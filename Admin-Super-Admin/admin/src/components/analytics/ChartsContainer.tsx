import * as React from "react"
import { 
  LineChart, 
  Line, 
  XAxis, 
  YAxis, 
  CartesianGrid, 
  Tooltip, 
  ResponsiveContainer, 
  BarChart, 
  Bar 
} from "recharts"
import type { TrendData } from "../../services/analytics"

interface ChartsContainerProps {
  data: TrendData[]
}

export function ChartsContainer({ data }: ChartsContainerProps) {
  return (
    <div className="grid grid-cols-1 lg:grid-cols-2 gap-8 mb-8">
      {/* 1. Performance Trend (Line) */}
      <div className="bg-white dark:bg-[#1A1D24] p-8 rounded-[2rem] border border-gray-100 dark:border-gray-800 shadow-sm">
        <div className="flex items-center justify-between mb-8">
          <div>
             <h3 className="text-lg font-black text-gray-900 dark:text-white tracking-tight">Performance Trend</h3>
             <p className="text-xs text-gray-400 font-medium">Daily impressions vs Click transitions</p>
          </div>
          <div className="flex gap-4">
             <div className="flex items-center gap-2">
                <div className="w-2 h-2 bg-brand-500 rounded-full" />
                <span className="text-[10px] font-bold text-gray-400 uppercase">Impressions</span>
             </div>
             <div className="flex items-center gap-2">
                <div className="w-2 h-2 bg-emerald-500 rounded-full" />
                <span className="text-[10px] font-bold text-gray-400 uppercase">Clicks</span>
             </div>
          </div>
        </div>
        
        <div className="h-[300px] w-full">
          <ResponsiveContainer width="100%" height="100%">
            <LineChart data={data} margin={{ top: 10, right: 20, left: 15, bottom: 20 }}>
              <CartesianGrid strokeDasharray="3 3" vertical={false} stroke="#E5E7EB" opacity={0.3} />
              <XAxis 
                dataKey="time" 
                axisLine={false} 
                tickLine={false} 
                tick={{ fontSize: 10, fontWeight: 700, fill: '#9CA3AF' }} 
                dy={10}
                label={{ value: 'Date', position: 'insideBottom', offset: -10, style: { fontSize: 10, fill: '#9CA3AF', fontWeight: 700 } }}
              />
              <YAxis 
                axisLine={false} 
                tickLine={false} 
                tick={{ fontSize: 10, fontWeight: 700, fill: '#9CA3AF' }} 
                label={{ value: 'Impressions & Clicks', angle: -90, position: 'insideLeft', offset: -5, style: { fontSize: 10, fill: '#9CA3AF', fontWeight: 700, textAnchor: 'middle' } }}
              />
              <Tooltip 
                contentStyle={{ 
                  borderRadius: '16px', 
                  border: 'none', 
                  boxShadow: '0 10px 15px -3px rgb(0 0 0 / 0.1)',
                  backgroundColor: '#111827',
                  color: '#fff'
                }} 
              />
              <Line 
                type="monotone" 
                dataKey="impressions" 
                stroke="#6366f1" 
                strokeWidth={4} 
                dot={false} 
                activeDot={{ r: 6, strokeWidth: 0 }} 
              />
              <Line 
                type="monotone" 
                dataKey="clicks" 
                stroke="#10b981" 
                strokeWidth={4} 
                dot={false} 
              />
            </LineChart>
          </ResponsiveContainer>
        </div>
      </div>

      {/* 2. Spend vs Engagement (Bar) */}
      <div className="bg-white dark:bg-[#1A1D24] p-8 rounded-[2rem] border border-gray-100 dark:border-gray-800 shadow-sm">
        <div className="flex items-center justify-between mb-8">
           <div>
              <h3 className="text-lg font-black text-gray-900 dark:text-white tracking-tight">Budget Efficiency</h3>
              <p className="text-xs text-gray-400 font-medium">Tracking spend velocity against clicks</p>
           </div>
        </div>

        <div className="h-[300px] w-full">
           <ResponsiveContainer width="100%" height="100%">
             <BarChart data={data} margin={{ top: 10, right: 20, left: 15, bottom: 20 }}>
               <CartesianGrid strokeDasharray="3 3" vertical={false} stroke="#E5E7EB" opacity={0.3} />
               <XAxis 
                 dataKey="time" 
                 axisLine={false} 
                 tickLine={false} 
                 tick={{ fontSize: 10, fontWeight: 700, fill: '#9CA3AF' }} 
                 dy={10}
                 label={{ value: 'Date', position: 'insideBottom', offset: -10, style: { fontSize: 10, fill: '#9CA3AF', fontWeight: 700 } }}
               />
               <YAxis 
                 axisLine={false} 
                 tickLine={false} 
                 tick={{ fontSize: 10, fill: '#9CA3AF' }} 
                 label={{ value: 'Spend & Clicks', angle: -90, position: 'insideLeft', offset: -5, style: { fontSize: 10, fill: '#9CA3AF', fontWeight: 700, textAnchor: 'middle' } }}
               />
               <Tooltip 
                 cursor={{ fill: 'transparent' }}
                 contentStyle={{ borderRadius: '16px', border: 'none', backgroundColor: '#111827' }} 
               />
               <Bar dataKey="spend" fill="#f59e0b" radius={[4, 4, 0, 0]} barSize={20} />
               <Bar dataKey="clicks" fill="#6366f1" radius={[4, 4, 0, 0]} barSize={20} />
             </BarChart>
           </ResponsiveContainer>
        </div>
      </div>
    </div>
  )
}
