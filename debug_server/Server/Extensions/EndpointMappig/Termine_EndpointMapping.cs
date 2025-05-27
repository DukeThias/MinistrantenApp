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
                var query = db.Termine
                    .Include(t => t.Teilnehmer) // Teilnehmer direkt mitladen
                    .AsQueryable();

                if (gemeindeId.HasValue)
                    query = query.Where(t => t.GemeindeID == gemeindeId.Value);

                if (terminId.HasValue)
                    query = query.Where(t => t.Id == terminId.Value);

                var termine = await query.ToListAsync();

                // Teilnehmer-Filter erst nach dem Laden anwenden!
                if (!string.IsNullOrEmpty(teilnehmer) && int.TryParse(teilnehmer, out int teilnehmerId))
                    termine = termine
                        .Where(t => t.Teilnehmer.Any(te => te != null && te.MinistrantId == teilnehmerId))
                        .ToList();

                return Results.Ok(termine);
            });

            // PUT: Termin aktualisieren
            app.MapPut("/api/termine/{id}", async (AppDbContext db, int id, Termin updatedTermin) =>
            {
                var termin = await db.Termine
                    .Include(t => t.Teilnehmer)
                    .FirstOrDefaultAsync(t => t.Id == id);

                if (termin is null)
                {
                    return Results.NotFound();
                }

                // Vorhandene Teilnehmer entfernen (optional)
                db.RemoveRange(termin.Teilnehmer);

                // Felder aktualisieren
                termin.UpdateFrom(updatedTermin);

                await db.SaveChangesAsync();
                return Results.Ok(termin);
            });

            // DELETE: Termin löschen
            app.MapDelete("/api/termine/{id}", async (AppDbContext db, int id) =>
            {
                var termin = await db.Termine
                    .Include(t => t.Teilnehmer)
                    .FirstOrDefaultAsync(t => t.Id == id);

                if (termin is null)
                {
                    return Results.NotFound();
                }

                db.RemoveRange(termin.Teilnehmer); // Auch Teilnehmer mitlöschen
                db.Termine.Remove(termin);
                await db.SaveChangesAsync();
                return Results.Ok(termin);
            });

            // DELETE: Alle Termine einer Gemeinde löschen
            app.MapDelete("/api/termine", async (AppDbContext db, int gemeindeId) =>
            {
                var termine = await db.Termine
                    .Where(t => t.GemeindeID == gemeindeId)
                    .Include(t => t.Teilnehmer)
                    .ToListAsync();

                if (termine.Count == 0)
                    return Results.NotFound("Keine Termine gefunden für die angegebene Gemeinde.");

                foreach (var termin in termine)
                {
                    db.RemoveRange(termin.Teilnehmer);
                }

                db.Termine.RemoveRange(termine);
                await db.SaveChangesAsync();
                return Results.Ok($"{termine.Count} Termine gelöscht.");
            });
        }
    }
}
