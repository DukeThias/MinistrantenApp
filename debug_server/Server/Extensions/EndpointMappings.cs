using Microsoft.EntityFrameworkCore;
using Server.Data;
using Server.Models;
using Server.Services;

namespace Server.Extensions
{
    public static class EndpointMappings
    {
        public static void MapApiEndpoints(this WebApplication app)
        {

            // Endpunkte für Ministranten auslagern
            app.MapMinistrantenEndpoints();

            // Endpunkte für Termine
            app.MapTermineEndpoints();

            // Endpunkte für Gemeinden
            app.MapGemeindenEndpoints();


            

            // Endpunkte für Nachrichten
            app.MapPost("/api/nachrichten", async (AppDbContext db, Nachrichten nachricht) =>
            {
                db.Nachrichten.Add(nachricht);
                await db.SaveChangesAsync();
                return Results.Created($"/api/nachrichten/{nachricht.Id}", nachricht);
            });

            app.MapGet("/api/nachrichten/{id}", async (AppDbContext db, int id) =>
            {
                var nachricht = await db.Nachrichten.FindAsync(id);
                return nachricht is not null ? Results.Ok(nachricht) : Results.NotFound();
            });

            app.MapGet("/api/nachrichten", async (AppDbContext db) =>
            {
                var nachrichten = await db.Nachrichten.ToListAsync();
                return Results.Ok(nachrichten);
            });

            app.MapDelete("/api/nachrichten/{id}", async (AppDbContext db, int id) =>
            {
                var nachricht = await db.Nachrichten.FindAsync(id);
                if (nachricht is null)
                {
                    return Results.NotFound();
                }

                db.Nachrichten.Remove(nachricht);
                await db.SaveChangesAsync();
                return Results.Ok(nachricht);
            });
        }
    }
}
