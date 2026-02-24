import { useState, useEffect } from 'react';
import api, { IMAGE_BASE_URL } from '../utils/api';
import { Plus, Trash, Loader, X, Image as ImageIcon, Rss, ChevronLeft, ChevronRight, Pencil } from 'lucide-react';

// ─── Multi-image uploader ────────────────────────────────────────────────────
function MultiImageUpload({ images, onChange }) {
    const [uploading, setUploading] = useState(false);
    const [error, setError] = useState(null);

    const handleFile = async (e) => {
        const files = Array.from(e.target.files);
        if (!files.length) return;
        setUploading(true);
        setError(null);
        try {
            const urls = await Promise.all(files.map(async (file) => {
                const fd = new FormData();
                fd.append('image', file);
                const { data } = await api.post('/upload', fd, {
                    headers: { 'Content-Type': 'multipart/form-data' }
                });
                return `${IMAGE_BASE_URL}${data.filePath}`;
            }));
            onChange([...images, ...urls]);
        } catch (err) {
            console.error('Upload error:', err);
            setError('Upload failed. Please try again.');
        } finally {
            setUploading(false);
            e.target.value = '';
        }
    };

    const remove = (idx) => onChange(images.filter((_, i) => i !== idx));

    return (
        <div>
            <div className="flex flex-wrap gap-3 mb-2">
                {images.map((url, idx) => (
                    <div key={idx} className="relative group w-24 h-24 rounded-lg overflow-hidden border border-gray-200 shadow-sm">
                        <img src={url} alt="" className="w-full h-full object-cover" onError={e => { e.target.src = 'https://via.placeholder.com/96?text=Error'; }} />
                        <button
                            type="button"
                            onClick={() => remove(idx)}
                            className="absolute top-1 right-1 bg-red-500 text-white rounded-full p-0.5 opacity-0 group-hover:opacity-100 transition-opacity"
                        >
                            <X size={12} />
                        </button>
                    </div>
                ))}
                <label className="w-24 h-24 flex flex-col items-center justify-center rounded-lg border-2 border-dashed border-gray-300 cursor-pointer hover:bg-gray-50 transition text-gray-500 text-xs gap-1">
                    <input type="file" multiple accept="image/*" className="hidden" onChange={handleFile} disabled={uploading} />
                    {uploading ? <Loader size={18} className="animate-spin text-blue-600" /> : <ImageIcon size={18} />}
                    <span>{uploading ? 'Uploading…' : 'Add Photo'}</span>
                </label>
            </div>
            {error && <p className="text-xs text-red-500 mt-1">{error}</p>}
        </div>
    );
}

// ─── Image carousel for feed card ────────────────────────────────────────────
function ImageCarousel({ images }) {
    const [idx, setIdx] = useState(0);
    if (!images?.length) return null;
    return (
        <div className="relative w-full h-44 rounded-lg overflow-hidden bg-gray-100 mb-3">
            <img src={images[idx]} alt="" className="w-full h-full object-cover" onError={e => { e.target.src = 'https://via.placeholder.com/400x176?text=Image'; }} />
            {images.length > 1 && (
                <>
                    <button onClick={() => setIdx(i => (i - 1 + images.length) % images.length)} className="absolute left-2 top-1/2 -translate-y-1/2 bg-black/40 text-white rounded-full p-1 hover:bg-black/60 transition">
                        <ChevronLeft size={14} />
                    </button>
                    <button onClick={() => setIdx(i => (i + 1) % images.length)} className="absolute right-2 top-1/2 -translate-y-1/2 bg-black/40 text-white rounded-full p-1 hover:bg-black/60 transition">
                        <ChevronRight size={14} />
                    </button>
                    <div className="absolute bottom-2 left-1/2 -translate-x-1/2 flex gap-1">
                        {images.map((_, i) => (
                            <button key={i} onClick={() => setIdx(i)} className={`w-1.5 h-1.5 rounded-full transition ${i === idx ? 'bg-white' : 'bg-white/50'}`} />
                        ))}
                    </div>
                    <span className="absolute top-2 right-2 text-xs bg-black/50 text-white px-1.5 py-0.5 rounded-full">
                        {idx + 1}/{images.length}
                    </span>
                </>
            )}
        </div>
    );
}

