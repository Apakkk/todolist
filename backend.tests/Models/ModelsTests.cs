using Xunit;
using TodoApi.Models;
using System;
using System.Collections.Generic;
using System.Linq;

namespace TodoApi.Tests.Models;

public class TodoItemTests
{
    [Fact]
    public void TodoItem_CreationWithValidData_ShouldSucceed()
    {
        // Arrange & Act
        var todo = new TodoItem
        {
            Id = 1,
            Text = "Test todo",
            Completed = false,
            CreatedAt = DateTime.UtcNow,
            UserId = 1
        };

        // Assert
        Assert.Equal(1, todo.Id);
        Assert.Equal("Test todo", todo.Text);
        Assert.False(todo.Completed);
        Assert.Equal(1, todo.UserId);
    }

    [Fact]
    public void TodoItem_DefaultCompletedStatus_ShouldBeFalse()
    {
        // Arrange & Act
        var todo = new TodoItem
        {
            Text = "New todo",
            UserId = 1
        };

        // Assert
        Assert.False(todo.Completed);
    }

    [Fact]
    public void TodoItem_CanToggleCompletedStatus()
    {
        // Arrange
        var todo = new TodoItem
        {
            Text = "Test todo",
            Completed = false,
            UserId = 1
        };

        // Act
        todo.Completed = true;

        // Assert
        Assert.True(todo.Completed);
    }

    [Fact]
    public void TodoItem_CanSetUpdatedAt()
    {
        // Arrange
        var todo = new TodoItem
        {
            Text = "Test todo",
            UserId = 1,
            CreatedAt = DateTime.UtcNow
        };

        var updateTime = DateTime.UtcNow.AddHours(1);

        // Act
        todo.UpdatedAt = updateTime;

        // Assert
        Assert.NotNull(todo.UpdatedAt);
        Assert.Equal(updateTime, todo.UpdatedAt);
    }

    [Fact]
    public void TodoItem_CanAssociateWithUser()
    {
        // Arrange
        var user = new User
        {
            Id = 1,
            Email = "test@example.com",
            FirstName = "Test",
            LastName = "User",
            Password = "hashedpassword"
        };

        var todo = new TodoItem
        {
            Id = 1,
            Text = "Test todo",
            UserId = user.Id,
            User = user,
            CreatedAt = DateTime.UtcNow
        };

        // Assert
        Assert.NotNull(todo.User);
        Assert.Equal(user.Id, todo.UserId);
        Assert.Equal("test@example.com", todo.User.Email);
    }

    [Fact]
    public void TodoItem_CreatedAt_IsSet()
    {
        // Arrange
        var createdTime = DateTime.UtcNow;

        // Act
        var todo = new TodoItem
        {
            Text = "Test todo",
            UserId = 1,
            CreatedAt = createdTime
        };

        // Assert
        Assert.Equal(createdTime, todo.CreatedAt);
    }
}

public class UserTests
{
    [Fact]
    public void User_CreationWithValidData_ShouldSucceed()
    {
        // Arrange & Act
        var user = new User
        {
            Id = 1,
            Email = "test@example.com",
            FirstName = "John",
            LastName = "Doe",
            Password = "hashedpassword"
        };

        // Assert
        Assert.Equal(1, user.Id);
        Assert.Equal("test@example.com", user.Email);
        Assert.Equal("John", user.FirstName);
        Assert.Equal("Doe", user.LastName);
    }

    [Fact]
    public void User_CanHaveEmptyTodosList()
    {
        // Arrange & Act
        var user = new User
        {
            Id = 1,
            Email = "test@example.com",
            FirstName = "John",
            LastName = "Doe",
            Password = "hashedpassword",
            Todos = new List<TodoItem>()
        };

        // Assert
        Assert.NotNull(user.Todos);
        Assert.Empty(user.Todos);
    }

    [Fact]
    public void User_CanHaveTodos()
    {
        // Arrange
        var user = new User
        {
            Id = 1,
            Email = "test@example.com",
            FirstName = "John",
            LastName = "Doe",
            Password = "hashedpassword",
            Todos = new List<TodoItem>()
        };

        var todo = new TodoItem
        {
            Id = 1,
            Text = "Test todo",
            UserId = 1,
            CreatedAt = DateTime.UtcNow
        };

        // Act
        user.Todos.Add(todo);

        // Assert
        Assert.Single(user.Todos);
        Assert.Equal("Test todo", user.Todos.First().Text);
    }

    [Fact]
    public void User_CanAddMultipleTodos()
    {
        // Arrange
        var user = new User
        {
            Id = 1,
            Email = "test@example.com",
            FirstName = "John",
            LastName = "Doe",
            Password = "hashedpassword",
            Todos = new List<TodoItem>()
        };

        var todos = new List<TodoItem>
        {
            new TodoItem { Id = 1, Text = "Todo 1", UserId = 1, CreatedAt = DateTime.UtcNow },
            new TodoItem { Id = 2, Text = "Todo 2", UserId = 1, CreatedAt = DateTime.UtcNow },
            new TodoItem { Id = 3, Text = "Todo 3", UserId = 1, CreatedAt = DateTime.UtcNow }
        };

        // Act
        foreach (var todo in todos)
        {
            user.Todos.Add(todo);
        }

        // Assert
        Assert.Equal(3, user.Todos.Count);
    }

    [Fact]
    public void User_CanRemoveTodo()
    {
        // Arrange
        var user = new User
        {
            Id = 1,
            Email = "test@example.com",
            FirstName = "John",
            LastName = "Doe",
            Password = "hashedpassword",
            Todos = new List<TodoItem>()
        };

        var todo = new TodoItem
        {
            Id = 1,
            Text = "Test todo",
            UserId = 1,
            CreatedAt = DateTime.UtcNow
        };

        user.Todos.Add(todo);

        // Act
        user.Todos.Remove(todo);

        // Assert
        Assert.Empty(user.Todos);
    }

    [Fact]
    public void User_EmailPropertyIsRequired()
    {
        // Arrange & Act
        var user = new User
        {
            Id = 1,
            FirstName = "John",
            LastName = "Doe",
            Password = "hashedpassword",
            Email = "test@example.com"
        };

        // Assert
        Assert.NotNull(user.Email);
        Assert.NotEmpty(user.Email);
    }

    [Fact]
    public void User_PasswordPropertyIsRequired()
    {
        // Arrange & Act
        var user = new User
        {
            Id = 1,
            Email = "test@example.com",
            FirstName = "John",
            LastName = "Doe",
            Password = "hashedpassword"
        };

        // Assert
        Assert.NotNull(user.Password);
        Assert.NotEmpty(user.Password);
    }
}
