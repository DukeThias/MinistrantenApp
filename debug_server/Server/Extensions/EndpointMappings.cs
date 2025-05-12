using Microsoft.AspNetCore.Builder;
using Microsoft.EntityFrameworkCore;
using Server.Data; // Für AppDbContext
using Server.Models; // Für Person, Termin, Gemeinden

namespace Server.Extensions
{
    public static class EndpointMappings
    {
        public static void MapApiEndpoints(this WebApplication app)
        {
            // Personen
            app.MapGet("/api/personen", async (AppDbContext db) =>
            {
                return await db.Ministranten.ToListAsync();
            });

            app.MapPost("/api/personen", async (AppDbContext db, Ministranten person) =>
            {
                db.Ministranten.Add(person);
                await db.SaveChangesAsync();
                return Results.Created($"/api/personen/{person.Id}", person);
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
        }
    }
}
