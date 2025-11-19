# 🧪 Testleri Çalıştırma Rehberi - Komut Satırı

## ✅ TÜM TESTLER BAŞARILI

```
Test summary: total: 40, failed: 0, succeeded: 40, skipped: 0
Build succeeded with 0 errors
```

---

## 📍 Konsola Yazmanız Gereken Komutlar

### 1. TÜM TESTLERI ÇALIŞTIR (Önerilen)

```bash
cd /Users/yusufapak/Desktop/toDoListt-main/backend.tests
dotnet test
```

**Çıktı**:
```
Test summary: total: 40, failed: 0, succeeded: 40, skipped: 0, duration: 0.9s
```

---

### 2. DETAYLI ÇIKTI İLE TESTLER

```bash
dotnet test --verbosity detailed
```

**Avantajları**:
- ✅ Her bir test adını gösterir
- ✅ Hangi testlerin geçtiğini gösterir
- ✅ Geçen/başarısız test sayısı
- ✅ Süre bilgisi

---

### 3. TEST KATEGORİLERİNE GÖRE ÇALIŞTIR

#### Sadece DTO Testleri (13 test)
```bash
dotnet test --filter "ClassName=TodoApi.Tests.DTOs.TodoDtoValidationTests"
```

#### Sadece TodoItem Model Testleri (6 test)
```bash
dotnet test --filter "ClassName=TodoApi.Tests.Models.TodoItemTests"
```

#### Sadece User Model Testleri (7 test)
```bash
dotnet test --filter "ClassName=TodoApi.Tests.Models.UserTests"
```

#### Sadece JWT Service Testleri (6 test)
```bash
dotnet test --filter "ClassName=TodoApi.Tests.Services.JwtServiceTests"
```

#### Sadece Integration Testleri (8 test) ⭐
```bash
dotnet test --filter "ClassName=TodoApi.Tests.Integration.TodoApiIntegrationTests"
```

---

### 4. BELİRLİ BİR TESTI ÇALIŞTIR

```bash
dotnet test --filter "Name=CreateTodoDto_WithValidText_ShouldPassValidation"
```

---

### 5. CODE COVERAGE RAPORU

```bash
dotnet test --collect:"XPlat Code Coverage"
```

**Rapor konumu**:
```
backend.tests/TestResults/[guid]/coverage.cobertura.xml
```

---

## 📊 TEST YAPILARI VE AÇIKLAMALAR

### 1️⃣ DTO VALIDATION TESTS (13 testler)

**Amaç**: Form verileri (CreateTodoDto, UpdateTodoDto, RegisterDto, LoginDto) doğru validate ediliyor mi?

**Dosya**: `backend.tests/DTOs/DtoValidationTests.cs`

```csharp
[Fact]
public void CreateTodoDto_WithValidText_ShouldPassValidation()
{
    // Arrange (Hazırla)
    var dto = new CreateTodoDto { Text = "Valid todo text" };

    // Act (Yap)
    var results = ValidateDto(dto);

    // Assert (Doğrula)
    Assert.Empty(results);  // Hiç hata olmamalı
}
```

**Testler**:
- ✅ CreateTodoDto: Valid, Empty, MaxLength
- ✅ UpdateTodoDto: Valid, Empty
- ✅ RegisterDto: Valid, InvalidEmail, WeakPassword, MissingFields
- ✅ LoginDto: Valid, EmptyEmail

**Çalıştır**:
```bash
dotnet test --filter "ClassName=TodoApi.Tests.DTOs.TodoDtoValidationTests"
```

---

### 2️⃣ TODOITEM MODEL TESTS (6 testler)

**Amaç**: TodoItem entity'si özellikleri doğru şekilde tutuyor mu?

**Dosya**: `backend.tests/Models/ModelsTests.cs`

