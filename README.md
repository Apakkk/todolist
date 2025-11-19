# 📝 TodoList Uygulaması

Modern bir full-stack todo list uygulaması. React + TypeScript frontend ve C# .NET backend ile geliştirilmiştir.

## 🎯 Özellikler

- ✅ User Registration & Authentication (JWT)
- ✅ Todo Create, Read, Update, Delete (CRUD)
- ✅ Todo completion toggle
- ✅ User authentication with secure passwords (BCrypt)
- ✅ Responsive UI with Tailwind CSS
- ✅ PostgreSQL Database
- ✅ Comprehensive Unit Tests

## 🛠️ Teknolojiler

### Frontend
- **React 18** - UI library
- **TypeScript** - Type safety
- **Vite** - Build tool
- **Tailwind CSS** - Styling
- **Axios** - HTTP client
- **React Router** - Navigation

### Backend
- **.NET 10** - Web framework
- **Entity Framework Core** - ORM
- **PostgreSQL** - Database
- **JWT** - Authentication
- **BCrypt** - Password hashing

## 📋 Kurulum

### Ön Gereksinimler

- **Node.js** 16+ (Frontend)
- **.NET 10** (Backend)
- **PostgreSQL** 15+ (Database)
- **Docker** (İsteğe bağlı)

### 1️⃣ Repository'yi Clone Et

```bash
git clone https://github.com/Apakkk/todolist.git
cd toDoListt-main
```

### 2️⃣ Frontend Kurulumu

```bash
# Dependencies yükle
npm install

# .env dosyası oluştur
cp .env.example .env

# Gerekirse VITE_API_BASE_URL'i düzenle
# .env dosyasında API_BASE_URL'i kontrol et
```

### 3️⃣ Backend Kurulumu

```bash
cd backend

# Dependencies yükle
dotnet restore

# appsettings.json'ı kontrol et
# Database connection string'i düzenle (gerekirse)

# Database migrate et
dotnet ef database update

cd ..
```

### 4️⃣ PostgreSQL Kurulumu

**Option A: Docker ile (Önerilen)**
```bash
docker-compose up -d
```

**Option B: Local PostgreSQL**
```bash
createdb -U postgres todoapp
```

## 🚀 Çalıştırma

### Frontend (Terminal 1)
```bash
npm run dev
# Frontend: http://localhost:5173
```

### Backend (Terminal 2)
```bash
cd backend
dotnet run
# Backend API: http://localhost:5275
# Swagger Docs: http://localhost:5275/swagger
```

### Monitoring (Prometheus & Grafana)

Docker ile tüm stack çalışırken:

- **Prometheus**: `http://localhost:9090`
- **Grafana**: `http://localhost:3000`
- **Backend Metrics**: `http://localhost:5275/metrics`


## 🧪 Testler

### Backend Tests
```bash
cd backend.tests
dotnet test
```

### Frontend Tests
```bash
npm test           # Testleri çalıştır
npm test:ui        # Visual test runner
npm test:coverage  # Coverage raporu
```

**Detaylı bilgi için:** [TEST_GUIDE.md](./TEST_GUIDE.md)

## 📁 Proje Yapısı

```
toDoListt-main/
├── src/                          # Frontend (React + TypeScript)
│   ├── components/               # React components
│   ├── pages/                    # Page components
│   ├── services/                 # API & Auth services
│   └── test/                     # Test setup
│
├── backend/                      # Backend (.NET)
│   ├── Controllers/              # API endpoints
│   ├── Services/                 # Business logic
│   ├── Models/                   # Entity models
│   ├── Data/                     # Database context
│   ├── DTOs/                     # Data transfer objects
│   ├── appsettings.json         # Configuration
│   └── Program.cs               # Application setup
│
├── backend.tests/               # Backend unit tests
│   ├── Services/
│   ├── Models/
│   └── DTOs/
│
├── .env                         # Frontend environment variables
├── .env.example                 # Frontend example file
├── docker-compose.yml           # Docker configuration
└── package.json                 # Frontend dependencies
```

## 🔑 Environment Variables

### Frontend (.env)
```
VITE_API_BASE_URL=http://localhost:5275/api
```

### Backend (backend/appsettings.json)
```json
{
  "ConnectionStrings": {
    "DefaultConnection": "Host=localhost;Database=todoapp;Username=postgres;Password=postgres;Port=5432"
  },
  "JWT": {
    "Secret": "YourSuperSecretKeyThatIsAtLeast32CharactersLong!@#$%^&*"
  }
}
```

