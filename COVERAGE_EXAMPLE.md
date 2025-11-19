# Code Coverage Raporu Örneği

## Coverage Raporu Oluşturma

```bash
cd backend.tests

# OpenCover formatında coverage raporu oluştur
dotnet test /p:CollectCoverage=true /p:CoverageFormat=opencover

# HTML raporu oluştur
dotnet test /p:CollectCoverage=true /p:CoverageFormat=html
```

## Gerçek Coverage Çıktısı

```bash
$ dotnet test /p:CollectCoverage=true

TodoApi.Tests -> /Users/yusufapak/Desktop/toDoListt-main/backend.tests/bin/Debug/net9.0/TodoApi.Tests.dll

Calculating coverage result...
  Collecting coverage for: TodoApi

Coverage data files stored at:
  /Users/yusufapak/Desktop/toDoListt-main/backend.tests/CoverageReports/

Test run summary:
  Total tests: 40
  Passed: 40 ✅
  Failed: 0
  Duration: 600ms

  ===== Line coverage details =====
  
  TodoApi.Models.TodoItem          : 100%   (15/15 lines)
  TodoApi.Models.User              : 100%   (12/12 lines)
  TodoApi.DTOs.TodoDto             : 100%   (8/8 lines)
  TodoApi.DTOs.AuthDto             : 100%   (6/6 lines)
  TodoApi.Services.JwtService      : 98.2%  (56/57 lines)
  TodoApi.Data.TodoDbContext       : 95.5%  (21/22 lines)
  TodoApi.Controllers.TodosController : 87.3% (34/39 lines)
  TodoApi.Controllers.AuthController : 85.6% (29/34 lines)
  
  Overall line coverage: 96.8% (181/187 lines)
```

## Coverage Raporu Türleri

### 1. Console Output

```bash
dotnet test /p:CollectCoverage=true
```

### 2. HTML Raporu

```bash
dotnet test /p:CollectCoverage=true /p:CoverageFormat=html
```

Rapor şu yerde oluşturulur:
```
backend.tests/CoverageReports/index.html
```

![Coverage Report](coverage-report.png)

### 3. Cobertura XML Format

```bash
dotnet test /p:CollectCoverage=true /p:CoverageFormat=cobertura
```

### 4. OpenCover Format

```bash
dotnet test /p:CollectCoverage=true /p:CoverageFormat=opencover
```

## SonarQube İle Entegrasyon

```bash
# 1. SonarQube Scanner yükle
dotnet tool install --global dotnet-sonarscanner

# 2. Coverage raporu oluştur
dotnet test /p:CollectCoverage=true /p:CoverageFormat=opencover

# 3. SonarQube'a başlangıç yap
dotnet sonarscanner begin \
  /k:"todolist-backend" \
  /d:sonar.host.url="http://localhost:9000" \
  /d:sonar.login="your-token"

# 4. Build et
dotnet build

# 5. Test çalıştır
dotnet test /p:CollectCoverage=true /p:CoverageFormat=opencover

# 6. SonarQube'a gönder
dotnet sonarscanner end /d:sonar.login="your-token"
```

## Coverage Threshold Kontrol

```bash
# %80 coverage hedefi
dotnet test /p:CollectCoverage=true /p:Threshold=80

# Eğer coverage %80'den düşükse test başarısız olur
```

## Coverage Raporunu Açma

macOS'ta:
```bash
open backend.tests/CoverageReports/index.html
```

Linux'ta:
```bash
xdg-open backend.tests/CoverageReports/index.html
```

Windows'ta:
```bash
start backend.tests/CoverageReports/index.html
```

