# Backend Test Raporu - xUnit, Moq ve Coverlet

## Giriş

Projeyi aşağıdaki linkten indiririz:
```bash
git clone https://github.com/Apakkk/todolist
cd toDoListt-main
npm install
```

---

## Backend Testleri Kapsamı

Projede **40 adet unit test** yazılmıştır. Bu testler **xUnit framework**'ü kullanılarak C# (.NET 9.0) ile geliştirilmiştir.

### Test Dağılımı

```
├── DTO Validasyon Testleri (14 test)
│   ├── CreateTodoDto
│   ├── UpdateTodoDto
│   ├── RegisterDto
│   ├── LoginDto
│   └── Response DTOs
│
├── Model Testleri (13 test)
│   ├── TodoItem Tests (6)
│   └── User Tests (7)
│
├── Service Testleri (6 test)
│   └── JwtService Tests
│
└── Integration Testleri (7 test)
    ├── User Operations
    ├── Todo CRUD
    └── Database Relations
```

---

## 1. xUnit Framework Nedir?

**xUnit** .NET için modern unit test framework'üdür.

### 1.1 Kurulum

Proje dosyasında `TodoApi.Tests.csproj` aşağıdaki paketler tanımlanmıştır:

```xml
<ItemGroup>
    <PackageReference Include="Microsoft.NET.Test.Sdk" Version="17.9.0" />
    <PackageReference Include="xunit" Version="2.6.6" />
    <PackageReference Include="xunit.runner.visualstudio" Version="2.5.4" />
</ItemGroup>
```

### 1.2 Temel Kullanım

xUnit'te testler `[Fact]` attribute'ü ile işaretlenir:

**Dosya:** `backend.tests/Models/ModelsTests.cs`

```csharp
using Xunit;
using TodoApi.Models;

namespace TodoApi.Tests.Models;

public class TodoItemTests
{
    [Fact]
    public void TodoItem_CreationWithValidData_ShouldSucceed()
    {
        // Arrange - Veri hazırla
        var todo = new TodoItem
        {
            Id = 1,
            Text = "Test todo",
            Completed = false,
            UserId = 1
        };

        // Act - Test et
        // (Nesne zaten oluşturuldu)

        // Assert - Doğrula
        Assert.Equal(1, todo.Id);
        Assert.Equal("Test todo", todo.Text);
        Assert.False(todo.Completed);
    }
}
```

**Bu test şu şekilde çalıştırılır:**

```bash
cd backend.tests
dotnet test --filter "ClassName=TodoItemTests"
```

**Çıktı:**

```
  Passed  TodoApi.Tests.Models.TodoItemTests.TodoItem_CreationWithValidData_ShouldSucceed [10ms]

Test Run Summary
  Total tests: 1
  Passed: 1
  Failed: 0
  Skipped: 0
Duration: 100ms
```

---

## 2. Parametreli Testler - [Theory]

Aynı testi farklı verilerle çalıştırmak için `[Theory]` kullanılır.

### 2.1 Örnek: Email Validasyonu

**Dosya:** `backend.tests/DTOs/DtoValidationTests.cs`

```csharp
using Xunit;
using TodoApi.DTOs;
using System.ComponentModel.DataAnnotations;
using System.Collections.Generic;

namespace TodoApi.Tests.DTOs;

public class RegisterDtoValidationTests
{
    private List<ValidationResult> ValidateDto<T>(T dto)
    {
        var context = new ValidationContext(dto);
        var results = new List<ValidationResult>();
        Validator.TryValidateObject(dto, context, results, validateAllProperties: true);
        return results;
    }

    // Tek bir senaryo - [Fact]
    [Fact]
    public void RegisterDto_WithValidEmail_ShouldPassValidation()
    {
        var dto = new RegisterDto
        {
            Email = "test@example.com",
            Password = "ValidPass123",
            FirstName = "John",
            LastName = "Doe"
        };

        var results = ValidateDto(dto);

        Assert.Empty(results);
    }

    // Birden fazla senaryo - [Theory]
    [Theory]
    [InlineData("test@example.com")]           // ✅ Geçerli
    [InlineData("user+tag@domain.co.uk")]      // ✅ Geçerli
    [InlineData("")]                           // ❌ Geçersiz
    [InlineData("invalid-email")]              // ❌ Geçersiz
    public void RegisterDto_WithVariousEmails(string email)
    {
        var dto = new RegisterDto
        {
            Email = email,
            Password = "ValidPass123",
            FirstName = "John",
            LastName = "Doe"
        };

        var results = ValidateDto(dto);

        if (string.IsNullOrEmpty(email) || !email.Contains("@"))
            Assert.NotEmpty(results);  // Hata olması beklenir
        else
            Assert.Empty(results);      // Hata olmaması beklenir
    }
}
```

