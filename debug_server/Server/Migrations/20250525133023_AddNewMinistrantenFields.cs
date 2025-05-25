using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Server.Migrations
{
    /// <inheritdoc />
    public partial class AddNewMinistrantenFields : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<int>(
                name: "AbwesendCount",
                table: "Ministranten",
                type: "INTEGER",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.AddColumn<int>(
                name: "AnwesendCount",
                table: "Ministranten",
                type: "INTEGER",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.AddColumn<int>(
                name: "TauschCount",
                table: "Ministranten",
                type: "INTEGER",
                nullable: false,
                defaultValue: 0);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "AbwesendCount",
                table: "Ministranten");

            migrationBuilder.DropColumn(
                name: "AnwesendCount",
                table: "Ministranten");

            migrationBuilder.DropColumn(
                name: "TauschCount",
                table: "Ministranten");
        }
    }
}
