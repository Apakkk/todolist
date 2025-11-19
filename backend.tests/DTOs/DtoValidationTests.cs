using Xunit;
using TodoApi.DTOs;
using System;
using System.ComponentModel.DataAnnotations;
using System.Collections.Generic;

namespace TodoApi.Tests.DTOs;

public class TodoDtoValidationTests
{
    private List<ValidationResult> ValidateDto<T>(T dto)
    {
        var context = new ValidationContext(dto);
        var results = new List<ValidationResult>();
        Validator.TryValidateObject(dto, context, results, validateAllProperties: true);
        return results;
    }

    [Fact]
    public void CreateTodoDto_WithValidText_ShouldPassValidation()
    {
        // Arrange
        var dto = new CreateTodoDto { Text = "Valid todo text" };

        // Act
        var results = ValidateDto(dto);

        // Assert
        Assert.Empty(results);
    }

    [Fact]
    public void CreateTodoDto_WithEmptyText_ShouldFailValidation()
    {
        // Arrange
        var dto = new CreateTodoDto { Text = string.Empty };

        // Act
        var results = ValidateDto(dto);

        // Assert
        Assert.NotEmpty(results);
    }

    [Fact]
    public void CreateTodoDto_WithTextExceedingMaxLength_ShouldFailValidation()
    {
        // Arrange
        var dto = new CreateTodoDto { Text = new string('a', 1001) };

        // Act
        var results = ValidateDto(dto);

        // Assert
        Assert.NotEmpty(results);
    }

    [Fact]
    public void UpdateTodoDto_WithValidData_ShouldPassValidation()
    {
        // Arrange
        var dto = new UpdateTodoDto 
        { 
            Text = "Updated todo",
            Completed = true 
        };

        // Act
        var results = ValidateDto(dto);

        // Assert
        Assert.Empty(results);
    }

    [Fact]
    public void UpdateTodoDto_WithEmptyText_ShouldFailValidation()
    {
        // Arrange
        var dto = new UpdateTodoDto 
        { 
            Text = string.Empty,
            Completed = false 
        };

        // Act
        var results = ValidateDto(dto);

        // Assert
        Assert.NotEmpty(results);
    }

    [Fact]
    public void RegisterDto_WithValidData_ShouldPassValidation()
    {
        // Arrange
        var dto = new RegisterDto
        {
            Email = "test@example.com",
            Password = "ValidPassword123",
            FirstName = "John",
            LastName = "Doe"
        };

        // Act
        var results = ValidateDto(dto);

        // Assert
        Assert.Empty(results);
    }

    [Fact]
    public void RegisterDto_WithInvalidEmail_ShouldFailValidation()
    {
        // Arrange
        var dto = new RegisterDto
        {
            Email = "invalid-email",
            Password = "ValidPassword123",
            FirstName = "John",
            LastName = "Doe"
        };

        // Act
        var results = ValidateDto(dto);

        // Assert
        Assert.NotEmpty(results);
    }

    [Fact]
    public void RegisterDto_WithShortPassword_ShouldFailValidation()
    {
        // Arrange
        var dto = new RegisterDto
        {
            Email = "test@example.com",
            Password = "short",
            FirstName = "John",
            LastName = "Doe"
        };

        // Act
        var results = ValidateDto(dto);

        // Assert
        Assert.NotEmpty(results);
    }

    [Fact]
    public void RegisterDto_MissingFirstName_ShouldFailValidation()
    {
        // Arrange
        var dto = new RegisterDto
        {
            Email = "test@example.com",
            Password = "ValidPassword123",
            FirstName = string.Empty,
            LastName = "Doe"
        };

        // Act
        var results = ValidateDto(dto);

        // Assert
        Assert.NotEmpty(results);
    }

    [Fact]
    public void LoginDto_WithValidData_ShouldPassValidation()
    {
        // Arrange
        var dto = new LoginDto
        {
            Email = "test@example.com",
            Password = "Password123"
        };

        // Act
        var results = ValidateDto(dto);

        // Assert
        Assert.Empty(results);
    }

    [Fact]
    public void LoginDto_WithInvalidEmail_ShouldFailValidation()
    {
        // Arrange
        var dto = new LoginDto
        {
            Email = "invalid-email",
            Password = "Password123"
        };

        // Act
        var results = ValidateDto(dto);

        // Assert
        Assert.NotEmpty(results);
    }

    [Fact]
    public void TodoDto_CanBeCreatedWithAllProperties()
    {
        // Arrange & Act
        var dto = new TodoDto
        {
            Id = 1,
            Text = "Test todo",
            Completed = true,
            CreatedAt = DateTime.UtcNow,
            UpdatedAt = DateTime.UtcNow,
            UserId = 1
        };

        // Assert
        Assert.Equal(1, dto.Id);
        Assert.Equal("Test todo", dto.Text);
        Assert.True(dto.Completed);
        Assert.Equal(1, dto.UserId);
    }

    [Fact]
    public void AuthResponseDto_ContainsTokenAndUser()
    {
        // Arrange & Act
        var dto = new AuthResponseDto
        {
            Token = "test-token-123",
            User = new UserDto
            {
                Id = 1,
                Email = "user@example.com",
                FirstName = "John",
                LastName = "Doe"
            }
        };

        // Assert
        Assert.NotNull(dto.Token);
        Assert.Equal("test-token-123", dto.Token);
        Assert.NotNull(dto.User);
        Assert.Equal("user@example.com", dto.User.Email);
    }
}
