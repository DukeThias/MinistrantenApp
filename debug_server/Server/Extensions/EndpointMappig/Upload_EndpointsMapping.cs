using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Server.Services;
using Server.Services.DatabaseAktionen;
using Server.Data;

namespace Server.Extensions
{
    public static class UploadEndpoints
    {
        public static void MapUploadEndpoints(this WebApplication app)
        {
            app.MapPost("/api/uploadplan/html", async (
                [FromForm] MiniplanUploadFormDto dto,
                MinistrantenService ministrantenService,
                AppDbContext db
            ) =>
            {
                if (dto.File == null || dto.File.Length == 0)
                    return Results.BadRequest("Keine Datei erhalten.");

                var gemeindeId = dto.GemeindeId;

                using var reader = new StreamReader(dto.File.OpenReadStream());
                var htmlContent = await reader.ReadToEndAsync();

                var parser = new MiniplanParserServices(ministrantenService, gemeindeId);
                var neueTermine = await parser.ParseHtmlToTermineAsync(htmlContent);

                foreach (var neuerTermin in neueTermine)
                {
                    // Verhindere Duplikate
                    bool existiert = await db.Termine.AnyAsync(t =>
                        t.Name == neuerTermin.Name &&
                        t.Start == neuerTermin.Start &&
                        t.GemeindeID == neuerTermin.GemeindeID
                    );

                    if (!existiert)
                    {
                        db.Termine.Add(neuerTermin);
                    }
                }

                await db.SaveChangesAsync();

                return Results.Ok(new { importiert = neueTermine.Count });
            })
            .DisableAntiforgery()
            .WithName("UploadMiniplan")
            .WithTags("Upload");
        }
    }
}