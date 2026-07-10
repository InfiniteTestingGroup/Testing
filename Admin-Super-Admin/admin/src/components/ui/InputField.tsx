import * as React from "react"
import { Input, type InputProps } from "./Input"

interface InputFieldProps extends InputProps {
  label: string
  error?: string
}

export const InputField = React.forwardRef<HTMLInputElement, InputFieldProps>(
  ({ label, error, className, ...props }, ref) => {
    return (
      <div className="w-full space-y-1.5">
        <label className="block text-sm font-medium text-gray-700 dark:text-gray-300">
          {label} {props.required && <span className="text-red-500">*</span>}
        </label>
        <Input ref={ref} className={className} {...props} />
        {error && (
          <p className="text-sm text-red-500 font-medium animate-in fade-in slide-in-from-top-1">
            {error}
          </p>
        )}
      </div>
    )
  }
)
InputField.displayName = "InputField"
