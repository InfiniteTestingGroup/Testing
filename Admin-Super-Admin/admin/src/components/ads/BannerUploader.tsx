import * as React from "react"
import { Image as ImageIcon, X, Plus, Scissors, Eye } from "lucide-react"
import ReactCrop, { type Crop } from 'react-image-crop'
import 'react-image-crop/dist/ReactCrop.css'
import getCroppedImg from "../../lib/cropUtils"
import { Modal } from "../ui/Modal"
import { Button } from "../ui/Button"

interface BannerUploaderProps {
  files: File[]
  onFilesChange: (files: File[]) => void
  onThumbnailChange?: (index: number) => void
  thumbnailIndex?: number
  error?: string
}

function ImageThumbnail({ file, index, onRemove, onPreview, isThumbnail, onSetThumbnail }: { 
  file: File; 
  index: number; 
  onRemove: () => void; 
  onPreview: (url: string) => void;
  isThumbnail?: boolean;
  onSetThumbnail?: () => void;
}) {
  const [url, setUrl] = React.useState<string>("");

  React.useEffect(() => {
    const objectUrl = URL.createObjectURL(file);
    setUrl(objectUrl);
    return () => URL.revokeObjectURL(objectUrl);
  }, [file]);

  if (!url) return null;

  return (
    <div className="relative group rounded-xl overflow-hidden bg-gray-100 dark:bg-gray-800 border border-gray-200 dark:border-gray-700 shadow-sm min-h-[160px] flex items-center justify-center">
      <img src={url} alt={`Banner ${index + 1}`} className="w-full h-full object-contain max-h-[160px]" />
      
      {/* Thumbnail Badge - Top Left */}
      {isThumbnail && (
        <div className="absolute top-2 left-2 bg-green-500 text-[11px] text-white px-2.5 py-0.5 rounded-full font-bold shadow-md z-10 flex items-center gap-1">
          <div className="w-2 h-2 bg-white rounded-full" />
          Thumbnail
        </div>
      )}
      
      {/* Number Badge - Top Left (if not thumbnail) */}
      {!isThumbnail && (
        <div className="absolute top-2 left-2 bg-brand-500 text-[11px] text-white px-2.5 py-0.5 rounded-full font-bold shadow-md z-10">
          {index + 1}
        </div>
      )}
      
      {/* Actions Container - Top Right */}
      <div className="absolute top-2 right-2 flex items-center gap-2 z-10">
        {!isThumbnail && onSetThumbnail && (
          <button
            type="button"
            onClick={onSetThumbnail}
            className="w-7 h-7 bg-green-500 hover:bg-green-600 text-white rounded-full flex items-center justify-center shadow-md transition-all hover:scale-110"
            title="Set as Thumbnail"
          >
            <div className="w-3 h-3 bg-white rounded-full" />
          </button>
        )}
        <button
          type="button"
          onClick={() => onPreview(url)}
          className="w-7 h-7 bg-white dark:bg-gray-800 text-gray-500 hover:text-brand-500 rounded-full flex items-center justify-center shadow-md transition-all hover:scale-110"
          title="Preview"
        >
          <Eye className="w-4 h-4" />
        </button>
        <button
          type="button"
          onClick={onRemove}
          className="w-7 h-7 bg-white dark:bg-gray-800 text-gray-500 hover:text-red-500 rounded-full flex items-center justify-center shadow-md transition-all hover:scale-110"
          title="Remove"
        >
          <X className="w-4 h-4" />
        </button>
      </div>

      {/* Hover Overlay */}
      <div className="absolute inset-0 bg-black/5 opacity-0 group-hover:opacity-100 transition-opacity pointer-events-none" />
    </div>
  );
}

