import { useEffect, useState } from 'react'
import { useSearchParams, useNavigate } from 'react-router-dom'
import { Unlock, ShieldCheck, ArrowRight, Lock, UserCheck } from 'lucide-react'
import { API_BASE_URL } from '../lib/auth'

export default function UnlockAccount() {
    const [searchParams] = useSearchParams()
    const navigate = useNavigate()
    const token = searchParams.get('token')

    const [loading, setLoading] = useState(false)
    const [error, setError] = useState<string | null>(null)
    const [success, setSuccess] = useState(false)
    const [email, setEmail] = useState('')

    useEffect(() => {
        if (!token) return

        const performUnlock = async () => {
            setLoading(true)
            setError(null)

            try {
                const response = await fetch(`${API_BASE_URL}/api/auth/superadmin/unlock-account`, {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify({ token }),
                })

                const data = await response.json()
                if (!response.ok) {
                    throw new Error(data.message || 'Failed to unlock account')
                }

                setSuccess(true)
                setEmail(data.email || '')
            } catch (err) {
                setError(err instanceof Error ? err.message : 'Something went wrong')
            } finally {
                setLoading(false)
            }
        }

        performUnlock()
    }, [token])

    if (!token) {
        return (
            <div className="min-h-screen bg-slate-50 flex items-center justify-center p-4">
                <div className="max-w-md w-full bg-white rounded-3xl shadow-xl shadow-slate-200/50 p-8 text-center uppercase tracking-tight">
                    <div className="w-16 h-16 bg-red-100 rounded-2xl flex items-center justify-center text-red-600 mx-auto mb-6">
                        <Lock size={32} />
                    </div>
                    <h1 className="text-2xl font-bold text-gray-900 mb-2">Missing Token</h1>
                    <p className="text-gray-500 mb-8 lowercase font-medium">Please use the link provided in your email to unlock your account.</p>
                    <button onClick={() => navigate('/')} className="btn-primary w-full shadow-lg shadow-primary-600/20">
                        Go to Login
                    </button>
                </div>
            </div>
        )
    }

    return (
        <div className="min-h-screen bg-slate-50 flex items-center justify-center p-4 selection:bg-red-100">
            <div className="max-w-md w-full animate-fade-in-up">
                {/* Brand */}
                <div className="mb-8 text-center">
                    <div className="inline-flex items-center gap-3 bg-white px-5 py-3 rounded-2xl shadow-sm border border-slate-100">
                        <div className="bg-red-600 p-2 rounded-xl text-white shadow-lg shadow-red-600/30">
                            <ShieldCheck size={24} />
                        </div>
                        <span className="text-2xl font-black tracking-tight text-slate-800">
                            KELIRI <span className="text-red-600">SECURITY</span>
                        </span>
                    </div>
                </div>

                {/* Card */}
                <div className="bg-white rounded-[2rem] shadow-2xl shadow-slate-200/60 border border-slate-100 overflow-hidden relative">
                    <div className="absolute top-0 left-0 w-full h-1.5 bg-gradient-to-r from-red-400 via-red-600 to-red-400 animate-gradient-x"></div>

                    <div className="p-8 sm:p-10 text-center">
                        {loading ? (
                            <div className="py-12">
                                <div className="w-16 h-16 border-4 border-slate-100 border-t-red-600 rounded-full animate-spin mx-auto mb-6"></div>
                                <h1 className="text-2xl font-bold text-slate-800 mb-2">Unlocking Account...</h1>
                                <p className="text-slate-500">Verifying security token and restoring access.</p>
                            </div>
                        ) : success ? (
                            <div className="py-6 animate-fade-in">
                                <div className="w-20 h-20 bg-green-100 rounded-full flex items-center justify-center text-green-600 mx-auto mb-6 shadow-inner">
                                    <UserCheck size={40} />
                                </div>
                                <h1 className="text-3xl font-bold text-slate-900 mb-2">Access Restored</h1>
                                <p className="text-slate-600 mb-2">Account for <span className="font-bold text-slate-800">{email}</span> is now unlocked.</p>
                                <div className="bg-green-50 p-4 rounded-2xl border border-green-100 mb-8">
                                    <p className="text-green-700 text-sm font-medium">You can now proceed to log in with your credentials. Please be careful with your password to avoid another lock.</p>
                                </div>
                                <button onClick={() => navigate('/')} className="btn-primary w-full bg-slate-900 hover:bg-black shadow-xl shadow-slate-200 transform active:scale-[0.98] transition-all flex items-center justify-center gap-2 group">
                                    Proceed to Login <ArrowRight size={20} className="group-hover:translate-x-1 transition-transform" />
                                </button>
                            </div>
                        ) : (
                            <div className="py-6 animate-fade-in">
                                <div className="w-20 h-20 bg-red-100 rounded-full flex items-center justify-center text-red-600 mx-auto mb-6">
                                    <Unlock size={40} />
                                </div>
                                <h1 className="text-2xl font-bold text-slate-900 mb-4">Unlock Failed</h1>
                                <div className="bg-red-50 p-5 rounded-2xl border border-red-100 mb-8">
                                    <p className="text-red-700 text-sm font-bold flex items-center gap-2 justify-center">
                                        <Lock size={16} /> {error || 'Something went wrong during unlock'}
                                    </p>
                                </div>
                                <p className="text-slate-500 text-sm mb-8 leading-relaxed">
                                    The link may have expired (valid for 15 minutes) or has already been used. Please try logging in again to trigger a new unlock email if needed.
                                </p>
                                <button onClick={() => navigate('/')} className="btn-primary w-full flex items-center justify-center gap-2 group">
                                    Back to Login <ArrowRight size={20} className="group-hover:translate-x-1 transition-transform" />
                                </button>
                            </div>
                        )}
                    </div>

                    <div className="px-8 py-5 bg-slate-50 border-t border-slate-100 text-center">
                        <div className="flex items-center justify-center gap-2 text-slate-400">
                            <ShieldCheck size={14} />
                            <span className="text-[10px] font-black uppercase tracking-widest leading-none">Security Enforcement Module</span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    )
}
