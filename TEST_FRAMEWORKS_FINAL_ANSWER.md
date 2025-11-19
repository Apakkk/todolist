# 📋 Test Framework'leri - Final Cevap

## ❓ SORUNUZ
"Bunlardan kaçını kullanıyoruz: xUnit, NUnit, Moq, Coverlet, Selenium, Atrium?"

---

## ✅ CEVAP: **3 TANESI**

```
┌─────────────┬─────────┬──────────┐
│ Framework   │ Durum   │ Versiyon │
├─────────────┼─────────┼──────────┤
│ xUnit       │ ✅ EVET │ 2.6.6    │ ← Unit Test Framework
│ Moq         │ ✅ EVET │ 4.20.70  │ ← Mocking Library
│ Coverlet    │ ✅ EVET │ 6.0.0    │ ← Coverage Tool
│ NUnit       │ ❌ HAYIR│    -     │ ✗ Gereksiz
│ Selenium    │ ❌ HAYIR│    -     │ ✗ UI Test (Yok)
│ Atrium      │ ❌ HAYIR│    -     │ ✗ .NET Uyumlu Değil
└─────────────┴─────────┴──────────┘
```

---

## 📊 DETAY TABLO

| # | Framework | Kullanılıyor | Neden | Dosya |
|---|-----------|:----:|---------|-------|
| 1 | **xUnit** | ✅ | Tüm 40 testleri yazıyoruz | TodoApi.Tests.csproj |
| 2 | **Moq** | ✅ | Mock nesneler oluşturmak (JwtService, Integration) | TodoApi.Tests.csproj |
| 3 | **Coverlet** | ✅ | Code coverage ölçümü (%15) | TodoApi.Tests.csproj |
| 4 | **NUnit** | ❌ | xUnit zaten kurulu, aynı amaç | - |
| 5 | **Selenium** | ❌ | Backend test yapıyoruz, UI test değil | - |
| 6 | **Atrium** | ❌ | .NET'e uyumlu değil (Kotlin library) | - |

---

## 🎯 ÖZET CEVAP

### Kullananlar (3) ✅
1. **xUnit** - Unit test çatısı
2. **Moq** - Mock nesneler
3. **Coverlet** - Coverage raporu

### Kullanılmayanlar (3) ❌
1. **NUnit** - Gereksiz ❌
2. **Selenium** - UI test yok ❌
3. **Atrium** - .NET uyumlu değil ❌

---

**Son Güncelleme**: 2025-11-19  
**Test Durumu**: 40/40 Passed ✅
