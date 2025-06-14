using Microsoft.EntityFrameworkCore;
using Server.Data; // Für AppDbContext
using Server.Services; // Für die Models
using Server.Extensions;
using Server.Logik;

var builder = WebApplication.CreateBuilder(args);

//für handy
builder.WebHost.UseUrls("http://*:5205"); // Port 5000 für alle IP-Adressen


// Services registrieren
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSingleton<WebSocketService>();
builder.Services.AddScoped<TermineService>();
builder.Services.AddScoped<MinistrantenService>();
builder.Services.AddScoped<GemeindenService>();
builder.Services.AddScoped<NachrichtenService>();
builder.Services.AddScoped<TauschService>();
builder.Services.AddScoped<TauschLogikService>();
builder.Services.AddSwaggerGen();

builder.Services.AddDbContext<AppDbContext>(options =>
    options.UseSqlite("Data Source=datenbank.db")
           .EnableSensitiveDataLogging()
           // .LogTo(Console.WriteLine)
           );


var app = builder.Build(); // Muss nach der Service-Registrierung erfolgen
using (var scope = app.Services.CreateScope())
{
    var db = scope.ServiceProvider.GetRequiredService<AppDbContext>();
    db.Database.Migrate(); // Wendet alle Migrationen an und erstellt Datenbank bei Bedarf
}

using (var scope = app.Services.CreateScope())
{
    var db = scope.ServiceProvider.GetRequiredService<AppDbContext>();
    db.Database.EnsureCreated(); // Erstellt die DB, wenn sie fehlt
}

app.MapApiEndpoints(); // Registriert alle API-Endpunkte (z. B. /api/personen usw.)

// Entferne oder kommentiere die Zeile aus, wenn du Antiforgery nicht brauchst:
// app.UseAntiforgery(); // wichtig für .DisableAntiforgery() zu funktionieren

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
            var tauschService = context.RequestServices.GetRequiredService<TauschService>();

            webSocketService.AddConnection(id, webSocket);
            Console.WriteLine($"Neue WebSocket-Verbindung: {id}");
            webSocketService.SendMessageAsync(id, "handshake", "Wenn du das liest, funktioniert irgendwas nicht...").Wait();

            try
            {

                await NachrichtenVerarbeiten.EchoLoop(id, webSocket, webSocketService, ministrantenService, gemeindenService, termineService, nachrichtenService, tauschService);
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

app.Run();