namespace Server.Models
{
    public class TauschAntwortDto
    {
        public int AnfrageId { get; set; } // Die ID der TauschAnfrage
        public string Status { get; set; } = "Abgelehnt"; // z. B. Gegenvorschlag, Bestätigt, Abgelehnt, Übernommen
        public int? GegentauschTerminId { get; set; } // Optional: Termin-ID bei Gegenvorschlag
    }
}
