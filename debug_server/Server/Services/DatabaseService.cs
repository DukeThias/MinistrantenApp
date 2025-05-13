using Microsoft.EntityFrameworkCore;
using Server.Data; // Ensure this namespace is imported
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

        // Einen Ministranten nach ID abrufen
        public async Task<Ministranten?> GetMinistrantByIdAsync(int id)
        {
            return await _db.Ministranten.FindAsync(id);
        }

        // Einen neuen Ministranten hinzufügen
        public async Task AddMinistrantAsync(Ministranten ministrant)
        {
            await _db.Ministranten.AddAsync(ministrant);
            await _db.SaveChangesAsync();
        }

        // Einen Ministranten aktualisieren
        // public async Task UpdateMinistrantAsync(int id, Ministranten updatedMinistrant)
        // {
        //     var ministrant = await _db.Ministranten.FindAsync(id);
        //     if (ministrant != null)
        //     {
        //         ministrant.Name = updatedMinistrant.Name;
        //         await _db.SaveChangesAsync();
        //     }
        // }

        // Einen Ministranten löschen
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