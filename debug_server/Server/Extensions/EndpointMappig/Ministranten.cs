using Server.Services;
using Server.Models;

namespace Server.Extensions
{
    public static class MinistrantenEndpoints
    {
        public static void MapMinistrantenEndpoints(this WebApplication app)
        {
            app.MapPost("/api/ministranten", async (DatabaseService dbService, Ministranten ministrant) =>
            {
                await dbService.AddMinistrantAsync(ministrant);
                return Results.Created($"/api/ministranten/{ministrant.Id}", ministrant);
            });


            app.MapGet("/api/ministranten", async (
                DatabaseService dbService,
                string? username,
                string? rolle,
                bool? vegan,
                bool? vegetarisch,
                int? gemeindeId, 
                int? ministrantenId
            ) =>
            {
                var ministranten = await dbService.GetAllMinistrantenAsync();

                if (!string.IsNullOrEmpty(username))
                    ministranten = ministranten.Where(m => m.Username == username).ToList();

                if (!string.IsNullOrEmpty(rolle))
                    ministranten = ministranten.Where(m => m.Rolle.Contains(rolle)).ToList();

                if (vegan.HasValue)
                    ministranten = ministranten.Where(m => m.Vegan == vegan.Value).ToList();

                if (vegetarisch.HasValue)
                    ministranten = ministranten.Where(m => m.Vegetarisch == vegetarisch.Value).ToList();

                if (gemeindeId.HasValue)
                    ministranten = ministranten.Where(m => m.GemeindeID == gemeindeId.Value).ToList();

                if (ministrantenId.HasValue)
                    ministranten = ministranten.Where(m => m.Id == ministrantenId.Value).ToList();

                return Results.Ok(ministranten);
            });


            app.MapDelete("/api/ministranten/{id}", async (DatabaseService dbService, int id) =>
            {
                await dbService.DeleteMinistrantAsync(id);
                return Results.Ok();
            });
        }
    }
}