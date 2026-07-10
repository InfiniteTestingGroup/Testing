import * as React from "react"
import { LayoutDashboard, Megaphone, Target, MousePointerClick } from "lucide-react"
import { motion } from "framer-motion"

interface PublisherStatsProps {
  stats: {
    totalAds: number
    activeCampaigns: number
    impressions: number
    clicks: number
    ctr: number
  }
}

const formatNumber = (num: number) => {
  if (num >= 1000000) return (num / 1000000).toFixed(1) + "M"
  if (num >= 1000) return (num / 1000).toFixed(1) + "K"
  return num.toString()
}

export function PublisherStats({ stats }: PublisherStatsProps) {
  const circleRadius = 18
  const circleCircumference = 2 * Math.PI * circleRadius
  const ctrProgress = Math.min(stats.ctr, 100)
  const strokeDashoffset = circleCircumference - (ctrProgress / 100) * circleCircumference

  const kpis = [
    { title: "Total Ads", value: formatNumber(stats.totalAds), icon: <LayoutDashboard className="w-5 h-5 text-blue-500" />, bg: "bg-blue-50 dark:bg-blue-500/10" },
    { title: "Active Campaigns", value: formatNumber(stats.activeCampaigns), icon: <Megaphone className="w-5 h-5 text-green-500" />, bg: "bg-green-50 dark:bg-green-500/10" },
    { title: "Total Impressions", value: formatNumber(stats.impressions), icon: <Target className="w-5 h-5 text-purple-500" />, bg: "bg-purple-50 dark:bg-purple-500/10" },
    { title: "Total Clicks", value: formatNumber(stats.clicks), icon: <MousePointerClick className="w-5 h-5 text-amber-500" />, bg: "bg-amber-50 dark:bg-amber-500/10" },
  ]

  return (
    <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-5 gap-4">
      {kpis.map((kpi, idx) => (
        <motion.div
          key={kpi.title}
          initial={{ opacity: 0, scale: 0.95 }}
          animate={{ opacity: 1, scale: 1 }}
          transition={{ duration: 0.3, delay: idx * 0.1 }}
          className="bg-white dark:bg-[#1A1D24] rounded-2xl p-5 shadow-sm border border-gray-200 dark:border-gray-800"
        >
          <div className="flex items-center justify-between mb-4">
            <h3 className="text-sm font-medium text-gray-500 dark:text-gray-400">{kpi.title}</h3>
            <div className={`p-2 rounded-xl ${kpi.bg}`}>
              {kpi.icon}
            </div>
          </div>
          <p className="text-2xl font-bold text-gray-900 dark:text-white">{kpi.value}</p>
        </motion.div>
      ))}

      {/* CTR Card with Circular Progress */}
      <motion.div
        initial={{ opacity: 0, scale: 0.95 }}
        animate={{ opacity: 1, scale: 1 }}
        transition={{ duration: 0.3, delay: 0.4 }}
        className="bg-gradient-to-br from-brand-50 to-brand-100 dark:from-brand-900/40 dark:to-brand-900/10 rounded-2xl p-5 shadow-sm border border-brand-200 dark:border-brand-800/50 flex flex-col justify-between"
      >
        <h3 className="text-sm font-medium text-brand-700 dark:text-brand-300">Click-Through Rate</h3>
        <div className="flex items-center justify-between mt-2">
          <p className="text-3xl font-extrabold text-brand-600 dark:text-brand-400">
            {stats.ctr.toFixed(1)}%
          </p>
          <div className="relative w-12 h-12">
            {/* Background Circle */}
            <svg className="w-full h-full transform -rotate-90">
              <circle
                cx="24"
                cy="24"
                r={circleRadius}
                stroke="currentColor"
                strokeWidth="4"
                fill="transparent"
                className="text-brand-200 dark:text-brand-800/50"
              />
              {/* Progress Circle */}
              <motion.circle
                cx="24"
                cy="24"
                r={circleRadius}
                stroke="currentColor"
                strokeWidth="4"
                fill="transparent"
                strokeDasharray={circleCircumference}
                initial={{ strokeDashoffset: circleCircumference }}
                animate={{ strokeDashoffset }}
                transition={{ duration: 1.5, ease: "easeOut", delay: 0.5 }}
                strokeLinecap="round"
                className="text-brand-500 dark:text-brand-400 drop-shadow-sm"
              />
            </svg>
          </div>
        </div>
      </motion.div>
    </div>
  )
}
