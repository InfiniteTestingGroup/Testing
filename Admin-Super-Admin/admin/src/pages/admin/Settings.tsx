import { useState } from 'react'
import { Settings as SettingsIcon, Bell, Shield, ChevronRight, Save } from 'lucide-react'

type Tab = 'general' | 'notifications' | 'security'

export default function Settings() {
  const [activeTab, setActiveTab] = useState<Tab>('general')

  const userStr = localStorage.getItem('admin_user')
  const user = userStr ? JSON.parse(userStr) : null
  const displayCompany = user?.company || 'KELIRI Publisher Network'
  const displayEmail = user?.email || 'admin@keliri.com'

  return (
    <div className="space-y-6 pb-6 max-w-[1400px] mx-auto px-4 sm:px-6 lg:px-8 py-8 animate-fade-in">
      {/* Header */}
      <div className="flex items-center justify-between pt-1">
        <div>
          <h1 className="text-2xl font-bold text-gray-900 dark:text-white tracking-tight">Platform Settings</h1>
          <p className="text-sm text-gray-500 dark:text-gray-400 mt-0.5">Manage your branch network configurations, alert criteria, and security preferences.</p>
        </div>
      </div>

      <div className="flex flex-col lg:flex-row gap-6">
        
        {/* Left Sidebar Menu */}
        <div className="lg:w-64 flex-shrink-0">
          <div className="bg-white dark:bg-[#1C1F26] p-2 rounded-2xl border border-gray-200 dark:border-gray-800 space-y-1 shadow-sm">
            <button
              onClick={() => setActiveTab('general')}
              className={`w-full flex items-center justify-between px-4 py-3 rounded-xl text-sm font-semibold transition-all
                ${activeTab === 'general' 
                  ? 'bg-brand-50 dark:bg-brand-500/10 text-brand-600 dark:text-brand-400 shadow-sm' 
                  : 'text-gray-600 dark:text-gray-400 hover:bg-gray-50 dark:hover:bg-gray-850'}`}
            >
              <div className="flex items-center gap-3">
                <SettingsIcon size={18} className={activeTab === 'general' ? 'text-brand-500' : 'text-gray-400'} />
                General Config
              </div>
              <ChevronRight size={14} className={activeTab === 'general' ? 'opacity-100' : 'opacity-0'} />
            </button>
            <button
              onClick={() => setActiveTab('notifications')}
              className={`w-full flex items-center justify-between px-4 py-3 rounded-xl text-sm font-semibold transition-all
                ${activeTab === 'notifications' 
                  ? 'bg-brand-50 dark:bg-brand-500/10 text-brand-600 dark:text-brand-400 shadow-sm' 
                  : 'text-gray-600 dark:text-gray-400 hover:bg-gray-50 dark:hover:bg-gray-850'}`}
            >
              <div className="flex items-center gap-3">
                <Bell size={18} className={activeTab === 'notifications' ? 'text-brand-500' : 'text-gray-400'} />
                Notifications
              </div>
              <ChevronRight size={14} className={activeTab === 'notifications' ? 'opacity-100' : 'opacity-0'} />
            </button>
            <button
              onClick={() => setActiveTab('security')}
              className={`w-full flex items-center justify-between px-4 py-3 rounded-xl text-sm font-semibold transition-all
                ${activeTab === 'security' 
                  ? 'bg-brand-50 dark:bg-brand-500/10 text-brand-600 dark:text-brand-400 shadow-sm' 
                  : 'text-gray-600 dark:text-gray-400 hover:bg-gray-50 dark:hover:bg-gray-850'}`}
            >
              <div className="flex items-center gap-3">
                <Shield size={18} className={activeTab === 'security' ? 'text-brand-500' : 'text-gray-400'} />
                Security
              </div>
              <ChevronRight size={14} className={activeTab === 'security' ? 'opacity-100' : 'opacity-0'} />
            </button>
          </div>
        </div>

        {/* Main Content Area */}
        <div className="flex-1 min-w-0">
          <div className="bg-white dark:bg-[#1C1F26] p-6 rounded-2xl border border-gray-200 dark:border-gray-800 h-full min-h-[500px] shadow-sm">
            
            {activeTab === 'general' && (
              <div className="space-y-6">
                <div>
                  <h3 className="text-lg font-bold text-gray-900 dark:text-white border-b border-gray-100 dark:border-gray-800 pb-3">General Configuration</h3>
                  <p className="text-sm text-gray-500 dark:text-gray-400 mt-2">Update business details and settings that apply globally to all branch campaigns.</p>
                </div>
                
                <div className="grid gap-6 sm:grid-cols-2 max-w-2xl">
                  <div className="space-y-2">
                    <label className="text-xs font-semibold text-gray-700 dark:text-gray-300">Company Name</label>
                    <input type="text" defaultValue={displayCompany} className="w-full px-4 py-2.5 bg-white dark:bg-[#1C1F26] border border-gray-200 dark:border-gray-800 rounded-xl text-gray-900 dark:text-white focus:ring-2 focus:ring-brand-500 focus:border-brand-500 transition-colors" />
                  </div>
                  <div className="space-y-2">
                    <label className="text-xs font-semibold text-gray-700 dark:text-gray-300">Support / Contact Email</label>
                    <input type="email" defaultValue={displayEmail} className="w-full px-4 py-2.5 bg-white dark:bg-[#1C1F26] border border-gray-200 dark:border-gray-800 rounded-xl text-gray-900 dark:text-white focus:ring-2 focus:ring-brand-500 focus:border-brand-500 transition-colors" />
                  </div>
                  <div className="space-y-2">
                    <label className="text-xs font-semibold text-gray-700 dark:text-gray-300">Default Currency</label>
                    <select className="w-full px-4 py-2.5 bg-white dark:bg-[#1C1F26] border border-gray-200 dark:border-gray-800 rounded-xl text-gray-900 dark:text-white focus:ring-2 focus:ring-brand-500 focus:border-brand-500 transition-colors">
                      <option value="INR">INR (₹) - Indian Rupee</option>
                      <option value="USD">USD ($) - US Dollar</option>
                    </select>
                  </div>
                  <div className="space-y-2">
                    <label className="text-xs font-semibold text-gray-700 dark:text-gray-300">GSTIN / Tax Registration</label>
                    <input type="text" placeholder="29XXXXX0000X0Z0" className="w-full px-4 py-2.5 bg-white dark:bg-[#1C1F26] border border-gray-200 dark:border-gray-800 rounded-xl text-gray-900 dark:text-white focus:ring-2 focus:ring-brand-500 focus:border-brand-500 transition-colors" />
                  </div>
                </div>

                <div className="pt-4 flex">
                  <button className="flex items-center gap-2 bg-brand-500 hover:bg-brand-600 text-white px-5 py-2.5 rounded-xl font-semibold text-sm hover:shadow-md transition-all">
                    <Save size={16} /> Save Changes
                  </button>
                </div>
              </div>
            )}

            {activeTab === 'notifications' && (
              <div className="space-y-6">
                <div>
                  <h3 className="text-lg font-bold text-gray-900 dark:text-white border-b border-gray-100 dark:border-gray-800 pb-3">Email & System Alerts</h3>
                  <p className="text-sm text-gray-500 dark:text-gray-400 mt-2">Manage which business events trigger automated notifications to your account email.</p>
                </div>

                <div className="space-y-4 max-w-2xl">
                  {/* Toggle items */}
                  {[
                    { id: 1, title: 'Ad Approval Status Updates', desc: 'Alert when one of your submitted campaigns is approved/rejected by Super Admin.' },
                    { id: 2, title: 'Budget Overrun Alerts', desc: 'Get notified when an active campaign exceeds 80% of its budget limit.' },
                    { id: 3, title: 'Daily Location Performance Digest', desc: 'Receive a daily email summarizing clicks, spend, and metrics per branch.' },
                    { id: 4, title: 'Support Ticket Replies', desc: 'Alert when the Super Admin replies to one of your platform queries.' },
                  ].map((setting) => (
                    <div key={setting.id} className="flex items-start justify-between border border-gray-100 dark:border-gray-800 p-4 rounded-xl bg-gray-50/50 dark:bg-gray-900/30">
                      <div>
                        <p className="text-sm font-semibold text-gray-900 dark:text-white">{setting.title}</p>
                        <p className="text-xs text-gray-500 dark:text-gray-400 mt-0.5">{setting.desc}</p>
                      </div>
                      <label className="relative inline-flex items-center cursor-pointer mt-1">
                        <input type="checkbox" defaultChecked className="sr-only peer" />
                        <div className="w-11 h-6 bg-gray-250 dark:bg-gray-800 peer-focus:outline-none rounded-full peer peer-checked:after:translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-white after:border-gray-300 dark:after:border-gray-700 after:border after:rounded-full after:h-5 after:w-5 after:transition-all peer-checked:bg-brand-500"></div>
                      </label>
                    </div>
                  ))}
                </div>
              </div>
            )}

            {activeTab === 'security' && (
              <div className="space-y-6">
                <div>
                  <h3 className="text-lg font-bold text-gray-900 dark:text-white border-b border-gray-100 dark:border-gray-800 pb-3">Security & Access</h3>
                  <p className="text-sm text-gray-500 dark:text-gray-400 mt-2">Review current authorization status and configure credentials protection.</p>
                </div>

                <div className="max-w-2xl space-y-6">
                  <div className="border border-green-100 dark:border-green-900/30 bg-green-50/50 dark:bg-green-950/10 rounded-2xl p-5 flex items-start gap-4">
                    <div className="w-10 h-10 rounded-full bg-green-100 dark:bg-green-950 flex items-center justify-center flex-shrink-0 text-green-600 dark:text-green-400">
                      <Shield size={20} />
                    </div>
                    <div>
                      <h4 className="text-sm font-bold text-gray-900 dark:text-white">Secure Admin Session</h4>
                      <p className="text-xs text-gray-650 dark:text-gray-405 mt-1">Your session token is encrypted and verified against KELIRI Single Sign-On protocols.</p>
                    </div>
                  </div>

                  <div>
                    <h4 className="text-sm font-bold text-gray-900 dark:text-white mb-3">Active Browser Session</h4>
                    <div className="border border-gray-100 dark:border-gray-800 rounded-xl overflow-hidden shadow-sm">
                      <div className="p-4 bg-gray-50 dark:bg-[#1C1F26] flex items-center justify-between border-b border-gray-100 dark:border-gray-800">
                        <div>
                          <p className="text-sm font-semibold text-gray-800 dark:text-gray-200">Current Device • Chrome Browser</p>
                          <p className="text-xs text-gray-500 dark:text-gray-400 mt-0.5">Session started at: {new Date().toLocaleTimeString()}</p>
                        </div>
                        <span className="bg-emerald-500/10 text-emerald-600 dark:text-emerald-400 px-2 py-0.5 text-[10px] font-semibold rounded-full border border-emerald-500/20">Active Now</span>
                      </div>
                    </div>
                  </div>
                </div>

              </div>
            )}

          </div>
        </div>

      </div>
    </div>
  )
}
