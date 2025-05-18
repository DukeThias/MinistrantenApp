using Microsoft.EntityFrameworkCore;
using Server.Data;
using Server.Models;

namespace Server.Services
{
    public class TermineService
    {
        private readonly AppDbContext _db;

        public TermineService(AppDbContext db)
        {
            _db = db;
        }

        public async Task<List<Termin>> GetAllTermineAsync()
            => await _db.Termine.ToListAsync();

        public async Task<Termin?> GetTerminByIdAsync(int id)
            => await _db.Termine.FindAsync(id);

        public async Task AddTerminAsync(Termin termin)
        {
            await _db.Termine.AddAsync(termin);
            await _db.SaveChangesAsync();
        }

        public async Task<bool> UpdateTerminAsync(int id, Termin updated)
        {
            var existing = await _db.Termine.FindAsync(id);
            if (existing == null) return false;

            existing.UpdateFrom(updated);
            await _db.SaveChangesAsync();
            return true;
        }

        public async Task DeleteTerminAsync(int id)
        {
            var termin = await _db.Termine.FindAsync(id);
            if (termin != null)
            {
                _db.Termine.Remove(termin);
                await _db.SaveChangesAsync();
            }
        }
    }
}