import api from './api';

export interface Todo {
  id: number;
  text: string;
  completed: boolean;
  createdAt: string;
  updatedAt?: string;
  userId: number;
}

export interface CreateTodoData {
  text: string;
}

export interface UpdateTodoData {
  text: string;
  completed: boolean;
}

export const todoService = {
  async getTodos(): Promise<Todo[]> {
    const response = await api.get('/todos');
    return response.data;
  },

  async createTodo(data: CreateTodoData): Promise<Todo> {
    const response = await api.post('/todos', data);
    return response.data;
  },

  async updateTodo(id: number, data: UpdateTodoData): Promise<Todo> {
    const response = await api.put(`/todos/${id}`, data);
    return response.data;
  },

  async deleteTodo(id: number): Promise<void> {
    await api.delete(`/todos/${id}`);
  },

  async toggleTodo(id: number): Promise<Todo> {
    const response = await api.put(`/todos/${id}/toggle`);
    return response.data;
  }
};
