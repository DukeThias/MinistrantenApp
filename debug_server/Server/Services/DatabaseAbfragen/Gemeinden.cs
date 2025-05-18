using Microsoft.EntityFrameworkCore;
using Server.Data;
using Server.Models;

namespace Server.Services
{
    public class GemeindenService
    {
        private readonly AppDbContext _db;

        public GemeindenService(AppDbContext db)
        {
            _db = db;
        }

        public async Task<List<Gemeinden>> GetAllGemeindenAsync()
            => await _db.Gemeinden.ToListAsync();

        public async Task<Gemeinden?> GetGemeindenByIdAsync(int id)
            => await _db.Gemeinden.FindAsync(id);

        public async Task AddGemeindenAsync(Gemeinden gemeinde)
        {
            await _db.Gemeinden.AddAsync(gemeinde);
            await _db.SaveChangesAsync();
        }

        public async Task<bool> UpdateGemeindenAsync(int id, Gemeinden updated)
        {
            var existing = await _db.Gemeinden.FindAsync(id);
            if (existing == null) return false;

            existing.UpdateFrom(updated);
            await _db.SaveChangesAsync();
            return true;
        }

        public async Task DeleteGemeindenAsync(int id)
        {
            var gemeinde = await _db.Gemeinden.FindAsync(id);
            if (gemeinde != null)
            {
                _db.Gemeinden.Remove(gemeinde);
                await _db.SaveChangesAsync();
            }
        }
    }
}