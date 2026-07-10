import type { ReactNode } from "react"
import { motion } from "framer-motion"
import { Card } from "../ui/Card"

interface KpiCardProps {
  title: string
  value: string | number
  icon: ReactNode
  delay?: number
}

export function KpiCard({ title, value, icon, delay = 0 }: KpiCardProps) {
  return (
    <motion.div
      initial={{ opacity: 0, y: 20 }}
      animate={{ opacity: 1, y: 0 }}
      transition={{ duration: 0.4, delay }}
      whileHover={{ y: -4, scale: 1.02 }}
      className="h-full"
    >
      <Card className="p-6 h-full flex flex-col justify-between hover:shadow-md transition-shadow">
        <div className="flex items-start justify-between">
          <div>
            <p className="text-sm font-medium text-gray-500 dark:text-gray-400 tracking-wide">{title}</p>
            <h3 className="mt-2 text-3xl font-bold text-gray-900 dark:text-white">{value}</h3>
          </div>
          <div className="p-3 bg-brand-50 text-brand-600 dark:bg-brand-500/10 dark:text-brand-400 rounded-xl">
            {icon}
          </div>
        </div>
      </Card>
    </motion.div>
  )
}
