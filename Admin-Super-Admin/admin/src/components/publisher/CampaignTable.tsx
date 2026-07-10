import * as React from "react"
import type { AdCampaign } from "../../services/publishers"
import { Eye } from "lucide-react"
import { motion } from "framer-motion"

interface CampaignTableProps {
  campaigns: AdCampaign[]
}

export function CampaignTable({ campaigns }: CampaignTableProps) {
  if (!campaigns || campaigns.length === 0) {
    return (
      <div className="bg-white dark:bg-[#1A1D24] rounded-2xl p-12 shadow-sm border border-gray-200 dark:border-gray-800 text-center flex flex-col items-center">
        <div className="w-16 h-16 bg-gray-100 dark:bg-gray-800 rounded-full flex items-center justify-center mb-4">
          <Eye className="w-8 h-8 text-gray-400" />
        </div>
        <h3 className="text-lg font-semibold text-gray-900 dark:text-white mb-2">No Campaigns Yet</h3>
        <p className="text-sm text-gray-500 dark:text-gray-400 max-w-sm">
          This publisher hasn't launched any ad campaigns yet. Once they do, their historical ads will appear here.
        </p>
      </div>
    )
  }

  return (
    <motion.div
      initial={{ opacity: 0, y: 20 }}
      animate={{ opacity: 1, y: 0 }}
      transition={{ duration: 0.5, delay: 0.4 }}
      className="bg-white dark:bg-[#1A1D24] rounded-2xl shadow-sm border border-gray-200 dark:border-gray-800 overflow-hidden"
    >
      <div className="px-6 py-5 border-b border-gray-200 dark:border-gray-800 flex items-center justify-between">
        <h3 className="text-base font-semibold text-gray-900 dark:text-white">Campaign History</h3>
      </div>
      <div className="overflow-x-auto">
        <table className="w-full text-left text-sm whitespace-nowrap">
          <thead className="bg-gray-50 dark:bg-[#1C1F26] border-b border-gray-200 dark:border-gray-800">
            <tr>
              <th className="px-6 py-4 font-medium text-gray-500 dark:text-gray-400">Ad Title</th>
              <th className="px-6 py-4 font-medium text-gray-500 dark:text-gray-400">Status</th>
              <th className="px-6 py-4 font-medium text-gray-500 dark:text-gray-400">Date Range</th>
              <th className="px-6 py-4 font-medium text-gray-500 dark:text-gray-400 text-right">Impressions</th>
              <th className="px-6 py-4 font-medium text-gray-500 dark:text-gray-400 text-right">Clicks</th>
              <th className="px-6 py-4 font-medium text-gray-500 dark:text-gray-400 text-right">CTR</th>
              <th className="px-6 py-4 font-medium text-gray-500 dark:text-gray-400 text-center">Action</th>
            </tr>
          </thead>
          <tbody className="divide-y divide-gray-100 dark:divide-gray-800/60">
            {campaigns.map((campaign) => (
              <tr key={campaign.id} className="hover:bg-gray-50/50 dark:hover:bg-[#1C1F26]/50 transition-colors">
                <td className="px-6 py-4">
                  <span className="font-semibold text-gray-900 dark:text-white">{campaign.title}</span>
                  <div className="text-xs text-gray-500 dark:text-gray-400 mt-0.5">{campaign.id}</div>
                </td>
                <td className="px-6 py-4">
                  <span className={`inline-flex items-center px-2.5 py-1 rounded-md text-xs font-medium border
                    ${campaign.status === 'Active' ? 'bg-green-50 text-green-700 border-green-200 dark:bg-green-500/10 dark:text-green-400 dark:border-green-500/20' :
                      campaign.status === 'Expired' ? 'bg-gray-50 text-gray-700 border-gray-200 dark:bg-gray-800 dark:text-gray-300 dark:border-gray-700' :
                        'bg-amber-50 text-amber-700 border-amber-200 dark:bg-amber-500/10 dark:text-amber-400 dark:border-amber-500/20'
                    }
                  `}>
                    {campaign.status}
                  </span>
                </td>
                <td className="px-6 py-4 text-gray-600 dark:text-gray-300">
                  {campaign.startDate} - {campaign.endDate}
                </td>
                <td className="px-6 py-4 text-right font-medium text-gray-900 dark:text-white">
                  {campaign.impressions > 0 ? campaign.impressions.toLocaleString() : "-"}
                </td>
                <td className="px-6 py-4 text-right font-medium text-gray-900 dark:text-white">
                  {campaign.clicks > 0 ? campaign.clicks.toLocaleString() : "-"}
                </td>
                <td className="px-6 py-4 text-right font-medium text-brand-600 dark:text-brand-400">
                  {campaign.ctr > 0 ? `${campaign.ctr}%` : "-"}
                </td>
                <td className="px-6 py-4 text-center">
                  <button className="p-2 text-gray-400 hover:text-brand-500 dark:hover:text-brand-400 hover:bg-gray-100 dark:hover:bg-gray-800 rounded-lg transition-colors focus:outline-none focus:ring-2 focus:ring-brand-500/50">
                    <Eye className="w-5 h-5" />
                  </button>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </motion.div>
  )
}
