using Microsoft.EntityFrameworkCore;
using Server.Data;
using Server.Models;

namespace Server.Services
{
    public class TauschService
    {
        private readonly AppDbContext _db;

        public TauschService(AppDbContext db)
        {
            _db = db;
        }

        public async Task<TauschAnfrage> StarteTauschAsync(TauschAnfrage anfrage)
        {
            anfrage.Status = "Offen";
            anfrage.Zeitstempel = DateTime.UtcNow;
            _db.TauschAnfragen.Add(anfrage);
            await _db.SaveChangesAsync();
            return anfrage;
        }

        public async Task<TauschAnfrage?> AntworteAufTauschAsync(int anfrageId, string status, int? gegentauschTerminId)
        {
            var anfrage = await _db.TauschAnfragen.FindAsync(anfrageId);
            if (anfrage == null) return null;

            anfrage.Status = status;
            anfrage.GegentauschTerminId = gegentauschTerminId;
            await _db.SaveChangesAsync();
            return anfrage;
        }

        public async Task<List<TauschAnfrage>> GetAnfragenFuerUserAsync(int userId)
        {
            return await _db.TauschAnfragen
                .Where(a => a.VonUserId == userId || a.AnUserId == userId)
                .OrderByDescending(a => a.Zeitstempel)
                .ToListAsync();
        }
    }
}
