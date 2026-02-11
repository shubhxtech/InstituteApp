import { BrowserRouter as Router, Routes, Route, Navigate } from 'react-router-dom';
import Login from './components/Auth/Login';
import Layout from './components/Layout/Layout';
import Dashboard from './pages/Dashboard';
import MessMenu from './pages/MessMenu';
import Cafeteria from './pages/Cafeteria';
import Carousel from './pages/Carousel';
import Calendar from './pages/Calendar';
import ContentModeration from './pages/ContentModeration';
import Notifications from './pages/Notifications';
import { isAuthenticated } from './utils/auth';

// Protected Route Wrapper
const ProtectedRoute = ({ children }) => {
  if (!isAuthenticated()) {
    return <Navigate to="/login" replace />;
  }
  return children;
};

function App() {
  return (
    <Router>
      <Routes>
        <Route path="/login" element={<Login />} />

        <Route path="/" element={
          <ProtectedRoute>
            <Layout />
          </ProtectedRoute>
        }>
          <Route index element={<Dashboard />} />
          <Route path="mess-menu" element={<MessMenu />} />
          <Route path="cafeteria" element={<Cafeteria />} />
          <Route path="carousel" element={<Carousel />} />
          <Route path="calendar" element={<Calendar />} />

          {/* Content Moderation Routes */}
          <Route path="buy-sell" element={<ContentModeration type="buy-sell" title="Buy & Sell" />} />
          <Route path="lost-found" element={<ContentModeration type="lost-found" title="Lost & Found" />} />
          <Route path="posts" element={<ContentModeration type="posts" title="Posts" />} />
          <Route path="notifications" element={<Notifications />} />
        </Route>
      </Routes>
    </Router>
  );
}

export default App;
