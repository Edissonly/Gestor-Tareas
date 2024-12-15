using Microsoft.EntityFrameworkCore;
using TaskManagementAPI.Data;

var builder = WebApplication.CreateBuilder(args);

// Agregar servicios 

builder.Services.AddDbContext<AppDbContext>(options =>
    options.UseNpgsql(builder.Configuration.GetConnectionString("DefaultConnection")));
builder.Services.AddControllers();
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

// Agregar SignalR
builder.Services.AddSignalR(); 

var app = builder.Build();

// Configuracion the HTTP 
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();

app.UseAuthorization();

app.UseCors(builder =>
    builder.WithOrigins("http://192.168.x.x:7001")
           .AllowAnyHeader()
           .AllowAnyMethod());


// Registrar los endpoints
app.MapControllers();
app.MapHub<TaskHub>("/taskHub");

app.Run();
