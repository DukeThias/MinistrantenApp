using Microsoft.EntityFrameworkCore;
using Server.Data; // Für AppDbContext
using Server.Services; // Für die Models
using System.Net.WebSockets;
using System.Text.Json;
using System.Text;
using Server.Extensions;
using Server.Models;  

var builder = WebApplication.CreateBuilder(args);

Dictionary<string, WebSocket> _connections = new Dictionary<string, WebSocket>();

// Services registrieren
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddScoped<DatabaseService>();
builder.Services.AddSingleton<WebSocketService>();
builder.Services.AddSwaggerGen();
builder.Services.AddDbContext<AppDbContext>(options =>
    options.UseSqlite("Data Source=datenbank.db")
           .EnableSensitiveDataLogging()
           .LogTo(Console.WriteLine));

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
            var webSocket = await context.WebSockets.AcceptWebSocketAsync();
            var id = Guid.NewGuid().ToString();

            var webSocketService = context.RequestServices.GetRequiredService<WebSocketService>();
            webSocketService.AddConnection(id, webSocket);

            Console.WriteLine($"Neue WebSocket-Verbindung: {id}");
            webSocketService.SendMessageAsync(id, "handshake", "Wenn du das liest, funktioniert irgendwas nicht...").Wait();
            await EchoLoop(id, webSocket, webSocketService);

            webSocketService.RemoveConnection(id);
            Console.WriteLine($"WebSocket-Verbindung geschlossen: {id}");
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

app.Run();

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
                    if (empfangen.inhalt == "gemeinden"){
                        service.SendMessageAsync(id, "gemeinden", //gemeinden logik);
                    }

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
