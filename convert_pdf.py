import os
import PyPDF2

def convert_pdf_to_txt(pdf_path, txt_path):
    try:
        # Absicherung für Pfade
        if not os.path.exists(pdf_path):
            print(f"Fehler: PDF nicht gefunden unter: {pdf_path}")
            # Versuche relativen Pfad vom Workspace root
            pdf_path = os.path.join(os.getcwd(), "Doku", "SP Systementwurf Projektarbeit 24WI.pdf")
            if not os.path.exists(pdf_path):
                print(f"Fehler: PDF auch nicht gefunden unter: {pdf_path}")
                return

        print(f"Lese PDF von: {pdf_path}")
        
        with open(pdf_path, 'rb') as pdf_file:
            pdf_reader = PyPDF2.PdfReader(pdf_file)
            text_content = []
            
            num_pages = len(pdf_reader.pages)
            print(f"Anzahl Seiten: {num_pages}")

            for page_num in range(num_pages):
                page = pdf_reader.pages[page_num]
                text = page.extract_text()
                if text:
                    text_content.append(f"--- Seite {page_num + 1} ---\n{text}")
            
            full_text = "\n".join(text_content)
            
            with open(txt_path, 'w', encoding='utf-8') as txt_file:
                txt_file.write(full_text)
            
            print(f"Erfolgreich konvertiert und gespeichert unter: {txt_path}")
            
    except Exception as e:
        print(f"Ein Fehler ist aufgetreten: {e}")

if __name__ == "__main__":
    # Wir nehmen an, wir sind im Workspace Root oder Frontend Ordner, suchen das PDF im 'Doku' Ordner
    # Der Workspace ist c:\Users\Micro\Projekt Wissenstest\projekt-wissenstest
    
    # Pfad zur PDF
    possible_paths = [
        r"c:\Users\Micro\Projekt Wissenstest\projekt-wissenstest\Doku\SP Systementwurf Projektarbeit 24WI.pdf"
    ]
    
    pdf_file_path = None
    for p in possible_paths:
        if os.path.exists(p):
            pdf_file_path = p
            break
            
    if not pdf_file_path:
        # Fallback: Suche rekursiv vom Root
        # Da wir den absoluten Pfad kennen, nutzen wir diesen als Fallback, falls das Skript woanders liegt
        target = r"c:\Users\Micro\Projekt Wissenstest\projekt-wissenstest\Doku\SP Systementwurf Projektarbeit 24WI.pdf"
        if os.path.exists(target):
           pdf_file_path = target

    if pdf_file_path:
        output_path = os.path.join(os.path.dirname(pdf_file_path), "SP_Systementwurf_Projektarbeit_24WI.txt")
        convert_pdf_to_txt(pdf_file_path, output_path)
    else:
        print("Konnte die PDF Datei nicht finden.")
