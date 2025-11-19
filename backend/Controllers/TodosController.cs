using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Security.Claims;
using TodoApi.Data;
using TodoApi.DTOs;
using TodoApi.Models;

namespace TodoApi.Controllers;

[ApiController]
[Route("api/[controller]")]
[Authorize]
public class TodosController : ControllerBase
{
    private readonly TodoDbContext _context;

    public TodosController(TodoDbContext context)
    {
        _context = context;
    }

    private int GetCurrentUserId()
    {
        var userIdClaim = User.FindFirst(ClaimTypes.NameIdentifier)?.Value;
        if (int.TryParse(userIdClaim, out int userId))
        {
            return userId;
        }
        throw new UnauthorizedAccessException("Invalid user ID");
    }

    [HttpGet]
    public async Task<ActionResult<List<TodoDto>>> GetTodos()
    {
        var userId = GetCurrentUserId();

        var todos = await _context.TodoItems
            .Where(t => t.UserId == userId)
            .OrderByDescending(t => t.CreatedAt)
            .Select(t => new TodoDto
            {
                Id = t.Id,
                Text = t.Text,
                Completed = t.Completed,
                CreatedAt = t.CreatedAt,
                UpdatedAt = t.UpdatedAt,
                UserId = t.UserId
            })
            .ToListAsync();

        return Ok(todos);
    }

    [HttpPost]
    public async Task<ActionResult<TodoDto>> CreateTodo(CreateTodoDto createTodoDto)
    {
        var userId = GetCurrentUserId();

        var todo = new TodoItem
        {
            Text = createTodoDto.Text,
            UserId = userId,
            CreatedAt = DateTime.UtcNow
        };

        _context.TodoItems.Add(todo);
        await _context.SaveChangesAsync();

        var todoDto = new TodoDto
        {
            Id = todo.Id,
            Text = todo.Text,
            Completed = todo.Completed,
            CreatedAt = todo.CreatedAt,
            UpdatedAt = todo.UpdatedAt,
            UserId = todo.UserId
        };

        return CreatedAtAction(nameof(GetTodo), new { id = todo.Id }, todoDto);
    }

    [HttpGet("{id}")]
    public async Task<ActionResult<TodoDto>> GetTodo(int id)
    {
        var userId = GetCurrentUserId();

        var todo = await _context.TodoItems
            .Where(t => t.Id == id && t.UserId == userId)
            .Select(t => new TodoDto
            {
                Id = t.Id,
                Text = t.Text,
                Completed = t.Completed,
                CreatedAt = t.CreatedAt,
                UpdatedAt = t.UpdatedAt,
                UserId = t.UserId
            })
            .FirstOrDefaultAsync();

        if (todo == null)
        {
            return NotFound();
        }

        return Ok(todo);
    }

    [HttpPut("{id}")]
    public async Task<ActionResult<TodoDto>> UpdateTodo(int id, UpdateTodoDto updateTodoDto)
    {
        var userId = GetCurrentUserId();

        var todo = await _context.TodoItems
            .FirstOrDefaultAsync(t => t.Id == id && t.UserId == userId);

        if (todo == null)
        {
            return NotFound();
        }

        todo.Text = updateTodoDto.Text;
        todo.Completed = updateTodoDto.Completed;
        todo.UpdatedAt = DateTime.UtcNow;

        await _context.SaveChangesAsync();

        var todoDto = new TodoDto
        {
            Id = todo.Id,
            Text = todo.Text,
            Completed = todo.Completed,
            CreatedAt = todo.CreatedAt,
            UpdatedAt = todo.UpdatedAt,
            UserId = todo.UserId
        };

        return Ok(todoDto);
    }

    [HttpDelete("{id}")]
    public async Task<IActionResult> DeleteTodo(int id)
    {
        var userId = GetCurrentUserId();

        var todo = await _context.TodoItems
            .FirstOrDefaultAsync(t => t.Id == id && t.UserId == userId);

        if (todo == null)
        {
            return NotFound();
        }

        _context.TodoItems.Remove(todo);
        await _context.SaveChangesAsync();

        return NoContent();
    }

    [HttpPut("{id}/toggle")]
    public async Task<ActionResult<TodoDto>> ToggleTodo(int id)
    {
        var userId = GetCurrentUserId();

        var todo = await _context.TodoItems
            .FirstOrDefaultAsync(t => t.Id == id && t.UserId == userId);

        if (todo == null)
        {
            return NotFound();
        }

        todo.Completed = !todo.Completed;
        todo.UpdatedAt = DateTime.UtcNow;

        await _context.SaveChangesAsync();

        var todoDto = new TodoDto
        {
            Id = todo.Id,
            Text = todo.Text,
            Completed = todo.Completed,
            CreatedAt = todo.CreatedAt,
            UpdatedAt = todo.UpdatedAt,
            UserId = todo.UserId
        };

        return Ok(todoDto);
    }
}
