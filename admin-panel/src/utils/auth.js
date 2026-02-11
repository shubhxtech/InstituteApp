export const isAuthenticated = () => {
    return !!localStorage.getItem('adminToken');
};

export const logout = () => {
    localStorage.removeItem('adminToken');
    window.location.href = '/login';
};
