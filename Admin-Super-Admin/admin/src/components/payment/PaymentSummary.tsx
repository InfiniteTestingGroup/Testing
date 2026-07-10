import * as React from "react"
import { Package, Calendar, Users, CheckCircle2 } from "lucide-react"
import type { Advertisement } from "../../services/ads"

interface PaymentSummaryProps {
  ad: Advertisement
  cost: number
}

function formatDate(dateStr?: string) {
  if (!dateStr) return 'N/A';
  try {
    const d = new Date(dateStr);
    if (isNaN(d.getTime())) return dateStr;
    return d.toLocaleDateString("en-US", { day: "numeric", month: "short", year: "numeric" });
  } catch {
    return dateStr;
  }
}

export function PaymentSummary({ ad, cost }: PaymentSummaryProps) {
  return (
    <div className="space-y-6">
      <div className="bg-white dark:bg-[#1A1D24] p-6 rounded-2xl border border-gray-200 dark:border-gray-800 shadow-sm">
        <h2 className="text-xl font-bold text-gray-900 dark:text-white mb-6 flex items-center gap-2">
          <Package className="w-5 h-5 text-brand-500" />
          Campaign Recap
        </h2>

        <div className="space-y-4">
          <div className="flex justify-between items-start pb-4 border-b border-gray-100 dark:border-gray-800">
            <div>
              <p className="text-sm font-bold text-gray-900 dark:text-white">{ad.title}</p>
              <p className="text-xs text-gray-500">{ad.id}</p>
            </div>
            <span className="px-2 py-1 bg-brand-50 text-brand-600 dark:bg-brand-500/10 dark:text-brand-400 text-[10px] font-black rounded uppercase">
              Draft
            </span>
          </div>

          <div className="grid grid-cols-2 gap-4">
            <div className="flex items-center gap-3">
              <div className="p-2 bg-gray-50 dark:bg-[#1C1F26] rounded-lg">
                <Calendar className="w-4 h-4 text-gray-400" />
              </div>
              <div>
                <p className="text-[10px] font-bold text-gray-400 uppercase tracking-wider">Duration</p>
                <p className="text-xs font-semibold text-gray-700 dark:text-gray-300 whitespace-nowrap">
                  {formatDate(ad.startDate)} to {formatDate(ad.endDate)}
                </p>
              </div>
            </div>
            
            <div className="flex items-center gap-3">
              <div className="p-2 bg-gray-50 dark:bg-[#1C1F26] rounded-lg">
                <Users className="w-4 h-4 text-gray-400" />
              </div>
              <div>
                <p className="text-[10px] font-bold text-gray-400 uppercase tracking-wider">Reach</p>
                <p className="text-xs font-semibold text-gray-700 dark:text-gray-300">
                  {ad.publishers.length} {ad.publishers.length === 1 ? 'Publisher' : 'Publishers'}
                </p>
              </div>
            </div>
          </div>
        </div>
      </div>

      <div className="bg-white dark:bg-[#1A1D24] p-6 rounded-2xl border border-gray-200 dark:border-gray-800 shadow-sm">
        <h3 className="text-sm font-black text-gray-400 uppercase tracking-widest mb-4">Investment Detail</h3>
        <div className="space-y-3">
          <div className="flex justify-between text-sm">
            <span className="text-gray-500 italic">Ad Configuration Fee</span>
            <span className="font-medium text-gray-900 dark:text-gray-200">₹{cost}</span>
          </div>
          <div className="flex justify-between text-sm">
            <span className="text-gray-500 italic">Network Allocation</span>
            <span className="font-medium text-green-600 dark:text-green-400">Included</span>
          </div>
          
          <div className="pt-4 mt-2 border-t border-gray-100 dark:border-gray-800 flex justify-between items-baseline">
            <span className="text-lg font-bold text-gray-900 dark:text-white">Total Amount</span>
            <span className="text-2xl font-black text-brand-600 dark:text-brand-400">₹{cost}</span>
          </div>
        </div>

        <div className="mt-6 flex items-start gap-3 p-3 bg-blue-50 dark:bg-blue-500/10 rounded-xl border border-blue-100 dark:border-blue-900/10">
           <CheckCircle2 className="w-4 h-4 text-blue-500 mt-0.5 flex-shrink-0" />
           <p className="text-[11px] text-blue-700 dark:text-blue-300 leading-normal">
             This ad will be activated across the selected network immediately after the transaction is verified.
           </p>
        </div>
      </div>
    </div>
  )
}
