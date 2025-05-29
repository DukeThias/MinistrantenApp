using Microsoft.EntityFrameworkCore;
using Server.Data;
using Server.Models;

namespace Server.Services
{
    public class TauschService
    {
        private readonly AppDbContext _db;

        public TauschService(AppDbContext db)
        {
            _db = db;
        }

        public async Task<TauschAnfrage> StarteTauschAsync(TauschAnfrage anfrage)
        {
            var termin = await _db.Termine
                .Include(t => t.Teilnehmer)
                .FirstOrDefaultAsync(t => t.Id == anfrage.VonTerminId);

            if (termin == null)
                throw new Exception("Termin nicht gefunden.");

            var vonTeilnehmer = termin.Teilnehmer.FirstOrDefault(t => t.MinistrantId == anfrage.VonUserId);
            if (vonTeilnehmer == null)
                throw new Exception("Du bist für diesen Termin nicht eingeteilt.");

            var anEingeteilt = termin.Teilnehmer.Any(t => t.MinistrantId == anfrage.AnUserId);
            if (anEingeteilt)
                throw new Exception("Die angefragte Person ist bereits eingeteilt.");

            var gleicheRolle = await _db.TeilnehmerInfos
                .Where(t => t.MinistrantId == anfrage.AnUserId && t.TerminId != anfrage.VonTerminId)
                .Select(t => t.Rolle.ToLower())
                .Distinct()
                .ToListAsync();

            if (!gleicheRolle.Contains(vonTeilnehmer.Rolle.ToLower()))
                throw new Exception("Beide Personen müssen die gleiche Rolle haben.");

            anfrage.Status = "Offen";
            anfrage.Zeitstempel = DateTime.UtcNow;
            _db.TauschAnfragen.Add(anfrage);
            await _db.SaveChangesAsync();
            return anfrage;
        }

