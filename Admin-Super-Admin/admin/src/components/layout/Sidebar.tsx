import * as React from "react"
import { Link, useLocation } from "react-router-dom"
import {
  LayoutDashboard,
  Megaphone,
  Globe,
  BarChart3,
  CreditCard,
  LogOut,
  ChevronRight,
  Menu,
  X,
  HelpCircle
} from "lucide-react"
import { cn } from "../../lib/utils"
import { useTheme } from "../../context/ThemeContext"

const menuItems = [
  { label: "Dashboard", icon: LayoutDashboard, path: "/admin/dashboard" },
  { label: "Ads Manager", icon: Megaphone, path: "/admin/ads" },
  { label: "Publishers", icon: Globe, path: "/admin/publishers" },
  { label: "Support Hub", icon: HelpCircle, path: "/admin/tickets" },
  { label: "Payments", icon: CreditCard, path: "/admin/payments" },
]

interface SidebarProps {
  isOpen: boolean
  setIsOpen: (open: boolean) => void
}

export function Sidebar({ isOpen, setIsOpen }: SidebarProps) {
  const location = useLocation()
  const { theme } = useTheme()

  const handleLogout = () => {
    localStorage.removeItem('admin_token')
    localStorage.removeItem('admin_user')
    document.documentElement.classList.remove("dark")
    window.location.href = "/admin/login"
  }

  const userStr = localStorage.getItem('admin_user')
  const user = userStr
    ? JSON.parse(userStr)
    : { name: 'System Admin', role: 'ADMIN' }

  return (
    <>
      {/* Mobile Toggle */}
      <button
        onClick={() => setIsOpen(!isOpen)}
        className="lg:hidden fixed bottom-6 right-6 z-50 p-4 bg-brand-500 text-white rounded-2xl shadow-2xl"
      >
        {isOpen ? <X className="w-6 h-6" /> : <Menu className="w-6 h-6" />}
      </button>

      <aside className={cn(
        "fixed left-0 top-0 h-screen bg-white dark:bg-[#0E1117] border-r border-gray-200 dark:border-gray-800 transition-all duration-300 z-40 flex flex-col",
        isOpen ? "w-72" : "w-20 overflow-hidden lg:overflow-visible"
      )}>

        {/* 🔥 LOGO SECTION (UPDATED) */}
        <div className="p-6 pb-12 flex items-center justify-between">
          <div className="flex items-center gap-4 min-w-0 overflow-hidden">

            {/* ✅ YOUR IMAGE LOGO */}
            <img
              src="/keliriicon.png"
              alt="logo"
              className="w-10 h-10 rounded-xl object-contain"
            />

            {isOpen && (
              <div className="animate-in fade-in slide-in-from-left-2 duration-300 truncate">
                <h1 className="text-xl font-black text-gray-900 dark:text-white tracking-tighter">
                  KELIRI
                </h1>
                <p className="text-[10px] uppercase font-bold text-gray-500 tracking-[0.2em]">
                  Admin Portal
                </p>
              </div>
            )}
          </div>

          <button
            onClick={() => setIsOpen(!isOpen)}
            className="p-2 text-gray-500 hover:text-gray-900 hover:bg-gray-100 dark:text-gray-400 dark:hover:text-white dark:hover:bg-gray-800 rounded-xl transition-all"
          >
            <Menu className="w-5 h-5" />
          </button>
        </div>

        {/* Navigation */}
        <nav className="flex-1 px-4 space-y-2">
          {menuItems.map((item) => {
            const isActive = location.pathname === item.path
            return (
              <Link
                key={item.path}
                to={item.path}
                className={cn(
                  "flex items-center gap-3 px-4 py-3 rounded-2xl transition-all group relative",
                  isActive
                    ? "bg-brand-500 text-white shadow-lg shadow-brand-500/20"
                    : "text-gray-500 hover:text-gray-900 hover:bg-gray-100 dark:text-gray-400 dark:hover:text-white dark:hover:bg-gray-800/50"
                )}
              >
                <item.icon className={cn(
                  "w-5 h-5",
                  isActive ? "text-white" : "group-hover:text-brand-400"
                )} />

                {isOpen && (
                  <span className="text-sm font-bold">
                    {item.label}
                  </span>
                )}

                {isActive && isOpen && (
                  <ChevronRight className="absolute right-4 w-4 h-4 opacity-50" />
                )}
              </Link>
            )
          })}
        </nav>

        {/* Bottom */}
        <div className="p-4 border-t border-gray-200 dark:border-gray-800/50">
          <button
            onClick={handleLogout}
            className="w-full flex items-center gap-3 px-4 py-3 rounded-2xl text-gray-500 hover:text-red-600 hover:bg-red-50 dark:text-gray-400 dark:hover:text-red-400 dark:hover:bg-red-500/5 transition-all"
          >
            <LogOut className="w-5 h-5" />
            {isOpen && <span className="text-sm font-bold">Logout</span>}
          </button>
        </div>

      </aside>
    </>
  )
}