// ─── Feed Card ────────────────────────────────────────────────────────────────
function FeedCard({ post, onDelete, onEdit }) {
    const date = new Date(post.createdAt).toLocaleDateString('en-IN', {
        day: 'numeric', month: 'short', year: 'numeric'
    });
    const typeColors = {
        Feed: 'bg-blue-100 text-blue-700',
        announcement: 'bg-orange-100 text-orange-700',
        event: 'bg-purple-100 text-purple-700',
        achievement: 'bg-green-100 text-green-700',
        general: 'bg-gray-100 text-gray-600',
    };
    const colorClass = typeColors[post.type] || typeColors.general;

    return (
        <div className="bg-white rounded-xl shadow-sm border border-gray-100 p-4 flex flex-col">
            <ImageCarousel images={post.images} />

            <div className="flex items-start justify-between gap-2 mb-1">
                <h3 className="font-semibold text-gray-900 text-base leading-snug">{post.title}</h3>
                <div className="flex items-center gap-1 flex-shrink-0 mt-0.5">
                    <button
                        onClick={() => onEdit(post)}
                        className="text-gray-400 hover:text-blue-500 transition"
                        title="Edit post"
                    >
                        <Pencil size={15} />
                    </button>
                    <button
                        onClick={() => onDelete(post._id)}
                        className="text-gray-400 hover:text-red-500 transition"
                        title="Delete post"
                    >
                        <Trash size={15} />
                    </button>
                </div>
            </div>

            <p className="text-gray-500 text-sm leading-relaxed flex-1">{post.description}</p>

            {post.link && (
                <a
                    href={post.link}
                    target="_blank"
                    rel="noopener noreferrer"
                    className="inline-flex items-center gap-1 text-xs text-blue-600 hover:underline mt-2"
                >
                    🔗 View Link →
                </a>
            )}

            <div className="flex items-center gap-2 mt-3 pt-3 border-t border-gray-100 text-xs text-gray-400">
                <span className="font-medium text-gray-600">{post.host}</span>
                <span>·</span>
                <span>{date}</span>
                <span className={`ml-auto px-2 py-0.5 rounded-full text-xs font-medium ${colorClass}`}>{post.type}</span>
            </div>
        </div>
    );
}

// ─── Main Feeds Page ──────────────────────────────────────────────────────────
// These values must match the Flutter app's accepted feed types
const FEED_TYPES = [
    { value: 'Feed', label: 'General Feed' },
    { value: 'announcement', label: 'Announcement' },
    { value: 'event', label: 'Event' },
    { value: 'achievement', label: 'Achievement' },
];

