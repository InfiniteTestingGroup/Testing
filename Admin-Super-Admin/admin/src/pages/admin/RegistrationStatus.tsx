import { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import { motion } from 'framer-motion';
import {
  BarChart2,
  Megaphone,
  MapPin,
  Building2,
  CheckCircle2,
  Clock,
  XCircle,
  ArrowRight,
  RotateCcw,
  Loader2,
  RefreshCw,
} from 'lucide-react';
import { adminApi } from '../../services/api';
import { toast } from 'react-hot-toast';

type RegistrationStatus = 'approved' | 'pending' | 'rejected';

const statusConfig = {
  approved: {
    icon: <CheckCircle2 className="w-12 h-12 text-emerald-500" />,
    badge: (
      <span className="inline-flex items-center gap-2 px-4 py-1.5 rounded-full bg-emerald-50 dark:bg-emerald-500/10 border border-emerald-200 dark:border-emerald-500/20 text-emerald-700 dark:text-emerald-400 text-sm font-bold uppercase tracking-widest">
        <span className="w-2 h-2 rounded-full bg-emerald-500 animate-pulse" />
        Approved
      </span>
    ),
    title: 'Application Approved!',
    message: 'Your business account has been verified and approved. You can now log in to your KELIRI Admin dashboard.',
    ctaLabel: 'Go to Login',
    ctaIcon: <ArrowRight className="w-[18px] h-[18px]" />,
    ctaStyle: 'bg-brand-500 hover:bg-brand-600 text-white shadow-lg shadow-brand-500/20',
    bgAccent: 'bg-emerald-50 dark:bg-emerald-500/5 border-emerald-100 dark:border-emerald-500/10',
  },
  pending: {
    icon: <Clock className="w-12 h-12 text-amber-500" />,
    badge: (
      <span className="inline-flex items-center gap-2 px-4 py-1.5 rounded-full bg-amber-50 dark:bg-amber-500/10 border border-amber-200 dark:border-amber-500/20 text-amber-700 dark:text-amber-400 text-sm font-bold uppercase tracking-widest">
        <span className="w-2 h-2 rounded-full bg-amber-500 animate-pulse" />
        Awaiting Approval
      </span>
    ),
    title: 'Under Review',
    message: 'Your application is currently being reviewed by our team. This usually takes 1–2 business days. We\'ll notify you via email once a decision has been made.',
    ctaLabel: null,
    ctaIcon: null,
    ctaStyle: '',
    bgAccent: 'bg-amber-50 dark:bg-amber-500/5 border-amber-100 dark:border-amber-500/10',
  },
  rejected: {
    icon: <XCircle className="w-12 h-12 text-red-500" />,
    badge: (
      <span className="inline-flex items-center gap-2 px-4 py-1.5 rounded-full bg-red-50 dark:bg-red-500/10 border border-red-200 dark:border-red-500/20 text-red-700 dark:text-red-400 text-sm font-bold uppercase tracking-widest">
        <span className="w-2 h-2 rounded-full bg-red-500" />
        Rejected
      </span>
    ),
    title: 'Application Rejected',
    message: 'Unfortunately, your application was not approved at this time. Please review the reason below and re-apply with the necessary corrections.',
    ctaLabel: 'Re-Apply',
    ctaIcon: <RotateCcw className="w-[18px] h-[18px]" />,
    ctaStyle: 'bg-red-500 hover:bg-red-600 text-white shadow-lg shadow-red-500/20',
    bgAccent: 'bg-red-50 dark:bg-red-500/5 border-red-100 dark:border-red-500/10',
  },
};

export default function RegistrationStatus() {
  const navigate = useNavigate();
  const [status, setStatus] = useState<RegistrationStatus>('pending');
  const [reason, setReason] = useState<string | undefined>(undefined);
  const [isLoading, setIsLoading] = useState(true);
  const [email, setEmail] = useState('');

  const fetchStatus = async (emailToFetch: string) => {
    try {
      const response = await adminApi.checkRegistrationStatus(emailToFetch);
      if (response.success && response.status) {
        setStatus(response.status.toLowerCase() as RegistrationStatus);
        setReason(response.rejectionReason);
      } else {
        // 404 from backend is normalized into success=false by the API wrapper.
        // Keep the UI stable and inform the user if it's just a missing/incorrect email.
        const msg = response.message || response.error;
        if (msg && /no registration found/i.test(msg)) {
          toast.error('No registration found for this email. Please check the email or register again.');
        }
      }
    } catch (error: any) {
      // Non-404 errors (network/server) still come here.
      console.error('Error fetching status:', error);
      toast.error('Unable to fetch status. Please try again.');
    } finally {
      setIsLoading(false);
    }
  };

  useEffect(() => {
    const storedEmail = localStorage.getItem('registrationEmail');
    const urlParams = new URLSearchParams(window.location.search);
    const emailParam = urlParams.get('email');
    const emailToUse = storedEmail || emailParam || '';
    
    if (emailToUse) {
      setEmail(emailToUse);
      fetchStatus(emailToUse);
    } else {
      setIsLoading(false);
      // Fallback
      setEmail('No email found');
    }
  }, []);

  const handleGoToLogin = () => {
    localStorage.removeItem('registrationEmail');
    navigate('/admin/login');
  };

  const handleReApply = () => {
    localStorage.removeItem('registrationEmail');
    navigate('/admin/register');
  };

  const cfg = statusConfig[status];

  return (
    <div className="flex min-h-screen bg-gray-50 md:bg-white dark:bg-[#0E1117]">

      {/* ── Left Panel ── */}
      <div className="hidden lg:flex lg:w-1/2 relative bg-gradient-to-br from-brand-500 via-brand-600 to-brand-700 overflow-hidden text-white p-12 flex-col justify-between">
        <div className="absolute top-[-10%] right-[-10%] w-96 h-96 bg-brand-400 rounded-full blur-[100px] opacity-60" />
        <div className="absolute bottom-[-10%] left-[-10%] w-[30rem] h-[30rem] bg-brand-800 rounded-full blur-[120px] opacity-60" />

        <div className="relative z-10">
          <div className="flex items-center gap-3">
            <img
              src="/src/assets/keliri-logo.png"
              alt="KELIRI"
              className="w-10 h-10 rounded-xl bg-white/20 p-1 backdrop-blur-sm border border-white/30 shadow-lg object-contain"
            />
            <div>
              <h1 className="font-bold text-lg leading-tight tracking-wide">KELIRI</h1>
              <p className="text-[10px] uppercase font-semibold text-brand-100 tracking-wider">Admin Panel</p>
            </div>
          </div>

          <div className="mt-24 max-w-xl">
            <h2 className="text-4xl md:text-5xl font-bold leading-tight mb-6 tracking-tight">
              Manage Your Advertising<br />Network From One<br />Unified Dashboard
            </h2>
            <p className="text-brand-100 text-lg md:text-xl font-medium leading-relaxed mb-12">
              Take complete control of your business advertising ecosystem — create campaigns, manage branch-level publishers, monitor performance, and track spending — all from a single, powerful admin platform.
            </p>

            <div className="grid grid-cols-2 gap-4">
              {[
                { icon: <BarChart2 className="w-5 h-5" />, title: 'Real-Time Insights', desc: 'Track performance across all locations with live data.' },
                { icon: <Megaphone className="w-5 h-5" />, title: 'Smart Ad Management', desc: 'Create, edit, publish, and monitor advertisements.' },
                { icon: <MapPin className="w-5 h-5" />, title: 'Geo-Targeting', desc: 'City-level and radius-based ad delivery.' },
                { icon: <Building2 className="w-5 h-5" />, title: 'Publisher Management', desc: 'Easily manage and track all your business branches.' },
              ].map((f, i) => (
                <div key={i} className="bg-white/10 backdrop-blur-md border border-white/10 rounded-2xl p-4 hover:bg-white/15 transition-colors">
                  <div className="flex items-center gap-3 mb-2">
                    <div className="p-2 bg-white/10 rounded-lg">{f.icon}</div>
                    <span className="font-semibold text-sm">{f.title}</span>
                  </div>
                  <p className="text-xs text-brand-200 leading-relaxed">{f.desc}</p>
                </div>
              ))}
            </div>
          </div>
        </div>

        <div className="relative z-10 text-xs text-brand-200 font-medium tracking-wide">© 2026 KELIRI</div>
      </div>

      {/* ── Right Panel ── */}
      <div className="w-full lg:w-1/2 flex items-center justify-center p-8 sm:p-12 lg:p-24 bg-gray-50 dark:bg-[#0E1117] transition-colors">
        <div className="w-full max-w-md">

          {/* Mobile Logo */}
          <div className="flex lg:hidden items-center gap-3 mb-10">
            <img src="/src/assets/keliri-logo.png" alt="KELIRI" className="w-10 h-10 rounded-xl bg-brand-500 p-1 shadow-lg object-contain" />
            <div>
              <h1 className="font-bold text-lg text-gray-900 dark:text-white leading-tight tracking-wide">KELIRI</h1>
              <p className="text-[10px] uppercase font-semibold text-brand-500 tracking-wider">Admin Panel</p>
            </div>
          </div>

          {isLoading ? (
            <div className="flex flex-col items-center justify-center gap-4 py-20">
              <Loader2 className="w-10 h-10 text-brand-500 animate-spin" />
              <p className="text-sm font-medium text-gray-500 dark:text-gray-400">Checking application status...</p>
            </div>
          ) : (
            <motion.div
              initial={{ opacity: 0, y: 16 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ duration: 0.4 }}
            >
              <div className="mb-8">
                <p className="text-sm text-gray-500 dark:text-gray-400 mb-1">Checking status for</p>
                <p className="text-sm font-semibold text-gray-800 dark:text-gray-200 truncate">{email}</p>
              </div>

              {/* Status Card */}
              <div className={`rounded-2xl border p-8 ${cfg.bgAccent} mb-6`}>
                <div className="flex flex-col items-center text-center gap-5">
                  <motion.div initial={{ scale: 0 }} animate={{ scale: 1 }} transition={{ type: 'spring', delay: 0.2 }}>
                    {cfg.icon}
                  </motion.div>

                  {cfg.badge}

                  <div>
                    <h2 className="text-2xl font-bold text-gray-900 dark:text-white mb-2">{cfg.title}</h2>
                    <p className="text-gray-500 dark:text-gray-400 text-sm leading-relaxed">{cfg.message}</p>
                  </div>

                  {/* Rejection reason if applicable */}
                  {status === 'rejected' && reason && (
                    <div className="w-full bg-red-100 dark:bg-red-500/10 border border-red-200 dark:border-red-500/20 rounded-xl p-4 text-left">
                      <p className="text-xs font-black uppercase tracking-widest text-red-500 mb-1">Rejection Reason</p>
                      <p className="text-sm text-red-700 dark:text-red-400">{reason}</p>
                    </div>
                  )}
                </div>
              </div>

              {/* CTA Button */}
              {status === 'approved' && (
                <button
                  onClick={handleGoToLogin}
                  className={`w-full flex items-center justify-center gap-2 py-3.5 px-4 font-semibold rounded-xl transition-all ${cfg.ctaStyle}`}
                >
                  {cfg.ctaLabel}
                  {cfg.ctaIcon}
                </button>
              )}

              {status === 'rejected' && (
                <button
                  onClick={handleReApply}
                  className={`w-full flex items-center justify-center gap-2 py-3.5 px-4 font-semibold rounded-xl transition-all ${cfg.ctaStyle}`}
                >
                  {cfg.ctaIcon}
                  {cfg.ctaLabel}
                </button>
              )}

              {status === 'pending' && (
                <div className="text-center space-y-4">
                  <button
                    disabled
                    className="w-full flex items-center justify-center gap-2 py-3.5 px-4 bg-gray-100 dark:bg-gray-800 text-gray-400 dark:text-gray-500 font-semibold rounded-xl cursor-not-allowed"
                  >
                    <Clock className="w-[18px] h-[18px]" />
                    Awaiting Decision
                  </button>
                  <button
                    onClick={() => window.location.reload()}
                    className="flex items-center justify-center gap-1.5 mx-auto text-sm text-gray-500 dark:text-gray-400 hover:text-brand-500 transition-colors"
                  >
                    <RefreshCw className="w-4 h-4" />
                    Refresh status
                  </button>
                </div>
              )}

              {/* Help text */}
              <p className="text-center text-xs text-gray-400 mt-8">
                Need help?{' '}
                <a href="mailto:support@keliri.com" className="text-brand-500 font-semibold hover:underline">
                  Contact support
                </a>
              </p>

              <div className="mt-6 flex items-center justify-center gap-1.5 text-xs text-gray-500 dark:text-gray-400">
                Protected by <span className="font-semibold text-gray-700 dark:text-gray-300">KELIRI Security</span>
                <span>·</span>
                Role-based access control
              </div>
            </motion.div>
          )}
        </div>
      </div>
    </div>
  );
}
