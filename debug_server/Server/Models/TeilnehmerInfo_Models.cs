using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Text.Json.Serialization;

namespace Server.Models
{
    public class TeilnehmerInfo
    {
        [Key]
        public int Id { get; set; }

        [Required]
        public int MinistrantId { get; set; }

        [Required]
        public string Rolle { get; set; } = string.Empty;

        // FK zu Termin
        public int TerminId { get; set; }

        [ForeignKey(nameof(TerminId))]
        [JsonIgnore]
        public Termin? Termin { get; set; }
    }
}
