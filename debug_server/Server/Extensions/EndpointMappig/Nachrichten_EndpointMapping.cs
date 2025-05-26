using Microsoft.EntityFrameworkCore;
using Server.Data;
using Server.Models;

namespace Server.Extensions
{
    public static class NachrichtenEndpoints
    {
        public static void MapNachrichtenEndpoints(this WebApplication app)
        {
            // POST: Neue Nachricht anlegen
            app.MapPost("/api/nachrichten", async (AppDbContext db, Nachrichten nachricht) =>
            {
                db.Nachrichten.Add(nachricht);
                await db.SaveChangesAsync();
                return Results.Created($"/api/nachrichten/{nachricht.Id}", nachricht);
            });

            // GET: Nachrichten abfragen
            app.MapGet("/api/nachrichten", async (
                AppDbContext db,
                int? id,
                int? gemeindeId
            ) =>
            {
                var query = db.Nachrichten.AsQueryable();

                if (id.HasValue)
                    query = query.Where(n => n.Id == id.Value);

                if (gemeindeId.HasValue)
                    query = query.Where(n => n.gemeindeId == gemeindeId.Value);

                var nachrichten = await query.ToListAsync();
                return Results.Ok(nachrichten);
            });


            // DELETE: Nachricht löschen
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