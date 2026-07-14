# Upgrade management options for this multi-host repo

Written 2026-07-13, after disabling `system.autoUpgrade` everywhere. Context and
options for choosing an upgrade workflow. Nothing here is implemented yet.

## Background: why autoUpgrade was disabled

- autoUpgrade ran daily with `--update-input nixpkgs`, upgrading each host past
  the repo's committed `flake.lock` (the updated lock was only ever written to
  an ephemeral store copy, never back to the repo).
- Result: running systems drifted ahead of git. A later manual
  `nixos-rebuild switch` jumped *backwards* to the committed pin; on tux
  (2026-07-12/13) that large delta restarted the GNOME user units and tore down
  the live desktop session, twice.
- Without `--update-input`, the timer only rebuilds the already-running
  generation (`flake = inputs.self.outPath` is a frozen snapshot), so it was
  pointless and got disabled.
- **Current state: upgrades are fully manual** — `nix flake update` + commit +
  rebuild each host.

## The target pattern: two separate loops

The old setup conflated two jobs. Keep them separate:

1. **Loop 1 — advance the pin (CI):** a scheduled job runs `nix flake update`,
   validates every host against the new lock, and commits / opens a PR only if
   green.
2. **Loop 2 — converge hosts on the repo:** each machine periodically pulls the
   repo and rebuilds *exactly what's committed* (autoUpgrade pointed at
   `github:jordan-bravo/.nix` instead of a local snapshot).

CI decides *what* to run; hosts merely converge on it. Every running system is
always a commit that CI validated. Git is the single source of truth.

## Loop 1 decisions

### Tooling

- Standard: Determinate Systems' `update-flake-lock` GitHub Action on a weekly
  schedule, producing a PR.
- Validation job: build or eval each
  `nixosConfigurations.<host>.config.system.build.toplevel`.

### Eval-only vs. full build

| | Catches | Cost |
|---|---|---|
| `nix eval .#...toplevel.drvPath` | syntax, option, assertion errors | seconds, free runner OK |
| full `nix build` | + broken packages, failed compiles | 5 host closures exhaust a free GitHub runner (14 GB disk, 2 cores) |

Middle grounds: full-build one representative host + eval the rest; or a
**self-hosted runner** on ryz/sovserv (real disk, warm nix store, and CI-built
paths land in a store hosts could fetch from via harmonia/attic/cachix).
Starting point: eval-only. Note: neither catches runtime service failures —
only staged rollout + rollback covers those.

### Auto-commit vs. PR on green

- Auto-commit: fully hands-off, but updates land unwatched — the exact failure
  mode just debugged.
- PR with build status + `nvd diff` comment (package-level closure diff): a
  30-second weekly review, paper trail. Preferred, especially since finserv
  handles funds.

### The git-crypt problem (blocker for any GitHub-hosted CI)

Every host's eval currently requires git-crypt unlocked: finserv and punk
import `secrets.nix`; all workstations import `workstation-secrets.nix` via
`modules/home-manager/hm-workstation.nix`. Options, worst to best:

1. **Give CI the git-crypt key** (GitHub Actions secret). Works; means GitHub
   effectively holds the secrets in usable form. Not preferred.
2. **Stub the secrets at eval time** (`builtins.pathExists` guard or committed
   dummy file) so CI evals a secrets-less variant. Cheap; CI signal no longer
   covers the real configs.
3. **Migrate eval-time secrets to sops-nix** (already used on sovserv).
   Encrypted YAML is safe to commit and eval; decryption happens on the host at
   activation. git-crypt shrinks or disappears; CI needs zero secret access.
   Most work, cleanest end state.

A self-hosted runner also sidesteps this entirely: that machine can hold the
git-crypt key locally like any other trusted host.

## Loop 2 decisions: pull vs. push

### Pull (autoUpgrade against the remote)

- `system.autoUpgrade.flake = "git+ssh://git@github.com/jordan-bravo/.nix"`
  (or `github:` ref + PAT in `nix.settings.access-tokens`); each host needs a
  deploy key / token for the private repo.
- Zero-touch, per-host schedule. Hosts converge on merged commits only.
- Workstations use `operation = "boot"` (activate on next reboot — never tears
  down a live session; the override is still in nixos-workstation.nix,
  commented out).

### Push (deploy from one machine)

- deploy-rs (automatic rollback if activation fails or host unreachable),
  colmena, or a plain `for h; do nixos-rebuild switch --target-host $h; done`
  script from tux.
