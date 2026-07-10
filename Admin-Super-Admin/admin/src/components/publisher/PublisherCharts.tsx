import * as React from "react"
import { motion } from "framer-motion"
import {
  LineChart, Line, BarChart, Bar,
  XAxis, YAxis, CartesianGrid, Tooltip, ResponsiveContainer, Legend, Area, LabelList,
  CartesianAxis
} from 'recharts'
import type { PublisherAnalytics, Publisher } from "../../services/publishers"


interface PublisherChartsProps {
  trends: PublisherAnalytics['trends']
  campaigns: PublisherAnalytics['campaigns']
  publishers?: Publisher[]
}

const CustomTooltip = ({ active, payload, label }: any) => {
  if (!active || !payload?.length) return null

  return (
    <div className="bg-white rounded-2xl shadow-xl border border-gray-200 p-5 min-w-[220px]">
      <h3 className="text-2xl font-bold text-gray-900 mb-4">
        {label}
      </h3>

      {payload.map((item, index) => (
        <div
          key={index}
          className="flex items-center gap-3 mb-2"
        >
          <div
            className="w-4 h-4 rounded-full"
            style={{ background: item.color }}
          />

          <span className="text-gray-600">
            {item.name}:
          </span>

          <span className="font-bold text-gray-900">
            {typeof item.value === 'number' ? item.value.toLocaleString() : item.value}
          </span>
        </div>
      ))}
    </div>
  )
}



export function PublisherCharts({ trends, campaigns, publishers = [] }: PublisherChartsProps) {
  // Sort campaigns by impressions descending and take top 5
  const sorted = [...campaigns].sort((a, b) => b.impressions - a.impressions);
  const barData = sorted.slice(0, 5).map(c => ({ name: c.title, impressions: c.impressions, clicks: c.clicks, }));
  // const barData = [
  //   { name: "Campaign A", impressions: 12000, clicks: 400 },
  //   { name: "Campaign B", impressions: 9000, clicks: 300 },
  //   { name: "Campaign C", impressions: 7000, clicks: 250 },
  // ];

  return (
    <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
      {/* Line Chart - Historical Trends */}
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 0.5, delay: 0.2 }}
        className="bg-white dark:bg-[#1A1D24] rounded-2xl p-6 shadow-sm border border-gray-200 dark:border-gray-800 flex flex-col"
      >
        <h3 className="text-base font-semibold text-gray-900 dark:text-white mb-6">Historical Engagement</h3>
        <div className="h-[300px] w-full mt-auto">
          <ResponsiveContainer width="100%" height="100%">
            <LineChart
              data={trends}
              margin={{ top: 20, right: 30, left: 20, bottom: 20 }}
            >
              {/* Gradient definitions for lines */}
              <defs>
                <linearGradient id="gradientImpression" x1="0" y1="0" x2="0" y2="1">
                  <stop offset="5%" stopColor="#F97316" stopOpacity={0.8} />
                  <stop offset="95%" stopColor="#F97316" stopOpacity={0} />
                </linearGradient>
                <linearGradient id="gradientClicks" x1="0" y1="0" x2="0" y2="1">
                  <stop offset="5%" stopColor="#22C55E" stopOpacity={0.8} />
                  <stop offset="95%" stopColor="#22C55E" stopOpacity={0} />
                </linearGradient>
              </defs>

              <CartesianGrid strokeDasharray="5 5" vertical={false} stroke="#D1D5DB" />

              <XAxis
                dataKey="date"
                tickLine={false}
                axisLine={false}
                fontSize={13}
                tickFormatter={(val) =>
                  new Date(val).toLocaleDateString(undefined, {
                    month: "short",
                    day: "numeric",
                  })
                }
                label={{
                  value: "Date",
                  position: "insideBottom",
                  offset: -5,
                  style: {
                    fill: "#9CA3AF",
                    fontSize: 14,
                    fontWeight: 500,
                  },
                }}
              />

              <YAxis
                tickLine={false}
                axisLine={false}
                fontSize={13}
                label={{
                  value: "Clicks & Impressions",
                  angle: -90,
                  position: "insideLeft",
                  dy: 80, // move down
                }}
              />

              <Tooltip
                content={<CustomTooltip />}
                cursor={{ stroke: "#6B7280", strokeDasharray: "4 4", strokeWidth: 1 }}
              />

              <Legend
                verticalAlign="top"
                align="right"
                iconType="circle"
                wrapperStyle={{ paddingBottom: "20px", fontWeight: 600 }}
              />

              {/* Area for Impressions with gradient */}
              <Area
                connectNulls
                dot={false}
                type="monotone"
                dataKey="impressions"
                name="IMPRESSIONS"
                stroke="#F97316"
                fill="url(#gradientImpression)"
                strokeWidth={3}
                activeDot={{ r: 8, fill: "#F97316", stroke: "#fff", strokeWidth: 2 }}
              />

              {/* Line for Clicks */}
              <Line
                connectNulls
                dot={false}
                dataKey="clicks"
                name="CLICKS"
                stroke="#22C55E"
                strokeWidth={4}
                activeDot={{ r: 8, fill: "#22C55E", stroke: "#fff", strokeWidth: 3 }}
              />
            </LineChart>
          </ResponsiveContainer>
        </div>
      </motion.div>

    </div>
  )
}
