# 📋 Script Komutları Karşılaştırması

## 🔧 Tüm Script'ler ve Ne Yaptıkları

### 1. `./build.sh` (Frontend Build)
**Ne Yapar:**
- ✅ Frontend dependency çözümleme (npm ci)
- ✅ TypeScript type checking
- ✅ ESLint static analysis
- ✅ Vite production build
- ✅ Security audit
- ❌ Artifact oluşturmaz
- ❌ Docker image build etmez
- ❌ Container başlatmaz

**Ne Zaman Kullanılır:**
- Sadece frontend'i test etmek istediğinizde
- CI/CD pipeline'da frontend build aşaması
- Local development build kontrolü

**Çıktı:**
```
dist/
├── index.html
└── assets/
```

**Süre:** ~1-2 saniye

---

### 2. `./backend/build.sh` (Backend Build)
**Ne Yapar:**
- ✅ Backend dependency çözümleme (dotnet restore)
- ✅ .NET compilation
- ✅ Code formatting check
- ✅ Security vulnerability scan
- ❌ Artifact oluşturmaz
- ❌ Docker image build etmez
- ❌ Container başlatmaz

**Ne Zaman Kullanılır:**
- Sadece backend'i test etmek istediğinizde
- CI/CD pipeline'da backend build aşaması
- Local development build kontrolü

**Çıktı:**
```
bin/Release/net9.0/
└── TodoApi.dll
```

**Süre:** ~2-3 saniye

---

### 3. `./build-all.sh` (Full Build)
**Ne Yapar:**
- ✅ Frontend build (./build.sh çalıştırır)
- ✅ Backend build (./backend/build.sh çalıştırır)
- ✅ Özet rapor
- ❌ Artifact oluşturmaz
- ❌ Docker image build etmez
- ❌ Container başlatmaz

**Ne Zaman Kullanılır:**
- Her iki projeyi birden test etmek
- Pre-commit kontrolü
- CI/CD pipeline'da build aşaması

**Çıktı:**
```
Frontend: ✅ PASSED
Backend:  ✅ PASSED
Duration: 11s
```

**Süre:** ~10-15 saniye

---

### 4. `./package.sh` (Build + Package + Containerize) 📦
**Ne Yapar:**
- ✅ Frontend build
- ✅ Backend build
- ✅ Frontend artifact oluşturma (.tar.gz)
- ✅ Backend artifact oluşturma (.tar.gz)
- ✅ Docker backend image build
- ✅ Docker frontend image build
- ✅ Build manifest (checksums)
- ❌ **Container başlatmaz!**

**Ne Zaman Kullanılır:**
- Release hazırlarken
- Docker image'ları oluşturmak için
- Artifact'ları arşivlemek için
- CI/CD pipeline'da package aşaması

**Çıktı:**
```
artifacts/
├── frontend/
│   └── todoapp-frontend-v1.0.0-[timestamp].tar.gz (80KB)
├── backend/
│   └── todoapp-backend-v1.0.0-[timestamp].tar.gz (2.8MB)
└── build-manifest.json

Docker Images:
├── todoapp-frontend:1.0.0 (81.3MB)
└── todoapp-backend:1.0.0 (381MB)
```

**Süre:** ~60-70 saniye

**⚠️ ÖNEMLİ:** Bu script sadece hazırlar, **uygulamayı başlatmaz!**

---

### 5. `./deploy.sh` (Build + Package + Deploy) 🚀 **EN KAPSAMLI**
**Ne Yapar:**
- ✅ Frontend build
- ✅ Backend build
- ✅ Frontend artifact oluşturma
- ✅ Backend artifact oluşturma
- ✅ Docker backend image build
- ✅ Docker frontend image build
- ✅ Build manifest
- ✅ **Mevcut container'ları durdurma**
- ✅ **Yeni container'ları başlatma**
- ✅ **Health check kontrolü**
- ✅ **Status raporu**

**Ne Zaman Kullanılır:**
- **Uygulamayı çalıştırmak istediğinizde** ⭐
- Local deployment
- Fresh start
- Production-like test

**Çıktı:**
```
artifacts/ + Docker Images + Running Containers

Services Running:
├── Frontend:  http://localhost
├── Backend:   http://localhost:5275/api
└── Database:  localhost:5432
```

**Süre:** ~70-80 saniye

**✅ BU SCRIPT HER ŞEYİ YAPAR VE UYGULAMAYI BAŞLATIR!**

---

### 6. `./version.sh` (Version Management)
**Ne Yapar:**
- ✅ İnteraktif version seçimi
- ✅ version.json güncelleme
- ✅ Git tag oluşturma (opsiyonel)
- ❌ Build yapmaz
- ❌ Container başlatmaz

**Ne Zaman Kullanılır:**
- Release öncesi version bump
- Git tag oluşturma

