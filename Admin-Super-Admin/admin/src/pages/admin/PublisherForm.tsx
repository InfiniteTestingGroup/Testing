import * as React from "react"
import { useParams, useNavigate } from "react-router-dom"
import { useForm, FormProvider } from "react-hook-form"
import { zodResolver } from "@hookform/resolvers/zod"
import { ArrowLeft, Save, Loader2, RefreshCw } from "lucide-react"
import toast, { Toaster } from "react-hot-toast"
import { publisherSchema, type PublisherFormData } from "../../schemas/publisherSchema"
import { PublisherFormFields } from "../../components/publisher/PublisherFormFields"
import { getPublisherById, createPublisher, updatePublisher } from "../../services/publishers"
import { Modal } from "../../components/ui/Modal"

export default function PublisherForm() {
  const { id } = useParams()
  const navigate = useNavigate()
  const isEditMode = !!id

  const [loading, setLoading] = React.useState(isEditMode)
  const [isSubmitting, setIsSubmitting] = React.useState(false)
  const [showCancelPrompt, setShowCancelPrompt] = React.useState(false)

  const methods = useForm<PublisherFormData>({
    resolver: zodResolver(publisherSchema) as any,
    defaultValues: {
      name: "",
      contactPerson: "",
      email: "",
      mobile: "",
      address: "",
      latitude: undefined,
      longitude: undefined,
    } as unknown as PublisherFormData
  })

  React.useEffect(() => {
    if (isEditMode && id) {
      const loadPublisher = async () => {
        try {
          const data = await getPublisherById(id)

          // Parse lat/lng from "lat, lng" location string
          let latitude: number | undefined
          let longitude: number | undefined
          if (data.location) {
            const parts = data.location.split(',')
            if (parts.length >= 2) {
              const parsedLat = parseFloat(parts[0].trim())
              const parsedLng = parseFloat(parts[1].trim())
              if (!isNaN(parsedLat)) latitude = parsedLat
              if (!isNaN(parsedLng)) longitude = parsedLng
            }
          }

          methods.reset({
            name: data.name,
            contactPerson: data.contactPerson,
            email: data.email,
            mobile: data.mobile.replace(/[^0-9]/g, '').slice(-10),
            address: data.address || '',
            latitude,
            longitude,
          })
        } catch (error) {
          toast.error("Failed to load publisher data")
          navigate("/admin/publishers")
        } finally {
          setLoading(false)
        }
      }
      loadPublisher()
    }
  }, [id, isEditMode, methods, navigate])

  const handleCancelClick = () => {
    if (methods.formState.isDirty) {
      setShowCancelPrompt(true);
    } else {
      navigate('/admin/publishers');
    }
  }

  const onSubmit = async (data: PublisherFormData) => {
    console.log('Submitting publisher data:', data);
    setIsSubmitting(true);
    try {
      const payload = {
        ...data,
        location:
          data.latitude !== undefined && data.longitude !== undefined
            ? `${data.latitude}, ${data.longitude}`
            : data.address,
      };
      if (isEditMode && id) {
        await updatePublisher(id, payload);
        toast.success('Publisher updated successfully');
      } else {
        await createPublisher(payload);
        toast.success('Publisher created successfully!');
      }
      navigate('/admin/publishers');
    } catch (error) {
      console.error('Error submitting publisher:', error);
      toast.error('Something went wrong. Please try again.');
    } finally {
      setIsSubmitting(false);
    }
  }

  if (loading) {
    return (
      <div className="min-h-screen bg-gray-50 dark:bg-[#0E1117] flex items-center justify-center">
        <Loader2 className="w-8 h-8 text-brand-500 animate-spin" />
      </div>
    )
  }

  return (
    <div className="min-h-screen bg-gray-50 dark:bg-[#0E1117] pb-12 transition-colors">
      <Toaster position="top-right" />
      
      {/* Header */}
      <div className="bg-white dark:bg-[#1A1D24] border-b border-gray-200 dark:border-gray-800 sticky top-0 z-40 shadow-sm transition-colors">
        <div className="max-w-4xl mx-auto px-4 sm:px-6 py-4 flex items-center justify-between">
          <div className="flex items-center gap-4">
            <button
              type="button"
              onClick={handleCancelClick}
              className="p-2 -ml-2 text-gray-500 hover:text-gray-900 dark:hover:text-white rounded-lg hover:bg-gray-100 dark:hover:bg-gray-800 transition-colors"
            >
              <ArrowLeft className="w-5 h-5" />
            </button>
            <h1 className="text-xl font-bold text-gray-900 dark:text-white tracking-tight">
              {isEditMode ? "Edit Publisher" : "Add New Publisher"}
            </h1>
          </div>
          
          <div className="flex items-center gap-3">
            <button
              type="button"
              onClick={() => methods.reset()}
              disabled={isSubmitting || !methods.formState.isDirty}
              className="hidden sm:flex items-center gap-2 px-4 py-2 text-gray-600 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-gray-800 rounded-lg text-sm font-medium transition-colors disabled:opacity-50"
            >
              <RefreshCw className="w-4 h-4" /> Reset
            </button>
            <button
              onClick={methods.handleSubmit(onSubmit)}
              disabled={isSubmitting}
              className="flex items-center gap-2 px-6 py-2 bg-brand-500 hover:bg-brand-600 text-white rounded-lg text-sm font-semibold shadow-sm shadow-brand-500/20 transition-all disabled:opacity-70 disabled:cursor-not-allowed"
            >
              {isSubmitting ? <Loader2 className="w-4 h-4 animate-spin" /> : <Save className="w-4 h-4" />}
              {isSubmitting ? "Saving..." : "Save Publisher"}
            </button>
          </div>
        </div>
      </div>

      {/* Main Form */}
      <div className="max-w-4xl mx-auto px-4 sm:px-6 pt-8">
        <FormProvider {...methods}>
          <form id="publisher-form" onSubmit={methods.handleSubmit(onSubmit)}>
            <PublisherFormFields />
          </form>
        </FormProvider>
      </div>

      {/* Dirty State Modal */}
      <Modal
        isOpen={showCancelPrompt}
        onClose={() => setShowCancelPrompt(false)}
        title="Discard changes?"
      >
        <p className="text-gray-600 dark:text-gray-300 mb-6">
          You have unsaved changes. Are you sure you want to discard them and go back to the publisher list?
        </p>
        <div className="flex justify-end gap-3 font-medium">
          <button
            onClick={() => setShowCancelPrompt(false)}
            className="px-4 py-2 text-gray-600 hover:bg-gray-100 dark:text-gray-300 dark:hover:bg-gray-800 rounded-lg transition-colors border border-gray-200 dark:border-gray-700"
          >
            Keep Editing
          </button>
          <button
            onClick={() => navigate("/admin/publishers")}
            className="px-6 py-2 bg-red-500 hover:bg-red-600 text-white rounded-lg transition-colors shadow-sm shadow-red-500/20"
          >
            Discard Changes
          </button>
        </div>
      </Modal>
    </div>
  )
}
