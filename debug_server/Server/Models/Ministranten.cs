using System;
using System.Collections.Generic;

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
        public int Gewandgroese { get; set; } // Korrekt als int
        public int GemeindeID { get; set; }
        public int GruppenID { get; set; }
        public List<string> Rolle { get; set; } = new(); // Muss als JSON gespeichert werden
        public bool Vegan { get; set; } // Korrekt als bool
        public bool Vegetarisch { get; set; } // Korrekt als bool
        public string? Allergien { get; set; }
        public string? Bemerkungen { get; set; }
    }
}
