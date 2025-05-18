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
            GemeindenService gemeindenService)
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
                            List<Ministranten> ministranten = await ministrantenService.GetAllMinistrantenAsync();
                            await service.SendMessageAsync(id, "authentifizierung", "true");
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
                                var chatMessage = JsonSerializer.Deserialize<ChatMessage>(empfangen.inhalt);
                                // Hier ggf. chatMessage speichern, z.B. mit eigenem ChatService
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