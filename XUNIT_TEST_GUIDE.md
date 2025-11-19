# 🧪 xUnit Test Guide - TodoList Application

Bu rehber, TodoList uygulamasında **xUnit** test framework'ünü kullanarak unit test'ler yazıp çalıştırmayı açıklamaktadır.

## 📦 xUnit Nedir?

xUnit, .NET için modern ve güçlü bir test framework'üdür. Özellikleri:
- ✅ Basit ve clean syntax
- ✅ Built-in test discovery
- ✅ Parallel test execution
- ✅ Rich assertion capabilities
- ✅ No test base classes required

## 🏗️ Test Projesi Yapısı

```
backend.tests/
├── DTOs/
│   └── DtoValidationTests.cs
├── Models/
│   └── ModelsTests.cs
├── Services/
│   └── JwtServiceTests.cs
├── Controllers/
│   └── (Placeholder for controller tests)
├── Integration/
│   └── (Placeholder for integration tests)
└── TodoApi.Tests.csproj
```

### Test Sayıları
- **DTO Validation Tests**: 12 tests
- **Model Tests**: 11 tests
- **Service Tests**: 6 tests
- **Toplam**: 29 tests

## 🚀 Test Çalıştırma

### 1. Tüm Testleri Çalıştır

```bash
cd backend.tests
dotnet test
```

**Beklenen Output:**
```
Test Run Successful.
Total tests: 29
Passed: 29
Duration: ~1-2s
```

### 2. Spesifik Test Class'ını Çalıştır

```bash
# DTO Tests
dotnet test --filter "ClassName=TodoApi.Tests.DTOs.TodoDtoValidationTests"

# Model Tests
dotnet test --filter "ClassName=TodoApi.Tests.Models.TodoItemTests"

# Service Tests
dotnet test --filter "ClassName=TodoApi.Tests.Services.JwtServiceTests"
```

### 3. Spesifik Bir Test'i Çalıştır

```bash
dotnet test --filter "Name=GenerateToken_WithValidUser_ReturnsValidToken"
```

### 4. Verbose Mode'da Çalıştır (Debug)

```bash
dotnet test -v detailed
```

### 5. Code Coverage Raporu Oluştur

```bash
dotnet test /p:CollectCoverage=true /p:CoverletOutputFormat=opencover
```

**Output:**
```
Coverage: 85%
Generated file: coverage.opencover.xml
```

## 📝 xUnit Test Yazımı

### Temel Yapı

```csharp
using Xunit;

public class MyTests
{
    [Fact]  // Parametresiz test
    public void TestName_Scenario_ExpectedResult()
    {
        // Arrange
        var data = SetupTestData();
        
        // Act
        var result = MyMethod(data);
        
        // Assert
        Assert.NotNull(result);
    }

    [Theory]  // Parametreli test
    [InlineData(1)]
    [InlineData(2)]
    public void ParameterizedTest(int value)
    {
        // Test code
    }
}
```

### Assertions Örnekleri

#### Equality
```csharp
Assert.Equal(expected, actual);
Assert.NotEqual(unexpected, actual);
```

#### Null Checks
```csharp
Assert.Null(nullValue);
Assert.NotNull(notNullValue);
```

#### Boolean Checks
```csharp
Assert.True(condition);
Assert.False(condition);
```

#### Collection Checks
```csharp
Assert.Empty(collection);
Assert.Single(collection);
Assert.Contains(expectedValue, collection);
Assert.Equal(expectedCount, collection.Count);
```

#### Exception Checks
```csharp
Assert.Throws<ArgumentException>(() => MyMethod());
```

#### String Checks
```csharp
Assert.StartsWith("prefix", text);
Assert.EndsWith("suffix", text);
Assert.Contains("substring", text);
```

### Test Naming Convention

Tüm test'ler bu format'ı takip eder:
```
MethodName_Scenario_ExpectedResult
```

**Örnekler:**
- `GenerateToken_WithValidUser_ReturnsValidToken`
- `CreateTodoDto_WithEmptyText_ShouldFailValidation`
- `User_CanHaveTodos_SuccessfullyAdded`

## 📊 Mevcut Test'ler

