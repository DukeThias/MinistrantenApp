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
            app.MapGet("/api/ministranten", async (DatabaseService dbService) =>
            {
                return await dbService.GetAllMinistrantenAsync();
            });

            app.MapGet("/api/ministranten/{id}", async (DatabaseService dbService, int id) =>
            {
                var ministrant = await dbService.GetMinistrantByIdAsync(id);
                return ministrant is not null ? Results.Ok(ministrant) : Results.NotFound();
            });

            app.MapPost("/api/ministranten", async (DatabaseService dbService, Ministranten ministrant) =>
            {
                await dbService.AddMinistrantAsync(ministrant);
                return Results.Created($"/api/ministranten/{ministrant.Id}", ministrant);
            });

            app.MapPut("/api/ministranten/{id}", async (DatabaseService dbService, int id, Ministranten updatedMinistrant) =>
            {
                var success = await dbService.UpdateMinistrantAsync(id, updatedMinistrant);
                return success ? Results.Ok(updatedMinistrant) : Results.NotFound();
            });


            app.MapDelete("/api/ministranten/{id}", async (DatabaseService dbService, int id) =>
            {
                await dbService.DeleteMinistrantAsync(id);
                return Results.Ok();
            });

            // Optional: Update-Endpunkt, falls benötigt
            // app.MapPut("/api/ministranten/{id}", async (DatabaseService dbService, int id, Ministranten updatedMinistrant) =>
            // {
            //     await dbService.UpdateMinistrantAsync(id, updatedMinistrant);
            //     return Results.Ok();
            // });

            // Termine
            app.MapGet("/api/termine", async (AppDbContext db) =>
            {
                return await db.Termine.ToListAsync();
            });

            app.MapPost("/api/termine", async (AppDbContext db, Termin termin) =>
            {
                db.Termine.Add(termin);
                await db.SaveChangesAsync();
                return Results.Created($"/api/termine/{termin.Id}", termin);
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

            // Gemeinden
            app.MapGet("/api/gemeinden", async (AppDbContext db) =>
            {
                return await db.Gemeinden.ToListAsync();
            });

            app.MapPost("/api/gemeinden", async (AppDbContext db, Gemeinden gemeinde) =>
            {
                db.Gemeinden.Add(gemeinde);
                await db.SaveChangesAsync();
                return Results.Created($"/api/gemeinden/{gemeinde.Id}", gemeinde);
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

            // Nachrichten
            app.MapGet("/api/nachrichten", async (AppDbContext db) =>
            {
                return await db.Nachrichten.ToListAsync();
            });

            app.MapPost("/api/nachrichten", async (AppDbContext db, Nachrichten nachricht) =>
            {
                db.Nachrichten.Add(nachricht);
                await db.SaveChangesAsync();
                return Results.Created($"/api/nachrichten/{nachricht.Id}", nachricht);
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
