import { describe, it, expect, beforeEach, vi } from 'vitest';
import { todoService, Todo, CreateTodoData, UpdateTodoData } from '../services/todoService';
import api from '../services/api';

vi.mock('../services/api');

describe('todoService', () => {
  beforeEach(() => {
    vi.clearAllMocks();
  });

  describe('getTodos', () => {
    it('should fetch all todos', async () => {
      const mockTodos: Todo[] = [
        {
          id: 1,
          text: 'Test todo 1',
          completed: false,
          createdAt: '2024-01-01T00:00:00Z',
          userId: 1,
        },
        {
          id: 2,
          text: 'Test todo 2',
          completed: true,
          createdAt: '2024-01-02T00:00:00Z',
          userId: 1,
        },
      ];

      (api.get as any).mockResolvedValueOnce({ data: mockTodos });

      const result = await todoService.getTodos();

      expect(api.get).toHaveBeenCalledWith('/todos');
      expect(result).toEqual(mockTodos);
      expect(result).toHaveLength(2);
    });

    it('should handle errors when fetching todos', async () => {
      const error = new Error('Network error');
      (api.get as any).mockRejectedValueOnce(error);

      await expect(todoService.getTodos()).rejects.toThrow('Network error');
    });
  });

  describe('createTodo', () => {
    it('should create a new todo', async () => {
      const createData: CreateTodoData = { text: 'New todo' };
      const mockTodo: Todo = {
        id: 3,
        text: 'New todo',
        completed: false,
        createdAt: '2024-01-03T00:00:00Z',
        userId: 1,
      };

      (api.post as any).mockResolvedValueOnce({ data: mockTodo });

      const result = await todoService.createTodo(createData);

      expect(api.post).toHaveBeenCalledWith('/todos', createData);
      expect(result).toEqual(mockTodo);
      expect(result.text).toBe('New todo');
    });

    it('should handle validation errors', async () => {
      const createData: CreateTodoData = { text: '' };
      const error = new Error('Validation error');
      (api.post as any).mockRejectedValueOnce(error);

      await expect(todoService.createTodo(createData)).rejects.toThrow('Validation error');
    });
  });

  describe('updateTodo', () => {
    it('should update an existing todo', async () => {
      const updateData: UpdateTodoData = { text: 'Updated todo', completed: true };
      const mockTodo: Todo = {
        id: 1,
        text: 'Updated todo',
        completed: true,
        createdAt: '2024-01-01T00:00:00Z',
        updatedAt: '2024-01-03T00:00:00Z',
        userId: 1,
      };

      (api.put as any).mockResolvedValueOnce({ data: mockTodo });

      const result = await todoService.updateTodo(1, updateData);

      expect(api.put).toHaveBeenCalledWith('/todos/1', updateData);
      expect(result).toEqual(mockTodo);
      expect(result.completed).toBe(true);
    });
  });

  describe('deleteTodo', () => {
    it('should delete a todo', async () => {
      (api.delete as any).mockResolvedValueOnce({});

      await todoService.deleteTodo(1);

      expect(api.delete).toHaveBeenCalledWith('/todos/1');
    });
  });

  describe('toggleTodo', () => {
    it('should toggle a todo completion status', async () => {
      const mockTodo: Todo = {
        id: 1,
        text: 'Test todo',
        completed: true,
        createdAt: '2024-01-01T00:00:00Z',
        updatedAt: '2024-01-03T00:00:00Z',
        userId: 1,
      };

      (api.put as any).mockResolvedValueOnce({ data: mockTodo });

      const result = await todoService.toggleTodo(1);

      expect(api.put).toHaveBeenCalledWith('/todos/1/toggle');
      expect(result.completed).toBe(true);
    });
  });
});
