import { motion } from "framer-motion"
import { Card } from "../ui/Card"
import { Badge } from "../ui/Badge"
import { Clock } from "lucide-react"

export interface Activity {
  id: string
  title: string
  status: "Active" | "Draft" | "Expired"
  publisher: string
  date: string
  daysAgo?: number
}

interface RecentActivityProps {
  data: Activity[]
  delay?: number
}

export function RecentActivity({ data, delay = 0 }: RecentActivityProps) {
  const getBadgeVariant = (status: Activity["status"]) => {
    switch (status) {
      case "Active":
        return "success"
      case "Draft":
        return "neutral"
      case "Expired":
        return "danger"
      default:
        return "default"
    }
  }

  return (
    <motion.div
      initial={{ opacity: 0, scale: 0.95 }}
      animate={{ opacity: 1, scale: 1 }}
      transition={{ duration: 0.5, delay }}
    >
      <Card className="overflow-hidden">
        <div className="p-6 border-b border-gray-100 dark:border-gray-800">
          <h3 className="text-lg font-semibold text-gray-900 dark:text-white flex items-center gap-2">
            <Clock className="w-5 h-5 text-brand-500" />
            Recent Activity
          </h3>
        </div>
        <div className="overflow-x-auto">
          <table className="w-full text-sm text-left">
            <thead className="text-xs text-gray-500 uppercase bg-gray-50 dark:bg-[#1C1F26] dark:text-gray-400">
              <tr>
                <th className="px-6 py-4 font-medium">Ad Name</th>
                <th className="px-6 py-4 font-medium">Status</th>
                <th className="px-6 py-4 font-medium">Publisher</th>
                <th className="px-6 py-4 font-medium">Date</th>
              </tr>
            </thead>
            <tbody>
              {data.map((item, index) => (
                <motion.tr
                  initial={{ opacity: 0, x: -20 }}
                  animate={{ opacity: 1, x: 0 }}
                  transition={{ duration: 0.3, delay: delay + index * 0.1 }}
                  key={item.id}
                  className="border-b border-gray-100 dark:border-gray-800 hover:bg-gray-50/50 dark:hover:bg-gray-800/50 transition-colors cursor-pointer group last:border-b-0"
                >
                  <td className="px-6 py-4 font-medium text-gray-900 dark:text-white group-hover:text-brand-500 transition-colors">
                    {item.title}
                  </td>
                  <td className="px-6 py-4">
                    <Badge variant={getBadgeVariant(item.status)}>{item.status}</Badge>
                  </td>
                  <td className="px-6 py-4 text-gray-600 dark:text-gray-300">
                    {item.publisher}
                  </td>
                  <td className="px-6 py-4 text-gray-500 dark:text-gray-400">
                    {item.daysAgo !== undefined ? `${item.daysAgo} day ago` : item.date}
                  </td>
                </motion.tr>
              ))}
            </tbody>
          </table>
        </div>
      </Card>
    </motion.div>
  )
}
