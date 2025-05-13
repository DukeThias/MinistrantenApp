

namespace Server.Models
{
    public class Ministranten
    {
        public int Id { get; set; }
        public string? Vorname { get; set; }
        public string? Name { get; set; }
        public string? Username { get; set; }
        public string? Passwort { get; set; }
        public string? Geschlecht { get; set; }
        public DateTime Geburtsdatum { get; set; }
        public string? Adresse { get; set; }
        public string? Telefonnummer { get; set; }
        public string? Email { get; set; }
        public int Gewandgroese { get; set; }
        public int GemeindeID { get; set; }
        public int GruppenID { get; set; }
        public List<string> Rolle { get; set; } = new();
        public int Einweihungsjahr { get; set; }
        public bool Vegan { get; set; }
        public bool Vegetarisch { get; set; }
        public string? Allergien { get; set; }
        public string? Bemerkungen { get; set; }

        // Methode zum Aktualisieren mit einem anderen Objekt
        public void UpdateFrom(Ministranten other)
        {
            Vorname = other.Vorname;
            Name = other.Name;
            Username = other.Username;
            Passwort = other.Passwort;
            Geschlecht = other.Geschlecht;
            Geburtsdatum = other.Geburtsdatum;
            Adresse = other.Adresse;
            Telefonnummer = other.Telefonnummer;
            Email = other.Email;
            Gewandgroese = other.Gewandgroese;
            GemeindeID = other.GemeindeID;
            GruppenID = other.GruppenID;
            Rolle = new List<string>(other.Rolle);
            Einweihungsjahr = other.Einweihungsjahr;
            Vegan = other.Vegan;
            Vegetarisch = other.Vegetarisch;
            Allergien = other.Allergien;
            Bemerkungen = other.Bemerkungen;
        }
    }
}
