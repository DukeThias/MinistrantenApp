using System.ComponentModel.DataAnnotations.Schema;

namespace Server.Models
{
    public class Ministranten
    {
        public int Id { get; set; }
        public string? Vorname { get; set; }
        public string? Name { get; set; }
        public string? Username { get; set; }//filter
        public string? Passwort { get; set; }
        public string? Geschlecht { get; set; }
        public DateTime Geburtsdatum { get; set; }
        public string? Adresse { get; set; }
        public string? Telefonnummer { get; set; }
        public string? Email { get; set; }
        public int Gewandgroese { get; set; }
        public int GemeindeID { get; set; }
        public int GruppenID { get; set; }
        public string Rolle { get; set; } = string.Empty; // <--- als String speichern!
        [NotMapped]
        public List<string> RollenListe => Rolle.Split(',', StringSplitOptions.RemoveEmptyEntries).ToList();
        public int Einweihungsjahr { get; set; }
        public bool Vegan { get; set; }//filter
        public bool Vegetarisch { get; set; }//filter
        public string? Allergien { get; set; }
        public string? Bemerkungen { get; set; }
        public int AnwesendCount { get; set; } // <--- Anwesend als int, um die Anzahl wie oft der Ministrant anwesend ist 
        public int AbwesendCount { get; set; } // <--- Abwesend als int, um die Anzahl wie oft der Ministrant abwesend ist
        public int TauschCount { get; set; } // <--- Tausch als int, um die Anzahl wie oft der Ministrant getauscht hat 
        public List<string> FmcToken { get; set; } = new();


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
            Rolle = other.Rolle; // <--- als String übernehmen!
            Einweihungsjahr = other.Einweihungsjahr;
            Vegan = other.Vegan;
            Vegetarisch = other.Vegetarisch;
            Allergien = other.Allergien;
            Bemerkungen = other.Bemerkungen;
            AnwesendCount = other.AnwesendCount;
            AbwesendCount = other.AbwesendCount;
            TauschCount = other.TauschCount;
        }
    }
}
