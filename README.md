# 📝 TodoList Full Stack Application

Modern, production-ready full-stack todo list uygulaması. React, .NET, PostgreSQL ve Docker ile geliştirilmiştir.

![Version](https://img.shields.io/badge/version-1.0.0-blue.svg)
![Build](https://img.shields.io/badge/build-passing-brightgreen.svg)
![License](https://img.shields.io/badge/license-MIT-green.svg)

## 🚀 Özellikler

- ✅ Modern ve responsive UI (React + Tailwind CSS)
- ✅ JWT tabanlı authentication
- ✅ RESTful API (.NET 9.0)
- ✅ PostgreSQL veritabanı
- ✅ Docker containerization
- ✅ Otomatik build pipeline
- ✅ Health check endpoints
- ✅ Production-ready

## 📋 Gereksinimler

- **Node.js** 18+
- **.NET SDK** 9.0+
- **Docker** & Docker Compose
- **Git**

## 🏗️ Teknoloji Stack

### Frontend
- React 18.3
- TypeScript 5.5
- Vite 5.4
- Tailwind CSS 3.4
- React Router DOM 7.9
- Axios 1.13

### Backend
- .NET 9.0 (ASP.NET Core Web API)
- Entity Framework Core 9.0
- PostgreSQL 15
- JWT Authentication
- BCrypt

### DevOps
- Docker & Docker Compose
- Multi-stage builds
- Health checks
- Automated pipelines

## 🚀 Hızlı Başlangıç

### Option 1: Docker (Önerilen) - Otomatik Deployment

```bash
# 1. Projeyi klonla
git clone <repository-url>
cd todolist

# 2. Build, Package ve Deploy (Tek Komut!)
./deploy.sh

# 3. Uygulama otomatik başlar
# Frontend: http://localhost
# Backend:  http://localhost:5275/api
```

### Option 2: Docker (Manuel) - Adım Adım

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
