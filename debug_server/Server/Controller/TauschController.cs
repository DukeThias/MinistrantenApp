using Microsoft.AspNetCore.Mvc;
using Server.Models;
using Server.Services;

namespace Server.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class TauschController : ControllerBase
    {
        private readonly TauschService _tauschService;
        private readonly WebSocketService _webSocketService;

        public TauschController(TauschService tauschService, WebSocketService webSocketService)
        {
            _tauschService = tauschService;
            _webSocketService = webSocketService;
        }

        [HttpPost("start")]
        public async Task<IActionResult> StarteTausch([FromBody] TauschAnfrage anfrage)
        {
            var neueAnfrage = await _tauschService.StarteTauschAsync(anfrage);

            // Nachricht an den Empfänger senden
            await _webSocketService.BroadcastMessageAsync("tausch-anfrage", $"Neue Tauschanfrage von User {anfrage.VonUserId} für Termin {anfrage.VonTerminId}");

            return Ok(neueAnfrage);
        }

        [HttpPost("antwort")]
        public async Task<IActionResult> AntworteAufTausch([FromBody] TauschAntwortDto dto)
        {
            var aktualisiert = await _tauschService.AntworteAufTauschAsync(dto.AnfrageId, dto.Status, dto.GegentauschTerminId);
            if (aktualisiert == null) return NotFound();

            // Nachricht an ursprünglichen Anfragenden senden
            await _webSocketService.BroadcastMessageAsync("tausch-antwort", $"Tauschantwort für Anfrage {dto.AnfrageId}: {dto.Status}");

            return Ok(aktualisiert);
        }

        [HttpGet("user/{id}")]
        public async Task<IActionResult> GetFuerUser(int id)
        {
            var result = await _tauschService.GetAnfragenFuerUserAsync(id);
            return Ok(result);
        }
    }
}
