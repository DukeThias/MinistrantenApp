using System.Text.RegularExpressions;
using AngleSharp;
using Server.Models;


namespace Server.Services.DatabaseAktionen
{
    /// <summary>
    /// Service zum Parsen von Ministranten-HTML-Plänen in Termin-Objekte.
    /// </summary>
    public class MiniplanParserServices
    {
        private readonly MinistrantenService _ministrantenService;
        private readonly int _gemeindeId;

        /// <summary>
        /// Konstruktor mit Dienst und Gemeinde-ID.
        /// </summary>
        public MiniplanParserServices(MinistrantenService ministrantenService, int gemeindeId)
        {
            _ministrantenService = ministrantenService;
            _gemeindeId = gemeindeId;
        }

        /// <summary>
        /// Parst eine HTML-Datei mit Ministrantenplan und gibt eine Liste von Terminen zurück.
        /// </summary>
        public async Task<List<Termin>> ParseHtmlToTermineAsync(string html)
        {
            // HTML-Dokument parsen
            var config = Configuration.Default;
            var context = BrowsingContext.New(config);
            var document = await context.OpenAsync(req => req.Content(html));
            var rows = document.QuerySelectorAll("table tr");

            // Alle Ministranten der Gemeinde abrufen
            var ministranten = await _ministrantenService.SearchMinistrantenAsync(gemeindeId: _gemeindeId);

            var termine = new List<Termin>();
            Termin? aktuellerTermin = null;
            string? letzteRolle = null;

            foreach (var row in rows)
            {
                var cells = row.Children;
                // Leere, "leere" oder reine Trenn-/Info-Zeilen überspringen
                if (cells.Length == 0 || row.TextContent.Trim() == "") continue;
                // Reihen mit nur einer Zelle und colspan sind in der Regel nur Trenner oder Infos, keine echten Daten
                if (cells.Length == 1 && cells[0].HasAttribute("colspan")) continue;

                // Kopfzeile: neuer Termin beginnt
                if (cells[0].ClassName == "phead")
                {
                    var headerText = cells[0].TextContent;
                    var parts = headerText.Split(',');
                    var datetimePart = parts[0].Trim(); // z. B. "So. 01.06.2025 09:00"
                    var ort = parts.Length > 1 ? parts[1].Trim() : "";
                    // Datum + Uhrzeit extrahieren
                    var dateMatch = Regex.Match(datetimePart, @"(\d{2})\.(\d{2})\.(\d{4}) (\d{2}):(\d{2})");
                    if (!dateMatch.Success) continue; // Ungültiges Format überspringen
                    var start = new DateTime(
                        int.Parse(dateMatch.Groups[3].Value),
                        int.Parse(dateMatch.Groups[2].Value),
                        int.Parse(dateMatch.Groups[1].Value),
                        int.Parse(dateMatch.Groups[4].Value),
                        int.Parse(dateMatch.Groups[5].Value),
                        0
                    );
                    // z. B. "(Sonntag 9:00)" → "Sonntag 9:00"
                    var name = headerText.Contains("(") && headerText.Contains(")")
                        ? headerText.Split('(', ')')[1].Trim()
                        : "";
                    aktuellerTermin = new Termin
                    {
                        Id = 0,
                        Name = name,
                        Beschreibung = "Ministrantenplan",
                        Ort = ort,
                        Start = start,
                        alle = false,
                        Teilnehmer = new List<TeilnehmerInfo>(),
                        GemeindeID = _gemeindeId
                    };
                    termine.Add(aktuellerTermin);
                    letzteRolle = null;
                }
                // Weitere Teilnehmer zum aktuellen Termin hinzufügen
                else if (aktuellerTermin != null)
                {
                    // Rolle wie "Normal", "Gabenbereitung", etc.
                    string rolle = letzteRolle ?? "";
                    if (cells.Length > 1 && cells[1].ClassName == "pdienst")
                    {
                        rolle = cells[1].TextContent.Trim();
                        letzteRolle = rolle;
                    }
                    // Teilnehmer ab Spalte 2
                    for (int i = 2; i < cells.Length; i++)
                    {
                        var name = cells[i].TextContent.Trim();
                        if (string.IsNullOrEmpty(name)) continue;
                        var nameParts = name.Split(' ', StringSplitOptions.RemoveEmptyEntries);
                        if (nameParts.Length < 2) continue;
                        var vorname = nameParts[0];
                        var nachname = string.Join(" ", nameParts.Skip(1));
                        var ministrant = ministranten
                            .FirstOrDefault(m => m.Vorname == vorname && m.Name == nachname);
                        if (ministrant != null)
                        {
                            aktuellerTermin.Teilnehmer.Add(new TeilnehmerInfo
                            {
                                ministrantId = ministrant.Id,
                                rolle = rolle
                            });
                        }
                        else
                        {
                            Console.WriteLine($"WARNUNG: {vorname} {nachname} nicht gefunden.");
                        }
                    }
                }
            }

            return termine;
        }
    }
}
