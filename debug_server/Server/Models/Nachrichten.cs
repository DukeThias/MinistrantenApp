namespace Server.Models
{
    public class Nachrichten
    {
        public int Id { get; set; }  // <- Primärschlüssel

        public string? art { get; set; }
        public string? inhalt { get; set; }
        public DateTime timestamp { get; set; } //gemeinde
    }
}
