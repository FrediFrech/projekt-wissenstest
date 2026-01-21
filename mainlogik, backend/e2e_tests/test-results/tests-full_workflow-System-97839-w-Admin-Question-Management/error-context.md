# Page snapshot

```yaml
- generic [ref=e2]:
  - navigation [ref=e3]:
    - link "✨ UML Wissenstest" [ref=e4] [cursor=pointer]:
      - /url: "?page=landingPage"
      - generic [ref=e5]: ✨ UML Wissenstest
    - generic [ref=e6]:
      - link "Login" [ref=e7] [cursor=pointer]:
        - /url: "?page=login"
      - link "Registrieren" [ref=e8] [cursor=pointer]:
        - /url: "?page=register"
  - main [ref=e9]:
    - generic [ref=e10]:
      - heading "Willkommen zurück 👋" [level=2] [ref=e11]
      - generic [ref=e12]:
        - generic [ref=e13]:
          - text: Benutzername
          - textbox "Benutzername" [ref=e14]:
            - /placeholder: Dein Username
            - text: lehrer
        - generic [ref=e15]:
          - text: Passwort
          - textbox "Passwort" [ref=e16]:
            - /placeholder: ••••••••
            - text: student
        - button "Anmelden" [active] [ref=e17] [cursor=pointer]
      - paragraph [ref=e18]:
        - text: Noch kein Konto?
        - link "Hier registrieren" [ref=e19] [cursor=pointer]:
          - /url: "?page=register"
```