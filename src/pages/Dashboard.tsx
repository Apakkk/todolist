import { useState, useEffect, FormEvent } from 'react';
import { useNavigate } from 'react-router-dom';
import { LogOut, Plus, ListTodo } from 'lucide-react';
import { authService, User } from '../services/authService';
import { todoService, Todo } from '../services/todoService';
import TodoItem from '../components/TodoItem';

export default function Dashboard() {
  const [todos, setTodos] = useState<Todo[]>([]);
  const [newTodo, setNewTodo] = useState('');
  const [user, setUser] = useState<User | null>(null);
  const [loading, setLoading] = useState(true);
  const navigate = useNavigate();

  useEffect(() => {
    const loadData = async () => {
      try {
        if (!authService.isAuthenticated()) {
          navigate('/login');
          return;
        }

        const userData = authService.getStoredUser();
        setUser(userData);

        const todosData = await todoService.getTodos();
        setTodos(todosData);
      } catch (error) {
        console.error('Error loading data:', error);
      } finally {
        setLoading(false);
      }
    };

    loadData();
  }, [navigate]);

  const handleAddTodo = async (e: FormEvent) => {
    e.preventDefault();
    if (!newTodo.trim()) return;

    try {
      const todo = await todoService.createTodo({ text: newTodo.trim() });
      setTodos([todo, ...todos]);
      setNewTodo('');
    } catch (error) {
      console.error('Error adding todo:', error);
    }
  };

  const handleDeleteTodo = async (id: number) => {
    try {
      await todoService.deleteTodo(id);
      setTodos(todos.filter(todo => todo.id !== id));
    } catch (error) {
      console.error('Error deleting todo:', error);
    }
  };

  const handleToggleTodo = async (id: number) => {
    try {
      const updatedTodo = await todoService.toggleTodo(id);
      setTodos(todos.map(todo => todo.id === id ? updatedTodo : todo));
    } catch (error) {
      console.error('Error toggling todo:', error);
    }
  };

  const handleLogout = () => {
    authService.logout();
    navigate('/login');
  };

  const completedCount = todos.filter(todo => todo.completed).length;
  const activeCount = todos.length - completedCount;

  if (loading) {
    return (
      <div className="min-h-screen bg-gradient-to-br from-blue-50 to-indigo-100 flex items-center justify-center">
        <div className="text-center">
          <div className="bg-blue-100 p-4 rounded-full inline-block mb-4">
            <ListTodo className="text-blue-600" size={32} />
          </div>
          <p className="text-gray-600">Yükleniyor...</p>
        </div>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-50 to-indigo-100">
      <div className="max-w-2xl mx-auto p-6">
        <div className="bg-white rounded-2xl shadow-xl p-8 mb-6">
          <div className="flex items-center justify-between mb-8">
            <div className="flex items-center gap-3">
              <div className="bg-blue-100 p-3 rounded-lg">
                <ListTodo className="text-blue-600" size={32} />
              </div>
              <div>
                <h1 className="text-3xl font-bold text-gray-800">Todo List</h1>
                <p className="text-gray-600">
                  Hoş geldin, {user?.firstName} {user?.lastName}!
                </p>
              </div>
            </div>
            <button
              onClick={handleLogout}
              className="flex items-center gap-2 px-4 py-2 bg-red-50 text-red-600 rounded-lg hover:bg-red-100 transition-colors font-medium"
            >
              <LogOut size={18} />
              Çıkış
            </button>
          </div>

          <form onSubmit={handleAddTodo} className="flex gap-3 mb-8">
            <input
              type="text"
              value={newTodo}
              onChange={(e) => setNewTodo(e.target.value)}
              placeholder="Yeni görev ekle..."
              className="flex-1 px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent outline-none transition"
            />
            <button
              type="submit"
              className="px-6 py-3 bg-blue-600 text-white rounded-lg font-medium hover:bg-blue-700 transition-colors shadow-md hover:shadow-lg flex items-center gap-2"
            >
              <Plus size={20} />
              Ekle
            </button>
          </form>

          <div className="flex items-center justify-between mb-6 text-sm text-gray-600">
            <span>{activeCount} aktif görev</span>
            <span>{completedCount} tamamlanmış görev</span>
          </div>

          {todos.length === 0 ? (
            <div className="text-center py-12">
              <div className="flex justify-center mb-4">
                <div className="bg-gray-100 p-4 rounded-full">
                  <ListTodo className="text-gray-400" size={48} />
                </div>
              </div>
              <h3 className="text-lg font-semibold text-gray-700 mb-2">Henüz görev yok</h3>
              <p className="text-gray-500">Yukarıdan yeni görev ekleyerek başlayın!</p>
            </div>
          ) : (
            <div className="space-y-2">
              {todos.map(todo => (
                <TodoItem
                  key={todo.id}
                  todo={todo}
                  onDelete={() => handleDeleteTodo(todo.id)}
                  onToggle={() => handleToggleTodo(todo.id)}
                />
              ))}
            </div>
          )}
        </div>
      </div>
    </div>
  );
}
