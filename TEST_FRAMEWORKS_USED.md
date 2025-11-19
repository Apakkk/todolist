# Test Framework'leri - Kullanılan ve Kullanılmayan

## 📋 Özet Tablo

| Framework | Kullanılıyor | Versiyon | Amaç |
|-----------|:------------:|----------|------|
| **xUnit** | ✅ **EVET** | 2.6.6 | Unit test framework |
| **NUnit** | ❌ HAYIR | - | Alternatif test framework |
| **Moq** | ✅ **EVET** | 4.20.70 | Mock nesneler oluşturma |
| **Coverlet** | ✅ **EVET** | 6.0.0 | Code coverage ölçümü |
| **Selenium** | ❌ HAYIR | - | Web browser otomasyonu (UI test) |
| **Atrium** | ❌ HAYIR | - | Web test framework (UI test) |

---

## ✅ KULLANILANLAR

### 1. **xUnit** (Unit Test Framework)
```xml
<PackageReference Include="xunit" Version="2.6.6" />
<PackageReference Include="xunit.runner.visualstudio" Version="2.5.4" />
<PackageReference Include="Microsoft.NET.Test.Sdk" Version="17.8.2" />
```

**Ne yapıyor?**
- Unit testleri yazabilmek için framework
- Attribute-based test definition (`[Fact]`, `[Theory]`)
- Assertion methods (Assert.Equal, Assert.NotNull, vb.)

**Örnek Kullanım**:
```csharp
[Fact]
public void CreateTodoDto_WithValidText_ShouldPassValidation()
{
    // Arrange
    var dto = new CreateTodoDto { Text = "Valid text" };
    
    // Act
    var results = ValidateDto(dto);
    
    // Assert
    Assert.Empty(results);
}
```

**Test Sayısı**: 40 test (tamamı xUnit ile yazılmış)

---

### 2. **Moq** (Mocking Framework)
```xml
<PackageReference Include="Moq" Version="4.20.70" />
```

**Ne yapıyor?**
- Bağımlılıkları mock'lamak (taklit etmek)
- Gerçek veritabanına bağlanmadan test yapmak
- Harici servisler çağrılmadan test yapmak

**Örnek Kullanım**:
```csharp
[Fact]
public void JwtService_UsesConfigurationCorrectly()
{
    // Arrange - Mock oluştur
    var mockConfig = new Mock<IConfiguration>();
    mockConfig
        .Setup(c => c["JWT:Secret"])
        .Returns("test-secret-key");
    
    var jwtService = new JwtService(mockConfig.Object);
    
    // Act
    var user = new User { Id = 1, Email = "test@example.com" };
    var token = jwtService.GenerateToken(user);
    
    // Assert
    Assert.NotNull(token);
}
```

**Kullanılan Yerler**:
- `JwtServiceTests.cs` - JWT token oluşturma/doğrulama
- `Integration/IntegrationTests.cs` - DbContext mock'lama (InMemory DB için)

---

### 3. **Coverlet** (Code Coverage)
```xml
<PackageReference Include="coverlet.collector" Version="6.0.0" />
```

**Ne yapıyor?**
- Testlerin kodun ne kadarını kapsadığını ölçmek
- Coverage raporu oluşturmak (XML, JSON, HTML formatlarında)

**Komut**:
```bash
dotnet test --collect:"XPlat Code Coverage"
```

**Sonuç**:
```
TestResults/[guid]/coverage.cobertura.xml
- Line Coverage: 15% (106/707 lines)
- Branch Coverage: 0.86%
```

---

## ❌ KULLANILMIYANLAR

### 1. **NUnit**
```xml
<!-- Kullanılmıyor! -->
<!-- <PackageReference Include="NUnit" Version="3.x" /> -->
```

**Neden kullanmıyoruz?**
- xUnit zaten kurulu ve çalışıyor
- Aynı amaç için (Unit Testing)
- xUnit daha modern ve temiz syntax
- NUnit'e gerek yok

