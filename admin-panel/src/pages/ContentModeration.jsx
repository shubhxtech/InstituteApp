import { useState, useEffect } from 'react';
import api from '../utils/api';
import { Trash, Eye, Loader, Search } from 'lucide-react';

export default function ContentModeration({ type, title }) {
    const [items, setItems] = useState([]);
    const [loading, setLoading] = useState(true);
    const [page, setPage] = useState(1);
    const [totalPages, setTotalPages] = useState(1);
    const [searchTerm, setSearchTerm] = useState('');

    useEffect(() => {
        fetchContent();
    }, [type, page, searchTerm]);

    // Debounce search could be added here for optimization

    const fetchContent = async () => {
        try {
            setLoading(true);
            const { data } = await api.get(`/admin/content/${type}?page=${page}&limit=10&search=${searchTerm}`);
            setItems(data.items);
            setTotalPages(data.totalPages);
        } catch (err) {
            console.error(`Error fetching ${type}: `, err);
        } finally {
            setLoading(false);
        }
    };

    const handleDelete = async (id) => {
        if (!window.confirm('Delete this item permanently? This cannot be undone.')) return;
        try {
            await api.delete(`/admin/content/${type}/${id}`);
            setItems(prev => prev.filter(item => item._id !== id));
        } catch (err) {
            console.error('Error deleting item:', err);
            alert('Failed to delete item');
        }
    };

    return (
        <div>
            <div className="flex justify-between items-center mb-6">
                <h1 className="text-3xl font-bold text-gray-800">{title} Moderation</h1>
                <div className="relative">
                    <Search className="absolute left-3 top-2.5 text-gray-400 h-5 w-5" />
                    <input
                        type="text"
                        placeholder="Search..."
                        className="pl-10 pr-4 py-2 border rounded-lg focus:outline-none focus:ring-blue-600 focus:border-blue-600 w-64"
                        value={searchTerm}
                        onChange={(e) => setSearchTerm(e.target.value)}
                    />
                </div>
            </div>

            <div className="bg-white rounded-xl shadow-md overflow-hidden">
                <div className="overflow-x-auto">
                    <table className="w-full text-left">
                        <thead className="bg-gray-50 border-b">
                            <tr>
                                <th className="px-6 py-3 text-xs font-semibold text-gray-500 uppercase tracking-wider">Item</th>
                                <th className="px-6 py-3 text-xs font-semibold text-gray-500 uppercase tracking-wider">Details</th>
                                <th className="px-6 py-3 text-xs font-semibold text-gray-500 uppercase tracking-wider">Date</th>
                                <th className="px-6 py-3 text-xs font-semibold text-gray-500 uppercase tracking-wider">Actions</th>
                            </tr>
                        </thead>
                        <tbody className="divide-y divide-gray-100">
                            {items.map((item) => (
                                <tr key={item._id} className="hover:bg-gray-50">
                                    <td className="px-6 py-4">
                                        <div className="flex items-center space-x-3">
                                            <div className="h-10 w-10 bg-gray-100 rounded flex-shrink-0 overflow-hidden">
                                                {(item.images && item.images[0]) || (item.image) ? (
                                                    <img
                                                        src={item.images ? item.images[0] : item.image}
                                                        alt=""
                                                        className="h-full w-full object-cover"
                                                    />
                                                ) : (
                                                    <div className="h-full w-full flex items-center justify-center text-gray-300 text-xs">No Img</div>
                                                )}
                                            </div>
                                            <div>
                                                <p className="font-medium text-gray-900 truncate max-w-xs">{item.name || item.title}</p>
                                                <p className="text-xs text-gray-500">{item._id}</p>
                                            </div>
                                        </div>
                                    </td>
                                    <td className="px-6 py-4">
                                        <p className="text-sm text-gray-500 truncate max-w-sm">{item.description || item.details}</p>
                                    </td>
                                    <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                                        {new Date(item.createdAt).toLocaleDateString()}
                                    </td>
                                    <td className="px-6 py-4 whitespace-nowrap">
                                        <button
                                            onClick={() => handleDelete(item._id)}
                                            className="text-red-600 hover:text-red-900 flex items-center space-x-1"
                                        >
                                            <Trash size={16} />
                                            <span className="text-xs font-medium">Delete</span>
                                        </button>
                                    </td>
                                </tr>
                            ))}
                            {items.length === 0 && !loading && (
                                <tr>
                                    <td colSpan="4" className="px-6 py-8 text-center text-gray-500">No items found.</td>
                                </tr>
                            )}
                        </tbody>
                    </table>
                </div>

                {/* Pagination */}
                {totalPages > 1 && (
                    <div className="px-6 py-4 border-t flex justify-center space-x-2">
                        <button
                            onClick={() => setPage(p => Math.max(1, p - 1))}
                            disabled={page === 1}
                            className="px-3 py-1 border rounded disabled:opacity-50 hover:bg-gray-50"
                        >
                            Previous
                        </button>
                        <span className="px-3 py-1 text-gray-600">Page {page} of {totalPages}</span>
                        <button
                            onClick={() => setPage(p => Math.min(totalPages, p + 1))}
                            disabled={page === totalPages}
                            className="px-3 py-1 border rounded disabled:opacity-50 hover:bg-gray-50"
                        >
                            Next
                        </button>
                    </div>
                )}
            </div>
        </div>
    );
}
