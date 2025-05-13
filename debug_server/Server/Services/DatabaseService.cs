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
        // Alle Gemeinden abrufen
        public async Task<List<Gemeinden>> GetAllGemeindenAsync()
        {
            return await _db.Gemeinden.ToListAsync();
        }

        // Gemeinden nach ID abrufen
        public async Task<Gemeinden?> GetGemeindenByIdAsync(int id)
        {
            return await _db.Gemeinden.FindAsync(id);
        }

        // Neue Gemeinden hinzufügen
        public async Task AddGemeindenAsync(Gemeinden Gemeinden)
        {
            await _db.Gemeinden.AddAsync(Gemeinden);
            await _db.SaveChangesAsync();
        }

        // Bestehende Gemeinden aktualisieren
        public async Task<bool> UpdateGemeindenAsync(int id, Gemeinden updated)
        {
            var existing = await _db.Gemeinden.FindAsync(id);
            if (existing == null) return false;

            existing.UpdateFrom(updated);
            await _db.SaveChangesAsync();
            return true;
        }

        // Gemeinden löschen
        public async Task DeleteGemeindenAsync(int id)
        {
            var Gemeinden = await _db.Gemeinden.FindAsync(id);
            if (Gemeinden != null)
            {
            _db.Gemeinden.Remove(Gemeinden);
            await _db.SaveChangesAsync();
            }
        }
        // Alle Ministranten abrufen
        public async Task<List<Ministranten>> GetAllMinistrantenAsync()
        {
            return await _db.Ministranten.ToListAsync();
        }

        // Ministranten nach GemeindenID abrufen
        public async Task<List<Ministranten>> GetMinistrantenByGemeindenAsync(int GemeindenID)
        {
            return await _db.Ministranten
                            .Where(m => m.GemeindeID == GemeindenID)
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
        public async Task<string?> GetPasswordByMinistrantNameAsync(string name)
        {
            var ministrant = await _db.Ministranten
                .FirstOrDefaultAsync(m => m.Name == name); // Suche nach dem Namen
            return ministrant?.Passwort; // Gib das Passwort zurück, falls gefunden
        }
    }
}
