

namespace Server.Extensions
{
    public static class EndpointMappings
    {
        public static void MapApiEndpoints(this WebApplication app)
        {

            // Endpunkte für Ministranten auslagern
            app.MapMinistrantenEndpoints();

            // Endpunkte für Termine
            app.MapTermineEndpoints();

            // Endpunkte für Gemeinden
            app.MapGemeindenEndpoints();

            // Endpunkte für Nachrichten
            app.MapNachrichtenEndpoints();

            //Endpunkte für Upload
            app.MapUploadEndpoints();
        }
    }
}