        public async Task<TauschAnfrage?> AntworteAufTauschAsync(int anfrageId, string status, int? gegentauschTerminId)
        {
            var anfrage = await _db.TauschAnfragen.FindAsync(anfrageId);
            if (anfrage == null) return null;

            if (status == "Gegenvorschlag")
            {
                if (!gegentauschTerminId.HasValue)
                    throw new Exception("Gegentausch-Termin muss angegeben werden.");

                var gegentermin = await _db.Termine
                    .Include(t => t.Teilnehmer)
                    .FirstOrDefaultAsync(t => t.Id == gegentauschTerminId.Value);

                if (gegentermin == null)
                    throw new Exception("Gegentausch-Termin nicht gefunden.");

                var anUserEingeteilt = gegentermin.Teilnehmer.FirstOrDefault(t => t.MinistrantId == anfrage.AnUserId);
                var vonUserEingeteilt = gegentermin.Teilnehmer.Any(t => t.MinistrantId == anfrage.VonUserId);

                if (anUserEingeteilt == null)
                    throw new Exception("Du bist nicht für den Gegentausch-Termin eingeteilt.");
                if (vonUserEingeteilt)
                    throw new Exception("Der ursprüngliche Anfragende ist beim Gegentausch-Termin bereits eingeteilt.");

                var ursprTermin = await _db.Termine
                    .Include(t => t.Teilnehmer)
                    .FirstOrDefaultAsync(t => t.Id == anfrage.VonTerminId);

                var ursprTeiln = ursprTermin?.Teilnehmer.FirstOrDefault(t => t.MinistrantId == anfrage.VonUserId);

                if (ursprTeiln == null || anUserEingeteilt.Rolle.ToLower() != ursprTeiln.Rolle.ToLower())
                    throw new Exception("Die Rolle muss beim Gegentausch übereinstimmen.");
            }

            anfrage.Status = status;
            anfrage.GegentauschTerminId = gegentauschTerminId;

            if (status == "Bestätigt")
            {
                var ursprTermin = await _db.Termine
                    .Include(t => t.Teilnehmer)
                    .FirstOrDefaultAsync(t => t.Id == anfrage.VonTerminId);

                var gegentermin = anfrage.GegentauschTerminId.HasValue
                    ? await _db.Termine.Include(t => t.Teilnehmer)
                        .FirstOrDefaultAsync(t => t.Id == anfrage.GegentauschTerminId.Value)
                    : null;

                if (ursprTermin != null && gegentermin != null)
                {
                    var vonTeiln = ursprTermin.Teilnehmer.FirstOrDefault(t => t.MinistrantId == anfrage.VonUserId);
                    var anTeiln = gegentermin.Teilnehmer.FirstOrDefault(t => t.MinistrantId == anfrage.AnUserId);

                    if (vonTeiln != null && anTeiln != null)
                    {
                        var rolleA = vonTeiln.Rolle;
                        var rolleB = anTeiln.Rolle;

                        ursprTermin.Teilnehmer.Remove(vonTeiln);
                        gegentermin.Teilnehmer.Remove(anTeiln);

                        ursprTermin.Teilnehmer.Add(new TeilnehmerInfo
                        {
                            MinistrantId = anfrage.AnUserId,
                            Rolle = rolleA
                        });

                        gegentermin.Teilnehmer.Add(new TeilnehmerInfo
                        {
                            MinistrantId = anfrage.VonUserId,
                            Rolle = rolleB
                        });
                    }
                }

                var uebernehmer = await _db.Ministranten.FindAsync(anfrage.AnUserId);
                if (uebernehmer != null)
                {
                    uebernehmer.TauschCount += 1;
                }
            }

            if (status == "Übernommen")
            {
                var uebernehmer = await _db.Ministranten.FindAsync(anfrage.AnUserId);
                if (uebernehmer != null)
                {
                    uebernehmer.TauschCount += 1;
                }

                var ursprTermin = await _db.Termine
                    .Include(t => t.Teilnehmer)
                    .FirstOrDefaultAsync(t => t.Id == anfrage.VonTerminId);

                var vonTeiln = ursprTermin?.Teilnehmer.FirstOrDefault(t => t.MinistrantId == anfrage.VonUserId);
                if (ursprTermin != null && vonTeiln != null)
                {
                    ursprTermin.Teilnehmer.Remove(vonTeiln);

                    ursprTermin.Teilnehmer.Add(new TeilnehmerInfo
                    {
                        MinistrantId = anfrage.AnUserId,
                        Rolle = vonTeiln.Rolle
                    });
                }
            }

            await _db.SaveChangesAsync();
            return anfrage;
        }

        public async Task<List<TauschAnfrage>> GetAnfragenFuerUserAsync(int userId)
        {
            return await _db.TauschAnfragen
                .Where(a => a.VonUserId == userId || a.AnUserId == userId)
                .OrderByDescending(a => a.Zeitstempel)
                .ToListAsync();
        }

        public async Task<bool> UebernehmeDienstAsync(int anfrageId, int neuerMinistrantId)
        {
            var anfrage = await _db.TauschAnfragen.FindAsync(anfrageId);
            if (anfrage == null) return false;

            if (anfrage.Status != "Offen") return false;

            anfrage.Status = "Übernommen";
            anfrage.AnUserId = neuerMinistrantId;

            var termin = await _db.Termine
                .Include(t => t.Teilnehmer)
                .FirstOrDefaultAsync(t => t.Id == anfrage.VonTerminId);

            var originalTeilnehmer = termin?.Teilnehmer.FirstOrDefault(t => t.MinistrantId == anfrage.VonUserId);
            if (termin == null || originalTeilnehmer == null) return false;

            termin.Teilnehmer.Remove(originalTeilnehmer);
            termin.Teilnehmer.Add(new TeilnehmerInfo
            {
                MinistrantId = neuerMinistrantId,
                Rolle = originalTeilnehmer.Rolle
            });

            var ministrant = await _db.Ministranten.FindAsync(neuerMinistrantId);
            if (ministrant != null)
            {
                ministrant.TauschCount += 1;
            }

            await _db.SaveChangesAsync();
            return true;
        }
    }
}
