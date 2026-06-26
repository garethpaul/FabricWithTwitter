package samples.twitterkit.fabric.twitter.com.wearexample;

import java.nio.charset.Charset;

public final class WearMessagePolicyTests {
    private static final Charset UTF_8 = Charset.forName("UTF-8");

    public static void main(String[] args) {
        expectText(" hello ", "hello", "ASCII whitespace");
        expectText("\u00a0hello\u2007", "hello", "Unicode space trimming");
        expectRejected(new byte[] {(byte) 0xc3, (byte) 0x28}, "malformed UTF-8");
        expectRejected("\u00a0\u2007".getBytes(UTF_8), "Unicode whitespace only");
        expectRejected("hello\u0000world".getBytes(UTF_8), "NUL control character");
        expectRejected("hello\u0085world".getBytes(UTF_8), "C1 control character");
        expectRejected("hello\u061cworld".getBytes(UTF_8), "Arabic letter mark");
        expectRejected("hello\u200eworld".getBytes(UTF_8), "left-to-right mark");
        expectRejected("hello\u202eworld".getBytes(UTF_8), "right-to-left override");
        expectRejected("hello\u2066world".getBytes(UTF_8), "left-to-right isolate");
        expectText("hello\u200dworld", "hello\u200dworld", "zero-width joiner");
        expectText("hello\nworld", "hello\nworld", "line break");

        int updateCurrent = 0x08000000;
        int immutable = 0x04000000;
        expectFlags(22, updateCurrent, "pre-Marshmallow flags");
        expectFlags(23, updateCurrent | immutable, "Marshmallow flags");
        expectFlags(35, updateCurrent | immutable, "modern flags");

        System.out.println("WearMessagePolicy behavioral tests passed");
    }

    private static void expectText(String input, String expected, String message) {
        String actual = WearMessagePolicy.decodeTweetPayload(input.getBytes(UTF_8));
        if (!expected.equals(actual)) {
            throw new AssertionError(message + ": expected normalized text");
        }
    }

    private static void expectRejected(byte[] input, String message) {
        if (WearMessagePolicy.decodeTweetPayload(input) != null) {
            throw new AssertionError(message + ": expected rejection");
        }
    }

    private static void expectFlags(int sdkInt, int expected, String message) {
        int actual = WearMessagePolicy.pendingIntentFlags(sdkInt);
        if (actual != expected) {
            throw new AssertionError(message + ": unexpected flags " + actual);
        }
    }
}