```csharp
[Fact]
public void TodoItem_Creation_SetsPropertiesCorrectly()
{
    // Arrange
    var todo = new TodoItem 
    { 
        Id = 1, 
        Text = "Test todo", 
        Completed = false, 
        CreatedAt = DateTime.UtcNow 
    };

    // Assert
    Assert.Equal(1, todo.Id);
    Assert.Equal("Test todo", todo.Text);
    Assert.False(todo.Completed);
}

[Fact]
public void TodoItem_Toggle_ChangesCompletedStatus()
{
    // Arrange
    var todo = new TodoItem { Completed = false };

    // Act
    todo.Completed = !todo.Completed;

    // Assert
    Assert.True(todo.Completed);
}
```

**Testler**:
- ✅ Özellikler doğru set ediliyor
- ✅ Completed durumu değişiyor
- ✅ Tarih tutuluyor
- ✅ Kullanıcı ilişkisi
- ✅ Koleksiyonlar başlatılıyor
- ✅ Constructor çalışıyor

**Çalıştır**:
```bash
dotnet test --filter "ClassName=TodoApi.Tests.Models.TodoItemTests"
```

---

### 3️⃣ USER MODEL TESTS (7 testler)

**Amaç**: User entity'si ve Todo ilişkileri doğru çalışıyor mu?

```csharp
[Fact]
public void User_Creation_SetsPropertiesCorrectly()
{
    // Arrange
    var user = new User
    {
        Email = "user@example.com",
        Password = "hashedpassword",
        FirstName = "John",
        LastName = "Doe"
    };

    // Assert
    Assert.Equal("user@example.com", user.Email);
    Assert.NotNull(user.Todos);
}

[Fact]
public void User_CanAddAndRemoveTodos()
{
    // Arrange
    var user = new User { Email = "user@example.com" };
    var todo = new TodoItem { Text = "Test todo" };

    // Act
    user.Todos.Add(todo);
    user.Todos.Remove(todo);

    // Assert
    Assert.Empty(user.Todos);
}
```

**Testler**:
- ✅ Özellikler doğru set ediliyor
- ✅ Todos koleksiyonu başlatılıyor
- ✅ Todo ekleyebiliyor
- ✅ Todo kaldırabiliyor
- ✅ Email property'si var
- ✅ User-Todo ilişkisi
- ✅ Tüm alanlar nullable değil

**Çalıştır**:
```bash
dotnet test --filter "ClassName=TodoApi.Tests.Models.UserTests"
```

---

### 4️⃣ JWT SERVICE TESTS (6 testler)

**Amaç**: JWT token'ları doğru oluşturuluyor ve doğrulanıyor mu?

**Dosya**: `backend.tests/Services/JwtServiceTests.cs`

```csharp
[Fact]
public void GenerateToken_CreatesValidJwt()
{
    // Arrange
    var user = new User
    {
        Id = 1,
        Email = "test@example.com",
        FirstName = "Test",
        LastName = "User"
    };

    // Act
    var token = _jwtService.GenerateToken(user);

    // Assert
    Assert.NotNull(token);
    Assert.NotEmpty(token);
}

[Fact]
public void ValidateToken_ReturnsClaimsPrincipalWithCorrectEmail()
{
    // Arrange
    var user = new User
    {
        Id = 1,
        Email = "jwt@example.com",
        FirstName = "JWT",
        LastName = "Test"
    };

    // Act
    var token = _jwtService.GenerateToken(user);
    var principal = _jwtService.ValidateToken(token);

    // Assert
    Assert.NotNull(principal);
    var emailClaim = principal.FindFirst(System.Security.Claims.ClaimTypes.Email);
    Assert.Equal("jwt@example.com", emailClaim?.Value);
}
```

**Testler**:
- ✅ Token üretiliyor
- ✅ Token null değil
- ✅ Token doğrulanıyor
- ✅ Claims doğru okunuyor
- ✅ Geçersiz token null döndürüyor
- ✅ Farklı kullanıcı farklı token

