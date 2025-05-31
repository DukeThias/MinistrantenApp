using System.Net.WebSockets;
using System.Text;
using System.Text.Json;
using Server.Services;
using Server.Models;
using Server.Services.DatabaseAktionen;

namespace Server.Logik
{

    public static class NachrichtenVerarbeiten
    {

        public static async Task EchoLoop(
            string id,
            WebSocket socket,
            WebSocketService service,
            MinistrantenService ministrantenService,
            GemeindenService gemeindenService,
            TermineService termineService,
            NachrichtenService nachrichtenService,
            TauschService tauschService // <--- HINZUFÜGEN
        )
        {
            var buffer = new byte[1024 * 4];
            while (socket.State == WebSocketState.Open)
            {

                var messageBuffer = new ArraySegment<byte>(new byte[1024 * 4]);
                var ms = new MemoryStream();

                WebSocketReceiveResult result;

                do
                {
                    result = await socket.ReceiveAsync(messageBuffer, CancellationToken.None);
                    ms.Write(messageBuffer.Array!, messageBuffer.Offset, result.Count);
                } while (!result.EndOfMessage);

                ms.Seek(0, SeekOrigin.Begin);
                var jsonString = Encoding.UTF8.GetString(ms.ToArray());

                Console.WriteLine($"[{id}] empfangen: {jsonString}");

                try
                {
                    var empfangen = JsonSerializer.Deserialize<Nachrichten>(jsonString);

                    if (empfangen == null)
                    {
                        Console.WriteLine("Ungültiges JSON erhalten.");
                        continue;
                    }
                    Console.WriteLine("empfangen.art: " + empfangen.art);
                    switch (empfangen.art?.ToLower())
                    {
                        case "anmeldung":

                            Console.WriteLine("Anmeldung empfangen: " + empfangen.inhalt);

                            var anmeldedaten = JsonSerializer.Deserialize<Ministranten>(empfangen.inhalt!);

                            List<Ministranten> ministranten = await ministrantenService.GetAllMinistrantenAsync();

                            var ministrant = ministranten.FirstOrDefault(m => m.Username == anmeldedaten!.Username);

                            if (ministrant == null)
                            {
                                Console.WriteLine("Account existiert nicht.");
                                await service.SendMessageAsync(id, "authentifizierung", JsonSerializer.Serialize(new { success = false, message = "Account existiert nicht." }));
                                continue;
                            }
                            else if (ministrant.Passwort == anmeldedaten!.Passwort)
                            {
                                await service.SendMessageAsync(id, "authentifizierung", JsonSerializer.Serialize(new { success = true, message = "Anmeldung erfolgreich.", person = ministrant }));
                                //Nach Authentifizierung:
                                if (ministrant.Rolle.Contains("ministrant"))
                                {
                                    var termine = termineService.GetAllTermineAsync().Result;

                                    service.SendMessageAsync(id, "termine", Termin.TermineToJsonString(termine.Where(m => m.GemeindeID == ministrant.GemeindeID).ToList())).Wait();

                                    ministranten = await ministrantenService.GetAllMinistrantenAsync();

                                    var ministrantenGefiltert = ministranten
                                        .Where(m => m.GemeindeID == ministrant.GemeindeID)
                                        .Select(m => new
                                        {
                                            m.Id,
                                            m.Vorname,
                                            m.Name,
                                            m.Username,
                                            m.GemeindeID,
                                            m.GruppenID,
                                            m.Rolle
                                        })

                                        .ToList();

                                    await service.SendMessageAsync(id, "ministranten", System.Text.Json.JsonSerializer.Serialize(ministrantenGefiltert));

                                    var gemeinden = gemeindenService.GetAllGemeindenAsync().Result;
                                    service.SendMessageAsync(id, "gemeinden", JsonSerializer.Serialize(gemeinden)).Wait();

                                    var nachrichten = nachrichtenService.GetAllNachrichtenAsync().Result;
                                    service.SendMessageAsync(id, "nachrichten", JsonSerializer.Serialize(nachrichten.Where(m => m.gemeindeId == ministrant.GemeindeID).ToList())).Wait();
                                }
                            }

                            else
                            {
                                Console.WriteLine("Passwort falsch.");
                                await service.SendMessageAsync(id, "authentifizierung", JsonSerializer.Serialize(new { success = false, message = "Passwort falsch." }));
                                continue;
                            }
                            break;

                        case "html_plan_file":
                            Console.WriteLine("HTML-Plan-Datei empfangen");
                            try
                            {
                                var inhaltJson = JsonDocument.Parse(empfangen.inhalt!);
                                var root = inhaltJson.RootElement;

                                string contentBase64 = root.TryGetProperty("content", out var contentProp) ? contentProp.GetString() ?? "" : "";
                                string encoding = root.TryGetProperty("encoding", out var encProp) ? encProp.GetString() ?? "" : "";
                                string gemeindeIdStr = root.TryGetProperty("gemeindeID", out var gemeindeIdProp) ? gemeindeIdProp.GetString() ?? "0" : "0";

                                // Optional: Dateiname ist **nicht** enthalten – also:
                                string fileName = "Unbekannt"; // oder null lassen

                                Console.WriteLine($"Dateiname: {fileName}, Kodierung: {encoding}, GemeindeId: {gemeindeIdStr}");

                                if (encoding.ToLowerInvariant() == "base64")
                                {
                                    Console.WriteLine("Verarbeite Base64-kodierten Inhalt");
                                    byte[] fileBytes = Convert.FromBase64String(contentBase64);
                                    string htmlContent = Encoding.UTF8.GetString(fileBytes);

                                    int gemeindeId = int.Parse(gemeindeIdStr);
                                    var parser = new MiniplanParserServices(ministrantenService, gemeindeId);
                                    var neueTermine = await parser.ParseHtmlToTermineAsync(htmlContent);

                                    foreach (var neuerTermin in neueTermine)
                                    {
                                        // Verhindere Duplikate
                                        bool existiert = await termineService.ExistiertTerminAsync(neuerTermin.Name, neuerTermin.Start, neuerTermin.GemeindeID);

                                        if (!existiert)
                                        {
                                            await termineService.AddTerminAsync(neuerTermin);
                                        }
                                    }

                                    Console.WriteLine($"Importiert: {neueTermine.Count} Termine");
                                    await service.SendMessageAsync(id, "html_plan_file", JsonSerializer.Serialize(new { success = true, count = neueTermine.Count }));
                                }
                                else
                                {
                                    Console.WriteLine("Ungültige Kodierung: " + encoding);
                                    await service.SendMessageAsync(id, "html_plan_file", JsonSerializer.Serialize(new { success = false, message = "Ungültige Kodierung." }));
                                }


                            }
                            catch (JsonException e)
                            {
                                Console.WriteLine($"Fehler beim Verarbeiten der HTML-Plan-Datei: {e.Message}");
                                await service.SendMessageAsync(id, "html_plan_file", JsonSerializer.Serialize(new { success = false, message = "Ungültiges JSON." }));
                            }

                            Console.WriteLine("Sende geupdatete Termine an den Client.");
                            await service.BroadcastMessageAsync("termine", Termin.TermineToJsonString(await termineService.GetAllTermineAsync()));
                            break;

                        case "anfrage":
                            Console.WriteLine("Anfrage empfangen: " + empfangen.inhalt);
                            if (empfangen.inhalt == "gemeinden")
                            {
                                Console.WriteLine("Sende Gemeinden");
                                var gemeinden = (await gemeindenService.GetAllGemeindenAsync()).Select(g => g.Name).ToList();
                                var antwortjson = JsonSerializer.Serialize(gemeinden);
                                await service.SendMessageAsync(id, "gemeinden", antwortjson);
                            }
                            break;

                        case "broadcast":
                            await service.BroadcastMessageAsync("Info", empfangen.inhalt!);
                            break;



                        case "ping":
                            await service.SendMessageAsync(id, "pong", "Ja der Server lebt");
                            break;




                        case "tauscheninitialisieren": // alles klein!
                            Console.WriteLine("Tausch initialisieren empfangen: " + empfangen.inhalt);
                            if (empfangen.inhalt == null)
                            {
                                Console.WriteLine("Tausch initialisieren ohne Inhalt empfangen.");
                                continue;
                            }
                            else
                            {
                                try
                                {
                                    var tauschAnfrage = JsonSerializer.Deserialize<TauschAnfrage>(
                                        empfangen.inhalt,
                                        new JsonSerializerOptions { PropertyNameCaseInsensitive = true }
                                    );
                                    Console.WriteLine("tauschAnfrage: " + (tauschAnfrage == null ? "null" : "ok"));

                                    if (tauschAnfrage == null)
                                    {
                                        await service.SendMessageAsync(id, "tausch-fehler", "Ungültige Tauschdaten.");
                                        break;
                                    }

                                    // Anfrage speichern/verarbeiten (z.B. Service aufrufen)
                                    var neueAnfrage = await tauschService.StarteTauschAsync(tauschAnfrage);
                                    Console.WriteLine("StarteTauschAsync abgeschlossen");

                                    // Antwort an den Client schicken
                                    await service.SendMessageAsync(id, "tausch-erstellt", JsonSerializer.Serialize(neueAnfrage));
                                    Console.WriteLine("Antwort gesendet.");
                                }
                                catch (Exception ex)
                                {
                                    Console.WriteLine("Fehler beim Verarbeiten der Tausch-Anfrage: " + ex.Message);
                                    await service.SendMessageAsync(id, "tausch-fehler", "Fehler beim Verarbeiten der Tausch-Anfrage.");
                                }
                            }
                            break;


                        case "chatmessage":
                            if (empfangen.inhalt == null)
                            {
                                Console.WriteLine("Chat-Nachricht ohne Inhalt empfangen.");
                                continue;
                            }
                            else
                            {
                                Console.WriteLine("Chat-Nachricht empfangen: " + empfangen.inhalt);
                                // Hier war vorher die Verarbeitung von ChatMessage, jetzt entfernt
                            }
                            break;




                        default:
                            Console.WriteLine("Unbekannter Nachrichtentyp: " + empfangen.art);
                            break;
                    }
                }
                catch (JsonException e)
                {
                    Console.WriteLine($"Fehler beim Verarbeiten der Nachricht: {e.Message}");
                }
            }
        }
    }
}
