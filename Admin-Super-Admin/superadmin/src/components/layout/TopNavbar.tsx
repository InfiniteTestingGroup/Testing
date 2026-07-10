import { useState } from 'react'
import {
  Bell,
  ChevronDown,
  User,
  LogOut,
  Menu,
  UserPlus,
  Ticket,
} from 'lucide-react'
import { useNavigate } from 'react-router-dom'
import { getAuthSession, getRoleLabel, logoutSuperAdmin } from '../../lib/auth'
import {
  useSuperAdminNotifications,
  type SuperAdminNotification,
} from '../../hooks/useSuperAdminNotifications'

interface TopNavbarProps {
  onMenuToggle: () => void
}

function timeAgo(isoString: string): string {
  const diff = Date.now() - new Date(isoString).getTime()
  const mins = Math.floor(diff / 60000)

  if (mins < 1) return 'just now'
  if (mins < 60) return `${mins}m ago`

  const hrs = Math.floor(mins / 60)
  if (hrs < 24) return `${hrs}h ago`

  return `${Math.floor(hrs / 24)}d ago`
}

function notificationIcon(type: SuperAdminNotification['type']) {
  if (type === 'ticket_raised' || type === 'ticket_replied') {
    return <Ticket size={14} />
  }

  return <UserPlus size={14} />
}

function notificationColor(type: SuperAdminNotification['type']): string {
  switch (type) {
    case 'admin_pending':
      return 'bg-amber-100 text-amber-600'
    case 'ticket_raised':
      return 'bg-blue-100 text-blue-600'
    case 'ticket_replied':
      return 'bg-purple-100 text-purple-600'
    default:
      return 'bg-primary-100 text-primary-600'
  }
}