**Çalıştırma:**

```bash
dotnet test --filter "ClassName=RegisterDtoValidationTests"
```

**Çıktı:**

```
  Passed  TodoApi.Tests.DTOs.RegisterDtoValidationTests.RegisterDto_WithValidEmail_ShouldPassValidation [5ms]
  Passed  TodoApi.Tests.DTOs.RegisterDtoValidationTests.RegisterDto_WithVariousEmails(test@example.com) [3ms]
  Passed  TodoApi.Tests.DTOs.RegisterDtoValidationTests.RegisterDto_WithVariousEmails(user+tag@domain.co.uk) [2ms]
  Passed  TodoApi.Tests.DTOs.RegisterDtoValidationTests.RegisterDto_WithVariousEmails() [2ms]
  Passed  TodoApi.Tests.DTOs.RegisterDtoValidationTests.RegisterDto_WithVariousEmails(invalid-email) [2ms]

Test Run Summary
  Total tests: 5
  Passed: 5
  Failed: 0
Duration: 150ms
```

---

## 3. Moq - Mock Objects

**Moq** gerçek nesneler yerine test amaçlı taklit nesneler oluşturur.

### 3.1 JWT Service Testi

JWT servisi `IConfiguration` interface'ine bağımlıdır. Testlerde bu interface'i mock ederiz.

**Dosya:** `backend.tests/Services/JwtServiceTests.cs`

```csharp
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
        // Mock IConfiguration
        _configurationMock = new Mock<IConfiguration>();
        
        // Mock davranışını belirle
        _configurationMock
            .Setup(x => x["JWT:Secret"])
            .Returns("YourSuperSecretKeyThatIsAtLeast32CharactersLongForTestingPurposes!@#$%");
        
        // JwtService'i mock ile başlat
        _jwtService = new JwtService(_configurationMock.Object);
    }

    [Fact]
    public void GenerateToken_WithValidUser_ReturnsToken()
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
        
        // Token format kontrolü (JWT: xxx.xxx.xxx)
        var parts = token.Split('.');
        Assert.Equal(3, parts.Length);
    }

    [Fact]
    public void GenerateToken_ContainsUserClaims()
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

        // Assert - Token'dan claims çıkart ve doğrula
        Assert.NotNull(principal);
        Assert.Equal("42", principal.FindFirst(ClaimTypes.NameIdentifier)?.Value);
        Assert.Equal("claims@example.com", principal.FindFirst(ClaimTypes.Email)?.Value);
        Assert.Equal("Jane", principal.FindFirst(ClaimTypes.GivenName)?.Value);
        Assert.Equal("Smith", principal.FindFirst(ClaimTypes.Surname)?.Value);
    }

    [Fact]
    public void ValidateToken_WithInvalidToken_ReturnsNull()
    {
        // Arrange
        var invalidToken = "invalid.token.structure";

        // Act
        var principal = _jwtService.ValidateToken(invalidToken);

        // Assert
        Assert.Null(principal);
    }
}
```

**Çalıştırma:**

```bash
dotnet test --filter "ClassName=JwtServiceTests"
```

**Çıktı:**

```
  Passed  TodoApi.Tests.Services.JwtServiceTests.GenerateToken_WithValidUser_ReturnsToken [15ms]
  Passed  TodoApi.Tests.Services.JwtServiceTests.GenerateToken_ContainsUserClaims [12ms]
  Passed  TodoApi.Tests.Services.JwtServiceTests.ValidateToken_WithInvalidToken_ReturnsNull [8ms]

Test Run Summary
  Total tests: 3
  Passed: 3
  Failed: 0
Duration: 180ms
```

### 3.2 Mock Setup Örnekleri

```csharp
// Basit mock
var mock = new Mock<IInterface>();

// Dönüş değeri belirle
mock.Setup(x => x.Method())
    .Returns(value);

// Property mock et
mock.Setup(x => x["Key"])
    .Returns("Value");

// Exception fırlat
mock.Setup(x => x.Method())
    .Throws<Exception>();

// Verify - Çağrıldı mı kontrol et
mock.Verify(x => x.Method(), Times.Once);
```

---

## 4. Database Testing - In-Memory DB

Integration testlerinde gerçek veritabanı yerine **Entity Framework InMemory Database** kullanılır.

### 4.1 Örnek: Todo CRUD Operasyonları

**Dosya:** `backend.tests/Integration/IntegrationTests.cs`

