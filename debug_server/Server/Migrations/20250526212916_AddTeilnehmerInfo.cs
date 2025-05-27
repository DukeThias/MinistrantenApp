using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Server.Migrations
{
    /// <inheritdoc />
    public partial class AddTeilnehmerInfo : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Teilnehmer_Termine_TerminId1",
                table: "Teilnehmer");

            migrationBuilder.DropIndex(
                name: "IX_Teilnehmer_TerminId1",
                table: "Teilnehmer");

            migrationBuilder.DropColumn(
                name: "TerminId1",
                table: "Teilnehmer");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<int>(
                name: "TerminId1",
                table: "Teilnehmer",
                type: "INTEGER",
                nullable: true);

            migrationBuilder.CreateIndex(
                name: "IX_Teilnehmer_TerminId1",
                table: "Teilnehmer",
                column: "TerminId1");

            migrationBuilder.AddForeignKey(
                name: "FK_Teilnehmer_Termine_TerminId1",
                table: "Teilnehmer",
                column: "TerminId1",
                principalTable: "Termine",
                principalColumn: "Id");
        }
    }
}
