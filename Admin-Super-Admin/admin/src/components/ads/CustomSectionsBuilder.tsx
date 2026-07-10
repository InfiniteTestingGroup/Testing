import * as React from "react"
import { useFieldArray, useFormContext } from "react-hook-form"
import { Plus, Trash2, GripVertical, Type, AlignLeft } from "lucide-react"

export function CustomSectionsBuilder() {
  const { control, register, formState: { errors } } = useFormContext()
  const { fields, append, remove } = useFieldArray({
    control,
    name: "customSections"
  })

  return (
    <div className="space-y-4">
      <div className="flex items-center justify-between">
        <div>
          <h3 className="text-sm font-bold text-gray-900 dark:text-white uppercase tracking-wider">Custom Content Sections</h3>
          <p className="text-xs text-gray-500 dark:text-gray-400">Add detailed information to your ad display</p>
        </div>
        <button
          type="button"
          onClick={() => append({ title: "", description: "" })}
          className="flex items-center gap-1.5 px-3 py-1.5 bg-brand-500 hover:bg-brand-600 text-white text-xs font-bold rounded-lg transition-colors shadow-sm"
        >
          <Plus className="w-3.5 h-3.5" />
          Add Section
        </button>
      </div>

      <div className="space-y-3">
        {fields.map((field, index) => (
          <div 
            key={field.id}
            className="group relative p-5 bg-gray-50 dark:bg-[#1C1F26] border border-gray-200 dark:border-gray-800 rounded-2xl transition-all hover:border-brand-500/30"
          >
            <div className="flex gap-4">
              {/* Index Column */}
              <div className="flex flex-col items-center gap-2 pt-1">
                <div className="w-6 h-6 rounded-lg bg-white dark:bg-gray-800 border border-gray-200 dark:border-gray-700 flex items-center justify-center text-[10px] font-black text-gray-400">
                  {index + 1}
                </div>
                <div className="flex-1 w-0.5 bg-gray-200 dark:bg-gray-800 rounded-full" />
              </div>

              {/* Inputs Column */}
              <div className="flex-1 space-y-4">
                <div>
                  <div className="flex items-center gap-2 mb-1.5">
                    <Type className="w-3.5 h-3.5 text-brand-500" />
                    <label className="text-xs font-bold text-gray-700 dark:text-gray-300">Section Title</label>
                  </div>
                  <input
                    {...register(`customSections.${index}.title` as const)}
                    placeholder="e.g. Benefits, How to Use, Specs..."
                    className="w-full px-4 py-2 text-sm bg-white dark:bg-[#1A1D24] border border-gray-200 dark:border-gray-700 rounded-xl focus:outline-none focus:ring-2 focus:ring-brand-500/20 focus:border-brand-500 transition-all"
                  />
                </div>

                <div>
                  <div className="flex items-center gap-2 mb-1.5">
                    <AlignLeft className="w-3.5 h-3.5 text-brand-500" />
                    <label className="text-xs font-bold text-gray-700 dark:text-gray-300">Description</label>
                  </div>
                  <textarea
                    {...register(`customSections.${index}.description` as const)}
                    placeholder="Detailed content for this section..."
                    rows={3}
                    className="w-full px-4 py-2 text-sm bg-white dark:bg-[#1A1D24] border border-gray-200 dark:border-gray-700 rounded-xl focus:outline-none focus:ring-2 focus:ring-brand-500/20 focus:border-brand-500 transition-all resize-none"
                  />
                </div>
              </div>

              {/* Action Column */}
              <div className="flex flex-col justify-center">
                <button
                  type="button"
                  onClick={() => remove(index)}
                  disabled={fields.length <= 1}
                  className="p-2 text-gray-400 hover:text-red-500 hover:bg-red-50 dark:hover:bg-red-500/10 rounded-lg transition-all disabled:opacity-0 disabled:pointer-events-none"
                >
                  <Trash2 className="w-4 h-4" />
                </button>
              </div>
            </div>
          </div>
        ))}
      </div>

      {errors.customSections && !Array.isArray(errors.customSections) && (
        <p className="text-xs font-semibold text-red-500 flex items-center gap-1 mt-2">
           {(errors.customSections as any).message}
        </p>
      )}
    </div>
  )
}
