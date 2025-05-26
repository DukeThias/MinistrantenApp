using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Server.Services;
using Server.Data;
using Server.Services.DatabaseAktionen;

namespace Server.Controllers
{
    [Authorize]
    [ApiController]
    [Route("api/[controller]")]
    public class UploadPlanController : ControllerBase
    {
        private readonly MinistrantenService _ministrantenService;
        private readonly AppDbContext _db;

        public UploadPlanController(MinistrantenService ministrantenService, AppDbContext db)
        {
            _ministrantenService = ministrantenService;
            _db = db;
        }

        /// <summary>
        /// Nimmt eine HTML-Datei entgegen, parst sie und speichert die Termine in die Datenbank.
        /// </summary>
        /// <param name="file">Hochgeladene HTML-Datei</param>
        /// <returns>Anzahl der importierten Termine</returns>
        [HttpPost("html")]
        [Consumes("multipart/form-data")]
        public async Task<IActionResult> UploadHtml([FromForm] IFormFile file)
        {
            // Prüfe, ob eine Datei hochgeladen wurde
            if (file == null || file.Length == 0)
                return BadRequest("Keine Datei hochgeladen.");

            // Benutzer-ID aus dem Token extrahieren
            var userIdString = User.FindFirst("id")?.Value;
            if (!int.TryParse(userIdString, out int userId))
                return Unauthorized("Benutzer nicht erkannt.");

            // Benutzer aus der Datenbank laden
            var benutzer = await _ministrantenService.GetMinistrantByIdAsync(userId);
            if (benutzer == null)
                return NotFound("Benutzer nicht gefunden.");

            // HTML-Inhalt aus der Datei lesen
            using var reader = new StreamReader(file.OpenReadStream());
            var htmlContent = await reader.ReadToEndAsync();

            // HTML parsen und Termine extrahieren
            var parser = new MiniplanParserServices(_ministrantenService, benutzer.GemeindeID);
            var termine = await parser.ParseHtmlToTermineAsync(htmlContent);

            // Termine in die Datenbank speichern
            _db.Termine.AddRange(termine);
            await _db.SaveChangesAsync();

            // Rückgabe: Anzahl der importierten Termine
            return Ok(new { importiert = termine.Count });
        }
    }
}