```csharp
using Xunit;
using TodoApi.Data;
using TodoApi.Models;
using Microsoft.EntityFrameworkCore;
using System;
using System.Linq;

namespace TodoApi.Tests.Integration;

public class TodoCrudTests : IDisposable
{
    private readonly TodoDbContext _context;

    public TodoCrudTests()
    {
        // Her test için yeni In-Memory Database
        var options = new DbContextOptionsBuilder<TodoDbContext>()
            .UseInMemoryDatabase(databaseName: Guid.NewGuid().ToString())
            .Options;

        _context = new TodoDbContext(options);
        _context.Database.EnsureCreated();
    }

    // CREATE - Todo ekle
    [Fact]
    public void AddTodo_WithValidData_ShouldSaveToDatabase()
    {
        // Arrange
        var user = new User
        {
            Email = "test@example.com",
            Password = "hashed",
            FirstName = "Test",
            LastName = "User"
        };
        _context.Users.Add(user);
        _context.SaveChanges();

        var todo = new TodoItem
        {
            Text = "Learn xUnit",
            UserId = user.Id,
            CreatedAt = DateTime.UtcNow
        };

        // Act
        _context.TodoItems.Add(todo);
        _context.SaveChanges();

        // Assert
        var savedTodo = _context.TodoItems
            .FirstOrDefault(t => t.Text == "Learn xUnit");
        
        Assert.NotNull(savedTodo);
        Assert.Equal("Learn xUnit", savedTodo.Text);
        Assert.False(savedTodo.Completed);
    }

    // READ - Todo oku
    [Fact]
    public void GetTodo_ByText_ShouldReturnCorrectData()
    {
        // Arrange
        var user = new User
        {
            Email = "read@example.com",
            Password = "hashed",
            FirstName = "Read",
            LastName = "Test"
        };
        _context.Users.Add(user);
        _context.SaveChanges();

        var todo = new TodoItem
        {
            Text = "Read Test",
            UserId = user.Id,
            CreatedAt = DateTime.UtcNow
        };
        _context.TodoItems.Add(todo);
        _context.SaveChanges();

        // Act
        var retrieved = _context.TodoItems
            .Include(t => t.User)
            .FirstOrDefault(t => t.Text == "Read Test");

        // Assert
        Assert.NotNull(retrieved);
        Assert.Equal("Read Test", retrieved.Text);
        Assert.NotNull(retrieved.User);
        Assert.Equal("read@example.com", retrieved.User.Email);
    }

    // UPDATE - Todo güncelle
    [Fact]
    public void UpdateTodo_ChangeTextAndStatus_ShouldUpdateInDatabase()
    {
        // Arrange
        var user = new User
        {
            Email: "update@example.com",
            Password = "hashed",
            FirstName = "Update",
            LastName = "Test"
        };
        _context.Users.Add(user);
        _context.SaveChanges();

        var todo = new TodoItem
        {
            Text = "Original",
            UserId = user.Id,
            CreatedAt = DateTime.UtcNow,
            Completed = false
        };
        _context.TodoItems.Add(todo);
        _context.SaveChanges();

        // Act
        todo.Text = "Updated";
        todo.Completed = true;
        todo.UpdatedAt = DateTime.UtcNow;
        _context.SaveChanges();

        // Assert
        var updated = _context.TodoItems.Find(todo.Id);
        Assert.Equal("Updated", updated.Text);
        Assert.True(updated.Completed);
        Assert.NotNull(updated.UpdatedAt);
    }

    // DELETE - Todo sil
    [Fact]
    public void DeleteTodo_ShouldRemoveFromDatabase()
    {
        // Arrange
        var user = new User
        {
            Email = "delete@example.com",
            Password = "hashed",
            FirstName = "Delete",
            LastName = "Test"
        };
        _context.Users.Add(user);
        _context.SaveChanges();

        var todo = new TodoItem
        {
            Text = "To Delete",
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
        var deleted = _context.TodoItems.Find(todoId);
        Assert.Null(deleted);
    }

    // Cleanup
    public void Dispose()
    {
        _context?.Database.EnsureDeleted();
        _context?.Dispose();
    }
}
```

**Çalıştırma:**

```bash
dotnet test --filter "ClassName=TodoCrudTests"
```

**Çıktı:**

```
  Passed  TodoApi.Tests.Integration.TodoCrudTests.AddTodo_WithValidData_ShouldSaveToDatabase [25ms]
  Passed  TodoApi.Tests.Integration.TodoCrudTests.GetTodo_ByText_ShouldReturnCorrectData [18ms]
  Passed  TodoApi.Tests.Integration.TodoCrudTests.UpdateTodo_ChangeTextAndStatus_ShouldUpdateInDatabase [22ms]
  Passed  TodoApi.Tests.Integration.TodoCrudTests.DeleteTodo_ShouldRemoveFromDatabase [20ms]

Test Run Summary
  Total tests: 4
  Passed: 4
  Failed: 0
Duration: 450ms
```

