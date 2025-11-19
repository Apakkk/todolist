import { describe, it, expect, beforeEach, vi } from 'vitest';
import { authService } from '../services/authService';
import api from '../services/api';

vi.mock('../services/api');

describe('authService', () => {
  beforeEach(() => {
    vi.clearAllMocks();
    localStorage.clear();
  });

  describe('register', () => {
    it('should register a new user successfully', async () => {
      const registerData = {
        email: 'test@example.com',
        password: 'Password123',
        firstName: 'John',
        lastName: 'Doe',
      };

      const mockResponse = {
        token: 'mock-token-123',
        user: {
          id: 1,
          email: 'test@example.com',
          firstName: 'John',
          lastName: 'Doe',
        },
      };

      (api.post as any).mockResolvedValueOnce({ data: mockResponse });

      const result = await authService.register(registerData);

      expect(api.post).toHaveBeenCalledWith('/auth/register', registerData);
      expect(result.token).toBe('mock-token-123');
      expect(result.user.email).toBe('test@example.com');
    });

    it('should handle registration errors', async () => {
      const registerData = {
        email: 'test@example.com',
        password: 'Password123',
        firstName: 'John',
        lastName: 'Doe',
      };

      const error = new Error('Email already exists');
      (api.post as any).mockRejectedValueOnce(error);

      await expect(authService.register(registerData)).rejects.toThrow('Email already exists');
    });
  });

  describe('login', () => {
    it('should login user successfully', async () => {
      const loginData = {
        email: 'test@example.com',
        password: 'Password123',
      };

      const mockResponse = {
        token: 'mock-token-123',
        user: {
          id: 1,
          email: 'test@example.com',
          firstName: 'John',
          lastName: 'Doe',
        },
      };

      (api.post as any).mockResolvedValueOnce({ data: mockResponse });

      const result = await authService.login(loginData);

      expect(api.post).toHaveBeenCalledWith('/auth/login', loginData);
      expect(result.token).toBe('mock-token-123');
    });

    it('should store token and user in localStorage', async () => {
      const loginData = {
        email: 'test@example.com',
        password: 'Password123',
      };

      const mockResponse = {
        token: 'mock-token-123',
        user: {
          id: 1,
          email: 'test@example.com',
          firstName: 'John',
          lastName: 'Doe',
        },
      };

      (api.post as any).mockResolvedValueOnce({ data: mockResponse });

      await authService.login(loginData);

      expect(localStorage.setItem).toHaveBeenCalledWith('authToken', 'mock-token-123');
      expect(localStorage.setItem).toHaveBeenCalledWith('user', JSON.stringify(mockResponse.user));
    });
  });

  describe('logout', () => {
    it('should clear localStorage and reset state', () => {
      localStorage.setItem('authToken', 'mock-token');
      localStorage.setItem('user', JSON.stringify({ id: 1 }));

      authService.logout();

      expect(localStorage.removeItem).toHaveBeenCalledWith('authToken');
      expect(localStorage.removeItem).toHaveBeenCalledWith('user');
    });
  });

  describe('isAuthenticated', () => {
    it('should return true if token exists', () => {
      (localStorage.getItem as any).mockReturnValueOnce('mock-token');

      const result = authService.isAuthenticated();

      expect(result).toBe(true);
    });

    it('should return false if token does not exist', () => {
      (localStorage.getItem as any).mockReturnValueOnce(null);

      const result = authService.isAuthenticated();

      expect(result).toBe(false);
    });
  });
});
