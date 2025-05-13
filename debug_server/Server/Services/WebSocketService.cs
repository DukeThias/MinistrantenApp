using System.Net.WebSockets;
using System.Text;
using System.Text.Json;
using Server.Models;

namespace Server.Services
{
    public class WebSocketService
    {
        private readonly Dictionary<string, WebSocket> _connections = new();

        // Verbindung hinzufügen
        public void AddConnection(string id, WebSocket socket)
        {
            _connections[id] = socket;
        }

        // Verbindung entfernen
        public void RemoveConnection(string id)
        {
            if (_connections.ContainsKey(id))
            {
                _connections[id].Abort();
                _connections.Remove(id);
            }
        }

        // Nachricht an eine Verbindung senden
        public async Task SendMessageAsync(string id, string art, string inhalt)
        {
            if (_connections.ContainsKey(id))
            {
                var socket = _connections[id];
                if (socket.State == WebSocketState.Open)
                {
                    var antwort = new Nachrichten
                    {
                        art = art,
                        inhalt = inhalt,
                        timestamp = DateTime.UtcNow
                    };
                    var antwortJson = JsonSerializer.Serialize(antwort);
                    var buffer = Encoding.UTF8.GetBytes(antwortJson);
                    await socket.SendAsync(new ArraySegment<byte>(buffer), WebSocketMessageType.Text, true, CancellationToken.None);
                }
            }
        }

        // Nachricht an alle Verbindungen senden
        public async Task BroadcastMessageAsync(string art, string inhalt)
{
    var nachricht = new Nachrichten
    {
        art = art,
        inhalt = inhalt,
        timestamp = DateTime.UtcNow
    };

    var json = JsonSerializer.Serialize(nachricht);
    var buffer = Encoding.UTF8.GetBytes(json);

    foreach (var connection in _connections.Values)
    {
        if (connection.State == WebSocketState.Open)
        {
            await connection.SendAsync(
                new ArraySegment<byte>(buffer),
                WebSocketMessageType.Text,
                true,
                CancellationToken.None
            );
        }
    }
}
    }}