### 1. DtoValidationTests.cs

**Amaç**: DTO'ların validation attribute'larını test et

**Tests**:
```
✓ CreateTodoDto_WithValidText_ShouldPassValidation
✓ CreateTodoDto_WithEmptyText_ShouldFailValidation
✓ CreateTodoDto_WithTextExceedingMaxLength_ShouldFailValidation
✓ UpdateTodoDto_WithValidData_ShouldPassValidation
✓ UpdateTodoDto_WithEmptyText_ShouldFailValidation
✓ RegisterDto_WithValidData_ShouldPassValidation
✓ RegisterDto_WithInvalidEmail_ShouldFailValidation
✓ RegisterDto_WithShortPassword_ShouldFailValidation
✓ RegisterDto_MissingFirstName_ShouldFailValidation
✓ LoginDto_WithValidData_ShouldPassValidation
✓ LoginDto_WithInvalidEmail_ShouldFailValidation
✓ TodoDto + AuthResponseDto Property Tests
```

**Çalıştır**:
```bash
dotnet test --filter "DtoValidationTests"
```

### 2. ModelsTests.cs

**Amaç**: Entity Model'leri test et

**Tests**:
```
TodoItemTests:
✓ TodoItem_CreationWithValidData_ShouldSucceed
✓ TodoItem_DefaultCompletedStatus_ShouldBeFalse
✓ TodoItem_CanToggleCompletedStatus
✓ TodoItem_CanSetUpdatedAt
✓ TodoItem_CanAssociateWithUser
✓ TodoItem_CreatedAt_IsSet

UserTests:
✓ User_CreationWithValidData_ShouldSucceed
✓ User_CanHaveEmptyTodosList
✓ User_CanHaveTodos
✓ User_CanAddMultipleTodos
✓ User_CanRemoveTodo
✓ User_EmailPropertyIsRequired
✓ User_PasswordPropertyIsRequired
```

**Çalıştır**:
```bash
dotnet test --filter "ModelsTests"
```

### 3. JwtServiceTests.cs

**Amaç**: JWT Service'i test et

**Tests**:
```
✓ GenerateToken_WithValidUser_ReturnsValidToken
✓ GenerateToken_TokenCanBeValidated
✓ ValidateToken_WithInvalidToken_ReturnsNull
✓ GenerateToken_ContainsAllUserClaims
✓ GenerateToken_MultipleUsers_GenerateDifferentTokens
✓ ValidateToken_WithValidToken_ContainsEmailClaim
```

**Çalıştır**:
```bash
dotnet test --filter "JwtServiceTests"
```

## 🔧 Moq - Mocking Framework

Test'lerde external dependencies'i mock'lamak için Moq kullanıyoruz.

### Temel Örnek

```csharp
using Moq;

[Fact]
public void MyTest()
{
    // Mock oluştur
    var mockService = new Mock<IMyService>();
    
    // Setup
    mockService
        .Setup(s => s.GetUser(It.IsAny<int>()))
        .Returns(new User { Id = 1 });
    
    // Verify
    mockService.Verify(s => s.GetUser(It.IsAny<int>()), Times.Once);
}
```

### It.IsAny - Any Parameter Match

```csharp
mockService
    .Setup(s => s.DoSomething(It.IsAny<string>()))
    .Returns("result");
```

### Verify - Mock Çağrısını Doğrula

```csharp
// Verify once called
mockService.Verify(s => s.Method(), Times.Once);

// Verify never called
mockService.Verify(s => s.Method(), Times.Never);

// Verify called N times
mockService.Verify(s => s.Method(), Times.Exactly(3));
```

## 💡 xUnit Best Practices

### 1. Arrange-Act-Assert Pattern
```csharp
[Fact]
public void GoodTest()
{
    // Arrange
    var input = CreateTestInput();
    
    // Act
    var result = SystemUnderTest.Method(input);
    
    // Assert
    Assert.Equal(expected, result);
}
```

### 2. Descriptive Test Names
```csharp
// ✅ Good
[Fact]
public void GenerateToken_WithValidUser_ReturnsNonEmptyToken()
```

```csharp
// ❌ Bad
[Fact]
public void Test1()
```