**NUnit vs xUnit Farkları**:
```csharp
// NUnit
[TestFixture]
public class NUnitTests
{
    [Test]
    public void TestMethod()
    {
        Assert.AreEqual(5, 5);
    }
}

// xUnit (Bizim Kullandığımız)
public class XUnitTests
{
    [Fact]
    public void TestMethod()
    {
        Assert.Equal(5, 5);
    }
}
```

---

### 2. **Selenium**
```xml
<!-- Kullanılmıyor! -->
<!-- <PackageReference Include="Selenium.WebDriver" Version="4.x" /> -->
```

**Neden kullanmıyoruz?**
- UI (User Interface) automation için
- Browser'ı kontrol etmek (click, type, vb.)
- Bizim testlerimiz unit/integration testleri
- API testlerimiz backend'e yönelik

**Selenium Ne Zaman Kullanılır?**
```csharp
// Selenium örneği (Bizim projede YOK!)
[Test]
public void LoginTest()
{
    var driver = new ChromeDriver();
    driver.Navigate().GoToUrl("http://localhost:5173");
    driver.FindElement(By.Id("email")).SendKeys("test@example.com");
    driver.FindElement(By.Id("password")).SendKeys("password123");
    driver.FindElement(By.Id("loginButton")).Click();
    // Sayfanın yükleneceğini bekle...
}
```

---

### 3. **Atrium** (Testing Automation)
```xml
<!-- Kullanılmıyor! -->
<!-- <PackageReference Include="Atrium" Version="x.x" /> -->
```

**Neden kullanmıyoruz?**
- Atrium Kotlin kütüphanesi (.NET için değil)
- Web automation için (Selenium gibi)
- Bizim projede frontend testleri yok
- Backend API testlerine ihtiyacımız var

---

## 🧪 Test Türleri ve Framework Eşleşmesi

```
Unit Tests (Yazılan testler)
├── DTO Tests (12) ......................... xUnit
├── Model Tests (13) ....................... xUnit
├── Service Tests (6) ...................... xUnit + Moq
└── Integration Tests (9) .................. xUnit + Moq + InMemory DB
    
UI Tests (YAZILMADI)
└── E2E Tests ............................. Selenium veya Playwright
    
Performance Tests (YAZILMADI)
└── Load Tests ............................ BenchmarkDotNet
```

---

## 📊 Detaylı Kullanım İstatistikleri

### xUnit Kullanılan Testler

| Test Dosyası | Satır Sayısı | Test Sayısı | Framework |
|--------------|:------------:|:-----------:|-----------|
| DTOs/DtoValidationTests.cs | 246 | 12 | xUnit |
| Models/ModelsTests.cs | 260 | 13 | xUnit |
| Services/JwtServiceTests.cs | 115 | 6 | xUnit + Moq |
| Integration/IntegrationTests.cs | 303 | 9 | xUnit + Moq + InMemory |
| **TOPLAM** | **924** | **40** | **xUnit** |

### Moq Kullanılan Yerler

```csharp
// 1. JwtServiceTests.cs
var mockConfig = new Mock<IConfiguration>();

// 2. IntegrationTests.cs
var mockConfig = new Mock<IConfiguration>();
mockConfig.Setup(c => c["JWT:Secret"]).Returns("test-secret");
```

### Coverlet Kullanılan Komutlar

```bash
# Coverage raporu oluştur
dotnet test --collect:"XPlat Code Coverage"

# Sonuç: TestResults/[guid]/coverage.cobertura.xml
```

---

## 🎯 Neden Bu Seçimler?

### ✅ xUnit Seçim Nedenileri
1. Modern ve temiz API
2. .NET'in resmi test framework'ü
3. Constructor injection destekleniyor
4. xUnit.net community aktif
5. Visual Studio tam entegre
6. Moq ile mükemmel uyum

