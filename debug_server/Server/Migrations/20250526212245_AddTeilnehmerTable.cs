using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Server.Migrations
{
    /// <inheritdoc />
    public partial class AddTeilnehmerTable : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "Teilnehmer",
                columns: table => new
                {
                    Id = table.Column<int>(type: "INTEGER", nullable: false)
                        .Annotation("Sqlite:Autoincrement", true),
                    MinistrantId = table.Column<int>(type: "INTEGER", nullable: false),
                    Rolle = table.Column<string>(type: "TEXT", nullable: false),
                    TerminId = table.Column<int>(type: "INTEGER", nullable: false),
                    TerminId1 = table.Column<int>(type: "INTEGER", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Teilnehmer", x => x.Id);
                    table.ForeignKey(
                        name: "FK_Teilnehmer_Termine_TerminId",
                        column: x => x.TerminId,
                        principalTable: "Termine",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_Teilnehmer_Termine_TerminId1",
                        column: x => x.TerminId1,
                        principalTable: "Termine",
                        principalColumn: "Id");
                });

            migrationBuilder.CreateIndex(
                name: "IX_Teilnehmer_TerminId",
                table: "Teilnehmer",
                column: "TerminId");

            migrationBuilder.CreateIndex(
                name: "IX_Teilnehmer_TerminId1",
                table: "Teilnehmer",
                column: "TerminId1");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "Teilnehmer");
        }
    }
}
