import * as React from "react"
import { cn } from "../../lib/utils"

export interface BadgeProps extends React.HTMLAttributes<HTMLDivElement> {
  variant?: "default" | "success" | "warning" | "danger" | "neutral" | "info"
}

function Badge({ className, variant = "default", ...props }: BadgeProps) {
  const variants = {
    default: "bg-brand-50 text-brand-600 dark:bg-brand-500/10 dark:text-brand-400",
    success: "bg-green-50 text-green-600 dark:bg-green-500/10 dark:text-green-400",
    warning: "bg-yellow-50 text-yellow-600 dark:bg-yellow-500/10 dark:text-yellow-400",
    danger: "bg-red-50 text-red-600 dark:bg-red-500/10 dark:text-red-400",
    neutral: "bg-gray-100 text-gray-600 dark:bg-gray-800 dark:text-gray-400",
    info: "bg-blue-50 text-blue-600 dark:bg-blue-500/10 dark:text-blue-400",
  }

  return (
    <div
      className={cn(
        "inline-flex items-center rounded-full px-2.5 py-0.5 text-xs font-semibold transition-colors focus:outline-none",
        variants[variant],
        className
      )}
      {...props}
    />
  )
}

export { Badge }
