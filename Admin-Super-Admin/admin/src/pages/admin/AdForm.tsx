import * as React from "react"
import { useNavigate, useParams } from "react-router-dom"
import { useForm, FormProvider } from "react-hook-form"
import { zodResolver } from "@hookform/resolvers/zod"
import { ArrowLeft, Save, Send, Loader2 } from "lucide-react"
import toast, { Toaster } from "react-hot-toast"
import { motion, AnimatePresence } from "framer-motion"

import { adSchema, type AdFormData } from "../../schemas/adSchema"
import { getAdById, createAd, updateAd, uploadMedia } from "../../services/ads"

import { AdStepper } from "../../components/ads/AdStepper"
import { AdDetailsStep } from "../../components/ads/AdDetailsStep"
import { MediaUploadStep, type MediaState } from "../../components/ads/MediaUploadStep"
import { AdFinalDetailsStep } from "../../components/ads/AdFinalDetailsStep"
import { TargetingStep } from "../../components/ads/TargetingStep"


const STEPS = ["Ad Options", "Media Upload", "Ad Details", "Geo-Targeting"]

export default function AdForm() {
  const { id } = useParams()
  const navigate = useNavigate()
  const isEditMode = !!id

  const [currentStep, setCurrentStep] = React.useState(0)
  const [loading, setLoading] = React.useState(isEditMode)

  const [mediaState, setMediaState] = React.useState<MediaState>({
    bannerFiles: [],
    bannerThumbnailIndex: 0, // Default to first image as thumbnail
    videoFile: null,
    videoUrl: "",
    videoThumbnail: null,
    imageAd: null,
  })

  const [mediaErrors, setMediaErrors] = React.useState<{ [key: string]: string }>({})

  const methods = useForm<AdFormData>({
    resolver: zodResolver(adSchema),
    defaultValues: {
      title: "",
      description: "",
      type: "Banner",
      companyUID: "",
      mediaFile: null,
      ctaType: "Redirect",
      ctaLabel: "Learn More",
      ctaActionValue: "",
      customSections: [{ title: "", description: "" }],
      locationMode: "manual",
      latitude: 0,
      longitude: 0,
      radius: 10,
    },
  })

  const { trigger, watch, formState: { isSubmitting }, reset } = methods
  const adType = watch("type")

  const [isUploading, setIsUploading] = React.useState(false)
  const [isPublishing, setIsPublishing] = React.useState(false)
  const uploadedMedia = React.useRef({
    imageAdFile: null as File | null,
    imageAdUID: "",
    bannerFiles: [] as File[],
    bannerUIDs: [] as string[],
    videoFile: null as File | null,
    videoUID: ""
  })

  React.useEffect(() => {
    if (currentStep < 1) {
      setMediaState({ bannerFiles: [], bannerThumbnailIndex: 0, videoFile: null, videoUrl: "", videoThumbnail: null, imageAd: null })
      setMediaErrors({})
    }
  }, [adType])


  React.useEffect(() => {
    async function load() {
      if (!id) return
      try {
        const ad = await getAdById(id)
        reset({
          title: ad.title,
          description: "This is a drafted description.",
          type: "Banner",
          ctaType: "Redirect",
          ctaLabel: "Learn More",
          ctaActionValue: "",
          customSections: [{ title: "Welcome", description: "Hello world" }],
          locationMode: "manual",
          radius: 25,
          latitude: 19.0760,
          longitude: 72.8777,
        })
      } catch (err) {
        toast.error("Failed to load draft.")
        navigate("/admin/ads")
      } finally {
        setLoading(false)
      }
    }
    load()
  }, [id, reset, navigate])

  const validateMediaStep = (): boolean => {
    const errors: { [key: string]: string } = {}

    if (adType === "Video") {
      if (!mediaState.videoFile && !mediaState.videoUrl.trim()) {
        errors.video = "Please upload a video file or enter a video URL."
      }
      if (!mediaState.imageAd) {
        errors.imageAd = "An Image Ad is required for Video ads."
      }
    } else if (adType === "Banner") {
      if (mediaState.bannerFiles.length === 0) {
        errors.banner = "At least 1 banner image is required."
      } else if (mediaState.bannerFiles.length > 4) {
        errors.banner = "Maximum 4 banner images allowed."
      }
    } else if (adType === "Image Ad") {
      if (!mediaState.imageAd) {
        errors.imageAd = "Please upload an image for your ad."
      }
    }

    setMediaErrors(errors)
    return Object.keys(errors).length === 0
  }

  const handleNext = async () => {
    let fieldsToValidate: (keyof AdFormData)[] = []

    if (currentStep === 0) {
      fieldsToValidate = ["title", "description", "type"]
    } else if (currentStep === 1) {
      const isValid = validateMediaStep()
      if (!isValid) {
        toast.error("Please complete all required media fields.", { id: "media-err" })
        return
      }

      // ---- UPLOAD LOGIC ----
      setIsUploading(true)
      const uploadToast = toast.loading("Uploading media…")
      try {
        if (adType === "Image Ad" || adType === "Banner" || adType === "Video") {
          if (mediaState.imageAd && uploadedMedia.current.imageAdFile !== mediaState.imageAd) {
            toast.loading("Uploading image ad…", { id: uploadToast })
            uploadedMedia.current.imageAdUID = await uploadMedia(mediaState.imageAd)
            uploadedMedia.current.imageAdFile = mediaState.imageAd
          }
        }

        if (adType === "Banner" && mediaState.bannerFiles.length > 0) {
          const filesChanged = mediaState.bannerFiles.length !== uploadedMedia.current.bannerFiles.length ||
            mediaState.bannerFiles.some((f, i) => f !== uploadedMedia.current.bannerFiles[i])
          if (filesChanged) {
            uploadedMedia.current.bannerUIDs = []
            for (let i = 0; i < mediaState.bannerFiles.length; i++) {
              toast.loading(`Uploading banner ${i + 1} of ${mediaState.bannerFiles.length}…`, { id: uploadToast })
              uploadedMedia.current.bannerUIDs.push(await uploadMedia(mediaState.bannerFiles[i]))
            }
            uploadedMedia.current.bannerFiles = [...mediaState.bannerFiles]
          }
        }

        if (adType === "Video" && mediaState.videoFile) {
          if (uploadedMedia.current.videoFile !== mediaState.videoFile) {
            toast.loading("Uploading video…", { id: uploadToast })
            uploadedMedia.current.videoUID = await uploadMedia(mediaState.videoFile)
            uploadedMedia.current.videoFile = mediaState.videoFile
          }
        }

        toast.success("Media successfully uploaded!", { id: uploadToast })
      } catch (err) {
        setIsUploading(false)
        toast.error("Media upload failed. Please try again.", { id: uploadToast })
        return
      }
      setIsUploading(false)
      // ---- END UPLOAD LOGIC ----

      setCurrentStep(curr => Math.min(curr + 1, STEPS.length - 1))
      return
    } else if (currentStep === 2) {
      fieldsToValidate = ["ctaType", "ctaLabel", "ctaActionValue", "customSections"]
    } else if (currentStep === 3) {
      fieldsToValidate = ["latitude", "longitude", "radius"]
    }

    const isValid = await trigger(fieldsToValidate)
    if (isValid) {
      setCurrentStep(curr => Math.min(curr + 1, STEPS.length - 1))
    } else {
      toast.error("Please fix the validation errors before proceeding", { id: "val-err" })
    }
  }

  const handleBack = () => setCurrentStep(curr => Math.max(curr - 1, 0))

  const onSubmit = async (data: AdFormData, shouldPublish: boolean = false) => {
    const uploadToast = toast.loading(isEditMode ? "Updating draft…" : "Creating draft…")
    try {

      let videoUrl: string | undefined
      if (data.type === "Video" && mediaState.videoUrl.trim()) {
        videoUrl = mediaState.videoUrl.trim()
      }

      const adminUserStr = localStorage.getItem('admin_user')
      let extractedCompanyUID = undefined
      let userObj: Record<string, any> = {}

      if (adminUserStr) {
        try {
          userObj = JSON.parse(adminUserStr)
          // Prioritize the actual UID/ID from the session
          extractedCompanyUID = userObj.companyUID || userObj.companyId || userObj.uid
        } catch (e) {
          console.error("Failed to parse admin user from session", e)
        }
      }

      // If companyUID is still missing, retry lookup from Ad Mobile API
      if (!extractedCompanyUID) {
        console.log('⚠️ companyUID missing from session, retrying lookup from Ad Mobile...')
        try {
          const { adMobileApi } = await import("../../services/api")
          const companyRes = await adMobileApi.get('/v1/company/PRODUCTS_SERVICES', {
            params: { all: 'yes' }
          })
          const allCompanies: any[] = companyRes.data?.data || []
          const adminEmail = userObj.email || userObj.identifier || ''

          // Try matching by email
          let matched = allCompanies.find(
            (c: any) => c?.email?.toLowerCase() === adminEmail.toLowerCase()
          )

          // Try matching by company name
          if (!matched && userObj.company) {
            const adminCompanyLower = userObj.company.toLowerCase()
            matched = allCompanies.find((c: any) =>
              c?.name?.toLowerCase() === adminCompanyLower ||
              c?.name?.toLowerCase().includes(adminCompanyLower) ||
              adminCompanyLower.includes(c?.name?.toLowerCase())
            )
          }

          // Try matching by admin name
          if (!matched && userObj.name) {
            const adminNameLower = userObj.name.toLowerCase()
            matched = allCompanies.find((c: any) =>
              c?.name?.toLowerCase().includes(adminNameLower) ||
              adminNameLower.includes(c?.name?.toLowerCase())
            )
          }

          // Last resort: use the single available company
          if (!matched && allCompanies.length === 1) {
            matched = allCompanies[0]
          }

          if (matched?.uid) {
            extractedCompanyUID = matched.uid
            // Patch localStorage so this doesn't fail again
            const updatedUser = { ...userObj, companyUID: matched.uid }
            localStorage.setItem('admin_user', JSON.stringify(updatedUser))
            console.log('✅ companyUID resolved on retry:', matched.uid)
          }
        } catch (e) {
          console.error('Failed to retry companyUID lookup:', e)
        }
      }

      // If companyUID is STILL missing after retry, block submission
      if (!extractedCompanyUID) {
        toast.error('Company not found. Please contact support or re-register your company.', { id: uploadToast });
        return;
      }

      console.log('AdForm Debug - extractedCompanyUID:', extractedCompanyUID);
      console.log('AdForm Debug - creating ad with companyUID:', extractedCompanyUID);

      const payload = {
        title: data.title,
        description: data.description,
        type: data.type,
        companyUID: extractedCompanyUID,
        imageAdUID: (data.type === "Banner" && uploadedMedia.current.bannerUIDs.length > 0)
          ? uploadedMedia.current.bannerUIDs[0]
          : (uploadedMedia.current.imageAdUID || undefined),
        bannerUIDs: uploadedMedia.current.bannerUIDs,
        videoUID: uploadedMedia.current.videoUID || undefined,
        videoUrl,
        videoType: mediaState.videoFile
          ? "VIDEO"
          : videoUrl?.includes("youtube")
            ? "YOUTUBE"
            : videoUrl?.includes("vimeo")
              ? "VIMEO"
              : "VIDEO",
        ctaType: data.ctaType,
        ctaLabel: data.ctaLabel,
        ctaActionValue: data.ctaActionValue,
        customSections: data.customSections,
      }

      let savedAdId: string | undefined

      if (isEditMode) {
        await updateAd(id, payload)
        savedAdId = id
      } else {
        const result = await createAd(payload)
        savedAdId = result.id
      }

      if (shouldPublish && savedAdId) {
        toast.success("Ad saved! Proceeding to publish configuration...", { id: uploadToast })

        setTimeout(() =>
          navigate(`/admin/ads/${savedAdId}/publish`, {
            state: {
              latitude: data.latitude,
              longitude: data.longitude,
              radius: data.radius,
            },
          }),
          800)
      } else {
        toast.success(isEditMode ? "Draft successfully updated" : "Ad draft created successfully!", { id: uploadToast })
        setTimeout(() => navigate("/admin/ads"), 800)
      }
    } catch (err: any) {
      console.error("[AdForm] Failed to save advertisement:", err)
      toast.error(err?.message || "Failed to save advertisement", { id: uploadToast })
    }
  }

  // ── Pre-bound submit handlers — bypass SubmitHandler generic mismatch ──
  const handleSaveDraft = async () => {
    const isValid = await trigger(["title", "description", "type", "ctaType", "ctaLabel", "ctaActionValue", "customSections", "companyUID"])
    if (isValid) await onSubmit(methods.getValues(), false)
  }
  const handlePublish = async () => {
    if (isPublishing) return
    setIsPublishing(true)
    try {
      const isValid = await trigger()
      if (isValid) await onSubmit(methods.getValues(), true)
    } finally {
      setIsPublishing(false)
    }
  }

  const renderCurrentStep = () => {
    switch (currentStep) {
      case 0: return <AdDetailsStep />
      case 1: return (
        <MediaUploadStep
          mediaState={mediaState}
          setMediaState={setMediaState}
          validationErrors={mediaErrors}
        />
      )
      case 2: return <AdFinalDetailsStep />
      case 3: return <TargetingStep />
      default: return null
    }
  }

  if (loading) {
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
        <div className="max-w-[1000px] mx-auto px-4 sm:px-6 lg:px-8 py-4">
          <div className="flex items-center justify-between">
            <div className="flex items-center gap-4">
              <button
                onClick={() => navigate("/admin/ads")}
                className="p-2 -ml-2 text-gray-500 hover:text-gray-900 dark:hover:text-white hover:bg-gray-100 dark:hover:bg-gray-800 rounded-lg transition-colors focus:outline-none"
              >
                <ArrowLeft className="w-5 h-5" />
              </button>
              <h1 className="text-xl font-bold text-gray-900 dark:text-white">
                {isEditMode ? "Manage Advertisement Draft" : "Launch New Advertisement"}
              </h1>
            </div>

            <div className="flex gap-3">
              <button
                type="button"
                onClick={handleSaveDraft}
                disabled={isSubmitting || isUploading}
                className="flex items-center gap-2 px-4 py-2 text-gray-600 hover:bg-gray-100 dark:text-gray-300 dark:hover:bg-gray-800 rounded-lg transition-colors font-semibold shadow-sm border border-gray-200 dark:border-gray-700 disabled:opacity-50"
              >
                <Save className="w-4 h-4" /> Save Draft
              </button>
            </div>
          </div>
        </div>
      </header>

      <main className="max-w-[800px] mx-auto px-4 sm:px-6 lg:px-8 pt-8">

        {/* Progress Stepper */}
        <AdStepper currentStep={currentStep} steps={STEPS} />

        {/* Form Area */}
        <div className="bg-white dark:bg-[#1A1D24] shadow-sm border border-gray-200 dark:border-gray-800 rounded-2xl overflow-hidden min-h-[480px] flex flex-col transition-colors">
          <FormProvider {...methods}>
            <form className="flex-1 flex flex-col">
              <div className="flex-1 p-6 md:p-8 overflow-y-auto">
                <AnimatePresence mode="wait">
                  <motion.div
                    key={currentStep}
                    initial={{ opacity: 0, x: 20 }}
                    animate={{ opacity: 1, x: 0 }}
                    exit={{ opacity: 0, x: -20 }}
                    transition={{ duration: 0.3 }}
                    className="h-full"
                  >
                    {renderCurrentStep()}
                  </motion.div>
                </AnimatePresence>
              </div>

              {/* Navigation Footer */}
              <div className="px-6 py-4 bg-gray-50 dark:bg-[#1C1F26] border-t border-gray-200 dark:border-gray-800 flex items-center justify-between mt-auto transition-colors">
                <button
                  type="button"
                  onClick={handleBack}
                  disabled={currentStep === 0 || isSubmitting || isUploading}
                  className="px-6 py-2 text-brand-500 hover:text-brand-600 font-semibold disabled:opacity-30 disabled:cursor-not-allowed transition-opacity"
                >
                  Back
                </button>

                {currentStep === STEPS.length - 1 ? (
                  <div className="flex items-center gap-3">
                    <button
                      type="button"
                      onClick={handlePublish}
                      disabled={isPublishing || isSubmitting || isUploading}
                      className="flex items-center gap-2 px-8 py-2.5 bg-brand-500 hover:bg-brand-600 text-white rounded-lg text-sm font-semibold shadow-sm shadow-brand-500/20 transition-all disabled:opacity-70 disabled:cursor-not-allowed"
                    >
                      {isPublishing ? <Loader2 className="w-4 h-4 animate-spin" /> : <Send className="w-4 h-4" />}
                      {isPublishing ? 'Publishing...' : 'Publish Campaign'}
                    </button>
                  </div>
                ) : (
                  <div className="flex items-center gap-3">
                    {currentStep === 2 && (
                      <button
                        type="button"
                        onClick={handleSaveDraft}
                        disabled={isSubmitting || isUploading}
                        className="px-6 py-2.5 bg-white dark:bg-[#1A1D24] text-gray-700 dark:text-gray-300 border border-gray-200 dark:border-gray-700 hover:bg-gray-50 dark:hover:bg-gray-800 rounded-lg text-sm font-semibold shadow-sm transition-all disabled:opacity-50"
                      >
                        Save as Draft
                      </button>
                    )}
                    <button
                      type="button"
                      onClick={handleNext}
                      disabled={isUploading}
                      className="flex items-center gap-2 px-8 py-2.5 bg-brand-500 hover:bg-brand-600 text-white rounded-lg text-sm font-semibold shadow-sm shadow-brand-500/20 transition-all disabled:opacity-70 disabled:cursor-not-allowed"
                    >
                      {isUploading && <Loader2 className="w-4 h-4 animate-spin" />}
                      {isUploading ? "Uploading..." : "Continue"}
                    </button>
                  </div>
                )}
              </div>
            </form>
          </FormProvider>
        </div>

      </main>
    </div>
  )
}