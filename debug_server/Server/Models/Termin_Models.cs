using System.Text.Json;
using System.Text.Json.Serialization;
using System.ComponentModel.DataAnnotations;

namespace Server.Models
{
    public class Termin
    {
        [Key]
        public int Id { get; set; }

        [Required]
        public string Name { get; set; } = string.Empty;

        [Required]
        public string Beschreibung { get; set; } = string.Empty;

        [Required]
        public string Ort { get; set; } = string.Empty;

        [Required]
        public DateTime Start { get; set; }

        [Required]
        public bool alle { get; set; }

        // Teilnehmer mit JSON-Schutz gegen Rekursion
        public List<TeilnehmerInfo> Teilnehmer { get; set; } = new();

        [Required]
        public int GemeindeID { get; set; }

        public static string TerminToJsonString(Termin termin)
        {
            return JsonSerializer.Serialize(termin);
        }

        public static string TermineToJsonString(List<Termin> termine)
        {
            return JsonSerializer.Serialize(termine);
        }

        public void UpdateFrom(Termin updated)
        {
            Name = updated.Name;
            Beschreibung = updated.Beschreibung;
            Ort = updated.Ort;
            Start = updated.Start;
            Teilnehmer = updated.Teilnehmer;
            alle = updated.alle;
            GemeindeID = updated.GemeindeID;
        }
    }
}
