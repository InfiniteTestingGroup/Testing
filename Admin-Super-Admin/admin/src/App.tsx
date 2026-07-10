import * as React from "react";
import { BrowserRouter, Routes, Route, Navigate } from "react-router-dom";

import Register from "./pages/admin/Register";
import RegistrationStatus from "./pages/admin/RegistrationStatus";
import Login from "./pages/admin/Login";
import Dashboard from "./pages/admin/Dashboard";
import Publishers from "./pages/admin/Publishers";
import PublisherDetails from "./pages/admin/PublisherDetails";
import PublisherForm from "./pages/admin/PublisherForm";
import AdsList from "./pages/admin/AdsList";
import AdForm from "./pages/admin/AdForm";
import PublishAd from "./pages/admin/PublishAd";
import PaymentPage from "./pages/admin/PaymentPage";
import PaymentHistory from "./pages/admin/PaymentHistory";
import PublisherMapPage from "./pages/admin/PublisherMapPage";
import InvoicePage from "./pages/admin/InvoicePage";
import AdminLayout from "./components/layout/AdminLayout";
import TicketsList from "./pages/admin/TicketsList";
import CreateTicket from "./pages/admin/CreateTicket";
import TicketDetails from "./pages/admin/TicketDetails";
import Profile from "./pages/admin/Profile";
import Settings from "./pages/admin/Settings";
import AnalyticsDashboard from "./pages/admin/AnalyticsDashboard";


function App() {
  return (
    <BrowserRouter>
      <Routes>
        <Route path="/" element={<Navigate to="/admin/register" />} />
        <Route path="/admin/register" element={<Register />} />
        <Route path="/admin/status" element={<RegistrationStatus />} />
        <Route path="/admin/login" element={<Login />} />
        <Route element={<AdminLayout />}>
          <Route path="/admin/dashboard" element={<Dashboard />} />
          <Route path="/admin/tickets" element={<TicketsList />} />
          <Route path="/admin/tickets/new" element={<CreateTicket />} />
          <Route path="/admin/tickets/:id" element={<TicketDetails />} />
          <Route path="/admin/ads" element={<AdsList />} />
          <Route path="/admin/ads/new" element={<AdForm />} />
          <Route path="/admin/ads/:id/edit" element={<AdForm />} />
          <Route path="/admin/ads/:id/publish" element={<PublishAd />} />
          <Route path="/admin/ads/:id/pay" element={<PaymentPage />} />
          <Route path="/admin/payments" element={<PaymentHistory />} />
          <Route path="/admin/invoice/:id" element={<InvoicePage />} />
          <Route path="/admin/publishers" element={<Publishers />} />
          <Route path="/admin/publishers/:id" element={<PublisherDetails />} />
          <Route path="/admin/publishers/new" element={<PublisherForm />} />
          <Route path="/admin/publishers/:id/edit" element={<PublisherForm />} />
          <Route path="/admin/publishers/map" element={<PublisherMapPage />} />
          <Route path="/admin/profile" element={<Profile />} />
          <Route path="/admin/settings" element={<Settings />} />
          <Route path="/admin/analytics" element={<AnalyticsDashboard />} />
        </Route>
      </Routes>
    </BrowserRouter>
  );
}

export default App;