# Build Pipeline Dokümantasyonu

## 🏗️ Build Aşamaları

### 1. Derleme (Compile)
Kaynak kodun çalıştırılabilir formata dönüştürülmesi.

### 2. Dependency Resolution
Projenin bağımlılıklarının çözümlenmesi ve indirilmesi.

### 3. Static Analysis
Kodun standartlara uygunluğunun denetlenmesi ve potansiyel hataların taranması.

---

## 🚀 Kullanım

### Tüm Projeyi Build Etme
```bash
./build-all.sh
```

### Sadece Frontend Build
```bash
./build.sh
```

### Sadece Backend Build
```bash
cd backend
./build.sh
```

---

## 📦 Frontend Build Pipeline

### Adımlar:
1. **Dependency Resolution** - `npm ci`
2. **Type Check** - `npm run typecheck`
3. **Static Analysis (Linting)** - `npm run lint`
4. **Build** - `npm run build`
5. **Security Audit** - `npm audit`

### Araçlar:
- **TypeScript Compiler**: Type checking
- **ESLint**: Code quality ve best practices
- **npm audit**: Security vulnerability scanning
- **Vite**: Build ve bundling

---

## 🔧 Backend Build Pipeline

### Adımlar:
1. **Dependency Resolution** - `dotnet restore`
2. **Compile** - `dotnet build --configuration Release`
3. **Format Check** - `dotnet format --verify-no-changes`
4. **Security Scan** - `dotnet list package --vulnerable`

### Araçlar:
- **.NET Compiler**: Code compilation
- **dotnet format**: Code formatting ve style
- **NuGet**: Package vulnerability scanning

---

## 🔍 Static Analysis

### Frontend
- **ESLint**: JavaScript/TypeScript linting
- **TypeScript**: Type safety
- Konfigürasyon: `eslint.config.js`, `tsconfig.json`

### Backend
- **dotnet format**: C# code formatting
- **NuGet Security Audit**: Dependency vulnerability scanning
- Konfigürasyon: `.editorconfig` (opsiyonel)

---

## 📊 SonarQube Entegrasyonu

### Lokal Çalıştırma
```bash
# SonarQube Scanner'ı kur (macOS)
brew install sonar-scanner

# Analiz çalıştır
sonar-scanner
```

### Konfigürasyon
- Dosya: `sonar-project.properties`
- SonarQube server URL ve token gereklidir

### CI/CD Entegrasyonu
- GitHub Actions workflow: `.github/workflows/build.yml`
- Her push ve PR'da otomatik analiz

---

## ✅ Build Başarı Kriterleri

### Frontend
- ✅ Tüm TypeScript type check'leri geçmeli
- ✅ ESLint kurallarına uygun olmalı
- ✅ Production build başarıyla tamamlanmalı
- ✅ Critical security vulnerability'leri olmamalı

### Backend
- ✅ Kod hatasız compile edilmeli
- ✅ Code formatting standartlara uygun olmalı
- ✅ Release configuration'da build başarılı olmalı
- ✅ Critical/High severity vulnerability'leri olmamalı

---

## 🛠️ Sorun Giderme

### Frontend Build Hataları

**Type Check Hatası:**
```bash
npm run typecheck
```
Detaylı hata mesajlarını gösterir.

**Linting Hatası:**
```bash
npm run lint
```
Otomatik düzeltme için:
```bash
npm run lint -- --fix
```

### Backend Build Hataları

**Format Hatası:**
```bash
cd backend
dotnet format
```
Otomatik formatting uygular.

**Dependency Hatası:**
```bash
dotnet restore --force
```

---

## 📈 Metrikler

Build süreçlerinin performansı:
- Frontend build süresi: ~1-2 saniye
- Backend build süresi: ~2-3 saniye
- Total pipeline süresi: ~5-10 saniye

---

## 🔐 Güvenlik

### Bağımlılık Güvenliği
- **Frontend**: npm audit
- **Backend**: dotnet list package --vulnerable

### Düzenli Güncellemeler
```bash
# Frontend bağımlılıkları güncelle
npm update

# Backend bağımlılıkları güncelle
cd backend
dotnet outdated
```

---

## 📝 Best Practices

1. **Her commit öncesi lokal build çalıştır**
   ```bash
   ./build-all.sh
   ```

2. **Pre-commit hook ekle**
   - Otomatik linting ve type checking

3. **Düzenli dependency güncellemeleri**
   - Güvenlik güncellemeleri öncelikli

4. **Build loglarını incele**
   - Warning'leri göz ardı etme

5. **CI/CD pipeline'ı takip et**
   - Failed build'leri hemen düzelt
