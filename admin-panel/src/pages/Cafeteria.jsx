import { useState, useEffect } from 'react';
import api from '../utils/api';
import { Plus, Edit, Trash, Save, X, Loader } from 'lucide-react';
import ImageUpload from '../components/ImageUpload';

export default function Cafeteria() {
    const [cafeterias, setCafeterias] = useState([]);
    const [loading, setLoading] = useState(true);
    const [editing, setEditing] = useState(null); // null = list, 'new' = create, object = edit
    const [formData, setFormData] = useState({
        name: '',
        location: '',
        time: '',
        contact: '',
        deliveryTime: '',
        images: [], // Array of URLs
        menu: []    // Array of URLs
    });

    useEffect(() => {
        fetchCafeterias();
    }, []);

    const fetchCafeterias = async () => {
        try {
            setLoading(true);
            const { data } = await api.get('/admin/cafeteria');
            setCafeterias(data);
        } catch (err) {
            console.error('Error fetching cafeterias:', err);
        } finally {
            setLoading(false);
        }
    };

    const handleEdit = (cafeteria) => {
        setEditing(cafeteria);
        setFormData({
            name: cafeteria.name,
            location: cafeteria.location,
            time: cafeteria.time,
            contact: cafeteria.contact,
            deliveryTime: cafeteria.deliveryTime,
            images: cafeteria.images || [],
            menu: cafeteria.menu || []
        });
    };

    const handleDelete = async (id) => {
        if (!window.confirm('Are you sure you want to delete this cafeteria?')) return;
        try {
            await api.delete(`/admin/cafeteria/${id}`);
            setCafeterias(prev => prev.filter(c => c._id !== id));
        } catch (err) {
            console.error('Error deleting cafeteria:', err);
            alert('Failed to delete cafeteria');
        }
    };

    const handleSubmit = async (e) => {
        e.preventDefault();
        try {
            // Filter out empty strings from arrays
            const cleanFormData = {
                ...formData,
                images: formData.images.filter(url => url && url.trim() !== ''),
                menu: formData.menu.filter(url => url && url.trim() !== '')
            };

            if (editing === 'new') {
                const { data } = await api.post('/admin/cafeteria', cleanFormData);
                setCafeterias(prev => [...prev, data]);
            } else {
                const { data } = await api.put(`/admin/cafeteria/${editing._id}`, cleanFormData);
                setCafeterias(prev => prev.map(c => c._id === editing._id ? data : c));
            }
            setEditing(null);
        } catch (err) {
            console.error('Error saving cafeteria:', err);
            alert('Failed to save cafeteria');
        }
    };

    if (loading) return <div className="flex justify-center p-10"><Loader className="animate-spin" /></div>;

    return (
        <div>
            <div className="flex justify-between items-center mb-6">
                <h1 className="text-3xl font-bold text-gray-800">Cafeteria Manager</h1>
                {!editing && (
                    <button
                        onClick={() => {
                            setEditing('new');
                            setFormData({ name: '', location: '', time: '', contact: '', deliveryTime: '', images: [], menu: [] });
                        }}
                        className="flex items-center space-x-2 bg-blue-600 text-white px-4 py-2 rounded-lg hover:bg-blue-700 transition"
                    >
                        <Plus size={20} />
                        <span>Add Cafeteria</span>
                    </button>
                )}
            </div>

            {editing ? (
                <div className="bg-white rounded-xl shadow-md p-6">
                    <div className="flex justify-between items-center mb-6">
                        <h2 className="text-xl font-bold text-gray-700">
                            {editing === 'new' ? 'Add New Cafeteria' : 'Edit Cafeteria'}
                        </h2>
                        <button onClick={() => setEditing(null)} className="text-gray-500 hover:text-gray-700">
                            <X size={24} />
                        </button>
                    </div>

                    <form onSubmit={handleSubmit} className="grid grid-cols-1 md:grid-cols-2 gap-6">
                        <div>
                            <label className="block text-sm font-medium text-gray-700 mb-1">Name</label>
                            <input
                                type="text"
                                required
                                className="w-full p-2 border rounded-lg focus:ring-blue-600 focus:border-blue-600"
                                value={formData.name}
                                onChange={e => setFormData({ ...formData, name: e.target.value })}
                            />
                        </div>
                        <div>
                            <label className="block text-sm font-medium text-gray-700 mb-1">Location</label>
                            <input
                                type="text"
                                className="w-full p-2 border rounded-lg focus:ring-blue-600 focus:border-blue-600"
                                value={formData.location}
                                onChange={e => setFormData({ ...formData, location: e.target.value })}
                            />
                        </div>
                        <div>
                            <label className="block text-sm font-medium text-gray-700 mb-1">Timings</label>
                            <input
                                type="text"
                                className="w-full p-2 border rounded-lg focus:ring-blue-600 focus:border-blue-600"
                                value={formData.time}
                                onChange={e => setFormData({ ...formData, time: e.target.value })}
                            />
                        </div>
                        <div>
                            <label className="block text-sm font-medium text-gray-700 mb-1">Delivery Time</label>
                            <input
                                type="text"
                                className="w-full p-2 border rounded-lg focus:ring-blue-600 focus:border-blue-600"
                                value={formData.deliveryTime}
                                onChange={e => setFormData({ ...formData, deliveryTime: e.target.value })}
                            />
                        </div>
                        <div>
                            <label className="block text-sm font-medium text-gray-700 mb-1">Contact</label>
                            <input
                                type="text"
                                className="w-full p-2 border rounded-lg focus:ring-blue-600 focus:border-blue-600"
                                value={formData.contact}
                                onChange={e => setFormData({ ...formData, contact: e.target.value })}
                            />
                        </div>

                        <div className="col-span-2">
                            <label className="block text-sm font-medium text-gray-700 mb-2">Cafeteria Images</label>
                            <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
                                {formData.images.map((img, index) => (
                                    <div key={index} className="relative group">
                                        <ImageUpload
                                            value={img}
                                            onChange={(url) => {
                                                const newImages = [...formData.images];
                                                if (url) newImages[index] = url;
                                                else newImages.splice(index, 1);
                                                setFormData({ ...formData, images: newImages });
                                            }}
                                            placeholder={`Image ${index + 1}`}
                                        />
                                    </div>
                                ))}
                                <div className="flex items-center justify-center">
                                    <button
                                        type="button"
                                        onClick={() => setFormData({ ...formData, images: [...formData.images, ''] })}
                                        className="flex flex-col items-center justify-center w-full h-32 border-2 border-dashed border-gray-300 rounded-lg hover:bg-gray-50 text-gray-500 transition-colors"
                                    >
                                        <Plus size={24} />
                                        <span className="text-xs mt-1">Add Image</span>
                                    </button>
                                </div>
                            </div>
                        </div>

                        <div className="col-span-2">
                            <label className="block text-sm font-medium text-gray-700 mb-2">Menu Images</label>
                            <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
                                {formData.menu.map((img, index) => (
                                    <div key={index} className="relative group">
                                        <ImageUpload
                                            value={img}
                                            onChange={(url) => {
                                                const newMenu = [...formData.menu];
                                                if (url) newMenu[index] = url;
                                                else newMenu.splice(index, 1);
                                                setFormData({ ...formData, menu: newMenu });
                                            }}
                                            placeholder={`Page ${index + 1}`}
                                        />
                                    </div>
                                ))}
                                <div className="flex items-center justify-center">
                                    <button
                                        type="button"
                                        onClick={() => setFormData({ ...formData, menu: [...formData.menu, ''] })}
                                        className="flex flex-col items-center justify-center w-full h-32 border-2 border-dashed border-gray-300 rounded-lg hover:bg-gray-50 text-gray-500 transition-colors"
                                    >
                                        <Plus size={24} />
                                        <span className="text-xs mt-1">Add Menu Page</span>
                                    </button>
                                </div>
                            </div>
                        </div>

                        <div className="col-span-2 flex justify-end space-x-3 mt-4">
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
                                <span>Save Cafeteria</span>
                            </button>
                        </div>
                    </form>
                </div>
            ) : (
                <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                    {cafeterias.map(cafeteria => (
                        <div key={cafeteria._id} className="bg-white rounded-xl shadow-md overflow-hidden">
                            <div className="h-48 bg-gray-200 relative">
                                {cafeteria.images?.[0] ? (
                                    <img src={cafeteria.images[0]} alt={cafeteria.name} className="w-full h-full object-cover" />
                                ) : (
                                    <div className="flex items-center justify-center h-full text-gray-400">No Image</div>
                                )}
                                <div className="absolute top-2 right-2 flex space-x-2">
                                    <button onClick={() => handleEdit(cafeteria)} className="p-2 bg-white rounded-full shadow hover:bg-gray-100 text-blue-600">
                                        <Edit size={16} />
                                    </button>
                                    <button onClick={() => handleDelete(cafeteria._id)} className="p-2 bg-white rounded-full shadow hover:bg-gray-100 text-red-600">
                                        <Trash size={16} />
                                    </button>
                                </div>
                            </div>
                            <div className="p-4">
                                <h3 className="text-lg font-bold text-gray-800 mb-1">{cafeteria.name}</h3>
                                <p className="text-sm text-gray-500 mb-2">{cafeteria.location}</p>
                                <div className="text-xs text-gray-600 space-y-1">
                                    <p><span className="font-semibold">Open:</span> {cafeteria.time || 'N/A'}</p>
                                    <p><span className="font-semibold">Delivery:</span> {cafeteria.deliveryTime || 'N/A'}</p>
                                </div>
                            </div>
                        </div>
                    ))}
                    {cafeterias.length === 0 && (
                        <div className="col-span-full text-center py-10 text-gray-400">No cafeterias found. Add one to get started.</div>
                    )}
                </div>
            )}
        </div>
    );
}