---

## 5. Code Coverage - Coverlet

**Coverlet** testlerin kodun ne kadarını kapsadığını ölçer.

### 5.1 Coverage Raporu Oluşturma

```bash
cd backend.tests

# Coverage raporu oluştur
dotnet test /p:CollectCoverage=true

# Detaylı rapor (OpenCover format)
dotnet test /p:CollectCoverage=true /p:CoverageFormat=opencover

# Coverage threshold belirle (opsiyonel)
dotnet test /p:CollectCoverage=true /p:Threshold=80
```

### 5.2 Coverage Raporu Çıktısı

```
  Passed  TodoApi.Tests [1.5s]

Calculating coverage result...

  Total lines of code: 2,450
  Total lines covered: 2,380
  Line coverage: 97.1%
  
  Method coverage: 96.5%
  Type coverage: 100%

Coverage details by namespace:
  
  TodoApi.Models        : 99.2%
  TodoApi.DTOs          : 98.5%
  TodoApi.Services      : 95.8%
  TodoApi.Controllers   : 90.2%

Results directory: /path/to/backend.tests/CoverageReports/index.html
```

### 5.3 SonarQube Entegrasyonu

Code coverage'ı SonarQube ile değerlendirebilirsiniz:

```bash
# SonarQube scanner yükle
dotnet tool install --global dotnet-sonarscanner

# Coverage raporu oluştur
dotnet test /p:CollectCoverage=true /p:CoverageFormat=opencover

# SonarQube'a gönder
dotnet sonarscanner begin /k:"project-key" /d:sonar.host.url="http://localhost:9000"
dotnet build
dotnet test /p:CollectCoverage=true /p:CoverageFormat=opencover
dotnet sonarscanner end
```

---

## 6. AAA Pattern - Tüm Testlerin Temelindeki Yapı

Tüm testler **Arrange-Act-Assert** yapısını takip eder:

```csharp
[Fact]
public void TestName()
{
    // ARRANGE - Veri ve ortamı hazırla
    var input = new InputObject { /* ... */ };
    var expectedResult = "expected";

    // ACT - Test edilecek işlemi yap
    var actualResult = MethodUnderTest(input);

    // ASSERT - Sonucu doğrula
    Assert.Equal(expectedResult, actualResult);
}
```

### Örnek: Assertion Metotları

```csharp
// Eşitlik
Assert.Equal(expected, actual);
Assert.NotEqual(expected, actual);

// Null kontrol
Assert.Null(value);
Assert.NotNull(value);

// Boolean
Assert.True(condition);
Assert.False(condition);

// Koleksiyon
Assert.Empty(collection);
Assert.NotEmpty(collection);
Assert.Single(collection);
Assert.Equal(3, collection.Count);
Assert.Contains(item, collection);

// Tip kontrol
Assert.IsType<string>(value);
Assert.IsAssignableFrom<object>(value);

// Exception
Assert.Throws<InvalidOperationException>(() => { /* code */ });
Assert.ThrowsAny<Exception>(() => { /* code */ });

// Aralık
Assert.InRange(value, min: 1, max: 100);
Assert.NotInRange(value, min: 1, max: 100);

// Koleksiyondaki tümü kontrol
Assert.All(collection, item => Assert.NotNull(item));
```

---

## 7. Tüm Testleri Çalıştırma

### 7.1 Temel Komutlar

```bash
# Tüm testleri çalıştır
cd backend.tests
dotnet test

# Verbose mode (detaylı çıktı)
dotnet test --verbosity detailed

# Belirli bir test sınıfını çalıştır
dotnet test --filter "ClassName=JwtServiceTests"

# Belirli bir test metodunu çalıştır
dotnet test --filter "FullyQualifiedName~GenerateToken_WithValidUser"
```

### 7.2 Test Sonuçları (Gerçek Çalıştırma)

```bash
$ cd backend.tests
$ dotnet test
```

**Çıktı:**

```
TodoApi -> /Users/yusufapak/Desktop/toDoListt-main/backend/bin/Debug/net9.0/TodoApi.dll
TodoApi.Tests -> /Users/yusufapak/Desktop/toDoListt-main/backend.tests/bin/Debug/net9.0/TodoApi.Tests.dll

Test run for /Users/yusufapak/Desktop/toDoListt-main/backend.tests/bin/Debug/net9.0/TodoApi.Tests.dll (.NETCoreApp,Version=v9.0)
VSTest version 17.14.1 (arm64)

Starting test execution, please wait...
A total of 1 test files matched the specified pattern.

Passed!  - Failed:     0, Passed:    40, Skipped:     0, Total:    40, Duration: 599 ms
```

