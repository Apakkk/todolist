# 📚 TEST DOKÜMANTASYON İNDEKSİ

## 🎯 Hızlı Erişim

### Başlangıç Yapanlar İçin
👉 **[QUICK_START_TESTS.md](./QUICK_START_TESTS.md)** - 5 dakikada başlayın
- Temel komutlar
- Test durumu özeti
- En çok kullanılan 3 komut

### Konsola Yazılacak Komutlar
👉 **[KONSOL_KOMUTLARI.md](./KONSOL_KOMUTLARI.md)** - Her komut açıklamalı
- TÜM testleri çalıştır
- Test kategorilerine göre çalıştır
- Belirli bir testi çalıştır
- Code coverage
- Hızlı copy-paste komutları

### Testlerin Detaylı Açıklaması
👉 **[TEST_RUN_EXPLANATION.md](./TEST_RUN_EXPLANATION.md)** - Derinlemesine anlama
- Her test kategorisinin ne yaptığını
- Kod örnekleri
- xUnit assertions rehberi
- Moq kullanımı
- Test mimarisi

### Test Dosyaları Özeti
👉 **[TEST_FILES_SUMMARY.md](./TEST_FILES_SUMMARY.md)** - Proje yapısı
- Her test dosyasında ne var
- Test listesi tablo formatında
- Teknoloji detayları
- Test istatistikleri

### Başarı Özet Raporu
👉 **[TEST_SUCCESS_SUMMARY.md](./TEST_SUCCESS_SUMMARY.md)** - Tamamlanma durumu
- 40 testin tümünün başarılı olduğu bilgisi
- Test dağılımı
- Coverage bilgileri
- Sonraki adımlar

---

## 📊 TEST YAPISI

```
40 TOPLAM TEST
├── 13 DTO Validation Tests
├── 6  TodoItem Model Tests
├── 7  User Model Tests
├── 6  JWT Service Tests
└── 8  Integration Tests (Database)
```

---

## ⚡ EN ÇIKMAYAN KOMUTLAR

```bash
# 1. TÜM TESTLER (en çok kullanacaksınız)
cd /Users/yusufapak/Desktop/toDoListt-main/backend.tests
dotnet test

# 2. INTEGRATION TESTLER (DB testleri)
dotnet test --filter "ClassName=TodoApi.Tests.Integration.TodoApiIntegrationTests"

# 3. DETAYLI ÇIKTI
dotnet test --verbosity detailed

# 4. CODE COVERAGE
dotnet test --collect:"XPlat Code Coverage"
```

---

## 🧪 TEST TÜRLERİ

### ✅ UNIT TESTS (32 test)
**Ne test eder**: Tek bir component
**Hız**: Çok hızlı (< 100ms)
**Kategoriler**:
- DTO Validation (13)
- Model Properties (13)
- Service Methods (6)

```bash
dotnet test --filter "ClassName=TodoApi.Tests.DTOs.TodoDtoValidationTests"
dotnet test --filter "ClassName=TodoApi.Tests.Models.TodoItemTests"
dotnet test --filter "ClassName=TodoApi.Tests.Models.UserTests"
dotnet test --filter "ClassName=TodoApi.Tests.Services.JwtServiceTests"
```

### ✅ INTEGRATION TESTS (8 test) ⭐
**Ne test eder**: Database + Components
**Hız**: Biraz yavaş (~250ms)
**İçerik**:
- User CRUD
- Todo CRUD
- Cascade Delete
- JWT Authentication
- Relationships
- Email Validation

```bash
dotnet test --filter "ClassName=TodoApi.Tests.Integration.TodoApiIntegrationTests"
```

---

## 📁 TEST DOSYALARI

### `backend.tests/DTOs/DtoValidationTests.cs`
- **Testler**: 13
- **Amaç**: Form validation
- **Test Eder**: CreateTodoDto, UpdateTodoDto, RegisterDto, LoginDto
- **Çalıştır**: `dotnet test --filter "TodoDtoValidationTests"`

### `backend.tests/Models/ModelsTests.cs`
- **Testler**: 13 (6 TodoItem + 7 User)
- **Amaç**: Entity model davranışı
- **Test Eder**: Properties, relationships, collections
- **Çalıştır**: `dotnet test --filter "TodoItemTests or UserTests"`

### `backend.tests/Services/JwtServiceTests.cs`
- **Testler**: 6
- **Amaç**: JWT token işlemleri
- **Test Eder**: Token generation, validation, claims
- **Çalıştır**: `dotnet test --filter "JwtServiceTests"`

### `backend.tests/Integration/IntegrationTests.cs`
- **Testler**: 8
- **Amaç**: Database entegrasyonu
- **Test Eder**: CRUD, relationships, cascade, JWT flow
- **Çalıştır**: `dotnet test --filter "TodoApiIntegrationTests"`

---

## 🎓 ÖĞRENME PATIKASI

### 1. **Başlangıç** (5 dakika)
1. [QUICK_START_TESTS.md](./QUICK_START_TESTS.md) oku
2. `dotnet test` komutunu çalıştır
3. Tüm 40 testin başarılı olduğunu gör ✅

