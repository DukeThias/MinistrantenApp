using Microsoft.AspNetCore.Http;
using Server.Services;
using Server.Services.DatabaseAktionen;
using Server.Models;
using Server.Data;

namespace Server.Extensions
{
    public static class UploadEndpoints
    {
        public static void MapUploadEndpoints(this WebApplication app)
        {
            app.MapPost("/api/uploadplan/html", async (
                IFormFile file,
                MinistrantenService ministrantenService,
                AppDbContext db
            ) =>
            {
                // Datei validieren
                if (file == null || file.Length == 0)
                    return Results.BadRequest("Keine Datei erhalten.");

                // ⚠ Feste Gemeinde-ID verwenden (z. B. ID = 1 für Tests)
                var gemeindeId = 1;

                // HTML-Inhalt lesen
                using var reader = new StreamReader(file.OpenReadStream());
                var htmlContent = await reader.ReadToEndAsync();

                // Parser starten
                var parser = new MiniplanParserServices(ministrantenService, gemeindeId);
                var termine = await parser.ParseHtmlToTermineAsync(htmlContent);

                // Termine speichern
                db.Termine.AddRange(termine);
                await db.SaveChangesAsync();

                return Results.Ok(new { importiert = termine.Count });
            })
            .DisableAntiforgery() // ← für Swagger nötig
            .Accepts<IFormFile>("multipart/form-data")
            .WithName("UploadMiniplan")
            .WithTags("Upload");
        }
    }
}
