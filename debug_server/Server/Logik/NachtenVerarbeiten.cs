using System.Net.WebSockets;
using System.Text;
using System.Text.Json;
using Server.Services;
using Server.Models;

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
            NachrichtenService nachrichtenService)
        {
            var buffer = new byte[1024 * 4];
            while (socket.State == WebSocketState.Open)
            {
                var result = await socket.ReceiveAsync(new ArraySegment<byte>(buffer), CancellationToken.None);
                var jsonString = Encoding.UTF8.GetString(buffer, 0, result.Count);

                Console.WriteLine($"[{id}] empfangen: {jsonString}");

                try
                {
                    var empfangen = JsonSerializer.Deserialize<Nachrichten>(jsonString);
                    if (empfangen == null)
                    {
                        Console.WriteLine("Ungültiges JSON erhalten.");
                        continue;
                    }

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
                                if (ministrant.Rolle.Contains("Ministrant"))
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
                            Console.WriteLine("Unbekannter Nachrichtentyp");
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

