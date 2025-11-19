# Test Framework'leri - Hızlı Referans

## 📊 Hangi Framework'ler Kullanılıyor?

| Framework | Durum | Versiyon | Dosya |
|-----------|:-----:|:--------:|-------|
| **xUnit** | ✅ | 2.6.6 | `TodoApi.Tests.csproj` |
| **Moq** | ✅ | 4.20.70 | `TodoApi.Tests.csproj` |
| **Coverlet** | ✅ | 6.0.0 | `TodoApi.Tests.csproj` |
| **NUnit** | ❌ | - | - |
| **Selenium** | ❌ | - | - |
| **Atrium** | ❌ | - | - |

---

## ✅ Kullanılan Framework'ler (3 adet)

### 1. xUnit ✅
**Amaç**: Unit test yazma ve çalıştırma
- 40 test yazılmış
- Tüm testler bu framework ile

### 2. Moq ✅
**Amaç**: Mock nesneler oluşturma (Test bağımlılıklarını taklit etme)
- JwtServiceTests'te kullanıldı
- Integration testlerde kullanıldı

### 3. Coverlet ✅
**Amaç**: Code coverage ölçümü
- Test kapsamını %15 olarak ölçtü
- XML rapor oluşturdu

---

## ❌ Kullanılmayan Framework'ler (3 adet)

### 1. NUnit ❌
**Neden kullanmıyoruz?**
- xUnit zaten kullanılıyor
- Aynı amaç (Unit testing)
- Ek framework gerekmez

### 2. Selenium ❌
**Neden kullanmıyoruz?**
- Browser/UI automation için
- Bizim testler API testleri
- Backend test odaklı

### 3. Atrium ❌
**Neden kullanmıyoruz?**
- .NET uyumlu değil (Kotlin library)
- Web UI testing için
- Projemizde gerek yok

---

## 🎯 Özet

**Kullanan**: 3 framework
- xUnit (unit testing)
- Moq (mocking)
- Coverlet (coverage)

**Kullanmayan**: 3 framework
- NUnit, Selenium, Atrium

**Toplam Test**: 40
**Başarı Oranı**: 100% ✅