export default function Feeds() {
    const [posts, setPosts] = useState([]);
    const [loading, setLoading] = useState(true);
    const [showForm, setShowForm] = useState(false);
    const [submitting, setSubmitting] = useState(false);
    const [editingPost, setEditingPost] = useState(null); // null = create mode, post object = edit mode

    const adminUser = JSON.parse(localStorage.getItem('adminUser') || '{}');

    const blankForm = { title: '', description: '', images: [], host: adminUser.name || 'Vertex Admin', type: 'Feed', emailId: adminUser.email || 'admin@iitmandi.ac.in', link: '' };
    const [form, setForm] = useState(blankForm);

    const openCreate = () => { setEditingPost(null); setForm(blankForm); setShowForm(true); };
    const openEdit = (post) => {
        setEditingPost(post);
        setForm({ title: post.title, description: post.description, images: post.images || [], host: post.host, type: post.type, emailId: post.emailId, link: post.link || '' });
        setShowForm(true);
    };
    const closeForm = () => { setShowForm(false); setEditingPost(null); setForm(blankForm); };

    useEffect(() => { fetchPosts(); }, []);

    const fetchPosts = async () => {
        try {
            setLoading(true);
            const { data } = await api.get('/posts');
            setPosts(data);
        } catch (err) {
            console.error('Error fetching posts:', err);
        } finally {
            setLoading(false);
        }
    };

    const handleSubmit = async (e) => {
        e.preventDefault();
        if (!form.title.trim() || !form.description.trim()) {
            alert('Title and description are required');
            return;
        }
        try {
            setSubmitting(true);
            if (editingPost) {
                // UPDATE
                const { data } = await api.put(`/posts/${editingPost._id}`, form);
                setPosts(prev => prev.map(p => p._id === editingPost._id ? data : p));
            } else {
                // CREATE
                const { data } = await api.post('/posts', form);
                setPosts(prev => [data, ...prev]);
            }
            closeForm();
        } catch (err) {
            console.error('Error saving post:', err);
            alert('Failed to save feed post');
        } finally {
            setSubmitting(false);
        }
    };

    const handleDelete = async (id) => {
        if (!window.confirm('Delete this feed post?')) return;
        try {
            await api.delete(`/posts/${id}`);
            setPosts(prev => prev.filter(p => p._id !== id));
        } catch (err) {
            console.error('Error deleting post:', err);
            alert('Failed to delete post');
        }
    };

    if (loading) return <div className="flex justify-center p-10"><Loader className="animate-spin text-gray-400" /></div>;

    return (
        <div>
            {/* Header */}
            <div className="flex justify-between items-center mb-6">
                <h1 className="text-3xl font-bold text-gray-800">Feeds</h1>
                {!showForm && (
                    <button
                        onClick={openCreate}
                        className="flex items-center space-x-2 bg-blue-600 text-white px-4 py-2 rounded-lg hover:bg-blue-700 transition"
                    >
                        <Plus size={20} />
                        <span>New Post</span>
                    </button>
                )}
            </div>

            {/* Create Form */}
            {showForm && (
                <div className="bg-white rounded-xl shadow-md p-6 mb-8 border border-blue-100">
                    <div className="flex justify-between items-center mb-4">
                        <h2 className="text-xl font-bold text-gray-700">{editingPost ? 'Edit Feed Post' : 'Create Feed Post'}</h2>
                        <button onClick={closeForm} className="text-gray-500 hover:text-gray-700">
                            <X size={24} />
                        </button>
                    </div>

                    <form onSubmit={handleSubmit} className="space-y-4">
                        <div>
                            <label className="block text-sm font-medium text-gray-700 mb-1">Title *</label>
                            <input
                                type="text"
                                required
                                value={form.title}
                                onChange={e => setForm({ ...form, title: e.target.value })}
                                placeholder="e.g. Annual Sports Day 2025"
                                className="w-full p-2 border rounded-lg focus:ring-blue-600 focus:border-blue-600"
                            />
                        </div>

                        <div>
                            <label className="block text-sm font-medium text-gray-700 mb-1">Description *</label>
                            <textarea
                                required
                                rows={4}
                                value={form.description}
                                onChange={e => setForm({ ...form, description: e.target.value })}
                                placeholder="Write your post content here…"
                                className="w-full p-2 border rounded-lg focus:ring-blue-600 focus:border-blue-600 resize-none"
                            />
                        </div>

                        <div>
                            <label className="block text-sm font-medium text-gray-700 mb-1">Photos (optional)</label>
                            <MultiImageUpload images={form.images} onChange={imgs => setForm({ ...form, images: imgs })} />
                        </div>

                        <div>
                            <label className="block text-sm font-medium text-gray-700 mb-1">Link (optional)</label>
                            <input
                                type="url"
                                value={form.link}
                                onChange={e => setForm({ ...form, link: e.target.value })}
                                placeholder="https://example.com"
                                className="w-full p-2 border rounded-lg focus:ring-blue-600 focus:border-blue-600"
                            />
                        </div>

                        <div className="grid grid-cols-2 gap-4">
                            <div>
                                <label className="block text-sm font-medium text-gray-700 mb-1">Posted by</label>
                                <input
                                    type="text"
                                    value={form.host}
                                    onChange={e => setForm({ ...form, host: e.target.value })}
                                    className="w-full p-2 border rounded-lg focus:ring-blue-600 focus:border-blue-600"
                                />
                            </div>
                            <div>
                                <label className="block text-sm font-medium text-gray-700 mb-1">Category</label>
                                <select
                                    value={form.type}
                                    onChange={e => setForm({ ...form, type: e.target.value })}
                                    className="w-full p-2 border rounded-lg focus:ring-blue-600 focus:border-blue-600"
                                >
                                    {FEED_TYPES.map(t => (
                                        <option key={t.value} value={t.value}>
                                            {t.label}
                                        </option>
                                    ))}
                                </select>
                            </div>
                        </div>

                        <div className="flex justify-end space-x-3 mt-4">
                            <button
                                type="button"
                                onClick={closeForm}
                                className="px-4 py-2 text-gray-700 bg-gray-100 rounded-lg hover:bg-gray-200"
                            >
                                Cancel
                            </button>
                            <button
                                type="submit"
                                disabled={submitting}
                                className="flex items-center space-x-2 bg-blue-600 text-white px-6 py-2 rounded-lg hover:bg-blue-700 disabled:opacity-50"
                            >
                                {submitting ? <Loader className="animate-spin" size={20} /> : (editingPost ? <Pencil size={20} /> : <Plus size={20} />)}
                                <span>{submitting ? 'Saving…' : (editingPost ? 'Save Changes' : 'Publish Post')}</span>
                            </button>
                        </div>
                    </form>
                </div>
            )}

            {/* Feed Grid */}
            {posts.length === 0 ? (
                <div className="text-center py-16 text-gray-400 bg-white rounded-lg border border-dashed">
                    <Rss size={36} className="mx-auto mb-2 opacity-40" />
                    <p>No feed posts yet. Click "New Post" to publish the first one.</p>
                </div>
            ) : (
                <div className="grid grid-cols-1 sm:grid-cols-2 xl:grid-cols-3 gap-4">
                    {posts.map(post => (
                        <FeedCard key={post._id} post={post} onDelete={handleDelete} onEdit={openEdit} />
                    ))}
                </div>
            )}
        </div>
    );
}
