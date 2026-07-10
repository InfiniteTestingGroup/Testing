import { NavLink, useNavigate } from 'react-router-dom'
import {
  LayoutDashboard,
  BarChart3,
  Users,
  Megaphone,
  DollarSign,
  Ticket,
  ShieldCheck,
  ChevronLeft,
  ChevronRight,
  LogOut,
  Radio,
  ClipboardList,
  Activity,
} from 'lucide-react'
import logo from '../../assets/lightmodelogo.png'
import icon from '../../assets/keliriicon.png'
import { getAuthSession, getRoleLabel, hasModuleAccess, logoutSuperAdmin } from '../../lib/auth'
import type { PermissionKey } from '../../lib/auth'

interface NavItem {
  id: string
  label: string
  icon: React.ElementType
  path: string
  permission: PermissionKey
  badge?: string
}

const navItems: NavItem[] = [

  { id: 'analytics', label: 'Analytics', icon: BarChart3, path: '/analytics', permission: 'analytics' },
  { id: 'admins', label: 'Admin Management', icon: Users, path: '/admins', permission: 'admins' },
  { id: 'publishers', label: 'Publishers', icon: Radio, path: '/publishers', permission: 'publishers' },
  { id: 'ads', label: 'Advertisements', icon: Megaphone, path: '/ads', permission: 'ads' },
  { id: 'revenue', label: 'Revenue', icon: DollarSign, path: '/revenue', permission: 'revenue' },
  { id: 'transactions', label: 'Transactions', icon: Activity, path: '/transactions', permission: 'transactions' },
  { id: 'tickets', label: 'Tickets & Support', icon: Ticket, path: '/tickets', permission: 'tickets' },
  { id: 'sub-admins', label: 'Sub-Admins', icon: ShieldCheck, path: '/sub-admins', permission: 'subAdmins' },
  { id: 'audit-logs', label: 'Audit Logs', icon: ClipboardList, path: '/audit-logs', permission: 'auditLogs' },
]

interface SidebarProps {
  collapsed: boolean
  onToggle: () => void
}

export default function Sidebar({ collapsed, onToggle }: SidebarProps) {
  const navigate = useNavigate()
  const session = getAuthSession()

  const handleLogout = async () => {
    await logoutSuperAdmin()
    navigate('/?reason=logged-out', { replace: true })
  }

  const visibleItems = navItems.filter((item) => hasModuleAccess(item.permission))

  return (
    <>
      {!collapsed && (
        <div
          className="lg:hidden fixed inset-0 bg-gray-900/40 backdrop-blur-sm z-30 animate-fade-in"
          onClick={onToggle}
        />
      )}

      <aside
        className={`fixed lg:relative flex flex-col bg-white shadow-sidebar transition-all duration-300 ease-in-out h-full flex-shrink-0 z-40
          ${collapsed ? '-translate-x-full lg:translate-x-0 lg:w-[72px]' : 'translate-x-0 w-[240px]'}`}
      >
        <div className={`flex items-center h-16 px-4 border-b border-gray-100 ${collapsed ? 'justify-center' : 'gap-3'}`}>
          <div className="w-9 h-9 rounded-xl flex items-center justify-center flex-shrink-0">
            <img src={icon} alt="KELIRI Logo" className="w-8 h-8 object-contain" />
          </div>
          {!collapsed && (
            <div className="animate-fade-in">
              <img src={logo} alt="KELIRI Logo" className="w-24 h-10 object-contain" />
              <p className="text-[10px] text-primary-500 font-medium tracking-widest uppercase">{getRoleLabel(session?.role)}</p>
            </div>
          )}
        </div>

        <button
          onClick={onToggle}
          className="hidden lg:flex absolute -right-3 top-[72px] z-10 w-6 h-6 bg-white border border-gray-200 rounded-full
                   items-center justify-center shadow-sm hover:bg-primary-50 hover:border-primary-200
                   transition-all duration-200 text-gray-500 hover:text-primary-600"
        >
          {collapsed ? <ChevronRight size={12} /> : <ChevronLeft size={12} />}
        </button>

        <nav className="flex-1 py-4 px-2 overflow-y-auto space-y-1">
          {!collapsed && (
            <p className="text-[10px] font-semibold text-gray-400 uppercase tracking-widest px-3 mb-2">Main Menu</p>
          )}
          {visibleItems.map((item) => {
            const Icon = item.icon
            return (
              <NavLink
                key={item.id}
                to={item.path}
                className={({ isActive }) =>
                  `flex items-center gap-3 px-3 py-2.5 rounded-xl text-sm font-medium transition-all duration-200 cursor-pointer group relative
                ${isActive
                    ? 'bg-primary-50 text-primary-600'
                    : 'text-gray-600 hover:bg-gray-50 hover:text-gray-900'
                  }
                ${collapsed ? 'justify-center' : ''}`
                }
              >
                {({ isActive }) => (
                  <>
                    {isActive && (
                      <span className="absolute left-0 top-1/2 -translate-y-1/2 w-1 h-5 bg-primary-500 rounded-r-full" />
                    )}
                    <Icon size={18} className="flex-shrink-0" />
                    {!collapsed && (
                      <span className="flex-1 animate-fade-in">{item.label}</span>
                    )}
                    {!collapsed && item.badge && (
                      <span className="bg-primary-500 text-white text-[10px] font-bold px-1.5 py-0.5 rounded-full min-w-[18px] text-center">
                        {item.badge}
                      </span>
                    )}
                    {collapsed && (
                      <div className="absolute left-full ml-2 px-2 py-1 bg-gray-900 text-white text-xs rounded-lg
                                   opacity-0 group-hover:opacity-100 pointer-events-none whitespace-nowrap z-50
                                   transition-opacity duration-200">
                        {item.label}
                      </div>
                    )}
                  </>
                )}
              </NavLink>
            )
          })}
        </nav>

        <div className="border-t border-gray-100 p-2 space-y-1">
          <button
            onClick={handleLogout}
            className={`w-full flex items-center gap-3 px-3 py-2.5 rounded-xl text-sm font-medium
                     text-red-500 hover:bg-red-50 transition-all duration-200
                     ${collapsed ? 'justify-center' : ''}`}
          >
            <LogOut size={18} className="flex-shrink-0" />
            {!collapsed && <span>Sign Out</span>}
          </button>
        </div>
      </aside>
    </>
  )
}
