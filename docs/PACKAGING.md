# Packaging & Containerization Dokümantasyonu

## 📦 Artifact & Containerization Pipeline

Bu dokümantasyon, uygulamanın paketleme ve containerization süreçlerini açıklar.

---

## 🎯 Genel Bakış

### Artifact Nedir?
Build edilmiş kod, ayar dosyaları ve kütüphanelerle birleştirilerek oluşturulan dağıtılabilir paket.

### Containerization Nedir?
Uygulamanın çalışması için gereken tüm bağımlılıkları (OS, runtime, libraries) içeren Docker image'ları.

---

## 📋 Süreçler

### 1. Version Management

```bash
# Versiyon güncelle
./version.sh

# Seçenekler:
# - Patch: Bug fixes (1.0.0 -> 1.0.1)
# - Minor: New features (1.0.0 -> 1.1.0)
# - Major: Breaking changes (1.0.0 -> 2.0.0)
```

**Version dosyası:** `version.json`
```json
{
  "version": "1.0.0",
  "buildDate": "2025-11-19",
  "name": "TodoList Full Stack Application"
}
```

### 2. Artifact Oluşturma

```bash
# Tüm artifact'ları ve Docker image'larını oluştur
./package.sh
```

**Oluşturulan Çıktılar:**
- `artifacts/frontend/todoapp-frontend-v1.0.0-[timestamp].tar.gz`
- `artifacts/backend/todoapp-backend-v1.0.0-[timestamp].tar.gz`
- `artifacts/build-manifest.json` (metadata)

**Artifact İçeriği:**

**Frontend Artifact:**
- Compiled JavaScript/CSS bundles
- Static assets (images, fonts)
- index.html
- version.json

**Backend Artifact:**
- Compiled .NET DLL files
- Dependencies (NuGet packages)
- Configuration files
- version.json

### 3. Docker Images

#### Frontend Image
```dockerfile
# Multi-stage build
FROM node:18-alpine AS builder
# ... build process ...
FROM nginx:alpine
# ... runtime setup ...
```

**İçerik:**
- Nginx web server
- Built frontend files
- Custom nginx configuration
- Health check endpoint

#### Backend Image
```dockerfile
# Multi-stage build
FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build
# ... build process ...
FROM mcr.microsoft.com/dotnet/aspnet:10.0 AS runtime
# ... runtime setup ...
```

**İçerik:**
- .NET Runtime
- Published application
- Health check endpoint
- Non-root user (security)

---

## 🚀 Kullanım

### Lokal Build & Test

```bash
# 1. Sadece build
./build-all.sh

# 2. Build + Package + Containerize
./package.sh

# 3. Docker container'ları çalıştır
docker-compose up -d

# 4. Servisleri kontrol et
docker-compose ps
```

### Docker Yönetimi

```bash
# İnteraktif menü
./docker-manager.sh

# Veya doğrudan komutlar:
docker-compose up -d        # Başlat
docker-compose down         # Durdur
docker-compose logs -f      # Logları izle
docker-compose ps           # Durum kontrolü
```

### Version ile Çalıştırma

```bash
# Belirli bir versiyon ile
VERSION=1.0.0 docker-compose up -d

# Image'ları listele
docker images | grep todoapp
```

---

## 🐳 Docker Compose Architecture

```
┌─────────────────┐
│   Frontend      │
│  (Nginx:80)     │
│                 │
└────────┬────────┘
         │
         │ Proxy /api -> backend:5275
         │
┌────────▼────────┐
│    Backend      │
│  (.NET:5275)    │
│                 │
└────────┬────────┘
         │
         │ PostgreSQL Connection
         │
┌────────▼────────┐
│   PostgreSQL    │
│   (Port:5432)   │
│                 │
└─────────────────┘
```

### Servisler

**1. PostgreSQL (postgres)**
- Port: 5432
- Database: todoapp
- Volume: postgres_data
- Health check: pg_isready

**2. Backend (backend)**
- Port: 5275
- Depends on: postgres
- Health check: /api/health
- Environment variables via docker-compose

**3. Frontend (frontend)**
- Port: 80
- Depends on: backend
- Nginx reverse proxy
- Health check: wget /

---

## 🏷️ Version Tagging

### Semantic Versioning
Format: `MAJOR.MINOR.PATCH`

- **MAJOR**: Breaking changes
- **MINOR**: New features (backward compatible)
- **PATCH**: Bug fixes

### Git Tags

```bash
# Tag oluştur
git tag -a v1.0.0 -m "Release version 1.0.0"

# Tag'i push et
git push origin v1.0.0

# Tag'leri listele
git tag -l
```

### Docker Image Tags

```bash
# Image'lar otomatik tag'lenir:
todoapp-frontend:1.0.0    # Specific version
todoapp-frontend:latest   # Latest version

todoapp-backend:1.0.0
todoapp-backend:latest
```

