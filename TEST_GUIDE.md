# TodoList Uygulaması - Test Rehberi

Bu dokümantasyon uygulamadaki unit test'leri açıklamaktadır.

## 📋 Test Yapısı

### Backend Tests (backend.tests/)

#### 1. **JwtServiceTests.cs**
JWT token generation ve validation için testler:
- ✅ Token generation başarıyla gerçekleşiyor
- ✅ Generated token validate edilebiliyor
- ✅ Geçersiz token'ler reject ediliyor
- ✅ Expired token'ler reject ediliyor

```bash
dotnet test backend.tests --filter "JwtServiceTests"
```

#### 2. **ModelsTests.cs**
Entity models için validation testleri:
- ✅ TodoItem oluşturulabiliyor
- ✅ User oluşturulabiliyor
- ✅ Todo completion toggle'ı çalışıyor
- ✅ User'lar todos'u add edebiliyor

```bash
dotnet test backend.tests --filter "ModelsTests"
```

#### 3. **DtoValidationTests.cs**
DTO validation'ları test ediyor:
- ✅ CreateTodoDto validation
- ✅ UpdateTodoDto validation
- ✅ RegisterDto validation
- ✅ LoginDto validation
- ✅ Email format validation
- ✅ Password length validation

```bash
dotnet test backend.tests --filter "DtoValidationTests"
```

### Frontend Tests (src/)

#### 1. **todoService.test.ts**
Todo service API calls'ı mock'lıyor:
- ✅ getTodos - tüm todos fetch ediyor
- ✅ createTodo - yeni todo oluşturuyor
- ✅ updateTodo - todo güncelleniyor
- ✅ deleteTodo - todo siliniyor
- ✅ toggleTodo - completion status toggle'ı

```bash
npm test -- todoService.test.ts
```

#### 2. **authService.test.ts**
Authentication service'i test ediyor:
- ✅ register - yeni user kaydı
- ✅ login - user giriş
- ✅ logout - user çıkış
- ✅ isAuthenticated - token kontrol
- ✅ localStorage operations

```bash
npm test -- authService.test.ts
```

#### 3. **TodoItem.test.tsx**
TodoItem component test'leri:
- ✅ Component render'ı
- ✅ Todo text gösteriliyor
- ✅ Completed state styling
- ✅ Toggle button functionality
- ✅ Delete button functionality

```bash
npm test -- TodoItem.test.tsx
```

## 🚀 Test Komutları

### Backend Tests

```bash
# Tüm backend testlerini çalıştır
cd backend.tests
dotnet test

# Spesifik test class'ını çalıştır
dotnet test --filter "ClassName"

# Verbose output ile çalıştır
dotnet test -v detailed

# Code coverage raporu ile
dotnet test /p:CollectCoverage=true
```

### Frontend Tests

```bash
# Tüm frontend testlerini çalıştır
npm test

# Watch mode'de çalıştır (continuous testing)
npm test -- --watch

# UI ile çalıştır (visual test runner)
npm test:ui

# Coverage raporu ile
npm test:coverage
```

## 📊 Test Coverage Hedefleri

- **Backend Service Tests**: 90%+
- **Backend Model Tests**: 100%
- **Backend DTO Validation**: 95%+
- **Frontend Service Tests**: 85%+
- **Frontend Component Tests**: 80%+

## ✅ Test Best Practices

### Backend (.NET)

1. **Naming Convention**: `[ClassName]Tests.cs`
2. **Test Method Names**: `MethodName_Scenario_ExpectedResult`
3. **Arrange-Act-Assert Pattern**: 
   ```csharp
   [Fact]
   public void Method_Scenario_Result()
   {
       // Arrange - test data hazırla
       // Act - method'u çağır
       // Assert - sonuçları kontrol et
   }
   ```
4. **Mocking**: Moq library kullan
5. **Test Isolation**: Her test bağımsız olmalı

### Frontend (React/TypeScript)

1. **Naming Convention**: `*.test.ts` veya `*.test.tsx`
2. **Describe Blocks**: Logical grouping için
3. **Test Patterns**:
   ```typescript
   describe('ComponentName', () => {
       it('should do something', () => {
           // test code
       });
   });
   ```
4. **Mocking**: vi.mock() kullan (Vitest)
5. **User-Centric Testing**: User actions'ı test et

## 🔧 Test Dosyalarının Konumları

```
backend.tests/
├── Services/
│   └── JwtServiceTests.cs
├── Models/
│   └── ModelsTests.cs
├── DTOs/
│   └── DtoValidationTests.cs
└── TodoApi.Tests.csproj

src/
├── services/
│   ├── todoService.test.ts
│   └── authService.test.ts
├── components/
│   └── TodoItem.test.tsx
└── test/
    └── setup.ts
```

## 📝 Örnek Test Yazımı

### Backend - Service Test
```csharp
[Fact]
public void GenerateToken_WithValidUser_ReturnsValidToken()
{
    // Arrange
    var user = new User { Id = 1, Email = "test@example.com" };

    // Act
    var token = _jwtService.GenerateToken(user);

    // Assert
    Assert.NotNull(token);
    Assert.NotEmpty(token);
}
```

### Frontend - Service Test
```typescript
it('should fetch all todos', async () => {
    // Arrange
    const mockTodos = [...];
    (api.get as any).mockResolvedValueOnce({ data: mockTodos });

    // Act
    const result = await todoService.getTodos();

    // Assert
    expect(api.get).toHaveBeenCalledWith('/todos');
    expect(result).toEqual(mockTodos);
});
```

## 🐛 Debugging Tests

### Backend
```bash
# Debug mode'de çalıştır
dotnet test --no-build --verbosity detailed

# Specific test'e breakpoint koy
# Visual Studio'da Debug Test Adapter kullan
```

### Frontend
```bash
# Debug mode'de çalıştır
npm test -- --inspect-brk

# Browser DevTools'u kullan
npm test:ui
```

## 📚 Kaynaklar

- [xUnit Documentation](https://xunit.net/)
- [Moq Documentation](https://github.com/Moq/moq4)
- [Vitest Documentation](https://vitest.dev/)
- [Testing Library Documentation](https://testing-library.com/)

## 🎯 Sonraki Adımlar

1. **Integration Tests** yazıl (API endpoint tests)
2. **E2E Tests** ekle (Playwright/Cypress)
3. **Performance Tests** oluştur
4. **CI/CD** pipeline'a testleri entegre et
5. **Code Coverage** raporlarını monitor et
