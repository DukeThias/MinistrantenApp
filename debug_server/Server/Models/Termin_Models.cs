using System.Text.Json;
using System.ComponentModel.DataAnnotations.Schema; // <--- hinzugefügt


namespace Server.Models
{
    public class Termin
    {
        required public int Id { get; set; }
        required public string Name { get; set; }
        required public string Beschreibung { get; set; }
        required public string Ort { get; set; }
        required public DateTime Start { get; set; }
        required public bool alle { get; set; }
        [NotMapped]
        public List<TeilnehmerInfo> Teilnehmer { get; set; } = new(); // TeilnehmerInfo muss als Klasse existieren!

        required public int GemeindeID { get; set; }//filter

        public static string TerminToJsonString(Termin termin){
            return JsonSerializer.Serialize(termin);
        }
        public static string TermineToJsonString(List<Termin> termine){
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