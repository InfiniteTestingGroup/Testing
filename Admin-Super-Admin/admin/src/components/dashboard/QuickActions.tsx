import * as React from "react"
import { motion } from "framer-motion"
import { PlusCircle, Rocket, UserPlus, CreditCard, BarChart3 } from "lucide-react"

export function QuickActions() {
  const actions = [
    {
      title: "Create New Ad",
      icon: <PlusCircle className="w-6 h-6" />,
      color: "from-orange-500 to-amber-500 dark:from-orange-600 dark:to-orange-500",
      delay: 0.1,
    },
    {
      title: "Publish Ad",
      icon: <Rocket className="w-6 h-6" />,
      color: "from-blue-500 to-cyan-500 dark:from-blue-600 dark:to-blue-500",
      delay: 0.2,
    },
    {
      title: "Add Publisher",
      icon: <UserPlus className="w-6 h-6" />,
      color: "from-emerald-500 to-teal-500 dark:from-emerald-600 dark:to-emerald-500",
      delay: 0.3,
    },
    {
      title: "View Payments",
      icon: <CreditCard className="w-6 h-6" />,
      color: "from-purple-500 to-indigo-500 dark:from-purple-600 dark:to-indigo-500",
      delay: 0.4,
    },
  ]

  return (
    <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
      {actions.map((action, index) => (
        <motion.button
          key={index}
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.4, delay: action.delay }}
          whileHover={{ scale: 1.02 }}
          whileTap={{ scale: 0.98 }}
          onClick={() => {
            if (action.title === "Add Publisher") {
              window.location.href = "/admin/publishers"
            } else if (action.title === "Create New Ad" || action.title === "Publish Ad") {
              window.location.href = "/admin/ads"
            } else if (action.title === "View Payments") {
              window.location.href = "/admin/payments"
            }
          }}
          className={`relative overflow-hidden flex items-center justify-center gap-3 p-6 rounded-2xl text-white font-semibold text-lg shadow-lg bg-gradient-to-r ${action.color} transition-all hover:shadow-xl`}
        >
          {action.icon}
          {action.title}
          <div className="absolute inset-0 bg-white/20 opacity-0 hover:opacity-100 transition-opacity rounded-2xl pointer-events-none" />
        </motion.button>
      ))}
    </div>
  )
}
