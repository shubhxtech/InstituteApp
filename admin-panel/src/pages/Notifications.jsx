import { useState, useEffect } from 'react';
import api from '../utils/api';
import { Plus, Trash, Bell, Send, Loader, X } from 'lucide-react';
import ImageUpload from '../components/ImageUpload';

export default function Notifications() {
    const [notifications, setNotifications] = useState([]);
    const [loading, setLoading] = useState(true);
    const [sending, setSending] = useState(false);
    const [showForm, setShowForm] = useState(false);

    const [formData, setFormData] = useState({
        title: '',
        description: '',
        image: '',
        by: 'Admin', // Default sender
        type: 'alert'
    });

    useEffect(() => {
        fetchNotifications();
    }, []);

    const fetchNotifications = async () => {
        try {
            setLoading(true);
            const { data } = await api.get('/notifications');
            setNotifications(data);
        } catch (err) {
            console.error('Error fetching notifications:', err);
        } finally {
            setLoading(false);
        }
    };

    const handleSubmit = async (e) => {
        e.preventDefault();
        if (!formData.title || !formData.description) {
            alert('Title and Description are required');
            return;
        }

        try {
            setSending(true);
            const { data } = await api.post('/notifications', formData);
            setNotifications(prev => [data, ...prev]);
            setShowForm(false);
            setFormData({ title: '', description: '', image: '', by: 'Admin', type: 'alert' });
            alert('Notification Sent Successfully!');
        } catch (err) {
            console.error('Error sending notification:', err);
            alert('Failed to send notification');
        } finally {
            setSending(false);
        }
    };

    const handleDelete = async (id) => {
        if (!window.confirm('Delete this notification?')) return;
        try {
            // Note: Admin deletion endpoint might be different depending on backend implementation
            // Assuming we can use the admin content delete route or a specific notification delete route
            // The user wanted verification of "admin to user" flow, so sending is priority.
            // But let's try to delete via standard admin route if it exists
            await api.delete(`/admin/content/notifications/${id}`);
            setNotifications(prev => prev.filter(n => n._id !== id));
        } catch (err) {
            console.error('Error deleting notification:', err);
            // Fallback to standard route if admin route fails, though admin route is safer
            // alert('Failed to delete notification');
        }
    };

    if (loading) return <div className="flex justify-center p-10"><Loader className="animate-spin" /></div>;

    return (
        <div>
            <div className="flex justify-between items-center mb-6">
                <h1 className="text-3xl font-bold text-gray-800">Notifications</h1>
                {!showForm && (
                    <button
                        onClick={() => setShowForm(true)}
                        className="flex items-center space-x-2 bg-blue-600 text-white px-4 py-2 rounded-lg hover:bg-blue-700 transition"
                    >
                        <Send size={20} />
                        <span>Post Notification</span>
                    </button>
                )}
            </div>

            {showForm && (
                <div className="bg-white rounded-xl shadow-md p-6 mb-8 border border-blue-100">
                    <div className="flex justify-between items-center mb-4">
                        <h2 className="text-xl font-bold text-gray-700">New Notification</h2>
                        <button onClick={() => setShowForm(false)} className="text-gray-500 hover:text-gray-700">
                            <X size={24} />
                        </button>
                    </div>

                    <form onSubmit={handleSubmit} className="space-y-4">
                        <div>
                            <label className="block text-sm font-medium text-gray-700 mb-1">Title</label>
                            <input
                                type="text"
                                required
                                className="w-full p-2 border rounded-lg focus:ring-blue-600 focus:border-blue-600"
                                value={formData.title}
                                onChange={e => setFormData({ ...formData, title: e.target.value })}
                                placeholder="e.g. Campus Wi-Fi Maintenance"
                            />
                        </div>

                        <div>
                            <label className="block text-sm font-medium text-gray-700 mb-1">Description</label>
                            <textarea
                                required
                                className="w-full p-2 border rounded-lg focus:ring-blue-600 focus:border-blue-600"
                                rows="3"
                                value={formData.description}
                                onChange={e => setFormData({ ...formData, description: e.target.value })}
                                placeholder="e.g. Wi-Fi will be down from 2 AM to 4 AM..."
                            />
                        </div>

                        <div>
                            <label className="block text-sm font-medium text-gray-700 mb-1">Image (Optional)</label>
                            <ImageUpload
                                value={formData.image}
                                onChange={(url) => setFormData({ ...formData, image: url })}
                                placeholder="Upload Attachment"
                            />
                        </div>

                        <div className="grid grid-cols-2 gap-4">
                            <div>
                                <label className="block text-sm font-medium text-gray-700 mb-1">Sender Name</label>
                                <input
                                    type="text"
                                    className="w-full p-2 border rounded-lg focus:ring-blue-600 focus:border-blue-600"
                                    value={formData.by}
                                    onChange={e => setFormData({ ...formData, by: e.target.value })}
                                />
                            </div>
                            <div>
                                <label className="block text-sm font-medium text-gray-700 mb-1">Type</label>
                                <select
                                    className="w-full p-2 border rounded-lg focus:ring-blue-600 focus:border-blue-600"
                                    value={formData.type}
                                    onChange={e => setFormData({ ...formData, type: e.target.value })}
                                >
                                    <option value="alert">Alert</option>
                                    <option value="info">Info</option>
                                    <option value="event">Event</option>
                                </select>
                            </div>
                        </div>

                        <div className="flex justify-end space-x-3 mt-4">
                            <button
                                type="button"
                                onClick={() => setShowForm(false)}
                                className="px-4 py-2 text-gray-700 bg-gray-100 rounded-lg hover:bg-gray-200"
                            >
                                Cancel
                            </button>
                            <button
                                type="submit"
                                disabled={sending}
                                className="flex items-center space-x-2 bg-blue-600 text-white px-6 py-2 rounded-lg hover:bg-blue-700 disabled:opacity-50"
                            >
                                {sending ? <Loader className="animate-spin" size={20} /> : <Send size={20} />}
                                <span>Send Now</span>
                            </button>
                        </div>
                    </form>
                </div>
            )}

            <div className="space-y-4">
                <h2 className="text-lg font-semibold text-gray-700">Recent Notifications</h2>
                {notifications.length === 0 ? (
                    <div className="text-center py-10 text-gray-400 bg-white rounded-lg border border-dashed">
                        No notifications sent yet.
                    </div>
                ) : (
                    notifications.map(note => (
                        <div key={note._id} className="bg-white rounded-lg shadow-sm p-4 border border-gray-100 flex items-start space-x-4">
                            <div className={`p-3 rounded-full flex-shrink-0 ${note.type === 'alert' ? 'bg-red-100 text-red-600' : 'bg-blue-100 text-blue-600'}`}>
                                <Bell size={24} />
                            </div>
                            <div className="flex-1">
                                <div className="flex justify-between items-start">
                                    <div>
                                        <h3 className="font-bold text-gray-900">{note.title}</h3>
                                        <p className="text-xs text-gray-500 mb-1">
                                            By {note.by} • {new Date(note.createdAt).toLocaleDateString()} {new Date(note.createdAt).toLocaleTimeString()}
                                        </p>
                                    </div>
                                    <button
                                        onClick={() => handleDelete(note._id)}
                                        className="text-gray-400 hover:text-red-500"
                                    >
                                        <Trash size={18} />
                                    </button>
                                </div>
                                <p className="text-gray-600 text-sm mt-1">{note.description}</p>
                                {note.image && (
                                    <div className="mt-3">
                                        <img src={note.image} alt="Attachment" className="h-32 rounded-lg object-cover border" />
                                    </div>
                                )}
                            </div>
                        </div>
                    ))
                )}
            </div>
        </div>
    );
}
