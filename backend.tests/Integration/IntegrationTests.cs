using Xunit;
using TodoApi.Data;
using TodoApi.Models;
using TodoApi.Services;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Moq;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Claims;

namespace TodoApi.Tests.Integration;

public class TodoApiIntegrationTests : IDisposable
{
    private readonly TodoDbContext _context;
    private readonly JwtService _jwtService;

    public TodoApiIntegrationTests()
    {
        // Setup in-memory database
        var options = new DbContextOptionsBuilder<TodoDbContext>()
            .UseInMemoryDatabase(databaseName: Guid.NewGuid().ToString())
            .Options;

        _context = new TodoDbContext(options);
        _context.Database.EnsureCreated();

        // Setup JWT Service
        var configurationMock = new Mock<IConfiguration>();
        configurationMock
            .Setup(x => x["JWT:Secret"])
            .Returns("YourSuperSecretKeyThatIsAtLeast32CharactersLongForTestingPurposes!@#$%");

        _jwtService = new JwtService(configurationMock.Object);
    }

    [Fact]
    public void CreateUser_AndVerifyInDatabase()
    {
        // Arrange
        var user = new User
        {
            Email = "integration@example.com",
            Password = "hashedpassword",
            FirstName = "Integration",
            LastName = "Test"
        };

        // Act
        _context.Users.Add(user);
        _context.SaveChanges();

        // Assert
        var savedUser = _context.Users.FirstOrDefault(u => u.Email == "integration@example.com");
        Assert.NotNull(savedUser);
        Assert.Equal("Integration", savedUser.FirstName);
    }

    [Fact]
    public void CreateTodo_WithUser_AndVerifyRelationship()
    {
        // Arrange
        var user = new User
        {
            Email = "todouser@example.com",
            Password = "hashedpassword",
            FirstName = "Todo",
            LastName = "User"
        };

        _context.Users.Add(user);
        _context.SaveChanges();

        var todo = new TodoItem
        {
            Text = "Integration Test Todo",
            UserId = user.Id,
            CreatedAt = DateTime.UtcNow
        };

        // Act
        _context.TodoItems.Add(todo);
        _context.SaveChanges();

        // Assert
        var savedTodo = _context.TodoItems
            .Include(t => t.User)
            .FirstOrDefault(t => t.Text == "Integration Test Todo");

        Assert.NotNull(savedTodo);
        Assert.Equal(user.Id, savedTodo.UserId);
        Assert.NotNull(savedTodo.User);
        Assert.Equal("todouser@example.com", savedTodo.User.Email);
    }

    [Fact]
    public void UpdateTodo_VerifyChangesInDatabase()
    {
        // Arrange
        var user = new User
        {
            Email = "updatetest@example.com",
            Password = "hashedpassword",
            FirstName = "Update",
            LastName = "Test"
        };

        _context.Users.Add(user);
        _context.SaveChanges();

        var todo = new TodoItem
        {
            Text = "Original Text",
            UserId = user.Id,
            CreatedAt = DateTime.UtcNow,
            Completed = false
        };

        _context.TodoItems.Add(todo);
        _context.SaveChanges();

        // Act
        todo.Text = "Updated Text";
        todo.Completed = true;
        todo.UpdatedAt = DateTime.UtcNow;
        _context.SaveChanges();

        // Assert
        var updatedTodo = _context.TodoItems.FirstOrDefault(t => t.Id == todo.Id);
        Assert.NotNull(updatedTodo);
        Assert.Equal("Updated Text", updatedTodo.Text);
        Assert.True(updatedTodo.Completed);
        Assert.NotNull(updatedTodo.UpdatedAt);
    }

