import * as React from "react"
import { useFormContext } from "react-hook-form"
import { Building2, User, Mail, Phone, MapPin, Navigation } from "lucide-react"
import { InputField } from "../ui/InputField"
import toast from "react-hot-toast"

export function PublisherFormFields() {
  const { register, formState: { errors }, setValue } = useFormContext()

  const handleDetectLocation = () => {
    if (!navigator.geolocation) {
      toast.error("Geolocation is not supported by your browser")
      return
    }

    const toastId = toast.loading("Detecting location...")

    navigator.geolocation.getCurrentPosition(
      (position) => {
        setValue("latitude", position.coords.latitude, { shouldValidate: true })
        setValue("longitude", position.coords.longitude, { shouldValidate: true })
        toast.success("Location detected!", { id: toastId })
      },
      (error) => {
        toast.error(`Unable to retrieve your location: ${error.message}`, { id: toastId })
      }
    )
  }

  return (
    <div className="space-y-6">
      {/* Basic Info Section */}
      <div className="bg-white dark:bg-[#1A1D24] border border-gray-200 dark:border-gray-800 rounded-2xl p-6 shadow-sm">
        <div className="flex items-center gap-3 mb-6 pb-4 border-b border-gray-100 dark:border-gray-800">
          <div className="p-2 bg-brand-50 dark:bg-brand-500/10 rounded-lg text-brand-600 dark:text-brand-400">
            <Building2 className="w-5 h-5" />
          </div>
          <div>
            <h3 className="text-lg font-semibold text-gray-900 dark:text-white">Basic Information</h3>
            <p className="text-sm text-gray-500 dark:text-gray-400">Essential details about the publisher or branch.</p>
          </div>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
          <InputField
            label="Publisher / Branch Name"
            icon={<Building2 className="w-[18px] h-[18px]" />}
            placeholder="e.g. Phoenix Mall Outlet"
            error={errors.name?.message as string}
            {...register("name")}
            required
          />
          <InputField
            label="Contact Person"
            icon={<User className="w-[18px] h-[18px]" />}
            placeholder="e.g. Rahul Sharma"
            error={errors.contactPerson?.message as string}
            {...register("contactPerson")}
            required
          />
          <InputField
            label="Email Address"
            type="email"
            icon={<Mail className="w-[18px] h-[18px]" />}
            placeholder="contact@outlet.com"
            error={errors.email?.message as string}
            {...register("email")}
            required
          />
          <InputField
            label="Mobile Number"
            type="tel"
            icon={<Phone className="w-[18px] h-[18px]" />}
            placeholder="9876543210"
            error={errors.mobile?.message as string}
            {...register("mobile")}
            required
          />
        </div>
      </div>

      {/* Location Info Section */}
      <div className="bg-white dark:bg-[#1A1D24] border border-gray-200 dark:border-gray-800 rounded-2xl p-6 shadow-sm">
        <div className="flex items-center gap-3 mb-6 pb-4 border-b border-gray-100 dark:border-gray-800">
          <div className="p-2 bg-blue-50 dark:bg-blue-500/10 rounded-lg text-blue-600 dark:text-blue-400">
            <MapPin className="w-5 h-5" />
          </div>
          <div className="flex-1">
            <h3 className="text-lg font-semibold text-gray-900 dark:text-white">Location Information</h3>
             <p className="text-sm text-gray-500 dark:text-gray-400">Used for geo-targeted ad delivery.</p>
          </div>
          <button
            type="button"
            onClick={handleDetectLocation}
            className="hidden sm:flex items-center gap-2 px-4 py-2 bg-gray-100 hover:bg-gray-200 text-gray-700 dark:bg-gray-800 dark:hover:bg-gray-700 dark:text-gray-200 rounded-lg text-sm font-medium transition-colors"
          >
            <Navigation className="w-4 h-4" />
            Auto-Detect Location
          </button>
        </div>

        <button
            type="button"
            onClick={handleDetectLocation}
            className="w-full sm:hidden flex justify-center items-center gap-2 px-4 py-2 mb-6 bg-gray-100 hover:bg-gray-200 text-gray-700 dark:bg-gray-800 dark:hover:bg-gray-700 dark:text-gray-200 rounded-lg text-sm font-medium transition-colors"
          >
            <Navigation className="w-4 h-4" />
            Auto-Detect Location
        </button>

        <div className="space-y-6">
          <div className="w-full space-y-1.5">
            <label className="block text-sm font-medium text-gray-700 dark:text-gray-300">
              Complete Address <span className="text-red-500">*</span>
            </label>
            <div className="relative">
              <div className="absolute top-3 left-3 pointer-events-none text-gray-400">
                <MapPin className="w-[18px] h-[18px]" />
              </div>
              <textarea
                className="flex w-full rounded-lg border border-gray-200 bg-white pl-10 pr-3 py-2 text-sm ring-offset-white placeholder:text-gray-500 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-brand-500 disabled:cursor-not-allowed disabled:opacity-50 dark:border-gray-800 dark:bg-[#1C1F26] dark:ring-offset-gray-950 dark:placeholder:text-gray-400 focus-visible:dark:ring-brand-500 transition-colors shadow-sm min-h-[100px] resize-y"
                placeholder="Enter complete business address..."
                {...register("address")}
              />
            </div>
            {errors.address && (
              <p className="text-sm text-red-500 font-medium animate-in fade-in slide-in-from-top-1">
                {errors.address.message as string}
              </p>
            )}
          </div>

          <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
            <InputField
              label="Latitude"
              type="number"
              step="any"
              placeholder="e.g. 19.0760"
              error={errors.latitude?.message as string}
              {...register("latitude")}
              required
            />
            <InputField
              label="Longitude"
              type="number"
              step="any"
              placeholder="e.g. 72.8777"
              error={errors.longitude?.message as string}
              {...register("longitude")}
              required
            />
          </div>
        </div>
      </div>
    </div>
  )
}
