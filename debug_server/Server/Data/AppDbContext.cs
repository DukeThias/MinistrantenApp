using Microsoft.EntityFrameworkCore;
using Server.Models; // Für Person, Termin, Gemeinden

namespace Server.Data{
public class AppDbContext : DbContext
{
    public DbSet<Ministranten> Ministranten { get; set; }
    public DbSet<Termin> Termine { get; set; }
    public DbSet<Gemeinden> Gemeinden { get; set; }
    public DbSet<Nachrichten> Nachrichten { get; set; }
    public DbSet<TauschAnfrage> TauschAnfragen { get; set; }



    public AppDbContext(DbContextOptions<AppDbContext> options) : base(options) { }

    protected override void OnModelCreating(ModelBuilder modelBuilder)
{
    modelBuilder.Entity<Ministranten>()
        .Property(m => m.Rolle);
}

}
}