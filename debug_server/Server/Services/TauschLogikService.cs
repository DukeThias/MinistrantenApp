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
            var termin = await _db.Termine
                .Include(t => t.Teilnehmer)
                .FirstOrDefaultAsync(t => t.Id == terminId);
            if (termin == null || termin.Teilnehmer == null)
                return new List<Ministranten>();

            var anfragender = await _db.Ministranten.FindAsync(userId);
            if (anfragender == null)
                return new List<Ministranten>();

            var teilnehmerInfo = termin.Teilnehmer
                .FirstOrDefault(t => t.MinistrantId == userId);
            if (teilnehmerInfo == null)
                return new List<Ministranten>();

            string rolleAmTermin = teilnehmerInfo.Rolle;
            if (string.IsNullOrEmpty(rolleAmTermin))
                return new List<Ministranten>();

            var eingeteilteIds = termin.Teilnehmer
                .Select(t => t.MinistrantId)
                .ToHashSet();

            var kandidaten = await _db.Ministranten
                .Where(m =>
                    m.Id != userId &&
                    m.RollenListe.Contains(rolleAmTermin, StringComparer.OrdinalIgnoreCase) &&
                    !eingeteilteIds.Contains(m.Id))
                .ToListAsync();

            return kandidaten;
        }

        public async Task<List<Termin>> GetMoeglicheGegentauschtermineAsync(int tauschPartnerId, int anfragenderId)
        {
            var alleTermine = await _db.Termine
                .Include(t => t.Teilnehmer)
                .ToListAsync();

            var result = new List<Termin>();

            foreach (var termin in alleTermine)
            {
                if (termin.Teilnehmer == null) continue;

                var istEingeteilt = termin.Teilnehmer
                    .FirstOrDefault(t => t.MinistrantId == tauschPartnerId);

                var istNichtEingeteilt = termin.Teilnehmer
                    .All(t => t.MinistrantId != anfragenderId);

                if (istEingeteilt == null || !istNichtEingeteilt) continue;

                string rolle = istEingeteilt.Rolle;
                if (string.IsNullOrEmpty(rolle)) continue;

                result.Add(termin);
            }

            return result;
        }

        public async Task<int> AblehnenAbgelaufenerAnfragenAsync()
        {
            var jetzt = DateTime.UtcNow;

            var offeneAnfragen = await _db.TauschAnfragen
                .Where(a => a.Status == "Offen")
                .ToListAsync();

            int abgelehnt = 0;

            foreach (var anfrage in offeneAnfragen)
            {
                var termin = await _db.Termine
                    .FirstOrDefaultAsync(t => t.Id == anfrage.VonTerminId);

                if (termin != null && (termin.Start - jetzt).TotalHours < 24)
                {
                    anfrage.Status = "Abgelehnt";
                    abgelehnt++;
                }
            }

            if (abgelehnt > 0)
                await _db.SaveChangesAsync();

            return abgelehnt;
        }
    }
}
