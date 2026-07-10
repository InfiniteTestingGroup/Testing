import * as React from "react"
import { Video, Link, X, UploadCloud } from "lucide-react"

interface VideoUploaderProps {
  videoFile: File | null
  videoUrl: string
  videoThumbnail: File | null
  onFileChange: (file: File | null) => void
  onUrlChange: (url: string) => void
  onThumbnailChange: (file: File | null) => void
  error?: string
}

export function VideoUploader({ videoFile, videoUrl, videoThumbnail, onFileChange, onUrlChange, onThumbnailChange, error }: VideoUploaderProps) {
  const [dragActive, setDragActive] = React.useState(false)
  const [previewUrl, setPreviewUrl] = React.useState<string | null>(null)
  const fileInputRef = React.useRef<HTMLInputElement>(null)

  React.useEffect(() => {
    if (videoFile) {
      const url = URL.createObjectURL(videoFile)
      setPreviewUrl(url)
      return () => URL.revokeObjectURL(url)
    } else {
      setPreviewUrl(null)
    }
  }, [videoFile])

  const handleFile = (file: File) => {
    if (!file.type.startsWith("video/")) return
    onFileChange(file)
    onUrlChange("") // clear URL when file is chosen
  }

  const handleDrop = (e: React.DragEvent) => {
    e.preventDefault()
    setDragActive(false)
    if (e.dataTransfer.files?.[0]) handleFile(e.dataTransfer.files[0])
  }

  const handleRemoveFile = () => {
    onFileChange(null)
    if (fileInputRef.current) fileInputRef.current.value = ""
  }

  const isFileLocked = !!videoFile        // URL input disabled when file uploaded
  const isUrlLocked = !!videoUrl.trim()   // File input disabled when URL entered

  return (
    <div className="space-y-3">
      <div className={`rounded-2xl border-2 p-4 transition-all ${
        error
          ? "border-red-400/60 bg-red-500/5"
          : "border-gray-200 dark:border-gray-700 bg-white dark:bg-[#1A1D24]"
      }`}>
        {/* Header */}
        <div className="flex items-center gap-2 mb-4">
          <div className="w-8 h-8 bg-purple-500 rounded-xl flex items-center justify-center">
            <Video className="w-4 h-4 text-white" />
          </div>
          <div>
            <p className="text-sm font-bold text-gray-900 dark:text-white">Video Content</p>
            <p className="text-xs text-gray-400">Upload a file OR paste a URL — not both</p>
          </div>
        </div>

        {/* ── Upload File Section ── */}
        <div className={`transition-all ${isUrlLocked ? "opacity-40 pointer-events-none" : ""}`}>
          {!videoFile ? (
            <label
              className={`flex flex-col items-center justify-center gap-3 w-full border-2 border-dashed rounded-xl px-5 py-8 cursor-pointer transition-all ${
                dragActive
                  ? "border-purple-500 bg-purple-500/5"
                  : "border-gray-200 dark:border-gray-600 hover:border-purple-500 dark:hover:border-purple-400"
              }`}
              onDragEnter={(e) => { e.preventDefault(); setDragActive(true) }}
              onDragLeave={(e) => { e.preventDefault(); setDragActive(false) }}
              onDragOver={(e) => e.preventDefault()}
              onDrop={handleDrop}
            >
              <div className={`w-12 h-12 rounded-full flex items-center justify-center transition-all ${dragActive ? "bg-purple-500" : "bg-gray-100 dark:bg-gray-700"}`}>
                <UploadCloud className={`w-6 h-6 ${dragActive ? "text-white" : "text-gray-400"}`} />
              </div>
              <div className="text-center">
                <p className="text-sm font-semibold text-gray-700 dark:text-gray-200">Drag & drop your video here</p>
                <p className="text-xs text-gray-400 mt-0.5">MP4 supported · Max 50MB</p>
              </div>
              <span className="px-4 py-1.5 border border-gray-200 dark:border-gray-600 text-xs font-semibold text-gray-700 dark:text-gray-300 rounded-lg hover:bg-gray-50 dark:hover:bg-gray-700 transition-colors">
                Browse Files
              </span>
              <input
                ref={fileInputRef}
                type="file"
                className="hidden"
                accept="video/mp4,video/*"
                onChange={(e) => e.target.files?.[0] && handleFile(e.target.files[0])}
              />
            </label>
          ) : (
            <div className="relative border border-gray-100 dark:border-gray-700 rounded-xl overflow-hidden bg-black/10">
              <button
                type="button"
                onClick={handleRemoveFile}
                className="absolute top-3 right-3 z-10 w-7 h-7 bg-black/50 hover:bg-red-500 text-white rounded-full flex items-center justify-center transition-colors"
              >
                <X className="w-3.5 h-3.5" />
              </button>
              <video src={previewUrl || ""} controls className="w-full max-h-52 object-contain" />
              <div className="px-3 py-2 flex items-center gap-2">
                <Video className="w-4 h-4 text-purple-500 flex-shrink-0" />
                <p className="text-xs font-semibold text-gray-900 dark:text-white truncate">{videoFile.name}</p>
                <span className="ml-auto text-[10px] text-gray-400">{(videoFile.size / (1024 * 1024)).toFixed(1)} MB</span>
              </div>
            </div>
          )}
        </div>

        {/* ── Divider ── */}
        <div className="flex items-center gap-3 my-4">
          <div className="flex-1 h-px bg-gray-100 dark:bg-gray-800" />
          <span className="text-[10px] font-black text-gray-400 uppercase tracking-widest">or</span>
          <div className="flex-1 h-px bg-gray-100 dark:bg-gray-800" />
        </div>

        {/* ── Video URL Input ── */}
        <div className={`transition-all ${isFileLocked ? "opacity-40 pointer-events-none" : ""}`}>
          <label className="flex items-center gap-2 text-xs font-bold text-gray-600 dark:text-gray-300 mb-2">
            <Link className="w-3.5 h-3.5 text-purple-400" />
            Paste Video URL (YouTube, Vimeo, CDN…)
          </label>
          <div className="flex items-center gap-2">
            <input
              type="url"
              value={videoUrl}
              onChange={(e) => {
                onUrlChange(e.target.value)
                if (e.target.value) onFileChange(null) // clear file when URL entered
              }}
              placeholder="https://example.com/ad-video.mp4"
              className="flex-1 px-3 py-2.5 rounded-xl border border-gray-200 dark:border-gray-700 bg-gray-50 dark:bg-[#1C1F26] text-sm text-gray-900 dark:text-white focus:outline-none focus:ring-2 focus:ring-purple-500/30 focus:border-purple-500 transition-colors"
            />
            {videoUrl && (
              <button
                type="button"
                onClick={() => onUrlChange("")}
                className="p-2 text-gray-400 hover:text-red-500 transition-colors"
              >
                <X className="w-4 h-4" />
              </button>
            )}
          </div>
        </div>
      </div>

      {/* ── Thumbnail Upload Section ── */}
      <div className={`rounded-2xl border-2 p-4 transition-all ${
        error
          ? "border-red-400/60 bg-red-500/5"
          : "border-gray-200 dark:border-gray-700 bg-white dark:bg-[#1A1D24]"
      }`}>
        {/* Header */}
        <div className="flex items-center gap-2 mb-4">
          <div className="w-8 h-8 bg-green-500 rounded-xl flex items-center justify-center">
            <div className="w-4 h-4 bg-white rounded-full" />
          </div>
          <div className="flex-1">
            <p className="text-sm font-bold text-gray-900 dark:text-white">Video Thumbnail</p>
            <p className="text-xs text-gray-400">Upload an image for video preview</p>
          </div>
        </div>

        {/* Thumbnail Upload Area */}
        {!videoThumbnail ? (
          <label className="flex flex-col items-center justify-center gap-3 w-full border-2 border-dashed rounded-xl px-5 py-6 cursor-pointer transition-all border-gray-200 dark:border-gray-600 hover:border-green-500 dark:hover:border-green-400">
            <div className="w-12 h-12 rounded-full flex items-center justify-center bg-gray-100 dark:bg-gray-700">
              <UploadCloud className="w-6 h-6 text-gray-400" />
            </div>
            <div className="text-center">
              <p className="text-sm font-semibold text-gray-700 dark:text-gray-200">
                Drag & drop or click to add thumbnail
              </p>
              <p className="text-xs text-gray-400 mt-1">JPEG, PNG · Max 2MB</p>
            </div>
            <input
              type="file"
              className="hidden"
              accept="image/jpeg,image/png,image/webp"
              onChange={(e) => e.target.files?.[0] && onThumbnailChange?.(e.target.files[0])}
            />
          </label>
        ) : (
          <div className="relative border border-gray-100 dark:border-gray-700 rounded-xl overflow-hidden bg-black/10">
            <button
              type="button"
              onClick={() => onThumbnailChange?.(null)}
              className="absolute top-3 right-3 z-10 w-7 h-7 bg-black/50 hover:bg-red-500 text-white rounded-full flex items-center justify-center transition-colors"
            >
              <X className="w-3.5 h-3.5" />
            </button>
            <img 
              src={URL.createObjectURL(videoThumbnail)} 
              alt="Video thumbnail" 
              className="w-full max-h-32 object-contain" 
            />
            <div className="px-3 py-2 flex items-center gap-2">
              <div className="w-4 h-4 bg-green-500 rounded-full flex items-center justify-center">
                <div className="w-2 h-2 bg-white rounded-full" />
              </div>
              <p className="text-xs font-semibold text-gray-900 dark:text-white truncate">{videoThumbnail.name}</p>
              <span className="ml-auto text-[10px] text-gray-400">{(videoThumbnail.size / (1024 * 1024)).toFixed(1)} MB</span>
            </div>
          </div>
        )}
      </div>

      {error && (
        <p className="text-xs font-semibold text-red-500 px-1 flex items-center gap-1 mt-2">
          <span className="inline-block w-1 h-1 rounded-full bg-red-500" />
          {error}
        </p>
      )}
    </div>
  )
}
