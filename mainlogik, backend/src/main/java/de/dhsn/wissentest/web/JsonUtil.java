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
import com.google.gson.JsonDeserializer;
import com.google.gson.JsonPrimitive;
import com.google.gson.JsonSerializer;
import java.time.OffsetDateTime;
import java.time.format.DateTimeFormatter;

public final class JsonUtil {
    private static final Gson GSON = new GsonBuilder()
            .registerTypeAdapter(OffsetDateTime.class, (JsonSerializer<OffsetDateTime>) (src, typeOfSrc, context) ->
                    new JsonPrimitive(src.format(DateTimeFormatter.ISO_OFFSET_DATE_TIME)))
            .registerTypeAdapter(OffsetDateTime.class, (JsonDeserializer<OffsetDateTime>) (json, typeOfT, context) ->
                    OffsetDateTime.parse(json.getAsString(), DateTimeFormatter.ISO_OFFSET_DATE_TIME))
            .create();

    private JsonUtil() {
    }

    public static Gson gson() {
        return GSON;
    }
}
