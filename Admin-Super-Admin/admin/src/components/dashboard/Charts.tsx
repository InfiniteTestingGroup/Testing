import {

  LineChart,

  Line,

  XAxis,

  YAxis,

  CartesianGrid,

  Tooltip,

  ResponsiveContainer,

} from "recharts"

import { Card } from "../ui/Card"

import { motion } from "framer-motion"

interface ChartProps {

  data: any[]

  title: string

  delay?: number

}

const CustomTooltip = ({ active, payload, label }: any) => {

  if (active && payload && payload.length) {

    return (

      <div className="bg-white dark:bg-gray-800 border dark:border-gray-700 p-3 rounded-lg shadow-lg">

        <p className="font-semibold text-gray-900 dark:text-white mb-2">{label}</p>

        {payload.map((entry: any, index: number) => (

          <p key={index} className="text-sm flex items-center gap-2">

            <span className="w-3 h-3 rounded-full" style={{ backgroundColor: entry.color }} />

            <span className="text-gray-600 dark:text-gray-300 capitalize">{entry.name}:</span>

            <span className="font-medium text-gray-900 dark:text-white">{entry.value}</span>

          </p>

        ))}

      </div>

    )

  }

  return null

}

const axisLabelStyle = { fontSize: 12, fill: '#6B7280', fontWeight: 500 }

function ChartLegend({ items }: { items: { label: string; color: string }[] }) {

  return (

    <div className="flex items-center gap-4 shrink-0">

      {items.map((item) => (

        <span key={item.label} className="flex items-center gap-1.5 text-xs font-semibold text-gray-500 dark:text-gray-400 uppercase tracking-wide whitespace-nowrap">

          <span className="w-2.5 h-2.5 rounded-full inline-block" style={{ backgroundColor: item.color }} />

          {item.label}

        </span>

      ))}

    </div>

  )

}

export function PerformanceChart({ data, title, delay = 0 }: ChartProps) {

  return (

    <motion.div

      initial={{ opacity: 0, scale: 0.95 }}

      animate={{ opacity: 1, scale: 1 }}

      transition={{ duration: 0.5, delay }}

      className="h-full"

    >

      <Card className="p-6 h-full flex flex-col">

        <div className="flex items-center justify-between mb-6 gap-4">

          <h3 className="text-lg font-semibold text-gray-900 dark:text-white whitespace-nowrap">{title}</h3>

          <ChartLegend items={[

            { label: 'Impressions', color: '#f97316' },

            { label: 'Clicks', color: '#22c55e' },

          ]} />

        </div>

        <div className="flex-1 w-full min-h-[300px]">

          <ResponsiveContainer width="100%" height="100%">

            <LineChart data={data} margin={{ top: 5, right: 20, left: 30, bottom: 40 }}>

              <CartesianGrid strokeDasharray="3 3" vertical={false} stroke="#374151" opacity={0.2} />

              <XAxis

                dataKey="name"

                axisLine={false}

                tickLine={false}

                tick={{ fill: '#6B7280', fontSize: 11 }}

                dy={10}

                interval="preserveStartEnd"

                label={{ value: 'Months', position: 'insideBottom', offset: -20, style: axisLabelStyle }}

              />

              <YAxis

                axisLine={false}

                tickLine={false}

                tick={{ fill: '#6B7280', fontSize: 12 }}

                width={55}

                label={{ value: 'Clicks & Impressions', angle: -90, position: 'insideLeft', offset: 15, dy: 70, style: axisLabelStyle }}

              />

              <Tooltip content={<CustomTooltip />} cursor={{ stroke: '#6B7280', strokeWidth: 1, strokeDasharray: '3 3' }} />

              <Line type="monotone" dataKey="impressions" name="Impressions" stroke="#f97316" strokeWidth={3} dot={false} activeDot={{ r: 6, strokeWidth: 0 }} />

              <Line type="monotone" dataKey="clicks" name="Clicks" stroke="#22c55e" strokeWidth={3} dot={false} activeDot={{ r: 6, strokeWidth: 0 }} />

            </LineChart>

          </ResponsiveContainer>

        </div>

      </Card>

    </motion.div>

  )

}