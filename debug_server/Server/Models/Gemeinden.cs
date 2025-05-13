namespace Server.Models
{
    public class Gemeinden
    {
        required public string Name { get; set; }
        required public string Kuerzel { get; set; }
        required public int Id { get; set; }


        public void UpdateFrom(Gemeinden updated)

        {

            Name = updated.Name;

            Kuerzel = updated.Kuerzel;

            Id = updated.Id;

        }
    }
}