using Microsoft.EntityFrameworkCore;
using Server.Data;
using Server.Models;

namespace Server.Extensions
{
    public static class TermineEndpoints
    {
        public static void MapTermineEndpoints(this WebApplication app)
        {
            // POST: Termin anlegen
            app.MapPost("/api/termine", async (AppDbContext db, Termin termin) =>
            {
                db.Termine.Add(termin);
                await db.SaveChangesAsync();
                return Results.Created($"/api/termine/{termin.Id}", termin);
            });


            // GET: Termine abfragen
            app.MapGet("/api/termine", async (
                AppDbContext db,
                string? teilnehmer,
                int? gemeindeId,
                int? terminId
            ) =>
            {
                var query = db.Termine.AsQueryable();

                if (gemeindeId.HasValue)
                    query = query.Where(t => t.GemeindeID == gemeindeId.Value);

                if (terminId.HasValue)
                    query = query.Where(t => t.Id == terminId.Value);

                var termine = await query.ToListAsync();

                // Teilnehmer-Filter erst nach dem Laden anwenden!
                if (!string.IsNullOrEmpty(teilnehmer) && int.TryParse(teilnehmer, out int teilnehmerId))
                    termine = termine.Where(t => t.Teilnehmer.Any(te => te != null && te.ministrantId == teilnehmerId)).ToList();

                return Results.Ok(termine);
            });

            // PUT: Termin aktualisieren
            app.MapPut("/api/termine/{id}", async (AppDbContext db, int id, Termin updatedTermin) =>
            {
                var termin = await db.Termine.FindAsync(id);
                if (termin is null)
                {
                    return Results.NotFound();
                }

                // Felder aktualisieren (nutzt die UpdateFrom-Methode aus deinem Modell)
                termin.UpdateFrom(updatedTermin);

                await db.SaveChangesAsync();
                return Results.Ok(termin);
            });

            // DELETE: Termin löschen
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