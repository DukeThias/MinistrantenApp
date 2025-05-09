using Microsoft.AspNetCore.Builder;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection; 
using Microsoft.Extensions.Hosting;
using System.Net.WebSockets;
using System.Text;
using System.Text.Json;
using YourNamespace;

var builder = WebApplication.CreateBuilder(args);

Dictionary<string, WebSocket> _connections = new Dictionary<string, WebSocket>();

// Services registrieren
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();
builder.Services.AddDbContext<AppDbContext>(options =>
    options.UseSqlite("Data Source=datenbank.db"));

var app = builder.Build();

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

app.Run();

// WebSocket-Kommunikationsmethode
// BITTE LESEN LUKAS !!!!!!!!! aösldkfjLIEHFOIÖAHEFLKJASLDFJALÖKDSJFLIAHÖVOIHALKSDHFHIADSFJALSKJDFKASJDÖFKJAS
// hier in der funktion werden nutzer separat gehalten. also hier muss man nix mehr angeben, wenn mehrere Nutzer angemeldet sind, startet das programm diese funktion mehrmals parallel
// und die id bestimmt einzelne geräte (noch nix mit authentifikation)
static async Task EchoLoop(string id, WebSocket socket)
{
    var buffer = new byte[1024 * 4];
    while (socket.State == WebSocketState.Open)
    {
        var result = await socket.ReceiveAsync(new ArraySegment<byte>(buffer), CancellationToken.None);
        var message = Encoding.UTF8.GetString(buffer, 0, result.Count);
        Console.WriteLine($"[{id}]Von Flutter empfangen: {message}");
        
    }
}

async void SendMessageToUser (string id, string typ, string nachricht, WebSocket socket){
    var nachrichtjson = JsonSerializer.Serialize(new { typ = typ, nachricht = nachricht , zeit = DateTime.UtcNow}); 
    await socket.SendAsync(new ArraySegment<byte>(Encoding.UTF8.GetBytes(nachrichtjson)), WebSocketMessageType.Text, true, CancellationToken.None);
}