### 3. Test Isolation
```csharp
// ✅ Each test is independent
[Fact]
public void Test1() { }

[Fact]
public void Test2() { }
```

### 4. One Assert Per Test (veya Related Asserts)
```csharp
// ✅ Good - related assertions
[Fact]
public void User_Creation_SetsAllProperties()
{
    var user = new User { Email = "test@test.com" };
    Assert.Equal("test@test.com", user.Email);
    Assert.NotNull(user);
}
```

### 5. Test Common and Edge Cases
```csharp
[Fact]
public void Method_WithValidInput_ReturnsResult() { }

[Fact]
public void Method_WithNullInput_ThrowsException() { }

[Fact]
public void Method_WithEmptyString_ReturnsEmpty() { }
```

## 📊 Coverage Report'ları

### Coverlet ile Coverage Oluştur

```bash
# Basic coverage
dotnet test /p:CollectCoverage=true

# OpenCover format
dotnet test /p:CollectCoverage=true /p:CoverletOutputFormat=opencover

# JSON format
dotnet test /p:CollectCoverage=true /p:CoverletOutputFormat=json

# Multiple formats
dotnet test /p:CollectCoverage=true /p:CoverletOutputFormat=\"json,opencover\"
```

### Coverage Dosyaları

Generated files:
- `coverage.json` - JSON format
- `coverage.opencover.xml` - OpenCover format

### Coverage Threshold

```bash
# Minimum %80 coverage
dotnet test /p:CollectCoverage=true /p:Threshold=80
```

## 🐛 Hata Giderme

### Test Bulunmuyor

```bash
# Test'leri discover et
dotnet test --list-tests

# Test adı hatalı mı kontrol et
dotnet test --filter "Name~YourTestName"
```

### Build Hatası

```bash
# Restore dependencies
dotnet restore

# Clean build
dotnet clean
dotnet build

# Build test project
cd backend.tests
dotnet build
```

### Mock Hatası

```csharp
// ❌ Yanlış - method returnu mock'lanamıyor
var mock = Mock.Of<IService>();

// ✅ Doğru
var mock = new Mock<IService>();
mock.Setup(s => s.Method()).Returns(value);
```

## 🔄 CI/CD Integration

### GitHub Actions Example

```yaml
name: xUnit Tests

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-dotnet@v3
        with:
          dotnet-version: '10.0'
      - run: cd backend.tests && dotnet test
      - run: dotnet test /p:CollectCoverage=true
      - name: Upload coverage
        uses: codecov/codecov-action@v3
```

## 📚 Useful Commands

```bash
# List all tests
dotnet test --list-tests

# Run specific category
dotnet test --filter "Category=UnitTest"

# Parallel execution (default behavior)
dotnet test

# Sequential execution
dotnet test --no-build -- RunInParallel=false

# Verbosity levels
dotnet test -v minimal
dotnet test -v normal
dotnet test -v detailed

# With output
dotnet test --logger "console;verbosity=detailed"
```

## 🎯 Coverage Goals

```
╔════════════════════╦════════════╗
║ Component          ║ Target     ║
╠════════════════════╬════════════╣
║ Models/DTOs        ║ 100%       ║
║ Services           ║ 95%+       ║
║ Controllers        ║ 90%+       ║
║ Overall            ║ 85%+       ║
╚════════════════════╩════════════╝
```

## ✅ Sonraki Adımlar

1. **Controller Tests Ekle** - TodosController ve AuthController
2. **Integration Tests Ekle** - Database operations
3. **Async Tests Ekle** - Async methods için
4. **Theory Tests Ekle** - Multiple data sets
5. **Coverage %85+ Hedefle**

## 📖 Kaynaklar

- [xUnit.net Documentation](https://xunit.net/)
- [xUnit.net GitHub](https://github.com/xunit/xunit)
- [Moq Documentation](https://github.com/Moq/moq4)
- [xUnit Best Practices](https://xunit.net/docs/getting-started/visual-studio)

---

**🎉 xUnit ile comprehensive test suite'i kurmuş olduk!**

Test çalıştırmak için:
```bash
cd backend.tests
dotnet test
```
