
import React from 'react';

const StatusBadge = ({ status }) => {
  const getStatusConfig = (status) => {
    // Ensure boolean status values are converted to string equivalents
    const normalizedStatus = typeof status === 'boolean' ? (status ? 'active' : 'inactive') : status;
    switch (normalizedStatus?.toLowerCase()) {
      case 'active':
        return { style: 'bg-emerald-50 text-emerald-700 border-emerald-100 glow-success', dot: 'bg-emerald-500' };
      case 'pending':
        return { style: 'bg-amber-50 text-amber-700 border-amber-100', dot: 'bg-amber-500' };
      case 'rejected':
        return { style: 'bg-rose-50 text-rose-700 border-rose-100', dot: 'bg-rose-500' };
      case 'suspended':
        return { style: 'bg-orange-50 text-orange-700 border-orange-100 glow-warning', dot: 'bg-orange-500' };
      case 'inactive':
        return { style: 'bg-slate-50 text-slate-600 border-slate-200', dot: 'bg-slate-400' };
      case 'expired':
        return { style: 'bg-indigo-50 text-indigo-700 border-indigo-100', dot: 'bg-indigo-500' };
      case 'draft':
        return { style: 'bg-slate-50 text-slate-500 border-slate-200', dot: 'bg-slate-300' };
      case 'completed':
        return { style: 'bg-blue-50 text-blue-700 border-blue-100', dot: 'bg-blue-500' };
      case 'paused':
        return { style: 'bg-purple-50 text-purple-700 border-purple-100', dot: 'bg-purple-500' };
      
      /* Ticket Statuses */
      case 'open':
        return { style: 'bg-blue-50 text-blue-700 border-blue-100 glow-info', dot: 'bg-blue-500' };
      case 'in progress':
        return { style: 'bg-indigo-50 text-indigo-700 border-indigo-100', dot: 'bg-indigo-500' };
      case 'resolved':
        return { style: 'bg-emerald-50 text-emerald-700 border-emerald-100 glow-success', dot: 'bg-emerald-500' };
      case 'closed':
        return { style: 'bg-slate-100 text-slate-500 border-slate-200', dot: 'bg-slate-400' };

      /* Priorities */
      case 'urgent':
        return { style: 'bg-rose-50 text-rose-700 border-rose-100 shadow-sm shadow-rose-100', dot: 'bg-rose-600 animate-pulse' };
      case 'high':
        return { style: 'bg-orange-50 text-orange-700 border-orange-100', dot: 'bg-orange-500' };
      case 'medium':
        return { style: 'bg-amber-50 text-amber-700 border-amber-100', dot: 'bg-amber-500' };
      case 'low':
        return { style: 'bg-emerald-50 text-emerald-600 border-emerald-100', dot: 'bg-emerald-500' };

      default:
        return { style: 'bg-slate-100 text-slate-700 border-slate-200', dot: 'bg-slate-400' };
    }
  };

  const config = getStatusConfig(status);

  const displayStatus = typeof status === 'boolean' ? (status ? 'Active' : 'Inactive') : (status ? status.charAt(0).toUpperCase() + status.slice(1).toLowerCase() : status);

  return (
    <span className={`inline-flex items-center gap-1.5 px-3 py-1 rounded-full text-[10px] font-black uppercase tracking-widest border transition-all duration-300 ${config.style}`}>
      <span className={`w-1.5 h-1.5 rounded-full ${config.dot} ${status?.toLowerCase() === 'active' ? 'animate-pulse' : ''}`} />
      {displayStatus}
    </span>
  );
};

export default StatusBadge;
