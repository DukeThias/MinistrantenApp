import json
from datetime import datetime

# Datei mit json öffnen
with open('events.json', 'r', encoding='utf-8') as f:
    data = json.load(f)

def latex_escape(text):
    """Ein paar Spezialzeichen für LaTeX escapen."""
    text = text.replace('&', '\\&').replace('%', '\\%').replace('_', '\\_')
    text = text.replace('#', '\\#').replace('$', '\\$').replace('{', '\\{').replace('}', '\\}')
    return text

def latex_checkbox_name(name):
    return r"\fbox{\rule{0pt}{1.5ex}\rule{1.5ex}{0pt}} " + latex_escape(name)

with open('table.tex', 'w', encoding='utf-8') as f:
    f.write(r"""\begin{tabular}{l l l l p{5.5cm}}
\textbf{Datum} & \textbf{Uhrzeit} & \textbf{Name} & \textbf{Ort} & \textbf{Teilnehmer} \\ \hline
""")

    for event in data:
        # Nur zulassen, wenn isGottesdienst existiert und True ist
        if not event.get("isGottesdienst", False):
            continue

        # Start: Datum und Uhrzeit extrahieren
        zeit = datetime.fromisoformat(event["start"])
        datum_str = zeit.strftime("%d.%m.%Y")
        uhrzeit_str = zeit.strftime("%H:%M")
        name = latex_escape(event["name"])
        ort = latex_escape(event["ort"])
        # Teilnehmer als Liste
        teilnehmer_liste = event.get("teilnehmer", [])
        # Falls es einzelne Namen sind (Fehlformatierung, Sicherheitscheck)
        if isinstance(teilnehmer_liste, str):
            teilnehmer_liste = [teilnehmer_liste]
        teilnehmer_text = r"\\ ".join(latex_checkbox_name(t) for t in teilnehmer_liste) if teilnehmer_liste else ""

        # Tabellenzeile schreiben
        zeile = f"{datum_str} & {uhrzeit_str} & {name} & {ort} & {teilnehmer_text} \\\\\n"
        f.write(zeile)

    f.write(r"\end{tabular}" + "\n")

print("LaTeX-Tabelle wurde als table.tex gespeichert.")