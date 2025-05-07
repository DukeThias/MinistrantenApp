using Microsoft.EntityFrameworkCore;

public class AppDbContext : DbContext
{
    public DbSet<Person> Personen { get; set; }
    public DbSet<Termin> Termine { get; set; }

    public AppDbContext(DbContextOptions<AppDbContext> options) : base(options) { }
}
