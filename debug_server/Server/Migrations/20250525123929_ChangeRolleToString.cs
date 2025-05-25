using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Server.Migrations
{
    /// <inheritdoc />
    public partial class ChangeRolleToString : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "ChatMessages");

            migrationBuilder.DropColumn(
                name: "Teilnehmer",
                table: "Termine");

            migrationBuilder.AddColumn<bool>(
                name: "alle",
                table: "Termine",
                type: "INTEGER",
                nullable: false,
                defaultValue: false);

            // Entferne oder kommentiere diese Zeile aus!
            // migrationBuilder.AddColumn<int>(
            //     name: "gemeindeId",
            //     table: "Nachrichten",
            //     nullable: false,
            //     defaultValue: 0);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "alle",
                table: "Termine");

            migrationBuilder.DropColumn(
                name: "gemeindeId",
                table: "Nachrichten");

            migrationBuilder.AddColumn<string>(
                name: "Teilnehmer",
                table: "Termine",
                type: "TEXT",
                nullable: false,
                defaultValue: "");

            migrationBuilder.CreateTable(
                name: "ChatMessages",
                columns: table => new
                {
                    Id = table.Column<int>(type: "INTEGER", nullable: false)
                        .Annotation("Sqlite:Autoincrement", true),
                    ReceiverId = table.Column<int>(type: "INTEGER", nullable: false),
                    SenderId = table.Column<int>(type: "INTEGER", nullable: false),
                    MessageText = table.Column<string>(type: "TEXT", nullable: false),
                    SentAt = table.Column<DateTime>(type: "TEXT", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_ChatMessages", x => x.Id);
                    table.ForeignKey(
                        name: "FK_ChatMessages_Ministranten_ReceiverId",
                        column: x => x.ReceiverId,
                        principalTable: "Ministranten",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_ChatMessages_Ministranten_SenderId",
                        column: x => x.SenderId,
                        principalTable: "Ministranten",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateIndex(
                name: "IX_ChatMessages_ReceiverId",
                table: "ChatMessages",
                column: "ReceiverId");

            migrationBuilder.CreateIndex(
                name: "IX_ChatMessages_SenderId",
                table: "ChatMessages",
                column: "SenderId");
        }
    }
}
