import { useState, useEffect } from "react";
import { useForm } from "react-hook-form";
import { useNavigate } from "react-router-dom";
import {
  BarChart2,
  Megaphone,
  MapPin,
  Building2,
  Mail,
  Lock,
  Eye,
  EyeOff,
  Phone,
  ArrowRight
} from "lucide-react";
import { motion } from "framer-motion";
import { adminApi, adMobileApi } from "../../services/api";
import { AlertCircle } from "lucide-react";
import icon from "../../assets/keliriicon.png";

type TabType = "email" | "otp";

export default function AdminLogin() {
  const [activeTab, setActiveTab] = useState<TabType>("email");
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [showPassword, setShowPassword] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const navigate = useNavigate();
  const { register, handleSubmit } = useForm();

  useEffect(() => {
    document.documentElement.classList.remove("dark");
  }, []);

  const onSubmit = async (data: any) => {
    setIsSubmitting(true);
    setError(null);
    try {
      if (activeTab === "email") {
        console.log('Login Payload:', { email: data.email, password: data.password });
        const result = await adminApi.login(data.email, data.password);
        console.log('Login Response:', result);
        if (result.success) {
          localStorage.setItem('admin_token', result.token || "");

          let userObj = result.user || {};
          console.log('🔍 Login Debug - Original user object:', userObj);
          console.log('🔍 Login Debug - Has companyUID:', !!userObj.companyUID);

          if (!userObj.companyUID) {
            try {
              console.log('🔍 Login Debug - Fetching companies from EC2...');
              const companyRes = await adMobileApi.get('/v1/company/PRODUCTS_SERVICES', {
                params: { all: 'yes' }
              });
              const allCompanies: any[] = companyRes.data?.data || [];
              console.log('🔍 Login Debug - EC2 companies found:', allCompanies.length);
              console.log('🔍 Login Debug - EC2 companies:', allCompanies.map(c => ({ name: c.name, email: c.email, uid: c.uid })));

              let matched = allCompanies.find(
                (c: any) =>
                  c?.email?.toLowerCase() === data.email?.toLowerCase() ||
                  (userObj.company && c?.name?.toLowerCase() === userObj.company?.toLowerCase())
              );

              if (!matched && userObj.company) {
                const adminCompanyLower = userObj.company.toLowerCase();
                matched = allCompanies.find((c: any) =>
                  c?.name?.toLowerCase().includes(adminCompanyLower) ||
                  adminCompanyLower.includes(c?.name?.toLowerCase())
                );
              }

              if (!matched && userObj.name) {
                const adminNameLower = userObj.name.toLowerCase();
                matched = allCompanies.find((c: any) =>
                  c?.name?.toLowerCase().includes(adminNameLower) ||
                  adminNameLower.includes(c?.name?.toLowerCase())
                );
              }

              if (!matched && allCompanies.length === 1) {
                matched = allCompanies[0];
                console.log('🔍 Login Debug - Using single available company as fallback');
              }

              console.log('🔍 Login Debug - Matching criteria:', {
                adminEmail: data.email?.toLowerCase(),
                adminCompany: userObj.company?.toLowerCase(),
                foundMatch: !!matched
              });

              if (matched?.uid) {
                userObj = { ...userObj, companyUID: matched.uid };
                console.log('✅ companyUID resolved from Ad Mobile:', matched.uid);
                console.log('🔍 Login Debug - Matched company:', { name: matched.name, email: matched.email, uid: matched.uid });
              } else {
                console.warn('⚠️ No matching company found in Ad Mobile for:', data.email);
                console.log('🔍 Login Debug - Available company emails:', allCompanies.map(c => c.email));
                console.log('🔍 Login Debug - Available company names:', allCompanies.map(c => c.name));
              }
            } catch (e) {
              console.warn('Could not look up companyUID from Ad Mobile:', e);
            }
          } else {
            console.log('🔍 Login Debug - Using existing companyUID:', userObj.companyUID);
          }

          localStorage.setItem('admin_user', JSON.stringify(userObj));
          navigate("/admin/dashboard");
        } else {
          setError(result.message || "Failed to sign in. Please check your credentials.");
        }
      } else {
        setError("OTP login is currently disabled for security reasons. Please use Email & Password.");
      }
    } catch (err: any) {
      setError(err.message || "An unexpected error occurred. Please try again later.");
    } finally {
      setIsSubmitting(false);
    }
  };

  return (
    <div className="flex min-h-screen bg-gray-50 md:bg-white dark:bg-[#0E1117]">
      {/* Left Panel - Branding (Hidden on mobile) */}
      <div className="hidden lg:flex lg:w-1/2 relative bg-gradient-to-br from-brand-500 via-brand-600 to-brand-700 overflow-hidden text-white p-12 flex-col justify-between">
        {/* Abstract background shapes */}
        <div className="absolute top-[-10%] right-[-10%] w-96 h-96 bg-brand-400 rounded-full blur-[100px] opacity-60"></div>
        <div className="absolute bottom-[-10%] left-[-10%] w-[30rem] h-[30rem] bg-brand-800 rounded-full blur-[120px] opacity-60"></div>

        <div className="relative z-10">
          <div className="flex items-center gap-3">
            {/* Logo icon — white/50 backdrop matching super admin */}
            <div className="w-10 h-10 bg-white/50 backdrop-blur rounded-xl flex items-center justify-center p-1.5 overflow-hidden">
              <img src={icon} alt="KELIRI" className="w-full h-full object-contain" />
            </div>
            <div>
              <h1 className="font-bold text-lg leading-tight tracking-wide text-black">keliri</h1>
              <p className="text-[10px] uppercase font-semibold text-white tracking-wider">Admin Panel</p>
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
                { icon: <BarChart2 className="w-5 h-5" />, title: "Real-Time Insights", desc: "Track performance across all locations with live data." },
                { icon: <Megaphone className="w-5 h-5" />, title: "Smart Ad Management", desc: "Create, edit, publish, and monitor advertisements." },
                { icon: <MapPin className="w-5 h-5" />, title: "Geo-Targeting", desc: "City-level and radius-based ad delivery." },
                { icon: <Building2 className="w-5 h-5" />, title: "Publisher Management", desc: "Easily manage and track all your business branches." },
              ].map((feature, i) => (
                <div key={i} className="bg-white/10 backdrop-blur-md border border-white/10 rounded-2xl p-4 hover:bg-white/15 transition-colors">
                  <div className="flex items-center gap-3 mb-2">
                    <div className="p-2 bg-white/10 rounded-lg shadow-sm">
                      {feature.icon}
                    </div>
                    <span className="font-semibold text-sm">{feature.title}</span>
                  </div>
                  <p className="text-xs text-brand-200 leading-relaxed">{feature.desc}</p>
                </div>
              ))}
            </div>
          </div>
        </div>

        <div className="relative z-10 text-xs text-brand-200 font-medium tracking-wide">
          © 2026 KELIRI
        </div>
      </div>

      {/* Right Panel - Login Form */}
      <div className="w-full lg:w-1/2 flex items-center justify-center p-8 sm:p-12 lg:p-24 relative bg-gray-50 dark:bg-[#0E1117] transition-colors">
        <div className="w-full max-w-md">

          {/* Mobile Header (Hidden on desktop) */}
          <div className="flex lg:hidden items-center gap-3 mb-10">
            <div className="w-10 h-10 bg-white/50 backdrop-blur rounded-xl flex items-center justify-center p-1.5 overflow-hidden shadow-lg">
              <img src={icon} alt="KELIRI" className="w-full h-full object-contain" />
            </div>
            <div>
              <h1 className="font-bold text-lg text-gray-900 dark:text-white leading-tight tracking-wide">keliri</h1>
              <p className="text-[10px] uppercase font-semibold text-brand-500 tracking-wider">Admin Panel</p>
            </div>
          </div>

          <div className="mb-10">
            <h2 className="text-3xl font-bold text-gray-900 dark:text-white mb-2">Welcome back</h2>
            <p className="text-gray-500 dark:text-gray-400">Sign in to your Admin account</p>
          </div>

          <div className="bg-gray-200/60 dark:bg-[#1C1F26] p-1.5 rounded-xl flex mb-8">
            <button
              type="button"
              onClick={() => setActiveTab("email")}
              className={`flex-1 flex items-center justify-center gap-2 py-3 text-sm font-semibold rounded-lg transition-all duration-200 ${activeTab === "email"
                ? "bg-white dark:bg-gray-800 text-gray-900 dark:text-white shadow-sm border border-gray-200/50 dark:border-gray-700"
                : "text-gray-500 hover:text-gray-700 dark:text-gray-400 dark:hover:text-gray-200"
                }`}
            >
              <Mail className="w-4 h-4" />
              Email & Password
            </button>
            <button
              type="button"
              onClick={() => setActiveTab("otp")}
              className={`flex-1 flex items-center justify-center gap-2 py-3 text-sm font-semibold rounded-lg transition-all duration-200 ${activeTab === "otp"
                ? "bg-white dark:bg-gray-800 text-gray-900 dark:text-white shadow-sm border border-gray-200/50 dark:border-gray-700"
                : "text-gray-500 hover:text-gray-700 dark:text-gray-400 dark:hover:text-gray-200"
                }`}
            >
              <Phone className="w-4 h-4" />
              Phone & OTP
            </button>
          </div>

          {error && (
            <motion.div
              initial={{ opacity: 0, y: -10 }}
              animate={{ opacity: 1, y: 0 }}
              className="mb-6 p-4 bg-red-50 dark:bg-red-900/20 border border-red-200 dark:border-red-800/50 rounded-xl flex items-start gap-3 text-red-600 dark:text-red-400"
            >
              <AlertCircle className="w-5 h-5 shrink-0 mt-0.5" />
              <p className="text-sm font-medium">{error}</p>
            </motion.div>
          )}

          <form onSubmit={handleSubmit(onSubmit)} className="space-y-5">
            {activeTab === "email" ? (
              <motion.div
                initial={{ opacity: 0, x: -10 }}
                animate={{ opacity: 1, x: 0 }}
                transition={{ duration: 0.2 }}
                className="space-y-5"
              >
                <div>
                  <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1.5">
                    Email Address
                  </label>
                  <div className="relative">
                    <div className="absolute inset-y-0 left-0 pl-3.5 flex items-center pointer-events-none text-gray-400">
                      <Mail className="w-[18px] h-[18px]" />
                    </div>
                    <input
                      {...register("email", { required: true })}
                      type="email"
                      placeholder="admin@keliri.com"
                      className="block w-full pl-10 px-4 py-3 bg-white dark:bg-[#1C1F26] border border-gray-200 dark:border-gray-800 rounded-xl text-gray-900 dark:text-white focus:ring-2 focus:ring-brand-500 focus:border-brand-500 transition-colors shadow-sm"
                    />
                  </div>
                </div>

                <div>
                  <div className="flex justify-between items-center mb-1.5">
                    <label className="block text-sm font-medium text-gray-700 dark:text-gray-300">
                      Password
                    </label>
                    <a href="#" className="text-sm font-medium text-brand-600 dark:text-brand-400 hover:text-brand-500">
                      Forgot password?
                    </a>
                  </div>
                  <div className="relative">
                    <div className="absolute inset-y-0 left-0 pl-3.5 flex items-center pointer-events-none text-gray-400">
                      <Lock className="w-[18px] h-[18px]" />
                    </div>
                    <input
                      {...register("password", { required: true })}
                      type={showPassword ? "text" : "password"}
                      placeholder="Enter your password"
                      className="block w-full pl-10 pr-10 px-4 py-3 bg-white dark:bg-[#1C1F26] border border-gray-200 dark:border-gray-800 rounded-xl text-gray-900 dark:text-white focus:ring-2 focus:ring-brand-500 focus:border-brand-500 transition-colors shadow-sm"
                    />
                    <button
                      type="button"
                      onClick={() => setShowPassword(!showPassword)}
                      className="absolute inset-y-0 right-0 pr-3.5 flex items-center text-gray-400 hover:text-gray-600 dark:hover:text-gray-200 transition-colors"
                    >
                      {showPassword ? <EyeOff className="w-[18px] h-[18px]" /> : <Eye className="w-[18px] h-[18px]" />}
                    </button>
                  </div>
                </div>
              </motion.div>
            ) : (
              <motion.div
                initial={{ opacity: 0, x: 10 }}
                animate={{ opacity: 1, x: 0 }}
                transition={{ duration: 0.2 }}
                className="space-y-5"
              >
                <div>
                  <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1.5">
                    Mobile Number
                  </label>
                  <div className="relative">
                    <div className="absolute inset-y-0 left-0 pl-3.5 flex items-center pointer-events-none text-gray-400">
                      <Phone className="w-[18px] h-[18px]" />
                    </div>
                    <input
                      {...register("mobile", { required: true })}
                      type="tel"
                      placeholder="Enter mobile number"
                      className="block w-full pl-10 px-4 py-3 bg-white dark:bg-[#1C1F26] border border-gray-200 dark:border-gray-800 rounded-xl text-gray-900 dark:text-white focus:ring-2 focus:ring-brand-500 focus:border-brand-500 transition-colors shadow-sm"
                    />
                  </div>
                </div>
              </motion.div>
            )}

            <button
              type="submit"
              disabled={isSubmitting}
              className="w-full flex items-center justify-center gap-2 py-3.5 px-4 bg-brand-500 hover:bg-brand-600 text-white font-semibold rounded-xl shadow-lg shadow-brand-500/20 transition-all disabled:opacity-70 disabled:cursor-not-allowed mt-6"
            >
              {isSubmitting ? "Authenticating..." : "Sign In"}
              {!isSubmitting && <ArrowRight className="w-[18px] h-[18px]" />}
            </button>
          </form>

          <div className="mt-10 flex items-center justify-center gap-1.5 text-xs text-gray-500 dark:text-gray-400">
            Protected by <span className="font-semibold text-gray-700 dark:text-gray-300">KELIRI Security</span>
            <span>·</span>
            Role-based access control
          </div>
        </div>
      </div>
    </div>
  );
}