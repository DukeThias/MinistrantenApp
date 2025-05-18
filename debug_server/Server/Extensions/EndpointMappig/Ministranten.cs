using Server.Services;
using Server.Models;

namespace Server.Extensions
{
    public static class MinistrantenEndpoints
    {
        public static void MapMinistrantenEndpoints(this WebApplication app)
        {
            app.MapPost("/api/ministranten", async (MinistrantenService ministrantenService, Ministranten ministrant) =>
            {
                await ministrantenService.AddMinistrantAsync(ministrant);
                return Results.Created($"/api/ministranten/{ministrant.Id}", ministrant);
            });

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

            app.MapDelete("/api/ministranten/{id}", async (MinistrantenService ministrantenService, int id) =>
            {
                await ministrantenService.DeleteMinistrantAsync(id);
                return Results.Ok();
            });
        }
    }
}