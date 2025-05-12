using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Server.Migrations
{
    /// <inheritdoc />
    public partial class AddMinistrantenTable : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "Gemeinden",
                columns: table => new
                {
                    Id = table.Column<int>(type: "INTEGER", nullable: false)
                        .Annotation("Sqlite:Autoincrement", true),
                    Name = table.Column<string>(type: "TEXT", nullable: false),
                    Kuerzel = table.Column<string>(type: "TEXT", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Gemeinden", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "Ministranten",
                columns: table => new
                {
                    Id = table.Column<int>(type: "INTEGER", nullable: false)
                        .Annotation("Sqlite:Autoincrement", true),
                    Name = table.Column<string>(type: "TEXT", nullable: false),
                    Vorname = table.Column<string>(type: "TEXT", nullable: false),
                    Geschlecht = table.Column<string>(type: "TEXT", nullable: false),
                    Geburtsdatum = table.Column<DateTime>(type: "TEXT", nullable: false),
                    Adresse = table.Column<string>(type: "TEXT", nullable: false),
                    Telefonnummer = table.Column<string>(type: "TEXT", nullable: false),
                    Email = table.Column<string>(type: "TEXT", nullable: false),
                    Gewandgroese = table.Column<string>(type: "TEXT", nullable: false),
                    GemeindeID = table.Column<int>(type: "INTEGER", nullable: false),
                    Rolle = table.Column<string>(type: "TEXT", nullable: false),
                    Vegan = table.Column<string>(type: "TEXT", nullable: false),
                    Vegetarisch = table.Column<string>(type: "TEXT", nullable: false),
                    Allergien = table.Column<string>(type: "TEXT", nullable: false),
                    Bemerkungen = table.Column<string>(type: "TEXT", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Ministranten", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "Termine",
                columns: table => new
                {
                    Id = table.Column<int>(type: "INTEGER", nullable: false)
                        .Annotation("Sqlite:Autoincrement", true),
                    Name = table.Column<string>(type: "TEXT", nullable: false),
                    Beschreibung = table.Column<string>(type: "TEXT", nullable: false),
                    Ort = table.Column<string>(type: "TEXT", nullable: false),
                    Start = table.Column<DateTime>(type: "TEXT", nullable: false),
                    Teilnehmer = table.Column<string>(type: "TEXT", nullable: false),
                    GemeindeID = table.Column<int>(type: "INTEGER", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Termine", x => x.Id);
                });
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "Gemeinden");

            migrationBuilder.DropTable(
                name: "Ministranten");

            migrationBuilder.DropTable(
                name: "Termine");
        }
    }
}
