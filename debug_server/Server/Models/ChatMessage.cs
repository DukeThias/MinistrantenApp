namespace Server.Models{
    public class ChatMessage
{
    public int Id { get; set; }
    public int SenderId { get; set; }//filter
    public int ReceiverId { get; set; }//filter
    required public string MessageText { get; set; }
    public DateTime SentAt { get; set; }

   //required public Ministranten Sender { get; set; }
    //required public Ministranten Receiver { get; set; }
}

}