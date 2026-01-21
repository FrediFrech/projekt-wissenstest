# JSP/JSF Compliance Analyse

## Anforderung aus dem Systementwurf
> "... eine Webanwendung **mit Java (Servlets, JSP oder JSF)** ..." + DB + mind. 1 JUnit‑Test. Weitere Technologien (AJAX/REST/HTML5) sind optional.

## Kurzfazit
**Die JSP‑Anforderung ist erfüllt.**

Warum? Es gibt echte JSP‑Seiten im Backend:
- [mainlogik, backend/src/main/webapp/index.jsp](../mainlogik,%20backend/src/main/webapp/index.jsp) als Startseite
- [mainlogik, backend/src/main/webapp/native.jsp](../mainlogik,%20backend/src/main/webapp/native.jsp) als Router
- Mehrere JSP‑Komponenten unter `jsp_native/`

Damit wird HTML serverseitig durch JSP erzeugt, wie gefordert.

---

## Pflichtpunkte (Abgleich)
1. **Java** ✅ (JDK 17)
2. **Servlets** ✅ (`AuthServlet`, `TestServlet`, `AdminServlet`)
3. **JSP oder JSF** ✅ (JSP vorhanden und aktiv genutzt)
4. **Server‑Datenbank** ✅ (PostgreSQL + JDBC)
5. **JUnit Test** ✅ (ProgressionServiceTest vorhanden)

---

## Optionales (was wir nutzen)
- **REST/JSON:** Backend‑API für AJAX
- **HTML5/CSS3:** Frontend‑Darstellung
- **AJAX/Fetch:** Requests aus `js_native/app.js`

---

## Risiko‑Check
**Kein Risiko durch fehlendes JSP.** Die JSP‑Seiten sind fester Bestandteil der App.

---

## Was du beim Prüfer zeigen kannst
1. JSP‑Einstieg über `index.jsp`
2. JSP‑Routing über `native.jsp` (`?page=...`)
3. Servlets + JDBC + DB‑Schema
4. JUnit‑Test im Backend

Damit ist die Anforderung sauber erfüllt.