**Çalıştır**:
```bash
dotnet test --filter "ClassName=TodoApi.Tests.Services.JwtServiceTests"
```

---

### 5️⃣ INTEGRATION TESTS (8 testler) ⭐ ÖNEMLİ

**Amaç**: Veritabanı işlemleri ve component etkileşimi doğru çalışıyor mu?

**Dosya**: `backend.tests/Integration/IntegrationTests.cs`

```csharp
public class TodoApiIntegrationTests : IDisposable
{
    private readonly TodoDbContext _context;
    private readonly JwtService _jwtService;

    // InMemory Database kullanıyoruz (gerçek DB değil)
    public TodoApiIntegrationTests()
    {
        var options = new DbContextOptionsBuilder<TodoDbContext>()
            .UseInMemoryDatabase(databaseName: Guid.NewGuid().ToString())
            .Options;
        
        _context = new TodoDbContext(options);
        _jwtService = new JwtService(mockConfig.Object);
    }

    [Fact]
    public void User_CanBeCreatedAndRetrieved()
    {
        // Arrange
        var user = new User
        {
            Email = "integration@example.com",
            Password = "hashedpwd",
            FirstName = "Integration",
            LastName = "Test"
        };

        // Act
        _context.Users.Add(user);
        _context.SaveChanges();
        
        var retrievedUser = _context.Users
            .FirstOrDefault(u => u.Email == "integration@example.com");

        // Assert
        Assert.NotNull(retrievedUser);
        Assert.Equal("integration@example.com", retrievedUser.Email);
    }

    [Fact]
    public void Todo_CanBeCreatedAndAssociatedWithUser()
    {
        // Arrange
        var user = new User { Email = "user@example.com" };
        _context.Users.Add(user);
        _context.SaveChanges();

        var todo = new TodoItem
        {
            Text = "Integration todo",
            UserId = user.Id
        };

        // Act
        _context.TodoItems.Add(todo);
        _context.SaveChanges();

        var retrievedTodo = _context.TodoItems
            .FirstOrDefault(t => t.Text == "Integration todo");

        // Assert
        Assert.NotNull(retrievedTodo);
        Assert.Equal(user.Id, retrievedTodo.UserId);
    }

    [Fact]
    public void CascadeDelete_DeletesUserTodosWhenUserDeleted()
    {
        // Arrange
        var user = new User { Email = "cascade@example.com" };
        _context.Users.Add(user);
        _context.SaveChanges();
        
        var todo = new TodoItem { Text = "Todo for deletion", UserId = user.Id };
        _context.TodoItems.Add(todo);
        _context.SaveChanges();

        // Act
        _context.Users.Remove(user);
        _context.SaveChanges();

        // Assert
        var deletedTodo = _context.TodoItems.FirstOrDefault(t => t.Id == todo.Id);
        Assert.Null(deletedTodo);  // Todo da silinmeli
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
        var emailClaim = principal.FindFirst(System.Security.Claims.ClaimTypes.Email);
        Assert.Equal("jwt@example.com", emailClaim?.Value);
    }
}
```

