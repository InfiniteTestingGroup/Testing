import { useState } from 'react'
import { createPortal } from 'react-dom'
import { User, Mail, Shield, Edit3, Key, X } from 'lucide-react'
import { getAuthSession, getRoleLabel } from '../lib/auth'

export default function Profile() {
  const [showEditProfile, setShowEditProfile] = useState(false)
  const [showChangePassword, setShowChangePassword] = useState(false)

  const session = getAuthSession()
  const name = session?.name || 'Unknown User'
  const email = session?.email || '—'
  const roleLabel = getRoleLabel(session?.role)
  const initial = name.charAt(0).toUpperCase()

  return (
    <div className="min-h-screen bg-gray-50 flex flex-col items-center py-10 px-4">
      {/* Page Title */}
      <div className="text-center mb-8">
        <h1 className="text-2xl font-bold text-gray-900 tracking-tight">My Profile</h1>
        <p className="text-sm text-gray-500 mt-1">Manage your identity and profile security.</p>
      </div>

      {/* Profile Card */}
      <div className="w-full max-w-md bg-white rounded-3xl shadow-sm border border-gray-100 overflow-hidden">

        {/* Orange banner */}
        <div className="h-28 bg-gradient-to-r from-orange-400 to-orange-500" />

        {/* Avatar + Name row */}
        <div className="px-6 pt-0 pb-0">
          <div className="flex items-center gap-4 -mt-9 mb-5">
            <div className="w-[72px] h-[72px] rounded-full bg-white p-1.5 shadow border border-gray-100 flex-shrink-0">
              <div className="w-full h-full rounded-full bg-orange-500 flex items-center justify-center text-white font-bold text-2xl select-none">
                {initial}
              </div>
            </div>
            <div>
              <h2 className="text-xl font-bold text-gray-900">{name}</h2>
              <span className="inline-block mt-1 px-2.5 py-0.5 rounded-md bg-orange-100 text-orange-600 text-xs font-semibold tracking-wide">
                {roleLabel}
              </span>
            </div>
          </div>
        </div>

        {/* Info rows */}
        <div className="px-6 pb-2 space-y-4">
          {[
            { icon: <User size={15} />, label: 'Full Name', value: name },
            { icon: <Mail size={15} />, label: 'Email Address', value: email },
            { icon: <Shield size={15} />, label: 'Account Role', value: roleLabel },
          ].map(({ icon, label, value }) => (
            <div key={label} className="flex items-center gap-3 text-sm">
              <div className="w-8 h-8 rounded-full bg-gray-50 border border-gray-100 flex items-center justify-center text-gray-400 flex-shrink-0">
                {icon}
              </div>
              <div>
                <p className="text-[11px] text-gray-400 font-medium uppercase tracking-wide">{label}</p>
                <p className="text-gray-800 font-semibold">{value}</p>
              </div>
            </div>
          ))}
        </div>

        {/* Action buttons */}
        <div className="px-6 py-6 space-y-3">
          <button
            onClick={() => setShowEditProfile(true)}
            className="w-full flex items-center justify-center gap-2 bg-gray-100 hover:bg-gray-200 text-gray-700 px-4 py-3 rounded-2xl text-sm font-semibold transition-colors"
          >
            <Edit3 size={15} /> Edit Profile Info
          </button>
          <button
            onClick={() => setShowChangePassword(true)}
            className="w-full flex items-center justify-center gap-2 bg-orange-500 hover:bg-orange-600 text-white px-4 py-3 rounded-2xl text-sm font-semibold transition-colors shadow-sm"
          >
            <Key size={15} /> Change Password
          </button>
        </div>
      </div>

      {/* Edit Profile Modal */}
      {showEditProfile && createPortal(
        <div className="fixed inset-0 z-[100] flex items-center justify-center p-4">
          <div className="absolute inset-0 bg-gray-900/40 backdrop-blur-sm" onClick={() => setShowEditProfile(false)} />
          <div className="relative bg-white rounded-3xl shadow-xl w-full max-w-md overflow-hidden">
            <div className="px-6 py-4 border-b border-gray-100 flex items-center justify-between">
              <h3 className="text-lg font-bold text-gray-900">Edit Profile Info</h3>
              <button onClick={() => setShowEditProfile(false)} className="text-gray-400 hover:text-gray-600 bg-gray-50 rounded-full p-1.5 hover:bg-gray-100 transition-colors">
                <X size={18} />
              </button>
            </div>
            <div className="p-6 space-y-5">
              <div className="space-y-2">
                <label className="text-xs font-semibold text-gray-700">Full Name</label>
                <input type="text" defaultValue={name} className="w-full border border-gray-200 rounded-xl px-4 py-2.5 text-sm text-gray-800 focus:outline-none focus:ring-2 focus:ring-orange-400" />
              </div>
              <div className="space-y-2">
                <label className="text-xs font-semibold text-gray-700">
                  Email Address <span className="font-normal text-gray-400">(Cannot be changed)</span>
                </label>
                <input type="email" defaultValue={email} readOnly className="w-full border border-gray-200 rounded-xl px-4 py-2.5 text-sm text-gray-400 bg-gray-50 cursor-not-allowed" />
              </div>
            </div>
            <div className="px-6 py-4 bg-gray-50/50 border-t border-gray-100 flex justify-end gap-3">
              <button onClick={() => setShowEditProfile(false)} className="px-4 py-2.5 text-sm font-semibold text-gray-600 hover:bg-gray-100 rounded-xl transition-colors">
                Cancel
              </button>
              <button onClick={() => setShowEditProfile(false)} className="px-5 py-2.5 bg-orange-500 hover:bg-orange-600 text-white text-sm font-semibold rounded-xl transition-colors shadow-sm">
                Save Changes
              </button>
            </div>
          </div>
        </div>,
        document.body
      )}

      {/* Change Password Modal */}
      {showChangePassword && createPortal(
        <div className="fixed inset-0 z-[100] flex items-center justify-center p-4">
          <div className="absolute inset-0 bg-gray-900/40 backdrop-blur-sm" onClick={() => setShowChangePassword(false)} />
          <div className="relative bg-white rounded-3xl shadow-xl w-full max-w-md overflow-hidden">
            <div className="px-6 py-4 border-b border-gray-100 flex items-center justify-between">
              <h3 className="text-lg font-bold text-gray-900">Change Password</h3>
              <button onClick={() => setShowChangePassword(false)} className="text-gray-400 hover:text-gray-600 bg-gray-50 rounded-full p-1.5 hover:bg-gray-100 transition-colors">
                <X size={18} />
              </button>
            </div>
            <div className="p-6 space-y-5">
              <div className="space-y-2">
                <label className="text-xs font-semibold text-gray-700">Current Password</label>
                <input type="password" placeholder="••••••••" className="w-full border border-gray-200 rounded-xl px-4 py-2.5 text-sm focus:outline-none focus:ring-2 focus:ring-orange-400" />
              </div>
              <div className="h-px bg-gray-100" />
              <div className="space-y-2">
                <label className="text-xs font-semibold text-gray-700">New Password</label>
                <input type="password" placeholder="••••••••" className="w-full border border-gray-200 rounded-xl px-4 py-2.5 text-sm focus:outline-none focus:ring-2 focus:ring-orange-400" />
              </div>
              <div className="space-y-2">
                <label className="text-xs font-semibold text-gray-700">Confirm New Password</label>
                <input type="password" placeholder="••••••••" className="w-full border border-gray-200 rounded-xl px-4 py-2.5 text-sm focus:outline-none focus:ring-2 focus:ring-orange-400" />
              </div>
              <ul className="text-[11px] text-gray-400 space-y-1 list-disc pl-4">
                <li>Must be at least 8 characters long</li>
                <li>Must contain at least 1 number and 1 symbol</li>
              </ul>
            </div>
            <div className="px-6 py-4 bg-gray-50/50 border-t border-gray-100 flex justify-end gap-3">
              <button onClick={() => setShowChangePassword(false)} className="px-4 py-2.5 text-sm font-semibold text-gray-600 hover:bg-gray-100 rounded-xl transition-colors">
                Cancel
              </button>
              <button onClick={() => setShowChangePassword(false)} className="px-5 py-2.5 bg-orange-500 hover:bg-orange-600 text-white text-sm font-semibold rounded-xl transition-colors shadow-sm">
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