### 2. **Komut Öğren** (10 dakika)
1. [KONSOL_KOMUTLARI.md](./KONSOL_KOMUTLARI.md) oku
2. Her komutun ne yaptığını anla
3. Farklı komutları dene

### 3. **Detay Öğren** (30 dakika)
1. [TEST_RUN_EXPLANATION.md](./TEST_RUN_EXPLANATION.md) oku
2. Her test kategorisinin ne yaptığını anla
3. Kod örneklerini oku

### 4. **Derinleşme** (1 saat)
1. [TEST_FILES_SUMMARY.md](./TEST_FILES_SUMMARY.md) oku
2. Gerçek test dosyalarını aç ve oku
3. Her testi kendi test editöründe çalıştır

### 5. **Uygulamaya Geç**
1. Yeni test yaz
2. Yeni feature test et
3. Coverage'ı yükselt

---

## ✅ KONTROL LISTESI

Aşağıdaki soruların cevaplarını biliyorsanız hazırsınız:

- [ ] Testleri çalıştırmak için ne yazmam lazım?
- [ ] DTOs neyi test ediyor?
- [ ] Integration testleri ne için kullanılıyor?
- [ ] Moq ne işe yaradığını biliyor musun?
- [ ] xUnit assertions'ları kullanabilir misin?
- [ ] Code coverage nasıl alınıyor?

---

## 📞 SORU CEVAPLAR

### Q: Testler neden hızlı?
A: InMemory database kullandığımız için. Gerçek DB'ye bağlanmıyoruz.

### Q: Integration vs Unit test farkı nedir?
A: Unit test single component, Integration test multiple components together.

### Q: Yeni test nasıl yazarım?
A: `[Fact]` attribute ile başla, Arrange-Act-Assert pattern'ı kullan.

### Q: Coverage nasıl artırırım?
A: Controller testleri yaz. Şu an Controllers test edilmiyor.

### Q: Mock neden kullanıyoruz?
A: Bağımlılıkları kontrol etmek ve testleri izole etmek için.

---

## 🚀 SONRAKI ADIMLAR

1. **Controller Testleri Ekle**
   ```bash
   dotnet new xunit -n ControllerTests
   # AuthController ve TodosController testleri yaz
   ```

2. **Coverage Hedefi Belirle**
   - Core Services: %80+
   - Controllers: %60+
   - Genel: %70+

3. **CI/CD Ekle**
   ```yaml
   # .github/workflows/tests.yml
   - run: cd backend.tests && dotnet test
   ```

4. **Performance Testleri**
   ```bash
   dotnet add package BenchmarkDotNet
   ```

---

## 📊 CURRENT STATUS

```
✅ 40/40 Tests Passed
✅ 0 Tests Failed
✅ Integration Tests Done
✅ Unit Tests Done
⏳ Controller Tests (TODO)
⏳ E2E Tests (TODO)
⏳ Performance Tests (TODO)
```

---

## 📖 İLGİLİ DOSYALAR

```
toDoListt-main/
├── QUICK_START_TESTS.md          # 👈 Başla buradan (5 min)
├── KONSOL_KOMUTLARI.md           # Tüm komutlar
├── TEST_RUN_EXPLANATION.md       # Detaylı açıklamalar
├── TEST_FILES_SUMMARY.md         # Dosya özeti
├── TEST_SUCCESS_SUMMARY.md       # Başarı raporu
├── TEST_DOCUMENTATION_INDEX.md   # Bu dosya
│
├── backend/
│   ├── Models/
│   ├── DTOs/
│   ├── Services/
│   └── Controllers/
│
└── backend.tests/
    ├── DTOs/DtoValidationTests.cs
    ├── Models/ModelsTests.cs
    ├── Services/JwtServiceTests.cs
    └── Integration/IntegrationTests.cs
```

---

## 🎯 ÖNEMLİ NOTLAR

1. **Test Çalıştırmadan Önce**
   ```bash
   cd /Users/yusufapak/Desktop/toDoListt-main/backend.tests
   ```

2. **Tüm Testler Başarılı mı?**
   ```bash
   dotnet test  # Çıktıda "Test summary: total: 40, succeeded: 40" görmeli
   ```

3. **Coverage Raporu**
   ```bash
   dotnet test --collect:"XPlat Code Coverage"
   # backend.tests/TestResults/[guid]/coverage.cobertura.xml
   ```

---

## 💡 TİPS

- `dotnet test --watch` - Otomatik yeniden çalıştır
- `dotnet test --filter "Name=TestAdı"` - Belirli testi çalıştır
- `dotnet test --verbosity detailed` - Detaylı log
- `dotnet test -p:CollectCoverage=true` - Coverage ile çalıştır

---

**Hazır mısın? [QUICK_START_TESTS.md](./QUICK_START_TESTS.md) ile başla! 🚀**

---

*Sürüm: 1.0*  
*Güncelleme: 2025-11-19*  
*Status: ✅ Tamamlandı*