**Süre:** ~1 saniye

---

### 7. `./docker-manager.sh` (Docker Management)
**Ne Yapar:**
- ✅ İnteraktif Docker menüsü
- ✅ Start/Stop/Restart services
- ✅ View logs
- ✅ Health check
- ✅ Rebuild images
- ✅ Cleanup
- ❌ Build yapmaz

**Ne Zaman Kullanılır:**
- Container'ları yönetmek için
- Logs görüntülemek için
- Troubleshooting

**Süre:** İnteraktif

---

## 🎯 Hangi Script'i Ne Zaman Kullanmalıyım?

### Senaryo 1: "Uygulamayı çalıştırmak istiyorum" 🚀
```bash
./deploy.sh
```
**Sonuç:** Uygulama http://localhost'ta çalışır halde!

---

### Senaryo 2: "Sadece Docker image'larını oluşturmak istiyorum"
```bash
./package.sh
```
**Sonuç:** Image'lar hazır, ama container'lar başlatılmamış

---

### Senaryo 3: "Kodda değişiklik yaptım, test etmek istiyorum"
```bash
./build-all.sh
```
**Sonuç:** Her iki proje build edilir, hatalar görülür

---

### Senaryo 4: "Release yapacağım"
```bash
# 1. Version bump
./version.sh

# 2. Build ve package
./package.sh

# 3. Test deployment
./deploy.sh

# 4. Git push
git add .
git commit -m "Release v1.0.0"
git push origin main
git push origin v1.0.0
```

---

### Senaryo 5: "Container'lar çalışıyor, sadece kodu güncelledim"
```bash
# Önce durdur
docker-compose down

# Yeniden deploy
./deploy.sh
```

---

## 📊 Karşılaştırma Tablosu

| Script | Build | Artifact | Docker Image | Start Container | Süre |
|--------|-------|----------|--------------|-----------------|------|
| `build.sh` | ✅ Frontend | ❌ | ❌ | ❌ | 1-2s |
| `backend/build.sh` | ✅ Backend | ❌ | ❌ | ❌ | 2-3s |
| `build-all.sh` | ✅ Both | ❌ | ❌ | ❌ | 10-15s |
| `package.sh` | ✅ Both | ✅ | ✅ | ❌ | 60-70s |
| **`deploy.sh`** ⭐ | ✅ Both | ✅ | ✅ | ✅ | 70-80s |
| `version.sh` | ❌ | ❌ | ❌ | ❌ | 1s |
| `docker-manager.sh` | ❌ | ❌ | ❌ | ✅ | - |

---

## 🔥 Hızlı Referans

### Sadece Çalıştır (En Basit)
```bash
./deploy.sh
```

### Build + Package (Docker Image Oluştur)
```bash
./package.sh
```

### Sadece Build (Hızlı Test)
```bash
./build-all.sh
```

### Container Yönetimi
```bash
./docker-manager.sh
```

### Manuel Control
```bash
# Build
./package.sh

# Start
docker-compose up -d

# Stop
docker-compose down

# Logs
docker-compose logs -f

# Status
docker-compose ps
```

---

## 💡 Pro Tips

### Tip 1: Full Clean Deploy
```bash
docker-compose down -v  # Stop ve volumes temizle
./deploy.sh             # Fresh start
```

### Tip 2: Quick Restart (Code değişti)
```bash
docker-compose restart backend   # Sadece backend restart
docker-compose restart frontend  # Sadece frontend restart
```

### Tip 3: Watch Logs
```bash
docker-compose logs -f backend   # Backend logs
docker-compose logs -f frontend  # Frontend logs
docker-compose logs -f           # All logs
```

### Tip 4: CI/CD Pipeline
```bash
./build-all.sh && ./package.sh
```

---

## ❓ Sık Sorulan Sorular

### Q: `package.sh` neden uygulamayı başlatmıyor?
**A:** Çünkü CI/CD pipeline'larda build ve deploy ayrı aşamalardır. `package.sh` sadece artifact hazırlar, deploy başka bir adımdır.

### Q: Hangi script'i kullanmalıyım?
**A:** 
- Hızlı çalıştırmak için: `./deploy.sh`
- Sadece image oluşturmak için: `./package.sh`
- Hızlı test için: `./build-all.sh`

### Q: Container'lar çalışıyor mu kontrol nasıl yapılır?
**A:** 
```bash
docker-compose ps
# veya
./docker-manager.sh  # → Option 6 (View status)
```

### Q: En hızlı deploy nasıl yapılır?
**A:** 
```bash
./deploy.sh  # Tek komut!
```

---

**Özet:** 
- 🎯 **Uygulamayı çalıştırmak için:** `./deploy.sh`
- 📦 **Sadece paketlemek için:** `./package.sh`
- 🔨 **Sadece build için:** `./build-all.sh`
