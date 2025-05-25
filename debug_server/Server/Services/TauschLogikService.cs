using Microsoft.EntityFrameworkCore;
using Server.Data;
using Server.Models;

namespace Server.Services
{
    public class TauschLogikService
    {
        private readonly AppDbContext _db;

        public TauschLogikService(AppDbContext db)
        {
            _db = db;
        }

        public async Task<List<Ministranten>> GetMoeglicheTauschpartnerAsync(int terminId, int userId)
        {
            var termin = await _db.Termine.FindAsync(terminId);
            if (termin == null || termin.Teilnehmer == null)
                return new List<Ministranten>();

            var anfragender = await _db.Ministranten.FindAsync(userId);
            if (anfragender == null)
                return new List<Ministranten>();

            var teilnehmerInfo = termin.Teilnehmer
                .FirstOrDefault(t => t is not null &&
                                     t.GetType().GetProperty("id")?.GetValue(t) is int id &&
                                     id == userId);

            if (teilnehmerInfo == null)
                return new List<Ministranten>();

            string? rolleAmTermin = teilnehmerInfo.GetType().GetProperty("rolle")?.GetValue(teilnehmerInfo) as string;
            if (string.IsNullOrEmpty(rolleAmTermin))
                return new List<Ministranten>();

            var eingeteilteIds = termin.Teilnehmer
                .Select(t => (int?)t?.GetType().GetProperty("id")?.GetValue(t) ?? null)
                .Where(id => id.HasValue)
                .Select(id => id!.Value)
                .ToHashSet();

            var kandidaten = await _db.Ministranten
                .Where(m =>
                    m.Id != userId &&
                    m.RollenListe.Contains(rolleAmTermin) &&
                    !eingeteilteIds.Contains(m.Id))
                .ToListAsync();

            return kandidaten;
        }

        public async Task<List<Termin>> GetMoeglicheGegentauschtermineAsync(int tauschPartnerId, int anfragenderId)
        {
            var alleTermine = await _db.Termine.ToListAsync();

            var result = new List<Termin>();

            foreach (var termin in alleTermine)
            {
                if (termin.Teilnehmer == null) continue;

                var istEingeteilt = termin.Teilnehmer
                    .FirstOrDefault(t => t is not null &&
                                         t.GetType().GetProperty("id")?.GetValue(t) is int id &&
                                         id == tauschPartnerId);

                var istNichtEingeteilt = termin.Teilnehmer
                    .All(t => (int?)t?.GetType().GetProperty("id")?.GetValue(t) != anfragenderId);

                if (istEingeteilt == null || !istNichtEingeteilt) continue;

                // Gleiche Rolle prüfen
                string? rolle = istEingeteilt.GetType().GetProperty("rolle")?.GetValue(istEingeteilt) as string;

                if (string.IsNullOrEmpty(rolle)) continue;

                // Optional: Du kannst auch prüfen, ob der Anfragende diese Rolle generell in RollenListe hat
                result.Add(termin);
            }

            return result;
        }
    }
}
