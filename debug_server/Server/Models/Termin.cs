using System.Text.Json;
namespace Server.Models
{
    public class Termin
    {
        required public int Id { get; set; }
        required public string Name { get; set; }
        required public string Beschreibung { get; set; }
        required public string Ort { get; set; }
        required public DateTime Start { get; set; }
        required public string Teilnehmer { get; set; }//filter ein bolean alle oder nicht alle 
        required public int GemeindeID { get; set; }//filter

        public static string TerminToJsonString(Termin termin){
            return JsonSerializer.Serialize(termin);
        }
        public static string TermineToJsonString(List<Termin> termine){
            return JsonSerializer.Serialize(termine);
        }
    }
}