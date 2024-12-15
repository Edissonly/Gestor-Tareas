using Microsoft.AspNetCore.SignalR;

public class TaskHub : Hub
{
    // Mensaje de actualización a los clientes
    public async Task SendTaskUpdate()
    {
        await Clients.All.SendAsync("ReceiveTaskUpdate");
    }
}
