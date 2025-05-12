namespace Server.Models
{
    public class Nachrichten
    {
        required public string Art { get; set; }
        required public string Inhalt { get; set; }
        required public DateTime Timestamp { get; set; }
    }
}
