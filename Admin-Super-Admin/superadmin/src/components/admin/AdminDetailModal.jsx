import React from 'react';
import { createPortal } from 'react-dom';
import { X } from 'lucide-react';

/**
 * AdminDetailModal
 *
 * Displays a full-screen modal with detailed information about an admin.
 * The modal is rendered using a portal to the document body.
 * It receives the admin object, a boolean `isOpen` flag, and an `onClose`
 * callback to hide the modal.
 */
export default function AdminDetailModal({ admin, isOpen, onClose }) {
  if (!isOpen || !admin) return null;

  return createPortal(
    <div className="fixed inset-0 z-[10000] flex items-center justify-center p-4 md:p-6">
      {/* Backdrop */}
      <div className="absolute inset-0 bg-black/60 backdrop-blur-sm" onClick={onClose} />
      {/* Modal */}
      <div className="relative bg-white rounded-2xl shadow-2xl w-full max-w-3xl max-h-[90vh] overflow-auto p-6 border border-gray-200">
        {/* Close button */}
        <button
          className="absolute top-3 right-3 text-gray-400 hover:text-gray-600"
          onClick={onClose}
        >
          <X className="w-5 h-5" />
        </button>
        {/* Header */}
        <h2 className="text-2xl font-bold mb-4 text-gray-900">{admin.name || 'Admin Details'}</h2>
        {/* Content */}
        <div className="space-y-4 text-sm text-gray-700">
          {/* Render admin fields in a key: value list */}
          {Object.entries(admin).map(([key, value]) => (
            <div key={key} className="flex">
              <span className="w-32 font-medium text-gray-600 capitalize">{key}:</span>
              <span className="flex-1 break-all pl-2">{typeof value === 'object' ? JSON.stringify(value, null, 2) : String(value)}</span>
            </div>
          ))}
        </div>
      </div>
    </div>,
    document.body
  );
}
