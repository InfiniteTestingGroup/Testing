import * as React from "react"
import { CreditCard, Info, MapPin, Radio, Calendar } from "lucide-react"
import type { Advertisement } from "../../services/ads"

interface AdSummaryCardProps {
  ad: Advertisement
  days: number
  numPublishers: number
  costPerDay: number
  onPublish: () => void
  isSubmitting: boolean
}

export function AdSummaryCard({ 
  ad, 
  days, 
  numPublishers, 
  costPerDay, 
  onPublish, 
  isSubmitting 
}: AdSummaryCardProps) {
  const totalCost = days * costPerDay * numPublishers

  return (
    <div className="sticky top-24 bg-white dark:bg-[#1A1D24] shadow-xl border border-gray-200 dark:border-gray-800 rounded-2xl overflow-hidden transition-all duration-300">
      <div className="p-6">
        <h3 className="text-lg font-bold text-gray-900 dark:text-white mb-4 flex items-center gap-2">
          <CreditCard className="w-5 h-5 text-brand-500" />
          Publication Summary
        </h3>

        {/* Ad Preview Section */}
        <div className="flex gap-4 p-4 mb-6 rounded-xl bg-gray-50 dark:bg-[#1C1F26] border border-gray-100 dark:border-gray-800">
          <div className="w-16 h-16 rounded-lg bg-gray-200 dark:bg-gray-800 flex-shrink-0 flex items-center justify-center overflow-hidden">
             {/* Thumbnail placeholder */}
             <Radio className="w-8 h-8 text-gray-400" />
          </div>
          <div className="overflow-hidden">
            <p className="text-sm font-bold text-gray-900 dark:text-white truncate">{ad.title}</p>
            <p className="text-xs text-gray-500">{ad.status} Advertisement</p>
            <span className="mt-2 inline-flex items-center px-2 py-0.5 rounded text-[10px] font-bold bg-brand-50 text-brand-600 dark:bg-brand-500/10 dark:text-brand-400 border border-brand-100 dark:border-brand-500/20 uppercase tracking-wider">
              {ad.id}
            </span>
          </div>
        </div>

        {/* Calculation Details */}
        <div className="space-y-4 mb-8">
          <div className="flex justify-between text-sm">
            <span className="text-gray-500">Assignment Count</span>
            <span className="font-semibold text-gray-900 dark:text-gray-200">{numPublishers} Publisher(s)</span>
          </div>
          <div className="flex justify-between text-sm">
            <span className="text-gray-500">Duration</span>
            <span className="font-semibold text-gray-900 dark:text-gray-200">{days} Day(s)</span>
          </div>
          <div className="flex justify-between text-sm">
            <span className="text-gray-500">Base Rate</span>
            <span className="font-semibold text-gray-900 dark:text-gray-200">₹365 / Year</span>
          </div>

          <div className="pt-4 border-t border-gray-100 dark:border-gray-800">
            <div className="flex justify-between items-baseline mb-1">
              <span className="text-gray-900 dark:text-white font-bold text-lg">Total Amount</span>
              <span className="text-brand-600 dark:text-brand-400 font-black text-2xl">
                ₹{Math.ceil(totalCost)}
              </span>
            </div>
            <p className="text-[10px] text-gray-400 text-right leading-tight italic">
              * (₹1.00 / day) × {days} days × {numPublishers} publishers
            </p>
          </div>
        </div>

        {/* CTA */}
        <button
          onClick={onPublish}
          disabled={isSubmitting || numPublishers === 0 || days <= 0}
          className="w-full bg-brand-500 hover:bg-brand-600 disabled:bg-gray-200 dark:disabled:bg-gray-800 disabled:text-gray-400 disabled:cursor-not-allowed text-white py-4 rounded-xl font-bold flex items-center justify-center gap-2 shadow-lg shadow-brand-500/20 active:scale-95 transition-all text-sm uppercase tracking-widest"
        >
          {isSubmitting ? (
            <span className="flex items-center gap-2">
              <div className="w-4 h-4 border-2 border-white/30 border-t-white rounded-full animate-spin" />
              Processing...
            </span>
          ) : (
            "Proceed to Payment"
          )}
        </button>

        <div className="mt-4 flex items-center gap-2 justify-center text-[10px] text-gray-400 uppercase font-bold tracking-widest">
           <Info className="w-3 h-3" />
           Secure Transaction Guaranteed
        </div>
      </div>
    </div>
  )
}
