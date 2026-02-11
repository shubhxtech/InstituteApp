import { useState, useEffect } from 'react';
import api from '../utils/api';
import { Users, ShoppingBag, Search, MessageSquare, Briefcase, Bell } from 'lucide-react';

export default function Dashboard() {
    const [stats, setStats] = useState({
        users: 0,
        buySell: 0,
        lostFound: 0,
        posts: 0,
        jobs: 0,
        notifications: 0
    });

    useEffect(() => {
        fetchStats();
    }, []);

    const fetchStats = async () => {
        try {
            // In a real app, you'd have a dedicated stats endpoint
            // For now, we'll fetch counts from individual endpoints or mock them
            // asking backend to add a stats endpoint is best practice
            // For this MVP, we'll just show placeholders or fetch list lengths
            const [bs, lf, posts, jobs, notifs] = await Promise.all([
                api.get('/admin/content/buy-sell?limit=1'),
                api.get('/admin/content/lost-found?limit=1'),
                api.get('/admin/content/posts?limit=1'),
                api.get('/admin/content/jobs?limit=1'),
                api.get('/admin/content/notifications?limit=1')
            ]);

            setStats({
                users: 0, // No user count endpoint yet
                buySell: bs.data.total,
                lostFound: lf.data.total,
                posts: posts.data.total,
                jobs: jobs.data.total,
                notifications: notifs.data.total
            });
        } catch (error) {
            console.error('Error fetching stats:', error);
        }
    };

    const statCards = [
        { title: 'Buy & Sell Items', value: stats.buySell, icon: ShoppingBag, color: 'bg-blue-500' },
        { title: 'Lost & Found', value: stats.lostFound, icon: Search, color: 'bg-orange-500' },
        { title: 'Posts', value: stats.posts, icon: MessageSquare, color: 'bg-green-500' },
        { title: 'Jobs', value: stats.jobs, icon: Briefcase, color: 'bg-purple-500' },
        { title: 'Notifications', value: stats.notifications, icon: Bell, color: 'bg-red-500' },
        { title: 'Users', value: stats.users || '-', icon: Users, color: 'bg-gray-500' },
    ];

    return (
        <div>
            <h1 className="text-3xl font-bold text-gray-800 mb-8">Dashboard Overview</h1>

            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                {statCards.map((card, index) => (
                    <div key={index} className="bg-white rounded-xl shadow-md p-6 flex items-center space-x-4">
                        <div className={`p-4 rounded-full ${card.color} text-white`}>
                            <card.icon size={24} />
                        </div>
                        <div>
                            <p className="text-gray-500 text-sm font-medium">{card.title}</p>
                            <h3 className="text-2xl font-bold text-gray-900">{card.value}</h3>
                        </div>
                    </div>
                ))}
            </div>

            <div className="mt-12">
                <h2 className="text-xl font-bold text-gray-800 mb-4">Quick Actions</h2>
                <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4">
                    {/* Quick action buttons can go here */}
                    <div className="bg-white p-6 rounded-lg shadow-sm border border-gray-100 hover:shadow-md transition cursor-pointer">
                        <h3 className="font-bold text-blue-600 mb-2">Update Mess Menu</h3>
                        <p className="text-gray-500 text-sm">Edit today's menu quickly</p>
                    </div>
                    <div
                        onClick={() => window.location.href = '/notifications'}
                        className="bg-white p-6 rounded-lg shadow-sm border border-gray-100 hover:shadow-md transition cursor-pointer"
                    >
                        <h3 className="font-bold text-blue-600 mb-2">Post Notification</h3>
                        <p className="text-gray-500 text-sm">Send alert to all users</p>
                    </div>
                </div>
            </div>
        </div>
    );
}