export function BannerUploader({ files, onFilesChange, onThumbnailChange, thumbnailIndex = 0, error }: BannerUploaderProps) {
  const [dragActive, setDragActive] = React.useState(false)
  const [selectedImage, setSelectedImage] = React.useState<string | null>(null)
  const [previewImage, setPreviewImage] = React.useState<string | null>(null)
  const [crop, setCrop] = React.useState<Crop>()
  const [completedCrop, setCompletedCrop] = React.useState<any>()
  const [isCropping, setIsCropping] = React.useState(false)
  const imgRef = React.useRef<HTMLImageElement>(null)
  
  const MAX = 4

  const handleFileSelect = (e: React.ChangeEvent<HTMLInputElement> | React.DragEvent) => {
    let file: File | undefined
    if ('files' in e.target && e.target.files?.[0]) {
      file = e.target.files[0]
    } else if ('dataTransfer' in e && e.dataTransfer.files?.[0]) {
      file = e.dataTransfer.files[0]
    }

    if (file && file.type.startsWith("image/")) {
      const reader = new FileReader()
      reader.onload = () => {
        setSelectedImage(reader.result as string)
      }
      reader.readAsDataURL(file)
    }
  }

  const onImageLoad = (e: React.SyntheticEvent<HTMLImageElement>) => {
    const { width, height } = e.currentTarget
    const initialCrop: Crop = {
      unit: '%',
      x: 0,
      y: 0,
      width: 100,
      height: 100,
    }
    setCrop(initialCrop)
    setCompletedCrop({
      unit: 'px',
      x: 0,
      y: 0,
      width,
      height
    })
  }

  const handleCropSave = async () => {
    if (selectedImage && completedCrop && imgRef.current) {
      try {
        setIsCropping(true)

        // Scale coordinates from rendered size to natural size
        const scaleX = imgRef.current.naturalWidth / imgRef.current.width;
        const scaleY = imgRef.current.naturalHeight / imgRef.current.height;

        const pixelCrop = {
          x: completedCrop.x * scaleX,
          y: completedCrop.y * scaleY,
          width: completedCrop.width * scaleX,
          height: completedCrop.height * scaleY,
        };

        const croppedFile = await getCroppedImg(selectedImage, pixelCrop)
        if (croppedFile) {
          onFilesChange([...files, croppedFile])
        }
        setSelectedImage(null)
      } catch (e) {
        console.error("Cropping failed:", e)
      } finally {
        setIsCropping(false)
      }
    }
  }

  const removeFile = (index: number) => {
    const updated = files.filter((_, i) => i !== index)
    onFilesChange(updated)
  }

  const handleDrop = (e: React.DragEvent) => {
    e.preventDefault()
    setDragActive(false)
    handleFileSelect(e)
  }

  return (
    <div className="space-y-4">
      <div className={`rounded-2xl border-2 p-4 transition-all ${
        error
          ? "border-red-400/60 bg-red-500/5"
          : "border-gray-200 dark:border-gray-700 bg-white dark:bg-[#1A1D24]"
      }`}>
        {/* Header */}
        <div className="flex items-center gap-2 mb-4">
          <div className="w-8 h-8 bg-brand-500 rounded-xl flex items-center justify-center">
            <ImageIcon className="w-4 h-4 text-white" />
          </div>
          <div className="flex-1">
            <p className="text-sm font-bold text-gray-900 dark:text-white">Banner Images</p>
            <p className="text-xs text-gray-400">Add up to 4 images for the banner carousel</p>
          </div>
          <div className="flex items-center gap-1.5 px-3 py-1 bg-gray-100 dark:bg-gray-800 rounded-full">
            <span className={`text-xs font-bold ${files.length === MAX ? "text-brand-500" : "text-gray-500"}`}>
              {files.length} / {MAX}
            </span>
          </div>
        </div>

        {/* Drop Zone */}
        {files.length < MAX ? (
          <label
            className={`flex flex-col items-center justify-center gap-2 w-full border-2 border-dashed rounded-xl px-5 py-8 cursor-pointer transition-all ${
              dragActive
                ? "border-brand-500 bg-brand-500/5"
                : error
                  ? "border-red-400/60 hover:border-red-500"
                  : "border-gray-200 dark:border-gray-600 hover:border-brand-500 dark:hover:border-brand-500"
            }`}
            onDragEnter={(e) => { e.preventDefault(); setDragActive(true) }}
            onDragLeave={(e) => { e.preventDefault(); setDragActive(false) }}
            onDragOver={(e) => e.preventDefault()}
            onDrop={handleDrop}
          >
            <div className={`w-12 h-12 rounded-xl flex items-center justify-center transition-colors ${
              dragActive ? "bg-brand-500" : "bg-gray-100 dark:bg-gray-700"
            }`}>
              <Plus className={`w-6 h-6 ${dragActive ? "text-white" : "text-gray-400"}`} />
            </div>
            <div className="text-center">
              <p className="text-sm font-semibold text-gray-700 dark:text-gray-300">
                Drag & drop or click to add images
              </p>
              <p className="text-xs text-gray-400 mt-1">JPEG, PNG · Max 5MB</p>
            </div>
            <input
              type="file"
              className="hidden"
              accept="image/jpeg,image/png,image/webp"
              onChange={handleFileSelect}
            />
          </label>
        ) : (
          <div className="flex flex-col items-center justify-center py-8 bg-gray-50 dark:bg-gray-800/50 rounded-xl border-2 border-dashed border-gray-200 dark:border-gray-700">
            <p className="text-sm font-medium text-gray-500 dark:text-gray-400">Maximum limit reached (4/4)</p>
          </div>
        )}
      </div>

      {/* Image Preview Grid */}
      {files.length > 0 && (
        <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
          {files.map((file, i) => (
            <ImageThumbnail 
              key={i} 
              file={file} 
              index={i} 
              onRemove={() => removeFile(i)}
              onPreview={(url) => setPreviewImage(url)}
              isThumbnail={i === thumbnailIndex}
              onSetThumbnail={() => onThumbnailChange?.(i)}
            />
          ))}
        </div>
      )}

      {error && (
        <p className="text-xs font-semibold text-red-500 px-1 flex items-center gap-1 mt-2">
          <span className="inline-block w-1 h-1 rounded-full bg-red-500" />
          {error}
        </p>
      )}

      {/* Crop Modal */}
      <Modal
        isOpen={!!selectedImage}
        onClose={() => setSelectedImage(null)}
        title="Adjust Image"
        maxWidth="max-w-4xl"
      >
        <div className="space-y-6">
          <div className="relative w-full bg-gray-900/5 rounded-xl overflow-hidden flex items-center justify-center border border-gray-200 dark:border-gray-800" style={{ maxHeight: '60vh' }}>
            {selectedImage && (
              <ReactCrop
                crop={crop}
                onChange={(_, percentCrop) => setCrop(percentCrop)}
                onComplete={(c) => setCompletedCrop(c)}
                className="max-h-full"
              >
                <img
                  ref={imgRef}
                  src={selectedImage}
                  alt="Crop preview"
                  onLoad={onImageLoad}
                  className="max-w-full max-h-[60vh] object-contain"
                />
              </ReactCrop>
            )}
          </div>

          <div className="flex justify-end gap-3 pt-2">
            <Button
              type="button"
              variant="secondary"
              onClick={() => setSelectedImage(null)}
              disabled={isCropping}
            >
              Cancel
            </Button>
            <Button
              type="button"
              onClick={handleCropSave}
              isLoading={isCropping}
              className="bg-brand-500 hover:bg-brand-600 text-white border-none shadow-sm shadow-brand-500/20 px-8"
            >
              <Scissors className="w-4 h-4 mr-2" />
              Crop & Add
            </Button>
          </div>
        </div>
      </Modal>

      {/* Large Preview Modal */}
      <Modal
        isOpen={!!previewImage}
        onClose={() => setPreviewImage(null)}
        title="Banner Preview"
        maxWidth="max-w-5xl"
      >
        <div className="flex flex-col items-center justify-center bg-gray-900/5 rounded-xl overflow-hidden border border-gray-200 dark:border-gray-800">
          {previewImage && (
            <img 
              src={previewImage} 
              alt="Large preview" 
              className="max-w-full max-h-[75vh] object-contain shadow-2xl"
            />
          )}
          <div className="w-full p-4 bg-white dark:bg-gray-900 flex justify-end">
            <Button 
              type="button"
              onClick={() => setPreviewImage(null)}
              className="bg-brand-500 hover:bg-brand-600 text-white border-none shadow-sm shadow-brand-500/20 px-8"
            >
              Close
            </Button>
          </div>
        </div>
      </Modal>
    </div>
  )
}


