import java.lang.instrument.ClassFileTransformer;
import java.lang.instrument.Instrumentation;
import java.security.ProtectionDomain;
import java.nio.charset.StandardCharsets;

/*
 * JxBrowser 9 launches Chromium with its Linux sandbox enabled by default.
 * Inside Flatpak, Chromium cannot create the nested user namespace required
 * by that sandbox, causing Thinkorswim's Schwab OAuth login panel to fail.
 *
 * Thinkorswim's application JARs are signed, so modifying them on disk breaks
 * Java signer verification. This agent changes the existing Chromium switch
 * in memory as JXBrowserEngine is loaded, leaving Schwab's signed files intact.
 */
public final class NoSandboxAgent {
    private static final String TARGET =
        "com/devexperts/tos/ui/user/browser/JXBrowserEngine";

    private static final byte[] ORIGINAL =
        "--do-not-de-elevate".getBytes(StandardCharsets.UTF_8);

    private static final byte[] REPLACEMENT =
        "--no-sandbox".getBytes(StandardCharsets.UTF_8);

    public static void premain(String args, Instrumentation instrumentation) {
        System.err.println("[thinkorswim-flatpak] JxBrowser compatibility agent active");

        instrumentation.addTransformer(new ClassFileTransformer() {
            @Override
            public byte[] transform(
                    Module module,
                    ClassLoader loader,
                    String className,
                    Class<?> classBeingRedefined,
                    ProtectionDomain protectionDomain,
                    byte[] classfileBuffer) {

                if (!TARGET.equals(className)) {
                    return null;
                }

                int pos = find(classfileBuffer, ORIGINAL);

                if (pos < 2) {
                    System.err.println(
                        "[thinkorswim-flatpak] JXBrowserEngine layout changed; "
                        + "sandbox workaround was not applied.");
                    return null;
                }

                int originalLength =
                    ((classfileBuffer[pos - 2] & 0xff) << 8)
                    | (classfileBuffer[pos - 1] & 0xff);

                if (originalLength != ORIGINAL.length) {
                    System.err.println(
                        "[thinkorswim-flatpak] Unexpected class constant length; "
                        + "sandbox workaround was not applied.");
                    return null;
                }

                int shrink = ORIGINAL.length - REPLACEMENT.length;
                byte[] patched = new byte[classfileBuffer.length - shrink];

                int constantLengthPosition = pos - 2;

                System.arraycopy(
                    classfileBuffer, 0,
                    patched, 0,
                    constantLengthPosition);

                patched[constantLengthPosition] =
                    (byte)((REPLACEMENT.length >>> 8) & 0xff);
                patched[constantLengthPosition + 1] =
                    (byte)(REPLACEMENT.length & 0xff);

                System.arraycopy(
                    REPLACEMENT, 0,
                    patched, pos,
                    REPLACEMENT.length);

                System.arraycopy(
                    classfileBuffer,
                    pos + ORIGINAL.length,
                    patched,
                    pos + REPLACEMENT.length,
                    classfileBuffer.length - (pos + ORIGINAL.length));

                System.err.println(
                    "[thinkorswim-flatpak] Applied JxBrowser --no-sandbox workaround.");

                return patched;
            }
        });
    }

    private static int find(byte[] input, byte[] target) {
        outer:
        for (int i = 0; i <= input.length - target.length; i++) {
            for (int j = 0; j < target.length; j++) {
                if (input[i + j] != target[j]) {
                    continue outer;
                }
            }
            return i;
        }
        return -1;
    }
}
