import { useState, useEffect } from 'react';
import api from '../utils/api';
import { Plus, Edit, Trash, Save, X, Loader, GripVertical } from 'lucide-react';
import ImageUpload from '../components/ImageUpload';

export default function Carousel() {
    const [images, setImages] = useState([]);
    const [loading, setLoading] = useState(true);
    const [editing, setEditing] = useState(null);
    const [formData, setFormData] = useState({
        imageUrl: '',
        title: '',
        description: '',
        link: '',
        order: 0,
        active: true
    });

    useEffect(() => {
        fetchImages();
    }, []);

    const fetchImages = async () => {
        try {
            setLoading(true);
            const { data } = await api.get('/admin/carousel');
            setImages(data);
        } catch (err) {
            console.error('Error fetching carousel images:', err);
        } finally {
            setLoading(false);
        }
    };

    const handleEdit = (img) => {
        setEditing(img);
        setFormData({
            imageUrl: img.imageUrl,
            title: img.title,
            description: img.description,
            link: img.link,
            order: img.order,
            active: img.active
        });
    };

    const handleDelete = async (id) => {
        if (!window.confirm('Delete this slide?')) return;
        try {
            await api.delete(`/admin/carousel/${id}`);
            setImages(prev => prev.filter(img => img._id !== id));
        } catch (err) {
            console.error('Error deleting image:', err);
        }
    };

    const handleSubmit = async (e) => {
        e.preventDefault();
        try {
            if (editing === 'new') {
                const { data } = await api.post('/admin/carousel', { ...formData, order: images.length });
                setImages(prev => [...prev, data]);
            } else {
                const { data } = await api.put(`/admin/carousel/${editing._id}`, formData);
                setImages(prev => prev.map(img => img._id === editing._id ? data : img));
            }
            setEditing(null);
        } catch (err) {
            console.error('Error saving image:', err);
            alert('Failed to save image');
        }
    };

    if (loading) return <div className="flex justify-center p-10"><Loader className="animate-spin" /></div>;

    return (
        <div>
            <div className="flex justify-between items-center mb-6">
                <h1 className="text-3xl font-bold text-gray-800">Carousel Manager</h1>
                {!editing && (
                    <button
                        onClick={() => {
                            setEditing('new');
                            setFormData({ imageUrl: '', title: '', description: '', link: '', order: images.length, active: true });
                        }}
                        className="flex items-center space-x-2 bg-blue-600 text-white px-4 py-2 rounded-lg hover:bg-blue-700 transition"
                    >
                        <Plus size={20} />
                        <span>Add Slide</span>
                    </button>
                )}
            </div>

            {editing ? (
                <div className="bg-white rounded-xl shadow-md p-6 max-w-2xl mx-auto">
                    <div className="flex justify-between items-center mb-6">
                        <h2 className="text-xl font-bold text-gray-700">
                            {editing === 'new' ? 'Add New Slide' : 'Edit Slide'}
                        </h2>
                        <button onClick={() => setEditing(null)} className="text-gray-500 hover:text-gray-700">
                            <X size={24} />
                        </button>
                    </div>

                    <form onSubmit={handleSubmit} className="space-y-4">
                        <div>
                            <label className="block text-sm font-medium text-gray-700 mb-1">Image</label>
                            <ImageUpload
                                value={formData.imageUrl}
                                onChange={(url) => setFormData({ ...formData, imageUrl: url })}
                                placeholder="Upload Carousel Slide"
                            />
                        </div>
                        <div>
                            <label className="block text-sm font-medium text-gray-700 mb-1">Title (Optional)</label>
                            <input
                                type="text"
                                className="w-full p-2 border rounded-lg focus:ring-blue-600 focus:border-blue-600"
                                value={formData.title}
                                onChange={e => setFormData({ ...formData, title: e.target.value })}
                            />
                        </div>
                        <div>
                            <label className="block text-sm font-medium text-gray-700 mb-1">Description (Optional)</label>
                            <textarea
                                className="w-full p-2 border rounded-lg focus:ring-blue-600 focus:border-blue-600"
                                rows="2"
                                value={formData.description}
                                onChange={e => setFormData({ ...formData, description: e.target.value })}
                            />
                        </div>
                        <div className="flex items-center space-x-2">
                            <input
                                type="checkbox"
                                id="active"
                                checked={formData.active}
                                onChange={e => setFormData({ ...formData, active: e.target.checked })}
                                className="w-4 h-4 text-blue-600 rounded border-gray-300 focus:ring-blue-600"
                            />
                            <label htmlFor="active" className="text-gray-700">Active (Visible)</label>
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
                                <span>Save Slide</span>
                            </button>
                        </div>
                    </form>
                </div>
            ) : (
                <div className="space-y-4 max-w-4xl mx-auto">
                    {images.map((img, index) => (
                        <div key={img._id} className="bg-white rounded-lg shadow-sm p-4 flex items-center space-x-4 border border-gray-100">
                            <div className="cursor-move text-gray-400 hover:text-gray-600">
                                <GripVertical size={20} />
                            </div>
                            <div className="h-16 w-24 bg-gray-100 rounded overflow-hidden flex-shrink-0">
                                <img src={img.imageUrl} alt={img.title} className="w-full h-full object-cover" />
                            </div>
                            <div className="flex-1">
                                <div className="flex items-center space-x-2">
                                    <h3 className="font-medium text-gray-900">{img.title || 'Untitled Slide'}</h3>
                                    {!img.active && <span className="px-2 py-0.5 bg-gray-200 text-gray-600 text-xs rounded-full">Inactive</span>}
                                </div>
                                <p className="text-sm text-gray-500 truncate">{img.description || 'No description'}</p>
                            </div>
                            <div className="flex space-x-2">
                                <button onClick={() => handleEdit(img)} className="p-2 text-blue-600 hover:bg-blue-50 rounded-full">
                                    <Edit size={18} />
                                </button>
                                <button onClick={() => handleDelete(img._id)} className="p-2 text-red-600 hover:bg-red-50 rounded-full">
                                    <Trash size={18} />
                                </button>
                            </div>
                        </div>
                    ))}
                    {images.length === 0 && (
                        <div className="text-center py-10 text-gray-400">No slides configured. Add one to display on homepage.</div>
                    )}
                </div>
            )}
        </div>
    );
}