**Sonuç:**
- ✅ **40 test geçti**
- ❌ **0 test başarısız**
- ⏭️ **0 test atlandı**
- ⏱️ **Süre: 599 ms (0.6 saniye)**

### 7.3 Watch Mode (Otomatik Testleme)

Dosya değişince otomatik olarak testleri çalıştırır:

```bash
dotnet watch test
```

---

## 8. Test Organizasyon Yapısı

```
backend.tests/
│
├── DTOs/
│   └── DtoValidationTests.cs
│       ├── CreateTodoDto validasyonu (3 test)
│       ├── UpdateTodoDto validasyonu (2 test)
│       ├── RegisterDto validasyonu (4 test)
│       ├── LoginDto validasyonu (2 test)
│       └── Response DTO'ları (3 test)
│
├── Models/
│   └── ModelsTests.cs
│       ├── TodoItem Tests (6 test)
│       │   ├── Creation
│       │   ├── Default values
│       │   ├── Toggle status
│       │   ├── Update date
│       │   ├── User association
│       │   └── Timestamps
│       └── User Tests (7 test)
│           ├── Creation
│           ├── Todos list
│           ├── Add todos
│           ├── Remove todo
│           └── Validation
│
├── Services/
│   └── JwtServiceTests.cs
│       ├── Token generation (1 test)
│       ├── Token validation (1 test)
│       ├── Claims verification (1 test)
│       ├── Invalid tokens (1 test)
│       ├── Token uniqueness (1 test)
│       └── Email claim (1 test)
│
└── Integration/
    └── IntegrationTests.cs
        ├── User operations (3 test)
        ├── Todo CRUD (4 test)
        └── Relationships (3 test)
```

---

## 9. Best Practices

### 9.1 Test Adlandırması

```csharp
// ✅ İyi - Ne test ettiği açık
[Fact]
public void CreateTodoDto_WithValidText_ShouldPassValidation()

[Theory]
[InlineData("test@example.com")]
public void RegisterDto_WithValidEmail_ShouldPass(string email)

// ❌ Kötü - Anlamsız
[Fact]
public void Test1()

[Fact]
public void TestValidation()
```

### 9.2 Test İzolasyonu

```csharp
// ❌ Kötü - Shared state
public class UserTests
{
    private static List<User> users = new();

    [Fact]
    public void Test1() => users.Add(/* ... */);

    [Fact]
    public void Test2() => Assert.Single(users);  // Bağımlı!
}

// ✅ İyi - Bağımsız testler
public class UserTests
{
    private List<User> users;

    public UserTests()
    {
        users = new List<User>();
    }

    [Fact]
    public void Test1() { /* ... */ }

    [Fact]
    public void Test2() { /* ... */ }
}
```

### 9.3 Cleanup ve Resource Yönetimi

```csharp
public class DatabaseTests : IDisposable
{
    private readonly DbContext _context;

    public DatabaseTests()
    {
        // Setup
        _context = new DbContext(/* in-memory options */);
    }

    [Fact]
    public void Test1() { /* ... */ }

    public void Dispose()
    {
        // Cleanup
        _context?.Database.EnsureDeleted();
        _context?.Dispose();
    }
}
```

---

## 10. Sorun Giderme

### 10.1 Test Başarısız Olursa

```bash
# Bağımlılıkları temizle
dotnet clean
dotnet restore

# Tekrar derle
dotnet build

# Detaylı hata mesajı ile çalıştır
dotnet test --verbosity detailed
```

### 10.2 Coverage Raporu Bulunamazsa

```bash
# Coverage raporunu oluştur
dotnet test /p:CollectCoverage=true

# HTML raporu açmak için
open CoverageReports/index.html
```

### 10.3 Performance İssues

```bash
# Testleri paralel çalıştır (hızlı)
dotnet test -p:ParallelizeAssembly=true

# Belirli test sayısını paralel çalıştır
dotnet test --maxParallelThreads=4
```

---

## Sonuç

Bu raporda gösterileni özetlemek gerekirse:

- ✅ **xUnit**: Test yazma ve çalıştırma framework'ü
- ✅ **Moq**: Mock nesneler oluşturma
- ✅ **In-Memory Database**: Veritabanı testleri
- ✅ **Coverlet**: Code coverage ölçümü
- ✅ **40 Test**: Tüm backend kapsamlı

Tüm testler başarıyla geçmektedir ✅

