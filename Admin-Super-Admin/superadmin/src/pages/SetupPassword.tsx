import { useState } from 'react'
import { useSearchParams, useNavigate } from 'react-router-dom'
import { KeyRound, ShieldCheck, ArrowRight, Lock, CheckCircle2 } from 'lucide-react'
import { API_BASE_URL } from '../lib/auth'

export default function SetupPassword() {
    const [searchParams] = useSearchParams()
    const navigate = useNavigate()
    const token = searchParams.get('token')

    const [form, setForm] = useState({
        newPassword: '',
        confirmPassword: '',
    })
    const [loading, setLoading] = useState(false)
    const [error, setError] = useState<string | null>(null)
    const [success, setSuccess] = useState(false)

    const handleSubmit = async (e: React.FormEvent) => {
        e.preventDefault()
        if (form.newPassword !== form.confirmPassword) {
            setError('Passwords do not match')
            return
        }
        if (form.newPassword.length < 6) {
            setError('Password must be at least 6 characters long')
            return
        }

        setLoading(true)
        setError(null)

        try {
            const response = await fetch(`${API_BASE_URL}/api/superadmin/sub-admins/setup-password`, {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({
                    setupToken: token,
                    newPassword: form.newPassword,
                }),
            })

            if (!response.ok) {
                const data = await response.json().catch(() => ({}))
                throw new Error(data.message || 'Failed to setup password')
            }

            setSuccess(true)
        } catch (err) {
            setError(err instanceof Error ? err.message : 'Something went wrong')
        } finally {
            setLoading(false)
        }
    }

    if (!token) {
        return (
            <div className="min-h-screen bg-slate-50 flex items-center justify-center p-4">
                <div className="max-w-md w-full bg-white rounded-3xl shadow-xl shadow-slate-200/50 p-8 text-center">
                    <div className="w-16 h-16 bg-red-100 rounded-2xl flex items-center justify-center text-red-600 mx-auto mb-6">
                        <Lock size={32} />
                    </div>
                    <h1 className="text-2xl font-bold text-gray-900 mb-2">Invalid Setup Link</h1>
                    <p className="text-gray-500 mb-8">This password setup link is invalid or has expired. Please contact your administrator for a new invitation.</p>
                    <button onClick={() => navigate('/')} className="btn-primary w-full shadow-lg shadow-primary-600/20">
                        Go to Login
                    </button>
                </div>
            </div>
        )
    }

    if (success) {
        return (
            <div className="min-h-screen bg-slate-50 flex items-center justify-center p-4">
                <div className="max-w-md w-full bg-white rounded-3xl shadow-xl shadow-slate-200/50 p-8 text-center animate-fade-in">
                    <div className="w-16 h-16 bg-green-100 rounded-2xl flex items-center justify-center text-green-600 mx-auto mb-6">
                        <CheckCircle2 size={32} />
                    </div>
                    <h1 className="text-2xl font-bold text-gray-900 mb-2">Password Set Successfully!</h1>
                    <p className="text-gray-500 mb-8">Your account is now active. You can login with your new secure password.</p>
                    <button onClick={() => navigate('/')} className="btn-primary w-full shadow-lg shadow-primary-600/20">
                        Proceed to Login <ArrowRight size={18} className="ml-2 inline" />
                    </button>
                </div>
            </div>
        )
    }

    return (
        <div className="min-h-screen bg-slate-50 flex items-center justify-center p-4 selection:bg-primary-100">
            <div className="max-w-md w-full animate-fade-in-up">
                {/* Logo/Brand */}
                <div className="mb-8 text-center">
                    <div className="inline-flex items-center gap-3 bg-white px-5 py-3 rounded-2xl shadow-sm border border-slate-100 group hover:border-primary-200 transition-all duration-300">
                        <div className="bg-primary-600 p-2 rounded-xl text-white shadow-lg shadow-primary-600/30 group-hover:scale-110 transition-transform">
                            <KeyRound size={24} />
                        </div>
                        <span className="text-2xl font-black tracking-tight text-slate-800">
                            KELIRI <span className="text-primary-600">ADMIN</span>
                        </span>
                    </div>
                </div>

                {/* Card */}
                <div className="bg-white rounded-[2rem] shadow-2xl shadow-slate-200/60 border border-slate-100 overflow-hidden relative">
                    <div className="absolute top-0 left-0 w-full h-1.5 bg-gradient-to-r from-primary-400 via-primary-600 to-primary-400 animate-gradient-x"></div>

                    <div className="p-8 sm:p-10">
                        <div className="mb-8">
                            <h1 className="text-3xl font-bold text-slate-900 mb-2">Initial Setup</h1>
                            <p className="text-slate-500 text-sm font-medium">Please set a secure password to activate your sub-admin account.</p>
                        </div>

                        {error && (
                            <div className="mb-6 p-4 bg-red-50 border border-red-100 rounded-2xl flex items-start gap-3 animate-shake">
                                <Lock className="text-red-500 mt-0.5" size={18} />
                                <p className="text-sm text-red-700 font-medium">{error}</p>
                            </div>
                        )}

                        <form onSubmit={handleSubmit} className="space-y-5">
                            <div className="space-y-2">
                                <label className="text-sm font-bold text-slate-700 ml-1">New Password</label>
                                <div className="relative group">
                                    <div className="absolute inset-y-0 left-0 pl-4 flex items-center pointer-events-none text-slate-400 group-focus-within:text-primary-600 transition-colors">
                                        <ShieldCheck size={20} />
                                    </div>
                                    <input
                                        type="password"
                                        required
                                        className="w-full bg-slate-50 border-slate-200 border-2 rounded-2xl py-4 pl-12 pr-4 text-slate-900 font-semibold focus:bg-white focus:border-primary-500 focus:ring-4 focus:ring-primary-500/10 transition-all outline-none placeholder:text-slate-400"
                                        placeholder="Create a strong password"
                                        value={form.newPassword}
                                        onChange={(e) => setForm((s) => ({ ...s, newPassword: e.target.value }))}
                                    />
                                </div>
                            </div>

                            <div className="space-y-2">
                                <label className="text-sm font-bold text-slate-700 ml-1">Confirm Password</label>
                                <div className="relative group">
                                    <div className="absolute inset-y-0 left-0 pl-4 flex items-center pointer-events-none text-slate-400 group-focus-within:text-primary-600 transition-colors">
                                        <ShieldCheck size={20} />
                                    </div>
                                    <input
                                        type="password"
                                        required
                                        className="w-full bg-slate-50 border-slate-200 border-2 rounded-2xl py-4 pl-12 pr-4 text-slate-900 font-semibold focus:bg-white focus:border-primary-500 focus:ring-4 focus:ring-primary-500/10 transition-all outline-none placeholder:text-slate-400"
                                        placeholder="Repeat your password"
                                        value={form.confirmPassword}
                                        onChange={(e) => setForm((s) => ({ ...s, confirmPassword: e.target.value }))}
                                    />
                                </div>
                            </div>

                            <div className="pt-4">
                                <button
                                    type="submit"
                                    disabled={loading}
                                    className="w-full bg-primary-600 hover:bg-primary-700 disabled:bg-primary-400 text-white font-bold py-4 px-6 rounded-2xl shadow-lg shadow-primary-600/30 hover:shadow-primary-600/40 transform active:scale-[0.98] transition-all flex items-center justify-center gap-2 group"
                                >
                                    {loading ? (
                                        <div className="w-5 h-5 border-2 border-white/30 border-t-white rounded-full animate-spin"></div>
                                    ) : (
                                        <>
                                            Save & Activate Account
                                            <ArrowRight size={20} className="group-hover:translate-x-1 transition-transform" />
                                        </>
                                    )}
                                </button>
                            </div>
                        </form>
                    </div>

                    <div className="px-8 py-6 bg-slate-50 border-t border-slate-100 text-center">
                        <p className="text-xs text-slate-500 font-medium uppercase tracking-widest leading-loose">
                            Security Guarantee
                            <br />
                            <span className="text-slate-400 italic normal-case font-normal">All passwords are encrypted using state-of-the-art BCrypt technology</span>
                        </p>
                    </div>
                </div>

                <div className="mt-8 text-center">
                    <p className="text-slate-500 text-sm font-medium">
                        Remembered? <button onClick={() => navigate('/')} className="text-primary-600 font-extrabold hover:underline transition-all">Back to Login</button>
                    </p>
                </div>
            </div>
        </div>
    )
}
