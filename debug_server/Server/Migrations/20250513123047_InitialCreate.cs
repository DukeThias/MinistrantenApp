using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Server.Migrations
{
    /// <inheritdoc />
    public partial class InitialCreate : Migration
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
                    Vorname = table.Column<string>(type: "TEXT", nullable: true),
                    Name = table.Column<string>(type: "TEXT", nullable: true),
                    Username = table.Column<string>(type: "TEXT", nullable: true),
                    Passwort = table.Column<string>(type: "TEXT", nullable: true),
                    Geschlecht = table.Column<string>(type: "TEXT", nullable: true),
                    Geburtsdatum = table.Column<DateTime>(type: "TEXT", nullable: false),
                    Adresse = table.Column<string>(type: "TEXT", nullable: true),
                    Telefonnummer = table.Column<string>(type: "TEXT", nullable: true),
                    Email = table.Column<string>(type: "TEXT", nullable: true),
                    Gewandgroese = table.Column<int>(type: "INTEGER", nullable: false),
                    GemeindeID = table.Column<int>(type: "INTEGER", nullable: false),
                    Rolle = table.Column<string>(type: "TEXT", nullable: false),
                    Vegan = table.Column<bool>(type: "INTEGER", nullable: false),
                    Vegetarisch = table.Column<bool>(type: "INTEGER", nullable: false),
                    Allergien = table.Column<string>(type: "TEXT", nullable: true),
                    Bemerkungen = table.Column<string>(type: "TEXT", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Ministranten", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "Nachrichten",
                columns: table => new
                {
                    Id = table.Column<int>(type: "INTEGER", nullable: false)
                        .Annotation("Sqlite:Autoincrement", true),
                    art = table.Column<string>(type: "TEXT", nullable: true),
                    inhalt = table.Column<string>(type: "TEXT", nullable: true),
                    timestamp = table.Column<DateTime>(type: "TEXT", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Nachrichten", x => x.Id);
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
                name: "Nachrichten");

            migrationBuilder.DropTable(
                name: "Termine");
        }
    }
}
