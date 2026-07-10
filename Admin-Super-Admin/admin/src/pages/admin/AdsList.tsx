import * as React from "react"
import { useNavigate } from "react-router-dom"
import { Plus, Loader2, Map } from "lucide-react"
import toast, { Toaster } from 'react-hot-toast'

import { AdsFilters } from "../../components/ads/AdsFilters"
import { AdsTable } from "../../components/ads/AdsTable"
import { Modal } from "../../components/ui/Modal"
import { MapView } from "../../components/dashboard/MapView"

import {
  fetchAds, duplicateAd, archiveAd, getAdDetail, clearAdsCache,
  type Advertisement
} from "../../services/ads"

import { fetchPublishers } from "../../services/publishers"

export default function AdsList() {
  const navigate = useNavigate()
  const [data, setData] = React.useState<Advertisement[]>([])
  const [totalItems, setTotalItems] = React.useState(0)
  const [loading, setLoading] = React.useState(true)
  const [publishersList, setPublishersList] = React.useState<string[]>([])

  // Map Modal State
  const [isMapOpen, setIsMapOpen] = React.useState(false)
  const [companyUID, setCompanyUID] = React.useState<string | undefined>(undefined)

  // Filters State
  const [searchTerm, setSearchTerm] = React.useState("")
  const [statusFilter, setStatusFilter] = React.useState("All")
  const [publisherFilter, setPublisherFilter] = React.useState("All")
  const [dateFilterMode, setDateFilterMode] = React.useState("All Time")
  const [customDateRange, setCustomDateRange] = React.useState({ start: "", end: "" })
  const [paymentFilter, setPaymentFilter] = React.useState("All")

  // Pagination State
  const [page, setPage] = React.useState(1)
  const [limit, setLimit] = React.useState(10)

  // Modal State
  const [isModalOpen, setIsModalOpen] = React.useState(false)
  const [selectedAd, setSelectedAd] = React.useState<{ id: string, title: string } | null>(null)
  const [isArchiving, setIsArchiving] = React.useState(false)

  // View Modal State
  const [isViewModalOpen, setIsViewModalOpen] = React.useState(false)
  const [viewingAd, setViewingAd] = React.useState<any | null>(null)
  const [isFetchingAd, setIsFetchingAd] = React.useState(false)

  const toLocalDateString = (date: Date) => {
    const offset = date.getTimezoneOffset()
    const localDate = new Date(date.getTime() - (offset * 60 * 1000))
    return localDate.toISOString().split('T')[0]
  }

  // Calculate generic date ranges
  const getDateRangeParams = () => {
    if (dateFilterMode === "All Time") return undefined

    const end = new Date()
    const start = new Date()

    if (dateFilterMode === "Today") {
      start.setHours(0, 0, 0, 0)
    } else if (dateFilterMode === "Last 7 days") {
      start.setDate(start.getDate() - 7)
    } else if (dateFilterMode === "Last 30 days") {
      start.setDate(start.getDate() - 30)
    } else if (dateFilterMode === "Custom Range") {
      if (!customDateRange.start && !customDateRange.end) return undefined
      return {
        start: customDateRange.start || undefined,
        end: customDateRange.end || undefined
      }
    }

    return {
      start: toLocalDateString(start),
      end: toLocalDateString(end)
    }
  }

  const loadData = React.useCallback(async () => {
    setLoading(true)
    try {
      clearAdsCache()
      // Get company UID from session
      let uid = undefined;
      const userStr = localStorage.getItem('admin_user');
      if (userStr) {
        const user = JSON.parse(userStr);
        uid = user.companyUID || user.companyId || user.uid;
        setCompanyUID(uid)
      }

      const response = await fetchAds({
        page,
        limit,
        search: searchTerm,
        status: statusFilter,
        publisher: publisherFilter,
        companyUID: uid,
        dateRange: getDateRangeParams(),
        paymentStatus: paymentFilter
      })
      setData(response.data)
      setTotalItems(response.totalItems)

      const publishersResponse = await fetchPublishers({
        page: 1,
        limit: 1000
      })

      setPublishersList(
        publishersResponse.data.map(pub => pub.name)
      )
    } catch (error) {
      toast.error("Failed to load advertisements")
      setData([])
    } finally {
      setLoading(false)
    }
  }, [page, limit, searchTerm, statusFilter, publisherFilter, dateFilterMode, customDateRange, paymentFilter])

  React.useEffect(() => {
    loadData()
  }, [loadData])

  // Reset page when filters change
  React.useEffect(() => {
    setPage(1)
  }, [searchTerm, statusFilter, publisherFilter, dateFilterMode, customDateRange, paymentFilter])

  // Handlers
  const handleView = async (id: string) => {
    setIsFetchingAd(true)
    const toastId = toast.loading("Fetching advertisement details...")
    try {
      const details = await getAdDetail(id)
      setViewingAd(details)
      setIsViewModalOpen(true)
      toast.dismiss(toastId)
    } catch (err) {
      toast.error("Failed to load advertisement details", { id: toastId })
    } finally {
      setIsFetchingAd(false)
    }
  }

  const handleEdit = (id: string) => {
    navigate(`/admin/ads/${id}/edit`)
  }

  const handlePublish = (id: string, _title: string) => {
    navigate(`/admin/ads/${id}/publish`)
  }

  const handleDuplicate = async (id: string, title: string) => {
    const promise = duplicateAd(id).then(() => loadData())
    toast.promise(promise, {
      loading: 'Duplicating payload...',
      success: `Created copy of "${title}"`,
      error: 'Failed to duplicate ad'
    })
  }

  const requestArchive = (id: string, title: string) => {
    setSelectedAd({ id, title })
    setIsModalOpen(true)
  }

  const confirmArchive = async () => {
    if (!selectedAd) return
    setIsArchiving(true)
    try {
      await archiveAd(selectedAd.id)
      toast.success(`Ad "${selectedAd.title}" has been archived`)
      setIsModalOpen(false)
      loadData()
    } catch (err) {
      toast.error("Failed to archive ad")
    } finally {
      setIsArchiving(false)
      setSelectedAd(null)
    }
  }

  return (
    <div className="min-h-screen bg-gray-50 dark:bg-[#0E1117] transition-colors duration-200">
      <Toaster position="top-right" />

      {/* Main Content */}
      <main className="w-full px-4 sm:px-6 lg:px-8 xl:px-12 py-8 max-w-[1600px] mx-auto">
        <div className="flex flex-col md:flex-row md:items-end justify-between mb-8 gap-4">
          <div>
            <h2 className="text-2xl font-bold text-gray-900 dark:text-white mb-2">Advertisements</h2>
            <p className="text-gray-500 dark:text-gray-400 text-sm md:text-base">
              Manage and monitor all your global ad campaigns from this unified datagrid.
            </p>
          </div>

          <div className="flex items-center gap-3">
            {/* Map View Button */}
            <button
              onClick={() => setIsMapOpen(true)}
              className="flex items-center justify-center gap-2 px-4 py-2.5 text-sm font-medium rounded-xl border border-gray-200 dark:border-gray-700 bg-white dark:bg-[#1C1F26] text-gray-600 dark:text-gray-300 hover:text-brand-600 dark:hover:text-brand-400 hover:border-brand-300 dark:hover:border-brand-700 hover:bg-brand-50 dark:hover:bg-brand-500/10 shadow-sm transition-all"
            >
              <Map className="w-5 h-5" />
              Map View
            </button>

            {/* Create New Ad Button */}
            <button
              onClick={() => navigate("/admin/ads/new")}
              className="flex items-center justify-center gap-2 px-5 py-2.5 bg-brand-500 hover:bg-brand-600 text-white font-semibold rounded-xl shadow-sm shadow-brand-500/20 transition-all active:scale-95"
            >
              <Plus className="w-5 h-5" />
              Create New Ad
            </button>
          </div>
        </div>

        {/* Dynamic Filters Component */}
        <AdsFilters
          searchTerm={searchTerm} setSearchTerm={setSearchTerm}
          statusFilter={statusFilter} setStatusFilter={setStatusFilter}
          publisherFilter={publisherFilter} setPublisherFilter={setPublisherFilter}
          dateFilterMode={dateFilterMode} setDateFilterMode={setDateFilterMode}
          customDateRange={customDateRange} setCustomDateRange={setCustomDateRange}
          publishersList={publishersList}
          paymentFilter={paymentFilter} setPaymentFilter={setPaymentFilter}
        />

        {/* Dynamic Data Grid */}
        <AdsTable
          data={data}
          loading={loading}
          totalItems={totalItems}
          page={page}
          limit={limit}
          onPageChange={setPage}
          onLimitChange={setLimit}
          onView={handleView}
          onEdit={handleEdit}
          onPublish={handlePublish}
          onDuplicate={handleDuplicate}
          onArchive={requestArchive}
        />
      </main>

      {/* Action Modals */}
      <Modal
        isOpen={isModalOpen}
        onClose={() => !isArchiving && setIsModalOpen(false)}
        title="Confirm Archival"
      >
        <div className="text-gray-600 dark:text-gray-300 mb-6">
          Are you sure you want to permanently archive the advertisement{" "}
          <span className="font-semibold text-gray-900 dark:text-white">{selectedAd?.title}</span>?
          <p className="mt-4 text-sm text-amber-700 dark:text-amber-400 bg-amber-50 dark:bg-amber-500/10 p-4 rounded-xl border border-amber-100 dark:border-amber-500/20 font-medium">
            ⚠️ Archiving an ad immediately pulls it from public rotation without exception. Analytics will be preserved in historical aggregates.
          </p>
        </div>
        <div className="flex justify-end gap-3 font-medium">
          <button
            onClick={() => setIsModalOpen(false)}
            disabled={isArchiving}
            className="px-4 py-2 text-gray-600 hover:bg-gray-100 dark:text-gray-300 dark:hover:bg-gray-800 rounded-lg transition-colors border border-gray-200 dark:border-gray-700"
          >
            Cancel
          </button>
          <button
            onClick={confirmArchive}
            disabled={isArchiving}
            className="px-6 py-2 text-white bg-red-500 hover:bg-red-600 shadow-sm shadow-red-500/20 rounded-lg transition-colors disabled:opacity-50 flex items-center justify-center min-w-[120px]"
          >
            {isArchiving ? (
              <span className="flex items-center gap-2"><Loader2 className="w-4 h-4 animate-spin" /> Archiving...</span>
            ) : "Archive Ad"}
          </button>
        </div>
      </Modal>

      {/* Map View Modal */}
      <MapView
        isOpen={isMapOpen}
        onClose={() => setIsMapOpen(false)}
        companyUID={companyUID}
      />

      {/* View Ad Details Modal */}
      <Modal
        isOpen={isViewModalOpen}
        onClose={() => setIsViewModalOpen(false)}
        title="Advertisement Details"
        maxWidth="max-w-2xl"
      >
        {viewingAd && (
          <div className="space-y-6">
            {/* Header / Meta */}
            <div className="flex flex-col sm:flex-row justify-between gap-4 border-b border-gray-100 dark:border-gray-800 pb-4">
              <div>
                <h4 className="text-xl font-bold text-gray-900 dark:text-white">{viewingAd.title}</h4>
                <p className="text-xs text-gray-500 dark:text-gray-400 mt-1">UID: {viewingAd.uid}</p>
              </div>
              <div className="flex items-center gap-2">
                <span className={`inline-flex items-center px-2.5 py-1 rounded-full text-xs font-semibold ${viewingAd.status === 'Active'
                  ? 'bg-green-100 text-green-700 dark:bg-green-500/20 dark:text-green-400'
                  : viewingAd.status === 'Suspended'
                    ? 'bg-red-100 text-red-700 dark:bg-red-500/20 dark:text-red-400'
                    : viewingAd.status === 'Pending'
                      ? 'bg-amber-100 text-amber-700 dark:bg-amber-500/20 dark:text-amber-400'
                      : 'bg-gray-100 text-gray-700 dark:bg-gray-500/20 dark:text-gray-400'
                  }`}>
                  {viewingAd.status || 'Draft'}
                </span>
                <span className="text-sm text-gray-500 dark:text-gray-400">
                  {viewingAd.prefix && `#${viewingAd.prefix}-${viewingAd.sequenceNumber}`}
                </span>
              </div>
            </div>

            {/* Main Details Grid */}
            <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
              <div className="space-y-4">
                <div>
                  <label className="block text-xs font-semibold text-gray-400 dark:text-gray-500 uppercase tracking-wider mb-1">Description</label>
                  <p className="text-sm text-gray-700 dark:text-gray-300 leading-relaxed bg-gray-50 dark:bg-[#1C1F26] p-3 rounded-xl border border-gray-100 dark:border-gray-800">{viewingAd.description || 'No description provided.'}</p>
                </div>

                <div className="grid grid-cols-2 gap-4">
                  <div>
                    <label className="block text-xs font-semibold text-gray-400 dark:text-gray-500 uppercase tracking-wider mb-1">Start Date</label>
                    <p className="text-sm font-medium text-gray-900 dark:text-gray-200">
                      {viewingAd.startDate ? new Date(viewingAd.startDate).toLocaleDateString() : 'N/A'}
                    </p>
                  </div>
                  <div>
                    <label className="block text-xs font-semibold text-gray-400 dark:text-gray-500 uppercase tracking-wider mb-1">End Date</label>
                    <p className="text-sm font-medium text-gray-900 dark:text-gray-200">
                      {viewingAd.endDate ? new Date(viewingAd.endDate).toLocaleDateString() : 'N/A'}
                    </p>
                  </div>
                </div>

                {viewingAd.company && (
                  <div>
                    <label className="block text-xs font-semibold text-gray-400 dark:text-gray-500 uppercase tracking-wider mb-1">Company</label>
                    <div className="flex items-center gap-3 bg-gray-50 dark:bg-[#1C1F26] p-3 rounded-xl border border-gray-100 dark:border-gray-800">
                      {viewingAd.company.companyLogo?.url || viewingAd.company.companyLogo?.s3Location ? (
                        <img
                          src={viewingAd.company.companyLogo?.url || viewingAd.company.companyLogo?.s3Location}
                          alt={viewingAd.company.name}
                          className="w-8 h-8 rounded-lg object-contain bg-white border border-gray-200"
                        />
                      ) : (
                        <div className="w-8 h-8 rounded-lg bg-brand-100 text-brand-700 flex items-center justify-center font-bold text-xs uppercase">
                          {viewingAd.company.name?.substring(0, 2)}
                        </div>
                      )}
                      <div>
                        <p className="text-sm font-semibold text-gray-900 dark:text-white">{viewingAd.company.name}</p>
                        <p className="text-xs text-gray-500 dark:text-gray-400">{viewingAd.company.email}</p>
                      </div>
                    </div>
                  </div>
                )}

                {viewingAd.cta && viewingAd.cta.buttons && viewingAd.cta.buttons.length > 0 && (
                  <div>
                    <label className="block text-xs font-semibold text-gray-400 dark:text-gray-500 uppercase tracking-wider mb-1">Call-To-Action</label>
                    <div className="bg-gray-50 dark:bg-[#1C1F26] p-3 rounded-xl border border-gray-100 dark:border-gray-800 space-y-2">
                      <p className="text-xs text-gray-500">CTA Type: <span className="font-semibold">{viewingAd.cta.ctaType || 'Button'}</span></p>
                      {viewingAd.cta.buttons.map((btn: any, idx: number) => {
                        const content = btn?.content || btn;
                        return (
                          <div key={idx} className="flex items-center justify-between border-t border-gray-100 dark:border-gray-800 pt-2 first:border-0 first:pt-0">
                            <span className="text-sm font-medium text-gray-800 dark:text-gray-300">{content.label}</span>
                            <span className="text-xs bg-brand-50 text-brand-600 dark:bg-brand-500/10 dark:text-brand-400 px-2 py-0.5 rounded font-mono truncate max-w-[150px]">{content.action}</span>
                          </div>
                        );
                      })}
                    </div>
                  </div>
                )}
              </div>

              {/* Creative Preview / Right Column */}
              <div className="flex flex-col space-y-4">
                <label className="block text-xs font-semibold text-gray-400 dark:text-gray-500 uppercase tracking-wider">Creative Preview</label>

                {/* Media Preview Box */}
                <div className="flex-1 min-h-[220px] bg-gray-100 dark:bg-[#0E1117] rounded-2xl overflow-hidden border border-gray-200 dark:border-gray-800 flex items-center justify-center relative group">
                  {viewingAd.thumbnail?.url || viewingAd.thumbnail?.s3Location ? (
                    <img
                      src={viewingAd.thumbnail.url || viewingAd.thumbnail.s3Location}
                      alt="Thumbnail Preview"
                      className="w-full h-full object-contain max-h-[300px]"
                    />
                  ) : viewingAd.content?.videoLink ? (
                    <div className="w-full h-full flex flex-col items-center justify-center p-4">
                      {viewingAd.content.videoType === 'VIDEO' ? (
                        <video
                          src={viewingAd.content.videoLink}
                          controls
                          className="w-full max-h-[260px] rounded-lg"
                        />
                      ) : (
                        <a
                          href={viewingAd.content.videoLink}
                          target="_blank"
                          rel="noopener noreferrer"
                          className="text-brand-500 hover:text-brand-600 text-sm font-semibold flex flex-col items-center gap-2 bg-white dark:bg-[#1C1F26] p-4 rounded-xl border border-gray-200 dark:border-gray-800 shadow-sm"
                        >
                          <svg className="w-8 h-8 text-red-500" fill="currentColor" viewBox="0 0 24 24"><path d="M23.498 6.163a3.003 3.003 0 0 0-2.11-2.107C19.505 3.545 12 3.545 12 3.545s-7.505 0-9.388.511a3.002 3.002 0 0 0-2.11 2.107C0 8.053 0 12 0 12s0 3.947.502 5.837a3.003 3.003 0 0 0 2.11 2.107c1.883.511 9.388.511 9.388.511s7.505 0 9.388-.511a3.002 3.002 0 0 0 2.11-2.107c.502-1.89.502-5.837.502-5.837s0-3.947-.502-5.837zM9.545 15.568V8.432L15.818 12l-6.273 3.568z" /></svg>
                          Play Video Link
                        </a>
                      )}
                    </div>
                  ) : (
                    <div className="text-gray-400 dark:text-gray-500 text-sm">No creative thumbnail or video link</div>
                  )}
                </div>

                {/* Banner list if Banner Ad */}
                {viewingAd.content?.banners && viewingAd.content.banners.length > 0 && (
                  <div>
                    <label className="block text-xs font-semibold text-gray-400 dark:text-gray-500 uppercase tracking-wider mb-2">Banners ({viewingAd.content.banners.length})</label>
                    <div className="grid grid-cols-4 gap-2">
                      {viewingAd.content.banners.map((bannerUrl: string, bIdx: number) => (
                        <div key={bIdx} className="aspect-square bg-gray-100 rounded-lg overflow-hidden border border-gray-200">
                          <img src={bannerUrl} alt={`Banner ${bIdx + 1}`} className="w-full h-full object-cover" />
                        </div>
                      ))}
                    </div>
                  </div>
                )}
              </div>
            </div>

            {/* Custom Sections */}
            {viewingAd.customTextSection && viewingAd.customTextSection.filter((s: any) => s.title !== 'assigned_publishers').length > 0 && (
              <div className="border-t border-gray-100 dark:border-gray-800 pt-6">
                <label className="block text-xs font-semibold text-gray-400 dark:text-gray-500 uppercase tracking-wider mb-3">Custom Details</label>
                <div className="space-y-4">
                  {viewingAd.customTextSection
                    .filter((section: any) => section.title !== 'assigned_publishers')
                    .map((section: any, sIdx: number) => (
                      <div key={sIdx} className="bg-gray-50 dark:bg-[#1C1F26] p-4 rounded-xl border border-gray-100 dark:border-gray-800">
                        <h5 className="text-sm font-bold text-gray-900 dark:text-white mb-1.5">{section.title}</h5>
                        <p className="text-sm text-gray-600 dark:text-gray-400 leading-relaxed">{section.description}</p>
                      </div>
                    ))}
                </div>
              </div>
            )}

            {/* Actions / Close */}
            <div className="flex justify-end pt-4 border-t border-gray-100 dark:border-gray-800">
              <button
                onClick={() => setIsViewModalOpen(false)}
                className="px-6 py-2.5 bg-gray-100 hover:bg-gray-200 text-gray-700 dark:bg-[#1C1F26] dark:hover:bg-gray-800 dark:text-gray-300 font-semibold rounded-xl transition-colors"
              >
                Close
              </button>
            </div>
          </div>
        )}
      </Modal>
    </div>
  )
}