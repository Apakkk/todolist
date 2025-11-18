#!/bin/bash

echo "🚀 Todo List Uygulaması Kurulum Scripti"
echo "======================================="

# Check if Docker is installed
if command -v docker &> /dev/null; then
    echo "✅ Docker bulundu"
    DOCKER_AVAILABLE=true
else
    echo "❌ Docker bulunamadı"
    DOCKER_AVAILABLE=false
fi

# Check if PostgreSQL is installed
if command -v psql &> /dev/null; then
    echo "✅ PostgreSQL bulundu"
    POSTGRES_AVAILABLE=true
else
    echo "❌ PostgreSQL bulunamadı"
    POSTGRES_AVAILABLE=false
fi

# Check if .NET is installed
if command -v dotnet &> /dev/null; then
    echo "✅ .NET bulundu"
    DOTNET_AVAILABLE=true
else
    echo "❌ .NET bulunamadı"
    DOTNET_AVAILABLE=false
fi

# Check if Node.js is installed
if command -v node &> /dev/null; then
    echo "✅ Node.js bulundu"
    NODE_AVAILABLE=true
else
    echo "❌ Node.js bulunamadı"
    NODE_AVAILABLE=false
fi

echo ""
echo "📋 Kurulum Seçenekleri:"
echo "1) Docker ile PostgreSQL (Önerilen)"
echo "2) Local PostgreSQL kullan"
echo "3) Sadece eksik bağımlılıkları kontrol et"

read -p "Seçiminizi yapın (1-3): " choice

case $choice in
    1)
        if [ "$DOCKER_AVAILABLE" = true ]; then
            echo "🐳 Docker ile PostgreSQL başlatılıyor..."
            docker-compose up -d
            echo "✅ PostgreSQL Docker container başlatıldı"
        else
            echo "❌ Docker yüklü değil. Lütfen Docker'ı kurun: https://docs.docker.com/get-docker/"
            exit 1
        fi
        ;;
    2)
        if [ "$POSTGRES_AVAILABLE" = true ]; then
            echo "🗄️ Local PostgreSQL kullanılıyor..."
            echo "Veritabanı oluşturuluyor..."
            
            # Try to create database
            createdb -U postgres todoapp 2>/dev/null || echo "Veritabanı zaten mevcut veya oluşturulamadı"
        else
            echo "❌ PostgreSQL yüklü değil. Kurulum talimatları:"
            echo ""
            echo "macOS: brew install postgresql@15"
            echo "Ubuntu: sudo apt install postgresql postgresql-contrib"
            echo "Windows: https://www.postgresql.org/download/windows/"
            exit 1
        fi
        ;;
    3)
        echo "🔍 Sadece kontrol ediliyor..."
        ;;
    *)
        echo "❌ Geçersiz seçim"
        exit 1
        ;;
esac

echo ""
echo "📦 Dependencies kuruluyor..."

# Install frontend dependencies
if [ "$NODE_AVAILABLE" = true ]; then
    echo "📱 Frontend dependencies kuruluyor..."
    npm install
    echo "✅ Frontend dependencies kuruldu"
else
    echo "❌ Node.js yüklü değil. Lütfen Node.js kurun: https://nodejs.org/"
    exit 1
fi

# Install backend dependencies
if [ "$DOTNET_AVAILABLE" = true ]; then
    echo "🔧 Backend dependencies kuruluyor..."
    cd backend
    dotnet restore
    echo "✅ Backend dependencies kuruldu"
    cd ..
else
    echo "❌ .NET yüklü değil. Lütfen .NET kurun: https://dotnet.microsoft.com/download"
    exit 1
fi

echo ""
echo "🎉 Kurulum tamamlandı!"
echo ""
echo "🚀 Uygulamayı başlatmak için:"
echo "1. Backend: cd backend && dotnet run"
echo "2. Frontend: npm run dev"
echo ""
echo "📱 Uygulama adresleri:"
echo "- Frontend: http://localhost:5173"
echo "- Backend API: http://localhost:5275"
echo "- API Docs: http://localhost:5275/swagger"
