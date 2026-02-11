import { useState, useEffect } from 'react';
import api from '../utils/api';
import { Save, Copy, Loader } from 'lucide-react';

const DAYS = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
const MEAL_TYPES = ['breakfast', 'lunch', 'snacks', 'dinner'];

export default function MessMenu() {
    const [activeDay, setActiveDay] = useState('Monday');
    const [menuData, setMenuData] = useState({});
    const [loading, setLoading] = useState(true);
    const [saving, setSaving] = useState(false);
    const [jsonInput, setJsonInput] = useState('');
    const [parsedData, setParsedData] = useState(null);
    const [error, setError] = useState(null);

    useEffect(() => {
        fetchMenus();
    }, []);

    useEffect(() => {
        if (menuData[activeDay]) {
            const currentMeals = menuData[activeDay].meals || { breakfast: [], lunch: [], snacks: [], dinner: [] };
            setParsedData(currentMeals);
            setJsonInput(JSON.stringify(currentMeals, null, 2));
        } else {
            const defaultMeals = { breakfast: [], lunch: [], snacks: [], dinner: [] };
            setParsedData(defaultMeals);
            setJsonInput(JSON.stringify(defaultMeals, null, 2));
        }
    }, [activeDay, menuData]);

    const fetchMenus = async () => {
        try {
            setLoading(true);
            const { data } = await api.get('/admin/mess-menu');
            const formattedData = {};
            data.forEach(item => {
                formattedData[item.day] = item;
            });
            setMenuData(formattedData);
        } catch (err) {
            console.error('Error fetching menus:', err);
            setError('Failed to load menu data');
        } finally {
            setLoading(false);
        }
    };

    const handleJsonChange = (e) => {
        const value = e.target.value;
        setJsonInput(value);
        try {
            setParsedData(JSON.parse(value));
            setError(null);
        } catch (err) {
            // Don't set parsed data if invalid JSON
        }
    };

    const saveMenu = async () => {
        try {
            // Validate JSON first
            let mealsToSave;
            try {
                mealsToSave = JSON.parse(jsonInput);
            } catch (err) {
                setError('Invalid JSON format');
                return;
            }

            setSaving(true);
            const { data } = await api.put(`/admin/mess-menu/${activeDay}`, { meals: mealsToSave });

            setMenuData(prev => ({
                ...prev,
                [activeDay]: data
            }));

            alert('Menu updated successfully!');
        } catch (err) {
            console.error('Error saving menu:', err);
            setError('Failed to save menu');
        } finally {
            setSaving(false);
        }
    };

    if (loading) return <div className="flex justify-center p-10"><Loader className="animate-spin" /></div>;

    return (
        <div>
            <h1 className="text-3xl font-bold text-gray-800 mb-6">Mess Menu Manager</h1>

            <div className="bg-white rounded-xl shadow-md overflow-hidden">
                {/* Day Tabs */}
                <div className="flex overflow-x-auto border-b">
                    {DAYS.map(day => (
                        <button
                            key={day}
                            onClick={() => setActiveDay(day)}
                            className={`px-6 py-4 font-medium whitespace-nowrap transition-colors ${activeDay === day
                                ? 'bg-blue-50 text-blue-600 border-b-2 border-blue-600'
                                : 'text-gray-600 hover:bg-gray-50'
                                }`}
                        >
                            {day}
                        </button>
                    ))}
                </div>

                <div className="p-6">
                    <div className="grid grid-cols-1 lg:grid-cols-2 gap-8">
                        {/* JSON Editor */}
                        <div>
                            <div className="flex justify-between items-center mb-4">
                                <h2 className="text-lg font-bold text-gray-700">JSON Editor</h2>
                                {error && <span className="text-red-500 text-sm font-medium">{error}</span>}
                            </div>
                            <textarea
                                value={jsonInput}
                                onChange={handleJsonChange}
                                className="w-full h-[500px] font-mono text-sm p-4 border rounded-lg bg-gray-50 focus:outline-none focus:border-blue-600 focus:ring-1 focus:ring-blue-600"
                                spellCheck="false"
                            />
                            <div className="mt-4 flex justify-end">
                                <button
                                    onClick={saveMenu}
                                    disabled={saving}
                                    className="flex items-center space-x-2 bg-blue-600 text-white px-6 py-2 rounded-lg hover:bg-blue-600 disabled:opacity-50 transition"
                                >
                                    {saving ? <Loader className="animate-spin h-5 w-5" /> : <Save className="h-5 w-5" />}
                                    <span>Save Changes</span>
                                </button>
                            </div>
                        </div>

                        {/* Visual Preview */}
                        <div>
                            <h2 className="text-lg font-bold text-gray-700 mb-4">Preview</h2>
                            <div className="bg-gray-50 rounded-lg p-6 h-[500px] overflow-y-auto border">
                                {parsedData ? (
                                    <div className="space-y-6">
                                        {MEAL_TYPES.map(type => (
                                            <div key={type} className="bg-white p-4 rounded-lg shadow-sm">
                                                <h3 className="uppercase text-xs font-bold text-gray-400 mb-3 tracking-wider">{type}</h3>
                                                {parsedData[type] && parsedData[type].length > 0 ? (
                                                    <ul className="space-y-2">
                                                        {parsedData[type].map((item, idx) => (
                                                            <li key={idx} className="flex items-start space-x-2 text-sm text-gray-700">
                                                                <span className="h-1.5 w-1.5 rounded-full bg-blue-600 mt-1.5 flex-shrink-0"></span>
                                                                <span>{item}</span>
                                                            </li>
                                                        ))}
                                                    </ul>
                                                ) : (
                                                    <p className="text-gray-400 text-sm italic">No items added</p>
                                                )}
                                            </div>
                                        ))}
                                    </div>
                                ) : (
                                    <div className="flex items-center justify-center h-full text-gray-400">
                                        Invalid JSON data
                                    </div>
                                )}
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    );
}
