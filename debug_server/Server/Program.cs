using Microsoft.AspNetCore.Builder;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection; 
using Microsoft.Extensions.Hosting;
using System.Net.WebSockets;
using System.Text;
using YourNamespace; // Ersetze durch deinen tatsächlichen Namespace

var builder = WebApplication.CreateBuilder(args);

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

app.UseHttpsRedirection();

// WebSocket-Unterstützung aktivieren
app.UseWebSockets();
app.Use(async (context, next) =>
{
    if (context.Request.Path == "/ws")
    {
        if (context.WebSockets.IsWebSocketRequest)
        {
            using var webSocket = await context.WebSockets.AcceptWebSocketAsync();
            await EchoLoop(webSocket);
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
static async Task EchoLoop(WebSocket socket)
{
    var buffer = new byte[1024 * 4];
    while (socket.State == WebSocketState.Open)
    {
        var result = await socket.ReceiveAsync(new ArraySegment<byte>(buffer), CancellationToken.None);
        var message = Encoding.UTF8.GetString(buffer, 0, result.Count);
        Console.WriteLine($"Von Flutter empfangen: {message}");

        var antwort = Encoding.UTF8.GetBytes("Hallo zurück vom Server!");
        await socket.SendAsync(new ArraySegment<byte>(antwort), WebSocketMessageType.Text, true, CancellationToken.None);
    }
}
