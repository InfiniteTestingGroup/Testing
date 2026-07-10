import * as React from "react"
import { Outlet, useNavigate, useLocation } from "react-router-dom"
import { Sidebar } from "./Sidebar"
import { ThemeProvider } from "../../context/ThemeContext"
import { Bell, ChevronDown, User, LogOut } from "lucide-react"
import { ThemeToggle } from "./ThemeToggle"
import { fetchTickets } from "../../services/tickets"
import { fetchAds } from "../../services/ads"
import TermsModal from "./TermsModal"

const formatTimeAgo = (timestamp: number) => {
  const diff = new Date().getTime() - timestamp;
  const mins = Math.floor(diff / 60000);
  if (mins < 1) return "Just now";
  if (mins < 60) return `${mins}m ago`;
  const hours = Math.floor(mins / 60);
  if (hours < 24) return `${hours}h ago`;
  return "1d ago";
};

export default function AdminLayout() {
  const [isOpen, setIsOpen] = React.useState(true)
  const [profileOpen, setProfileOpen] = React.useState(false)
  const [notifOpen, setNotifOpen] = React.useState(false)
  const [notifications, setNotifications] = React.useState<any[]>([])
  const [unreadCount, setUnreadCount] = React.useState(0)
  const [isTermsOpen, setIsTermsOpen] = React.useState(false)
  const navigate = useNavigate()
  const location = useLocation()

  React.useEffect(() => {
    const token = localStorage.getItem('admin_token')
    if (!token) {
      navigate('/admin/login')
    }
  }, [navigate])

  React.useEffect(() => {
    const loadNotifications = async () => {
      try {
        let companyUID = undefined;
        const userStr = localStorage.getItem('admin_user');
        if (userStr) {
          const user = JSON.parse(userStr);
          companyUID = user.companyUID || user.companyId || user.uid;
        }

        const [tickets, adsResult] = await Promise.all([
          fetchTickets().catch(() => []),
          fetchAds({ page: 1, limit: 100, companyUID }).catch(() => ({ data: [] }))
        ]);

        const list: any[] = [];
        const now = new Date().getTime();
        const oneDayMs = 24 * 60 * 60 * 1000;

        // Retrieve dismissed notification IDs from localStorage
        const dismissedStr = localStorage.getItem('admin_dismissed_notifications');
        const dismissedIds: string[] = dismissedStr ? JSON.parse(dismissedStr) : [];
        const updatedDismissed = [...dismissedIds];
        let dismissedChanged = false;

        const currentPath = window.location.pathname;

        // Process tickets
        tickets.forEach((t: any) => {
          const ticketTime = t.updatedAt ? new Date(t.updatedAt).getTime() : new Date(t.createdAt).getTime();
          // Keep for one day
          if (now - ticketTime <= oneDayMs) {
            let text = "";
            let unread = true;
            if (t.status === "Resolved") {
              text = `Support ticket #${t.id.substring(0, 8)}: "${t.subject}" has been resolved by Super Admin`;
            } else if (t.status === "Closed") {
              text = `Support ticket #${t.id.substring(0, 8)}: "${t.subject}" has been closed by Super Admin`;
            } else if (t.status === "In Progress") {
              const isUpdated = t.updatedAt && t.createdAt && new Date(t.updatedAt).getTime() !== new Date(t.createdAt).getTime();
              if (isUpdated) {
                text = `Super Admin replied to support ticket #${t.id.substring(0, 8)}: "${t.subject}"`;
              } else {
                text = `Support ticket #${t.id.substring(0, 8)}: "${t.subject}" is being processed by Super Admin`;
              }
            }
            
            if (text) {
              const timeVal = new Date(ticketTime).getTime();
              const id = `ticket-${t.id}-${t.status}-${timeVal}`;
              // Auto-dismiss if the user is currently on the tickets page
              if (currentPath.startsWith('/admin/tickets')) {
                if (!updatedDismissed.includes(id)) {
                  updatedDismissed.push(id);
                  dismissedChanged = true;
                }
              } else if (!dismissedIds.includes(id)) {
                list.push({
                  id,
                  text,
                  time: formatTimeAgo(ticketTime),
                  timestamp: ticketTime,
                  unread,
                  type: 'ticket'
                });
              }
            }
          }
        });

        // Process ads
        adsResult.data.forEach((ad: any) => {
          const adTime = ad.startDate ? new Date(ad.startDate).getTime() : now;
          if (now - adTime <= oneDayMs) {
            let text = "";
            let unread = false;
            if (ad.status === "Active") {
              text = `Ad campaign "${ad.title}" has been approved by Super Admin`;
              unread = true;
            } else if (ad.status === "Expired") {
              text = `Ad campaign "${ad.title}" has expired`;
            } else if (ad.status === "Suspended") {
              text = `Ad campaign "${ad.title}" has been suspended by Super Admin`;
              unread = true;
            }
            if (text) {
              const timeVal = new Date(adTime).getTime();
              const id = `ad-${ad.id}-${ad.status}-${timeVal}`;
              // Auto-dismiss if the user is currently on the ads page
              if (currentPath.startsWith('/admin/ads')) {
                if (!updatedDismissed.includes(id)) {
                  updatedDismissed.push(id);
                  dismissedChanged = true;
                }
              } else if (!dismissedIds.includes(id)) {
                list.push({
                  id,
                  text,
                  time: formatTimeAgo(adTime),
                  timestamp: adTime,
                  unread,
                  type: 'ad'
                });
              }
            }
          }
        });

        if (dismissedChanged) {
          localStorage.setItem('admin_dismissed_notifications', JSON.stringify(updatedDismissed));
        }

        // Sort notifications by newest first
        list.sort((a, b) => b.timestamp - a.timestamp);
        setNotifications(list);
        setUnreadCount(list.filter(n => n.unread).length);
      } catch (err) {
        console.error("Failed to load notifications", err);
      }
    };

    loadNotifications();
    const interval = setInterval(loadNotifications, 60000);
    return () => clearInterval(interval);
  }, [location.pathname]);

  const handleLogout = () => {
    localStorage.removeItem('admin_token')
    localStorage.removeItem('admin_user')
    document.documentElement.classList.remove("dark")
    window.location.href = "/admin/login"
  }

  const userStr = localStorage.getItem('admin_user')
  const user = userStr
    ? JSON.parse(userStr)
    : { name: 'Admin User', role: 'Admin' }

  const displayName = user.name || user.fullName || 'Admin User'
  const displayRole = user.role || user.userType || 'Admin'
  const initial = displayName ? displayName.charAt(0).toUpperCase() : 'A'

  return (
    <ThemeProvider>
      <div className="flex">
        {/* Sidebar Wrapper */}
        <div 
          className={`hidden lg:block transition-all duration-300 ease-in-out ${
            isOpen ? "w-72" : "w-20"
          } flex-shrink-0`}
        >
           <Sidebar isOpen={isOpen} setIsOpen={setIsOpen} />
        </div>

        {/* Mobile Sidebar Overlay (Sidebar will handle its own visibility on mobile) */}
        <div className="lg:hidden">
          <Sidebar isOpen={isOpen} setIsOpen={setIsOpen} />
        </div>

        {/* Main Content */}
        <main className="flex-1 w-full overflow-x-hidden min-h-screen relative p-0 transition-all duration-300 bg-gray-50 dark:bg-[#0E1117] transition-colors duration-200">
          {/* Header */}
          <header className="sticky top-0 z-40 bg-white/80 dark:bg-[#1C1F26]/80 backdrop-blur-md border-b border-gray-200 dark:border-gray-800 transition-colors">
            <div className="w-full px-4 sm:px-6 lg:px-8 xl:px-12">
              <div className="flex justify-between items-center h-16">
                <div className="flex items-center gap-2">
                  <div className="w-8 h-8 rounded-lg bg-brand-500 flex items-center justify-center text-white font-bold shadow-sm">
                    K
                  </div>
                  <h1 className="text-xl font-bold tracking-wide text-gray-900 dark:text-white">
                    KELIRI <span className="text-sm font-semibold text-brand-500 uppercase tracking-widest ml-1">Admin</span>
                  </h1>
                </div>
                
                <div className="flex items-center gap-4">
                  <ThemeToggle />
                  {/* Notifications Dropdown */}
                  <div className="relative">
                    <button 
                      onClick={() => { setNotifOpen(!notifOpen); setProfileOpen(false) }}
                      className="p-2 text-gray-400 hover:text-gray-500 dark:hover:text-gray-300 relative transition-colors rounded-xl hover:bg-gray-50 dark:hover:bg-gray-800/50"
                    >
                      <Bell className="w-5 h-5" />
                      {unreadCount > 0 && (
                        <span className="absolute top-1 right-1 w-4 h-4 bg-brand-500 text-white text-[9px] font-bold rounded-full flex items-center justify-center border-2 border-white dark:border-[#1C1F26]">
                          {unreadCount}
                        </span>
                      )}
                    </button>

                    {notifOpen && (
                      <>
                        <div className="fixed inset-0 z-40" onClick={() => setNotifOpen(false)} />
                        <div className="absolute right-0 top-12 w-80 bg-white dark:bg-[#1C1F26] rounded-2xl shadow-lg border border-gray-100 dark:border-gray-800 z-50 overflow-hidden">
                          <div className="flex items-center justify-between px-4 py-3 border-b border-gray-150 dark:border-gray-800">
                            <p className="font-bold text-gray-900 dark:text-white text-sm">Notifications</p>
                            <span className="bg-brand-50 dark:bg-brand-500/10 text-brand-600 dark:text-brand-400 text-[10px] px-2 py-0.5 rounded-full font-semibold">
                              {unreadCount} new
                            </span>
                          </div>
                          <div className="divide-y divide-gray-50 dark:divide-gray-800 max-h-80 overflow-y-auto">
                            {notifications.length === 0 ? (
                              <div className="px-4 py-8 text-center text-xs text-gray-400 dark:text-gray-500">
                                No notifications in the last 24 hours.
                              </div>
                            ) : (
                              notifications.map((n) => (
                                <div 
                                  key={n.id} 
                                  onClick={() => {
                                    // Dismiss this notification in localStorage
                                    const dismissedStr = localStorage.getItem('admin_dismissed_notifications');
                                    const dismissedIds: string[] = dismissedStr ? JSON.parse(dismissedStr) : [];
                                    if (!dismissedIds.includes(n.id)) {
                                      dismissedIds.push(n.id);
                                      localStorage.setItem('admin_dismissed_notifications', JSON.stringify(dismissedIds));
                                    }

                                    // Remove from current local state
                                    setNotifications(prev => prev.filter(item => item.id !== n.id));
                                    setUnreadCount(prev => Math.max(0, prev - (n.unread ? 1 : 0)));
                                    
                                    // Navigate based on type
                                    if (n.type === 'ticket') navigate('/admin/tickets');
                                    else if (n.type === 'ad') navigate('/admin/ads');
                                    
                                    setNotifOpen(false);
                                  }}
                                  className={`px-4 py-3 hover:bg-gray-50 dark:hover:bg-gray-800/30 transition-colors cursor-pointer text-left ${
                                    n.unread ? 'bg-brand-50/20 dark:bg-brand-500/5' : ''
                                  }`}
                                >
                                  <div className="flex items-start gap-3">
                                    {n.unread && <span className="w-2 h-2 rounded-full bg-brand-500 mt-1.5 flex-shrink-0" />}
                                    {!n.unread && <span className="w-2 h-2 rounded-full bg-transparent mt-1.5 flex-shrink-0" />}
                                    <div className="flex-1 min-w-0">
                                      <p className="text-xs text-gray-750 dark:text-gray-300 leading-relaxed break-words">{n.text}</p>
                                      <p className="text-[10px] text-gray-400 dark:text-gray-500 mt-1">{n.time}</p>
                                    </div>
                                  </div>
                                </div>
                              ))
                            )}
                          </div>
                          <div className="px-4 py-2.5 border-t border-gray-100 dark:border-gray-800 text-center bg-gray-50 dark:bg-[#1C1F26]">
                            <button 
                              onClick={() => {
                                navigate('/admin/dashboard');
                                setNotifOpen(false);
                              }}
                              className="text-xs font-semibold text-brand-600 dark:text-brand-400 hover:text-brand-700 dark:hover:text-brand-300 transition-colors"
                            >
                              Go to Dashboard
                            </button>
                          </div>
                        </div>
                      </>
                    )}
                  </div>
                  <div className="h-8 w-px bg-gray-200 dark:bg-gray-700 mx-2"></div>
                  <div className="relative">
                    <div 
                      onClick={() => setProfileOpen(!profileOpen)}
                      className="flex items-center gap-3 cursor-pointer group p-1.5 rounded-xl hover:bg-gray-50 dark:hover:bg-gray-800/50 transition-colors select-none"
                    >
                      <div className="w-8 h-8 rounded-full bg-brand-100 dark:bg-brand-900 flex items-center justify-center text-brand-600 dark:text-brand-300 font-semibold group-hover:bg-brand-200 dark:group-hover:bg-brand-800 transition-colors">
                        {initial}
                      </div>
                      <div className="hidden md:block">
                        <p className="text-sm font-medium text-gray-700 dark:text-gray-200">{displayName}</p>
                        <p className="text-xs text-brand-500 font-semibold">{displayRole}</p>
                      </div>
                      <ChevronDown className={`w-4 h-4 text-gray-400 transition-transform duration-200 ${profileOpen ? 'rotate-180' : ''}`} />
                    </div>

                    {profileOpen && (
                      <>
                        <div className="fixed inset-0 z-40" onClick={() => setProfileOpen(false)} />
                        <div className="absolute right-0 top-12 w-48 bg-white dark:bg-[#1C1F26] rounded-2xl shadow-lg border border-gray-100 dark:border-gray-800 z-50 overflow-hidden py-1">
                          <div className="px-4 py-2.5 border-b border-gray-100 dark:border-gray-800">
                            <p className="text-xs font-semibold text-gray-900 dark:text-white truncate">{displayName}</p>
                            <p className="text-[10px] text-gray-500 truncate">{user.email || 'admin@keliri.com'}</p>
                          </div>
                          <button 
                            onClick={() => { navigate('/admin/profile'); setProfileOpen(false) }}
                            className="w-full flex items-center gap-3 px-4 py-2 text-sm text-gray-700 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-800/50 transition-colors text-left"
                          >
                            <User size={14} /> Profile
                          </button>
                          <div className="border-t border-gray-100 dark:border-gray-800 my-1"></div>
                          <button
                            onClick={handleLogout}
                            className="w-full flex items-center gap-3 px-4 py-2 text-sm text-red-500 hover:bg-red-50 dark:hover:bg-red-900/10 transition-colors text-left"
                          >
                            <LogOut size={14} /> Logout
                          </button>
                        </div>
                      </>
                    )}
                  </div>
                </div>
              </div>
            </div>
          </header>

          <div className="max-w-[1600px] mx-auto">
             <Outlet />
          </div>

          {/* Premium glass-morphism footer with T&C */}
          <footer className="bg-white/30 dark:bg-white/5 backdrop-blur-md border-t border-gray-200/50 dark:border-gray-700/50 pt-3 pb-4 text-right pr-8 rounded-t-lg shadow-inner">
            <a
              href="#"
              onClick={(e) => { e.preventDefault(); setIsTermsOpen(true); }}
              className="text-sm text-indigo-700 dark:text-indigo-400 hover:text-indigo-900 dark:hover:text-indigo-300 font-medium underline transition-colors"
            >
              Terms &amp; Conditions
            </a>
          </footer>

          {isTermsOpen && <TermsModal isOpen={isTermsOpen} onClose={() => setIsTermsOpen(false)} />}
        </main>
      </div>
    </ThemeProvider>
  )
}
