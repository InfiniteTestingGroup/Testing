import { PieChart, Pie, Cell, ResponsiveContainer, Tooltip } from 'recharts'

interface RevenueDistributionChartProps {
  data?: { name: string; value: number; color: string }[]
}

interface CustomTooltipProps {
  active?: boolean
  payload?: { value: number; name: string }[]
}

const CustomTooltip = ({ active, payload }: CustomTooltipProps) => {
  if (active && payload && payload.length) {
    return (
      <div className="bg-white border border-gray-100 rounded-xl shadow-card-hover px-3.5 py-2.5">
        <p className="text-[11px] text-gray-400 mb-1">{payload[0].name}</p>
        <p className="text-sm font-bold text-gray-900">
          ₹{payload[0].value.toLocaleString()}
        </p>
      </div>
    )
  }
  return null
}


export default function RevenueDistributionChart({ data = [] }: RevenueDistributionChartProps) {
  return (
    <div className="glass-card p-5 animate-fade-in">
      <div className="mb-3">
        <h3 className="text-sm font-semibold text-gray-900">Revenue by Ad Type</h3>
        <p className="text-xs text-gray-400 mt-0.5">Distribution across formats</p>
      </div>

      <div className="flex flex-col lg:flex-row items-center justify-center gap-20 py-1">
        {/* Donut Chart */}
        <div className="w-[240px] h-[240px]">
          <ResponsiveContainer width="100%" height="100%">
            <PieChart>
              <Pie
                data={data}
                cx="50%"
                cy="50%"
                innerRadius={65}
                outerRadius={90}
                paddingAngle={4}
                dataKey="value"
                stroke="none"
              >
                {data.map((entry, index) => (
                  <Cell key={`cell-${index}`} fill={entry.color} />
                ))}
              </Pie>
              <Tooltip content={<CustomTooltip />} />
            </PieChart>
          </ResponsiveContainer>
        </div>

        {/* Revenue Breakdown */}
        <div className="w-full max-w-sm lg:ml-12">
          <div className="space-y-4">
            {data.map((item, index) => (
              <div
                key={index}
                className="flex items-center justify-between border-b border-gray-100 pb-3"
              >
                <div className="flex items-center gap-3">
                  <span
                    className="w-3 h-3 rounded-full"
                    style={{ backgroundColor: item.color }}
                  />
                  <span className="text-sm font-medium text-gray-700">
                    {item.name}
                  </span>
                </div>

                <span className="text-sm font-bold text-gray-900">
                  ₹{item.value.toLocaleString()}
                </span>
              </div>
            ))}
          </div>
        </div>
      </div>
    </div>
  )
}
