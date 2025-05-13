namespace Server.Models
{
    public class Ministranten
    {
        public int Id { get; set; }
        public string? Vorname { get; set; }
        public string? Name { get; set; }
        public string? Username { get; set; }
        public string? Geschlecht { get; set; }
        public DateTime Geburtsdatum { get; set; }
        public string? Adresse { get; set; }
        public string? Telefonnummer { get; set; }
        public string? Email { get; set; }
        public string? Gewandgroese { get; set; }
        public int GemeindeID { get; set; }
        public string? Rolle { get; set; }
        public string? Vegan { get; set; }
        public string? Vegetarisch { get; set; }
        public string? Allergien { get; set; }
        public string? Bemerkungen { get; set; }
    }
}
