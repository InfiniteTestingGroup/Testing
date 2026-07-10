import { useState } from 'react'
import { createPortal } from 'react-dom'
import { useNavigate } from 'react-router-dom'
import { User, Mail, Shield, Calendar, Edit3, Key, Activity, Clock, X, Building2 } from 'lucide-react'

const activityLog = [
  { id: 1, action: "Created new ad campaign 'Summer Launch'", time: "2 hours ago", date: "18 Jun 2026" },
  { id: 2, action: "Added Publisher location 'Bengaluru Center'", time: "5 hours ago", date: "18 Jun 2026" },
  { id: 3, action: "Updated company billing details", time: "Yesterday", date: "17 Jun 2026" },
  { id: 4, action: "Generated monthly invoice #INV-9201", time: "3 days ago", date: "15 Jun 2026" },
  { id: 5, action: "Logged in securely from Hyderabad", time: "4 days ago", date: "14 Jun 2026" },
]

export default function Profile() {
  const [showEditProfile, setShowEditProfile] = useState(false)
  const [showChangePassword, setShowChangePassword] = useState(false)
  const navigate = useNavigate()

  const userStr = localStorage.getItem('admin_user')
  const user = userStr ? JSON.parse(userStr) : null

  const displayName = user?.name || user?.fullName || 'Admin User'
  const displayEmail = user?.email || 'admin@keliri.com'
  const displayRole = user?.role || user?.userType || 'Admin'
  const displayCompany = user?.company || 'KELIRI Publisher Network'
  
  // Create initials
  const initials = displayName
    ? displayName.split(' ').map((n: string) => n[0]).join('').substring(0, 2).toUpperCase()
    : 'AU'

  return (
    <div className="space-y-6 pb-6 max-w-md mx-auto px-4 sm:px-6 lg:px-8 py-8 animate-fade-in">
      {/* Header */}
      <div className="text-center pt-1">
        <h1 className="text-2xl font-bold text-gray-900 dark:text-white tracking-tight">My Profile</h1>
        <p className="text-sm text-gray-500 dark:text-gray-400 mt-0.5">Manage your identity and profile security.</p>
      </div>

      <div className="space-y-6">
        
        {/* Centered Identity Card */}
        <div className="bg-white dark:bg-[#1C1F26] rounded-2xl border border-gray-200 dark:border-gray-800 overflow-hidden shadow-sm">
          <div className="h-24 bg-gradient-to-r from-brand-400 to-brand-600"></div>
          <div className="px-6 pb-6 pt-14 relative">
            <div className="w-20 h-20 bg-white dark:bg-[#1C1F26] rounded-full p-1 absolute -top-10 shadow-sm border border-gray-100 dark:border-gray-800">
              <div className="w-full h-full bg-brand-100 dark:bg-brand-900/50 text-brand-600 dark:text-brand-400 rounded-full flex items-center justify-center font-bold text-2xl">
                {initials}
              </div>
            </div>
            
            <div>
              <h2 className="text-xl font-bold text-gray-900 dark:text-white">{displayName}</h2>
              <div className="flex items-center gap-2 mt-1">
                <span className="bg-brand-50 dark:bg-brand-500/10 text-brand-600 dark:text-brand-400 text-xs px-2.5 py-0.5 rounded-full font-semibold">
                  {displayRole}
                </span>
              </div>
            </div>

            <div className="mt-6 space-y-4">
              <div className="flex items-center gap-3 text-sm">
                <div className="w-8 h-8 rounded-full bg-gray-50 dark:bg-gray-800 flex items-center justify-center text-gray-500 dark:text-gray-400">
                  <User size={15} />
                </div>
                <div>
                  <p className="text-xs text-gray-400 dark:text-gray-500 font-medium">Full Name</p>
                  <p className="text-gray-800 dark:text-gray-200 font-medium">{displayName}</p>
                </div>
              </div>
              <div className="flex items-center gap-3 text-sm">
                <div className="w-8 h-8 rounded-full bg-gray-50 dark:bg-gray-800 flex items-center justify-center text-gray-500 dark:text-gray-400">
                  <Mail size={15} />
                </div>
                <div>
                  <p className="text-xs text-gray-400 dark:text-gray-500 font-medium">Email Address</p>
                  <p className="text-gray-800 dark:text-gray-200 font-medium">{displayEmail}</p>
                </div>
              </div>
              <div className="flex items-center gap-3 text-sm">
                <div className="w-8 h-8 rounded-full bg-gray-50 dark:bg-gray-800 flex items-center justify-center text-gray-500 dark:text-gray-400">
                  <Building2 size={15} />
                </div>
                <div>
                  <p className="text-xs text-gray-400 dark:text-gray-500 font-medium">Company</p>
                  <p className="text-gray-800 dark:text-gray-200 font-medium">{displayCompany}</p>
                </div>
              </div>
              <div className="flex items-center gap-3 text-sm">
                <div className="w-8 h-8 rounded-full bg-gray-50 dark:bg-gray-800 flex items-center justify-center text-gray-500 dark:text-gray-400">
                  <Shield size={15} />
                </div>
                <div>
                  <p className="text-xs text-gray-400 dark:text-gray-500 font-medium">Account Role</p>
                  <p className="text-gray-800 dark:text-gray-200 font-medium">{displayRole}</p>
                </div>
              </div>
            </div>

          </div>
        </div>

        {/* Buttons Card */}
        <div className="bg-white dark:bg-[#1C1F26] p-4 rounded-2xl border border-gray-200 dark:border-gray-800 space-y-3 shadow-sm">
          <button 
            onClick={() => setShowEditProfile(true)}
            className="w-full flex items-center justify-center gap-2 bg-gray-50 dark:bg-gray-800 hover:bg-gray-100 dark:hover:bg-gray-700/50 text-gray-700 dark:text-gray-200 px-4 py-2.5 rounded-xl text-sm font-medium transition-colors border border-gray-200 dark:border-gray-700"
          >
            <Edit3 size={15} /> Edit Profile Info
          </button>
          <button 
            onClick={() => setShowChangePassword(true)}
            className="w-full flex items-center justify-center gap-2 bg-brand-50 dark:bg-brand-500/10 hover:bg-brand-100 dark:hover:bg-brand-500/20 text-brand-600 dark:text-brand-400 px-4 py-2.5 rounded-xl text-sm font-medium transition-colors border border-brand-100 dark:border-brand-500/20"
          >
            <Key size={15} /> Change Password
          </button>
        </div>
      </div>

      {/* ── Edit Profile Modal ── */}
      {showEditProfile && createPortal(
        <div className="fixed inset-0 z-[100] flex items-center justify-center p-4 sm:p-0">
          <div className="absolute inset-0 bg-gray-900/40 dark:bg-gray-950/60 backdrop-blur-sm" onClick={() => setShowEditProfile(false)} />
          <div className="relative bg-white dark:bg-[#1C1F26] rounded-3xl shadow-xl w-full max-w-md overflow-hidden border border-gray-100 dark:border-gray-800">
            <div className="px-6 py-4 border-b border-gray-100 dark:border-gray-800 flex items-center justify-between">
              <h3 className="text-lg font-bold text-gray-900 dark:text-white">Edit Profile Info</h3>
              <button onClick={() => setShowEditProfile(false)} className="text-gray-400 hover:text-gray-600 dark:hover:text-gray-200 bg-gray-50 dark:bg-gray-800 rounded-full p-1.5 hover:bg-gray-100 dark:hover:bg-gray-700 transition-colors">
                <X size={18} />
              </button>
            </div>
            <div className="p-6 space-y-5">
              <div className="space-y-2">
                <label className="text-xs font-semibold text-gray-700 dark:text-gray-300">Full Name</label>
                <input type="text" defaultValue={displayName} className="w-full px-4 py-2.5 bg-white dark:bg-[#1C1F26] border border-gray-200 dark:border-gray-800 rounded-xl text-gray-900 dark:text-white focus:ring-2 focus:ring-brand-500 focus:border-brand-500 transition-colors" />
              </div>
              <div className="space-y-2">
                <label className="text-xs font-semibold text-gray-700 dark:text-gray-300">Email Address <span className="font-normal text-gray-400">(Cannot be changed manually)</span></label>
                <input type="email" defaultValue={displayEmail} readOnly className="w-full px-4 py-2.5 bg-gray-50 dark:bg-gray-800/50 border border-gray-200 dark:border-gray-800 rounded-xl text-gray-900 dark:text-white opacity-70 cursor-not-allowed select-none" />
              </div>
            </div>
            <div className="px-6 py-4 bg-gray-50/50 dark:bg-[#1C1F26] border-t border-gray-100 dark:border-gray-800 flex justify-end gap-3">
              <button 
                onClick={() => setShowEditProfile(false)} 
                className="px-4 py-2.5 text-sm font-semibold text-gray-600 dark:text-gray-400 hover:bg-gray-200 dark:hover:bg-gray-800 rounded-xl transition-colors"
              >
                Cancel
              </button>
              <button 
                onClick={() => setShowEditProfile(false)} 
                className="px-5 py-2.5 bg-brand-500 hover:bg-brand-600 text-white text-sm font-semibold rounded-xl transition-colors shadow-sm"
              >
                Save Changes
              </button>
            </div>
          </div>
        </div>,
        document.body
      )}

      {/* ── Change Password Modal ── */}
      {showChangePassword && createPortal(
        <div className="fixed inset-0 z-[100] flex items-center justify-center p-4 sm:p-0">
          <div className="absolute inset-0 bg-gray-900/40 dark:bg-gray-950/60 backdrop-blur-sm" onClick={() => setShowChangePassword(false)} />
          <div className="relative bg-white dark:bg-[#1C1F26] rounded-3xl shadow-xl w-full max-w-md overflow-hidden border border-gray-100 dark:border-gray-800">
            <div className="px-6 py-4 border-b border-gray-100 dark:border-gray-800 flex items-center justify-between">
              <h3 className="text-lg font-bold text-gray-900 dark:text-white">Change Password</h3>
              <button onClick={() => setShowChangePassword(false)} className="text-gray-400 hover:text-gray-600 dark:hover:text-gray-200 bg-gray-50 dark:bg-gray-800 rounded-full p-1.5 hover:bg-gray-100 dark:hover:bg-gray-700 transition-colors">
                <X size={18} />
              </button>
            </div>
            <div className="p-6 space-y-5">
              <div className="space-y-2">
                <label className="text-xs font-semibold text-gray-700 dark:text-gray-300">Current Password</label>
                <input type="password" placeholder="••••••••" className="w-full px-4 py-2.5 bg-white dark:bg-[#1C1F26] border border-gray-200 dark:border-gray-800 rounded-xl text-gray-900 dark:text-white focus:ring-2 focus:ring-brand-500 focus:border-brand-500 transition-colors" />
              </div>
              <div className="h-px bg-gray-100 dark:bg-gray-800 my-1" />
              <div className="space-y-2">
                <label className="text-xs font-semibold text-gray-700 dark:text-gray-300">New Password</label>
                <input type="password" placeholder="••••••••" className="w-full px-4 py-2.5 bg-white dark:bg-[#1C1F26] border border-gray-200 dark:border-gray-800 rounded-xl text-gray-900 dark:text-white focus:ring-2 focus:ring-brand-500 focus:border-brand-500 transition-colors" />
              </div>
              <div className="space-y-2">
                <label className="text-xs font-semibold text-gray-700 dark:text-gray-300">Confirm New Password</label>
                <input type="password" placeholder="••••••••" className="w-full px-4 py-2.5 bg-white dark:bg-[#1C1F26] border border-gray-200 dark:border-gray-800 rounded-xl text-gray-900 dark:text-white focus:ring-2 focus:ring-brand-500 focus:border-brand-500 transition-colors" />
              </div>
              
              <ul className="text-[11px] text-gray-500 dark:text-gray-400 space-y-1 list-disc pl-4 mt-2">
                <li>Must be at least 8 characters long</li>
                <li>Must contain at least 1 number and 1 symbol</li>
              </ul>
            </div>
            <div className="px-6 py-4 bg-gray-50/50 dark:bg-[#1C1F26] border-t border-gray-100 dark:border-gray-800 flex justify-end gap-3">
              <button 
                onClick={() => setShowChangePassword(false)} 
                className="px-4 py-2.5 text-sm font-semibold text-gray-600 dark:text-gray-400 hover:bg-gray-200 dark:hover:bg-gray-800 rounded-xl transition-colors"
              >
                Cancel
              </button>
              <button 
                onClick={() => setShowChangePassword(false)} 
                className="px-5 py-2.5 bg-brand-500 hover:bg-brand-600 text-white text-sm font-semibold rounded-xl transition-colors shadow-sm"
              >
                Update Password
              </button>
            </div>
          </div>
        </div>,
        document.body
      )}

    </div>
  )
}
