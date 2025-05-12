namespace Server.Models
{
    public class Nachricht
    {
        required public string Art { get; set; }
        required public string Inhalt { get; set; }
        required public DateTime Timestamp { get; set; }
    }
}
