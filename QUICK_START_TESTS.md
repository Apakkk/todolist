# ⚡ HIZLI BAŞLANGIC - TEST KOMUTLARI

## 📌 En Önemli Komutlar

### 1. TÜM TESTLERI ÇALIŞTIR (En Çok Kullanılacak)
```bash
cd /Users/yusufapak/Desktop/toDoListt-main/backend.tests
dotnet test
```

✅ Tüm 40 test çalışır (0.9 saniye)

---

### 2. INTEGRATION TESTLERINI ÇALIŞTIR (DB testleri)
```bash
dotnet test --filter "ClassName=TodoApi.Tests.Integration.TodoApiIntegrationTests"
```

✅ 8 Integration test çalışır

---

### 3. UNIT TESTLERINI ÇALIŞTIR (Model, DTO, Service testleri)
```bash
dotnet test --filter "ClassName=TodoApi.Tests.DTOs.TodoDtoValidationTests OR ClassName=TodoApi.Tests.Models.TodoItemTests OR ClassName=TodoApi.Tests.Models.UserTests OR ClassName=TodoApi.Tests.Services.JwtServiceTests"
```

✅ 32 Unit test çalışır

---

## 📊 Test Durumu

```
✅ DTO Tests              13/13  (100%)
✅ TodoItem Tests          6/6   (100%)
✅ User Tests              7/7   (100%)
✅ JWT Service Tests       6/6   (100%)
✅ Integration Tests       8/8   (100%)
─────────────────────────────────
✅ TOPLAM                40/40  (100%)
```

---

## 🎯 Ne Test Edildi?

### ✅ Unit Tests (32 test)
- Form validasyonu (DTO)
- Entity özellikleri (Model)
- Token işlemleri (Service)

### ✅ Integration Tests (8 test)
- Veritabanı CRUD
- User-Todo ilişkileri
- Cascade delete
- JWT authentication
- Email duplicate kontrolü

---

## 💡 Sorun Giderme

**Eğer test çalışmazsa**:
```bash
# Cache temizle
dotnet clean

# Yeniden build et
dotnet build

# Testleri çalıştır
dotnet test
```

---

## 📚 Detaylı Rehber

- `TEST_RUN_EXPLANATION.md` - Detaylı açıklama
- `KONSOL_KOMUTLARI.md` - Tüm komutlar
- `TEST_SUCCESS_SUMMARY.md` - Özet rapor

---

**✅ Tüm testler başarılı!**  
Geliştirmeye devam edebilirsiniz! 🚀
