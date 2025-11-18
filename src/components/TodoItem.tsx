import { Trash2, Check } from 'lucide-react';
import { Todo } from '../services/todoService';

interface TodoItemProps {
  todo: Todo;
  onDelete: (id: number) => void;
  onToggle: (id: number) => void;
}

export default function TodoItem({ todo, onDelete, onToggle }: TodoItemProps) {
  const formatDate = (dateString: string) => {
    const date = new Date(dateString);
    return date.toLocaleDateString('tr-TR', {
      day: '2-digit',
      month: '2-digit',
      year: 'numeric',
      hour: '2-digit',
      minute: '2-digit'
    });
  };

  return (
    <div className="flex items-center gap-3 p-4 bg-gray-50 rounded-lg hover:bg-gray-100 transition-colors">
      <button
        onClick={() => onToggle(todo.id)}
        className={`w-6 h-6 rounded-full border-2 flex items-center justify-center transition-all ${
          todo.completed
            ? 'bg-green-500 border-green-500 text-white'
            : 'border-gray-300 hover:border-green-400'
        }`}
      >
        {todo.completed && <Check size={16} />}
      </button>
      
      <div className="flex-1">
        <p className={`transition-all ${
          todo.completed 
            ? 'text-gray-500 line-through' 
            : 'text-gray-800'
        }`}>
          {todo.text}
        </p>
        <p className="text-xs text-gray-400 mt-1">
          {formatDate(todo.createdAt)}
          {todo.updatedAt && todo.updatedAt !== todo.createdAt && (
            <span> • Güncellendi: {formatDate(todo.updatedAt)}</span>
          )}
        </p>
      </div>
      
      <button
        onClick={() => onDelete(todo.id)}
        className="p-2 text-red-500 hover:bg-red-50 rounded-lg transition-colors"
        aria-label="Görevi sil"
      >
        <Trash2 size={18} />
      </button>
    </div>
  );
}
