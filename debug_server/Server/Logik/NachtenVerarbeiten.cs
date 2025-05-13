using System.Net.WebSockets;
using System.Text;
using System.Text.Json;
using Server.Services;
using Server.Models;

namespace Server.Logik
{
    public static class NachrichtenVerarbeiten
    {
        public
static async Task EchoLoop(string id, WebSocket socket, WebSocketService service)
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
                            
                            Console.WriteLine("Sende authentifizierung");
                            await service.SendMessageAsync(id, "authentifizierung", "true");
                            break;

                        case "anfrage":
                            if (empfangen.inhalt == "gemeinden")
                            {
                                Console.WriteLine("Sende Gemeinden");
                                var gemeinden = new List<string> { "Laupheim", "Biberach", "Ulm" };
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

        private static void _CaseAnmeldung()
        {
            // Logic for "anmeldung" case
        }

        private static void _CaseAnfrage()
        {
            // Logic for "anfrage" case
        }

        private static void _CaseBroadcast()
        {
            // Logic for "broadcast" case
        }

        private static void _CasePing()
        {
            // Logic for "ping" case
        }

        private static void _CaseDefault()
        {
            // Logic for default case
        }
    }
}