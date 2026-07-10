import { useEffect, useState } from 'react';
import {
  Search,
  X,
  Clock,
  Filter,
  Shield,
  FileText,
  Wallet,
} from 'lucide-react';
import { fetchAuditLogs } from '../lib/management';
import type { AuditLogRecord } from '../lib/management';
import DataTable from '../components/shared/DataTable';

type ActionType = 'Approval' | 'Login' | 'Publisher Creation' | 'Ad Update' | 'Account Deletion';
type ActorRole = 'Super Admin' | 'Admin' | 'Publisher' | 'Sub-Super Admin';
type EntityType = 'Session' | 'Account' | 'Publisher' | 'Ad' | 'User';

const getActionBadge = (actionType: ActionType | string) => {
  if (actionType === 'Payment') {
    return (
      <span className="px-2.5 py-0.5 rounded-md text-[11px] font-semibold bg-emerald-50 text-emerald-700 border border-emerald-100 flex items-center w-max">
        <Wallet size={12} className="mr-1" /> Payment
      </span>
    );
  }
  if (actionType === 'Login') {
    return (
      <span className="px-2.5 py-0.5 rounded-md text-[11px] font-semibold bg-amber-50 text-amber-700 border border-amber-100 flex items-center w-max">
        <Clock size={12} className="mr-1" /> Login
      </span>
    );
  }
  // default badge
  return (
    <span className="px-2.5 py-0.5 rounded-md text-[11px] font-semibold bg-blue-50 text-blue-700 border border-blue-100 flex items-center w-max">
      <FileText size={12} className="mr-1" /> {actionType}
    </span>
  );
};