## 📝 API Endpoints

### Authentication
- `POST /api/auth/register` - Yeni kullanıcı kayıt
- `POST /api/auth/login` - Kullanıcı giriş

### Todos
- `GET /api/todos` - Tüm todos'ları getir
- `POST /api/todos` - Yeni todo oluştur
- `GET /api/todos/{id}` - Spesifik todo getir
- `PUT /api/todos/{id}` - Todo güncelle
- `DELETE /api/todos/{id}` - Todo sil
- `PUT /api/todos/{id}/toggle` - Completion toggle

## 🔒 Security

- JWT-based authentication
- BCrypt password hashing
- CORS enabled
- Secure HTTP headers

## 📚 Kaynaklar

- [.NET Documentation](https://learn.microsoft.com/dotnet/)
- [React Documentation](https://react.dev/)
- [Entity Framework Core](https://learn.microsoft.com/ef/core/)
- [PostgreSQL](https://www.postgresql.org/)

## 🐛 Sorun Giderme

### Backend başlatılmıyor?
```bash
# Database'i kontrol et
dotnet ef database update

# Port 5275 kullanımda mı?
lsof -i :5275
```

### Frontend'e bağlanılamıyor?
```bash
# .env dosyasını kontrol et
cat .env

# VITE_API_BASE_URL doğru mu?
```

### Testler başarısız?
```bash
# Dependencies'i yeniden kur
npm install
dotnet restore

# Testleri verbose mod'da çalıştır
dotnet test -v detailed
```

## 📄 Lisans

MIT License

## 👨‍💻 Yazar

**Yusuf Apak**
- GitHub: [@Apakkk](https://github.com/Apakkk)

## 🤝 Katkı

Pull requests'e açığız! Lütfen feature branch'inde PR açın.

---

**Son Güncelleme:** Kasım 19, 2025
=======
# 📝 TodoList Full Stack Application

Production-ready, tam otomatize edilmiş DevOps pipeline ile geliştirilmiş modern full-stack uygulaması.

![Version](https://img.shields.io/badge/version-1.0.0-blue.svg)
![Build](https://img.shields.io/badge/build-passing-brightgreen.svg)
![DevOps](https://img.shields.io/badge/DevOps-automated-success.svg)
![Docker](https://img.shields.io/badge/docker-ready-blue.svg)

## 🚀 Özellikler

### Uygulama
- ✅ Modern ve responsive UI (React 18 + Tailwind CSS)
- ✅ JWT tabanlı authentication
- ✅ RESTful API (.NET 9.0)
- ✅ PostgreSQL veritabanı
- ✅ Real-time todo yönetimi

### DevOps Pipeline
- ✅ **Otomatik build** (compile, type check, lint)
- ✅ **Static analysis** (ESLint, dotnet format, security scan)
- ✅ **Artifact generation** (tar.gz paketleme)
- ✅ **Docker containerization** (multi-stage builds)
- ✅ **Version management** (semantic versioning)
- ✅ **Health checks** (tüm servisler)
- ✅ **CI/CD ready** (GitHub Actions)
- ✅ **One-command deployment** 🚀

## 📋 Gereksinimler

- **Node.js** 18+
- **.NET SDK** 9.0+
- **Docker** & Docker Compose
- **Git**

## 🏗️ Teknoloji Stack

### Frontend
- React 18.3 + TypeScript 5.5
- Vite 5.4 (build tool)
- Tailwind CSS 3.4
- React Router DOM 7.9
- Axios (HTTP client)

### Backend
- .NET 9.0 (ASP.NET Core Web API)
- Entity Framework Core 9.0
- PostgreSQL 15
- JWT Authentication + BCrypt

### DevOps & Infrastructure
- **Docker** - Containerization
- **Docker Compose** - Multi-container orchestration
- **Nginx** - Reverse proxy & static file serving
- **Shell Scripts** - Build & deployment automation
- **GitHub Actions** - CI/CD pipeline

---

## 🎯 DevOps Pipeline Özeti

Bu proje, modern DevOps prensipleriyle **sıfırdan production-ready** hale getirilmiştir:

### 📊 Tamamlanan Aşamalar

| Aşama | Durum | Açıklama |
|-------|-------|----------|
| **1. Development** | ✅ | Full-stack uygulama geliştirildi |
| **2. Build Automation** | ✅ | Otomatik derleme ve test scriptleri |
| **3. Static Analysis** | ✅ | Kod kalitesi ve güvenlik taraması |
| **4. Test** | ✅ | Unit testler (infrastructure ready) |
| **5. Artifact Creation** | ✅ | Dağıtılabilir paketler oluşturuldu |
| **6. Containerization** | ✅ | Docker image'ları optimize edildi |
| **7. Orchestration** | ✅ | Multi-container yönetimi |
| **8. Deployment** | ✅ | Tek komutla deployment |
| **9. Documentation** | ✅ | Kapsamlı dokümantasyon |

### 🔄 Pipeline Akışı

```
┌─────────────┐
│   1. CODE   │  Developer commits
└──────┬──────┘
       │
┌──────▼──────┐
│  2. BUILD   │  • npm ci / dotnet restore
└──────┬──────┘  • Type check / Compile
       │         • ESLint / dotnet format
┌──────▼──────┐
│  3. TEST    │  • npm test / dotnet test
└──────┬──────┘  • Unit + Integration tests
       │
┌──────▼──────┐
│ 4. ANALYZE  │  • npm audit (security)
└──────┬──────┘  • dotnet list package --vulnerable
       │
┌──────▼──────┐
│ 5. PACKAGE  │  • tar.gz artifacts
└──────┬──────┘  • Version tagging
       │         • Checksums
┌──────▼──────┐
│6.CONTAINERIZE│ • Docker multi-stage builds
└──────┬──────┘  • Image optimization (81MB frontend, 381MB backend)
       │
┌──────▼──────┐
│  7. DEPLOY  │  • docker-compose up
└──────┬──────┘  • Health checks
       │         • Service orchestration
┌──────▼──────┐
│   8. RUN    │  ✅ Production ready!
└─────────────┘
```

---

## 🛠️ DevOps Scripts Rehberi

Proje 7 farklı otomasyon scripti ile birlikte gelir. Her biri farklı kullanım senaryoları için tasarlanmıştır:

### 1️⃣ `./build.sh` - Frontend Build
**Ne Yapar:**
```bash
[1/4] npm ci              # Dependency installation
[2/4] Type check          # TypeScript validation
[3/4] ESLint              # Code quality check
[4/4] Vite build          # Production bundle
[5/5] Security audit      # npm audit
```

**Ne Zaman Kullanılır:**
- Frontend değişikliklerini test etmek
- CI/CD'de sadece frontend build aşaması

**Süre:** ~1-2 saniye  
**Çıktı:** `dist/` klasörü

---

### 2️⃣ `./backend/build.sh` - Backend Build
**Ne Yapar:**
```bash
[1/3] dotnet restore      # NuGet packages
[2/3] dotnet build        # Compilation (Release)
[3/3] dotnet format       # Code formatting check
[4/4] Security scan       # Vulnerable packages
```

**Ne Zaman Kullanılır:**
- Backend değişikliklerini test etmek
- CI/CD'de sadece backend build aşaması

**Süre:** ~2-3 saniye  
**Çıktı:** `bin/Release/net9.0/`

---

### 3️⃣ `./build-all.sh` - Full Build (Test Amaçlı)
**Ne Yapar:**
- Frontend + Backend build'i sırayla çalıştırır
- Toplam build süresini ölçer
- Özet rapor sunar

**Ne Zaman Kullanılır:**
- Pre-commit kontrolü
- Her iki projede değişiklik yapıldıysa
- Hızlı test için

**Süre:** ~10-15 saniye  
**Çıktı:** Build sonuç raporu

**❌ Yapmaz:** Artifact, Docker image, container başlatma

---

### 4️⃣ `./package.sh` - Build + Package + Containerize
**Ne Yapar:**
```bash
[1/4] Frontend build      # Production build
[2/4] Backend build       # Release build
[3/4] Artifact creation   # tar.gz arşivleri
      • todoapp-frontend-v1.0.0.tar.gz (80KB)
      • todoapp-backend-v1.0.0.tar.gz (2.8MB)
[4/4] Docker images       # Multi-stage builds
      • todoapp-frontend:1.0.0 (81.3MB)
      • todoapp-backend:1.0.0 (381MB)
[5/5] Build manifest      # Metadata + checksums
```

**Ne Zaman Kullanılır:**
- Release hazırlığı
- Docker image'larını yenilemek
- Artifact'ları arşivlemek
- CI/CD pipeline'da package aşaması

**Süre:** ~60-70 saniye  
**Çıktı:** `artifacts/` + Docker images

**❌ Yapmaz:** Container'ları başlatmaz!

---

### 5️⃣ `./deploy.sh` - Full Deployment (EN ÇOK KULLANILAN) ⭐
**Ne Yapar:**
```bash
[1/3] Package             # ./package.sh çalıştırır
      (Build + Artifact + Docker images)
[2/3] Stop containers     # docker-compose down
[3/3] Start containers    # docker-compose up -d
      • PostgreSQL (health check)
      • Backend API
      • Frontend Nginx
[4/4] Health verification # Servis kontrolü
```

**Ne Zaman Kullanılır:**
- **Uygulamayı çalıştırmak için** (en yaygın)
- Fresh start
- Deployment simülasyonu
- Production-like test

**Süre:** ~70-80 saniye  
**Çıktı:** Çalışan uygulama!

**✅ Yapar:** HER ŞEY! Build → Package → Deploy → Run

---

### 6️⃣ `./version.sh` - Version Management
**Ne Yapar:**
- İnteraktif menü ile version seçimi
- `version.json` güncelleme
- Git tag oluşturma (opsiyonel)
- Semantic versioning (MAJOR.MINOR.PATCH)

**Ne Zaman Kullanılır:**
- Release öncesi version bump
- Git tag oluşturma

**Seçenekler:**
```
1) Patch:  1.0.0 → 1.0.1  (Bug fixes)
2) Minor:  1.0.0 → 1.1.0  (New features)
3) Major:  1.0.0 → 2.0.0  (Breaking changes)
```

---

### 7️⃣ `./docker-manager.sh` - Docker Yönetim Aracı
**Ne Yapar:**
- İnteraktif menü ile Docker yönetimi
- Start/Stop/Restart services
- Logs görüntüleme
- Health check kontrolü
- Image rebuild
- Cleanup

**Ne Zaman Kullanılır:**
- Container'ları yönetmek
- Logs izlemek
- Troubleshooting

---

## 📋 Hangi Script'i Kullanmalıyım?

| Senaryo | Script | Süre |
|---------|--------|------|
| 🚀 **Uygulamayı çalıştırmak** | `./deploy.sh` | 70-80s |
| 🔨 Kod değişikliği test | `./build-all.sh` | 10-15s |
| 📦 Release hazırlığı | `./package.sh` | 60-70s |
| 🔢 Version güncelleme | `./version.sh` | 1s |
| 🐳 Container yönetimi | `./docker-manager.sh` | - |
| 🔍 Sadece frontend test | `./build.sh` | 1-2s |
| 🔧 Sadece backend test | `./backend/build.sh` | 2-3s |

---

## ⚡ Hızlı Başlangıç

### Tek Komutla Çalıştır (Önerilen) 🚀

```bash
# 1. Projeyi klonla
git clone https://github.com/Apakkk/todolist.git
cd todolist

# 2. Uygulamayı başlat (tek komut!)
./deploy.sh

# 3. Tarayıcıda aç
open http://localhost
```

**Bu kadar!** Deploy script otomatik olarak:
- ✅ Frontend'i build eder
- ✅ Backend'i build eder
- ✅ Artifact'ları oluşturur
- ✅ Docker image'larını build eder
- ✅ Container'ları başlatır
- ✅ Health check'leri doğrular

**Süre:** ~70-80 saniye  
**Sonuç:** Çalışan uygulama!

```bash
# 1. Projeyi klonla
git clone <repository-url>
cd todolist

# 2. Build ve package (artifact + image oluştur)
./package.sh

# 3. Container'ları başlat
docker-compose up -d

# 4. Uygulamaya eriş
open http://localhost
```

### Option 3: Local Development

```bash
# 1. Database başlat
docker-compose up -d postgres

# 2. Backend başlat
cd backend
dotnet run

# 3. Frontend başlat (yeni terminal)
npm install
npm run dev
```

## 📖 Dokümantasyon

- 📘 [BUILD.md](BUILD.md) - Build pipeline dokümantasyonu
- 📦 [PACKAGING.md](PACKAGING.md) - Paketleme ve containerization
- 🔄 [DEVOPS-LIFECYCLE.md](DEVOPS-LIFECYCLE.md) - Detaylı DevOps lifecycle
- 📊 [DEVOPS-SUMMARY.md](DEVOPS-SUMMARY.md) - Görsel özet

## 🛠️ Kullanılabilir Komutlar

### Build Scripts
```bash
./build.sh              # Frontend build
./build-all.sh          # Full project build
./package.sh            # Build + Package + Containerize (Docker image oluşturur)
./deploy.sh             # Build + Package + Deploy (Uygulamayı başlatır) 🚀
./version.sh            # Version management
```

### Docker Management
```bash
docker-compose up -d           # Start all services
docker-compose down            # Stop all services
docker-compose ps              # Service status
docker-compose logs -f         # View logs
./docker-manager.sh            # Interactive management
```

### Development
```bash
# Frontend
npm run dev                    # Development server
npm run build                  # Production build
npm run lint                   # Linting
npm run typecheck              # Type checking

# Backend
dotnet run                     # Run application
dotnet build                   # Build project
dotnet format                  # Format code
dotnet test                    # Run tests
```

## 🌐 Endpoints

### Frontend
- **URL:** http://localhost
- **Port:** 80

### Backend API
- **Base URL:** http://localhost:5275/api
- **Health Check:** http://localhost:5275/api/health

### Database
- **Host:** localhost
- **Port:** 5432
- **Database:** todoapp
- **Username:** postgres
- **Password:** postgres

## 📊 API Endpoints

### Authentication
```
POST   /api/auth/register    # User registration
POST   /api/auth/login       # User login
```

### Todos (Requires Authentication)
```
GET    /api/todos            # Get user's todos
POST   /api/todos            # Create new todo
PUT    /api/todos/{id}       # Update todo
DELETE /api/todos/{id}       # Delete todo
```

## 🏗️ Proje Yapısı

```
todolist/
├── src/                      # Frontend source
│   ├── components/          # React components
│   ├── pages/              # Page components
│   └── services/           # API services
├── backend/                 # Backend source
│   ├── Controllers/        # API controllers
│   ├── Models/             # Data models
│   ├── Services/           # Business logic
│   ├── Data/               # Database context
│   └── DTOs/               # Data transfer objects
├── artifacts/              # Build artifacts
├── .github/                # CI/CD workflows
├── scripts/                # Build scripts
└── docs/                   # Documentation
```

## 🐳 Docker Images

```bash
# List images
docker images | grep todoapp

# Outputs:
# todoapp-frontend:1.0.0    81.3MB
# todoapp-backend:1.0.0     381MB
```

## 🔒 Environment Variables

### Frontend
```env
VITE_API_URL=http://localhost:5275/api
```

### Backend
```env
ConnectionStrings__DefaultConnection=Host=localhost;Database=todoapp;...
JWT__Secret=YourSecretKey
```

## 📈 Performance Metrics

| Metric | Value |
|--------|-------|
| Frontend Build Time | ~1-2s |
| Backend Build Time | ~2-3s |
| Docker Build Time | ~60s |
| Frontend Image Size | 81.3MB |
| Backend Image Size | 381MB |

## 🧪 Testing

```bash
# Frontend tests (coming soon)
npm run test

# Backend tests (coming soon)
dotnet test
```

---

## 📚 Detaylı Dokümantasyon

Tüm dokümantasyon `docs/` klasöründe (~2,500+ satır):

| Dosya | İçerik | Hedef |
|-------|--------|-------|
| **[BUILD.md](docs/BUILD.md)** | Build pipeline, static analysis | Developers |
| **[SCRIPTS-GUIDE.md](docs/SCRIPTS-GUIDE.md)** ⭐ | 7 script karşılaştırması | **Herkese Önerilir** |
| **[PACKAGING.md](docs/PACKAGING.md)** | Docker & artifact creation | DevOps |
| **[DEVOPS-LIFECYCLE.md](docs/DEVOPS-LIFECYCLE.md)** | Complete journey (969 satır) | Tech Leads |
| **[DEVOPS-SUMMARY.md](docs/DEVOPS-SUMMARY.md)** | Görsel özet & metrikler | Managers |
| **[CHANGELOG.md](docs/CHANGELOG.md)** | Version history | All |

**📖 [docs/README.md](docs/README.md)** - Dokümantasyon indeksi ve rehber

---

## 🤝 Contributing

1. Fork the project
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📝 Version History

- **1.0.0** (19 Nov 2025)
  - Initial release
  - Full-stack implementation
  - Docker containerization
  - Build pipeline automation

## 📄 License

This project is licensed under the MIT License.

## 👥 Authors

- **Development Team** - Full-stack development, DevOps implementation

## 🙏 Acknowledgments

- React team for the amazing framework
- .NET team for the powerful backend framework
- Docker for containerization
- Tailwind CSS for the utility-first CSS framework

## 📞 Support

For support, email support@example.com or open an issue on GitHub.

---

**Made with ❤️ using React, .NET, and Docker**
