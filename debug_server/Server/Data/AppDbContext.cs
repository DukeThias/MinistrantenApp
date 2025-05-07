using Microsoft.EntityFrameworkCore;

namespace YourNamespace{
public class AppDbContext : DbContext
{
    public DbSet<Person> Personen { get; set; }
    public DbSet<Termin> Termine { get; set; }
    public DbSet<Gemeinden> Gemeinden { get; set; }

    public AppDbContext(DbContextOptions<AppDbContext> options) : base(options) { }
}
}