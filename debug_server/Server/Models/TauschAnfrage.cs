namespace Server.Models
{
    public class TauschAnfrage
    {
        public int Id { get; set; }

        public int VonUserId { get; set; }
        public int AnUserId { get; set; }

        public int VonTerminId { get; set; }
        public int? GegentauschTerminId { get; set; }

        public string Status { get; set; } = "Offen"; // Offen, Gegenvorschlag, Bestätigt, Abgelehnt, Übernommen
        public DateTime Zeitstempel { get; set; } = DateTime.UtcNow;
    }
}
