import { useState } from 'react';
import api, { IMAGE_BASE_URL } from '../utils/api';
import { Upload, X, Loader } from 'lucide-react';

const ImageUpload = ({ value, onChange, placeholder = "Upload Image" }) => {
    const [uploading, setUploading] = useState(false);
    const [error, setError] = useState(null);

    const handleFileChange = async (e) => {
        const file = e.target.files[0];
        if (!file) return;

        const formData = new FormData();
        formData.append('image', file);

        try {
            setUploading(true);
            setError(null);

            // Upload endpoint
            const config = {
                headers: {
                    'Content-Type': 'multipart/form-data',
                }
            };

            const { data } = await api.post('/upload', formData, config);

            // Backend returns { filePath: "/uploads/filename.ext" }
            // We'll construct the full URL for display if needed, but saving the relative path or full URL depends on preference.
            // Let's save the full URL so standard <img> tags work everywhere easily without needing base URL context
            const fullUrl = `${IMAGE_BASE_URL}${data.filePath}`;

            onChange(fullUrl);
        } catch (err) {
            console.error('Upload error:', err);
            setError('Upload failed. Detailed error in console.');
        } finally {
            setUploading(false);
            // Reset input
            e.target.value = '';
        }
    };

    const handleRemove = () => {
        onChange('');
    };

    return (
        <div className="w-full">
            {value ? (
                <div className="relative inline-block border rounded-lg overflow-hidden group">
                    <img
                        src={value}
                        alt="Uploaded"
                        className="h-32 w-auto object-cover block"
                        onError={(e) => { e.target.src = 'https://via.placeholder.com/150?text=Error'; }}
                    />
                    <button
                        type="button"
                        onClick={handleRemove}
                        className="absolute top-1 right-1 bg-red-500 text-white p-1 rounded-full opacity-0 group-hover:opacity-100 transition-opacity"
                        title="Remove Image"
                    >
                        <X size={14} />
                    </button>
                </div>
            ) : (
                <div className="flex flex-col items-start">
                    <label className="cursor-pointer flex items-center justify-center space-x-2 bg-gray-50 border border-gray-300 border-dashed rounded-lg px-4 py-3 hover:bg-gray-100 transition w-full">
                        <input
                            type="file"
                            accept="image/*"
                            onChange={handleFileChange}
                            className="hidden"
                            disabled={uploading}
                        />
                        {uploading ? (
                            <Loader className="animate-spin text-primary" size={20} />
                        ) : (
                            <Upload className="text-gray-500" size={20} />
                        )}
                        <span className="text-sm text-gray-600 font-medium">
                            {uploading ? 'Uploading...' : placeholder}
                        </span>
                    </label>
                    {error && <p className="text-xs text-red-500 mt-1">{error}</p>}
                </div>
            )}
        </div>
    );
};

export default ImageUpload;
