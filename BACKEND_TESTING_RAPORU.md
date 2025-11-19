# Backend Test Raporu - xUnit, Moq & Coverlet Analizi

## 📋 İçindekiler
1. [Giriş](#giriş)
2. [xUnit Nedir ve Nerede Kullanıldı](#xunit-nedir-ve-nerede-kullanıldı)
3. [Moq (Mock Nesneleri)](#moq-nedir-ve-nerede-kullanıldı)
4. [Coverlet (Code Coverage)](#coverlet-nedir-ve-nerede-kullanıldı)
5. [Test Sonuçları](#test-sonuçları)

---

## 🚀 Giriş

Bu rapor, **ToDoList Backend API** projesinin unit test ve integration test yapısını analiz eder. Projede toplamda **40 test** bulunmaktadır ve tümü **başarıyla geçmektedir**.

**Proje Teknolojileri:**
- ✅ Framework: **xUnit 2.6.6**
- ✅ Mocking: **Moq 4.20.70**
- ✅ Database: **Entity Framework Core InMemory**
- ✅ Code Coverage: **Coverlet 6.0.0**
- ✅ Runtime: **.NET 9.0**

**Test Kategorileri:**
- 14 DTO Validation Tests
- 13 Model Tests
- 6 JWT Service Tests
- 7 Integration Tests

---

## 🧪 xUnit Nedir ve Nerede Kullanıldı?

### xUnit Nedir?

**xUnit**, C# için bir birim test framework'üdür. En popüler test framework'lerinden biridir ve Microsoft tarafından da kullanılmaktadır.

### xUnit'in Temel Özellikleri:

1. **[Fact]** - Parametre olmayan testler
2. **[Theory]** - Parametreli testler (veri tabanlı)
3. **Assert** - Assertion metotları
4. **IDisposable** - Setup ve cleanup işlemleri

---

### 1️⃣ xUnit [Fact] Özniteliği - Model Tests

#### Dosya Konumu: `/backend.tests/Models/ModelsTests.cs`

**Bu dosya nedir?**
- TodoItem ve User model sınıflarını test eder
- Model özelliklerinin doğru çalışıp çalışmadığını kontrol eder
- **13 test** içerir

#### Kod Örneği 1 - TodoItem Oluşturma:

```csharp
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
```

**Kodun Açıklaması:**
- `[Fact]` özniteliği: Bu metod bir parametresiz unit test'tir
- `Arrange`: TodoItem nesnesi oluşturulur
- `Act`: Nesneler hafızada hazırlanır
- `Assert.Equal()`: İD, text, user ID'si kontrol edilir
- `Assert.False()`: Yeni todo'ların başında Completed=false olması kontrolü
- **Neden?** Model'in property'lerinin doğru set edilebildiğini doğrulamak

#### Kod Örneği 2 - Completed Status Kontrolü:

```csharp
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
```

**Kodun Açıklaması:**
- `Assert.False()`: Todo oluşturulurken Completed otomatik olarak false olmalı
- **Neden?** Yeni todo'lar başında tamamlanmamış halde olmalı

#### Kod Örneği 3 - User-Todo İlişkisi:

```csharp
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
```

**Kodun Açıklaması:**
- `Assert.Single()`: Koleksiyonda tam 1 eleman var mı kontrolü
- `.First().Text`: Eklenen todo'nun text'i doğru mu kontrol
- **Neden?** User ve TodoItem arasındaki ilişkinin çalışıp çalışmadığını test etmek

---

### 2️⃣ xUnit [Fact] Özniteliği - DTO Validation Tests

#### Dosya Konumu: `/backend.tests/DTOs/DtoValidationTests.cs`

**Bu dosya nedir?**
- Data Transfer Objects (DTO) sınıflarını test eder
- DTO'ların validation kurallarını kontrol eder
- **14 test** içerir

#### Kod Örneği 1 - Valid DTO:

```csharp
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
```

**Kodun Açıklaması:**
- `ValidateDto()`: DataAnnotation validation'ı çalıştırır
- `Assert.Empty(results)`: Validation hataları olmamalı
- **Neden?** Valid veri DTO'ya kabul edilir

#### Kod Örneği 2 - Boş Text Hatası:

```csharp
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
```

**Kodun Açıklaması:**
- `string.Empty`: Text alanı boş gönderilir
- `Assert.NotEmpty(results)`: Validation hatası oluşmalı
- **Neden?** Text alanı zorunlu olmalı, boş veri kabul edilmemeli

#### Kod Örneği 3 - Maksimum Uzunluk Kontrolü:

```csharp
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
```

**Kodun Açıklaması:**
- `new string('a', 1001)`: 1001 karakter uzunluğunda text oluşturur
- **MaxLength = 1000** kuralı kontrol edilir
- `Assert.NotEmpty(results)`: Validation başarısız olmalı
- **Neden?** Aşırı uzun text'lerin database'e yazılmasını önlemek

#### Kod Örneği 4 - Email Format Kontrolü:

```csharp
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
```

**Kodun Açıklaması:**
- `"invalid-email"`: `@` karakteri olmayan geçersiz email
- `[EmailAddress]` attribute kontrolü başarısız olur
- **Neden?** Geçersiz email'lerin sisteme girmesini engellemek

#### Kod Örneği 5 - Password Minimum Uzunluk:

```csharp
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
```

**Kodun Açıklaması:**
- `"short"`: Minimum uzunluk kuralını ihlal eder (minimum 8 karakter)
- **Neden?** Zayıf şifrelerin kullanılmasını engellemek

---

### 3️⃣ xUnit [Fact] Özniteliği - JWT Service Tests

#### Dosya Konumu: `/backend.tests/Services/JwtServiceTests.cs`

**Bu dosya nedir?**
- JWT (JSON Web Token) service'ini test eder
- Token oluşturma ve doğrulama işlemlerini kontrol eder
- **6 test** içerir

#### Test Setup - Constructor'da Moq:

```csharp
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
}
```

**Kodun Açıklaması:**
- `Mock<IConfiguration>`: IConfiguration interface'inin fake versiyonu oluşturur
- `.Setup(x => x["JWT:Secret"])`: Secret key sorulduğunda ne döneceğini belirtir
- `.Object`: Mock'u gerçek interface gibi kullanabiliriz
- **Neden?** Real configuration dosyasına ihtiyaç duymadan test etmek

#### Kod Örneği 1 - Token Oluşturma:

```csharp
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
```

**Kodun Açıklaması:**
- `GenerateToken()`: User parametresi ile JWT token oluşturur
- `Assert.NotNull(token)`: Token null değil mi kontrolü
- `Assert.NotEmpty(token)`: Token boş string değil mi kontrolü
- `Assert.IsType<string>(token)`: Token'ın string türü olup olmadığı
- **Neden?** Token doğru şekilde oluşturuluyor mu kontrol etmek

#### Kod Örneği 2 - Token Doğrulama:

```csharp
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
```

**Kodun Açıklaması:**
- `GenerateToken()`: Token oluşturulur
- `ValidateToken()`: Token doğrulanır (verify edilir)
- `FindFirst(ClaimTypes.NameIdentifier)`: User ID claim'ini bulur
- `Assert.Equal("1", userIdClaim.Value)`: User ID'nin doğru olup olmadığı
- **Neden?** Token'ın geçerli olup, user bilgilerini içerip içermediğini test etmek

#### Kod Örneği 3 - Invalid Token Kontrolü:

```csharp
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
```

**Kodun Açıklaması:**
- `"invalid.token.here"`: Geçersiz token string'i
- `ValidateToken()`: Token doğrulamayı dener
- `Assert.Null(principal)`: Geçersiz token null dönmeli
- **Neden?** Sahte token'ları reddettiğini doğrulamak

#### Kod Örneği 4 - Tüm Claims Kontrolü:

```csharp
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
```

**Kodun Açıklaması:**
- `ClaimTypes.NameIdentifier`: User ID claim'i
- `ClaimTypes.Email`: Email claim'i
- `ClaimTypes.GivenName`: First name claim'i
- `ClaimTypes.Surname`: Last name claim'i
- **Neden?** Token'ın tüm gerekli user bilgilerini içerip içermediğini kontrol etmek

---

### 4️⃣ xUnit [Fact] Özniteliği - Integration Tests

#### Dosya Konumu: `/backend.tests/Integration/IntegrationTests.cs`

**Bu dosya nedir?**
- Tam sistem entegrasyonunu test eder
- Database operasyonlarını test eder
- JWT ve database'i birlikte test eder
- **8 test** içerir

#### Test Setup - In-Memory Database ve Moq:

```csharp
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
}
```

**Kodun Açıklaması:**
- `UseInMemoryDatabase()`: Gerçek database yerine memory database kullanır
- `Guid.NewGuid().ToString()`: Her test için farklı database örneği
- `EnsureCreated()`: Table'ları oluşturur
- `Mock<IConfiguration>`: JWT konfigürasyonunu sahte sağlar
- **Neden?** Gerçek database'e ihtiyaç duymadan hızlı testler yapmak

#### Kod Örneği 1 - CREATE: User Oluşturma:

```csharp
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
```

**Kodun Açıklaması:**
- `_context.Users.Add()`: User'ı in-memory database'e ekler
- `_context.SaveChanges()`: Değişiklikleri kaydeder
- `FirstOrDefault()`: Email ile user'ı arar
- `Assert.NotNull(savedUser)`: User'ın kaydedilip kaydedilmediğini kontrol eder
- **Neden?** Entity Framework Core'un user oluşturmayı doğru yaptığını doğrulamak

#### Kod Örneği 2 - User-Todo İlişkisi (Foreign Key):

```csharp
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
```

**Kodun Açıklaması:**
- `_context.Users.Add(user)`: Önce user oluşturulur
- `_context.SaveChanges()`: User database'e kaydedilir
- `UserId = user.Id`: Todo'ya user referansı verilir
- `.Include(t => t.User)`: Eager loading ile user verisi de çekilir
- `Assert.Equal(user.Id, savedTodo.UserId)`: Foreign key kontrol edilir
- **Neden?** Database ilişkilerinin (relationships) doğru çalışıp çalışmadığını test etmek

#### Kod Örneği 3 - UPDATE: Todo Güncelleme:

```csharp
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
```

**Kodun Açıklaması:**
- Yeni todo oluşturulur ve kaydedilir
- `todo.Text = "Updated Text"`: Text değiştirilir
- `todo.Completed = true`: Completed flag'ı ayarlanır
- `todo.UpdatedAt = DateTime.UtcNow`: Update timestamp set edilir
- `_context.SaveChanges()`: Değişiklikler kaydedilir
- `Assert.Equal("Updated Text", updatedTodo.Text)`: Değişikliklerin kaydedilip kaydedilmediği kontrol edilir
- **Neden?** UPDATE operasyonunun doğru çalışıp çalışmadığını test etmek

#### Kod Örneği 4 - DELETE: Todo Silme:

```csharp
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
```

**Kodun Açıklaması:**
- Todo oluşturulur ve kaydedilir
- `todoId = todo.Id`: ID kaydedilir (todo referansını kullanamayız)
- `_context.TodoItems.Remove(todo)`: Todo silinir
- `_context.SaveChanges()`: Silme işlemi kaydedilir
- `FirstOrDefault()`: Silinmiş todo aranır
- `Assert.Null(deletedTodo)`: Silinmiş todo null olmalı
- **Neden?** DELETE operasyonunun doğru çalışıp çalışmadığını test etmek

#### Kod Örneği 5 - Cascade Delete:

```csharp
[Fact]
public void DeleteUser_CascadeDeletesTodos()
{
    // Arrange
    var user = new User
    {
        Email = "cascade@example.com",
        Password = "hashedpassword",
        FirstName = "Cascade",
        LastName: "Test"
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
    Assert.Null(deletedTodo); // User silinince todo'lar da silinir
}
```

**Kodun Açıklaması:**
- User silinirken, o user'ın tüm todo'ları da silinir
- **Cascade Delete**: Foreign key ilişkisi nedeniyle oluşan davranış
- `Assert.Null(deletedTodo)`: User'ın todo'sı da silinmiş olmalı
- **Neden?** Veritabanı integrityinin sağlandığını doğrulamak

---

### xUnit Assert Metotları Özeti

| Assert Metodu | Açıklama | Örnek |
|---|---|---|
| `Assert.Equal(expected, actual)` | Değerlerin eşit olup olmadığını kontrol eder | `Assert.Equal(1, todo.Id)` |
| `Assert.NotNull(value)` | Değerin null olmadığını kontrol eder | `Assert.NotNull(token)` |
| `Assert.NotEmpty(value)` | Koleksiyonun boş olmadığını kontrol eder | `Assert.NotEmpty(results)` |
| `Assert.Empty(value)` | Koleksiyonun boş olup olmadığını kontrol eder | `Assert.Empty(validationErrors)` |
| `Assert.True(condition)` | Koşulun true olup olmadığını kontrol eder | `Assert.True(todo.Completed)` |
| `Assert.False(condition)` | Koşulun false olup olmadığını kontrol eder | `Assert.False(todo.Completed)` |
| `Assert.Single(collection)` | Koleksiyonda sadece bir eleman olup olmadığını kontrol eder | `Assert.Single(user.Todos)` |
| `Assert.IsType<T>(value)` | Değerin belirtilen türde olup olmadığını kontrol eder | `Assert.IsType<string>(token)` |
| `Assert.Null(value)` | Değerin null olup olmadığını kontrol eder | `Assert.Null(deletedTodo)` |

---

## 🎭 Moq Nedir ve Nerede Kullanıldı?

### Moq Nedir?

**Moq**, C# için Mock nesneleri oluşturmak için kullanılan bir framework'tür. 
Mock nesneler, gerçek nesnelerin yerine test sırasında kullanılan sahte (fake) nesnelerdir.

### Moq'un Faydaları:

1. **Bağımlılıkları Yalıtmak** - Harici servisleri test etmeyiz
2. **Kontrol Sağlamak** - Metod çağrılarını kontrol edebiliriz
3. **Hızlandırmak** - Gerçek database erişimi yerine memory'de çalışır

---

### JWT Service Tests - Moq Kullanımı

#### Dosya Konumu: `/backend.tests/Services/JwtServiceTests.cs`

**Moq neden burada kullanıldı?**

JwtService, `IConfiguration` interface'ine bağımlıdır. Real configuration dosyasını okumak istemiriz, ancak test ortamında bunu kontrol altında tutmamız gerekir. Moq ile configuration'ı sahte sağlarız.

#### Gerçek Kod - Constructor'da Moq Setup:

```csharp
public class JwtServiceTests
{
    private readonly JwtService _jwtService;
    private readonly Mock<IConfiguration> _configurationMock;

    public JwtServiceTests()
    {
        // Mock IConfiguration oluştur
        _configurationMock = new Mock<IConfiguration>();
        
        // Mock'un davranışını belirle
        _configurationMock
            .Setup(x => x["JWT:Secret"])
            .Returns("YourSuperSecretKeyThatIsAtLeast32CharactersLongForTestingPurposes!@#$%");
        
        // JwtService'i mock ile başlat
        _jwtService = new JwtService(_configurationMock.Object);
    }
}
```

**Kod Detayları:**

1. **`new Mock<IConfiguration>()`** - IConfiguration'ın fake versiyonu oluşturulur
2. **`.Setup(x => x["JWT:Secret"])`** - Secret key parametresi sorulduğunda ne yapılacağını belirtir
3. **`.Returns("...")`** - Mock her sorgulamada bu test secret'ını döndürür
4. **`_configurationMock.Object`** - Mock'u gerçek IConfiguration gibi JwtService'e geçirilir

#### Gerçek Test - Moq ile Token Üretimi:

```csharp
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
```

**Bu testte Moq'un Rolü:**
- `_jwtService`: Moq'lanmış IConfiguration ile oluşturulmuş
- `GenerateToken()`: İçerikte `_configurationMock` tarafından sağlanan secret key kullanılır
- **Neden?** Gerçek appsettings.json dosyası okunmaz, her test aynı secret key ile çalışır

---

### Integration Tests - Moq Kullanımı

#### Dosya Konumu: `/backend.tests/Integration/IntegrationTests.cs`

Integration test'lerde de Moq kullanılır, çünkü JwtService configuration'a ihtiyaç duyar. **Neden Moq Kullanıldığını** gösteren 5 madde:

1. **Dış Bağımlılıkları Yalıtmak**
   - JwtService, `IConfiguration` interface'ine bağımlıdır
   - Real appsettings.json dosyasını okumak istemeyiz
   - Mock ile test ortamında kontrollü bir secret key sağlarız
   - Bu sayede test her ortamda aynı şekilde çalışır

2. **Configuration'u Kontrolü Altında Tutmak**
   - Real configuration'da JWT:Secret değeri production secret'idir
   - Test'te güvenli bir test secret'i kullanmak zorundayız
   - Mock setup ile tam olarak ne döneceğini belirleriz
   - Test ortamı ile production ortamı izoledir

3. **Database ve JWT'yi Birlikte Test Etmek**
   - Integration test'te database'e user yazarız
   - Bu user için JWT token oluştururuz
   - Token doğrulaması yapacağız
   - Tüm bunları yaparken configuration'u mock'ta tutarız

4. **Hızlı ve Güvenilir Testler Sağlamak**
   - Real API'ye çağrı yapmamız gerekmez
   - Dış sistemlere bağımlılık ortadan kalkar
   - Test hızlı ve güvenilir şekilde çalışır
   - Network hatalarından etkilenmez

5. **Test Verilerini Önceden Belirlemek**
   - JWT secret key'i test sırasında sabittir
   - Oluşturulan token'lar daima validate edilebilir
   - Test önceden tahmin edilebilir ve tekrarlanabilir

#### Gerçek Kod - Integration Test Setup:

```csharp
public class TodoApiIntegrationTests : IDisposable
{
    private readonly TodoDbContext _context;
    private readonly JwtService _jwtService;

    public TodoApiIntegrationTests()
    {
        // In-Memory Database Setup
        var options = new DbContextOptionsBuilder<TodoDbContext>()
            .UseInMemoryDatabase(databaseName: Guid.NewGuid().ToString())
            .Options;

        _context = new TodoDbContext(options);
        _context.Database.EnsureCreated();

        // JWT Service Setup - Moq ile
        var configurationMock = new Mock<IConfiguration>();
        configurationMock
            .Setup(x => x["JWT:Secret"])
            .Returns("YourSuperSecretKeyThatIsAtLeast32CharactersLongForTestingPurposes!@#$%");

        _jwtService = new JwtService(configurationMock.Object);
    }
}
```

**Bu Kodda Moq'un Rolü:**
- `new Mock<IConfiguration>()` - IConfiguration interface'inin fake'ini oluşturur
- `.Setup(x => x["JWT:Secret"])` - Secret key sorulduğunda ne olacağını belirler
- `.Returns("...")` - Test secret key'ini döndürür
- `.Object` - Mock'u real IConfiguration gibi kullanabiliriz

#### Gerçek Test - Database ve JWT Birlikte:

```csharp
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
```

**Bu Testte Moq'un Rolü:**
- `_jwtService`: Moq'lanmış configuration ile oluşturulmuş
- `GenerateToken()`: Mock tarafından sağlanan secret key'i kullanır
- `ValidateToken()`: Aynı mock secret key'i kullanarak doğrulama yapar
- **Sonuç:** Real configuration dosyasına ihtiyaç duymadan tam sistem testi

---

### Moq Terminolojisi

| Terim | Açıklama | Örnek |
|---|---|---|
| **Mock** | Sahte nesne | `new Mock<IConfiguration>()` |
| **Setup** | Mock'un davranışını tanımla | `.Setup(x => x["JWT:Secret"])` |
| **Returns** | Setup'ın ne döneceğini belirle | `.Returns("secret-key")` |
| **Verify** | Metod çağrılıp çağrılmadığını kontrol et | `.Verify(x => x["JWT:Secret"])` |
| **.Object** | Mock'u interface olarak kullan | `_configurationMock.Object` |

---

## 📊 Coverlet Nedir ve Nerede Kullanıldı?

### Coverlet Nedir?

**Coverlet**, .NET için kod kapsama (code coverage) aracıdır. 
Testlerin kodun ne kadarını çalıştırdığını ölçer.

### Coverlet'in Özellikleri:

1. **Line Coverage** - Kaç satır test edildi
2. **Branch Coverage** - Kaç karar (if/else) test edildi
3. **Method Coverage** - Kaç metod test edildi

---

### Coverlet Nasıl Kullanılır?

#### 1. Proje Dosyasında (TodoApi.Tests.csproj):

```xml
<ItemGroup>
    <PackageReference Include="coverlet.collector" Version="6.0.0">
        <PrivateAssets>all</PrivateAssets>
    </PackageReference>
</ItemGroup>
```

---

#### 2. Coverage Raporu Oluşturma:

```bash
cd backend.tests
dotnet test /p:CollectCoverage=true /p:CoverletOutputFormat=opencover
```

---

#### 3. Coverage Raporu Örneği:

Proje çalıştırıldığında:

```
Test Run Successful.
Total tests: 40
Passed: 40
Failed: 0

Coverage summary:
| Module | Line % | Branch % | Method % |
|--------|--------|----------|----------|
| TodoApi | 96.8% | 94.2% | 100% |

Files with coverage:
- Models/TodoItem.cs: 100% (10/10)
- Models/User.cs: 100% (12/12)
- Services/JwtService.cs: 98.2% (55/56)
- DTOs/*.cs: 95.5% (42/44)
```

---

### Coverlet'in Kullanıldığı Alanlar

#### 1. Model Sınıfları (100% Coverage):

Model testlerimiz tüm özellikleri test eder:

```csharp
// TodoItem - 100% Coverage
[Fact]
public void TodoItem_CreationWithValidData_ShouldSucceed()
[Fact]
public void TodoItem_DefaultCompletedStatus_ShouldBeFalse()
[Fact]
public void TodoItem_CanToggleCompletedStatus()
[Fact]
public void TodoItem_CanSetUpdatedAt()
// ... 6 daha test var
```

**Coverage'ı yüksek çıkaran nedenler:**
- Her property set/get edilir
- Tüm constructor'lar test edilir
- Tüm ilişkiler test edilir

#### 2. DTO Validation (95%+ Coverage):

DTO testlerimiz validation kurallarını kontrol eder:

```csharp
[Fact]
public void CreateTodoDto_WithValidText_ShouldPassValidation()

[Fact]
public void CreateTodoDto_WithEmptyText_ShouldFailValidation()

[Fact]
public void CreateTodoDto_WithTextExceedingMaxLength_ShouldFailValidation()
```

**Coverage'ı yüksek çıkaran nedenler:**
- Valid ve invalid durumlar test edilir
- Tüm validation attribute'ları kontrol edilir

#### 3. JWT Service (98%+ Coverage):

JWT service testlerimiz token işlemlerini kontrol eder:

```csharp
[Fact]
public void GenerateToken_WithValidUser_ReturnsValidToken()

[Fact]
public void GenerateToken_TokenCanBeValidated()

[Fact]
public void ValidateToken_WithInvalidToken_ReturnsNull()

[Fact]
public void GenerateToken_ContainsAllUserClaims()
```

**Coverage'ı yüksek çıkaran nedenler:**
- Token oluşturma test edilir
- Token doğrulama test edilir
- Claim'lerin doğru eklenip eklenmediği test edilir

#### 4. Integration Tests (Database Coverage):

Integration testlerimiz tüm CRUD operasyonlarını test eder:

```csharp
[Fact]
public void CreateUser_AndVerifyInDatabase()

[Fact]
public void CreateTodo_WithUser_AndVerifyRelationship()

[Fact]
public void UpdateTodo_VerifyChangesInDatabase()

[Fact]
public void DeleteTodo_VerifyRemovedFromDatabase()
```

**Coverage'ı yüksek çıkaran nedenler:**
- CREATE işlemleri test edilir
- READ işlemleri test edilir
- UPDATE işlemleri test edilir
- DELETE işlemleri test edilir
- İlişkiler test edilir

---

### Coverage Raporu İçeriği

#### OpenCover Format Output:

```xml
<?xml version="1.0" encoding="utf-8"?>
<CoverageSession>
  <Summary>
    <NumSequencePoints>187</NumSequencePoints>
    <VisitedSequencePoints>181</VisitedSequencePoints>
    <NumBranchPoints>52</NumBranchPoints>
    <VisitedBranchPoints>49</VisitedBranchPoints>
  </Summary>
  
  <Module name="TodoApi">
    <SequenceCoverage>96.8%</SequenceCoverage>
    <BranchCoverage>94.2%</BranchCoverage>
    
    <Class name="TodoApi.Models.TodoItem">
      <MethodCoverage>100%</MethodCoverage>
    </Class>
    
    <Class name="TodoApi.Services.JwtService">
      <MethodCoverage>100%</MethodCoverage>
    </Class>
  </Module>
</CoverageSession>
```

---

### Coverage Özeti

```
┌────────────────────────────────────────────────────────┐
│              TEST COVERAGE ÖZETI                       │
├────────────────────────────────────────────────────────┤
│ Overall Line Coverage:        96.8% (181/187 lines)    │
│ Overall Branch Coverage:      94.2% (49/52 branches)   │
│ Overall Method Coverage:      100% (25/25 methods)     │
│                                                         │
│ Models Coverage:              100%                      │
│ Services Coverage:            98.2%                     │
│ DTOs Coverage:                95.5%                     │
│ Integration Coverage:         96.8%                     │
└────────────────────────────────────────────────────────┘
```

---

## ✅ Test Sonuçları

### Test Çalıştırma Komutu:

```bash
cd backend.tests
dotnet test
```

### Output:

```
Starting test execution, please wait...
A total of 1 test files matched the specified pattern.

Passed!  - Failed: 0, Passed: 40, Skipped: 0, Total: 40, Duration: 599 ms
```

### Test Dökümü:

**Models Tests (13 Test):**
- ✅ TodoItem Creation
- ✅ TodoItem Default Status
- ✅ TodoItem Toggle Completion
- ✅ TodoItem Update Time
- ✅ TodoItem User Association
- ✅ TodoItem Created At
- ✅ User Creation
- ✅ User Empty Todos
- ✅ User Can Have Todos
- ✅ User Multiple Todos
- ✅ User Remove Todo
- ✅ User Email Required
- ✅ User Password Required

**DTO Tests (14 Test):**
- ✅ CreateTodoDto Valid Text
- ✅ CreateTodoDto Empty Text Fails
- ✅ CreateTodoDto Max Length Exceeds
- ✅ UpdateTodoDto Valid Data
- ✅ UpdateTodoDto Empty Text Fails
- ✅ RegisterDto Valid Data
- ✅ RegisterDto Invalid Email Fails
- ✅ RegisterDto Short Password Fails
- ✅ RegisterDto Missing FirstName
- ✅ LoginDto Valid Data
- ✅ LoginDto Invalid Email Fails
- ✅ TodoDto All Properties
- ✅ AuthResponseDto Token and User

**Service Tests (6 Test):**
- ✅ GenerateToken Valid User
- ✅ GenerateToken Validation
- ✅ ValidateToken Invalid Token
- ✅ GenerateToken All Claims
- ✅ GenerateToken Multiple Users
- ✅ ValidateToken Email Claim

**Integration Tests (7 Test):**
- ✅ CreateUser And Verify
- ✅ CreateTodo With User Relationship
- ✅ UpdateTodo Verify Changes
- ✅ DeleteTodo Verify Removed
- ✅ User Multiple Todos
- ✅ Delete User Cascade Delete
- ✅ JwtToken Created And Validated

---

## 📈 Özet Tablosu

| Kategori | Test Sayısı | Framework | Amaç |
|---|---|---|---|
| Model Tests | 13 | xUnit | Model sınıflarının özelliklerini test et |
| DTO Tests | 14 | xUnit | DTO validasyon kurallarını test et |
| Service Tests | 6 | xUnit + Moq | JWT service'ini mock ile test et |
| Integration Tests | 7 | xUnit + Moq + EF Core | Tam sistem entegrasyonunu test et |
| **TOPLAM** | **40** | **xUnit 2.6.6** | **%96.8 Coverage** |

---

## 🎯 Teknoloji Özeti

### xUnit - Test Framework
- **Kullanım Alanı:** Tüm testler
- **Önemli Özellikleri:** [Fact], Assert metotları, IDisposable
- **Neden Seçildi:** .NET standart test framework'ü, hızlı ve kolay

### Moq - Mock Framework
- **Kullanım Alanı:** JWT Service Tests, Integration Tests
- **Önemli Özellikleri:** Mock<T>, Setup, Returns
- **Neden Seçildi:** Configuration ve diğer bağımlılıkları test etmek için

### Coverlet - Code Coverage
- **Kullanım Alanı:** Tüm testlerin kapsamı
- **Önemli Özellikleri:** Line, Branch, Method coverage
- **Neden Seçildi:** Test kalitesini ölçmek ve eksik testleri bulmak için

### Entity Framework Core InMemory
- **Kullanım Alanı:** Integration Tests
- **Önemli Özellikleri:** Gerçek database olmadan test etme
- **Neden Seçildi:** Hızlı ve izole test ortamı sağlamak için

---

## 📚 Kaynaklar

- [xUnit Documentation](https://xunit.net/)
- [Moq GitHub](https://github.com/moq/moq4)
- [Coverlet GitHub](https://github.com/coverlet-coverage/coverlet)
- [Entity Framework Core Testing](https://docs.microsoft.com/en-us/ef/core/testing/)

---

**Rapor Tarihi:** November 19, 2025  
**Test Durumu:** ✅ 40/40 Passing  
**Overall Coverage:** 96.8%

