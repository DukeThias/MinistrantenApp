using Server.Models;
using Server.Services;

namespace Server.Extensions
{
    public static class TauschEndpoints
    {
        public static void MapTauschEndpoints(this WebApplication app)
        {
            // Tauschanfrage starten
            app.MapPost("/api/tausch/start", async (
                TauschService tauschService,
                WebSocketService webSocketService,
                TauschAnfrage anfrage) =>
            {
                var neueAnfrage = await tauschService.StarteTauschAsync(anfrage);
                await webSocketService.BroadcastMessageAsync("tausch-anfrage", $"Neue Tauschanfrage von User {anfrage.VonUserId} für Termin {anfrage.VonTerminId}");
                return Results.Ok(neueAnfrage);
            })
            .WithName("StarteTausch")
            .WithOpenApi()
            .WithSummary("Neue Tauschanfrage erstellen")
            .WithDescription("Startet eine neue Tauschanfrage und benachrichtigt den Empfänger über WebSocket.");

            // Auf Tauschanfrage antworten
            app.MapPost("/api/tausch/antwort", async (
                TauschService tauschService,
                WebSocketService webSocketService,
                TauschAntwortDto dto) =>
            {
                var aktualisiert = await tauschService.AntworteAufTauschAsync(dto.AnfrageId, dto.Status, dto.GegentauschTerminId);
                if (aktualisiert == null) return Results.NotFound();

                await webSocketService.BroadcastMessageAsync("tausch-antwort", $"Tauschantwort für Anfrage {dto.AnfrageId}: {dto.Status}");
                return Results.Ok(aktualisiert);
            })
            .WithName("AntworteAufTausch")
            .WithOpenApi()
            .WithSummary("Antwort auf eine Tauschanfrage")
            .WithDescription("Antwortet auf eine bestehende Tauschanfrage mit Status (Bestätigt, Abgelehnt etc.).");


            // API-Endpunkt zum Bereinigen abgelaufener Tauschanfragen
            app.MapPost("/api/tausch/cleanup", async (
                TauschLogikService logikService) =>
            {
                var anzahl = await logikService.AblehnenAbgelaufenerAnfragenAsync();
                return Results.Ok(new { abgelehnt = anzahl });
            })
            .WithName("BereinigeAbgelaufeneTauschanfragen")
            .WithOpenApi()
            .WithSummary("Setzt alte Anfragen auf 'Abgelehnt'")
            .WithDescription("Alle offenen Tauschanfragen mit weniger als 24h Vorlauf werden automatisch abgelehnt.");

            // Dienst ohne Gegentausch übernehmen
            app.MapPost("/api/tausch/uebernehmen", async (
                TauschService tauschService,
                WebSocketService webSocketService,
                TauschUebernahmeDto dto) =>
            {
                var ok = await tauschService.UebernehmeDienstAsync(dto.AnfrageId, dto.NeuerMinistrantId);
                if (!ok) return Results.BadRequest("Übernahme fehlgeschlagen.");

                await webSocketService.BroadcastMessageAsync("tausch-uebernahme", $"Dienst wurde übernommen (AnfrageId: {dto.AnfrageId})");
                return Results.Ok(new { message = "Dienst erfolgreich übernommen." });
            })
            .WithName("UebernehmeDienst")
            .WithOpenApi()
            .WithSummary("Dienst übernehmen")
            .WithDescription("Erlaubt einem Nutzer, einen Dienst ohne Gegentausch zu übernehmen.");



            // Tauschanfragen für einen User abrufen
            app.MapGet("/api/tausch/user/{id}", async (
                TauschService tauschService, int id) =>
            {
                var result = await tauschService.GetAnfragenFuerUserAsync(id);
                return Results.Ok(result);
            })
            .WithName("HoleTauschanfragenFuerUser")
            .WithOpenApi()
            .WithSummary("Tauschanfragen für einen bestimmten User")
            .WithDescription("Gibt alle Tauschanfragen zurück, an denen der User beteiligt ist.");
        }
    }
}
