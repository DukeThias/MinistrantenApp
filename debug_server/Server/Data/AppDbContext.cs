using Microsoft.EntityFrameworkCore;
using Server.Models;

namespace Server.Data
{
    public class AppDbContext : DbContext
    {
        public DbSet<Ministranten> Ministranten { get; set; }
        public DbSet<Termin> Termine { get; set; }
        public DbSet<TeilnehmerInfo> Teilnehmer { get; set; }
        public DbSet<Gemeinden> Gemeinden { get; set; }
        public DbSet<Nachrichten> Nachrichten { get; set; }
        public DbSet<TauschAnfrage> TauschAnfragen { get; set; }

        public AppDbContext(DbContextOptions<AppDbContext> options) : base(options) { }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<Ministranten>()
                .Property(m => m.Rolle);

            modelBuilder.Entity<Termin>()
                .HasMany(t => t.Teilnehmer)
                .WithOne(p => p.Termin!)
                .HasForeignKey(p => p.TerminId)
                .OnDelete(DeleteBehavior.Cascade);
        }
    }
}
