using Microsoft.EntityFrameworkCore;
using Server.Data;
using Server.Models;

namespace Server.Services
{
    public class NachrichtenService
    {
        private readonly AppDbContext _db;

        public NachrichtenService(AppDbContext db)
        {
            _db = db;
        }

        public async Task<List<Nachrichten>> GetAllNachrichtenAsync()
            => await _db.Nachrichten.ToListAsync();

        public async Task<Nachrichten?> GetNachrichtByIdAsync(int id)
            => await _db.Nachrichten.FindAsync(id);

        public async Task<List<Nachrichten>> SearchNachrichtenAsync(int? id = null, int? gemeindeId = null)
        {
            var query = _db.Nachrichten.AsQueryable();

            if (id.HasValue)
                query = query.Where(n => n.Id == id.Value);

            if (gemeindeId.HasValue)
                query = query.Where(n => n.gemeindeId == gemeindeId.Value);

            return await query.ToListAsync();
        }

        public async Task AddNachrichtAsync(Nachrichten nachricht)
        {
            await _db.Nachrichten.AddAsync(nachricht);
            await _db.SaveChangesAsync();
        }

        public async Task DeleteNachrichtAsync(int id)
        {
            var nachricht = await _db.Nachrichten.FindAsync(id);
            if (nachricht != null)
            {
                _db.Nachrichten.Remove(nachricht);
                await _db.SaveChangesAsync();
            }
        }
    }
}