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
        }
    }
}