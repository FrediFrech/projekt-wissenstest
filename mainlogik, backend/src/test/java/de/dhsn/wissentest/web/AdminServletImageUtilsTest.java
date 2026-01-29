/*
 * Datei: AdminServletImageUtilsTest.java
 * Tests für Bild-Upload-Helper (Dateiendung + Content-Type).
 */
package de.dhsn.wissentest.web;

import org.junit.jupiter.api.Test;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.Comparator;

import static org.junit.jupiter.api.Assertions.*;

class AdminServletImageUtilsTest {

    @Test
    void isImageFileRecognizesCommonExtensions() throws Exception {
        Path dir = Files.createTempDirectory("imgtest");
        try {
            assertTrue(ImageUploadUtils.isImageFile(dir.resolve("a.png")));
            assertTrue(ImageUploadUtils.isImageFile(dir.resolve("a.jpg")));
            assertTrue(ImageUploadUtils.isImageFile(dir.resolve("a.jpeg")));
            assertTrue(ImageUploadUtils.isImageFile(dir.resolve("a.gif")));
            assertTrue(ImageUploadUtils.isImageFile(dir.resolve("a.webp")));
            assertTrue(ImageUploadUtils.isImageFile(dir.resolve("a.bmp")));
            assertTrue(ImageUploadUtils.isImageFile(dir.resolve("a.svg")));
            assertFalse(ImageUploadUtils.isImageFile(dir.resolve("a.txt")));
        } finally {
            deleteTree(dir);
        }
    }

    @Test
    void guessContentTypeFallsBackToExtension() throws Exception {
        Path dir = Files.createTempDirectory("imgtype");
        try {
            Path png = Files.createTempFile(dir, "img", ".png");
            String pngType = ImageUploadUtils.guessContentType(png);
            assertEquals("image/png", pngType);

            Path svg = Files.createTempFile(dir, "img", ".svg");
            String svgType = ImageUploadUtils.guessContentType(svg);
            assertEquals("image/svg+xml", svgType);

            Path txt = Files.createTempFile(dir, "doc", ".txt");
            String txtType = ImageUploadUtils.guessContentType(txt);
            assertNull(txtType);
        } finally {
            deleteTree(dir);
        }
    }

    private static void deleteTree(Path dir) throws IOException {
        if (dir == null || !Files.exists(dir)) {
            return;
        }
        Files.walk(dir)
                .sorted(Comparator.reverseOrder())
                .forEach(p -> {
                    try {
                        Files.deleteIfExists(p);
                    } catch (IOException ignored) {
                    }
                });
    }
}
