import React, { useEffect, useMemo, useState } from 'react';
import { Eye, MapPin, User, Mail, Calendar, Info, BarChart2, Plus, Map as MapIcon } from 'lucide-react';
import PageHeader from '../components/shared/PageHeader';
import DataTable from '../components/shared/DataTable';
import StatusBadge from '../components/shared/StatusBadge';
import DetailDrawer from '../components/shared/DetailDrawer';
import FilterBar from '../components/shared/FilterBar';
import { fetchPublisherDetail, fetchPublishers, fetchAdmins } from '../lib/management';
import CreatePublisherModal from '../components/admin/CreatePublisherModal';
import { PublisherMapView } from '../components/admin/PublisherMapView';

const PublisherMonitoring = () => {
  const [publishers, setPublishers] = useState([]);
  const [allPublishers, setAllPublishers] = useState([]);
  const [isLoading, setIsLoading] = useState(true);
  const [selectedPublisher, setSelectedPublisher] = useState(null);
  const [isDrawerOpen, setIsDrawerOpen] = useState(false);
  const [activeFilters, setActiveFilters] = useState({
    status: null,
    sort: null,
    search: '',
    company: '',
    fromDate: '',
    toDate: ''
  });
  const [isCreateModalOpen, setIsCreateModalOpen] = useState(false);
  const [admins, setAdmins] = useState([]);
  const [isMapOpen, setIsMapOpen] = useState(false);

  useEffect(() => {
    const loadAdmins = async () => {
      try {
        const data = await fetchAdmins();
        setAdmins(data);
      } catch (err) {
        console.error("Failed to load admins:", err);
      }
    };
    loadAdmins();
  }, []);

  // Load all publishers without server‑side status filtering; client‑side filters handle status
  const loadPublishers = async () => {
    setIsLoading(true);
    try {
      const data = await fetchPublishers();
      console.log("Publisher Data", data);
      // Store the complete list for map view and filter derivation
      setAllPublishers(data);
      // Initially show all publishers; client‑side filters will narrow down
      setPublishers(data);
    } catch (err) {
      console.error('Failed to fetch publishers:', err);
      setAllPublishers([]);
      setPublishers([]);
    } finally {
      setIsLoading(false);
    }
  };

  // Load publishers on mount and when status filter changes (server‑side)
  // When status filter changes, reload all data (server returns full list) then client‑side filtering applies
  useEffect(() => {
    loadPublishers();
  }, [activeFilters.status]);

  // Apply client-side filters when allPublishers or activeFilters change
  useEffect(() => {
    const filtered = allPublishers.filter((publisher) => {
      const adminMatch = activeFilters.admin ? publisher.adminId === activeFilters.admin : true;
      // Normalize publisher status (handle boolean, numeric, and case variations)
      let normalizedPubStatus;
      if (typeof publisher.status === 'boolean') {
        normalizedPubStatus = publisher.status ? 'active' : 'inactive';
      } else if (typeof publisher.status === 'number') {
        // Common convention: 1 = Active, 0 = Inactive
        if (publisher.status === 1) normalizedPubStatus = 'active';
        else if (publisher.status === 0) normalizedPubStatus = 'inactive';
        else normalizedPubStatus = String(publisher.status).toLowerCase();
      } else if (typeof publisher.status === 'string') {
        const lower = publisher.status.toLowerCase();
        if (lower === 'true') normalizedPubStatus = 'active';
        else if (lower === 'false') normalizedPubStatus = 'inactive';
        else normalizedPubStatus = lower;
      } else {
        normalizedPubStatus = String(publisher.status).toLowerCase();
      }
      // Debug status filtering
      console.log('Filtering status:', {
        publisherId: publisher.id,
        rawStatus: publisher.status,
        normalizedPubStatus,
        activeFilter: activeFilters.status,
      });
      const statusMatch = activeFilters.status
        ? normalizedPubStatus === activeFilters.status.toLowerCase()
        : true;
      const searchMatch = activeFilters.search
        ? publisher.name?.toLowerCase().includes(activeFilters.search.toLowerCase()) ||
        publisher.email?.toLowerCase().includes(activeFilters.search.toLowerCase()) ||
        publisher.location?.toLowerCase().includes(activeFilters.search.toLowerCase())
        : true;

      // Date range filter based on joinDate
      // Parse active filter dates; treat missing values as unbounded.
      const fromMs = activeFilters.fromDate ? new Date(activeFilters.fromDate).setHours(0, 0, 0, 0) : null;
      const toMs = activeFilters.toDate ? new Date(activeFilters.toDate).setHours(23, 59, 59, 999) : null;

      // If both dates provided but from is after to, swap them to support inverted input.
      let startMs = fromMs;
      let endMs = toMs;
      if (startMs !== null && endMs !== null && startMs > endMs) {
        const tmp = startMs;
        startMs = endMs;
        endMs = tmp;
      }

      const dateMatch = (() => {
        if (startMs !== null && endMs !== null) {
          const joinMs = new Date(publisher.joinDate).getTime();
          return joinMs >= startMs && joinMs <= endMs;
        } else if (startMs !== null) {
          return new Date(publisher.joinDate).getTime() >= startMs;
        } else if (endMs !== null) {
          return new Date(publisher.joinDate).getTime() <= endMs;
        }
        return true;
      })();

      return adminMatch && statusMatch && searchMatch && dateMatch;
    });
    setPublishers(filtered);
    console.log('Filtered publishers count:', filtered.length, 'Active status filter:', activeFilters.status);
  }, [
    allPublishers,
    activeFilters.admin,
    activeFilters.status,
    activeFilters.search,
    activeFilters.fromDate,
    activeFilters.toDate
  ]);

  const handleOpenDetails = async (publisher) => {
    setSelectedPublisher(publisher);
    setIsDrawerOpen(true);

    try {
      const details = await fetchPublisherDetail(publisher.id);
      setSelectedPublisher(details);
    } catch {
      // Keep summary fallback data.
    }
  };

  const columns = [
    { key: 'id', label: 'ID', className: 'font-mono text-[10px] font-bold text-gray-400' },
    { key: 'name', label: 'Publisher', render: (val) => <span className="font-bold text-gray-900">{val}</span> },
    {
      key: 'adminName',
      label: 'Managed By',
      render: (val) => (
        <div className="flex items-center gap-2">
          <div className="w-5 h-5 rounded-full bg-gray-100 flex items-center justify-center text-[8px] font-bold text-gray-500">{val.charAt(0)}</div>
          <span className="text-sm font-medium text-gray-600">{val}</span>
        </div>
      ),
    },
    {
      key: 'location',
      label: 'Location',
      render: (val) => (
        <div className="flex items-center gap-1.5 text-gray-500">
          <MapPin size={14} className="text-gray-400" />
          <span className="text-sm font-medium">{val}</span>
        </div>
      ),
    },
    {
      key: 'latitude',
      label: 'Latitude',
      render: (val) => {
        const num = parseFloat(val);
        return (!isNaN(num)) ? <span className="text-sm text-gray-900">{num.toFixed(4)}</span> : <span className="text-sm text-gray-400">N/A</span>;
      }
    },
    {
      key: 'longitude',
      label: 'Longitude',
      render: (val) => {
        const num = parseFloat(val);
        return (!isNaN(num)) ? <span className="text-sm text-gray-900">{num.toFixed(4)}</span> : <span className="text-sm text-gray-400">N/A</span>;
      }
    },
    { key: 'adsPosted', label: 'Ads', className: 'text-center font-bold text-gray-900' },
    { key: 'engagement', label: 'Engagement', render: (val) => <span className="font-black text-primary-600">{val}%</span> },
    {
      key: 'status',
      label: 'Activity',
      render: (val) => {
        const strVal = String(val).toLowerCase();
        let displayStatus = val;
        if (strVal === 'true' || strVal === 'active') {
          displayStatus = 'Active';
        } else if (strVal === 'false' || strVal === 'inactive') {
          displayStatus = 'Inactive';
        }
        return <StatusBadge status={displayStatus} />;
      }
    },
    {
      key: 'actions',
      label: 'Actions',
      render: (_, row) => (
        <button
          onClick={(e) => { e.stopPropagation(); handleOpenDetails(row); }}
          className="flex items-center gap-2 px-3 py-1.5 bg-gray-100 hover:bg-primary-500 hover:text-white rounded-lg text-xs font-bold transition-all group"
        >
          <Eye size={14} />
          View
        </button>
      ),
    },
  ];

  const handleFilterChange = (key, value) => {
    // Normalize empty string (from select reset) to null so filters clear properly
    setActiveFilters((prev) => ({ ...prev, [key]: value || null }));
  };

  const resetFilters = () => {
    setActiveFilters({ status: null, sort: null, search: '', company: '', fromDate: '', toDate: '' });
  };

  const sortedPublishers = useMemo(() => {
    let result = [...publishers];
    const sortKey = activeFilters.sort;

    if (sortKey) {
      switch (sortKey) {
        case 'latest':
        case 'oldest':
          result.sort((a, b) => {
            const timeA = new Date(a.registeredDate || 0).getTime();
            const timeB = new Date(b.registeredDate || 0).getTime();
            return sortKey === 'oldest'
              ? timeA - timeB
              : timeB - timeA;
          });
          break;

        case 'ads_desc':
          result.sort((a, b) => b.adsPosted - a.adsPosted);
          break;

        case 'ads_asc':
          result.sort((a, b) => a.adsPosted - b.adsPosted);
          break;

        case 'eng_desc':
          result.sort((a, b) => b.engagement - a.engagement);
          break;

        case 'eng_asc':
          result.sort((a, b) => a.engagement - b.engagement);
          break;

        case 'name_asc':
          result.sort((a, b) => a.name.localeCompare(b.name));
          break;

        case 'name_desc':
          result.sort((a, b) => b.name.localeCompare(a.name));
          break;

        default:
          break;
      }
    }

    return result;
  }, [publishers, activeFilters.sort]);

  const adminOptions = useMemo(() => {
    const map = new Map();
    allPublishers.forEach((publisher) => {
      if (!map.has(publisher.adminId)) {
        map.set(publisher.adminId, publisher.adminName);
      }
    });

    return Array.from(map.entries())
      .map(([value, label]) => ({ value, label }))
      .sort((a, b) => a.label.localeCompare(b.label));
  }, [allPublishers]);

  const filterOptions = [
    {
      key: 'search',
      label: 'Search Publishers',
      type: 'search',
      placeholder: 'Search by name, email, or location',
      appliedValue: activeFilters.search,
    },
    {
      key: 'admin',
      label: 'Admin',
      type: 'select',
      options: adminOptions,
      appliedValue: activeFilters.admin ? adminOptions.find((a) => a.value === activeFilters.admin)?.label : null,
    },
    {
      key: 'status',
      label: 'Status',
      type: 'select',
      options: [
        { label: 'Active', value: 'Active' },
        { label: 'Inactive', value: 'Inactive' },
        { label: 'Suspended', value: 'Suspended' },
      ],
      appliedValue: activeFilters.status,
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
      key: 'sort',
      label: 'Sort By',
      type: 'select',
      options: [
        { label: 'Most Ads Posted', value: 'ads_desc' },
        { label: 'Least Ads Posted', value: 'ads_asc' },
        { label: 'Highest Engagement', value: 'eng_desc' },
        { label: 'Lowest Engagement', value: 'eng_asc' },
        { label: 'Name (A-Z)', value: 'name_asc' },
        { label: 'Name (Z-A)', value: 'name_desc' },
      ],
      appliedValue: activeFilters.sort,
    },
  ];

  const publisherAds = selectedPublisher?.ads ?? [];

  return (
    <div className="pb-10 space-y-8 animate-fade-in">
      <div className="animate-fade-in-scale">
        <PageHeader
          title={
            <div className="flex items-center gap-4">
              <span>Publisher Monitoring</span>
            </div>
          }
          subtitle="Global audit of all publisher engagement and display activity"
          actions={
            <div className="flex items-center gap-3">
              <div className="flex items-center gap-2.5 bg-white border border-gray-200 px-3 py-1.5 rounded-2xl shadow-sm">
                <span className="text-sm font-black text-gray-900">{allPublishers.length} Publishers</span>
              </div>
              <button
                onClick={() => setIsMapOpen(true)}
                className="px-5 py-2.5 bg-white hover:bg-gray-50 border border-gray-200 text-gray-700 rounded-xl text-xs font-bold shadow-sm active:scale-95 transition-all flex items-center gap-2"
              >
                <MapIcon size={16} />
                Map View
              </button>
              <button
                onClick={() => setIsCreateModalOpen(true)}
                className="px-5 py-2.5 bg-primary-500 hover:bg-primary-600 text-white rounded-xl text-xs font-bold shadow-lg shadow-primary-500/20 active:scale-95 transition-all flex items-center gap-2"
              >
                <Plus size={16} />
                Create Publisher
              </button>
            </div>
          }
        />
      </div>

      <div className="card-floating p-0 animate-fade-in-scale delay-100">
        <FilterBar
          filters={filterOptions}
          onFilterChange={handleFilterChange}
          onReset={resetFilters}
          activeFiltersCount={Object.values(activeFilters).filter(Boolean).length}
        />
      </div>

      <div className="card-floating p-0 overflow-hidden animate-fade-in-scale delay-200">
        {isLoading ? (
          <DataTable
            columns={columns}
            data={[]}
            isLoading={true}
            onRowClick={handleOpenDetails}
            exportFileName="publishers_audit"
            className="hover-glow-border"
            pageSizeOptions={[10, 25, 50, 100, 500]}
          />
        ) : publishers.length === 0 ? (
          <div className="p-8 text-center text-gray-500">
            No publisher records found. Please verify backend connectivity and data.
          </div>
        ) : (
          <DataTable
            columns={columns}
            data={sortedPublishers}
            isLoading={false}
            onRowClick={handleOpenDetails}
            exportFileName="publishers_audit"
            className="hover-glow-border"
            pageSizeOptions={[10, 25, 50, 100, 500]}
          />
        )}
      </div>

      <DetailDrawer
        isOpen={isDrawerOpen}
        onClose={() => setIsDrawerOpen(false)}
        title="Publisher Insights"
        footerActions={<span className="text-[10px] font-bold text-gray-400 uppercase tracking-widest border border-gray-200 px-2 py-1 rounded-lg">Read Only</span>}
      >
        {selectedPublisher && (
          <div className="space-y-8 animate-fade-in">
            <div className="bg-white p-6 rounded-2xl border border-gray-100 shadow-sm relative overflow-hidden group">
              <div className="absolute top-0 right-0 p-4 opacity-10 group-hover:opacity-20 transition-opacity">
                <BarChart2 size={120} className="text-primary-500" />
              </div>
              <div className="relative z-10">
                <div className="flex items-center gap-4 mb-4">
                  <div className="w-16 h-16 rounded-2xl bg-gray-900 flex items-center justify-center text-white text-2xl font-black">
                    {selectedPublisher.name.charAt(0)}
                  </div>
                  <div>
                    <h3 className="text-xl font-black text-gray-900">{selectedPublisher.name}</h3>
                    <div className="flex items-center gap-2 mt-1">
                      <StatusBadge status={selectedPublisher.status} />
                      <span className="text-xs text-gray-400 font-mono">{selectedPublisher.id}</span>
                    </div>
                  </div>
                </div>
                <div className="grid grid-cols-2 gap-y-3 pt-4 border-t border-gray-50">
                  <div className="flex items-center gap-2 text-sm">
                    <User size={14} className="text-primary-500" />
                    <span className="text-gray-500">Admin:</span>
                    <span className="font-bold text-gray-900">{selectedPublisher.adminName}</span>
                  </div>
                  <div className="flex items-center gap-2 text-sm">
                    <MapPin size={14} className="text-primary-500" />
                    <span className="text-gray-500">Location:</span>
                    <span className="font-bold text-gray-900">{selectedPublisher.location}</span>
                  </div>
                  <div className="flex items-center gap-2 text-sm">
                    <Mail size={14} className="text-primary-500" />
                    <span className="font-bold text-gray-900">{selectedPublisher.email}</span>
                  </div>
                  <div className="flex items-center gap-2 text-sm">
                    <Calendar size={14} className="text-primary-500" />
                    <span className="text-gray-500">Joined:</span>
                    <span className="font-bold text-gray-900">{selectedPublisher.joinDate}</span>
                  </div>
                </div>
              </div>
            </div>

            <div className="grid grid-cols-2 md:grid-cols-4 gap-3">
              {[
                { label: 'Ads Posted', value: selectedPublisher.adsPosted, icon: Info },
                { label: 'Impressions', value: selectedPublisher.impressions.toLocaleString(), icon: Info },
                { label: 'Clicks', value: selectedPublisher.clicks.toLocaleString(), icon: Info },
                { label: 'Engagement', value: `${selectedPublisher.engagement}%`, icon: Info, highlight: true },
              ].map((stat, idx) => (
                <div key={idx} className="bg-white p-4 rounded-2xl border border-gray-100 text-center flex flex-col items-center shadow-sm">
                  <p className="text-[10px] font-bold text-gray-400 uppercase tracking-widest mb-1">{stat.label}</p>
                  <p className={`text-xl font-black ${stat.highlight ? 'text-primary-500' : 'text-gray-900'}`}>{stat.value}</p>
                </div>
              ))}
            </div>

            <div className="space-y-3">
              <h4 className="text-sm font-bold text-gray-900 uppercase tracking-wider flex items-center justify-between">
                Published Advertisements
                <span className="text-xs font-medium text-gray-400 normal-case">{publisherAds.length} campaigns</span>
              </h4>
              <div className="bg-white border border-gray-100 rounded-2xl overflow-hidden shadow-sm">
                <div className="overflow-x-auto">
                  <table className="w-full text-left">
                    <thead className="bg-gray-50">
                      <tr>
                        <th className="px-4 py-3 text-[10px] font-bold text-gray-400 uppercase">AD Title</th>
                        <th className="px-4 py-3 text-[10px] font-bold text-gray-400 uppercase">Type</th>
                        <th className="px-4 py-3 text-[10px] font-bold text-gray-400 uppercase">Status</th>
                        <th className="px-4 py-3 text-[10px] font-bold text-gray-400 uppercase text-right">CTR</th>
                      </tr>
                    </thead>
                    <tbody className="divide-y divide-gray-100">
                      {publisherAds.length > 0 ? publisherAds.map((ad, idx) => (
                        <tr key={idx} className="hover:bg-gray-50 transition-colors">
                          <td className="px-4 py-3 text-sm font-semibold text-gray-900 max-w-[150px] truncate">{ad.title}</td>
                          <td className="px-4 py-3 text-xs text-gray-500 font-medium">{ad.type}</td>
                          <td className="px-4 py-3"><StatusBadge status={ad.status} /></td>
                          <td className="px-4 py-3 text-right text-xs font-bold text-primary-600">{ad.ctr}%</td>
                        </tr>
                      )) : (
                        <tr>
                          <td colSpan="4" className="px-4 py-8 text-center text-gray-400 text-xs italic">No campaigns found for this publisher</td>
                        </tr>
                      )}
                    </tbody>
                  </table>
                </div>
              </div>
            </div>
          </div>
        )}
      </DetailDrawer>

      {isCreateModalOpen && (
        <CreatePublisherModal
          isOpen={isCreateModalOpen}
          onClose={() => setIsCreateModalOpen(false)}
          onSuccess={loadPublishers}
          admins={admins}
        />
      )}

      <PublisherMapView
        isOpen={isMapOpen}
        onClose={() => setIsMapOpen(false)}
        publishers={allPublishers}
        onPublisherClick={handleOpenDetails}
      />
    </div>
  );
};

export default PublisherMonitoring;