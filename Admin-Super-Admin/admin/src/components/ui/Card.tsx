import * as React from "react"
import { cn } from "../../lib/utils"

const Card = React.forwardRef<HTMLDivElement, React.HTMLAttributes<HTMLDivElement>>(
  ({ className, ...props }, ref) => (
    <div
      ref={ref}
      className={cn(
        "rounded-2xl border bg-white text-gray-950 shadow-[0_4px_20px_-4px_rgba(0,0,0,0.05)] dark:bg-[#1A1D24] dark:border-gray-800/80 dark:text-white dark:shadow-[0_8px_30px_rgb(0,0,0,0.12)] dark:ring-1 dark:ring-white/5 transition-all overflow-hidden relative",
        className
      )}
      {...props}
    />
  )
)
Card.displayName = "Card"

export { Card }