**Testler**:
- ✅ User CRUD (Create, Read, Update, Delete)
- ✅ Todo CRUD
- ✅ Cascade Delete (User silinince Todo'lar da silinir)
- ✅ JWT Token Integration
- ✅ User-Todo İlişkisi
- ✅ Email Duplicate Kontrolü
- ✅ Timestamp işlemleri
- ✅ Filter ve Search

**Çalıştır**:
```bash
dotnet test --filter "ClassName=TodoApi.Tests.Integration.TodoApiIntegrationTests"
```

---

## 🎯 HIZLI KOMUTLAR (KOPYALA-YAPISTIR)

### Tüm testleri normal mod da çalıştır
```bash
cd /Users/yusufapak/Desktop/toDoListt-main/backend.tests && dotnet test
```

### Tüm testleri detaylı mode'da çalıştır
```bash
cd /Users/yusufapak/Desktop/toDoListt-main/backend.tests && dotnet test --verbosity detailed
```

### Integration testlerini sadece çalıştır
```bash
cd /Users/yusufapak/Desktop/toDoListt-main/backend.tests && dotnet test --filter "ClassName=TodoApi.Tests.Integration.TodoApiIntegrationTests"
```

### DTO ve Model testlerini çalıştır
```bash
cd /Users/yusufapak/Desktop/toDoListt-main/backend.tests && dotnet test --filter "ClassName=TodoApi.Tests.DTOs.TodoDtoValidationTests OR ClassName=TodoApi.Tests.Models.TodoItemTests OR ClassName=TodoApi.Tests.Models.UserTests"
```

### Test sayısını görüntüle
```bash
cd /Users/yusufapak/Desktop/toDoListt-main/backend.tests && dotnet test --verbosity quiet | grep "Test summary"
```

---

## 📈 TEST İSTATİSTİKLERİ

```
┌─────────────────────────────────────────────────┐
│         TOPLAM TEST: 40                         │
├─────────────────────────────────────────────────┤
│ 1. DTO Validation Tests        →  13 test ✅    │
│ 2. TodoItem Model Tests        →   6 test ✅    │
│ 3. User Model Tests            →   7 test ✅    │
│ 4. JWT Service Tests           →   6 test ✅    │
│ 5. Integration Tests (DB)      →   8 test ✅    │
├─────────────────────────────────────────────────┤
│ BAŞARILI                       →  40 test ✅    │
│ BAŞARISIZ                      →   0 test ❌    │
│ ATLANAN                        →   0 test ⏭️     │
└─────────────────────────────────────────────────┘
```

---

## 🧬 TEST TÜRLERİ AÇIKLAMASI

### Unit Tests (Birim Testler)
**Ne test eder**: Tek bir sınıf veya metod
**Örnekler**:
- DTO validation (DtoValidationTests)
- Model properties (TodoItemTests, UserTests)
- JWT token generation (JwtServiceTests)

```bash
dotnet test --filter "ClassName=TodoApi.Tests.DTOs.TodoDtoValidationTests"
```

### Integration Tests (Entegrasyon Testleri)
**Ne test eder**: Birden çok component'in birlikte çalışması
**Örnekler**:
- User ve Todo'nun birlikte çalışması
- JWT ile authentication flow'u
- Veritabanı işlemleri
- Cascade delete işlemleri

```bash
dotnet test --filter "ClassName=TodoApi.Tests.Integration.TodoApiIntegrationTests"
```

**Fark**:
| Unit Test | Integration Test |
|-----------|-----------------|
| Hızlı (birkaç ms) | Biraz daha yavaş (50-100ms) |
| İzole edilmiş | Component'ler birlikte |
| Mock kullanır | Gerçek DB (InMemory) |
| Az kaynak | Daha çok kaynak |

---

## ⚙️ TEKNOLOJILER

```
xUnit 2.6.6          - Test framework
Moq 4.20.70          - Mocking library
Coverlet 6.0.0       - Code coverage
EF InMemory 9.0.0    - Fake database
.NET 10.0            - Runtime
```

---

## 🚀 SONRAKI ADIMLAR

1. **Controller Testleri Ekle**
   ```bash
   dotnet test --filter "ClassName=TodoApi.Tests.Controllers.*"
   ```

2. **Performance Tests**
   ```bash
   dotnet add package BenchmarkDotNet
   ```

3. **E2E Tests**
   ```bash
   dotnet add package PlaywrightSharp
   ```

4. **CI/CD Pipeline**
   GitHub Actions ile otomatik test çalıştır

---

**📅 Son Güncelleme**: 2025-11-19  
**✅ Durum**: Tüm 40 test başarılı  
**⏱️ Süre**: ~0.9 saniye
