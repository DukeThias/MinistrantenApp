namespace Server.Models
{
    public class Nachrichten
    {
        public int Id { get; set; }  // <- Primärschlüssel

        public string? Art { get; set; }
        public string? Inhalt { get; set; }
        public DateTime Timestamp { get; set; }
    }
}