---

## 📊 Build Manifest

`artifacts/build-manifest.json` örneği:

```json
{
  "version": "1.0.0",
  "buildDate": "20251119-143022",
  "artifacts": {
    "frontend": {
      "file": "todoapp-frontend-v1.0.0-20251119-143022.tar.gz",
      "size": "235K",
      "dockerImage": "todoapp-frontend:1.0.0"
    },
    "backend": {
      "file": "todoapp-backend-v1.0.0-20251119-143022.tar.gz",
      "size": "28M",
      "dockerImage": "todoapp-backend:1.0.0"
    }
  },
  "dockerImages": [
    "todoapp-frontend:1.0.0",
    "todoapp-backend:1.0.0",
    "postgres:15"
  ],
  "checksum": {
    "frontend": "abc123...",
    "backend": "def456..."
  }
}
```

---

## 🔐 Security

### Best Practices

1. **Non-root User (Backend)**
   ```dockerfile
   RUN useradd -m -u 1000 appuser
   USER appuser
   ```

2. **Multi-stage Builds**
   - Build dependencies ayrı stage'de
   - Final image sadece runtime içerir
   - Image boyutu minimize

3. **Health Checks**
   - Her servis için health check endpoint
   - Docker otomatik restart
   - Monitoring için ready

4. **.dockerignore**
   - Gereksiz dosyalar hariç
   - Image boyutu küçük
   - Build hızı artar

---

## 📈 Performans

### Image Boyutları

| Service | Base Image | Final Size |
|---------|-----------|------------|
| Frontend | nginx:alpine | ~25MB |
| Backend | dotnet/aspnet:10.0 | ~210MB |
| PostgreSQL | postgres:15 | ~380MB |

### Build Süreleri

| Process | Time |
|---------|------|
| Frontend Build | ~1-2s |
| Backend Publish | ~2-3s |
| Frontend Image | ~15-20s |
| Backend Image | ~30-40s |
| Total | ~50-70s |

---

## 🛠️ Troubleshooting

### Image Build Hataları

```bash
# Cache temizle ve rebuild
docker-compose build --no-cache

# Tüm unused image'ları temizle
docker image prune -a
```

### Container Çalışmıyor

```bash
# Logları kontrol et
docker-compose logs [service-name]

# Health check durumu
docker ps

# Container içine gir
docker exec -it [container-name] sh
```

### Network Sorunları

```bash
# Network'leri listele
docker network ls

# Network detaylarını gör
docker network inspect todoapp_todoapp-network

# Network'ü sıfırla
docker-compose down
docker-compose up -d
```

---

## 📦 Deployment

### Image Registry'ye Push

```bash
# Docker Hub
docker login
docker tag todoapp-frontend:1.0.0 username/todoapp-frontend:1.0.0
docker push username/todoapp-frontend:1.0.0

# Private Registry
docker tag todoapp-frontend:1.0.0 registry.example.com/todoapp-frontend:1.0.0
docker push registry.example.com/todoapp-frontend:1.0.0
```

### Image Save/Load

```bash
# Image'ı dosyaya kaydet
docker save todoapp-frontend:1.0.0 | gzip > todoapp-frontend-1.0.0.tar.gz

# Image'ı yükle
gunzip -c todoapp-frontend-1.0.0.tar.gz | docker load
```

### Production Deployment

```bash
# Production docker-compose
docker-compose -f docker-compose.prod.yml up -d

# Specific version deploy
VERSION=1.0.0 docker-compose up -d
```

---

## 🔄 CI/CD Integration

### GitHub Actions Örneği

```yaml
- name: Build and Push Docker Images
  run: |
    ./package.sh
    docker push todoapp-frontend:${{ github.ref_name }}
    docker push todoapp-backend:${{ github.ref_name }}
```

---

## 📝 Checklist

### Her Release Öncesi

- [ ] Version number güncellendi (`./version.sh`)
- [ ] Build başarılı (`./build-all.sh`)
- [ ] Artifact'lar oluşturuldu (`./package.sh`)
- [ ] Docker image'lar build edildi
- [ ] Container'lar test edildi (`docker-compose up`)
- [ ] Health check'ler çalışıyor
- [ ] Git tag oluşturuldu
- [ ] Build manifest kontrol edildi
- [ ] CHANGELOG güncellendi
- [ ] Dokümantasyon güncellendi

---

## 📚 Referanslar

- [Docker Best Practices](https://docs.docker.com/develop/dev-best-practices/)
- [Multi-stage Builds](https://docs.docker.com/build/building/multi-stage/)
- [Docker Compose](https://docs.docker.com/compose/)
- [Semantic Versioning](https://semver.org/)
