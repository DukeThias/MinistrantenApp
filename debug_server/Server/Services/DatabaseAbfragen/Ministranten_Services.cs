using Microsoft.EntityFrameworkCore;
using Server.Data;
using Server.Models;

namespace Server.Services
{
    public class MinistrantenService
    {
        private readonly AppDbContext _db;

        public MinistrantenService(AppDbContext db)
        {
            _db = db;
        }

        public async Task<List<Ministranten>> GetAllMinistrantenAsync()
            => await _db.Ministranten.ToListAsync();

        public async Task<Ministranten?> GetMinistrantByIdAsync(int id)
            => await _db.Ministranten.FindAsync(id);

        public async Task AddMinistrantAsync(Ministranten ministrant)
        {
            await _db.Ministranten.AddAsync(ministrant);
            await _db.SaveChangesAsync();
        }

        public async Task<bool> UpdateMinistrantAsync(int id, Ministranten updated)
        {
            var existing = await _db.Ministranten.FindAsync(id);
            if (existing == null) return false;

            existing.UpdateFrom(updated);
            await _db.SaveChangesAsync();
            return true;
        }

        public async Task DeleteMinistrantAsync(int id)
        {
            var ministrant = await _db.Ministranten.FindAsync(id);
            if (ministrant != null)
            {
                _db.Ministranten.Remove(ministrant);
                await _db.SaveChangesAsync();
            }
        }

        public async Task<List<Ministranten>> SearchMinistrantenAsync(
            string? username = null,
            string? rolle = null,
            bool? vegan = null,
            bool? vegetarisch = null,
            int? gemeindeId = null,
            int? ministrantenId = null)
        {
            var query = _db.Ministranten.AsQueryable();

            if (!string.IsNullOrEmpty(username))
                query = query.Where(m => m.Username == username);

            if (!string.IsNullOrEmpty(rolle))
                query = query.Where(m => m.Rolle.Contains(rolle));

            if (vegan.HasValue)
                query = query.Where(m => m.Vegan == vegan.Value);

            if (vegetarisch.HasValue)
                query = query.Where(m => m.Vegetarisch == vegetarisch.Value);

            if (gemeindeId.HasValue)
                query = query.Where(m => m.GemeindeID == gemeindeId.Value);

            if (ministrantenId.HasValue)
                query = query.Where(m => m.Id == ministrantenId.Value);

            return await query.ToListAsync();
        }
    }
}