using Microsoft.AspNetCore.Builder;
using Microsoft.EntityFrameworkCore;
using Server.Data;
using Server.Models;

namespace Server.Extensions
{
    public static class EndpointMappings
    {
        public static void MapApiEndpoints(this WebApplication app)
        {
            // Personen
            app.MapGet("/api/personen", async (AppDbContext db) =>
            {
                Console.WriteLine("GET /api/personen");
                return await db.Ministranten.ToListAsync();
            }
            );

            app.MapPost("/api/personen", async (AppDbContext db, Ministranten ministranten) =>
            {
                db.Ministranten.Add(ministranten);
                await db.SaveChangesAsync();
                return Results.Created($"/api/ministranten/{ministranten.Id}", ministranten);
            });

            app.MapDelete("/api/personen/{id}", async (AppDbContext db, int id) =>
            {
                var person = await db.Ministranten.FindAsync(id);
                if (person is null)
                {
                    return Results.NotFound();
                }

                db.Ministranten.Remove(person);
                await db.SaveChangesAsync();
                return Results.Ok(person);
            });

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
