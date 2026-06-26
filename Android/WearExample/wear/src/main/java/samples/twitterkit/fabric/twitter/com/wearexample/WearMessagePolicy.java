package samples.twitterkit.fabric.twitter.com.wearexample;

import java.nio.ByteBuffer;
import java.nio.charset.CharacterCodingException;
import java.nio.charset.Charset;
import java.nio.charset.CharsetDecoder;
import java.nio.charset.CodingErrorAction;

final class WearMessagePolicy {
    private static final Charset UTF_8 = Charset.forName("UTF-8");
    private static final int MAX_TWEET_PAYLOAD_BYTES = 1024;
    private static final int FLAG_UPDATE_CURRENT = 0x08000000;
    private static final int FLAG_IMMUTABLE = 0x04000000;

    private WearMessagePolicy() {
    }

    static String decodeTweetPayload(byte[] messageData) {
        if (messageData == null || messageData.length == 0 ||
                messageData.length > MAX_TWEET_PAYLOAD_BYTES) {
            return null;
        }

        CharsetDecoder decoder = UTF_8.newDecoder()
                .onMalformedInput(CodingErrorAction.REPORT)
                .onUnmappableCharacter(CodingErrorAction.REPORT);
        final String decoded;
        try {
            decoded = decoder.decode(ByteBuffer.wrap(messageData)).toString();
        } catch (CharacterCodingException exception) {
            return null;
        }

        String normalized = trimUnicodeWhitespace(decoded);
        if (normalized.length() == 0 || containsUnsupportedControlCharacter(normalized)
                || containsBidiControlCharacter(normalized)) {
            return null;
        }
        return normalized;
    }

    static int pendingIntentFlags(int sdkInt) {
        if (sdkInt >= 23) {
            return FLAG_UPDATE_CURRENT | FLAG_IMMUTABLE;
        }
        return FLAG_UPDATE_CURRENT;
    }

    private static String trimUnicodeWhitespace(String value) {
        int start = 0;
        int end = value.length();
        while (start < end && isWhitespace(value.charAt(start))) {
            start++;
        }
        while (end > start && isWhitespace(value.charAt(end - 1))) {
            end--;
        }
        return value.substring(start, end);
    }

    private static boolean isWhitespace(char value) {
        return Character.isWhitespace(value) || Character.isSpaceChar(value);
    }

    private static boolean containsUnsupportedControlCharacter(String value) {
        for (int index = 0; index < value.length(); index++) {
            char character = value.charAt(index);
            if (Character.isISOControl(character) &&
                    character != '\n' && character != '\r' && character != '\t') {
                return true;
            }
        }
        return false;
    }

    private static boolean containsBidiControlCharacter(String value) {
        for (int index = 0; index < value.length();) {
            int codePoint = value.codePointAt(index);
            if (codePoint == 0x061C
                    || (codePoint >= 0x200E && codePoint <= 0x200F)
                    || (codePoint >= 0x202A && codePoint <= 0x202E)
                    || (codePoint >= 0x2066 && codePoint <= 0x2069)) {
                return true;
            }
            index += Character.charCount(codePoint);
        }
        return false;
    }
}
