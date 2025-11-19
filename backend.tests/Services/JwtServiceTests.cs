using Xunit;
using Moq;
using Microsoft.Extensions.Configuration;
using TodoApi.Services;
using TodoApi.Models;
using System.Security.Claims;

namespace TodoApi.Tests.Services;

public class JwtServiceTests
{
    private readonly JwtService _jwtService;
    private readonly Mock<IConfiguration> _configurationMock;

    public JwtServiceTests()
    {
        _configurationMock = new Mock<IConfiguration>();
        _configurationMock
            .Setup(x => x["JWT:Secret"])
            .Returns("YourSuperSecretKeyThatIsAtLeast32CharactersLongForTestingPurposes!@#$%");
        
        _jwtService = new JwtService(_configurationMock.Object);
    }

    [Fact]
    public void GenerateToken_WithValidUser_ReturnsValidToken()
    {
        // Arrange
        var user = new User
        {
            Id = 1,
            Email = "test@example.com",
            FirstName = "John",
            LastName = "Doe",
            Password = "hashedpassword"
        };

        // Act
        var token = _jwtService.GenerateToken(user);

        // Assert
        Assert.NotNull(token);
        Assert.NotEmpty(token);
        Assert.IsType<string>(token);
    }

    [Fact]
    public void GenerateToken_TokenCanBeValidated()
    {
        // Arrange
        var user = new User
        {
            Id = 1,
            Email = "test@example.com",
            FirstName = "John",
            LastName = "Doe",
            Password = "hashedpassword"
        };

        // Act
        var token = _jwtService.GenerateToken(user);
        var principal = _jwtService.ValidateToken(token);

        // Assert
        Assert.NotNull(principal);
        var userIdClaim = principal.FindFirst(ClaimTypes.NameIdentifier);
        Assert.NotNull(userIdClaim);
        Assert.Equal("1", userIdClaim.Value);
    }

    [Fact]
    public void ValidateToken_WithInvalidToken_ReturnsNull()
    {
        // Arrange
        var invalidToken = "invalid.token.here";

        // Act
        var principal = _jwtService.ValidateToken(invalidToken);

        // Assert
        Assert.Null(principal);
    }

    [Fact]
    public void GenerateToken_ContainsAllUserClaims()
    {
        // Arrange
        var user = new User
        {
            Id = 42,
            Email = "claims@example.com",
            FirstName = "Jane",
            LastName = "Smith",
            Password = "hashedpassword"
        };

        // Act
        var token = _jwtService.GenerateToken(user);
        var principal = _jwtService.ValidateToken(token);

        // Assert
        Assert.NotNull(principal);
        Assert.Equal("42", principal.FindFirst(ClaimTypes.NameIdentifier)?.Value);
        Assert.Equal("claims@example.com", principal.FindFirst(ClaimTypes.Email)?.Value);
        Assert.Equal("Jane", principal.FindFirst(ClaimTypes.GivenName)?.Value);
        Assert.Equal("Smith", principal.FindFirst(ClaimTypes.Surname)?.Value);
    }

    [Fact]
    public void GenerateToken_MultipleUsers_GenerateDifferentTokens()
    {
        // Arrange
        var user1 = new User
        {
            Id = 1,
            Email = "user1@example.com",
            FirstName = "User",
            LastName = "One",
            Password = "hashedpassword"
        };

        var user2 = new User
        {
            Id = 2,
            Email = "user2@example.com",
            FirstName = "User",
            LastName = "Two",
            Password = "hashedpassword"
        };

        // Act
        var token1 = _jwtService.GenerateToken(user1);
        var token2 = _jwtService.GenerateToken(user2);

        // Assert
        Assert.NotEqual(token1, token2);
    }

    [Fact]
    public void ValidateToken_WithValidToken_ContainsEmailClaim()
    {
        // Arrange
        var user = new User
        {
            Id = 5,
            Email = "email@example.com",
            FirstName = "Test",
            LastName = "User",
            Password = "hashedpassword"
        };

        // Act
        var token = _jwtService.GenerateToken(user);
        var principal = _jwtService.ValidateToken(token);

        // Assert
        Assert.NotNull(principal);
        var emailClaim = principal.FindFirst(ClaimTypes.Email);
        Assert.NotNull(emailClaim);
        Assert.Equal("email@example.com", emailClaim.Value);
    }
}
