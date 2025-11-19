# 🚀 Setup & Configuration Guide

## 📋 Hızlı Başlangıç

### 1. Clone & Install

```bash
# Repository'yi clone et
git clone https://github.com/Apakkk/todolist.git
cd toDoListt-main

# Frontend dependencies'i yükle
npm install

# Backend dependencies'i yükle
cd backend
dotnet restore
cd ..
```

### 2. Environment Variables

**Frontend - .env dosyası oluştur:**
```bash
cp .env.example .env
```

**.env dosyası içeriği:**
```
VITE_API_BASE_URL=http://localhost:5275/api
```

**Backend - appsettings.json kontrol et:**
```bash
cd backend
# appsettings.json dosyası zaten hazır, değiştirmeye gerek yok
```

### 3. Database Setup

**Option A: Docker (Önerilen)**
```bash
# PostgreSQL container başlat
docker-compose up -d

# Başarılı mı kontrol et
docker ps
```

**Option B: Local PostgreSQL**
```bash
# PostgreSQL'i kur (macOS)
brew install postgresql@15

# Database oluştur
createdb -U postgres todoapp
```

### 4. Database Migration

```bash
cd backend

# Entity Framework migration'ı çalıştır
dotnet ef database update

cd ..
```

## 🎯 Uygulamayı Çalıştır

### Terminal 1 - Frontend

```bash
npm run dev
```

**Output:**
```
  VITE v5.4.2  ready in 123 ms

  ➜  Local:   http://localhost:5173/
  ➜  press h + enter to show help
```

✅ Frontend hazır: **http://localhost:5173**

### Terminal 2 - Backend

```bash
cd backend
dotnet run
```

**Output:**
```
info: Microsoft.Hosting.Lifetime[14]
      Now listening on: http://localhost:5275
info: Microsoft.Hosting.Lifetime[0]
      Application started
```

✅ Backend hazır: **http://localhost:5275**
✅ API Docs: **http://localhost:5275/swagger**

## ✅ Verification Checklist

```bash
# Frontend'in çalıştığını kontrol et
curl http://localhost:5173

# Backend API'nin çalıştığını kontrol et
curl http://localhost:5275/swagger

# Database bağlantısını kontrol et
# Backend logs'ında "Database updated" veya benzer mesaj aranır
```

## 🧪 Testleri Çalıştır

```bash
# Frontend tests
npm test

# Backend tests
cd backend.tests
dotnet test
```

## 📁 Environment Files Özeti

| Dosya | Kullanım | Git'e Eklenir |
|-------|----------|---------------|
| `.env` | Frontend prod config | ❌ No (gitignore) |
| `.env.example` | Frontend example | ✅ Yes |
| `backend/appsettings.json` | Backend prod config | ❌ No (gitignore) |
| `backend/appsettings.example.json` | Backend example | ✅ Yes |
| `backend/appsettings.Development.json` | Backend dev config | ❌ No (gitignore) |

## 🔧 Production Deployment

### Environment Variables (Production)

**Frontend - .env.production**
```
VITE_API_BASE_URL=https://your-api-domain.com/api
```

**Backend - appsettings.Production.json**
```json
{
  "ConnectionStrings": {
    "DefaultConnection": "Host=your-db-host;Database=todoapp;Username=dbuser;Password=strongpassword;Port=5432"
  },
  "JWT": {
    "Secret": "GenerateAStrongSecretKeyAtLeast32Characters!@#$%^&*()"
  }
}
```

## 🐛 Sık Karşılaşılan Sorunlar

### ❌ "Cannot connect to the database"

```bash
# PostgreSQL'in çalışıp çalışmadığını kontrol et
psql -U postgres -d todoapp

# Veya Docker'da
docker-compose ps

# Bağlantı string'i doğru mu?
grep "ConnectionStrings" backend/appsettings.json
```

### ❌ "Port 5275 is already in use"

```bash
# Hangi process kullanıyor kontrol et
lsof -i :5275

# Process'i öldür (PID'si biliniyorsa)
kill -9 <PID>
```

### ❌ "Port 5173 is already in use"

```bash
# Farklı port'ta çalıştır
npm run dev -- --port 3000
```

### ❌ Frontend API'ye bağlanamıyor

1. `.env` dosyasını kontrol et:
```bash
cat .env
```

2. Backend'in çalışıp çalışmadığını kontrol et:
```bash
curl http://localhost:5275/swagger
```

3. CORS ayarlarını kontrol et (`backend/Program.cs`)

## 📚 Useful Commands

```bash
# Frontend
npm run dev              # Development
npm run build            # Production build
npm run preview          # Preview build
npm test                 # Run tests
npm test:ui              # Visual test UI
npm test:coverage        # Coverage report
npm run lint             # ESLint check
npm run typecheck        # TypeScript check

# Backend
dotnet run               # Development
dotnet build             # Build project
dotnet test              # Run tests
dotnet ef migrations add # Create migration
dotnet ef database update # Apply migrations
dotnet publish           # Production build
```

## 🔐 Security Tips

1. **JWT Secret**: Production'da strong, random secret kullan
2. **Database Password**: Güçlü password set et
3. **CORS**: Trusted domains'i whitelist et
4. **HTTPS**: Production'da HTTPS zorunlu
5. **Secrets Management**: Sensitive data'yı environment variables'a taşı

## 📝 İlk Kullanım

1. Frontend'i aç: http://localhost:5173
2. "Sign Up" linkine tıkla
3. Email ve password ile kayıt ol
4. Login yap
5. Todo'lar oluştur, güncelle, sil
6. Completion toggle'ı test et

## 📖 Daha Fazla Bilgi

- README.md - Proje overview
- TEST_GUIDE.md - Testing details
- TESTS_SETUP.md - Test setup summary
