using Microsoft.EntityFrameworkCore;
using Server.Data; // Für AppDbContext
using Server.Services; // Für die Models
using Server.Extensions;
using Server.Logik;

var builder = WebApplication.CreateBuilder(args);

//für handy
builder.WebHost.UseUrls("http://*:5205"); // Port 5000 für alle IP-Adressen

//Dictionary<string, WebSocket> _connections = new Dictionary<string, WebSocket>();

// Services registrieren
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSingleton<WebSocketService>();
builder.Services.AddScoped<TermineService>();
builder.Services.AddScoped<MinistrantenService>();
builder.Services.AddScoped<GemeindenService>();
builder.Services.AddScoped<NachrichtenService>();
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

            var termineService = context.RequestServices.GetRequiredService<TermineService>();
            var ministrantenService = context.RequestServices.GetRequiredService<MinistrantenService>();
            var gemeindenService = context.RequestServices.GetRequiredService<GemeindenService>();
            var nachrichtenService = context.RequestServices.GetRequiredService<NachrichtenService>();
            var webSocketService = context.RequestServices.GetRequiredService<WebSocketService>();

            webSocketService.AddConnection(id, webSocket);
            Console.WriteLine($"Neue WebSocket-Verbindung: {id}");

            _nachLogin(webSocketService, termineService, ministrantenService, gemeindenService, nachrichtenService, id);

            try
            {
                await NachrichtenVerarbeiten.EchoLoop(id, webSocket, webSocketService, ministrantenService, gemeindenService);
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Fehler beim Verarbeiten der WebSocket-Nachricht: {ex.Message}");
                webSocketService.RemoveConnection(id); // Entfernen der Verbindung im Fehlerfall
            }

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

void _nachLogin(
    WebSocketService webSocketService,
    TermineService termineService,
    MinistrantenService ministrantenService,
    GemeindenService gemeindenService,
    NachrichtenService nachrichtenService,
    string id)
{
    webSocketService.SendMessageAsync(id, "handshake", "Wenn du das liest, funktioniert irgendwas nicht...").Wait();

    var termine = termineService.GetAllTermineAsync().Result;
    webSocketService.SendMessageAsync(id, "termine", Server.Models.Termin.TermineToJsonString(termine)).Wait();

    var ministranten = ministrantenService.GetAllMinistrantenAsync().Result;
    webSocketService.SendMessageAsync(id, "ministranten", System.Text.Json.JsonSerializer.Serialize(ministranten)).Wait();

    var gemeinden = gemeindenService.GetAllGemeindenAsync().Result;
    webSocketService.SendMessageAsync(id, "gemeinden", System.Text.Json.JsonSerializer.Serialize(gemeinden)).Wait();

    var nachrichten = nachrichtenService.GetAllNachrichtenAsync().Result;
    webSocketService.SendMessageAsync(id, "nachrichten", System.Text.Json.JsonSerializer.Serialize(nachrichten)).Wait();
}