export default function AuditLogs() {
  const [logs, setLogs] = useState<AuditLogRecord[]>([]);
  const [isLoading, setIsLoading] = useState(true);
  const [search, setSearch] = useState('');
  const [actionType, setActionType] = useState<ActionType | ''>('');
  const [actorRole, setActorRole] = useState<ActorRole | ''>('');
  const [entityType, setEntityType] = useState<EntityType | ''>('');
  const [fromDate, setFromDate] = useState('');
  const [toDate, setToDate] = useState('');

  useEffect(() => {
    const load = async () => {
      setIsLoading(true);
      try {
        const data = await fetchAuditLogs({ search, actionType, actorRole, entityType, fromDate, toDate });
        setLogs(data);
      } catch (err) {
        console.error(err);
      } finally {
        setIsLoading(false);
      }
    };
    load();
  }, [search, actionType, actorRole, entityType, fromDate, toDate]);

  const clearFilters = () => {
    setSearch('');
    setActionType('');
    setActorRole('');
    setEntityType('');
    setFromDate('');
    setToDate('');
  };

  const activeFiltersCount = [search, actionType, actorRole, entityType, fromDate, toDate].filter(Boolean).length;

  const columns = [
    {
      key: 'timestamp',
      label: 'Timestamp',
      render: (val: string) => {
        const dateObj = new Date(val);
        return (
          <div className="whitespace-nowrap">
            <div className="text-sm font-semibold text-gray-900">
              {dateObj.toLocaleDateString('en-GB', { day: '2-digit', month: 'short', year: 'numeric' })}
            </div>
            <div className="text-xs text-gray-400 mt-0.5 flex items-center gap-1">
              <Clock size={10} />
              {dateObj.toLocaleTimeString('en-US', { hour: '2-digit', minute: '2-digit', second: '2-digit' })}
            </div>
          </div>
        )
      }
    },
    {
      key: 'actorName',
      label: 'Actor',
      render: (_: any, row: AuditLogRecord) => (
        <div className="whitespace-nowrap">
          <div className="text-sm font-bold text-gray-900">{row.actorName}</div>
          <div className="text-xs text-gray-500">{row.actorRole}</div>
        </div>
      )
    },
    {
      key: 'actionType',
      label: 'Action Type',
      render: (val: string) => getActionBadge(val)
    },
    {
      key: 'entityType',
      label: 'Entity',
      render: (_: any, row: AuditLogRecord) => (
        <div className="whitespace-nowrap">
          <div className="text-sm font-medium text-gray-700">{row.entityType}</div>
          <div className="text-xs text-gray-500">{row.entityId}</div>
        </div>
      )
    },
    {
      key: 'action',
      label: 'Action',
      render: (_: any, row: AuditLogRecord) => (
        <div>
          <div className="text-sm font-medium text-gray-700">{row.action}</div>
          <div className="text-xs text-gray-400 mt-1 uppercase tracking-wider font-semibold">{row.id}</div>
        </div>
      )
    },
    {
      key: 'ip',
      label: 'IP',
      render: (val: string) => (
        <div className="inline-flex items-center gap-1.5 px-2.5 py-1 rounded-md bg-gray-100 text-gray-600 text-xs font-medium font-mono">
          {val}
        </div>
      )
    }
  ];

  return (
    <div className="space-y-6 pb-6 max-w-[1400px] mx-auto">
      <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4 pt-1 relative z-30">
        <div>
          <h1 className="text-2xl font-bold text-gray-900 tracking-tight">Audit Logs</h1>
          <p className="text-sm text-gray-500 mt-0.5">Read-only audit trail of ads, payments, logins, and approvals.</p>
        </div>
      </div>

      <div className="glass-card p-4 space-y-4">
        <div className="grid grid-cols-1 md:grid-cols-2 xl:grid-cols-6 gap-3">
          <div className="relative xl:col-span-2">
            <Search size={16} className="absolute left-3 top-1/2 -translate-y-1/2 text-gray-400" />
            <input
              type="text"
              placeholder="Search actor, action, id, ip..."
              value={search}
              onChange={(e) => setSearch(e.target.value)}
              className="w-full pl-9 pr-4 py-2 text-sm bg-gray-50 border border-gray-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-primary-500/20 focus:border-primary-500 font-medium"
            />
          </div>

          <select value={actionType} onChange={(e) => setActionType(e.target.value as ActionType || '')} className="px-3 py-2 text-sm bg-gray-50 border border-gray-200 rounded-xl focus:outline-none font-medium text-gray-700">
            <option value="">All Action Types</option>
            <option value="Approval">Approval</option>
            <option value="Login">Login</option>
            <option value="Publisher Creation">Publisher Creation</option>
            <option value="Ad Update">Ad Update</option>
<option value="Account Deletion">Account Deletion</option>
          </select>

          <select value={actorRole} onChange={(e) => setActorRole(e.target.value as ActorRole | '')} className="px-3 py-2 text-sm bg-gray-50 border border-gray-200 rounded-xl focus:outline-none font-medium text-gray-700">
            <option value="">All Actors</option>
            <option value="Super Admin">Super Admin</option>
            <option value="Sub-Super Admin">Sub-Super Admin</option>
            <option value="Admin">Admin</option>
          </select>

          <select value={entityType} onChange={(e) => setEntityType(e.target.value as EntityType | '')} className="px-3 py-2 text-sm bg-gray-50 border border-gray-200 rounded-xl focus:outline-none font-medium text-gray-700">
            <option value="">All Entities</option>
            <option value="Session">Session</option>
            <option value="Account">Account</option>
            <option value="Publisher">Publisher</option>
            <option value="Ad">Ad</option>
<option value="User">User</option>
          </select>

          <div className="flex flex-col sm:flex-row gap-2 xl:col-span-2 items-center">
            <div className="flex flex-col">
              <label className="text-xs text-gray-500 mb-1">From Date</label>
              <input type="date" placeholder="From Date" value={fromDate} onChange={(e) => setFromDate(e.target.value)} className="w-full px-3 py-2 text-sm bg-gray-50 border border-gray-200 rounded-xl focus:outline-none font-medium text-gray-700" />
            </div>
            <div className="flex flex-col">
              <label className="text-xs text-gray-500 mb-1">To Date</label>
              <input type="date" placeholder="To Date" value={toDate} onChange={(e) => setToDate(e.target.value)} className="w-full px-3 py-2 text-sm bg-gray-50 border border-gray-200 rounded-xl focus:outline-none font-medium text-gray-700" />
            </div>
          </div>
        </div>

        <div className="flex items-center justify-between">
          <div className="inline-flex items-center gap-2 text-xs font-semibold text-gray-500">
            <Shield size={14} className="text-primary-500" />
            Immutable logs: entries cannot be edited or deleted.
          </div>
          {activeFiltersCount > 0 && (
            <button onClick={clearFilters} className="inline-flex items-center gap-1.5 px-3 py-1.5 rounded-lg bg-gray-100 text-xs font-bold text-gray-700 border border-gray-200 hover:bg-gray-200 transition-colors">
              <Filter size={12} /> Clear Filters <X size={12} />
            </button>
          )}
        </div>
      </div>

      <DataTable
        columns={columns}
        data={logs}
        isLoading={isLoading}
        onRowClick={() => { }}
        exportFileName="system_audit_logs"
      />
    </div>
  );
}
