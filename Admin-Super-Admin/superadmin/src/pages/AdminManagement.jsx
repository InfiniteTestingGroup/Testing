import React, { useEffect, useMemo, useState } from 'react';
import { Eye, CheckCircle2, XCircle, AlertCircle, RefreshCw, FileText, Phone, Mail, Building2, Calendar, Trash2, UserPlus, Map } from 'lucide-react';
import PageHeader from '../components/shared/PageHeader';
import DataTable from '../components/shared/DataTable';
import StatusBadge from '../components/shared/StatusBadge';
import DetailDrawer from '../components/shared/DetailDrawer';
import ConfirmDialog from '../components/shared/ConfirmDialog';
import FilterBar from '../components/shared/FilterBar';
import CreateAdminModal from '../components/admin/CreateAdminModal';
import AdminDetailsModal from '../components/admin/AdminDetailsModal';
import { AdminMapView } from '../components/admin/AdminMapView';
import {
  fetchAdminDetail,
  fetchAdminNotifications,
  fetchAdmins,
  runAdminAction,
  deleteAdmin,
} from '../lib/management';

const AdminManagement = () => {
  const [admins, setAdmins] = useState([]);
  const [allAdmins, setAllAdmins] = useState([]);
  const [isLoading, setIsLoading] = useState(true);
  const [selectedAdmin, setSelectedAdmin] = useState(null);
  const [isDrawerOpen, setIsDrawerOpen] = useState(false);
  const [confirmDialog, setConfirmDialog] = useState({ isOpen: false, type: '', admin: null });
  const [activeFilters, setActiveFilters] = useState({
    status: null,
    sort: null,
    search: '',
    company: '',
    location: '',
    fromDate: '',
    toDate: ''
  });
  const [emailNotifications, setEmailNotifications] = useState([]);
  const [isCreateModalOpen, setIsCreateModalOpen] = useState(false);
  const [isMapOpen, setIsMapOpen] = useState(false);

  useEffect(() => {
    const loadInitialData = async () => {
      setIsLoading(true);
      try {
        const [adminsData, allAdminsData, notifications] = await Promise.all([
          fetchAdmins({ status: activeFilters.status || undefined }),
          fetchAdmins(), // Unfiltered for the map
          fetchAdminNotifications(),
        ]);
        console.table(adminsData);
        setAdmins(adminsData);
        setAllAdmins(allAdminsData);
        setEmailNotifications(notifications);
      } finally {
        setIsLoading(false);
      }
    };

    loadInitialData();
  }, [activeFilters.status]);

  const handleAction = (type, admin) => {
    setConfirmDialog({ isOpen: true, type, admin });
  };

  const refreshListAndDetail = async (adminId) => {
    const [adminsData, allAdminsData] = await Promise.all([
      fetchAdmins({ status: activeFilters.status || undefined }),
      fetchAdmins()
    ]);
    setAdmins(adminsData);
    setAllAdmins(allAdminsData);

    if (adminId && isDrawerOpen) {
      try {
        const detail = await fetchAdminDetail(adminId);
        setSelectedAdmin(detail);
      } catch {
        // Keep current drawer state if detail fetch fails.
      }
    }

    const notifications = await fetchAdminNotifications();
    setEmailNotifications(notifications);
  };

  const executeAction = async (reason) => {
    const { type, admin } = confirmDialog;
    if (!admin) return;

    const actionMap = {
      Approve: 'approve',
      Reject: 'reject',
      Suspend: 'suspend',
      Reinstate: 'reinstate',
    };

    await runAdminAction(admin.id, actionMap[type], reason);
    await refreshListAndDetail(admin.id);
    setConfirmDialog({ isOpen: false, type: '', admin: null });
  };

  const handleDeleteAdmin = async (admin) => {
    if (window.confirm(`Are you sure you want to PERMANENTLY delete the account and registration for ${admin.email}? This cannot be undone.`)) {
      setIsLoading(true);
      try {
        await deleteAdmin(admin.id);
        await refreshListAndDetail();
        setIsDrawerOpen(false);
      } finally {
        setIsLoading(false);
      }
    }
  };

  const handleOpenDetails = async (admin) => {
    setIsLoading(true);
    try {
      const detail = await fetchAdminDetail(admin.id);
      setSelectedAdmin(detail);
      setIsDrawerOpen(true);
    } catch (err) {
      console.error('Failed to fetch admin detail', err);
      // Fallback to summary admin if fetch fails
      setSelectedAdmin(admin);
      setIsDrawerOpen(true);
    } finally {
      setIsLoading(false);
    }
  };

  const columns = useMemo(() => ([
    { key: 'id', label: 'Admin ID', className: 'font-mono text-xs font-bold' },
    {
      key: 'name',
      label: 'Name',
      render: (val) => (
        <div className="flex items-center gap-3">
          <div className="w-8 h-8 rounded-full bg-primary-100 flex items-center justify-center text-primary-700 font-bold text-xs uppercase">
            {val.charAt(0)}
          </div>
          <span className="font-semibold text-gray-900">{val}</span>
        </div>
      ),
    },
    { key: 'email', label: 'Email' },
    { key: 'company', label: 'Company', render: (val) => <span className="font-medium text-gray-700">{val}</span> },
    { key: 'registeredDate', label: 'Registered', render: (val) => { const d = new Date(val); return isNaN(d.getTime()) ? val : d.toLocaleDateString('en-IN', { day: '2-digit', month: 'short', year: 'numeric' }); } },
    { key: 'status', label: 'Status', render: (val) => <StatusBadge status={val} /> },
    {
      key: 'actions',
      label: 'Actions',
      render: (_, row) => (
        <div className="flex items-center gap-1">
          <button
            onClick={(e) => { e.stopPropagation(); handleOpenDetails(row); }}
            className="p-2 text-gray-400 hover:text-primary-600 hover:bg-primary-50 rounded-lg transition-all"
            title="View Details"
          >
            <Eye size={18} />
          </button>

          {row.status === 'Pending' && (
            <>
              <button
                onClick={(e) => { e.stopPropagation(); handleAction('Approve', row); }}
                className="p-2 text-gray-400 hover:text-green-600 hover:bg-green-50 rounded-lg transition-all"
                title="Approve"
              >
                <CheckCircle2 size={18} />
              </button>
              <button
                onClick={(e) => { e.stopPropagation(); handleAction('Reject', row); }}
                className="p-2 text-gray-400 hover:text-red-600 hover:bg-red-50 rounded-lg transition-all"
                title="Reject"
              >
                <XCircle size={18} />
              </button>
            </>
          )}

          {row.status === 'Active' && (
            <button
              onClick={(e) => { e.stopPropagation(); handleAction('Suspend', row); }}
              className="p-2 text-gray-400 hover:text-orange-600 hover:bg-orange-50 rounded-lg transition-all"
              title="Suspend"
            >
              <AlertCircle size={18} />
            </button>
          )}

          {row.status === 'Suspended' && (
            <button
              onClick={(e) => { e.stopPropagation(); handleAction('Reinstate', row); }}
              className="p-2 text-gray-400 hover:text-green-600 hover:bg-green-50 rounded-lg transition-all"
              title="Reinstate"
            >
              <RefreshCw size={18} />
            </button>
          )}

          <button
            onClick={(e) => { e.stopPropagation(); handleDeleteAdmin(row); }}
            className="p-2 text-gray-400 hover:text-red-600 hover:bg-red-50 rounded-lg transition-all ml-1"
            title="Delete Admin"
          >
            <Trash2 size={18} />
          </button>
        </div>
      ),
    },
  ]), []);

  const handleFilterChange = (key, value) => {
    setActiveFilters((prev) => ({ ...prev, [key]: value }));
  };

  const resetFilters = () => {
    setActiveFilters({
      status: null,
      sort: null,
      search: '',
      company: '',
      location: '',
      fromDate: '',
      toDate: ''
    });
  };

  const sortedAdmins = useMemo(() => {
    let result = [...admins];

    // Search filter
    if (activeFilters.search) {
      const q = activeFilters.search.toLowerCase();
      result = result.filter(
        a =>
          (a.name && a.name.toLowerCase().includes(q)) ||
          (a.email && a.email.toLowerCase().includes(q)) ||
          (a.company && a.company.toLowerCase().includes(q))
      );
    }

    // Location filter – AdminRecord uses city/businessAddress/location (location field populated from businessAddress)
    if (activeFilters.location) {
      const q = activeFilters.location.trim().toLowerCase();

      result = result.filter(admin => {
        const city = admin.city?.toLowerCase() || '';
        const businessAddress = admin.businessAddress?.toLowerCase() || '';
        const location = admin.location?.toLowerCase() || '';
        // Also check registration sub-object fields if present
        const regCity = admin.registration?.city?.toLowerCase() || '';
        const regState = admin.registration?.state?.toLowerCase() || '';
        const regAddr = admin.registration?.businessAddress?.toLowerCase() || '';
        return (
          city.includes(q) ||
          businessAddress.includes(q) ||
          location.includes(q) ||
          regCity.includes(q) ||
          regState.includes(q) ||
          regAddr.includes(q)
        );
      });
    }

    // Company filter
    if (activeFilters.company) {
      result = result.filter(
        a => a.company && a.company.toLowerCase().includes(activeFilters.company.toLowerCase())
      );
    }

    // Status filter
    if (activeFilters.status) {
      result = result.filter(a => a.status === activeFilters.status);
    }

    // Date filters with validation
    const parseDate = dateStr => {
      if (!dateStr || dateStr === 'N/A' || dateStr === 'Unknown') return 0;
      let d = new Date(dateStr);
      if (!isNaN(d.getTime())) return d.getTime();

      // Handle Java's Date.toString() format with timezone like "Mon Jun 08 22:12:23 IST 2026"
      const parts = dateStr.split(' ');
      if (parts.length >= 6) {
        const cleanStr = `${parts[1]} ${parts[2]}, ${parts[5]} ${parts[3]}`;
        d = new Date(cleanStr);
        if (!isNaN(d.getTime())) return d.getTime();
      }
      return 0;
    };

    let fromMs = null;
    let toMs = null;
    if (activeFilters.fromDate) {
      fromMs = new Date(activeFilters.fromDate).getTime();
    }
    if (activeFilters.toDate) {
      toMs = new Date(activeFilters.toDate).getTime();
    }
    // Ensure correct ordering
    if (fromMs !== null && toMs !== null && fromMs > toMs) {
      // Swap to maintain logical range
      const tmp = fromMs;
      fromMs = toMs;
      toMs = tmp;
    }
    if (fromMs !== null) {
      result = result.filter(admin => parseDate(admin.registeredDate) >= fromMs);
    }
    if (toMs !== null) {
      result = result.filter(admin => parseDate(admin.registeredDate) <= toMs);
    }
    // Sorting
    result.sort((a, b) => {
      const timeA = parseDate(a.registeredDate);
      const timeB = parseDate(b.registeredDate);
      return activeFilters.sort === 'oldest' ? timeA - timeB : timeB - timeA;
    });

    return result;
  }, [admins, activeFilters]);

  const companyOptions = useMemo(() => {
    const unique = new Set();
    admins.forEach((a) => {
      if (a.company) unique.add(a.company);
    });
    return Array.from(unique).map((c) => ({ label: c, value: c }));
  }, [admins]);

  const filterOptions = [
    {
      key: 'search',
      label: 'Search Admins',
      type: 'search',
      placeholder: 'Search by name, email, or company',
      appliedValue: activeFilters.search,
    },
    {
      key: 'company',
      label: 'Company',
      type: 'select',
      options: companyOptions,
      appliedValue: activeFilters.company,
    },
    {
      key: 'location',
      label: 'Location',
      type: 'search',
      placeholder: 'Search by city, state or address',
      appliedValue: activeFilters.location,
    },
    {
      key: 'fromDate',
      label: 'From Date',
      type: 'date',
      placeholder: 'Select start date',
      appliedValue: activeFilters.fromDate,
    },
    {
      key: 'toDate',
      label: 'To Date',
      type: 'date',
      placeholder: 'Select end date',
      appliedValue: activeFilters.toDate,
    },
    {
      key: 'status',
      label: 'Status',
      type: 'select',
      options: [
        { label: 'Pending', value: 'Pending' },
        { label: 'Active', value: 'Active' },
        { label: 'Rejected', value: 'Rejected' },
        { label: 'Suspended', value: 'Suspended' },
      ],
      appliedValue: activeFilters.status,
    },
    {
      key: 'sort',
      label: 'Sort By',
      type: 'select',
      options: [
        { label: 'Latest to Oldest', value: 'latest' },
        { label: 'Oldest to Latest', value: 'oldest' },
      ],
      appliedValue: activeFilters.sort,
    },
  ];

  const adminPublishers = selectedAdmin?.publishers ?? [];
  const performance = selectedAdmin?.performance ?? { totalAds: 0, revenue: 0, avgCtr: 0 };
  const documents = selectedAdmin?.documents ?? [];
  const registration = selectedAdmin?.registration ?? null;

  return (
    <div className="pb-10 space-y-8">
      <div className="animate-fade-in-scale">
        <PageHeader
          title={
            <div className="flex items-center gap-4">
              <span>Admin Management</span>
            </div>
          }
          subtitle="System-wide governance of regional ecosystem administrators"
          actions={
            <div className="flex items-center gap-3">
              <div className="flex items-center gap-2">
                <div className="flex items-center gap-2.5 bg-white border border-gray-200 px-3 py-1.5 rounded-2xl shadow-sm">
                  <span className="text-sm font-black text-gray-900">{allAdmins.length} Admins</span>
                </div>
                <button
                  onClick={() => setIsMapOpen(true)}
                  className="px-5 py-2.5 bg-white hover:bg-gray-50 border border-gray-200 text-gray-700 rounded-xl text-xs font-bold shadow-sm active:scale-95 transition-all flex items-center gap-2"
                >
                  <Map size={16} />
                  Map View
                </button>
              </div>
              <button
                onClick={() => setIsCreateModalOpen(true)}
                className="px-5 py-2.5 bg-primary-500 hover:bg-primary-600 text-white rounded-xl text-xs font-bold shadow-lg shadow-primary-500/20 active:scale-95 transition-all flex items-center gap-2"
              >
                <UserPlus size={16} />
                Create Admin
              </button>
            </div>
          }
        />
      </div>

      <div className="card-floating p-0 animate-fade-in-scale delay-75">
        <FilterBar
          filters={filterOptions}
          onFilterChange={handleFilterChange}
          onReset={resetFilters}
          activeFiltersCount={Object.values(activeFilters).filter(Boolean).length}
        />
      </div>

      <div className="card-floating p-0 overflow-hidden animate-fade-in-scale delay-100">
        <DataTable
          columns={columns}
          data={sortedAdmins}
          isLoading={isLoading}
          onRowClick={handleOpenDetails}
          exportFileName="admins_list"
          className="hover-glow-border"
        />
      </div>

      <AdminMapView
        isOpen={isMapOpen}
        onClose={() => setIsMapOpen(false)}
        admins={allAdmins}
        onAdminClick={handleOpenDetails}
      />

      <div className="card-floating p-5 animate-fade-in-scale delay-150">
        <h3 className="text-sm font-bold text-gray-900 uppercase tracking-wider mb-3">Email Notifications</h3>
        {emailNotifications.length === 0 ? (
          <p className="text-sm text-gray-500">No approval/rejection emails triggered yet.</p>
        ) : (
          <div className="space-y-2">
            {emailNotifications.map((emailEvent) => (
              <div key={emailEvent.id} className="border border-gray-100 rounded-xl px-4 py-3 bg-white">
                <p className="text-xs font-bold text-gray-800">{emailEvent.trigger}</p>
                <p className="text-xs text-gray-500 mt-0.5">To: {emailEvent.to}</p>
                <p className="text-xs text-gray-500 mt-0.5">{emailEvent.content}</p>
              </div>
            ))}
          </div>
        )}
      </div>

      <AdminDetailsModal
        isOpen={isDrawerOpen}
        onClose={() => setIsDrawerOpen(false)}
        admin={selectedAdmin}
        onAction={handleAction}
      />

      {confirmDialog.isOpen && (
        <ConfirmDialog
          isOpen={confirmDialog.isOpen}
          onClose={() => setConfirmDialog({ isOpen: false, type: '', admin: null })}
          onConfirm={executeAction}
          title={`${confirmDialog.type} Admin`}
          message={`Are you sure you want to ${confirmDialog.type.toLowerCase()} ${confirmDialog.admin?.name}?`}
          confirmText={`${confirmDialog.type} Account`}
          type={confirmDialog.type === 'Reject' || confirmDialog.type === 'Suspend' ? 'danger' : 'primary'}
          requireReason={confirmDialog.type === 'Reject' || confirmDialog.type === 'Suspend'}
          reasonPlaceholder={confirmDialog.type === 'Suspend' ? "Explain why this admin is being suspended..." : "Explain why this application is being rejected..."}
        />
      )}

      {isCreateModalOpen && (
        <CreateAdminModal
          isOpen={isCreateModalOpen}
          onClose={() => setIsCreateModalOpen(false)}
          onSuccess={refreshListAndDetail}
        />
      )}
    </div>
  );
};

export default AdminManagement;
