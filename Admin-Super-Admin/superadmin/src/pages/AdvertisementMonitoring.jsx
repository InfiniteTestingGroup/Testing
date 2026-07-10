import React, { useState, useEffect, useRef, useMemo } from 'react';
import { Eye, AlertCircle, MapPin, Target, BarChart3, Megaphone, User, Radio, ExternalLink, Download, Map as MapIcon } from 'lucide-react';
import { exportToCSV } from '../utils/export';
import PageHeader from '../components/shared/PageHeader';
import StatusBadge from '../components/shared/StatusBadge';
import DetailDrawer from '../components/shared/DetailDrawer';
import FilterBar from '../components/shared/FilterBar';
import ConfirmDialog from '../components/shared/ConfirmDialog';
import { fetchAdvertisements, fetchAdvertisementsPaginated, suspendAdvertisement } from '../lib/ads';
import { AdvertisementMapView } from '../components/admin/AdvertisementMapView';

const PAGE_SIZE = 20;

const AdvertisementMonitoring = () => {
    const [ads, setAds] = useState([]);
    const [isLoading, setIsLoading] = useState(true);
    const [error, setError] = useState('');
    const [selectedAd, setSelectedAd] = useState(null);
    const [isDrawerOpen, setIsDrawerOpen] = useState(false);

    // Removed 'publisher' from activeFilters
    const [activeFilters, setActiveFilters] = useState({
        status: null, type: null, adType: null, sortBy: null, searchTerm: '',
        dateRange: null, location: null, performanceTier: null,
    });
    const [totalCount, setTotalCount] = useState(null);

    // Dialog state
    const [confirmDialog, setConfirmDialog] = useState({ isOpen: false, ad: null });
    const [isMapOpen, setIsMapOpen] = useState(false);
    const [wasMapOpen, setWasMapOpen] = useState(false);
    const [isMapLoading, setIsMapLoading] = useState(false);

    // Tracks whether all pages have been loaded (used to trigger auto-fetch on filter)
    const allPagesLoadedRef = useRef(false);
    const [page, setPage] = useState(0);
    const [hasMore, setHasMore] = useState(true);
    const [isFetchingMore, setIsFetchingMore] = useState(false);
    const loaderRef = useRef(null);

    // Shared in-flight promise for "load everything" so filter/map/export
    // never race each other with duplicate fetchAdvertisements() calls.
    const fullFetchPromiseRef = useRef(null);

    const formatMetric = (value, suffix = '') => {
        if (value === null || value === undefined) {
            return 'N/A';
        }

        if (typeof value === 'number') {
            return `${value.toLocaleString()}${suffix}`;
        }

        return `${value}${suffix}`;
    };

    // Ensures the full (unpaginated) ad list is loaded exactly once, even if
    // multiple callers (filter change, map open, export) ask for it around
    // the same time. Returns a promise resolving to the full list.
    const ensureAllAdsLoaded = () => {
        if (allPagesLoadedRef.current) {
            return Promise.resolve(ads);
        }
        if (fullFetchPromiseRef.current) {
            return fullFetchPromiseRef.current;
        }

        const promise = fetchAdvertisements()
            .then(data => {
                setAds(data);
                setHasMore(false);
                allPagesLoadedRef.current = true;
                return data;
            })
            .finally(() => {
                fullFetchPromiseRef.current = null;
            });

        fullFetchPromiseRef.current = promise;
        return promise;
    };

    // Initial load
    useEffect(() => {
        let active = true;

        const load = async () => {
            setIsLoading(true);
            setError('');

            try {
                allPagesLoadedRef.current = false;
                const result = await fetchAdvertisementsPaginated(0, PAGE_SIZE);
                if (active) {
                    setAds(result.content);
                    setTotalCount(result.totalElements ?? result.content?.length ?? 0);
                    setHasMore(result.totalPages > 1);
                    setPage(1);
                    if (result.totalPages <= 1) {
                        allPagesLoadedRef.current = true;
                    }
                }
            } catch (err) {
                if (active) {
                    setAds([]);
                    setError(err instanceof Error ? err.message : 'Unable to load advertisements');
                }
            } finally {
                if (active) {
                    setIsLoading(false);
                }
            }
        };

        load();
        return () => { active = false; };
    }, []);

    // Infinite scroll observer
    useEffect(() => {
        const observer = new IntersectionObserver(
            async ([entry]) => {
                if (entry.isIntersecting && hasMore && !isFetchingMore) {
                    setIsFetchingMore(true);
                    try {
                        const result = await fetchAdvertisementsPaginated(page, PAGE_SIZE);
                        setAds(prev => [...prev, ...result.content]);
                        const nextPage = page + 1;
                        const done = nextPage >= result.totalPages;
                        setHasMore(!done);
                        if (done) allPagesLoadedRef.current = true;
                        setPage(prev => prev + 1);
                    } catch (err) {
                        setError(err instanceof Error ? err.message : 'Unable to load more advertisements');
                    } finally {
                        setIsFetchingMore(false);
                    }
                }
            },
            { threshold: 0.1 }
        );
        const node = loaderRef.current;
        if (node) observer.observe(node);
        return () => observer.disconnect();
    }, [page, hasMore, isFetchingMore]);

    const handleSuspend = (ad) => {
        setConfirmDialog({ isOpen: true, ad });
    };

    const executeSuspend = async () => {
        const { ad } = confirmDialog;
        if (!ad) {
            return;
        }

        try {
            const updatedAd = await suspendAdvertisement(ad.id);
            setAds(prev => prev.map(a => a.id === ad.id ? updatedAd : a));
            if (selectedAd && selectedAd.id === ad.id) {
                setSelectedAd(updatedAd);
            }
            setConfirmDialog({ isOpen: false, ad: null });
        } catch (err) {
            setError(err instanceof Error ? err.message : 'Unable to suspend advertisement');
        }
    };

    // Derive unique locations from loaded ads for searchable dropdown
    const locationOptions = useMemo(() => {
        const unique = [...new Set(ads.map(a => a.location).filter(Boolean).filter(l => l !== 'Unknown'))];
        return unique.sort().map(l => ({ label: l, value: l }));
    }, [ads]);

    // Removed the publisher filter from filterOptions
    const filterOptions = [
        {
            key: 'searchTerm',
            label: 'Quick Search',
            type: 'search',
            appliedValue: activeFilters.searchTerm
        },
        {
            key: 'adType',
            label: 'Ad Type',
            type: 'select',
            options: [
                { label: 'Video', value: 'Video' },
                { label: 'Banner', value: 'Banner' },
                { label: 'Image', value: 'Image' }
            ],
            appliedValue: activeFilters.adType
        },
        {
            key: 'status',
            label: 'Status',
            type: 'select',
            options: [
                { label: 'Active', value: 'Active' },
                { label: 'Pending', value: 'Pending' },
                { label: 'Completed', value: 'Completed' },
                { label: 'Suspended', value: 'Suspended' },
                { label: 'Paused', value: 'Paused' },
                { label: 'Inactive', value: 'Inactive' }
            ],
            appliedValue: activeFilters.status
        },
        {
            key: 'dateRange',
            label: 'Date Range',
            type: 'dateRange',
            appliedValue: activeFilters.dateRange
        },
        {
            key: 'location',
            label: 'Location / Region',
            type: 'searchableSelect',
            placeholder: 'Search city or region…',
            options: locationOptions,
            appliedValue: activeFilters.location
        },
        {
            key: 'performanceTier',
            label: 'Performance Tier',
            type: 'select',
            placeholder: 'All Tiers',
            options: [
                { label: 'High CTR (>5%)', value: 'high' },
                { label: 'Medium CTR (2–5%)', value: 'medium' },
                { label: 'Low CTR (<2%)', value: 'low' },
                { label: 'No Impressions', value: 'none' }
            ],
            appliedValue: activeFilters.performanceTier
        },
        {
            key: 'sortBy',
            label: 'Sort By',
            type: 'select',
            placeholder: 'Default (Newest to Oldest)',
            options: [
                { label: 'Newest to Oldest', value: 'newest' },
                { label: 'Oldest to Newest', value: 'oldest' }
            ],
            appliedValue: activeFilters.sortBy
        }
    ];

    const filteredData = ads
        .filter(ad => {
            if (activeFilters.status && ad.status?.toLowerCase() !== activeFilters.status.toLowerCase()) return false;
            if (activeFilters.adType && !ad.type?.toLowerCase().includes(activeFilters.adType.toLowerCase())) return false;
            if (activeFilters.searchTerm) {
                const term = activeFilters.searchTerm.toLowerCase();
                const matchesTitle = ad.title?.toLowerCase().includes(term);
                const matchesId = ad.id?.toLowerCase().includes(term);
                const matchesAdmin = ad.adminName?.toLowerCase().includes(term);
                if (!matchesTitle && !matchesId && !matchesAdmin) return false;
            }
            // Date Range filter
            if (activeFilters.dateRange) {
                const adDate = ad.createdAt ? new Date(ad.createdAt).getTime() : null;
                if (adDate) {
                    if (activeFilters.dateRange.from) {
                        const from = new Date(activeFilters.dateRange.from + 'T00:00:00').getTime();
                        if (adDate < from) return false;
                    }
                    if (activeFilters.dateRange.to) {
                        const to = new Date(activeFilters.dateRange.to + 'T23:59:59').getTime();
                        if (adDate > to) return false;
                    }
                } else if (activeFilters.dateRange.from || activeFilters.dateRange.to) {
                    return false; // No date = doesn't match a date filter
                }
            }
            // Location filter
            if (activeFilters.location) {
                if (!ad.location?.toLowerCase().includes(activeFilters.location.toLowerCase())) return false;
            }

            // Performance Tier filter
            if (activeFilters.performanceTier) {
                const ctr = ad.ctr;
                const impressions = ad.impressions;
                if (activeFilters.performanceTier === 'none') {
                    if (impressions !== null && impressions !== undefined && impressions > 0) return false;
                } else if (activeFilters.performanceTier === 'high') {
                    if (ctr === null || ctr === undefined || ctr <= 5) return false;
                } else if (activeFilters.performanceTier === 'medium') {
                    if (ctr === null || ctr === undefined || ctr <= 2 || ctr > 5) return false;
                } else if (activeFilters.performanceTier === 'low') {
                    if (ctr === null || ctr === undefined || ctr >= 2) return false;
                    if (impressions === null || impressions === undefined || impressions === 0) return false;
                }
            }
            return true;
        })
        .sort((a, b) => {
            const timeA = a.createdAt ? new Date(a.createdAt).getTime() : 0;
            const timeB = b.createdAt ? new Date(b.createdAt).getTime() : 0;
            if (activeFilters.sortBy === 'oldest') {
                return timeA - timeB;
            }
            // Default to newest first
            return timeB - timeA;
        });

    const handleFilterChange = (key, value) => {
        setActiveFilters(prev => ({ ...prev, [key]: value }));

        // If not all pages are loaded yet, fetch everything now so the filter
        // applies to the complete dataset rather than only the scrolled-in portion.
        if (!allPagesLoadedRef.current) {
            setIsLoading(true); // shows skeleton instead of a premature "No campaigns found"
            ensureAllAdsLoaded()
                .catch(err => {
                    setError(err instanceof Error ? err.message : 'Unable to load all advertisements');
                })
                .finally(() => {
                    setIsLoading(false);
                });
        }
    };

    // Open Map View
    const handleOpenMap = async () => {
        if (!allPagesLoadedRef.current) {
            setIsMapLoading(true);
            try {
                await ensureAllAdsLoaded();
            } catch (err) {
                setError(err instanceof Error ? err.message : 'Unable to load map data');
                setIsMapLoading(false);
                return;
            }
            setIsMapLoading(false);
        }
        setIsMapOpen(true);
    };

    const [isExporting, setIsExporting] = useState(false);

    const handleExport = async () => {
        setIsExporting(true);
        try {
            // Reuses an in-flight "load everything" fetch if one is already
            // running (e.g. from a filter change or Map View click), instead
            // of firing a second competing request. Otherwise fetches fresh
            // to guarantee the export reflects the complete dataset.
            const allData = await ensureAllAdsLoaded();
            const columns = [
                { key: 'id', label: 'ID' },
                { key: 'title', label: 'Title' },
                { key: 'type', label: 'Type' },
                { key: 'status', label: 'Status' },
                { key: 'adminName', label: 'Admin' },
                { key: 'publisherName', label: 'Publisher' },
                { key: 'impressions', label: 'Impressions' },
                { key: 'clicks', label: 'Clicks' },
                { key: 'ctr', label: 'CTR' },
                { key: 'createdDate', label: 'Created Date' }
            ];
            exportToCSV(allData, columns, 'advertisements_audit');
        } catch (err) {
            setError(err instanceof Error ? err.message : 'Export failed');
        } finally {
            setIsExporting(false);
        }
    };

    return (
        <div className="pb-10 space-y-8 animate-fade-in">
            <div className="animate-fade-in-scale">
                <PageHeader
                    title="Advertisement Monitoring"
                    subtitle="System-wide lifecycle management and performance audit of all campaigns"
                    actions={
                        <div className="flex items-center gap-3">
                            {totalCount !== null && (
                                <span className="px-5 py-2.5 bg-white border border-gray-200 text-gray-700 rounded-xl text-xs font-bold shadow-sm tabular-nums">
                                    {totalCount.toLocaleString()} campaigns
                                </span>
                            )}
                            <button
                                onClick={handleOpenMap}
                                disabled={isMapLoading}
                                className="px-5 py-2.5 bg-white hover:bg-gray-50 border border-gray-200 text-gray-700 rounded-xl text-xs font-bold shadow-sm active:scale-95 transition-all flex items-center gap-2 disabled:opacity-50"
                            >
                                <MapIcon size={16} />
                                {isMapLoading ? 'Loading...' : 'Map View'}
                            </button>
                            <button
                                onClick={handleExport}
                                disabled={isExporting}
                                className="flex items-center gap-2 px-4 py-2 text-sm font-bold text-primary-600 bg-primary-50 hover:bg-primary-100 rounded-xl transition-all disabled:opacity-50"
                            >
                                <Download size={16} />
                                {isExporting ? 'Exporting...' : 'Export CSV'}
                            </button>
                        </div>
                    }
                />
            </div>

            <div className="card-floating p-0 animate-fade-in-scale delay-100">
                <FilterBar
                    filters={filterOptions}
                    onFilterChange={handleFilterChange}
                    onReset={() => setActiveFilters({ status: null, type: null, adType: null, sortBy: null, searchTerm: '', dateRange: null, location: null, performanceTier: null })}
                    activeFiltersCount={Object.values(activeFilters).filter(Boolean).length}
                />
            </div>

            {error && (
                <div className="rounded-2xl border border-red-200 bg-red-50 px-4 py-3 text-sm font-medium text-red-700">
                    {error}
                </div>
            )}

            {/* Ads Grid View */}
            <div className="animate-fade-in-scale delay-200">
                {isLoading ? (
                    <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-6">
                        {[1, 2, 3, 4, 5, 6, 7, 8].map(i => (
                            <div key={i} className="aspect-[4/5] bg-white rounded-[2.5rem] border border-gray-100 animate-pulse" />
                        ))}
                    </div>
                ) : filteredData.length > 0 ? (
                    <>
                        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-6">
                            {filteredData.map((ad) => (
                                <div
                                    key={ad.id}
                                    onClick={() => { setSelectedAd(ad); setIsDrawerOpen(true); setWasMapOpen(false); }}
                                    className="group relative bg-white rounded-[2rem] border border-gray-100 shadow-sm hover:shadow-2xl hover:shadow-primary-500/10 transition-all duration-500 cursor-pointer overflow-hidden flex flex-col animate-fade-in"
                                >
                                    <div className="aspect-[4/3] w-full overflow-hidden relative">
                                        <img
                                            src={ad.image || 'https://images.unsplash.com/photo-1620641788421-7a1c342ea42e?w=800&q=80'}
                                            alt={ad.title}
                                            loading="lazy"
                                            decoding="async"
                                            className="w-full h-full object-cover transition-transform duration-700 group-hover:scale-110"
                                            onError={(e) => {
                                                e.currentTarget.onerror = null;
                                                e.currentTarget.src = 'https://images.unsplash.com/photo-1620641788421-7a1c342ea42e?w=800&q=80';
                                            }}
                                        />
                                        <div className="absolute inset-0 bg-gradient-to-t from-black/80 via-black/20 to-transparent opacity-60 group-hover:opacity-40 transition-opacity" />

                                        <div className="absolute top-4 right-4 z-10 transition-transform duration-300 group-hover:translate-x-1">
                                            <StatusBadge status={ad.status} />
                                        </div>

                                        <div className="absolute bottom-4 left-4 z-10">
                                            <div className="px-3 py-1.5 bg-white/20 backdrop-blur-md border border-white/20 text-white text-[10px] font-black rounded-xl uppercase tracking-widest shadow-xl">
                                                {ad.type}
                                            </div>
                                        </div>
                                    </div>

                                    <div className="p-6 flex-1 flex flex-col relative">
                                        <div className="mb-1">
                                            <span className="text-[10px] font-black text-gray-400 font-mono tracking-tighter bg-gray-50 px-2 py-0.5 rounded-md">ID: {ad.id}</span>
                                        </div>
                                        <h4 className="text-lg font-black text-gray-900 leading-tight mb-6 group-hover:text-primary-600 transition-colors line-clamp-2">
                                            {ad.title}
                                        </h4>

                                        <div className="mt-auto pt-5 border-t border-gray-50 flex items-center justify-between">
                                            <div className="space-y-1">
                                                <p className="text-[10px] font-black text-gray-400 uppercase tracking-tighter">Impressions</p>
                                                <p className="text-base font-black text-gray-900 tracking-tight">{formatMetric(ad.impressions)}</p>
                                            </div>
                                            <div className="space-y-1 text-right">
                                                <p className="text-[10px] font-black text-gray-400 uppercase tracking-tighter">Avg CTR</p>
                                                <p className="text-base font-black text-primary-500 tracking-tight">{formatMetric(ad.ctr, ad.ctr === null || ad.ctr === undefined ? '' : '%')}</p>
                                            </div>
                                        </div>

                                        <div className="absolute -top-6 right-6 flex gap-2 translate-y-4 opacity-0 group-hover:translate-y-0 group-hover:opacity-100 transition-all duration-300 z-20">
                                            <button
                                                onClick={(e) => { e.stopPropagation(); setSelectedAd(ad); setIsDrawerOpen(true); setWasMapOpen(false); }}
                                                className="w-12 h-12 bg-white shadow-xl rounded-2xl flex items-center justify-center text-primary-500 hover:bg-primary-500 hover:text-white transition-all active:scale-90 border border-gray-50"
                                            >
                                                <Eye size={20} />
                                            </button>
                                            {ad.status === 'Active' && (
                                                <button
                                                    onClick={(e) => { e.stopPropagation(); handleSuspend(ad); }}
                                                    className="w-12 h-12 bg-white shadow-xl rounded-2xl flex items-center justify-center text-red-500 hover:bg-red-500 hover:text-white transition-all active:scale-90 border border-gray-50"
                                                >
                                                    <AlertCircle size={20} />
                                                </button>
                                            )}
                                        </div>
                                    </div>
                                </div>
                            ))}
                        </div>

                        <div ref={loaderRef} className="py-6 flex justify-center">
                            {isFetchingMore && (
                                <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-6 w-full">
                                    {[1, 2, 3, 4].map(i => (
                                        <div key={i} className="aspect-[4/5] bg-white rounded-[2.5rem] border border-gray-100 animate-pulse" />
                                    ))}
                                </div>
                            )}
                        </div>
                    </>
                ) : (
                    <div className="card-floating py-20 flex flex-col items-center justify-center text-center">
                        <div className="w-20 h-20 bg-gray-50 rounded-full flex items-center justify-center text-gray-300 mb-4">
                            <Megaphone size={40} />
                        </div>
                        <h3 className="text-xl font-black text-gray-900">No campaigns found</h3>
                        <p className="text-sm text-gray-400 mt-2">Try adjusting your filters or search criteria</p>
                    </div>
                )}
            </div>

            <DetailDrawer
                isOpen={isDrawerOpen}
                onClose={() => {
                    setIsDrawerOpen(false);
                    if (wasMapOpen) {
                        setIsMapOpen(true);
                        setWasMapOpen(false);
                    }
                }}
                title="Advertisement Deep-Dive"
                footerActions={
                    selectedAd?.status === 'Active' && (
                        <button
                            onClick={() => handleSuspend(selectedAd)}
                            className="flex items-center gap-2 px-4 py-2 bg-red-600 text-white rounded-xl text-xs font-black shadow-lg shadow-red-600/20 active:scale-95 transition-all"
                        >
                            <AlertCircle size={14} />
                            Suspend Campaign
                        </button>
                    )
                }
            >
                {selectedAd && (
                    <div className="space-y-8 animate-fade-in">
                        <div className="bg-white p-6 rounded-3xl border border-gray-100 shadow-sm space-y-4">
                            <div className="flex items-start justify-between">
                                <div className="p-3 bg-primary-100 text-primary-600 rounded-2xl">
                                    <Megaphone size={28} />
                                </div>
                                <StatusBadge status={selectedAd.status} />
                            </div>
                            <div>
                                <h3 className="text-2xl font-black text-gray-900 leading-tight">{selectedAd.title}</h3>
                                <p className="text-sm font-medium text-gray-400 mt-1 font-mono tracking-tighter">ID: {selectedAd.id}</p>
                            </div>

                            <div className="grid grid-cols-2 gap-4 pt-4 border-t border-gray-50">
                                <div className="space-y-1">
                                    <p className="text-[10px] font-bold text-gray-400 uppercase tracking-widest">Type</p>
                                    <p className="text-sm font-bold text-gray-900">{selectedAd.type} Advertisement</p>
                                </div>
                                <div className="space-y-1">
                                    <p className="text-[10px] font-bold text-gray-400 uppercase tracking-widest">Created On</p>
                                    <p className="text-sm font-bold text-gray-900">{selectedAd.createdDate}</p>
                                </div>
                            </div>
                        </div>

                        <div className="grid grid-cols-2 gap-4">
                            <div className="bg-gray-50 p-4 rounded-2xl border border-gray-100 shadow-inner">
                                <div className="flex items-center gap-2 text-indigo-600 mb-2 font-bold text-[10px] uppercase">
                                    <User size={14} />
                                    Account Admin
                                </div>
                                <p className="text-sm font-black text-gray-900">{selectedAd.adminName}</p>
                            </div>
                            <div className="bg-gray-50 p-4 rounded-2xl border border-gray-100 shadow-inner">
                                <div className="flex items-center gap-2 text-purple-600 mb-2 font-bold text-[10px] uppercase">
                                    <Radio size={14} />
                                    Publisher
                                </div>
                                <p className="text-sm font-black text-gray-900">{selectedAd.publisherName}</p>
                            </div>
                        </div>

                        <div className="space-y-3">
                            <h4 className="text-sm font-bold text-gray-900 uppercase tracking-wider flex items-center gap-2">
                                <MapPin size={16} className="text-primary-500" />
                                Targeting Configuration
                            </h4>
                            <div className="bg-white p-5 rounded-2xl border border-gray-100 shadow-sm grid grid-cols-2 gap-4">
                                <div className="space-y-1">
                                    <p className="text-[10px] font-bold text-gray-400 uppercase tracking-tighter">Target City</p>
                                    <p className="text-sm font-bold text-gray-900">{selectedAd.location}</p>
                                </div>
                                <div className="space-y-1">
                                    <p className="text-[10px] font-bold text-gray-400 uppercase tracking-tighter">Geo-Radius</p>
                                    <div className="flex items-center gap-2">
                                        <div className="flex-1 h-1.5 bg-gray-100 rounded-full">
                                            <div className="bg-primary-500 h-1.5 rounded-full" style={{ width: `${Math.min((parseFloat(selectedAd.radius) || 0) * 10, 100)}%` }} />
                                        </div>
                                        <p className="text-sm font-bold text-gray-900">{selectedAd.radius}</p>
                                    </div>
                                </div>
                                <div className="col-span-2 space-y-1 pt-2">
                                    <p className="text-[10px] font-bold text-gray-400 uppercase tracking-tighter">Campaign Duration</p>
                                    <div className="flex items-center gap-3">
                                        <span className="text-sm font-bold text-gray-900">{selectedAd.startDate}</span>
                                        <span className="text-gray-300">→</span>
                                        <span className="text-sm font-bold text-gray-900">{selectedAd.endDate}</span>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div className="space-y-3">
                            <h4 className="text-sm font-bold text-gray-900 uppercase tracking-wider flex items-center gap-2">
                                <BarChart3 size={16} className="text-primary-500" />
                                Performance Metrics
                            </h4>
                            <div className="grid grid-cols-3 gap-3">
                                {[
                                    { label: 'Impressions', value: formatMetric(selectedAd.impressions) },
                                    { label: 'Clicks', value: formatMetric(selectedAd.clicks) },
                                    { label: 'Avg CTR', value: formatMetric(selectedAd.ctr, selectedAd.ctr === null || selectedAd.ctr === undefined ? '' : '%'), highlight: true }
                                ].map((m, i) => (
                                    <div key={i} className="bg-white p-4 rounded-2xl border border-gray-100 shadow-sm text-center">
                                        <p className="text-[10px] font-bold text-gray-400 uppercase tracking-tight mb-1">{m.label}</p>
                                        <p className={`text-xl font-black ${m.highlight ? 'text-primary-500' : 'text-gray-900'}`}>{m.value}</p>
                                    </div>
                                ))}
                            </div>
                        </div>

                        <div className="space-y-3">
                            <h4 className="text-sm font-bold text-gray-900 uppercase tracking-wider flex items-center gap-2">
                                <Target size={16} className="text-primary-500" />
                                Ad Creative Preview
                            </h4>
                            <div
                                onClick={() => selectedAd.image && window.open(selectedAd.image, '_blank')}
                                className="aspect-video bg-gray-100 rounded-3xl border border-gray-200 flex flex-col items-center justify-center relative overflow-hidden group cursor-pointer hover:bg-gray-50 transition-all hover:border-primary-200"
                                title="Click to view full size creative"
                            >
                                {selectedAd.image ? (
                                    selectedAd.type === 'Video' ? (
                                        <div className="w-full h-full flex items-center justify-center relative bg-black">
                                            <video
                                                src={selectedAd.image}
                                                className="w-full h-full object-contain"
                                            />
                                            <div className="absolute inset-0 bg-black/40 flex flex-col items-center justify-center text-white opacity-80 group-hover:opacity-100 transition-opacity gap-2">
                                                <ExternalLink size={28} />
                                                <span className="text-xs font-bold uppercase tracking-wider">Play / Preview Video</span>
                                            </div>
                                        </div>
                                    ) : (
                                        <div className="w-full h-full relative">
                                            <img
                                                src={selectedAd.image}
                                                alt="Ad Creative"
                                                className="w-full h-full object-cover"
                                                onError={(e) => {
                                                    e.currentTarget.onerror = null;
                                                    e.currentTarget.src = 'https://placehold.co/600x400?text=Creative+Not+Found+On+S3';
                                                }}
                                            />
                                            <div className="absolute inset-0 bg-black/30 flex flex-col items-center justify-center text-white opacity-0 group-hover:opacity-100 transition-opacity gap-2">
                                                <ExternalLink size={28} />
                                                <span className="text-xs font-bold uppercase tracking-wider">View Full Creative</span>
                                            </div>
                                        </div>
                                    )
                                ) : (
                                    <>
                                        <div className="w-12 h-12 bg-white rounded-2xl flex items-center justify-center text-gray-400 group-hover:text-primary-500 group-hover:scale-110 shadow-sm transition-all">
                                            <ExternalLink size={24} />
                                        </div>
                                        <span className="text-sm font-bold text-gray-400 group-hover:text-primary-600">No creative available</span>
                                    </>
                                )}
                            </div>
                        </div>
                    </div>
                )}
            </DetailDrawer>

            {confirmDialog.isOpen && (
                <ConfirmDialog
                    isOpen={confirmDialog.isOpen}
                    onClose={() => setConfirmDialog({ isOpen: false, ad: null })}
                    onConfirm={executeSuspend}
                    title="Suspend Advertisement"
                    message={`Are you sure you want to suspend the campaign "${confirmDialog.ad?.title}"? This action will take the ad offline immediately.`}
                    confirmText="Suspend Campaign"
                    type="danger"
                />
            )}

            <AdvertisementMapView
                isOpen={isMapOpen}
                onClose={() => setIsMapOpen(false)}
                campaigns={filteredData}
                onViewDetails={(ad) => {
                    setWasMapOpen(true);
                    setIsMapOpen(false);
                    setSelectedAd(ad);
                    setIsDrawerOpen(true);
                }}
            />
        </div>
    );
};

export default AdvertisementMonitoring;