- Keeps a human in the loop per deploy; rollback story attractive for finserv.

These compose: pull for boring hosts, push for critical ones.

## Sketch of a concrete end state

1. **CI**: weekly `update-flake-lock` PR + eval of all hosts (stub secrets or
   sops-nix), `nvd diff` posted as PR comment. Merge from anywhere.
2. **sovserv, punk**: pull-based weekly `switch`, Saturday morning, from the
   GitHub flake ref.
3. **finserv**: stays manual, or push-deployed with deploy-rs for the rollback
   net.
4. **Workstations**: manual `git pull && nixos-rebuild boot` + reboot, or pull
   timer with `operation = "boot"`. Low urgency — they're used interactively.

Staged rollout as the runtime-failure net: a canary workstation runs a lock a
few days before the servers pick it up; finserv always last.

## Deep dive: self-hosted runner on sovserv

Evaluated 2026-07-13. Putting a GitHub Actions runner on sovserv resolves most
of the open questions at once.

### Problems it solves

1. **git-crypt blocker gone.** The runner is a process on owned hardware; the
   git-crypt key lives on sovserv's disk (provisioned via sops, already in use
   there). CI evals/builds the *real* configs — GitHub's cloud never holds a
   decryption key.
2. **Full builds feasible → stronger CI signal.** Free GitHub runners (2 cores,
   ~14 GB disk) can't build 5 NixOS closures; sovserv's persistent nix store
   can, and weekly runs only rebuild the delta. Catches "package fails to
   compile", not just "config fails to eval".
3. **Nix store doubles as a binary cache.** Everything CI validates is already
   in sovserv's store. Serve it (harmonia/nix-serve over tailscale + signing
   key; other hosts add it to `substituters`) and hosts download finished
   closures instead of rebuilding. sovserv's own upgrades become seconds-long
   activations.
4. **No GitHub Actions metering** (private-repo hosted minutes are capped on
   the free plan; nix builds devour them).
5. **Declarative runner**: `services.github-runners.<name>` with a sops-managed
   PAT `tokenFile` — the runner is just more config in this repo.

### What it doesn't solve / adds

- Runtime service failures still uncaught (CI proves it builds, not that it
  starts). Staged rollout + generation rollback remain the net.
- Workflow-defined shell executes on the Nextcloud/CouchDB server. Low risk on
  a single-committer private repo (fork PRs are the real danger); the NixOS
  module runs it as an unprivileged dynamic user — keep admin scopes off its
  PAT.
- CI availability coupled to sovserv uptime.
- Small ops tail: PAT rotation; runner updates ride nixpkgs bumps.

### Weekly upgrade process once in place

1. Scheduled workflow (Sat) on the sovserv runner: `update-flake-lock` bumps
   the lock, opens a PR.
2. Validation job: unlock git-crypt from local key, `nix build` every host's
   `toplevel` (warm store → minutes), post per-host `nvd diff` PR comments.
3. Review PR (green checks + skim diff), merge — from anywhere. A red build
   means "no upgrade this week", never "broken host"; machines keep the old pin.
4. Hosts converge on the merged commit:
   - **sovserv**: pull autoUpgrade from the `git+ssh` flake ref; closure
     already local, activation takes seconds.
   - **punk**: pull; fetches prebuilt closures from sovserv over tailscale.
   - **workstations**: pull timer with `operation = "boot"` or manual
     `git pull && nixos-rebuild boot`; downloads from sovserv's cache.
   - **finserv**: last and manual (or deploy-rs), days after the same lock has
     been live elsewhere.
5. Rollback = standard NixOS generations.

Optional extension: on-merge workflow job push-deploys sovserv/punk via
deploy-rs (auto-rollback on failed activation), collapsing step 4 for servers
into the merge click.

Net effect: hands-off upgrades like the old daily autoUpgrade pretended to be,
but every change is committed first, validated by full builds of the real
configs, human-approved, staged, and served from an owned cache.

## Open questions to settle before implementing

- Secrets approach for CI: stub vs. sops-nix migration vs. self-hosted runner?
- PR-review cadence acceptable, or is auto-merge-on-green wanted after trust is
  built?
- Binary cache worth it (CI builds once, hosts fetch) — cachix, attic, or
  harmonia on a LAN host?
- Does finserv get deploy-rs, or stay fully manual?
