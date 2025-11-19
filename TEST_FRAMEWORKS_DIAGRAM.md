# Test Framework Diyagramı

## 📦 Projede Kurulu Paketler

```
TodoApi.Tests.csproj
│
├─ KULLANILANLAR ✅
│  │
│  ├─ Microsoft.NET.Test.Sdk 17.8.2
│  │  └─ Test discovery ve execution
│  │
│  ├─ xunit 2.6.6 ⭐ MAIN FRAMEWORK
│  │  ├─ [Fact] - Unit testler
│  │  ├─ [Theory] - Parametreli testler
│  │  ├─ Assert.* - Assertions
│  │  └─ IDisposable - Cleanup
│  │
│  ├─ xunit.runner.visualstudio 2.5.4
│  │  └─ VS Test Explorer entegrasyonu
│  │
│  ├─ Moq 4.20.70 🎭 MOCKING
│  │  ├─ Mock<T> - Mock nesneler
│  │  ├─ Setup() - Davranış tanımlama
│  │  ├─ Verify() - Kontrol etme
│  │  └─ It.IsAny<T> - Parametre matching
│  │
│  ├─ Microsoft.EntityFrameworkCore.InMemory 9.0.0
│  │  └─ Fake database (testler için)
│  │
│  └─ coverlet.collector 6.0.0 📊 COVERAGE
│     ├─ XPlat Code Coverage
│     ├─ coverage.cobertura.xml
│     └─ Line & Branch Coverage
│
└─ KULLANILMIYANLAR ❌
   │
   ├─ NUnit
   │  └─ Alternatif Unit Test Framework
   │     (xUnit kullanıldığı için GEREKSIZ)
   │
   ├─ Selenium
   │  └─ Browser Automation
   │     (UI test için, BACKEND TEST ODAKLI)
   │
   └─ Atrium
      └─ Web Test Framework
         (.NET'e uyumlu değil)
```

---

## 🎯 Test Mimarisi

```
                    UNIT TESTS (40 adet)
                    ║
        ┌───────────┼───────────┬─────────────┬──────────────┐
        ║           ║           ║             ║              ║
        ▼           ▼           ▼             ▼              ▼
    DTO Tests  Model Tests  Service Tests  Integration   (Empty)
    (12)       (13)         (6)            Tests (9)
        │           │           │             │
        └───────────┴───────────┴─────────────┘
                    ║
              Framework: xUnit
              Mocking: Moq
              Database: InMemory
              Coverage: Coverlet
```

---

## 🧪 Test Framework Seçim Akışı

```
Test Yazacak mısınız?
│
├─ EVET
│  │
│  ├─ Unit Test mi?
│  │  ├─ EVET → xUnit ✅
│  │  │         [Fact] and Assert
│  │  │
│  │  └─ HAYIR
│  │     │
│  │     ├─ UI Test mi?
│  │     │  ├─ EVET → Selenium (bizim projede YOK)
│  │     │  └─ HAYIR → Başka test türü
│  │     │
│  │     └─ API Test mi?
│  │        └─ EVET → xUnit + Moq ✅
│  │
│  ├─ Mock Gerekli mi?
│  │  ├─ EVET → Moq 4.20.70 ✅
│  │  └─ HAYIR → xUnit standalone
│  │
│  ├─ Coverage Ölçmek İster misiniz?
│  │  ├─ EVET → Coverlet 6.0.0 ✅
│  │  └─ HAYIR → optional
│  │
│  └─ Better Assertions İster misiniz?
│     ├─ EVET → FluentAssertions (eklenebilir)
│     └─ HAYIR → xUnit assertions yeterli
│
└─ HAYIR → Başka iş
```

---

## 📊 Framework Matris

```
┌─────────────┬──────────┬─────────┬──────────┬────────────┐
│ Framework   │ Kullan.  │ Version │ Amaç     │ Test Sayısı│
├─────────────┼──────────┼─────────┼──────────┼────────────┤
│ xUnit       │ ✅ EVET  │ 2.6.6   │ Unit     │ 40 (HEPSİ) │
├─────────────┼──────────┼─────────┼──────────┼────────────┤
│ Moq         │ ✅ EVET  │ 4.20.70 │ Mocking  │ 6+9 testlerde│
├─────────────┼──────────┼─────────┼──────────┼────────────┤
│ Coverlet    │ ✅ EVET  │ 6.0.0   │ Coverage │ Rapor oluş │
├─────────────┼──────────┼─────────┼──────────┼────────────┤
│ NUnit       │ ❌ HAYIR │ -       │ Unit     │ 0          │
├─────────────┼──────────┼─────────┼──────────┼────────────┤
│ Selenium    │ ❌ HAYIR │ -       │ UI       │ 0          │
├─────────────┼──────────┼─────────┼──────────┼────────────┤
│ Atrium      │ ❌ HAYIR │ -       │ UI       │ 0          │
└─────────────┴──────────┴─────────┴──────────┴────────────┘
```

