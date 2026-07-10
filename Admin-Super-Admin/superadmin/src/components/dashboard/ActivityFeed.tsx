import { AlertCircle, CheckCircle, Clock3, MapPinned } from 'lucide-react'
import type { RecentActivity } from '../../lib/dashboard'

interface ActivityFeedProps {
  activities: RecentActivity[]
}

function formatRelativeTime(timestamp: string) {
  const diffMs = Date.now() - new Date(timestamp).getTime()
  const minutes = Math.max(1, Math.floor(diffMs / 60000))

  if (minutes < 60) return `${minutes} min ago`
  const hours = Math.floor(minutes / 60)
  if (hours < 24) return `${hours} hr ago`
  const days = Math.floor(hours / 24)
  return `${days} day${days > 1 ? 's' : ''} ago`
}

function getStatusMeta(status: string) {
  switch (status) {
    case 'ACTIVE':
      return { icon: MapPinned, iconBg: 'bg-green-100', iconColor: 'text-green-600' }
    case 'COMPLETED':
      return { icon: CheckCircle, iconBg: 'bg-blue-100', iconColor: 'text-blue-600' }
    case 'PENDING':
      return { icon: Clock3, iconBg: 'bg-yellow-100', iconColor: 'text-yellow-600' }
    default:
      return { icon: AlertCircle, iconBg: 'bg-red-100', iconColor: 'text-red-500' }
  }
}

export default function ActivityFeed({ activities }: ActivityFeedProps) {
  return (
    <div className="glass-card p-6 animate-fade-in h-full flex flex-col">
      <div className="flex items-center justify-between mb-5">
        <div>
          <h3 className="text-sm font-semibold text-gray-900">Recent Campaign Activity</h3>
          <p className="text-xs text-gray-400 mt-0.5">Latest events coming from live publish records</p>
        </div>
      </div>

      <div className="flex flex-col gap-0 flex-1">
        {activities.map((item, index) => {
          const meta = getStatusMeta(item.status)
          const Icon = meta.icon
          const isLast = index === activities.length - 1
          return (
            <div key={item.id} className="flex gap-3">
              <div className="flex flex-col items-center">
                <div className={`w-8 h-8 ${meta.iconBg} rounded-lg flex items-center justify-center flex-shrink-0 z-10`}>
                  <Icon size={14} className={meta.iconColor} />
                </div>
                {!isLast && <div className="w-px flex-1 bg-gray-100 my-1" />}
              </div>
              <div className={`flex-1 min-w-0 ${!isLast ? 'pb-4' : ''}`}>
                <p className="text-xs text-gray-700 leading-relaxed">{item.action}</p>
                <p className="text-[11px] text-gray-400 mt-0.5">
                  {formatRelativeTime(item.occurredAt)}{item.locationName ? ` • ${item.locationName}` : ''}
                </p>
              </div>
            </div>
          )
        })}
      </div>
    </div>
  )
}