### ✅ Moq Seçim Nedenileri
1. En popüler .NET mocking library
2. AAA (Arrange-Act-Assert) pattern uygun
3. Setup/Verify API çok güçlü
4. LINQ-based query matching
5. Async support

### ✅ Coverlet Seçim Nedenileri
1. .NET Core için resmi tool
2. Cross-platform destek
3. OpenCover format (industry standard)
4. VS Code ve CI/CD entegrasyonu
5. Performans iyi

---

## 🚀 Gelecek İçin Öneriler

### Eklenebilecek Framework'ler

#### 1. **Playwright** (UI Testing için)
```bash
dotnet add package Microsoft.Playwright
dotnet add package Xunit
```

```csharp
[Fact]
public async Task LoginPage_CanLogin()
{
    await using var browser = await Chromium.LaunchAsync();
    var page = await browser.NewPageAsync();
    await page.GotoAsync("http://localhost:5173");
    await page.FillAsync("#email", "test@example.com");
    await page.FillAsync("#password", "password123");
    await page.ClickAsync("button:has-text('Login')");
    await Expect(page).ToHaveURLAsync(new Regex(".*dashboard.*"));
}
```

#### 2. **BenchmarkDotNet** (Performance Testing)
```bash
dotnet add package BenchmarkDotNet
```

```csharp
[MemoryDiagnoser]
public class JwtBenchmarks
{
    [Benchmark]
    public string GenerateToken()
    {
        return _jwtService.GenerateToken(_user);
    }
}
```

#### 3. **FluentAssertions** (Better Assertions)
```bash
dotnet add package FluentAssertions
```

```csharp
// Yerine
Assert.Equal("test@example.com", user.Email);

// Yazabiliriz
user.Email.Should().Be("test@example.com");
user.Todos.Should().NotBeEmpty().And.HaveCount(1);
```

---

## 📝 Test Komutları

```bash
# Tüm testleri çalıştır
cd backend.tests
dotnet test

# Detaylı çıktı
dotnet test --verbosity detailed

# Belirli test sınıfını çalıştır
dotnet test --filter "ClassName=TodoApi.Tests.DTOs.TodoDtoValidationTests"

# Coverage raporu oluştur
dotnet test --collect:"XPlat Code Coverage"

# Hızlı mode (cache kullan)
dotnet test --no-restore --no-build
```

---

## 🎓 Öğrenilen Dersler

1. **xUnit Seçimi Doğru** ✅
   - Modern, temiz, powerful
   - Community desteği excellent
   
2. **Moq Seçimi Doğru** ✅
   - Dependencies mock'lama for isolated tests
   - InMemory DB ile combo perfect
   
3. **Coverlet Seçimi Doğru** ✅
   - Coverage tracking önemli
   - CI/CD entegrasyonu kolay

4. **Selenium GEREKSIZ** ❌
   - Backend testlerine yönelik
   - UI testlerine ihtiyaç yok (henüz)

5. **Atrium UYGULANMIYOR** ❌
   - .NET platformunda değil
   - JavaScript/Kotlin kütüphanesi

---

## 📚 İlgili Dosyalar

- `TEST_SUCCESS_SUMMARY.md` - Test sonuçları özeti
- `TEST_RUN_EXPLANATION.md` - Detaylı açıklamalar
- `XUNIT_TEST_GUIDE.md` - xUnit kullanım rehberi
- `TodoApi.Tests.csproj` - Test konfigürasyonu

---

**Kullanılan Framework Özeti**:
- ✅ **xUnit** - Unit Testing
- ✅ **Moq** - Mocking
- ✅ **Coverlet** - Code Coverage
- ❌ **NUnit** - Gereksiz (xUnit var)
- ❌ **Selenium** - UI Testing (yok)
- ❌ **Atrium** - .NET uyumlu değil

**Son Güncelleme**: 2025-11-19
