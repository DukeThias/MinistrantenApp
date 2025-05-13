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
            // Endpunkte für Ministranten
            app.MapPost("/api/ministranten", async (DatabaseService dbService, Ministranten ministrant) =>
            {
                await dbService.AddMinistrantAsync(ministrant);
                return Results.Created($"/api/ministranten/{ministrant.Id}", ministrant);
            });

            app.MapGet("/api/ministranten/{id}", async (DatabaseService dbService, int id) =>
            {
                var ministrant = await dbService.GetMinistrantByIdAsync(id);
                return ministrant is not null ? Results.Ok(ministrant) : Results.NotFound();
            });

            app.MapGet("/api/ministranten", async (DatabaseService dbService) =>
            {
                var ministranten = await dbService.GetAllMinistrantenAsync();
                return Results.Ok(ministranten);
            });

            app.MapGet("/api/ministranten/gemeinde/{gemeindeId}", async (DatabaseService dbService, int gemeindeId) =>
            {
                var ministranten = await dbService.GetMinistrantenByGemeindeAsync(gemeindeId); // Korrekte Methode
                return Results.Ok(ministranten);
            });

            app.MapDelete("/api/ministranten/{id}", async (DatabaseService dbService, int id) =>
            {
                await dbService.DeleteMinistrantAsync(id);
                return Results.Ok();
            });

            // Endpunkte für Termine
            app.MapPost("/api/termine", async (AppDbContext db, Termin termin) =>
            {
                db.Termine.Add(termin);
                await db.SaveChangesAsync();
                return Results.Created($"/api/termine/{termin.Id}", termin);
            });

            app.MapGet("/api/termine/{id}", async (AppDbContext db, int id) =>
            {
                var termin = await db.Termine.FindAsync(id);
                return termin is not null ? Results.Ok(termin) : Results.NotFound();
            });

            app.MapGet("/api/termine", async (AppDbContext db) =>
            {
                var termine = await db.Termine.ToListAsync();
                return Results.Ok(termine);
            });

            app.MapDelete("/api/termine/{id}", async (AppDbContext db, int id) =>
            {
                var termin = await db.Termine.FindAsync(id);
                if (termin is null)
                {
                    return Results.NotFound();
                }

                db.Termine.Remove(termin);
                await db.SaveChangesAsync();
                return Results.Ok(termin);
            });

            // Endpunkte für Gemeinden
            app.MapPost("/api/gemeinden", async (AppDbContext db, Gemeinden gemeinde) =>
            {
                db.Gemeinden.Add(gemeinde);
                await db.SaveChangesAsync();
                return Results.Created($"/api/gemeinden/{gemeinde.Id}", gemeinde);
            });

            app.MapGet("/api/gemeinden/{id}", async (AppDbContext db, int id) =>
            {
                var gemeinde = await db.Gemeinden.FindAsync(id);
                return gemeinde is not null ? Results.Ok(gemeinde) : Results.NotFound();
            });

            app.MapGet("/api/gemeinden", async (AppDbContext db) =>
            {
                var gemeinden = await db.Gemeinden.ToListAsync();
                return Results.Ok(gemeinden);
            });

            app.MapDelete("/api/gemeinden/{id}", async (AppDbContext db, int id) =>
            {
                var gemeinde = await db.Gemeinden.FindAsync(id);
                if (gemeinde is null)
                {
                    return Results.NotFound();
                }

                db.Gemeinden.Remove(gemeinde);
                await db.SaveChangesAsync();
                return Results.Ok(gemeinde);
            });

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
