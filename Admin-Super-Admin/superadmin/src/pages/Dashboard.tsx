import React from 'react';
import { Navigate } from 'react-router-dom';
import { hasModuleAccess } from '../lib/auth';

/**
 * Minimal placeholder Dashboard component.
 * Restores the "/dashboard" route after the original implementation was commented out.
 * Shows a clean, premium UI using glassmorphism and responsive layout.
 */
function Dashboard() {
  // Permission guard – redirect if the user lacks access.
  if (!hasModuleAccess('dashboard')) {
    return <Navigate to="/" replace />;
  }

  return (
    <div className="min-h-screen bg-gray-50 p-6">
      <div className="max-w-5xl mx-auto">
        <h1 className="text-3xl font-bold text-gray-900 mb-4">Super Admin Dashboard</h1>
        <p className="text-gray-600 mb-8">
          The full dashboard is under construction. This placeholder confirms the route is active and respects permission
          access.
        </p>
        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6">
          {/* Example KPI cards with glassmorphism */}
          {[1, 2, 3].map((i) => (
            <div
              key={i}
              className="glass-card p-5 rounded-xl shadow-sm bg-white/80 backdrop-blur-sm animate-fade-in"
            >
              <h2 className="text-lg font-semibold text-gray-800 mb-2">KPI #{i}</h2>
              <p className="text-2xl font-bold text-primary-600">—</p>
            </div>
          ))}
        </div>
      </div>
    </div>
  );
}

export default Dashboard;