    [Fact]
    public void DeleteTodo_VerifyRemovedFromDatabase()
    {
        // Arrange
        var user = new User
        {
            Email = "deletetest@example.com",
            Password = "hashedpassword",
            FirstName = "Delete",
            LastName = "Test"
        };

        _context.Users.Add(user);
        _context.SaveChanges();

        var todo = new TodoItem
        {
            Text = "Todo To Delete",
            UserId = user.Id,
            CreatedAt = DateTime.UtcNow
        };

        _context.TodoItems.Add(todo);
        _context.SaveChanges();

        var todoId = todo.Id;

        // Act
        _context.TodoItems.Remove(todo);
        _context.SaveChanges();

        // Assert
        var deletedTodo = _context.TodoItems.FirstOrDefault(t => t.Id == todoId);
        Assert.Null(deletedTodo);
    }

    [Fact]
    public void UserCanHaveMultipleTodos()
    {
        // Arrange
        var user = new User
        {
            Email = "multitodo@example.com",
            Password = "hashedpassword",
            FirstName = "Multi",
            LastName = "Todo"
        };

        _context.Users.Add(user);
        _context.SaveChanges();

        // Act
        var todos = new List<TodoItem>
        {
            new TodoItem { Text = "Todo 1", UserId = user.Id, CreatedAt = DateTime.UtcNow },
            new TodoItem { Text = "Todo 2", UserId = user.Id, CreatedAt = DateTime.UtcNow },
            new TodoItem { Text = "Todo 3", UserId = user.Id, CreatedAt = DateTime.UtcNow }
        };

        _context.TodoItems.AddRange(todos);
        _context.SaveChanges();

        // Assert
        var userTodos = _context.TodoItems.Where(t => t.UserId == user.Id).ToList();
        Assert.Equal(3, userTodos.Count);
    }

    [Fact]
    public void DeleteUser_CascadeDeletesTodos()
    {
        // Arrange
        var user = new User
        {
            Email = "cascade@example.com",
            Password = "hashedpassword",
            FirstName = "Cascade",
            LastName = "Test"
        };

        _context.Users.Add(user);
        _context.SaveChanges();

        var todo = new TodoItem
        {
            Text = "Todo For Cascade",
            UserId = user.Id,
            CreatedAt = DateTime.UtcNow
        };

        _context.TodoItems.Add(todo);
        _context.SaveChanges();

        var userId = user.Id;
        var todoId = todo.Id;

        // Act
        _context.Users.Remove(user);
        _context.SaveChanges();

        // Assert
        var deletedUser = _context.Users.FirstOrDefault(u => u.Id == userId);
        var deletedTodo = _context.TodoItems.FirstOrDefault(t => t.Id == todoId);

        Assert.Null(deletedUser);
        Assert.Null(deletedTodo); // Cascade delete
    }

    [Fact]
    public void JwtToken_CreatedAndValidatedSuccessfully()
    {
        // Arrange
        var user = new User
        {
            Id = 1,
            Email = "jwt@example.com",
            Password = "hashedpassword",
            FirstName = "JWT",
            LastName = "Test"
        };

        // Act
        var token = _jwtService.GenerateToken(user);
        var principal = _jwtService.ValidateToken(token);

        // Assert
        Assert.NotNull(token);
        Assert.NotNull(principal);
        var emailClaim = principal.FindFirst(ClaimTypes.Email);
        Assert.Equal("jwt@example.com", emailClaim?.Value);
    }

    [Fact]
    public void UniqueEmailConstraint_CanCheckForDuplicates()
    {
        // Arrange
        var user1 = new User
        {
            Email = "unique@example.com",
            Password = "hashedpassword",
            FirstName = "User",
            LastName = "One"
        };

        _context.Users.Add(user1);
        _context.SaveChanges();

        // Act - Check if email already exists
        var existingEmail = "unique@example.com";
        var emailExists = _context.Users.Any(u => u.Email == existingEmail);

        // Assert
        Assert.True(emailExists, "Email should be found in database");
        
        // Act - Check for non-existing email
        var nonExistingEmail = "different@example.com";
        var emailDoesNotExist = _context.Users.Any(u => u.Email == nonExistingEmail);

        // Assert
        Assert.False(emailDoesNotExist, "Non-existing email should not be found");
    }

    public void Dispose()
    {
        _context?.Database.EnsureDeleted();
        _context?.Dispose();
    }
}
