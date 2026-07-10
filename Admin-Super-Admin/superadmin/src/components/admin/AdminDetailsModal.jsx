import React, { useState, useEffect } from 'react';
import { createPortal } from 'react-dom';
import { X, Mail, Phone, Building2, Calendar, FileText } from 'lucide-react';
import StatusBadge from '../shared/StatusBadge';


export default function AdminDetailsModal({ isOpen, onClose, admin, onAction }) {





  if (!isOpen || !admin) return null;



  const handleBackdropClick = (e) => {
    if (e.target === e.currentTarget) onClose();
  };

  const performance = admin.performance || { totalAds: 0, revenue: 0, avgCtr: 0 };
  const documents = admin.documents || [];
  const registration = admin.registration || null;
  const adminPublishers = admin.publishers || [];

  const renderStatusBadge = (status) => {
    const s = String(status).toLowerCase();

    if (s === 'pending') {
      return (
        <span className="inline-flex items-center gap-1.5 px-2.5 py-1 rounded-full bg-orange-50 text-orange-600 text-[10px] font-bold uppercase tracking-wider">
          <span className="w-1.5 h-1.5 rounded-full bg-orange-500"></span>
          Pending
        </span>
      );
    }

    if (s === 'active' || s === 'true') {
      return (
        <span className="inline-flex items-center gap-1.5 px-2.5 py-1 rounded-full bg-green-50 text-green-600 text-[10px] font-bold uppercase tracking-wider">
          <span className="w-1.5 h-1.5 rounded-full bg-green-500"></span>
          Active
        </span>
      );
    }

    if (s === 'inactive' || s === 'false') {
      return (
        <span className="inline-flex items-center gap-1.5 px-2.5 py-1 rounded-full bg-gray-50 text-gray-600 text-[10px] font-bold uppercase tracking-wider">
          <span className="w-1.5 h-1.5 rounded-full bg-gray-500"></span>
          Inactive
        </span>
      );
    }

    return <StatusBadge status={status} />;
  };


  return createPortal(
    <div
      className="fixed inset-0 z-[9999] flex items-center justify-center p-4 bg-black/50 backdrop-blur-sm animate-fade-in"
      onClick={handleBackdropClick}
    >
      <div
        className="bg-white rounded-[32px] shadow-2xl w-full max-w-4xl max-h-[90vh] flex flex-col overflow-hidden animate-fade-in-scale relative"
      >
        {/* Header */}
        <div className="flex items-center justify-between px-8 py-6 border-b border-gray-100 flex-shrink-0">
          <h2 className="text-2xl font-bold text-gray-900 tracking-tight">Admin Details</h2>
          <div className="flex items-center gap-3">
            {admin.status === 'Pending' && (
              <>
                <button
                  onClick={() => onAction('Approve', admin)}
                  className="px-5 py-2.5 bg-[#16a34a] hover:bg-[#15803d] text-white rounded-xl text-sm font-bold shadow-lg shadow-green-500/20 active:scale-95 transition-all"
                >
                  Approve
                </button>
                <button
                  onClick={() => onAction('Reject', admin)}
                  className="px-5 py-2.5 bg-[#dc2626] hover:bg-[#b91c1c] text-white rounded-xl text-sm font-bold shadow-lg shadow-red-500/20 active:scale-95 transition-all"
                >
                  Reject
                </button>
              </>
            )}
            {admin.status === 'Active' && (
              <button
                onClick={() => onAction('Suspend', admin)}
                className="px-5 py-2.5 bg-[#ea580c] hover:bg-[#c2410c] text-white rounded-xl text-sm font-bold shadow-lg shadow-orange-500/20 active:scale-95 transition-all"
              >
                Suspend
              </button>
            )}
            {admin.status === 'Suspended' && (
              <button
                onClick={() => onAction('Reinstate', admin)}
                className="px-5 py-2.5 bg-[#16a34a] hover:bg-[#15803d] text-white rounded-xl text-sm font-bold shadow-lg shadow-green-500/20 active:scale-95 transition-all"
              >
                Reinstate
              </button>
            )}
            <button
              onClick={onClose}
              className="w-10 h-10 flex items-center justify-center rounded-full bg-gray-100 text-gray-500 hover:bg-gray-200 hover:text-gray-700 transition-colors ml-2"
            >
              <X size={20} />
            </button>
          </div>
        </div>

        {/* Body */}
        <div className="flex-1 overflow-y-auto p-8 custom-scrollbar">

          {/* User Profile Summary */}
          <div className="flex items-center gap-5 mb-8">
            <div className="w-20 h-20 rounded-2xl bg-[#ea580c] flex items-center justify-center text-white text-3xl font-bold uppercase shadow-sm">
              {admin.name?.charAt(0) || '?'}
            </div>
            <div>
              <h3 className="text-2xl font-bold text-gray-900">{admin.name}</h3>
              <div className="flex items-center gap-3 mt-2">
                {renderStatusBadge(admin.status)}
                <span className="text-sm text-gray-400 font-mono">{admin.id}</span>
              </div>
            </div>
          </div>

          {/* Quick Info Grid */}
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4 mb-8">
            <div className="bg-white p-5 rounded-2xl border border-gray-100 shadow-[0_2px_10px_-4px_rgba(0,0,0,0.05)]">
              <div className="flex items-center gap-2 text-[#ea580c] mb-3">
                <Mail size={18} />
                <span className="text-[11px] font-bold uppercase tracking-widest text-gray-400">Email Address</span>
              </div>
              <p className="text-sm font-semibold text-gray-900 break-all">{admin.email || 'N/A'}</p>
            </div>
            <div className="bg-white p-5 rounded-2xl border border-gray-100 shadow-[0_2px_10px_-4px_rgba(0,0,0,0.05)]">
              <div className="flex items-center gap-2 text-[#ea580c] mb-3">
                <Phone size={18} />
                <span className="text-[11px] font-bold uppercase tracking-widest text-gray-400">Phone Number</span>
              </div>
              <p className="text-sm font-semibold text-gray-900">{admin.phone || 'N/A'}</p>
            </div>
            <div className="bg-white p-5 rounded-2xl border border-gray-100 shadow-[0_2px_10px_-4px_rgba(0,0,0,0.05)]">
              <div className="flex items-center gap-2 text-[#ea580c] mb-3">
                <Building2 size={18} />
                <span className="text-[11px] font-bold uppercase tracking-widest text-gray-400">Company</span>
              </div>
              <p className="text-sm font-semibold text-gray-900">{admin.company || 'N/A'}</p>
            </div>
            <div className="bg-white p-5 rounded-2xl border border-gray-100 shadow-[0_2px_10px_-4px_rgba(0,0,0,0.05)]">
              <div className="flex items-center gap-2 text-[#ea580c] mb-3">
                <Calendar size={18} />
                <span className="text-[11px] font-bold uppercase tracking-widest text-gray-400">Registered</span>
              </div>
              <p className="text-sm font-semibold text-gray-900">{admin.registeredDate || 'N/A'}</p>
            </div>
          </div>

          {/* Performance Summary */}
          <div className="mb-8">
            <h4 className="text-[13px] font-bold text-gray-900 uppercase tracking-wider mb-4">Performance Summary</h4>
            <div className="grid grid-cols-3 gap-4">
              <div className="bg-white p-5 rounded-2xl border border-gray-100 text-center shadow-[0_2px_10px_-4px_rgba(0,0,0,0.05)]">
                <p className="text-[11px] font-bold text-gray-400 uppercase tracking-widest mb-2">Total Ads</p>
                <p className="text-2xl font-black text-[#6366f1]">{performance.totalAds}</p>
              </div>
              <div className="bg-white p-5 rounded-2xl border border-gray-100 text-center shadow-[0_2px_10px_-4px_rgba(0,0,0,0.05)]">
                <p className="text-[11px] font-bold text-gray-400 uppercase tracking-widest mb-2">Revenue</p>
                <p className="text-2xl font-black text-[#16a34a]">INR {performance.revenue}</p>
              </div>
              <div className="bg-white p-5 rounded-2xl border border-gray-100 text-center shadow-[0_2px_10px_-4px_rgba(0,0,0,0.05)]">
                <p className="text-[11px] font-bold text-gray-400 uppercase tracking-widest mb-2">Avg CTR</p>
                <p className="text-2xl font-black text-[#ea580c]">{performance.avgCtr}%</p>
              </div>
            </div>
          </div>

          {/* Verification Documents */}
          {documents.length > 0 && (
            <div className="mb-8">
              <h4 className="text-[13px] font-bold text-gray-900 uppercase tracking-wider mb-4">Verification Documents</h4>
              <div className="space-y-3">
                {documents.map((doc, idx) => (
                  <div
                    key={idx}
                    className="flex items-center justify-between p-4 bg-white border border-gray-100 rounded-2xl shadow-[0_2px_10px_-4px_rgba(0,0,0,0.05)] hover:border-orange-200 transition-all cursor-pointer group"
                    onClick={() => doc.url && window.open(doc.url, '_blank')}
                  >
                    <div className="flex items-center gap-4">
                      <div className="p-3 bg-red-50 text-red-500 rounded-xl">
                        <FileText size={24} strokeWidth={1.5} />
                      </div>
                      <div>
                        <p className="text-sm font-semibold text-gray-900 group-hover:text-orange-600 transition-colors">{doc.name}</p>
                        <p className="text-[11px] text-gray-400 font-bold uppercase tracking-wider mt-0.5">{doc.type}</p>
                      </div>
                    </div>
                    <button className="text-sm font-bold text-[#ea580c] hover:underline px-2">
                      View
                    </button>
                  </div>
                ))}
              </div>
            </div>
          )}

          {/* Registration Details */}
          <div className="mb-8">
            <h4 className="text-[13px] font-bold text-gray-900 uppercase tracking-wider mb-4">Registration Details</h4>
            <div className="grid grid-cols-2 gap-4">
              {[
                ['Authorized Person', registration?.authorizedPerson || 'N/A'],
                ['Company Type', registration?.companyType || 'N/A'],
                ['Mobile', registration?.mobileNumber ? `${registration.countryCode || ''} ${registration.mobileNumber}`.trim() : 'N/A'],
                ['Address Line 1', registration?.businessAddress || 'N/A'],
                ['Country', registration?.country || 'N/A'],
                ['Submitted At', registration?.submittedAt || 'N/A'],
              ]
                .map(([label, value], idx) => (
                  <div key={idx} className="bg-white p-5 rounded-2xl border border-gray-100 shadow-[0_2px_10px_-4px_rgba(0,0,0,0.05)]">
                    <p className="text-[11px] font-bold text-gray-400 uppercase tracking-widest mb-2">{label}</p>
                    <p className="text-sm font-semibold text-gray-900 break-words">{String(value)}</p>
                  </div>
                ))}
            </div>
          </div>

          {/* Publishers Under Management */}
          <div className="mb-4">
            <h4 className="text-[13px] font-bold text-gray-900 uppercase tracking-wider mb-4">Publishers Under Management</h4>
            <div className="bg-white border border-gray-100 rounded-2xl overflow-hidden shadow-[0_2px_10px_-4px_rgba(0,0,0,0.05)]">
              <table className="w-full text-left">
                <thead className="bg-gray-50/50">
                  <tr>
                    <th className="px-5 py-4 text-[11px] font-bold text-gray-400 uppercase tracking-wider">Name</th>
                    <th className="px-5 py-4 text-[11px] font-bold text-gray-400 uppercase tracking-wider">Status</th>
                    <th className="px-5 py-4 text-[11px] font-bold text-gray-400 uppercase tracking-wider text-right">Ads</th>
                  </tr>
                </thead>
                <tbody className="divide-y divide-gray-100">
                  {adminPublishers.length > 0 ? (
                    adminPublishers.map((pub, idx) => (
                      <tr key={idx} className="text-sm">
                        <td className="px-5 py-4 font-semibold text-gray-900">
                          {pub.name}
                        </td>
                        <td className="px-5 py-4">
                          {renderStatusBadge(pub.status)}
                        </td>
                        <td className="px-5 py-4 text-right font-bold text-gray-700">
                          {pub.adsPosted || 0}
                        </td>
                      </tr>
                    ))
                  ) : (
                    <tr>
                      <td
                        colSpan="3"
                        className="px-5 py-10 text-center text-gray-400 text-sm"
                      >
                        No publishers linked yet
                      </td>
                    </tr>
                  )}
                </tbody>
              </table>
            </div>
          </div>

        </div>
      </div>
    </div>,
    document.body
  );
}
