import { useState, useRef, useEffect } from 'react'
import { Navigate, useLocation, useNavigate } from 'react-router-dom'
import {
  Mail, Lock, Eye, EyeOff, Phone, ArrowRight,
  Shield, BarChart3, Megaphone, MapPin
} from 'lucide-react'
import logo from '../assets/lightmodelogo.png'
import icon from '../assets/keliriicon.png'
import { AuthError, getAuthSession, loginSuperAdmin, persistAuthSession } from '../lib/auth'

type Tab = 'email' | 'phone'
type OtpStep = 'phone' | 'otp'

const features = [
  { icon: BarChart3, label: 'Real-time Analytics', desc: 'Track performance across all campaigns' },
  { icon: Megaphone, label: 'Ad Management', desc: 'Monitor and control all advertisements' },
  { icon: MapPin, label: 'Geo-Targeting', desc: 'City and radius-based ad delivery' },
  { icon: Shield, label: 'Secure & Compliant', desc: 'Role-based access with full audit logs' },
]

export default function Login() {
  const navigate = useNavigate()
  const location = useLocation()
  const existingSession = getAuthSession()

  // Tab state
  const [activeTab, setActiveTab] = useState<Tab>('email')

  // Email form
  const [email, setEmail] = useState('')
  const [password, setPassword] = useState('')
  const [showPassword, setShowPassword] = useState(false)

  // Phone/OTP form
  const [phone, setPhone] = useState('')
  const [otpStep, setOtpStep] = useState<OtpStep>('phone')
  const [otp, setOtp] = useState(['', '', '', '', '', ''])
  const [countdown, setCountdown] = useState(0)
  const otpRefs = useRef<(HTMLInputElement | null)[]>([])

  // Loading
  const [loading, setLoading] = useState(false)
  const [errors, setErrors] = useState<Record<string, string>>({})
  const [authMessage, setAuthMessage] = useState('')

  useEffect(() => {
    const params = new URLSearchParams(location.search)
    const reason = params.get('reason')

    if (reason === 'session-expired') {
      setAuthMessage('Session expired. Please login again.')
      return
    }
    if (reason === 'forbidden') {
      setAuthMessage('You do not have permission to access that module.')
      return
    }

    setAuthMessage('')
  }, [location.search])

  // Countdown timer
  useEffect(() => {
    if (countdown <= 0) return
    const timer = setTimeout(() => setCountdown((c) => c - 1), 1000)
    return () => clearTimeout(timer)
  }, [countdown])

  const validate = () => {
    const errs: Record<string, string> = {}
    if (activeTab === 'email') {
      if (!email) errs.email = 'Email is required'
      else if (!/\S+@\S+\.\S+/.test(email)) errs.email = 'Enter a valid email'
      if (!password) errs.password = 'Password is required'
      else if (password.length < 6) errs.password = 'Minimum 6 characters'
    } else if (otpStep === 'phone') {
      if (!phone) errs.phone = 'Phone number is required'
      else if (!/^\d{10}$/.test(phone.replace(/\s/g, ''))) errs.phone = 'Enter a valid 10-digit number'
    } else {
      if (otp.some((d) => !d)) errs.otp = 'Please enter all 6 digits'
    }
    return errs
  }

  const handleEmailLogin = async (e: React.FormEvent) => {
    e.preventDefault()
    const errs = validate()
    if (Object.keys(errs).length) { setErrors(errs); return }
    setErrors({})
    setAuthMessage('')
    setLoading(true)

    try {
      const response = await loginSuperAdmin(email, password)
      persistAuthSession(response)
      setLoading(false)
      // Determine redirect based on role permissions
      const newSession = getAuthSession()
        if (newSession?.role === 'MASTER_SUPER_ADMIN') {
          navigate('/analytics', { replace: true })
        } else {
          // Sub admin may not have access to analytics; redirect to a page they have permission for
          navigate('/profile', { replace: true })
        }
    } catch (error) {
      setLoading(false)

      if (error instanceof AuthError) {
        setAuthMessage(error.message)
        return
      }

      setAuthMessage('Unable to reach the server. Please try again.')
    }
  }

  const handleSendOtp = (e: React.FormEvent) => {
    e.preventDefault()
    const errs = validate()
    if (Object.keys(errs).length) { setErrors(errs); return }
    setErrors({})
    setLoading(true)
    setTimeout(() => {
      setLoading(false)
      setOtpStep('otp')
      setCountdown(60)
      setTimeout(() => otpRefs.current[0]?.focus(), 100)
    }, 1000)
  }

  const handleVerifyOtp = (e: React.FormEvent) => {
    e.preventDefault()
    const errs = validate()
    if (Object.keys(errs).length) { setErrors(errs); return }
    setErrors({})
    setLoading(true)
    setTimeout(() => {
      setLoading(false)
      navigate('/analytics')
    }, 1400)
  }

  const handleOtpChange = (index: number, value: string) => {
    if (!/^\d?$/.test(value)) return
    const updated = [...otp]
    updated[index] = value
    setOtp(updated)
    if (value && index < 5) otpRefs.current[index + 1]?.focus()
  }

  const handleOtpKeyDown = (index: number, e: React.KeyboardEvent) => {
    if (e.key === 'Backspace' && !otp[index] && index > 0) {
      otpRefs.current[index - 1]?.focus()
    }
  }

  const handleResendOtp = () => {
    setCountdown(60)
    setOtp(['', '', '', '', '', ''])
    setTimeout(() => otpRefs.current[0]?.focus(), 100)
  }

  if (existingSession) {
    const redirectPath = existingSession.role === 'MASTER_SUPER_ADMIN' ? '/analytics' : '/profile';
    return <Navigate to={redirectPath} replace />;
  }

  return (
    <div className="min-h-screen flex">
      {/* ─── Left Panel: Branding ─── */}
      <div className="hidden lg:flex flex-col w-[52%] bg-gradient-to-br from-primary-500 via-primary-600 to-orange-700 relative overflow-hidden p-12">
        {/* Background decorations */}
        <div className="absolute top-0 right-0 w-72 h-72 bg-white/5 rounded-full -translate-y-1/3 translate-x-1/3" />
        <div className="absolute bottom-0 left-0 w-96 h-96 bg-black/10 rounded-full translate-y-1/3 -translate-x-1/3" />
        <div className="absolute top-1/2 right-8 w-32 h-32 bg-white/5 rounded-3xl rotate-12" />

        <div className="relative z-10 flex items-center gap-3 mb-16">
          <div className="w-10 h-10 bg-white/50 backdrop-blur rounded-xl flex items-center justify-center p-1.5 overflow-hidden">
            <img src={icon} alt="KELIRI Logo" className="w-full h-full object-contain" />
          </div>
          <div>
            <img src={logo} alt="KELIRI Logo" className="w-24 h-10 object-contain" />
            <p className="text-orange-200 text-[11px] font-medium tracking-widest uppercase mt-0.5">Super Admin Panel</p>
          </div>
        </div>

        {/* Headline */}
        <div className="relative z-10 flex-1 flex flex-col justify-center">
          <h1 className="text-white font-bold text-4xl leading-tight mb-4">
            Manage Your<br />
            <span className="text-orange-200">Geo-Ad Ecosystem</span><br />
            From One Place
          </h1>
          <p className="text-orange-100 text-base leading-relaxed mb-12 max-w-md">
            Full control over admins, publishers, campaigns, revenue and analytics — all in a single powerful dashboard.
          </p>

          {/* Features */}
          <div className="grid grid-cols-2 gap-4">
            {features.map((f) => {
              const Icon = f.icon
              return (
                <div key={f.label} className="flex items-start gap-3 bg-white/10 backdrop-blur-sm rounded-2xl p-4 hover:bg-white/15 transition-colors">
                  <div className="w-8 h-8 bg-white/20 rounded-lg flex items-center justify-center flex-shrink-0 mt-0.5">
                    <Icon size={15} className="text-white" />
                  </div>
                  <div>
                    <p className="text-white font-semibold text-sm leading-none">{f.label}</p>
                    <p className="text-orange-200 text-xs mt-1 leading-relaxed">{f.desc}</p>
                  </div>
                </div>
              )
            })}
          </div>
        </div>

        {/* Footer text */}
        <p className="relative z-10 text-orange-200/70 text-xs mt-10">
          © 2026 KELIRI · Vinidra Softech · Confidential
        </p>
      </div>

      {/* ─── Right Panel: Form ─── */}
      <div className="flex-1 flex items-center justify-center p-8 bg-gray-50">
        <div className="w-full max-w-md animate-fade-in">
          {/* Mobile logo */}
          <div className="lg:hidden flex items-center gap-2 mb-8">
            <div className="w-8 h-8 rounded-xl flex items-center justify-center flex-shrink-0">
              <img src={icon} alt="KELIRI Logo" className="w-8 h-8 object-contain" />
            </div>
            <p className="font-bold text-gray-900">KELIRI</p>
          </div>

          <div className="mb-8">
            <h2 className="text-2xl font-bold text-gray-900">Welcome back</h2>
            <p className="text-gray-500 text-sm mt-1">Sign in to your Super Admin account</p>
          </div>

          {authMessage && (
            <div className="mb-6 rounded-xl border border-red-200 bg-red-50 px-4 py-3 text-sm font-medium text-red-600">
              {authMessage}
            </div>
          )}

          {/* Tab Switcher */}
          <div className="flex bg-gray-100 rounded-xl p-1 mb-6 gap-1">
            {(['email', 'phone'] as Tab[]).map((tab) => (
              <button
                key={tab}
                onClick={() => { setActiveTab(tab); setErrors({}); setOtpStep('phone') }}
                className={`flex-1 flex items-center justify-center gap-2 py-2.5 rounded-lg text-sm font-medium transition-all duration-200
                  ${activeTab === tab
                    ? 'bg-white text-gray-900 shadow-sm'
                    : 'text-gray-500 hover:text-gray-700'
                  }`}
              >
                {tab === 'email' ? <Mail size={15} /> : <Phone size={15} />}
                {tab === 'email' ? 'Email & Password' : 'Phone & OTP'}
              </button>
            ))}
          </div>

          {/* ── Email Form ── */}
          {activeTab === 'email' && (
            <form onSubmit={handleEmailLogin} className="space-y-4 animate-fade-in">
              <div>
                <label className="text-xs font-semibold text-gray-600 mb-1.5 block">Email Address</label>
                <div className="relative">
                  <Mail size={16} className="absolute left-3.5 top-1/2 -translate-y-1/2 text-gray-400" />
                  <input
                    id="email-input"
                    type="email"
                    placeholder="admin@keliri.com"
                    value={email}
                    onChange={(e) => {
                      setEmail(e.target.value)
                      if (errors.email || authMessage) {
                        setErrors((prev) => ({ ...prev, email: '' }))
                        setAuthMessage('')
                      }
                    }}
                    className={`input-field pl-10 ${errors.email ? 'border-red-400 ring-2 ring-red-100' : ''}`}
                  />
                </div>
                {errors.email && <p className="text-xs text-red-500 mt-1">{errors.email}</p>}
              </div>

              <div>
                <div className="flex items-center justify-between mb-1.5">
                  <label className="text-xs font-semibold text-gray-600">Password</label>
                  <button type="button" className="text-xs text-primary-600 hover:text-primary-700 font-medium transition-colors">
                    Forgot password?
                  </button>
                </div>
                <div className="relative">
                  <Lock size={16} className="absolute left-3.5 top-1/2 -translate-y-1/2 text-gray-400" />
                  <input
                    id="password-input"
                    type={showPassword ? 'text' : 'password'}
                    placeholder="Enter your password"
                    value={password}
                    onChange={(e) => {
                      setPassword(e.target.value)
                      if (errors.password || authMessage) {
                        setErrors((prev) => ({ ...prev, password: '' }))
                        setAuthMessage('')
                      }
                    }}
                    className={`input-field pl-10 pr-10 ${errors.password ? 'border-red-400 ring-2 ring-red-100' : ''}`}
                  />
                  <button
                    type="button"
                    onClick={() => setShowPassword(!showPassword)}
                    className="absolute right-3.5 top-1/2 -translate-y-1/2 text-gray-400 hover:text-gray-600 transition-colors"
                  >
                    {showPassword ? <EyeOff size={16} /> : <Eye size={16} />}
                  </button>
                </div>
                {errors.password && <p className="text-xs text-red-500 mt-1">{errors.password}</p>}
              </div>

              <button
                id="login-btn"
                type="submit"
                disabled={loading}
                className="btn-primary w-full flex items-center justify-center gap-2 mt-2"
              >
                {loading ? (
                  <span className="flex items-center gap-2">
                    <svg className="animate-spin h-4 w-4" viewBox="0 0 24 24" fill="none">
                      <circle className="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" strokeWidth="4" />
                      <path className="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8v8z" />
                    </svg>
                    Signing in...
                  </span>
                ) : (
                  <>Sign In <ArrowRight size={16} /></>
                )}
              </button>
            </form>
          )}

          {/* ── Phone / OTP Form ── */}
          {activeTab === 'phone' && (
            <div className="animate-fade-in">
              {otpStep === 'phone' ? (
                <form onSubmit={handleSendOtp} className="space-y-4">
                  <div>
                    <label className="text-xs font-semibold text-gray-600 mb-1.5 block">Phone Number</label>
                    <div className="relative">
                      <span className="absolute left-3.5 top-1/2 -translate-y-1/2 text-gray-500 text-sm font-medium">+91</span>
                      <span className="absolute left-[46px] top-1/2 -translate-y-1/2 text-gray-300">|</span>
                      <input
                        id="phone-input"
                        type="tel"
                        placeholder="98765 43210"
                        value={phone}
                        onChange={(e) => setPhone(e.target.value)}
                        maxLength={10}
                        className={`input-field pl-14 ${errors.phone ? 'border-red-400 ring-2 ring-red-100' : ''}`}
                      />
                    </div>
                    {errors.phone && <p className="text-xs text-red-500 mt-1">{errors.phone}</p>}
                  </div>
                  <button
                    id="send-otp-btn"
                    type="submit"
                    disabled={loading}
                    className="btn-primary w-full flex items-center justify-center gap-2"
                  >
                    {loading ? (
                      <span className="flex items-center gap-2">
                        <svg className="animate-spin h-4 w-4" viewBox="0 0 24 24" fill="none">
                          <circle className="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" strokeWidth="4" />
                          <path className="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8v8z" />
                        </svg>
                        Sending OTP...
                      </span>
                    ) : (
                      <>Send OTP <ArrowRight size={16} /></>
                    )}
                  </button>
                </form>
              ) : (
                <form onSubmit={handleVerifyOtp} className="space-y-5 animate-fade-in">
                  <div className="bg-primary-50 border border-primary-100 rounded-xl px-4 py-3 flex items-center gap-2">
                    <Phone size={14} className="text-primary-500 flex-shrink-0" />
                    <p className="text-sm text-primary-700">OTP sent to <strong>+91 {phone}</strong></p>
                    <button
                      type="button"
                      onClick={() => { setOtpStep('phone'); setOtp(['', '', '', '', '', '']) }}
                      className="ml-auto text-xs text-primary-600 hover:text-primary-700 font-semibold underline"
                    >
                      Change
                    </button>
                  </div>

                  <div>
                    <label className="text-xs font-semibold text-gray-600 mb-3 block">Enter 6-digit OTP</label>
                    <div className="flex gap-2 justify-between">
                      {otp.map((digit, i) => (
                        <input
                          key={i}
                          ref={(el) => { otpRefs.current[i] = el }}
                          id={`otp-${i}`}
                          type="text"
                          inputMode="numeric"
                          maxLength={1}
                          value={digit}
                          onChange={(e) => handleOtpChange(i, e.target.value)}
                          onKeyDown={(e) => handleOtpKeyDown(i, e)}
                          className={`w-11 h-12 text-center text-lg font-bold border rounded-xl bg-white
                                     focus:outline-none focus:border-primary-400 focus:ring-2 focus:ring-primary-100
                                     transition-all duration-200
                                     ${digit ? 'border-primary-400 bg-primary-50 text-primary-700' : 'border-gray-200 text-gray-800'}
                                     ${errors.otp ? 'border-red-400' : ''}`}
                        />
                      ))}
                    </div>
                    {errors.otp && <p className="text-xs text-red-500 mt-2">{errors.otp}</p>}
                  </div>

                  <div className="flex items-center justify-between">
                    <p className="text-xs text-gray-500">
                      {countdown > 0
                        ? <>Resend in <span className="text-primary-600 font-semibold">{countdown}s</span></>
                        : 'Didn\'t receive the code?'}
                    </p>
                    <button
                      type="button"
                      disabled={countdown > 0}
                      onClick={handleResendOtp}
                      className={`text-xs font-semibold transition-colors
                        ${countdown > 0
                          ? 'text-gray-300 cursor-not-allowed'
                          : 'text-primary-600 hover:text-primary-700'
                        }`}
                    >
                      Resend OTP
                    </button>
                  </div>

                  <button
                    id="verify-otp-btn"
                    type="submit"
                    disabled={loading}
                    className="btn-primary w-full flex items-center justify-center gap-2"
                  >
                    {loading ? (
                      <span className="flex items-center gap-2">
                        <svg className="animate-spin h-4 w-4" viewBox="0 0 24 24" fill="none">
                          <circle className="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" strokeWidth="4" />
                          <path className="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8v8z" />
                        </svg>
                        Verifying...
                      </span>
                    ) : (
                      <>Verify & Sign In <ArrowRight size={16} /></>
                    )}
                  </button>
                </form>
              )}
            </div>
          )}

          {/* Footer */}
          <p className="text-center text-xs text-gray-400 mt-8">
            Protected by KELIRI Security · <span className="text-gray-500">Role-based access control</span>
          </p>
        </div>
      </div>
    </div>
  )
}
