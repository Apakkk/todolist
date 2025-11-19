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
