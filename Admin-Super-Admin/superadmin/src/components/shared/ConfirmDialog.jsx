
import React, { useState } from 'react';
import { createPortal } from 'react-dom';
import { AlertTriangle, X } from 'lucide-react';

const ConfirmDialog = ({ 
  isOpen, 
  onClose, 
  onConfirm, 
  title, 
  message, 
  confirmText = 'Confirm', 
  cancelText = 'Cancel',
  type = 'danger', // danger, warning, primary
  requireReason = false,
  reasonPlaceholder = 'Enter reason...'
}) => {
  const [reason, setReason] = useState('');

  if (!isOpen) return null;

  const handleConfirm = () => {
    if (requireReason && !reason.trim()) return;
    onConfirm(requireReason ? reason : null);
    setReason('');
    onClose();
  };

  const getColors = () => {
    switch (type) {
      case 'danger': return { btn: 'bg-red-600 hover:bg-red-700 shadow-red-200', icon: 'text-red-600 bg-red-100' };
      case 'warning': return { btn: 'bg-amber-600 hover:bg-amber-700 shadow-amber-200', icon: 'text-amber-600 bg-amber-100' };
      default: return { btn: 'bg-primary-600 hover:bg-primary-700 shadow-primary-200', icon: 'text-primary-600 bg-primary-100' };
    }
  };

  const colors = getColors();

  return createPortal(
    <div className="fixed inset-0 z-[10000] flex items-center justify-center p-4">
      <div className="absolute inset-0 bg-gray-900/60 backdrop-blur-md animate-fade-in" onClick={onClose} />
      <div className="relative bg-white rounded-[2rem] shadow-2xl w-full max-w-md overflow-hidden animate-fade-in-scale">
        <div className="p-8">
          <div className="flex items-start gap-4">
            <div className={`p-4 rounded-2xl flex-shrink-0 ${colors.icon}`}>
              <AlertTriangle size={28} />
            </div>
            <div className="flex-1">
              <h3 className="text-xl font-black text-gray-900 tracking-tight">{title}</h3>
              <p className="text-sm text-gray-500 mt-2 leading-relaxed">{message}</p>
              
              {requireReason && (
                <div className="mt-6">
                  <label className="text-[10px] font-black text-gray-400 uppercase tracking-[0.2em]">Reason for {title.toLowerCase()}</label>
                  <textarea
                    className="w-full mt-2 p-4 text-sm bg-gray-50 border border-gray-100 rounded-2xl focus:outline-none focus:ring-4 focus:ring-primary-500/10 focus:border-primary-400 transition-all font-medium"
                    rows="3"
                    placeholder={reasonPlaceholder}
                    value={reason}
                    onChange={(e) => setReason(e.target.value)}
                    autoFocus
                  />
                  {!reason.trim() && (
                    <p className="text-[10px] text-red-500 mt-2 font-bold px-1">Reason is mandatory to proceed</p>
                  )}
                </div>
              )}
            </div>
          </div>
        </div>
        
        <div className="bg-gray-50/50 px-8 py-6 flex items-center justify-end gap-3">
          <button
            onClick={onClose}
            className="px-6 py-3 text-xs font-black text-gray-500 hover:bg-gray-100 rounded-xl transition-all uppercase tracking-widest"
          >
            {cancelText}
          </button>
          <button
            onClick={handleConfirm}
            disabled={requireReason && !reason.trim()}
            className={`px-6 py-3 text-xs font-black text-white rounded-xl shadow-lg transition-all disabled:opacity-50 disabled:cursor-not-allowed active:scale-95 uppercase tracking-widest ${colors.btn}`}
          >
            {confirmText}
          </button>
        </div>
        
        <button 
          onClick={onClose}
          className="absolute top-6 right-6 p-2 rounded-xl text-gray-400 hover:bg-gray-100 transition-all active:scale-90"
        >
          <X size={18} />
        </button>
      </div>
    </div>,
    document.body
  );
};

export default ConfirmDialog;
