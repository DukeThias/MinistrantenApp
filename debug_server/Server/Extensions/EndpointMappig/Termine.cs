using Microsoft.EntityFrameworkCore;
using Server.Data;
using Server.Models;

namespace Server.Extensions
{
    public static class TermineEndpoints
    {
        public static void MapTermineEndpoints(this WebApplication app)
        {
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
        }
    }
}