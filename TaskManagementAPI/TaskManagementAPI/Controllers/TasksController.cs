using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.SignalR;
using Microsoft.EntityFrameworkCore;
using TaskManagementAPI.Data;
using Task = TaskManagementAPI.Models.Task;

namespace TaskManagementAPI.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class TasksController : ControllerBase
    {
        private readonly AppDbContext _context;
        private readonly IHubContext<TaskHub> _hubContext;

        public TasksController(AppDbContext context, IHubContext<TaskHub> hubContext)
        {
            _context = context;
            _hubContext = hubContext;
        }

        [HttpGet]
        public async Task<ActionResult<IEnumerable<Task>>> GetTasks()
        {
            return await _context.Tasks.Where(t => !t.IsDeleted).ToListAsync();
        }

        [HttpPost]
        public async Task<ActionResult<Task>> CreateTask(Task task)
        {
            task.CreatedAt = DateTime.UtcNow;
            _context.Tasks.Add(task);
            // Notificar  a los clientes
            await _hubContext.Clients.All.SendAsync("ReceiveTaskUpdate");
            await _context.SaveChangesAsync();
            return CreatedAtAction(nameof(GetTasks), new { id = task.Id }, task);
        }

        [HttpPut("{id}/complete")]
        public async Task<IActionResult> CompleteTask(int id)
        {
            var task = await _context.Tasks.FindAsync(id);
            if (task == null) return NotFound();

            task.IsCompleted = true;
            await _context.SaveChangesAsync();

            await _hubContext.Clients.All.SendAsync("ReceiveTaskUpdate");
            return NoContent();
        }

        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteTask(int id)
        {
            var task = await _context.Tasks.FindAsync(id);
            if (task == null) return NotFound();

            task.IsDeleted = true;

            await _hubContext.Clients.All.SendAsync("ReceiveTaskUpdate");
            await _context.SaveChangesAsync();
            return NoContent();
        }
    }
}