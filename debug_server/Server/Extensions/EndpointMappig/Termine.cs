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


            app.MapGet("/api/termine", async (
                AppDbContext db,
                string? teilnehmer,
                int? gemeindeId,
                int? terminId
            ) =>
            {
                var query = db.Termine.AsQueryable();

                if (!string.IsNullOrEmpty(teilnehmer))
                    query = query.Where(t => t.Teilnehmer.Contains(teilnehmer));

                if (gemeindeId.HasValue)
                    query = query.Where(t => t.GemeindeID == gemeindeId.Value);

                if (terminId.HasValue)
                    query = query.Where(t => t.Id == terminId.Value);

                var termine = await query.ToListAsync();
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