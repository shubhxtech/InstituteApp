import { useState, useEffect } from 'react';
import api from '../utils/api';
import { Plus, Edit, Trash, Save, X, Loader, Calendar as CalendarIcon } from 'lucide-react';

export default function Calendar() {
    const [events, setEvents] = useState([]);
    const [loading, setLoading] = useState(true);
    const [editing, setEditing] = useState(null);
    const [formData, setFormData] = useState({
        title: '',
        startDate: '',
        endDate: '',
        isAllDay: true,
        color: '#3283D5',
        category: 'event'
    });

    useEffect(() => {
        fetchEvents();
    }, []);

    const fetchEvents = async () => {
        try {
            setLoading(true);
            const { data } = await api.get('/admin/events');
            setEvents(data);
        } catch (err) {
            console.error('Error fetching events:', err);
        } finally {
            setLoading(false);
        }
    };

    const handleEdit = (event) => {
        setEditing(event);
        setFormData({
            title: event.title,
            startDate: event.startDate ? new Date(event.startDate).toISOString().split('T')[0] : '',
            endDate: event.endDate ? new Date(event.endDate).toISOString().split('T')[0] : '',
            isAllDay: event.isAllDay,
            color: event.color,
            category: event.category
        });
    };

    const handleDelete = async (id) => {
        if (!window.confirm('Delete this event?')) return;
        try {
            await api.delete(`/admin/events/${id}`);
            setEvents(prev => prev.filter(e => e._id !== id));
        } catch (err) {
            console.error('Error deleting event:', err);
        }
    };

    const handleSubmit = async (e) => {
        e.preventDefault();
        try {
            if (editing === 'new') {
                const { data } = await api.post('/admin/events', formData);
                setEvents(prev => [...prev, data].sort((a, b) => new Date(a.startDate) - new Date(b.startDate)));
            } else {
                const { data } = await api.put(`/admin/events/${editing._id}`, formData);
                setEvents(prev => prev.map(e => e._id === editing._id ? data : e).sort((a, b) => new Date(a.startDate) - new Date(b.startDate)));
            }
            setEditing(null);
        } catch (err) {
            console.error('Error saving event:', err);
            alert('Failed to save event');
        }
    };

    if (loading) return <div className="flex justify-center p-10"><Loader className="animate-spin" /></div>;

    return (
        <div>
            <div className="flex justify-between items-center mb-6">
                <h1 className="text-3xl font-bold text-gray-800">Academic Calendar</h1>
                {!editing && (
                    <button
                        onClick={() => {
                            setEditing('new');
                            setFormData({ title: '', startDate: '', endDate: '', isAllDay: true, color: '#3283D5', category: 'event' });
                        }}
                        className="flex items-center space-x-2 bg-blue-600 text-white px-4 py-2 rounded-lg hover:bg-blue-600 transition"
                    >
                        <Plus size={20} />
                        <span>Add Event</span>
                    </button>
                )}
            </div>

            {editing ? (
                <div className="bg-white rounded-xl shadow-md p-6 max-w-2xl mx-auto">
                    <div className="flex justify-between items-center mb-6">
                        <h2 className="text-xl font-bold text-gray-700">
                            {editing === 'new' ? 'Add New Event' : 'Edit Event'}
                        </h2>
                        <button onClick={() => setEditing(null)} className="text-gray-500 hover:text-gray-700">
                            <X size={24} />
                        </button>
                    </div>

                    <form onSubmit={handleSubmit} className="space-y-4">
                        <div>
                            <label className="block text-sm font-medium text-gray-700 mb-1">Event Title</label>
                            <input
                                type="text"
                                required
                                className="w-full p-2 border rounded-lg focus:ring-blue-600 focus:border-blue-600"
                                value={formData.title}
                                onChange={e => setFormData({ ...formData, title: e.target.value })}
                            />
                        </div>

                        <div className="grid grid-cols-2 gap-4">
                            <div>
                                <label className="block text-sm font-medium text-gray-700 mb-1">Start Date</label>
                                <input
                                    type="date"
                                    required
                                    className="w-full p-2 border rounded-lg focus:ring-blue-600 focus:border-blue-600"
                                    value={formData.startDate}
                                    onChange={e => setFormData({ ...formData, startDate: e.target.value })}
                                />
                            </div>
                            <div>
                                <label className="block text-sm font-medium text-gray-700 mb-1">End Date</label>
                                <input
                                    type="date"
                                    required
                                    className="w-full p-2 border rounded-lg focus:ring-blue-600 focus:border-blue-600"
                                    value={formData.endDate}
                                    onChange={e => setFormData({ ...formData, endDate: e.target.value })}
                                />
                            </div>
                        </div>

                        <div className="grid grid-cols-2 gap-4">
                            <div>
                                <label className="block text-sm font-medium text-gray-700 mb-1">Color Code</label>
                                <div className="flex items-center space-x-2">
                                    <input
                                        type="color"
                                        className="h-10 w-10 p-0 border-0 rounded"
                                        value={formData.color}
                                        onChange={e => setFormData({ ...formData, color: e.target.value })}
                                    />
                                    <input
                                        type="text"
                                        value={formData.color}
                                        onChange={e => setFormData({ ...formData, color: e.target.value })}
                                        className="flex-1 p-2 border rounded-lg uppercase"
                                    />
                                </div>
                            </div>
                            <div>
                                <label className="block text-sm font-medium text-gray-700 mb-1">Category</label>
                                <select
                                    className="w-full p-2 border rounded-lg focus:ring-blue-600 focus:border-blue-600"
                                    value={formData.category}
                                    onChange={e => setFormData({ ...formData, category: e.target.value })}
                                >
                                    <option value="event">Event</option>
                                    <option value="exam">Exam</option>
                                    <option value="holiday">Holiday</option>
                                    <option value="deadline">Deadline</option>
                                    <option value="break">Break</option>
                                </select>
                            </div>
                        </div>

                        <div className="flex items-center space-x-2">
                            <input
                                type="checkbox"
                                id="isAllDay"
                                checked={formData.isAllDay}
                                onChange={e => setFormData({ ...formData, isAllDay: e.target.checked })}
                                className="w-4 h-4 text-blue-600 rounded border-gray-300 focus:ring-blue-600"
                            />
                            <label htmlFor="isAllDay" className="text-gray-700">All Day Event</label>
                        </div>

                        <div className="flex justify-end space-x-3 mt-6">
                            <button
                                type="button"
                                onClick={() => setEditing(null)}
                                className="px-4 py-2 text-gray-700 bg-gray-100 rounded-lg hover:bg-gray-200"
                            >
                                Cancel
                            </button>
                            <button
                                type="submit"
                                className="flex items-center space-x-2 bg-blue-600 text-white px-6 py-2 rounded-lg hover:bg-blue-600"
                            >
                                <Save size={20} />
                                <span>Save Event</span>
                            </button>
                        </div>
                    </form>
                </div>
            ) : (
                <div className="bg-white rounded-xl shadow-md overflow-hidden">
                    <div className="overflow-x-auto">
                        <table className="w-full text-left">
                            <thead className="bg-gray-50 border-b">
                                <tr>
                                    <th className="px-6 py-3 text-xs font-semibold text-gray-500 uppercase">Status</th>
                                    <th className="px-6 py-3 text-xs font-semibold text-gray-500 uppercase">Event</th>
                                    <th className="px-6 py-3 text-xs font-semibold text-gray-500 uppercase">Date Range</th>
                                    <th className="px-6 py-3 text-xs font-semibold text-gray-500 uppercase">Category</th>
                                    <th className="px-6 py-3 text-xs font-semibold text-gray-500 uppercase">Actions</th>
                                </tr>
                            </thead>
                            <tbody className="divide-y divide-gray-100">
                                {events.map((event) => {
                                    const start = new Date(event.startDate);
                                    const end = new Date(event.endDate);
                                    const isPast = end < new Date();

                                    return (
                                        <tr key={event._id} className="hover:bg-gray-50">
                                            <td className="px-6 py-4">
                                                <span className={`px-2 py-1 text-xs rounded-full ${isPast ? 'bg-gray-100 text-gray-600' : 'bg-green-100 text-green-700'}`}>
                                                    {isPast ? 'Past' : 'Upcoming'}
                                                </span>
                                            </td>
                                            <td className="px-6 py-4">
                                                <div className="flex items-center space-x-3">
                                                    <div className="w-3 h-3 rounded-full" style={{ backgroundColor: event.color }}></div>
                                                    <span className="font-medium text-gray-900">{event.title}</span>
                                                </div>
                                            </td>
                                            <td className="px-6 py-4 text-sm text-gray-500">
                                                {start.toLocaleDateString()} - {end.toLocaleDateString()}
                                            </td>
                                            <td className="px-6 py-4">
                                                <span className="capitalize text-sm text-gray-600 bg-gray-100 px-2 py-0.5 rounded">
                                                    {event.category}
                                                </span>
                                            </td>
                                            <td className="px-6 py-4 flex space-x-3">
                                                <button onClick={() => handleEdit(event)} className="text-blue-600 hover:text-blue-800">
                                                    <Edit size={16} />
                                                </button>
                                                <button onClick={() => handleDelete(event._id)} className="text-red-600 hover:text-red-800">
                                                    <Trash size={16} />
                                                </button>
                                            </td>
                                        </tr>
                                    );
                                })}
                                {events.length === 0 && (
                                    <tr><td colSpan="5" className="text-center py-8 text-gray-400">No events found.</td></tr>
                                )}
                            </tbody>
                        </table>
                    </div>
                </div>
            )}
        </div>
    );
}
