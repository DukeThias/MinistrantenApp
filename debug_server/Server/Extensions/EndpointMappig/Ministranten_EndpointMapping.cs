using Server.Services;
using Server.Models;

namespace Server.Extensions
{
    public static class MinistrantenEndpoints
    {
        public static void MapMinistrantenEndpoints(this WebApplication app)
        {
            // POST: Neuen Ministranten anlegen
            app.MapPost("/api/ministranten", async (MinistrantenService ministrantenService, Ministranten ministrant) =>
            {
                await ministrantenService.AddMinistrantAsync(ministrant);
                return Results.Created($"/api/ministranten/{ministrant.Id}", ministrant);
            });

            // GET: Ministranten abfragen
            app.MapGet("/api/ministranten", async (
                MinistrantenService ministrantenService,
                string? username,
                string? rolle,
                bool? vegan,
                bool? vegetarisch,
                int? gemeindeId, 
                int? ministrantenId
            ) =>
            {
                var ministranten = await ministrantenService.SearchMinistrantenAsync(username, rolle, vegan, vegetarisch, gemeindeId, ministrantenId);
                return Results.Ok(ministranten);
            });

            // PUT: Ministrant aktualisieren
            app.MapPut("/api/ministranten/{id}", async (MinistrantenService ministrantenService, int id, Ministranten updatedMinistrant) =>
            {
                var result = await ministrantenService.UpdateMinistrantAsync(id, updatedMinistrant);
                if (!result)
                    return Results.NotFound();
                return Results.Ok(updatedMinistrant);
            });

            // DELETE: Ministrant löschen
            app.MapDelete("/api/ministranten/{id}", async (MinistrantenService ministrantenService, int id) =>
            {
                await ministrantenService.DeleteMinistrantAsync(id);
                return Results.Ok();
            });
        }
    }
}