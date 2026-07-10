import { BrowserRouter, Routes, Route, Navigate } from 'react-router-dom';
import { Toaster } from 'react-hot-toast';
import Login from './pages/Login';
// import Dashboard from './pages/Dashboard'; // Dashboard component removed; route redirects to Analytics
import Revenue from './pages/Revenue';
import Transactions from './pages/Transactions';
import AuditLogs from './pages/AuditLogs';
import Profile from './pages/Profile';
import AdminManagement from './pages/AdminManagement';
import PublisherMonitoring from './pages/PublisherMonitoring';
import AdvertisementMonitoring from './pages/AdvertisementMonitoring';
import Analytics from './pages/Analytics';
import Tickets from './pages/Tickets';
import SubAdmins from './pages/SubAdmins';
import SetupPassword from './pages/SetupPassword';
import UnlockAccount from './pages/UnlockAccount';
import ResetPassword from './pages/ResetPassword';
import InvoicePage from './pages/InvoicePage';
import DashboardLayout from './components/layout/DashboardLayout';
import ProtectedRoute from './components/auth/ProtectedRoute';
import PermissionRoute from './components/auth/PermissionRoute';
import { DashboardCacheProvider } from './context/DashboardCacheContext';

function App() {
  return (
    <DashboardCacheProvider>
      <BrowserRouter>
        <Toaster position="top-right" toastOptions={{ duration: 3000 }} />
        <Routes>
          <Route path="/" element={<Login />} />
          <Route path="/setup-password" element={<SetupPassword />} />
          <Route path="/unlock-account" element={<UnlockAccount />} />
          <Route path="/reset-password" element={<ResetPassword />} />
          <Route element={<ProtectedRoute />}> 
            <Route element={<DashboardLayout />}>
              <Route element={<PermissionRoute permission="dashboard" />}> 
            <Route path="/dashboard" element={<Analytics />} />
              </Route>
              <Route element={<PermissionRoute permission="analytics" />}> 
                <Route path="/analytics" element={<Analytics />} />
              </Route>
              <Route element={<PermissionRoute permission="admins" />}> 
                <Route path="/admins" element={<AdminManagement />} />
              </Route>
              <Route element={<PermissionRoute permission="publishers" />}> 
                <Route path="/publishers" element={<PublisherMonitoring />} />
              </Route>
              <Route element={<PermissionRoute permission="ads" />}> 
                <Route path="/ads" element={<AdvertisementMonitoring />} />
              </Route>
              <Route element={<PermissionRoute permission="revenue" />}> 
                <Route path="/revenue" element={<Revenue />} />
              </Route>
              <Route element={<PermissionRoute permission="transactions" />}> 
                <Route path="/transactions" element={<Transactions />} />
                <Route path="/invoice/:id" element={<InvoicePage />} />
              </Route>
              <Route element={<PermissionRoute permission="tickets" />}> 
                <Route path="/tickets" element={<Tickets />} />
              </Route>
              <Route element={<PermissionRoute permission="auditLogs" />}> 
                <Route path="/audit-logs" element={<AuditLogs />} />
              </Route>
              <Route element={<PermissionRoute permission="profile" />}> 
                <Route path="/profile" element={<Profile />} />
              </Route>
              <Route element={<PermissionRoute permission="subAdmins" />}> 
                <Route path="/sub-admins" element={<SubAdmins />} />
              </Route>
            </Route>
          </Route>
          <Route path="*" element={<Navigate to="/" replace />} />
        </Routes>
      </BrowserRouter>
    </DashboardCacheProvider>
  );
}

export default App;
