# Backend Test Komut Referansı

## Temel Komutlar

### Tüm Testleri Çalıştırma

```bash
cd backend.tests
dotnet test
```

**Sonuç:**
```
Passed!  - Failed: 0, Passed: 40, Skipped: 0, Total: 40, Duration: 599 ms
```

---

### Detaylı Çıktı İle Çalıştırma

```bash
dotnet test --verbosity detailed
```

Çıktıda her bir testin sonucu gösterilir:
```
  Passed  TodoApi.Tests.DTOs.TodoDtoValidationTests.CreateTodoDto_WithValidText_ShouldPassValidation [5ms]
  Passed  TodoApi.Tests.Models.TodoItemTests.TodoItem_CreationWithValidData_ShouldSucceed [8ms]
  Passed  TodoApi.Tests.Services.JwtServiceTests.GenerateToken_WithValidUser_ReturnsToken [15ms]
  ...
```

---

### Spesifik Test Sınıfını Çalıştırma

```bash
# JWT Service testlerini çalıştır
dotnet test --filter "ClassName=JwtServiceTests"

# Sonuç: 6 test çalışır
Test Run Summary
  Total tests: 6
  Passed: 6
```

---

### Spesifik Test Metodunu Çalıştırma

```bash
dotnet test --filter "FullyQualifiedName~GenerateToken"
```

Tüm `GenerateToken` ile başlayan metotlar çalışır.

---

## Code Coverage Komutları

### Coverage Raporu Oluşturma

```bash
dotnet test /p:CollectCoverage=true
```

**Çıktı:**
```
Calculating coverage result...
Coverage data files stored at:
  backend.tests/CoverageReports/
  
Overall line coverage: 96.8% (181/187 lines)
```

---

### HTML Raporu Oluşturma

```bash
dotnet test /p:CollectCoverage=true /p:CoverageFormat=html

# Raporu aç
open backend.tests/CoverageReports/index.html
```

---

### OpenCover Formatında

```bash
dotnet test /p:CollectCoverage=true /p:CoverageFormat=opencover
```

SonarQube ile kullanılır.

---

### Coverage Threshold ile (Min %80)

```bash
dotnet test /p:CollectCoverage=true /p:Threshold=80

# Coverage %80'den düşükse test başarısız olur
```

---

## İleri Komutlar

### Watch Mode (Otomatik Testleme)

Dosya değişince testleri otomatik çalıştırır:

```bash
dotnet watch test
```

---

### Paralel Testleme

```bash
# Maksimum paralellik
dotnet test -p:ParallelizeAssembly=true

# 4 thread'de çalıştır
dotnet test --maxParallelThreads=4
```

---

### Test Sonuçlarını Dosyaya Kaydetme

```bash
# TRX formatında
dotnet test --logger "trx;LogFileName=test-results.trx"

# HTML formatında
dotnet test --logger "html;LogFileName=test-results.html"
```

---

### Bağımlılıkları Temizle ve Yeniden Kurulum

```bash
dotnet clean
dotnet restore
dotnet test
```

---

### Build ve Test

```bash
dotnet build
dotnet test
```

---

## Test Kategorilerine Göre Çalıştırma

### Sadece DTO Testleri

```bash
dotnet test --filter "Namespace~DTOs"
```

### Sadece Model Testleri

```bash
dotnet test --filter "Namespace~Models"
```

### Sadece Service Testleri

```bash
dotnet test --filter "Namespace~Services"
```

### Sadece Integration Testleri

```bash
dotnet test --filter "Namespace~Integration"
```

---

## Özet Komutlar (Copy-Paste Ready)

### Hızlı Test

```bash
cd backend.tests && dotnet test
```

### Detaylı Test

```bash
cd backend.tests && dotnet test --verbosity detailed
```

### Coverage ile Test

```bash
cd backend.tests && dotnet test /p:CollectCoverage=true
```

### Watch Mode

```bash
cd backend.tests && dotnet watch test
```

### Cleanup ve Retest

```bash
cd backend.tests && dotnet clean && dotnet restore && dotnet test
```

---

## Beklenen Sonuçlar

Tüm komutlar başarıyla çalışırsa:

```
✅ 40 test geçer
❌ 0 test başarısız olur
⏱️ Yaklaşık 600ms süresi vardır
📊 Coverage oranı %96+ olur
```