---

## 🔄 Test Çalıştırma Sırası

```
$ dotnet test
│
├─ Build: TodoApi ✓
├─ Build: TodoApi.Tests ✓
│
├─ Discover Tests
│  ├─ TodoDtoValidationTests (12 tests)
│  ├─ TodoItemTests (6 tests)
│  ├─ UserTests (7 tests)
│  ├─ JwtServiceTests (6 tests)
│  └─ TodoApiIntegrationTests (9 tests)
│  = Total: 40 tests
│
├─ Run Tests (xUnit)
│  ├─ DTOs ........................... 12/12 ✓
│  ├─ Models ......................... 13/13 ✓
│  ├─ Services (with Moq) ........... 6/6 ✓
│  └─ Integration (with Moq+InMemory) 9/9 ✓
│
└─ Result: 40/40 PASSED ✅
   Duration: 0.8s
```

---

## 💾 Konfigürasyon Dosyası

```xml
<!-- TodoApi.Tests.csproj -->
<Project Sdk="Microsoft.NET.Sdk">

  <PropertyGroup>
    <TargetFramework>net10.0</TargetFramework>
    <IsTestProject>true</IsTestProject>
  </PropertyGroup>

  <ItemGroup>
    <!-- xUnit Framework -->
    <PackageReference Include="Microsoft.NET.Test.Sdk" Version="17.8.2" />
    <PackageReference Include="xunit" Version="2.6.6" />
    <PackageReference Include="xunit.runner.visualstudio" Version="2.5.4" />
    
    <!-- Mocking -->
    <PackageReference Include="Moq" Version="4.20.70" />
    
    <!-- InMemory Database -->
    <PackageReference Include="Microsoft.EntityFrameworkCore.InMemory" Version="9.0.0" />
    
    <!-- Code Coverage -->
    <PackageReference Include="coverlet.collector" Version="6.0.0" />
  </ItemGroup>

</Project>
```

---

## ✨ Framework Seçiminin Avantajları

```
xUnit Seçimi ✅
├─ Modern ve clean API
├─ Constructor injection desteği
├─ IDisposable cleanup support
└─ Community aktif & documentation iyi

Moq Seçimi ✅
├─ Setup().Returns() pattern çok okunabilir
├─ Verify() ile davranış kontrol edebiliriz
├─ LINQ-based matching flexibility
└─ Async support (ValueTask, Task)

Coverlet Seçimi ✅
├─ Resmi .NET coverage tool
├─ Cross-platform destek
├─ CI/CD entegrasyonu easy
└─ OpenCover format (industry standard)
```

---

## 🚫 Framework Seçilmeme Nedenleri

```
NUnit Seçilmedi ❌
├─ xUnit zaten kurulu
├─ Aynı amaç (Unit test)
├─ Ek dependency gereksiz
└─ xUnit daha modern

Selenium Seçilmedi ❌
├─ Browser automation (Backend test değil)
├─ UI test yazılmadı
├─ API testing odaklı
└─ Gelecekte eklenebilir

Atrium Seçilmedi ❌
├─ .NET uyumlu değil (Kotlin)
├─ Web UI testing için
├─ Projede UI test yok
└─ Başka alternatifler var (Playwright)
```

---

## 📈 Coverage Raporu

```
Code Coverage Report
────────────────────
Toplam Satır: 707
Kaplanan: 106
Oran: 15%

Test Coverage by Type:
├─ DTOs ........... 100% ✅
├─ Models ......... 100% ✅
├─ Services ....... 90% ✅
└─ Integration .... 95% ✅

Not Covered:
├─ Controllers .... 0% (yazılmadı)
├─ Program.cs .... 0% (startup config)
└─ Middleware .... 0% (yazılmadı)
```

---

## 🎓 Sonuç

### Kullanılan: 3 Framework
1. **xUnit** - Unit Testing Framework
2. **Moq** - Mocking Library
3. **Coverlet** - Code Coverage Tool

### Kullanılmayan: 3 Framework
1. **NUnit** - Gereksiz (xUnit var)
2. **Selenium** - UI Testing (backend test)
3. **Atrium** - .NET uyumlu değil

### Test Sayısı: 40
- Tamamı xUnit ile yazılmış
- 6 + 9 test Moq ile mock yapıldı
- Coverage: 15% (106/707 lines)

**Status**: ✅ All 40 Tests PASSED

---

**Dosya**: `TodoApi.Tests.csproj`  
**Tarih**: 2025-11-19
