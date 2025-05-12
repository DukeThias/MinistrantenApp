using Microsoft.EntityFrameworkCore;
using Server.Data; // Für AppDbContext
using Server.Models; // Für die Models
using System.Net.WebSockets;
using System.Text;
using Server.Extensions;

var builder = WebApplication.CreateBuilder(args);

Dictionary<string, WebSocket> _connections = new Dictionary<string, WebSocket>();

// Services registrieren
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();
builder.Services.AddDbContext<AppDbContext>(options =>
    options.UseSqlite("Data Source=datenbank.db"));

var app = builder.Build(); // Muss nach der Service-Registrierung erfolgen

app.MapApiEndpoints(); // Registriert alle API-Endpunkte (z. B. /api/personen usw.)

// Swagger aktivieren im Development-Modus
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

// WebSocket-Unterstützung aktivieren
app.UseWebSockets();
app.Use(async (context, next) =>
{
    if (context.Request.Path == "/ws")
    {
        if (context.WebSockets.IsWebSocketRequest)
        {
            var id = context.Request.Query["id"].ToString();
            if (string.IsNullOrEmpty(id))
            {
                context.Response.StatusCode = 400;
                return;
            }

            if (_connections.ContainsKey(id))
            {
                context.Response.StatusCode = 400;
                Console.WriteLine($"WebSocket mit ID {id} bereits verbunden.");
                return;
            }

            using var webSocket = await context.WebSockets.AcceptWebSocketAsync();
            await EchoLoop(id, webSocket);
        }
        else
        {
            context.Response.StatusCode = 400;
        }
    }
    else
    {
        await next();
    }
});

// API-Basisendpunkt
app.MapGet("/", () => "Server läuft!");

app.Run();

// WebSocket-Kommunikationsmethode
static async Task EchoLoop(string id, WebSocket socket)
{
    var buffer = new byte[1024 * 4];
    while (socket.State == WebSocketState.Open)
    {
        var result = await socket.ReceiveAsync(new ArraySegment<byte>(buffer), CancellationToken.None);
        var message = Encoding.UTF8.GetString(buffer, 0, result.Count);
        Console.WriteLine($"[{id}] Von Flutter empfangen: {message}");

        try
        {
            // JSON-String in ein Dictionary deserialisieren
            var data = JsonSerializer.Deserialize<Dictionary<string, object>>(message);

            if (data != null && data.ContainsKey("art") && data.ContainsKey("inhalt"))
            {
                string? type = data["art"].ToString();
                string? inhalt = data["inhalt"].ToString();
                switch (type)
                {
                    case "lol":
                        Console.WriteLine("Aktion für 'lol' ausführen");
                        // Führe Aktion für "lol" aus
                        break;

                    case "ping":
                        Console.WriteLine("Aktion für 'ping' ausführen");
                        await SendMessageToUser(id, "antwort", "ping "+inhalt, socket);
                        break;

                    default:
                        Console.WriteLine($"Unbekannter Typ: {type}");
                        break;
                }
            }
            else
            {
                Console.WriteLine("Ungültige JSON-Daten oder 'type'-Feld fehlt.");
            }
        }
        catch (JsonException ex)
        {
            Console.WriteLine($"Fehler beim Verarbeiten der JSON-Daten: {ex.Message}");
        }
    }
}



static async Task SendMessageToUser(string id, string typ, string nachricht, WebSocket socket)
{
    Console.WriteLine("senden...");
    var nachrichtjson = JsonSerializer.Serialize(new { art = typ, inhalt = nachricht, timestamp = DateTime.UtcNow });
    Console.WriteLine(nachrichtjson);
    await socket.SendAsync(new ArraySegment<byte>(Encoding.UTF8.GetBytes(nachrichtjson)), WebSocketMessageType.Text, true, CancellationToken.None);
}

