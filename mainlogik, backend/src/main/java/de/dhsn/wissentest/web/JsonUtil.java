/*
 * Datei: JsonUtil.java
 * Diese Klasse stellt eine zentrale Gson-Instanz bereit, damit alle Servlets auf die gleiche
 * JSON-Serialisierung zugreifen. So vermeiden wir unterschiedliche Einstellungen oder doppelte
 * Konfigurationen.
 * Verbindung: Wird von ServletUtils und damit indirekt von allen Servlets genutzt.
 */
package de.dhsn.wissentest.web;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

public final class JsonUtil {
    private static final Gson GSON = new GsonBuilder().create();

    private JsonUtil() {
    }

    public static Gson gson() {
        return GSON;
    }
}
