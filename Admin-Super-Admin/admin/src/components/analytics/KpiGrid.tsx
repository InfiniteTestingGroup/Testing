import * as React from "react"
import { motion } from "framer-motion"
import { Eye, MousePointer2, TrendingUp, Wallet, Zap, ArrowUpRight, ArrowDownRight } from "lucide-react"
import type { KpiData } from "../../services/analytics"

interface KpiGridProps {
  data: KpiData
}

export function KpiGrid({ data }: KpiGridProps) {
  const cards = [
    { 
      label: "Total Impressions", 
      value: data.impressions.toLocaleString(), 
      trend: data.trends.impressions, 
      icon: Eye, 
      color: "text-blue-500", 
      bg: "bg-blue-50 dark:bg-blue-500/10" 
    },
    { 
      label: "Total Clicks", 
      value: data.clicks.toLocaleString(), 
      trend: data.trends.clicks, 
      icon: MousePointer2, 
      color: "text-brand-500", 
      bg: "bg-brand-50 dark:bg-brand-500/10" 
    },
    { 
      label: "Click Through Rate", 
      value: `${data.ctr}%`, 
      trend: data.trends.ctr, 
      icon: TrendingUp, 
      color: "text-emerald-500", 
      bg: "bg-emerald-50 dark:bg-emerald-500/10" 
    },
    { 
      label: "Total Spend", 
      value: `₹${data.spend.toLocaleString()}`, 
      trend: data.trends.spend, 
      icon: Wallet, 
      color: "text-amber-500", 
      bg: "bg-amber-50 dark:bg-amber-500/10" 
    },
    { 
      label: "Active Campaigns", 
      value: String(data.activeCampaigns), 
      trend: 0, 
      icon: Zap, 
      color: "text-purple-500", 
      bg: "bg-purple-50 dark:bg-purple-500/10" 
    },
  ]

  return (
    <div className="grid grid-cols-1 md:grid-cols-3 lg:grid-cols-5 gap-6 mb-8">
      {cards.map((card, i) => (
        <motion.div
          key={card.label}
          initial={{ opacity: 0, scale: 0.95 }}
          animate={{ opacity: 1, scale: 1 }}
          transition={{ delay: i * 0.05 }}
          className="bg-white dark:bg-[#1A1D24] p-6 rounded-3xl border border-gray-200 dark:border-gray-800 shadow-sm relative overflow-hidden group hover:shadow-xl transition-all"
        >
          {/* Decorative Background Icon */}
          <card.icon className={`absolute -right-4 -bottom-4 w-24 h-24 opacity-5 transition-transform group-hover:scale-110 group-hover:rotate-12 ${card.color}`} />
          
          <div className="flex items-center justify-between mb-4">
            <div className={`p-2.5 rounded-xl ${card.bg} ${card.color}`}>
              <card.icon className="w-5 h-5" />
            </div>
            {card.trend !== 0 && (
              <div className={`flex items-center gap-0.5 px-2 py-1 rounded-full text-[10px] font-black ${
                card.trend > 0 ? "bg-green-50 text-green-600 dark:bg-green-500/10" : "bg-red-50 text-red-600 dark:bg-red-500/10"
              }`}>
                {card.trend > 0 ? <ArrowUpRight className="w-3 h-3" /> : <ArrowDownRight className="w-3 h-3" />}
                {Math.abs(card.trend)}%
              </div>
            )}
          </div>
          
          <p className="text-[10px] font-black text-gray-400 uppercase tracking-widest mb-1">{card.label}</p>
          <h3 className="text-2xl font-black text-gray-900 dark:text-white transition-transform group-hover:translate-x-1">{card.value}</h3>
        </motion.div>
      ))}
    </div>
  )
}