export default function TopNavbar({ onMenuToggle }: TopNavbarProps) {
  const [notifOpen, setNotifOpen] = useState(false)
  const [profileOpen, setProfileOpen] = useState(false)
  const navigate = useNavigate()
  const session = getAuthSession()

  const {
    notifications,
    unreadCount,
    loading,
    reload,
    dismissByType,
    dismissTicketNotifications,
  } = useSuperAdminNotifications()

  const handleLogout = async () => {
    await logoutSuperAdmin()
    setProfileOpen(false)
    navigate('/?reason=logged-out', { replace: true })
  }

  const handleNotificationClick = (notification: SuperAdminNotification) => {
    if (notification.type === 'admin_pending') {
      dismissByType('admin_pending')
      navigate('/admins')
    }

    if (notification.type === 'ticket_raised' || notification.type === 'ticket_replied') {
      dismissTicketNotifications()
      navigate('/tickets')
    }

    setNotifOpen(false)
  }

  return (
    <header className="h-16 bg-white shadow-navbar flex items-center px-6 gap-4 sticky top-0 z-20">
      {/* Mobile menu toggle */}
      <button
        onClick={onMenuToggle}
        className="lg:hidden p-2 rounded-lg hover:bg-gray-100 text-gray-500 transition-colors"
      >
        <Menu size={20} />
      </button>

      {/* Brand */}
      <div className="flex items-center gap-2">
        <div className="w-8 h-8 rounded-lg bg-primary-500 flex items-center justify-center text-white font-bold shadow-sm">
          K
        </div>
        <h1 className="text-xl font-bold tracking-wide text-gray-900">
          KELIRI{' '}
          <span className="text-sm font-semibold text-primary-500 uppercase tracking-widest ml-1">
            SuperAdmin
          </span>
        </h1>
      </div>

      <div className="flex items-center gap-2 ml-auto">
        {/* Notifications */}
        <div className="relative">
          <button
            onClick={() => {
              const nextOpen = !notifOpen
              setNotifOpen(nextOpen)
              setProfileOpen(false)
              if (nextOpen) reload()
            }}
            className="relative p-2 rounded-xl hover:bg-gray-100 transition-colors text-gray-600"
          >
            <Bell size={20} />
            {unreadCount > 0 && (
              <span className="absolute top-1 right-1 min-w-4 h-4 px-1 bg-primary-500 text-white text-[9px] font-bold rounded-full flex items-center justify-center animate-pulse-soft">
                {unreadCount > 9 ? '9+' : unreadCount}
              </span>
            )}
          </button>

          {notifOpen && (
            <>
              <div className="fixed inset-0 z-40" onClick={() => setNotifOpen(false)} />

              <div className="absolute right-0 top-12 w-96 bg-white rounded-2xl shadow-card-hover border border-gray-100 z-50 animate-fade-in overflow-hidden">
                <div className="flex items-center justify-between px-4 py-3 border-b border-gray-100">
                  <p className="font-semibold text-gray-900 text-sm">Notifications</p>

                  <span className="badge-primary text-[10px] px-2 py-0.5">
                    {unreadCount} new
                  </span>
                </div>

                <div className="divide-y divide-gray-50 max-h-[420px] overflow-y-auto">
                  {loading ? (
                    <div className="px-4 py-8 text-center text-sm text-gray-400">
                      Loading...
                    </div>
                  ) : notifications.length === 0 ? (
                    <div className="px-4 py-8 text-center">
                      <Bell size={28} className="text-gray-200 mx-auto mb-2" />
                      <p className="text-sm text-gray-400 font-medium">
                        No notifications in the last 24 hours
                      </p>
                    </div>
                  ) : (
                    notifications.map((n) => (
                      <div
                        key={n.id}
                        onClick={() => handleNotificationClick(n)}
                        className={`px-4 py-3 hover:bg-gray-50 transition-colors cursor-pointer ${n.unread ? 'bg-primary-50/40' : ''
                          }`}
                      >
                        <div className="flex items-start gap-3">
                          <div
                            className={`p-2 rounded-xl flex-shrink-0 mt-0.5 ${notificationColor(
                              n.type,
                            )}`}
                          >
                            {notificationIcon(n.type)}
                          </div>

                          <div className="flex-1 min-w-0">
                            <div className="flex items-center justify-between gap-2">
                              <p className="text-xs font-bold text-gray-800 truncate">
                                {n.title}
                              </p>
                              <p className="text-[10px] text-gray-400 flex-shrink-0">
                                {timeAgo(n.time)}
                              </p>
                            </div>

                            <p className="text-xs text-gray-700 leading-relaxed mt-0.5 line-clamp-2">
                              {n.message}
                            </p>
                          </div>

                          {n.unread && (
                            <span className="w-2 h-2 rounded-full bg-primary-500 mt-1.5 flex-shrink-0" />
                          )}
                        </div>
                      </div>
                    ))
                  )}
                </div>

                <div className="px-4 py-3 border-t border-gray-100 text-center bg-gray-50/50">
                  <button
                    type="button"
                    onClick={() => {
                      navigate('/analytics')
                      setNotifOpen(false)
                    }}
                    className="text-xs font-semibold text-primary-600 hover:text-primary-700 transition-colors"
                  >
                    View Analytics
                  </button>
                </div>
              </div>
            </>
          )}
        </div>

        {/* Profile */}
        <div className="relative">
          <button
            onClick={() => {
              setProfileOpen(!profileOpen)
              setNotifOpen(false)
            }}
            className="flex items-center gap-2 pl-2 pr-3 py-1.5 rounded-xl hover:bg-gray-100 transition-colors"
          >
            <div className="w-8 h-8 bg-gradient-to-br from-primary-400 to-primary-600 rounded-full flex items-center justify-center">
              <span className="text-white font-semibold text-xs">SA</span>
            </div>

            <div className="text-left hidden sm:block">
              <p className="text-xs font-semibold text-gray-800">Super Admin</p>
              <p className="text-[10px] text-primary-600">{getRoleLabel(session?.role)}</p>
              <p className="text-[10px] text-gray-500">
                {session?.email ?? 'admin@keliri.com'}
              </p>
            </div>

            <ChevronDown
              size={14}
              className={`text-gray-500 transition-transform duration-200 ${profileOpen ? 'rotate-180' : ''
                }`}
            />
          </button>

          {profileOpen && (
            <>
              <div className="fixed inset-0 z-40" onClick={() => setProfileOpen(false)} />

              <div className="absolute right-0 top-12 w-48 bg-white rounded-2xl shadow-card-hover border border-gray-100 z-50 animate-fade-in overflow-hidden">
                <div className="px-4 py-3 border-b border-gray-100">
                  <p className="text-xs font-semibold text-gray-800">
                    {getRoleLabel(session?.role)}
                  </p>
                  <p className="text-[10px] text-gray-400">
                    {session?.email ?? 'admin@keliri.com'}
                  </p>
                </div>

                <div className="py-1">
                  <button
                    onClick={() => {
                      navigate('/profile')
                      setProfileOpen(false)
                    }}
                    className="w-full flex items-center gap-3 px-4 py-2 text-sm text-gray-700 hover:bg-gray-50 transition-colors"
                  >
                    <User size={14} /> Profile
                  </button>


                  <button
                    onClick={handleLogout}
                    className="w-full flex items-center gap-3 px-4 py-2 text-sm text-red-500 hover:bg-red-50 transition-colors"
                  >
                    <LogOut size={14} /> Sign Out
                  </button>
                </div>
              </div>
            </>
          )}
        </div>
      </div>
    </header>
  )
}
