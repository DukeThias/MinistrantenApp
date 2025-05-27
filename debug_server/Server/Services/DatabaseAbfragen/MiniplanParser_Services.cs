using System.Text.RegularExpressions;
using AngleSharp;
using Server.Models;

namespace Server.Services.DatabaseAktionen
{
    public class MiniplanParserServices
    {
        private readonly MinistrantenService _ministrantenService;
        private readonly int _gemeindeId;

        public MiniplanParserServices(MinistrantenService ministrantenService, int gemeindeId)
        {
            _ministrantenService = ministrantenService;
            _gemeindeId = gemeindeId;
        }

        public async Task<List<Termin>> ParseHtmlToTermineAsync(string html)
        {
            var config = Configuration.Default;
            var context = BrowsingContext.New(config);
            var document = await context.OpenAsync(req => req.Content(html));
            var rows = document.QuerySelectorAll("table tr");

            var ministranten = await _ministrantenService.SearchMinistrantenAsync(gemeindeId: _gemeindeId);

            var termine = new List<Termin>();
            Termin? aktuellerTermin = null;
            string? aktuelleRolle = null;

            foreach (var row in rows)
            {
                var cells = row.Children;
                if (cells.Length == 0 || string.IsNullOrWhiteSpace(row.TextContent))
                    continue;

                bool istNeuerTermin = cells[0].ClassName == "phead";

                if (istNeuerTermin)
                {
                    var headerText = cells[0].TextContent;
                    var parts = headerText.Split(',');

                    var datetimePart = parts[0].Trim();
                    var ort = parts.Length > 1 ? parts[1].Trim() : "";

                    var dateMatch = Regex.Match(datetimePart, @"(\d{2})\.(\d{2})\.(\d{4}) (\d{2}):(\d{2})");

                    if (!dateMatch.Success) continue;

                    var start = new DateTime(
                        int.Parse(dateMatch.Groups[3].Value),
                        int.Parse(dateMatch.Groups[2].Value),
                        int.Parse(dateMatch.Groups[1].Value),
                        int.Parse(dateMatch.Groups[4].Value),
                        int.Parse(dateMatch.Groups[5].Value),
                        0
                    );

                    var name = headerText.Contains("(") ? headerText.Split('(', ')')[1].Trim() : "Unbenannt";

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
                }

                // Rolle aktualisieren, wenn vorhanden
                for (int i = 0; i < cells.Length; i++)
                {
                    if (cells[i].ClassName == "pdienst")
                    {
                        aktuelleRolle = cells[i].TextContent.Trim();
                        break;
                    }
                }

                // Teilnehmer zuordnen
                for (int i = 0; i < cells.Length; i++)
                {
                    if (cells[i].ClassName == "pdienst" || string.IsNullOrWhiteSpace(cells[i].TextContent))
                        continue;

                    var name = cells[i].TextContent.Trim();
                    var nameParts = name.Split(' ', StringSplitOptions.RemoveEmptyEntries);
                    if (nameParts.Length < 2)
                        continue;

                    var vorname = nameParts[0].Trim().ToLower();
                    var nachname = string.Join(" ", nameParts.Skip(1)).Trim().ToLower();

                    var ministrant = ministranten.FirstOrDefault(m =>
                        !string.IsNullOrEmpty(m.Vorname) &&
                        !string.IsNullOrEmpty(m.Name) &&
                        m.Vorname.Trim().ToLower() == vorname &&
                        m.Name.Trim().ToLower() == nachname);

                    if (ministrant != null && aktuellerTermin != null)
                    {
                        aktuellerTermin.Teilnehmer.Add(new TeilnehmerInfo
                        {
                            MinistrantId = ministrant.Id,
                            Rolle = aktuelleRolle ?? "Unbekannt"
                        });
                        Console.WriteLine($"✅ Zugeordnet: {vorname} {nachname} -> ID {ministrant.Id}, Rolle: {aktuelleRolle}");
                    }
                    else
                    {
                        Console.WriteLine($"⚠ NICHT GEFUNDEN: HTML = '{vorname} {nachname}' → Gemeinde: {_gemeindeId}");
                    }
                }
            }

            return termine;
        }
    }
}
