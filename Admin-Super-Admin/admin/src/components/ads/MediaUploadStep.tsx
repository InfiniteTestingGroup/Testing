import * as React from "react"
import { useFormContext } from "react-hook-form"
import { motion, AnimatePresence } from "framer-motion"
import { Type, AlertCircle } from "lucide-react"

import { BannerUploader } from "./BannerUploader"
import { VideoUploader } from "./VideoUploader"
import { ImageAdUpload } from "./ImageAdUpload"

// ─────────────────────────────────────────────
// Types for local media state (stored outside RHF)
// ─────────────────────────────────────────────
export interface MediaState {
  bannerFiles: File[]
  bannerThumbnailIndex: number // Index of selected thumbnail for banner ads
  videoFile: File | null
  videoUrl: string
  videoThumbnail: File | null // Thumbnail file for video ads
  imageAd: File | null
}

interface MediaUploadStepProps {
  mediaState: MediaState
  setMediaState: React.Dispatch<React.SetStateAction<MediaState>>
  validationErrors: { [key: string]: string }
}

export function MediaUploadStep({ mediaState, setMediaState, validationErrors }: MediaUploadStepProps) {
  const { watch } = useFormContext()
  const adType: string = watch("type") // "Banner" | "Video" | "Image Ad"

  const isVideoAd   = adType === "Video"
  const isBannerAd  = adType === "Banner"
  const isImageAd   = adType === "Image Ad" 

  const adTypeLabel = isVideoAd ? "Video" : isBannerAd ? "Banner" : "Image Ad"

  return (
    <div className="space-y-6">
      {/* Header */}
      <div>
        <h2 className="text-xl font-bold text-gray-900 dark:text-white">Upload Ad Media</h2>
        <p className="text-sm text-gray-500 dark:text-gray-400 mt-1">
          You selected an{" "}
          <span className="font-bold text-brand-500">{adTypeLabel}</span> ad.{" "}
          {isVideoAd && "Upload a video file or paste a URL, then add an image ad (thumbnail)."}
          {isBannerAd && "Upload 1–4 banner images and an image ad (thumbnail)."}
          {isImageAd && "Upload a single high-quality visual for your image ad."}
        </p>
      </div>

      {/* ── Image Ad ── */}
      {isImageAd && (
        <motion.div
          key="image-ad"
          initial={{ opacity: 0, y: 12 }}
          animate={{ opacity: 1, y: 0 }}
          exit={{ opacity: 0, y: -12 }}
          transition={{ duration: 0.25 }}
        >
          <ImageAdUpload
            imageAd={mediaState.imageAd}
            onImageAdChange={(file) => setMediaState(s => ({ ...s, imageAd: file }))}
            error={validationErrors.imageAd}
          />
        </motion.div>
      )}

      {/* ── Video Ad ── */}
      <AnimatePresence mode="wait">
        {isVideoAd && (
          <motion.div
            key="video"
            initial={{ opacity: 0, y: 12 }}
            animate={{ opacity: 1, y: 0 }}
            exit={{ opacity: 0, y: -12 }}
            transition={{ duration: 0.25 }}
            className="space-y-4"
          >
            <VideoUploader
              videoFile={mediaState.videoFile}
              videoUrl={mediaState.videoUrl}
              videoThumbnail={mediaState.videoThumbnail}
              onFileChange={(file) => setMediaState(s => ({ ...s, videoFile: file }))}
              onUrlChange={(url) => setMediaState(s => ({ ...s, videoUrl: url }))}
              onThumbnailChange={(file) => setMediaState(s => ({ ...s, videoThumbnail: file }))}
              error={validationErrors.video}
            />
          </motion.div>
        )}

        {/* ── Banner Ad ── */}
        {isBannerAd && (
          <motion.div
            key="banner"
            initial={{ opacity: 0, y: 12 }}
            animate={{ opacity: 1, y: 0 }}
            exit={{ opacity: 0, y: -12 }}
            transition={{ duration: 0.25 }}
            className="space-y-4"
          >
            <BannerUploader
              files={mediaState.bannerFiles}
              onFilesChange={(files) => setMediaState(s => ({ ...s, bannerFiles: files }))}
              onThumbnailChange={(index) => setMediaState(s => ({ ...s, bannerThumbnailIndex: index }))}
              thumbnailIndex={mediaState.bannerThumbnailIndex}
              error={validationErrors.banner}
            />
          </motion.div>
        )}
      </AnimatePresence>

      {/* Global error (fallback) */}
      {validationErrors.general && (
        <div className="flex items-center gap-2 p-3 rounded-xl bg-red-50 dark:bg-red-500/10 text-red-600 dark:text-red-400 text-sm font-medium border border-red-100 dark:border-red-900/30">
          <AlertCircle className="w-5 h-5 flex-shrink-0" />
          {validationErrors.general}
        </div>
      )}
    </div>
  )
}
