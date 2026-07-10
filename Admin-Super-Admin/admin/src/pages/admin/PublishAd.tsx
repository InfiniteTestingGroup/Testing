import * as React from "react"
import { useNavigate, useParams, useLocation } from "react-router-dom"
import { useForm, Controller } from "react-hook-form"
import { zodResolver } from "@hookform/resolvers/zod"
import { ArrowLeft, Loader2, MapPin, Crosshair, HelpCircle } from "lucide-react"
import toast, { Toaster } from "react-hot-toast"
import { getAdById, fetchPublisherNames, finalizeAdPublication, updateAdPublicationDetails, type Advertisement } from "../../services/ads"
import { publishSchema, type PublishFormData } from "../../schemas/publishSchema"
import { DatePicker } from "../../components/ui/DatePicker"
import { MultiSelect } from "../../components/ui/MultiSelect"
import { AdSummaryCard } from "../../components/ads/AdSummaryCard"
export default function PublishAd() {
  const { id } = useParams()
  const location = useLocation()
  const navigate = useNavigate()

  const {
    latitude,
    longitude,
    radius,
  } = (location.state as any) || {}

  console.log("Location state:", location.state)
  console.log("Latitude:", latitude)
  console.log("Longitude:", longitude)
  console.log("Radius:", radius)

  const [ad, setAd] = React.useState<Advertisement | null>(null)
  const [publishers, setPublishers] = React.useState<{ id: string, name: string }[]>([])
  const [loading, setLoading] = React.useState(true)
  const { register, control, handleSubmit, watch, formState: { errors, isSubmitting } } = useForm<PublishFormData>({
    resolver: zodResolver(publishSchema),
    defaultValues: {
      startDate: new Date().toISOString().split("T")[0],
      endDate: "",
      publisherIds: []
    }
  })
  const formData = watch()
  // Data Loading
  React.useEffect(() => {
    async function load() {
      if (!id) return
      const [adResult, pubsResult] = await Promise.allSettled([
        getAdById(id),
        fetchPublisherNames()
      ])

      if (adResult.status === 'fulfilled') {
        setAd(adResult.value)
      } else {
        console.warn('[PublishAd] getAdById failed:', adResult.reason)
        // Use a placeholder so the publish form is still fully usable
        setAd({
          id,
          title: 'Your Advertisement',
          publishers: [],
          status: 'Draft',
          startDate: '',
          endDate: '',
          impressions: 0,
          clicks: 0,
          ctr: 0,
          paymentStatus: 'Pending',
        })
      }

      if (pubsResult.status === 'fulfilled') {
        setPublishers(pubsResult.value)
      } else {
        console.warn('[PublishAd] fetchPublisherNames failed:', pubsResult.reason)
        toast.error('Could not load publisher list — you can still proceed to payment.', { id: 'pub-err' })
        setPublishers([])
      }

      setLoading(false)
    }
    load()
  }, [id])

  // Calculation logic
  const days = React.useMemo(() => {
    if (!formData.startDate || !formData.endDate) return 0
    const start = new Date(formData.startDate)
    const end = new Date(formData.endDate)
    const diffTime = end.getTime() - start.getTime()
    return Math.max(0, Math.ceil(diffTime / (1000 * 60 * 60 * 24)))
  }, [formData.startDate, formData.endDate])
  // Locked targeting constraints shown on the page

  const onSubmit = async (data: PublishFormData) => {
    const costAmount = Math.max(1, days * 1 * data.publisherIds.length)
    try {
      localStorage.setItem(`assigned_publishers_${id}`, JSON.stringify(data.publisherIds))
      
      // Update dates and publisher IDs in customTextSection in MongoDB
      const existingSections = ad.customTextSection || []
      const filteredSections = existingSections.filter((s: any) => s.title !== 'assigned_publishers')
      const updatedSections = [
        ...filteredSections,
        {
          title: 'assigned_publishers',
          description: JSON.stringify(data.publisherIds)
        }
      ]

      await updateAdPublicationDetails(id!, {
        startDate: new Date(data.startDate).toISOString(),
        endDate: new Date(data.endDate).toISOString(),
        customTextSection: updatedSections
      })

      // Create the campaign with proper geo-targeting payload and ISO dates
      await finalizeAdPublication(id!, {
        startDate: new Date(data.startDate).toISOString(),
        endDate: new Date(data.endDate).toISOString(),
        latitude,
        longitude,
        radiusKm: radius,
        locationName: "Selected Target Area",
      })
      toast.success("Publication saved! Proceeding to payment...")
      navigate(`/admin/ads/${id}/pay`, { state: { cost: costAmount } })
    } catch (err: any) {
      console.error("[PublishAd] finalizeAdPublication error:", err)
      localStorage.setItem(`assigned_publishers_${id}`, JSON.stringify(data.publisherIds))
      toast.error("Warning: Could not sync changes. Proceeding to checkout...")
      navigate(`/admin/ads/${id}/pay`, { state: { cost: costAmount } })
    }
  }
  if (loading || !ad) {
    return (
      <div className="min-h-screen bg-gray-50 dark:bg-[#0E1117] flex items-center justify-center">
        <Loader2 className="w-10 h-10 text-brand-500 animate-spin" />
      </div>
    )
  }
  return (
    <div className="min-h-screen bg-gray-50 dark:bg-[#0E1117] pb-16 transition-colors duration-200">
      <Toaster position="top-right" />

      {/* Header */}
      <header className="sticky top-0 z-40 bg-white/80 dark:bg-[#1C1F26]/80 backdrop-blur-md border-b border-gray-200 dark:border-gray-800">
        <div className="max-w-[1200px] mx-auto px-4 py-4 flex items-center gap-4">
          <button
            onClick={() => navigate(`/admin/ads/${id}/edit`)}
            className="p-2 text-gray-500 hover:text-gray-900 dark:hover:text-white hover:bg-gray-100 dark:hover:bg-gray-800 rounded-lg transition-colors"
          >
            <ArrowLeft className="w-5 h-5" />
          </button>
          <div>
            <h1 className="text-lg font-bold text-gray-900 dark:text-white leading-tight">Publish Advertisement</h1>
            <p className="text-xs text-gray-500 font-medium">Step 4 of 4: Finalize & Pay</p>
          </div>
        </div>
      </header>
      <main className="max-w-[1200px] mx-auto px-4 py-8">
        <div className="grid grid-cols-1 lg:grid-cols-12 gap-8 items-start">

          {/* Left: Configuration */}
          <div className="lg:col-span-8 space-y-6">

            {/* 1. Assignment */}
            <section className="bg-white dark:bg-[#1A1D24] p-6 rounded-2xl border border-gray-200 dark:border-gray-800 shadow-sm transition-colors">
              <h2 className="text-sm font-black text-gray-400 uppercase tracking-widest mb-6 flex items-center gap-2">
                <span className="flex items-center justify-center w-5 h-5 rounded-full bg-brand-500 text-white text-[10px]">1</span>
                Network Assignment
              </h2>
              <Controller
                name="publisherIds"
                control={control}
                render={({ field }) => (
                  <MultiSelect
                    label="Assign Publishers"
                    options={publishers}
                    selectedIds={field.value}
                    onChange={field.onChange}
                    error={errors.publisherIds?.message}
                  />
                )}
              />
              <p className="mt-4 text-xs text-gray-500 leading-relaxed italic bg-gray-50 dark:bg-[#1C1F26] p-4 rounded-xl border border-gray-100 dark:border-gray-800">
                <HelpCircle className="w-3.5 h-3.5 inline mr-1 mb-0.5 text-brand-500" />
                Selected publishers will receive this ad content for their allocated slots. You can add more publishers later from the dashboard.
              </p>
            </section>
            {/* 2. Duration */}
            <section className="bg-white dark:bg-[#1A1D24] p-6 rounded-2xl border border-gray-200 dark:border-gray-800 shadow-sm transition-colors">
              <h2 className="text-sm font-black text-gray-400 uppercase tracking-widest mb-6 flex items-center gap-2">
                <span className="flex items-center justify-center w-5 h-5 rounded-full bg-brand-500 text-white text-[10px]">2</span>
                Campaign Duration
              </h2>
              <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                <DatePicker
                  label="Activation Date"
                  error={errors.startDate?.message}
                  {...register("startDate")}
                />
                <DatePicker
                  label="Deactivation Date"
                  error={errors.endDate?.message}
                  {...register("endDate")}
                />
              </div>
            </section>
            {/* 3. Targeting Review */}
            <section className="bg-white dark:bg-[#1A1D24] p-6 rounded-2xl border border-dotted border-gray-300 dark:border-gray-700 transition-colors opacity-90">
              <h2 className="text-sm font-black text-gray-400 uppercase tracking-widest mb-6 flex items-center gap-2">
                Targeting Constraints (Locked)
              </h2>
              <div className="grid grid-cols-2 gap-6 text-sm">
                <div className="flex items-center gap-3">
                  <div className="p-2 bg-gray-100 dark:bg-gray-800 rounded-lg"><MapPin className="w-4 h-4 text-gray-500" /></div>
                  <div>
                    <p className="text-xs text-gray-500 font-bold uppercase tracking-tighter">Coordinates</p>
                    <p className="font-medium text-gray-700 dark:text-gray-300 tabular-nums">{latitude?.toFixed(4)}, {longitude?.toFixed(4)}</p>
                  </div>
                </div>
                <div className="flex items-center gap-3">
                  <div className="p-2 bg-gray-100 dark:bg-gray-800 rounded-lg"><Crosshair className="w-4 h-4 text-gray-500" /></div>
                  <div>
                    <p className="text-xs text-gray-500 font-bold uppercase tracking-tighter">Coverage Radius</p>
                    <p className="font-medium text-gray-700 dark:text-gray-300">{radius} KM Radius</p>
                  </div>
                </div>
              </div>
            </section>
          </div>
          {/* Right: Summary */}
          <aside className="lg:col-span-4">
            <AdSummaryCard
              ad={ad}
              days={days}
              numPublishers={formData.publisherIds.length}
              costPerDay={1} // ₹365 / 365
              onPublish={handleSubmit(onSubmit)}
              isSubmitting={isSubmitting}
            />
          </aside>
        </div>
      </main>
    </div>
  )
}
