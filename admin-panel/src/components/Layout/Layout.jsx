import { Outlet, NavLink, useNavigate } from 'react-router-dom';
import {
    LayoutDashboard,
    Utensils,
    Coffee,
    Image,
    Calendar,
    ShoppingBag,
    Search,
    MessageSquare,
    LogOut,
    Bell
} from 'lucide-react';
import { logout } from '../../utils/auth';

export default function Layout() {
    const navigate = useNavigate();
    const user = JSON.parse(localStorage.getItem('adminUser') || '{}');

    const handleLogout = () => {
        logout();
    };

    const navItems = [
        { name: 'Dashboard', path: '/', icon: LayoutDashboard },
        { name: 'Mess Menu', path: '/mess-menu', icon: Utensils },
        { name: 'Cafeteria', path: '/cafeteria', icon: Coffee },
        { name: 'Carousel', path: '/carousel', icon: Image },
        { name: 'Calendar', path: '/calendar', icon: Calendar },
        { name: 'Buy & Sell', path: '/buy-sell', icon: ShoppingBag },
        { name: 'Lost & Found', path: '/lost-found', icon: Search },
        { name: 'Posts', path: '/posts', icon: MessageSquare },
        { name: 'Notifications', path: '/notifications', icon: Bell },
    ];

    return (
        <div className="flex h-screen bg-gray-100">
            {/* Sidebar */}
            <div className="w-64 bg-white shadow-lg">
                <div className="p-6 border-b">
                    <h1 className="text-2xl font-bold text-primary">Insti Admin</h1>
                </div>
                <nav className="p-4 space-y-1">
                    {navItems.map((item) => (
                        <NavLink
                            key={item.path}
                            to={item.path}
                            className={({ isActive }) =>
                                `flex items-center space-x-3 px-4 py-3 rounded-lg transition-colors ${isActive ? 'bg-blue-50 text-primary' : 'text-gray-600 hover:bg-gray-50'
                                }`
                            }
                        >
                            <item.icon size={20} />
                            <span>{item.name}</span>
                        </NavLink>
                    ))}
                </nav>
                <div className="absolute bottom-0 w-64 p-4 border-t bg-white">
                    <div className="flex items-center justify-between mb-4">
                        <div className="flex items-center space-x-2">
                            <div className="w-8 h-8 bg-blue-600 rounded-full flex items-center justify-center text-white font-bold">
                                {user.name?.[0] || 'A'}
                            </div>
                            <div className="text-sm">
                                <p className="font-medium text-gray-900">{user.name || 'Admin'}</p>
                                <p className="text-gray-500 text-xs">{user.email}</p>
                            </div>
                        </div>
                        <button onClick={handleLogout} className="text-gray-400 hover:text-danger">
                            <LogOut size={20} />
                        </button>
                    </div>
                </div>
            </div>

            {/* Main Content */}
            <div className="flex-1 overflow-auto">
                <div className="p-8">
                    <Outlet />
                </div>
            </div>
        </div>
    );
}
