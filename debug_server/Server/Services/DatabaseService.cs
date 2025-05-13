using Microsoft.EntityFrameworkCore;
using Server.Data;
using Server.Models;


namespace Server.Services
{
    public class DatabaseService
    {
        private readonly AppDbContext _db;

        public DatabaseService(AppDbContext db)
        {
            _db = db;
        }

        // Alle Ministranten abrufen
        public async Task<List<Ministranten>> GetAllMinistrantenAsync()
        {
            return await _db.Ministranten.ToListAsync();
        }

        // Ministranten nach GemeindeID abrufen
        public async Task<List<Ministranten>> GetMinistrantenByGemeindeAsync(int gemeindeID)
        {
            return await _db.Ministranten
                            .Where(m => m.GemeindeID == gemeindeID)
                            .ToListAsync();
        }

        // Einzelnen Ministranten nach ID abrufen
        public async Task<Ministranten?> GetMinistrantByIdAsync(int id)
        {
            return await _db.Ministranten.FindAsync(id);
        }

        // Neuen Ministranten hinzufügen
        public async Task AddMinistrantAsync(Ministranten ministrant)
        {
            await _db.Ministranten.AddAsync(ministrant);
            await _db.SaveChangesAsync();
        }

        // Bestehenden Ministranten aktualisieren
        public async Task<bool> UpdateMinistrantAsync(int id, Ministranten updated)
        {
            var existing = await _db.Ministranten.FindAsync(id);
            if (existing == null) return false;

            existing.UpdateFrom(updated);
            await _db.SaveChangesAsync();
            return true;
        }

        // Ministranten löschen
        public async Task DeleteMinistrantAsync(int id)
        {
            var ministrant = await _db.Ministranten.FindAsync(id);
            if (ministrant != null)
            {
                _db.Ministranten.Remove(ministrant);
                await _db.SaveChangesAsync();
            }
        }
    }
}
