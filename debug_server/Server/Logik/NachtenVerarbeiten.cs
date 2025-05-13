using System.Net.WebSockets;
using System.Text;
using System.Text.Json;
using Server.Services;
using Server.Models;
using Server.Data;



namespace Server.Logik
{
    public static class NachrichtenVerarbeiten
    {
        public
static async Task EchoLoop(string id, WebSocket socket, WebSocketService service, DatabaseService dbs)
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
                            List<Ministranten> ministranten = await dbs.GetAllMinistrantenAsync();
                            await service.SendMessageAsync(id, "authentifizierung", "true");
                            break;

                        case "anfrage":
                            Console.WriteLine("Anfrage empfangen: " + empfangen.inhalt);
                            if (empfangen.inhalt == "gemeinden")
                            {
                                Console.WriteLine("Sende Gemeinden");
                                var gemeinden = (await dbs.GetAllGemeindenAsync()).Select(g => g.Name).ToList();
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

        private static void _CaseBroadcast(Nachrichten empfangen)
        {
            Console.WriteLine("Broadcast empfangen: " + empfangen.inhalt);
            // Additional logic for "broadcast" case
        }

        private static void _CasePing(Nachrichten empfangen)
        {
            Console.WriteLine("Ping empfangen: " + empfangen.inhalt);
            // Additional logic for "ping" case
        }

        private static void _CaseDefault(Nachrichten empfangen)
        {
            Console.WriteLine("Unbekannter Nachrichtentyp empfangen: " + empfangen.inhalt);
            // Additional logic for default case
        }
        }
}