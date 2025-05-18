using Microsoft.EntityFrameworkCore;
using Server.Data;
using Server.Models;

namespace Server.Extensions
{
    public static class GemeindenEndpoints
    {
        public static void MapGemeindenEndpoints(this WebApplication app)
        {
            app.MapPost("/api/gemeinden", async (AppDbContext db, Gemeinden gemeinde) =>
            {
                db.Gemeinden.Add(gemeinde);
                await db.SaveChangesAsync();
                return Results.Created($"/api/gemeinden/{gemeinde.Id}", gemeinde);
            });

            app.MapGet("/api/gemeinden", async (
                AppDbContext db,
                int? id,
                string? kuerzel
            ) =>
            {
                var query = db.Gemeinden.AsQueryable();

                if (id.HasValue)
                    query = query.Where(g => g.Id == id.Value);

                if (!string.IsNullOrEmpty(kuerzel))
                    query = query.Where(g => g.Kuerzel == kuerzel);

                var gemeinden = await query.ToListAsync();
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
        }
    }
}