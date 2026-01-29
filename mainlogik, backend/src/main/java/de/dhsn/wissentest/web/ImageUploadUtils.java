package de.dhsn.wissentest.web;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.Locale;

public final class ImageUploadUtils {
    private ImageUploadUtils() {
    }

    public static boolean isImageFile(Path file) {
        String name = file.getFileName().toString().toLowerCase(Locale.ROOT);
        return name.endsWith(".png") || name.endsWith(".jpg") || name.endsWith(".jpeg")
                || name.endsWith(".gif") || name.endsWith(".webp") || name.endsWith(".bmp")
                || name.endsWith(".svg");
    }

    public static String guessContentType(Path file) throws IOException {
        String contentType = Files.probeContentType(file);
        if (contentType != null && contentType.startsWith("image/")) {
            return contentType;
        }
        String name = file.getFileName().toString().toLowerCase(Locale.ROOT);
        if (name.endsWith(".png")) return "image/png";
        if (name.endsWith(".jpg") || name.endsWith(".jpeg")) return "image/jpeg";
        if (name.endsWith(".gif")) return "image/gif";
        if (name.endsWith(".webp")) return "image/webp";
        if (name.endsWith(".bmp")) return "image/bmp";
        if (name.endsWith(".svg")) return "image/svg+xml";
        return null;
    }
}
