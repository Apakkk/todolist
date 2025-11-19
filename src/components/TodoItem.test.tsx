import { describe, it, expect, vi } from 'vitest';
import { render, screen, fireEvent } from '@testing-library/react';
import TodoItem from '../components/TodoItem';
import type { Todo } from '../services/todoService';

describe('TodoItem Component', () => {
  const mockTodo: Todo = {
    id: 1,
    text: 'Test todo item',
    completed: false,
    createdAt: '2024-01-01T00:00:00Z',
    userId: 1,
  };

  it('should render todo item with text', () => {
    const mockOnToggle = vi.fn();
    const mockOnDelete = vi.fn();

    render(
      <TodoItem 
        todo={mockTodo} 
        onToggle={mockOnToggle} 
        onDelete={mockOnDelete} 
      />
    );

    expect(screen.getByText('Test todo item')).toBeInTheDocument();
  });

  it('should apply completed class when todo is completed', () => {
    const completedTodo = { ...mockTodo, completed: true };
    const mockOnToggle = vi.fn();
    const mockOnDelete = vi.fn();

    const { container } = render(
      <TodoItem 
        todo={completedTodo} 
        onToggle={mockOnToggle} 
        onDelete={mockOnDelete} 
      />
    );

    const todoElement = container.querySelector('.line-through');
    expect(todoElement).toBeInTheDocument();
  });

  it('should call onToggle when toggle button is clicked', () => {
    const mockOnToggle = vi.fn();
    const mockOnDelete = vi.fn();

    render(
      <TodoItem 
        todo={mockTodo} 
        onToggle={mockOnToggle} 
        onDelete={mockOnDelete} 
      />
    );

    const toggleButton = screen.getByRole('button', { name: /toggle/i });
    fireEvent.click(toggleButton);

    expect(mockOnToggle).toHaveBeenCalledWith(mockTodo.id);
  });

  it('should call onDelete when delete button is clicked', () => {
    const mockOnToggle = vi.fn();
    const mockOnDelete = vi.fn();

    render(
      <TodoItem 
        todo={mockTodo} 
        onToggle={mockOnToggle} 
        onDelete={mockOnDelete} 
      />
    );

    const deleteButton = screen.getByRole('button', { name: /delete/i });
    fireEvent.click(deleteButton);

    expect(mockOnDelete).toHaveBeenCalledWith(mockTodo.id);
  });
});
