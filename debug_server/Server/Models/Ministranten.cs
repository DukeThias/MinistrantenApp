namespace Server.Models
{
    public class Ministranten
    {
        required public int Id { get; set; }
        required public string Vorname { get; set; }
        required public string Name { get; set; }
        required public string Username { get; set; }
        required public string Geschlecht { get; set; }
        required public DateTime Geburtsdatum { get; set; }
        required public string Adresse { get; set; }
        required public string Telefonnummer { get; set; }
        required public string Email { get; set; }
        required public string Gewandgroese { get; set; }
        required public int GemeindeID { get; set; }
        required public string Rolle { get; set; }
        required public string Vegan { get; set; }
        required public string Vegetarisch { get; set; }
        required public string Allergien { get; set; }
        required public string Bemerkungen { get; set; }
    }
}
