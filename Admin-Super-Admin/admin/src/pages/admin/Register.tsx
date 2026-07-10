// import { useState, useEffect } from 'react';
// import { useNavigate } from 'react-router-dom';
// import { useForm } from 'react-hook-form';
// import { Toaster } from 'react-hot-toast';
// import { motion } from 'framer-motion';
// import {
//   BarChart2,
//   Megaphone,
//   MapPin,
//   Building2,
//   User,
//   Phone,
//   Mail,
//   MapPinned,
//   FileText,
//   Upload,
//   ArrowRight,
//   Loader2,
//   Lock,
//   Eye,
//   EyeOff,
// } from 'lucide-react';
// import { adminApi } from '../../services/api';
// import type { Company } from '../../services/api';
// import { toast } from 'react-hot-toast';

// export default function AdminRegister() {
//   const navigate = useNavigate();
//   const [isSubmitting, setIsSubmitting] = useState(false);
//   const [gstCertFile, setGstCertFile] = useState<File | null>(null);
//   const [companyDocFile, setCompanyDocFile] = useState<File | null>(null);
//   const [idProofFile, setIdProofFile] = useState<File | null>(null);
//   const [showPassword, setShowPassword] = useState(false);
//   const [showConfirmPassword, setShowConfirmPassword] = useState(false);
//   const [registrationMode, setRegistrationMode] = useState<'new' | 'existing'>('new');
//   const [companies, setCompanies] = useState<Company[]>([]);
//   const [isLoadingCompanies, setIsLoadingCompanies] = useState(false);
//   const [selectedCompanyId, setSelectedCompanyId] = useState<string>('');

//   useEffect(() => {
//     if (registrationMode === 'existing' && companies.length === 0) {
//       const fetchCompanies = async () => {
//         setIsLoadingCompanies(true);
//         try {
//           const response = await adminApi.getAllCompanies();
//           if (response.success && response.data) {
//             setCompanies(response.data);
//           }
//         } catch (error) {
//           console.error('Failed to fetch companies:', error);
//           toast.error('Failed to load existing companies');
//         } finally {
//           setIsLoadingCompanies(false);
//         }
//       };
//       fetchCompanies();
//     }
//   }, [registrationMode, companies.length]);

//   const {
//     register,
//     handleSubmit,
//     watch,
//     formState: { errors },
//   } = useForm({ mode: 'onBlur', shouldUnregister: true });

//   const gstNumber = watch('gstNumber');
//   const showGstCertificate = Boolean(gstNumber?.trim());

//   const onSubmit = async (data: any) => {
//     if (data.password !== data.confirmPassword) {
//       toast.error('Passwords do not match');
//       return;
//     }

//     if (registrationMode === 'new' && (!companyDocFile || !idProofFile)) {
//       toast.error('Please upload all required documents');
//       return;
//     }

//     if (registrationMode === 'new' && showGstCertificate && !gstCertFile) {
//       toast.error('Please upload your GST certificate');
//       return;
//     }

//     setIsSubmitting(true);
//     try {
//       // 1. Build JSON Payload for Ad Mobile (EC2)
//       let jsonPayload: any;
//       if (registrationMode === 'new') {
//         jsonPayload = {
//           name: data.companyName,
//           email: data.emailId,
//           companyType: data.companyType || 'PRODUCTS_SERVICES',
//           phoneNumber: {
//             countryCode: data.countryCode || '+91',
//             dialNumber: data.mobileNumber,
//           },
//           tax: (showGstCertificate && data.gstNumber) ? {
//             taxType: 'GST',
//             taxNumber: data.gstNumber,
//           } : undefined,
//           billingAddress: {
//             addressLine1: data.businessAddress,
//             city: data.city,
//             state: data.state,
//             zipCode: data.zipCode,
//             country: data.country || 'India',
//           },
//           primaryContact: {
//             name: data.authorizedPerson,
//             email: data.emailId,
//             isSameAsBilling: true,
//             phoneNumber: {
//               countryCode: data.countryCode || '+91',
//               dialNumber: data.mobileNumber,
//             },
//           },
//           password: data.password,
//         };
//       } else {
//         if (!selectedCompanyId) {
//           toast.error('Please select an existing company');
//           setIsSubmitting(false);
//           return;
//         }
//         // Look up actual company name for the payload
//         let actualName = data.authorizedPerson; // fallback
//         const selectedComp = companies.find(c => c._id === selectedCompanyId);
//         if (selectedComp) {
//           actualName = selectedComp.name;
//         }

//         jsonPayload = {
//           companyId: selectedCompanyId,
//           name: data.authorizedPerson, // Use authorizedPerson here to pass the unique name check
//           email: data.emailId,
//           phoneNumber: {
//             countryCode: data.countryCode || '+91',
//             dialNumber: data.mobileNumber,
//           },
//           password: data.password,
//           billingAddress: {
//             addressLine1: data.businessAddress || "Company Headquarters",
//             city: "Unknown",
//             state: "Unknown",
//             zipCode: "000000",
//             country: "India"
//           },
//           tax: {
//             taxType: 'GST',
//             taxNumber: "00AAAAA0000A1Z0"
//           },
//           primaryContact: {
//             name: data.authorizedPerson, // Administrator Name
//             email: data.emailId,
//             phoneNumber: {
//               countryCode: data.countryCode || '+91',
//               dialNumber: data.mobileNumber
//             }
//           }
//         };
//       }

//       // 2. Build FormData Payload for Spring Boot (Localhost)
//       const formData = new FormData();

//       // Get the actual company name if joining an existing one
//       let actualCompanyName = data.companyName;
//       if (registrationMode === 'existing' && selectedCompanyId) {
//         const selectedComp = companies.find(c => c._id === selectedCompanyId);
//         if (selectedComp) {
//           actualCompanyName = selectedComp.name;
//         }
//       }

//       const fullAddress = data.businessAddress
//         ? `${data.businessAddress}${data.city ? `, ${data.city}` : ''}${data.state ? `, ${data.state}` : ''}`
//         : (actualCompanyName || 'Joining Existing Company');

//       if (registrationMode === 'existing' && selectedCompanyId) {
//         formData.append('companyId', selectedCompanyId);
//       }

//       formData.append('companyName', actualCompanyName || '');
//       formData.append('authorizedPerson', data.authorizedPerson);
//       formData.append('businessAddress', fullAddress);
//       if (showGstCertificate && data.gstNumber) formData.append('gstNumber', data.gstNumber);
//       formData.append('mobileNumber', data.mobileNumber);
//       formData.append('emailId', data.emailId);
//       formData.append('password', data.password);

//       // Add files if they exist (Spring Boot requires them for new registration approval)
//       if (gstCertFile) formData.append('gstCertificate', gstCertFile);
//       if (companyDocFile) formData.append('companyRegistrationDoc', companyDocFile);
//       if (idProofFile) formData.append('idProof', idProofFile);

//       console.log('--- DUAL REGISTRATION START ---');
//       console.log('1. Sending to Ad Mobile (EC2):', jsonPayload);
//       console.log('2. Sending to Spring Boot (Local):', Object.fromEntries(formData.entries()));

//       // Step A: Register with Ad Mobile (EC2)
//       const adMobileRes = await adminApi.registerCompany(jsonPayload);
//       console.log('Ad Mobile Response:', adMobileRes);

//       if (!adMobileRes || (typeof adMobileRes === 'object' && !adMobileRes.success)) {
//         toast.error(adMobileRes?.message || 'Ad Mobile registration failed');
//         setIsSubmitting(false);
//         return;
//       }

//       // Step B: Register with Spring Boot (Local)
//       const springBootRes = await adminApi.registerAdmin(formData);
//       console.log('Spring Boot Response:', springBootRes);

//       if (!springBootRes || (typeof springBootRes === 'object' && !springBootRes.success)) {
//         toast.error(springBootRes?.message || 'Spring Boot registration failed');
//         setIsSubmitting(false);
//         return;
//       }

//       // Success
//       toast.success('Registration synchronized successfully');
//       localStorage.setItem('registrationEmail', data.emailId);
//       setTimeout(() => {
//         navigate('/admin/status');
//       }, 1500);
//     } catch (error: any) {
//       console.error('Dual Registration Error:', error);
//       toast.error(error.message || 'An unexpected error occurred during synchronization');
//     } finally {
//       setIsSubmitting(false);
//     }
//   };

//   const inputClass =
//     'block w-full pl-10 px-4 py-3 bg-white dark:bg-[#1C1F26] border border-gray-200 dark:border-gray-800 rounded-xl text-gray-900 dark:text-white placeholder-gray-400 focus:ring-2 focus:ring-brand-500 focus:border-brand-500 transition-colors shadow-sm text-sm';
//   const errorClass = 'text-xs text-red-500 mt-1 font-medium';
//   const labelClass = 'block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1.5';

//   const FileDropZone = ({
//     label,
//     file,
//     onChange,
//     accept = '.pdf,.jpg,.jpeg,.png',
//     required = false,
//     hint,
//   }: {
//     label: string;
//     file: File | null;
//     onChange: (f: File | null) => void;
//     accept?: string;
//     required?: boolean;
//     hint?: string;
//   }) => (
//     <div>
//       <label className={labelClass}>
//         {label} {required && <span className="text-red-500">*</span>}
//       </label>
//       <label className="group flex flex-col items-center justify-center w-full h-28 border-2 border-dashed border-gray-200 dark:border-gray-700 rounded-xl cursor-pointer bg-gray-50 dark:bg-[#1C1F26] hover:border-brand-400 hover:bg-brand-50/30 dark:hover:border-brand-500 transition-all">
//         <div className="flex flex-col items-center gap-1.5 text-center px-4">
//           {file ? (
//             <>
//               <FileText className="w-6 h-6 text-brand-500" />
//               <p className="text-sm font-semibold text-brand-600 dark:text-brand-400 truncate max-w-[200px]">{file.name}</p>
//               <p className="text-xs text-gray-400">Click to change</p>
//             </>
//           ) : (
//             <>
//               <Upload className="w-6 h-6 text-gray-400 group-hover:text-brand-500 transition-colors" />
//               <p className="text-sm font-medium text-gray-500 dark:text-gray-400">
//                 <span className="text-brand-500 font-semibold">Click to upload</span> or drag & drop
//               </p>
//               <p className="text-xs text-gray-400">{hint || 'PDF, JPG, PNG accepted'}</p>
//             </>
//           )}
//         </div>
//         <input
//           type="file"
//           accept={accept}
//           className="hidden"
//           onChange={(e) => onChange(e.target.files?.[0] ?? null)}
//         />
//       </label>
//     </div>
//   );

//   return (
//     <div className="flex min-h-screen bg-gray-50 md:bg-white dark:bg-[#0E1117]">
//       <Toaster position="top-right" />

//       {/* ── Left Panel ── */}
//       <div className="hidden lg:flex lg:w-5/12 relative bg-gradient-to-br from-brand-500 via-brand-600 to-brand-700 overflow-hidden text-white p-12 flex-col justify-between">
//         <div className="absolute top-[-10%] right-[-10%] w-96 h-96 bg-brand-400 rounded-full blur-[100px] opacity-60" />
//         <div className="absolute bottom-[-10%] left-[-10%] w-[30rem] h-[30rem] bg-brand-800 rounded-full blur-[120px] opacity-60" />

//         <div className="relative z-10">
//           <div className="flex items-center gap-3">
//             <img src="/src/assets/keliri-logo.png" alt="KELIRI" className="w-10 h-10 rounded-xl bg-white/20 p-1 backdrop-blur-sm border border-white/30 shadow-lg object-contain" />
//             <div>
//               <h1 className="font-bold text-lg leading-tight tracking-wide">KELIRI</h1>
//               <p className="text-[10px] uppercase font-semibold text-brand-100 tracking-wider">Admin Panel</p>
//             </div>
//           </div>

//           <div className="mt-16 max-w-xl">
//             <h2 className="text-4xl font-bold leading-tight mb-5 tracking-tight">
//               Manage Your Advertising<br />Network From One<br />Unified Dashboard
//             </h2>
//             <p className="text-brand-100 text-lg font-medium leading-relaxed mb-10">
//               Take complete control of your business advertising ecosystem — create campaigns, manage branch-level publishers, monitor performance, and track spending — all from a single, powerful admin platform.
//             </p>

//             <div className="grid grid-cols-2 gap-4">
//               {[
//                 { icon: <BarChart2 className="w-5 h-5" />, title: 'Real-Time Insights', desc: 'Track performance across all locations with live data.' },
//                 { icon: <Megaphone className="w-5 h-5" />, title: 'Smart Ad Management', desc: 'Create, edit, publish, and monitor advertisements.' },
//                 { icon: <MapPin className="w-5 h-5" />, title: 'Geo-Targeting', desc: 'City-level and radius-based ad delivery.' },
//                 { icon: <Building2 className="w-5 h-5" />, title: 'Publisher Management', desc: 'Easily manage and track all your business branches.' },
//               ].map((f, i) => (
//                 <div key={i} className="bg-white/10 backdrop-blur-md border border-white/10 rounded-2xl p-4 hover:bg-white/15 transition-colors">
//                   <div className="flex items-center gap-3 mb-2">
//                     <div className="p-2 bg-white/10 rounded-lg">{f.icon}</div>
//                     <span className="font-semibold text-sm">{f.title}</span>
//                   </div>
//                   <p className="text-xs text-brand-200 leading-relaxed">{f.desc}</p>
//                 </div>
//               ))}
//             </div>
//           </div>
//         </div>

//         <div className="relative z-10 text-xs text-brand-200 font-medium tracking-wide">© 2026 KELIRI</div>
//       </div>

//       {/* ── Right Panel ── */}
//       <div className="w-full lg:w-7/12 flex items-start justify-center p-6 sm:p-10 lg:p-14 overflow-y-auto bg-gray-50 dark:bg-[#0E1117] transition-colors">
//         <div className="w-full max-w-2xl">

//           {/* Mobile Logo */}
//           <div className="flex lg:hidden items-center gap-3 mb-8">
//             <img src="/src/assets/keliri-logo.png" alt="KELIRI" className="w-10 h-10 rounded-xl bg-brand-500 p-1 shadow-lg object-contain" />
//             <div>
//               <h1 className="font-bold text-lg text-gray-900 dark:text-white leading-tight tracking-wide">KELIRI</h1>
//               <p className="text-[10px] uppercase font-semibold text-brand-500 tracking-wider">Admin Panel</p>
//             </div>
//           </div>

//           <div className="mb-8">
//             <h2 className="text-3xl font-bold text-gray-900 dark:text-white mb-1">Create your account</h2>
//             <p className="text-gray-500 dark:text-gray-400">Register your business to get started with KELIRI Admin</p>
//           </div>

//           <form onSubmit={handleSubmit(onSubmit)} className="space-y-8">

//             {/* ── Registration Mode Toggle ── */}
//             <div className="flex bg-gray-100 dark:bg-[#1C1F26] p-1.5 rounded-xl">
//               <button
//                 type="button"
//                 onClick={() => setRegistrationMode('new')}
//                 className={`flex-1 py-2.5 text-sm font-semibold rounded-lg transition-all ${registrationMode === 'new'
//                   ? 'bg-white dark:bg-[#2C313C] text-brand-600 shadow-sm'
//                   : 'text-gray-500 hover:text-gray-700 dark:text-gray-400 dark:hover:text-gray-200'
//                   }`}
//               >
//                 Register New Company
//               </button>
//               <button
//                 type="button"
//                 onClick={() => setRegistrationMode('existing')}
//                 className={`flex-1 py-2.5 text-sm font-semibold rounded-lg transition-all ${registrationMode === 'existing'
//                   ? 'bg-white dark:bg-[#2C313C] text-brand-600 shadow-sm'
//                   : 'text-gray-500 hover:text-gray-700 dark:text-gray-400 dark:hover:text-gray-200'
//                   }`}
//               >
//                 Join Existing Company
//               </button>
//             </div>

//             {/* ── Existing Company Selection ── */}
//             {registrationMode === 'existing' && (
//               <div>
//                 <h3 className="text-xs font-black uppercase tracking-widest text-gray-400 dark:text-gray-500 mb-5 pb-3 border-b border-gray-100 dark:border-gray-800">
//                   Select Company
//                 </h3>
//                 {isLoadingCompanies ? (
//                   <div className="flex items-center gap-2 text-sm text-gray-500 p-4 border border-gray-200 dark:border-gray-800 rounded-xl bg-gray-50 dark:bg-[#1C1F26]">
//                     <Loader2 className="w-4 h-4 animate-spin text-brand-500" /> Loading companies...
//                   </div>
//                 ) : (
//                   <div className="space-y-2 max-h-60 overflow-y-auto pr-2 border border-gray-200 dark:border-gray-800 rounded-xl p-2 bg-gray-50 dark:bg-[#1C1F26]">
//                     {companies.length === 0 ? (
//                       <div className="p-4 text-sm text-center text-gray-500">No companies found.</div>
//                     ) : (
//                       companies.map((company) => (
//                         <div
//                           key={company._id}
//                           onClick={() => setSelectedCompanyId(company._id)}
//                           className={`flex items-center gap-3 p-3 rounded-lg cursor-pointer transition-all ${selectedCompanyId === company._id
//                             ? 'bg-brand-50 border-brand-200 dark:bg-brand-900/20 dark:border-brand-500/30 border'
//                             : 'hover:bg-gray-100 dark:hover:bg-[#2C313C] border border-transparent'
//                             }`}
//                         >
//                           {company.companyLogo ? (
//                             <img src={typeof company.companyLogo === 'string' ? company.companyLogo : company.companyLogo.url} alt={company.name} className="w-10 h-10 rounded-lg object-cover bg-white" />
//                           ) : (
//                             <div className="w-10 h-10 rounded-lg bg-brand-100 dark:bg-brand-900 flex items-center justify-center text-brand-600 font-bold text-lg">
//                               {company.name.charAt(0)}
//                             </div>
//                           )}
//                           <div className="flex-1">
//                             <h4 className="font-semibold text-gray-900 dark:text-white text-sm">{company.name}</h4>
//                             {company.companyType && <p className="text-xs text-gray-500 uppercase">{company.companyType.replace('_', ' ')}</p>}
//                           </div>
//                           <div className={`w-5 h-5 rounded-full border flex items-center justify-center ${selectedCompanyId === company._id ? 'border-brand-500 bg-brand-500' : 'border-gray-300 dark:border-gray-600'
//                             }`}>
//                             {selectedCompanyId === company._id && <div className="w-2 h-2 bg-white rounded-full" />}
//                           </div>
//                         </div>
//                       ))
//                     )}
//                   </div>
//                 )}
//               </div>
//             )}

//             {/* ── Company Information ── */}
//             {registrationMode === 'new' && (
//               <div>
//                 <h3 className="text-xs font-black uppercase tracking-widest text-gray-400 dark:text-gray-500 mb-5 pb-3 border-b border-gray-100 dark:border-gray-800">
//                   Company Information
//                 </h3>
//                 <div className="grid grid-cols-1 md:grid-cols-2 gap-5">

//                   {/* Company Name */}
//                   <div>
//                     <label className={labelClass}>Company Name <span className="text-red-500">*</span></label>
//                     <div className="relative">
//                       <div className="absolute inset-y-0 left-0 pl-3.5 flex items-center pointer-events-none text-gray-400">
//                         <Building2 className="w-[18px] h-[18px]" />
//                       </div>
//                       <input
//                         {...register('companyName', { required: 'Company name is required' })}
//                         type="text"
//                         placeholder="Your company name"
//                         className={inputClass}
//                       />
//                     </div>
//                     {errors.companyName && <p className={errorClass}>{errors.companyName.message as string}</p>}
//                   </div>

//                   {/* Company Type */}
//                   <div>
//                     <label className={labelClass}>Company Type <span className="text-red-500">*</span></label>
//                     <div className="relative">
//                       <div className="absolute inset-y-0 left-0 pl-3.5 flex items-center pointer-events-none text-gray-400">
//                         <Building2 className="w-[18px] h-[18px]" />
//                       </div>
//                       <select
//                         {...register('companyType', { required: 'Company type is required' })}
//                         className={`${inputClass} appearance-none`}
//                       >
//                         <option value="">Select Type</option>
//                         <option value="PRODUCTS_SERVICES">Products & Services</option>
//                         <option value="PRODUCTS_SERVICES">Publisher</option>
//                       </select>
//                     </div>
//                     {errors.companyType && <p className={errorClass}>{errors.companyType.message as string}</p>}
//                   </div>

//                   {/* Business Address - full width */}
//                   <div className="md:col-span-2">
//                     <label className={labelClass}>Business Address <span className="text-red-500">*</span></label>
//                     <div className="grid gap-3">
//                       <div className="relative">
//                         <div className="absolute inset-y-0 left-0 pl-3.5 flex items-center pointer-events-none text-gray-400">
//                           <MapPinned className="w-[18px] h-[18px]" />
//                         </div>
//                         <input
//                           {...register('businessAddress', { required: 'Address Line 1 is required' })}
//                           type="text"
//                           placeholder="Address Line 1"
//                           className={inputClass}
//                         />
//                       </div>
//                       {errors.businessAddress && <p className={errorClass}>{errors.businessAddress.message as string}</p>}

//                       <div className="relative">
//                         <div className="absolute inset-y-0 left-0 pl-3.5 flex items-center pointer-events-none text-gray-400">
//                           <MapPinned className="w-[18px] h-[18px]" />
//                         </div>
//                         <input
//                           {...register('addressLine2')}
//                           type="text"
//                           placeholder="Address Line 2 (Optional)"
//                           className={inputClass}
//                         />
//                       </div>

//                       <div className="grid grid-cols-2 gap-3">
//                         <div>
//                           <input
//                             {...register('city', { required: 'City is required' })}
//                             type="text"
//                             placeholder="City"
//                             className={`${inputClass} px-4`}
//                           />
//                           {errors.city && <p className={errorClass}>{errors.city.message as string}</p>}
//                         </div>
//                         <div>
//                           <input
//                             {...register('state', { required: 'State is required' })}
//                             type="text"
//                             placeholder="State"
//                             className={`${inputClass} px-4`}
//                           />
//                           {errors.state && <p className={errorClass}>{errors.state.message as string}</p>}
//                         </div>
//                       </div>

//                       <div className="grid grid-cols-2 gap-3">
//                         <div>
//                           <input
//                             {...register('zipCode', { required: 'Zip Code is required' })}
//                             type="text"
//                             placeholder="Zip/Postal Code"
//                             className={`${inputClass} px-4`}
//                           />
//                           {errors.zipCode && <p className={errorClass}>{errors.zipCode.message as string}</p>}
//                         </div>
//                         <div>
//                           <input
//                             {...register('country', { required: 'Country is required' })}
//                             type="text"
//                             defaultValue="India"
//                             placeholder="Country"
//                             className={`${inputClass} px-4`}
//                           />
//                           {errors.country && <p className={errorClass}>{errors.country.message as string}</p>}
//                         </div>
//                       </div>
//                     </div>
//                   </div>

//                   {/* GST Number */}
//                   <div className={showGstCertificate ? '' : 'md:col-span-2'}>
//                     <label className={labelClass}>GST Number <span className="text-gray-400 font-normal text-xs">(Optional)</span></label>
//                     <div className="relative">
//                       <div className="absolute inset-y-0 left-0 pl-3.5 flex items-center pointer-events-none text-gray-400">
//                         <FileText className="w-[18px] h-[18px]" />
//                       </div>
//                       <input
//                         {...register('gstNumber')}
//                         type="text"
//                         placeholder="e.g. 27AAPCS1234C1ZV"
//                         className={inputClass}
//                       />
//                     </div>
//                     <p className="text-xs text-gray-400 mt-1">GST certificate upload will appear if you enter a number</p>
//                   </div>

//                   {/* GST Certificate Upload (conditional) */}
//                   {showGstCertificate && (
//                     <motion.div initial={{ opacity: 0, y: -8 }} animate={{ opacity: 1, y: 0 }}>
//                       <FileDropZone
//                         label="GST Certificate"
//                         file={gstCertFile}
//                         onChange={setGstCertFile}
//                         required={showGstCertificate}
//                         hint="PDF, JPG, PNG — max 5MB"
//                       />
//                     </motion.div>
//                   )}
//                 </div>
//               </div>
//             )}

//             {/* ── Contact Information ── */}
//             <div>
//               <h3 className="text-xs font-black uppercase tracking-widest text-gray-400 dark:text-gray-500 mb-5 pb-3 border-b border-gray-100 dark:border-gray-800">
//                 Contact Information
//               </h3>
//               <div className="grid grid-cols-1 md:grid-cols-2 gap-5">

//                 {/* Authorized Person */}
//                 <div className="md:col-span-2">
//                   <label className={labelClass}>Authorized Person Name <span className="text-red-500">*</span></label>
//                   <div className="relative">
//                     <div className="absolute inset-y-0 left-0 pl-3.5 flex items-center pointer-events-none text-gray-400">
//                       <User className="w-[18px] h-[18px]" />
//                     </div>
//                     <input
//                       {...register('authorizedPerson', { required: 'Authorized person name is required' })}
//                       type="text"
//                       placeholder="Enter your full name"
//                       className={inputClass}
//                     />
//                   </div>
//                   {errors.authorizedPerson && <p className={errorClass}>{errors.authorizedPerson.message as string}</p>}
//                 </div>

//                 {/* Mobile Number */}
//                 <div>
//                   <label className={labelClass}>Mobile Number <span className="text-red-500">*</span></label>
//                   <div className="flex relative">
//                     <select
//                       {...register('countryCode')}
//                       className="block w-24 pl-3 pr-2 py-3 bg-white dark:bg-[#1C1F26] border border-gray-200 dark:border-gray-800 rounded-l-xl text-gray-900 dark:text-white placeholder-gray-400 focus:ring-2 focus:ring-brand-500 focus:border-brand-500 transition-colors shadow-sm text-sm"
//                       defaultValue="+91"
//                     >
//                       <option value="+91">+91</option>
//                       <option value="+1">+1</option>
//                       <option value="+44">+44</option>
//                     </select>
//                     <div className="absolute inset-y-0 left-24 pl-3 flex items-center pointer-events-none text-gray-400">
//                       <Phone className="w-[18px] h-[18px]" />
//                     </div>
//                     <input
//                       {...register('mobileNumber', {
//                         required: 'Mobile number is required',
//                         pattern: { value: /^\d{10}$/, message: 'Enter a valid 10-digit mobile number' },
//                       })}
//                       type="tel"
//                       placeholder="10-digit mobile number"
//                       className={`${inputClass} rounded-l-none pl-10 border-l-0`}
//                     />
//                   </div>
//                   {errors.mobileNumber && <p className={errorClass}>{errors.mobileNumber.message as string}</p>}
//                 </div>

//                 {/* Email ID */}
//                 <div>
//                   <label className={labelClass}>Email ID <span className="text-red-500">*</span></label>
//                   <div className="relative">
//                     <div className="absolute inset-y-0 left-0 pl-3.5 flex items-center pointer-events-none text-gray-400">
//                       <Mail className="w-[18px] h-[18px]" />
//                     </div>
//                     <input
//                       {...register('emailId', {
//                         required: 'Email is required',
//                         pattern: { value: /^[^\s@]+@[^\s@]+\.[^\s@]+$/, message: 'Enter a valid email address' },
//                       })}
//                       type="email"
//                       placeholder="business@example.com"
//                       className={inputClass}
//                     />
//                   </div>
//                   {errors.emailId && <p className={errorClass}>{errors.emailId.message as string}</p>}
//                 </div>

//                 {/* Password */}
//                 <div>
//                   <label className={labelClass}>Password <span className="text-red-500">*</span></label>
//                   <div className="relative">
//                     <div className="absolute inset-y-0 left-0 pl-3.5 flex items-center pointer-events-none text-gray-400">
//                       <Lock className="w-[18px] h-[18px]" />
//                     </div>
//                     <input
//                       {...register('password', {
//                         required: 'Password is required',
//                         minLength: { value: 8, message: 'Password must be at least 8 characters' }
//                       })}
//                       type={showPassword ? 'text' : 'password'}
//                       placeholder="••••••••"
//                       className={inputClass}
//                     />
//                     <button
//                       type="button"
//                       onClick={() => setShowPassword(!showPassword)}
//                       className="absolute inset-y-0 right-0 pr-3.5 flex items-center text-gray-400 hover:text-gray-600 focus:outline-none"
//                     >
//                       {showPassword ? <EyeOff className="w-5 h-5" /> : <Eye className="w-5 h-5" />}
//                     </button>
//                   </div>
//                   {errors.password && <p className={errorClass}>{errors.password.message as string}</p>}
//                 </div>

//                 {/* Confirm Password */}
//                 <div>
//                   <label className={labelClass}>Confirm Password <span className="text-red-500">*</span></label>
//                   <div className="relative">
//                     <div className="absolute inset-y-0 left-0 pl-3.5 flex items-center pointer-events-none text-gray-400">
//                       <Lock className="w-[18px] h-[18px]" />
//                     </div>
//                     <input
//                       {...register('confirmPassword', {
//                         required: 'Please confirm your password'
//                       })}
//                       type={showConfirmPassword ? 'text' : 'password'}
//                       placeholder="••••••••"
//                       className={inputClass}
//                     />
//                     <button
//                       type="button"
//                       onClick={() => setShowConfirmPassword(!showConfirmPassword)}
//                       className="absolute inset-y-0 right-0 pr-3.5 flex items-center text-gray-400 hover:text-gray-600 focus:outline-none"
//                     >
//                       {showConfirmPassword ? <EyeOff className="w-5 h-5" /> : <Eye className="w-5 h-5" />}
//                     </button>
//                   </div>
//                   {errors.confirmPassword && <p className={errorClass}>{errors.confirmPassword.message as string}</p>}
//                 </div>
//               </div>
//             </div>

//             {/* ── Document Uploads ── */}
//             <div>
//               <h3 className="text-xs font-black uppercase tracking-widest text-gray-400 dark:text-gray-500 mb-5 pb-3 border-b border-gray-100 dark:border-gray-800">
//                 Document Uploads
//               </h3>
//               <div className="grid grid-cols-1 md:grid-cols-2 gap-5">
//                 <FileDropZone
//                   label="Company Registration Document"
//                   file={companyDocFile}
//                   onChange={setCompanyDocFile}
//                   required
//                   hint="Certificate of incorporation or equivalent"
//                 />
//                 <FileDropZone
//                   label="ID Proof"
//                   file={idProofFile}
//                   onChange={setIdProofFile}
//                   required
//                   hint="Aadhaar, Passport, or Driving License"
//                 />
//               </div>
//             </div>

//             {/* ── Submit ── */}
//             <button
//               type="submit"
//               disabled={isSubmitting}
//               className="w-full flex items-center justify-center gap-2 py-3.5 px-4 bg-brand-500 hover:bg-brand-600 text-white font-semibold rounded-xl shadow-lg shadow-brand-500/20 transition-all disabled:opacity-70 disabled:cursor-not-allowed"
//             >
//               {isSubmitting ? (
//                 <><Loader2 className="w-5 h-5 animate-spin" /> Submitting...</>
//               ) : (
//                 <>Register <ArrowRight className="w-[18px] h-[18px]" /></>
//               )}
//             </button>
//           </form>

//           <div className="mt-8 text-center">
//             <p className="text-sm text-gray-500 dark:text-gray-400">
//               Already have an account?{' '}
//               <a href="/admin/login" className="text-brand-600 dark:text-brand-400 font-semibold hover:underline">
//                 Sign in
//               </a>
//             </p>
//           </div>

//           <div className="mt-6 flex items-center justify-center gap-1.5 text-xs text-gray-500 dark:text-gray-400">
//             Protected by <span className="font-semibold text-gray-700 dark:text-gray-300">KELIRI Security</span>
//             <span>·</span>
//             Role-based access control
//           </div>
//         </div>
//       </div>
//     </div>
//   );
// }
import { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import { useForm } from 'react-hook-form';
import { Toaster } from 'react-hot-toast';
import { motion } from 'framer-motion';
import {
  GoogleMap,
  Marker,
  Circle,
  useJsApiLoader
} from "@react-google-maps/api";
import {
  BarChart2,
  Megaphone,
  MapPin,
  Building2,
  User,
  Phone,
  Mail,
  MapPinned,
  FileText,
  Upload,
  ArrowRight,
  Loader2,
  Lock,
  Eye,
  EyeOff,
  Search,
} from 'lucide-react';
import { adminApi } from '../../services/api';
import type { Company } from '../../services/api';
import { toast } from 'react-hot-toast';
import icon from '../../assets/keliriicon.png';

export default function AdminRegister() {
  const navigate = useNavigate();
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [gstCertFile, setGstCertFile] = useState<File | null>(null);
  const [companyDocFile, setCompanyDocFile] = useState<File | null>(null);
  const [idProofFile, setIdProofFile] = useState<File | null>(null);
  const [showPassword, setShowPassword] = useState(false);
  const [showConfirmPassword, setShowConfirmPassword] = useState(false);
  const [registrationMode, setRegistrationMode] = useState<'new' | 'existing'>('new');
  const [companies, setCompanies] = useState<Company[]>([]);
  const [isLoadingCompanies, setIsLoadingCompanies] = useState(false);
  const [companySearchTerm, setCompanySearchTerm] = useState('');
  const [selectedCompanyId, setSelectedCompanyId] = useState<string>('');
  const filteredCompanies = companies.filter(c =>
    c.name.toLowerCase().includes(companySearchTerm.toLowerCase())
  );
  const [locationMode, setLocationMode] = useState<"manual" | "auto">("manual");
  const [latitude, setLatitude] = useState<number | null>(null);
  const [longitude, setLongitude] = useState<number | null>(null);
  const [locationLoading, setLocationLoading] = useState(false);

  const { isLoaded } = useJsApiLoader({
    googleMapsApiKey: import.meta.env.VITE_GOOGLE_MAPS_API_KEY || "",
  });

  useEffect(() => {
    if (registrationMode === 'existing' && companies.length === 0) {
      const fetchCompanies = async () => {
        setIsLoadingCompanies(true);
        try {
          const response = await adminApi.getAllCompanies();
          if (response.success && response.data) {
            setCompanies(response.data);
          }
        } catch (error) {
          console.error('Failed to fetch companies:', error);
          toast.error('Failed to load existing companies');
        } finally {
          setIsLoadingCompanies(false);
        }
      };
      fetchCompanies();
    }
  }, [registrationMode, companies.length]);

  const {
    register,
    handleSubmit,
    watch,
    formState: { errors },
  } = useForm({ mode: 'onBlur', shouldUnregister: true });

  const gstNumber = watch('gstNumber');
  const showGstCertificate = Boolean(gstNumber?.trim());

  const detectLocation = () => {
    setLocationLoading(true);
    navigator.geolocation.getCurrentPosition(
      (position) => {
        setLatitude(position.coords.latitude);
        setLongitude(position.coords.longitude);
        setLocationLoading(false);
        toast.success("Location detected");
      },
      () => {
        toast.error("Unable to get location");
        setLocationLoading(false);
      }
    );
  };

  const onSubmit = async (data: any) => {
    if (data.password !== data.confirmPassword) {
      toast.error('Passwords do not match');
      return;
    }
    if (registrationMode === 'new' && (!companyDocFile || !idProofFile)) {
      toast.error('Please upload all required documents');
      return;
    }
    if (registrationMode === 'new' && (latitude === null || longitude === null)) {
      toast.error('Please provide Latitude and Longitude');
      return;
    }
    if (registrationMode === 'new' && showGstCertificate && !gstCertFile) {
      toast.error('Please upload your GST certificate');
      return;
    }

    setIsSubmitting(true);
    try {
      let jsonPayload: any;
      if (registrationMode === 'new') {
        jsonPayload = {
          name: data.companyName,
          email: data.emailId,
          latitude: latitude,
          longitude: longitude,
          companyType: data.companyType || 'PRODUCTS_SERVICES',
          phoneNumber: {
            countryCode: data.countryCode || '+91',
            dialNumber: data.mobileNumber,
          },
          tax: (showGstCertificate && data.gstNumber) ? {
            taxType: 'GST',
            taxNumber: data.gstNumber,
          } : undefined,
          billingAddress: {
            addressLine1: data.businessAddress,
            city: data.city,
            state: data.state,
            zipCode: data.zipCode,
            country: data.country || 'India',
          },
          primaryContact: {
            name: data.authorizedPerson,
            email: data.emailId,
            isSameAsBilling: true,
            phoneNumber: {
              countryCode: data.countryCode || '+91',
              dialNumber: data.mobileNumber,
            },
          },
          password: data.password,
        };
      } else {
        if (!selectedCompanyId) {
          toast.error('Please select an existing company');
          setIsSubmitting(false);
          return;
        }
        let actualName = data.authorizedPerson;
        const selectedComp = companies.find(c => c._id === selectedCompanyId);
        if (selectedComp) {
          actualName = selectedComp.name;
        }
        jsonPayload = {
          companyId: selectedCompanyId,
          name: data.authorizedPerson,
          email: data.emailId,
          phoneNumber: {
            countryCode: data.countryCode || '+91',
            dialNumber: data.mobileNumber,
          },
          password: data.password,
          billingAddress: {
            addressLine1: data.businessAddress || "Company Headquarters",
            city: "Unknown",
            state: "Unknown",
            zipCode: "000000",
            country: "India"
          },
          tax: {
            taxType: 'GST',
            taxNumber: "00AAAAA0000A1Z0"
          },
          primaryContact: {
            name: data.authorizedPerson,
            email: data.emailId,
            phoneNumber: {
              countryCode: data.countryCode || '+91',
              dialNumber: data.mobileNumber
            }
          }
        };
      }

      const formData = new FormData();
      let actualCompanyName = data.companyName;
      if (registrationMode === 'existing' && selectedCompanyId) {
        const selectedComp = companies.find(c => c._id === selectedCompanyId);
        if (selectedComp) {
          actualCompanyName = selectedComp.name;
        }
      }
      const fullAddress = data.businessAddress
        ? `${data.businessAddress}${data.city ? `, ${data.city}` : ''}${data.state ? `, ${data.state}` : ''}`
        : (actualCompanyName || 'Joining Existing Company');

      if (registrationMode === 'existing' && selectedCompanyId) {
        formData.append('companyId', selectedCompanyId);
      }
      formData.append('companyName', actualCompanyName || '');
      formData.append('authorizedPerson', data.authorizedPerson);
      formData.append('businessAddress', fullAddress);
      if (showGstCertificate && data.gstNumber) formData.append('gstNumber', data.gstNumber);
      formData.append('mobileNumber', data.mobileNumber);
      formData.append('emailId', data.emailId);
      formData.append('password', data.password);
      formData.append('latitude', latitude?.toString() || '');
      formData.append('longitude', longitude?.toString() || '');
      if (gstCertFile) formData.append('gstCertificate', gstCertFile);
      if (companyDocFile) formData.append('companyRegistrationDoc', companyDocFile);
      if (idProofFile) formData.append('idProof', idProofFile);

      console.log('--- DUAL REGISTRATION START ---');
      console.log('JSON Payload:', jsonPayload);
      console.log('FormData:', Object.fromEntries(formData.entries()));
      console.log("Latitude:", latitude);
      console.log("Longitude:", longitude);

      const springBootRes = await adminApi.registerAdmin(formData);
      console.log('Spring Boot Response:', springBootRes);

      if (!springBootRes || (typeof springBootRes === 'object' && !springBootRes.success)) {
        toast.error(springBootRes?.message || 'Spring Boot registration failed');
        setIsSubmitting(false);
        return;
      }

      toast.success('Registration synchronized successfully');
      localStorage.setItem('registrationEmail', data.emailId);
      setTimeout(() => {
        navigate('/admin/status');
      }, 1500);
    } catch (error: any) {
      console.error('Dual Registration Error:', error);
      toast.error(error.message || 'An unexpected error occurred during synchronization');
    } finally {
      setIsSubmitting(false);
    }
  };

  const inputClass =
    'block w-full pl-10 px-4 py-3 bg-white dark:bg-[#1C1F26] border border-gray-200 dark:border-gray-800 rounded-xl text-gray-900 dark:text-white placeholder-gray-400 focus:ring-2 focus:ring-brand-500 focus:border-brand-500 transition-colors shadow-sm text-sm';
  const errorClass = 'text-xs text-red-500 mt-1 font-medium';
  const labelClass = 'block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1.5';

  const FileDropZone = ({
    label,
    file,
    onChange,
    accept = '.pdf,.jpg,.jpeg,.png',
    required = false,
    hint,
  }: {
    label: string;
    file: File | null;
    onChange: (f: File | null) => void;
    accept?: string;
    required?: boolean;
    hint?: string;
  }) => (
    <div>
      <label className={labelClass}>
        {label} {required && <span className="text-red-500">*</span>}
      </label>
      <label className="group flex flex-col items-center justify-center w-full h-28 border-2 border-dashed border-gray-200 dark:border-gray-700 rounded-xl cursor-pointer bg-gray-50 dark:bg-[#1C1F26] hover:border-brand-400 hover:bg-brand-50/30 dark:hover:border-brand-500 transition-all">
        <div className="flex flex-col items-center gap-1.5 text-center px-4">
          {file ? (
            <>
              <FileText className="w-6 h-6 text-brand-500" />
              <p className="text-sm font-semibold text-brand-600 dark:text-brand-400 truncate max-w-[200px]">{file.name}</p>
              <p className="text-xs text-gray-400">Click to change</p>
            </>
          ) : (
            <>
              <Upload className="w-6 h-6 text-gray-400 group-hover:text-brand-500 transition-colors" />
              <p className="text-sm font-medium text-gray-500 dark:text-gray-400">
                <span className="text-brand-500 font-semibold">Click to upload</span> or drag & drop
              </p>
              <p className="text-xs text-gray-400">{hint || 'PDF, JPG, PNG accepted'}</p>
            </>
          )}
        </div>
        <input
          type="file"
          accept={accept}
          className="hidden"
          onChange={(e) => onChange(e.target.files?.[0] ?? null)}
        />
      </label>
    </div>
  );

  return (
    <div className="flex min-h-screen bg-gray-50 md:bg-white dark:bg-[#0E1117]">
      <Toaster position="top-right" />

      {/* ── Left Panel ── */}
      <div className="hidden lg:flex lg:w-5/12 relative bg-gradient-to-br from-brand-500 via-brand-600 to-brand-700 overflow-hidden text-white p-12 flex-col justify-between">
        <div className="absolute top-[-10%] right-[-10%] w-96 h-96 bg-brand-400 rounded-full blur-[100px] opacity-60" />
        <div className="absolute bottom-[-10%] left-[-10%] w-[30rem] h-[30rem] bg-brand-800 rounded-full blur-[120px] opacity-60" />

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

          <div className="mt-16 max-w-xl">
            <h2 className="text-4xl font-bold leading-tight mb-5 tracking-tight">
              Manage Your Advertising<br />Network From One<br />Unified Dashboard
            </h2>
            <p className="text-brand-100 text-lg font-medium leading-relaxed mb-10">
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
      <div className="w-full lg:w-7/12 flex items-start justify-center p-6 sm:p-10 lg:p-14 overflow-y-auto bg-gray-50 dark:bg-[#0E1117] transition-colors">
        <div className="w-full max-w-2xl">

          {/* Mobile Logo */}
          <div className="flex lg:hidden items-center gap-3 mb-8">
            <div className="w-10 h-10 bg-white/50 backdrop-blur rounded-xl flex items-center justify-center p-1.5 overflow-hidden shadow-lg">
              <img src={icon} alt="KELIRI" className="w-full h-full object-contain" />
            </div>
            <div>
              <h1 className="font-bold text-lg text-gray-900 dark:text-white leading-tight tracking-wide">keliri</h1>
              <p className="text-[10px] uppercase font-semibold text-brand-500 tracking-wider">Admin Panel</p>
            </div>
          </div>

          <div className="mb-8">
            <h2 className="text-3xl font-bold text-gray-900 dark:text-white mb-1">Create your account</h2>
            <p className="text-gray-500 dark:text-gray-400">Register your business to get started with KELIRI Admin</p>
          </div>

          <form onSubmit={handleSubmit(onSubmit)} className="space-y-8">

            {/* ── Registration Mode Toggle ── */}
            <div className="flex bg-gray-100 dark:bg-[#1C1F26] p-1.5 rounded-xl">
              <button
                type="button"
                onClick={() => setRegistrationMode('new')}
                className={`flex-1 py-2.5 text-sm font-semibold rounded-lg transition-all ${registrationMode === 'new'
                  ? 'bg-white dark:bg-[#2C313C] text-brand-600 shadow-sm'
                  : 'text-gray-500 hover:text-gray-700 dark:text-gray-400 dark:hover:text-gray-200'
                  }`}
              >
                Register New Company
              </button>
              <button
                type="button"
                onClick={() => setRegistrationMode('existing')}
                className={`flex-1 py-2.5 text-sm font-semibold rounded-lg transition-all ${registrationMode === 'existing'
                  ? 'bg-white dark:bg-[#2C313C] text-brand-600 shadow-sm'
                  : 'text-gray-500 hover:text-gray-700 dark:text-gray-400 dark:hover:text-gray-200'
                  }`}
              >
                Join Existing Company
              </button>
            </div>

            {/* ── Existing Company Selection ── */}
            {registrationMode === 'existing' && (
              <div>
                <h3 className="text-xs font-black uppercase tracking-widest text-gray-400 dark:text-gray-500 mb-5 pb-3 border-b border-gray-100 dark:border-gray-800">
                  Select Company
                </h3>
                <div className="relative mb-4">
                  <span className="absolute inset-y-0 left-0 flex items-center pl-3 pointer-events-none">
                    <Search className="h-5 w-5 text-gray-400" aria-hidden="true" />
                  </span>
                  <input
                    type="text"
                    placeholder="Search companies by name..."
                    value={companySearchTerm}
                    onChange={(e) => setCompanySearchTerm(e.target.value)}
                    className="block w-full pl-10 pr-4 py-2.5 text-sm border border-gray-200 dark:border-gray-800 rounded-xl bg-gray-50 dark:bg-[#1C1F26] text-gray-900 dark:text-white placeholder-gray-400 focus:outline-none focus:ring-2 focus:ring-brand-500 focus:border-brand-500 transition-colors"
                  />
                </div>
                {isLoadingCompanies ? (
                  <div className="flex items-center gap-2 text-sm text-gray-500 p-4 border border-gray-200 dark:border-gray-800 rounded-xl bg-gray-50 dark:bg-[#1C1F26]">
                    <Loader2 className="w-4 h-4 animate-spin text-brand-500" /> Loading companies...
                  </div>
                ) : (
                  <div className="space-y-2 max-h-60 overflow-y-auto pr-2 border border-gray-200 dark:border-gray-800 rounded-xl p-2 bg-gray-50 dark:bg-[#1C1F26]">
                    {filteredCompanies.length === 0 ? (
                      <div className="p-4 text-sm text-center text-gray-500">
                        {companies.length === 0 ? "No companies found." : "No matching companies found."}
                      </div>
                    ) : (
                      filteredCompanies.map((company) => (
                        <div
                          key={company._id}
                          onClick={() => setSelectedCompanyId(company._id)}
                          className={`flex items-center gap-3 p-3 rounded-lg cursor-pointer transition-all ${selectedCompanyId === company._id
                            ? 'bg-brand-50 border-brand-200 dark:bg-brand-900/20 dark:border-brand-500/30 border'
                            : 'hover:bg-gray-100 dark:hover:bg-[#2C313C] border border-transparent'
                            }`}
                        >
                          {company.companyLogo ? (
                            <img src={typeof company.companyLogo === 'string' ? company.companyLogo : company.companyLogo.url} alt={company.name} className="w-10 h-10 rounded-lg object-cover bg-white" />
                          ) : (
                            <div className="w-10 h-10 rounded-lg bg-brand-100 dark:bg-brand-900 flex items-center justify-center text-brand-600 font-bold text-lg">
                              {company.name.charAt(0)}
                            </div>
                          )}
                          <div className="flex-1">
                            <h4 className="font-semibold text-gray-900 dark:text-white text-sm">{company.name}</h4>
                            {company.companyType && <p className="text-xs text-gray-500 uppercase">{company.companyType.replace('_', ' ')}</p>}
                          </div>
                          <div className={`w-5 h-5 rounded-full border flex items-center justify-center ${selectedCompanyId === company._id ? 'border-brand-500 bg-brand-500' : 'border-gray-300 dark:border-gray-600'
                            }`}>
                            {selectedCompanyId === company._id && <div className="w-2 h-2 bg-white rounded-full" />}
                          </div>
                        </div>
                      ))
                    )}
                  </div>
                )}
              </div>
            )}

            {/* ── Company Information ── */}
            {registrationMode === 'new' && (
              <div>
                <h3 className="text-xs font-black uppercase tracking-widest text-gray-400 dark:text-gray-500 mb-5 pb-3 border-b border-gray-100 dark:border-gray-800">
                  Company Information
                </h3>
                <div className="grid grid-cols-1 md:grid-cols-2 gap-5">

                  <div>
                    <label className={labelClass}>Company Name <span className="text-red-500">*</span></label>
                    <div className="relative">
                      <div className="absolute inset-y-0 left-0 pl-3.5 flex items-center pointer-events-none text-gray-400">
                        <Building2 className="w-[18px] h-[18px]" />
                      </div>
                      <input
                        {...register('companyName', { required: 'Company name is required' })}
                        type="text"
                        placeholder="Your company name"
                        className={inputClass}
                      />
                    </div>
                    {errors.companyName && <p className={errorClass}>{errors.companyName.message as string}</p>}
                  </div>

                  <div>
                    <label className={labelClass}>Company Type <span className="text-red-500">*</span></label>
                    <div className="relative">
                      <div className="absolute inset-y-0 left-0 pl-3.5 flex items-center pointer-events-none text-gray-400">
                        <Building2 className="w-[18px] h-[18px]" />
                      </div>
                      <select
                        {...register('companyType', { required: 'Company type is required' })}
                        className={`${inputClass} appearance-none`}
                      >
                        <option value="">Select Type</option>
                        <option value="PRODUCTS_SERVICES">Products & Services</option>
                        <option value="PRODUCTS_SERVICES">Publisher</option>
                      </select>
                    </div>
                    {errors.companyType && <p className={errorClass}>{errors.companyType.message as string}</p>}
                  </div>

                  <div className="md:col-span-2">
                    <label className={labelClass}>Business Address <span className="text-red-500">*</span></label>
                    <div className="grid gap-3">
                      <div className="flex bg-gray-100 p-1 rounded-lg mb-3 w-72 mx-auto">
                        <button
                          type="button"
                          onClick={() => setLocationMode("manual")}
                          className={`flex-1 py-2 text-sm font-medium rounded-md transition-all ${locationMode === "manual" ? "bg-white shadow" : ""}`}
                        >
                          Manual Entry
                        </button>
                        <button
                          type="button"
                          onClick={() => { setLocationMode("auto"); detectLocation(); }}
                          className={`flex-1 py-2 text-sm font-medium rounded-md transition-all ${locationMode === "auto" ? "bg-white shadow" : ""}`}
                        >
                          Auto Detect
                        </button>
                      </div>

                      {(locationMode === "auto" || locationMode === "manual") && (
                        <>
                          <div className="grid grid-cols-2 gap-4 mb-4">
                            <div>
                              <label className={labelClass}>Latitude <span className="text-red-500">*</span></label>
                              <input
                                type="number"
                                step="any"
                                value={latitude ?? ""}
                                onChange={(e) => setLatitude(Number(e.target.value))}
                                placeholder="Enter Latitude"
                                className={`${inputClass} px-4`}
                                readOnly={locationMode === "auto"}
                              />
                            </div>
                            <div>
                              <label className={labelClass}>Longitude <span className="text-red-500">*</span></label>
                              <input
                                type="number"
                                step="any"
                                value={longitude ?? ""}
                                onChange={(e) => setLongitude(Number(e.target.value))}
                                placeholder="Enter Longitude"
                                className={`${inputClass} px-4`}
                                readOnly={locationMode === "auto"}
                              />
                            </div>
                          </div>

                          {latitude && longitude && (
                            <div className="overflow-hidden rounded-xl border border-gray-200 mb-4">
                              {isLoaded && (
                                <GoogleMap
                                  mapContainerStyle={{ height: "400px", width: "100%" }}
                                  center={{ lat: latitude, lng: longitude }}
                                  zoom={12}
                                  options={{
                                    streetViewControl: false,
                                    mapTypeControl: false,
                                    fullscreenControl: false,
                                  }}
                                >
                                  <Marker position={{ lat: latitude, lng: longitude }} />
                                  <Circle
                                    center={{ lat: latitude, lng: longitude }}
                                    radius={10000}
                                    options={{ fillOpacity: 0.2, strokeWeight: 2 }}
                                  />
                                </GoogleMap>
                              )}
                            </div>
                          )}
                        </>
                      )}

                      <div className="relative">
                        <div className="absolute inset-y-0 left-0 pl-3.5 flex items-center pointer-events-none text-gray-400">
                          <MapPinned className="w-[18px] h-[18px]" />
                        </div>
                        <input
                          {...register('businessAddress', { required: 'Address Line 1 is required' })}
                          type="text"
                          placeholder="Address Line 1"
                          className={inputClass}
                        />
                      </div>
                      {errors.businessAddress && <p className={errorClass}>{errors.businessAddress.message as string}</p>}

                      <div className="relative">
                        <div className="absolute inset-y-0 left-0 pl-3.5 flex items-center pointer-events-none text-gray-400">
                          <MapPinned className="w-[18px] h-[18px]" />
                        </div>
                        <input
                          {...register('addressLine2')}
                          type="text"
                          placeholder="Address Line 2 (Optional)"
                          className={inputClass}
                        />
                      </div>

                      <div className="grid grid-cols-2 gap-3">
                        <div>
                          <input {...register('city', { required: 'City is required' })} type="text" placeholder="City" className={`${inputClass} px-4`} />
                          {errors.city && <p className={errorClass}>{errors.city.message as string}</p>}
                        </div>
                        <div>
                          <input {...register('state', { required: 'State is required' })} type="text" placeholder="State" className={`${inputClass} px-4`} />
                          {errors.state && <p className={errorClass}>{errors.state.message as string}</p>}
                        </div>
                      </div>

                      <div className="grid grid-cols-2 gap-3">
                        <div>
                          <input {...register('zipCode', { required: 'Zip Code is required' })} type="text" placeholder="Zip/Postal Code" className={`${inputClass} px-4`} />
                          {errors.zipCode && <p className={errorClass}>{errors.zipCode.message as string}</p>}
                        </div>
                        <div>
                          <input {...register('country', { required: 'Country is required' })} type="text" defaultValue="India" placeholder="Country" className={`${inputClass} px-4`} />
                          {errors.country && <p className={errorClass}>{errors.country.message as string}</p>}
                        </div>
                      </div>
                    </div>
                  </div>

                  <div className={showGstCertificate ? '' : 'md:col-span-2'}>
                    <label className={labelClass}>GST Number <span className="text-gray-400 font-normal text-xs">(Optional)</span></label>
                    <div className="relative">
                      <div className="absolute inset-y-0 left-0 pl-3.5 flex items-center pointer-events-none text-gray-400">
                        <FileText className="w-[18px] h-[18px]" />
                      </div>
                      <input {...register('gstNumber')} type="text" placeholder="e.g. 27AAPCS1234C1ZV" className={inputClass} />
                    </div>
                    <p className="text-xs text-gray-400 mt-1">GST certificate upload will appear if you enter a number</p>
                  </div>

                  {showGstCertificate && (
                    <motion.div initial={{ opacity: 0, y: -8 }} animate={{ opacity: 1, y: 0 }}>
                      <FileDropZone
                        label="GST Certificate"
                        file={gstCertFile}
                        onChange={setGstCertFile}
                        required={showGstCertificate}
                        hint="PDF, JPG, PNG — max 5MB"
                      />
                    </motion.div>
                  )}
                </div>
              </div>
            )}

            {/* ── Contact Information ── */}
            <div>
              <h3 className="text-xs font-black uppercase tracking-widest text-gray-400 dark:text-gray-500 mb-5 pb-3 border-b border-gray-100 dark:border-gray-800">
                Contact Information
              </h3>
              <div className="grid grid-cols-1 md:grid-cols-2 gap-5">

                <div className="md:col-span-2">
                  <label className={labelClass}>Authorized Person Name <span className="text-red-500">*</span></label>
                  <div className="relative">
                    <div className="absolute inset-y-0 left-0 pl-3.5 flex items-center pointer-events-none text-gray-400">
                      <User className="w-[18px] h-[18px]" />
                    </div>
                    <input
                      {...register('authorizedPerson', { required: 'Authorized person name is required' })}
                      type="text"
                      placeholder="Enter your full name"
                      className={inputClass}
                    />
                  </div>
                  {errors.authorizedPerson && <p className={errorClass}>{errors.authorizedPerson.message as string}</p>}
                </div>

                <div>
                  <label className={labelClass}>Mobile Number <span className="text-red-500">*</span></label>
                  <div className="flex relative">
                    <select
                      {...register('countryCode')}
                      className="block w-24 pl-3 pr-2 py-3 bg-white dark:bg-[#1C1F26] border border-gray-200 dark:border-gray-800 rounded-l-xl text-gray-900 dark:text-white placeholder-gray-400 focus:ring-2 focus:ring-brand-500 focus:border-brand-500 transition-colors shadow-sm text-sm"
                      defaultValue="+91"
                    >
                      <option value="+91">+91</option>
                      <option value="+1">+1</option>
                      <option value="+44">+44</option>
                    </select>
                    <div className="absolute inset-y-0 left-24 pl-3 flex items-center pointer-events-none text-gray-400">
                      <Phone className="w-[18px] h-[18px]" />
                    </div>
                    <input
                      {...register('mobileNumber', {
                        required: 'Mobile number is required',
                        pattern: { value: /^\d{10}$/, message: 'Enter a valid 10-digit mobile number' },
                      })}
                      type="tel"
                      placeholder="10-digit mobile number"
                      className={`${inputClass} rounded-l-none pl-10 border-l-0`}
                    />
                  </div>
                  {errors.mobileNumber && <p className={errorClass}>{errors.mobileNumber.message as string}</p>}
                </div>

                <div>
                  <label className={labelClass}>Email ID <span className="text-red-500">*</span></label>
                  <div className="relative">
                    <div className="absolute inset-y-0 left-0 pl-3.5 flex items-center pointer-events-none text-gray-400">
                      <Mail className="w-[18px] h-[18px]" />
                    </div>
                    <input
                      {...register('emailId', {
                        required: 'Email is required',
                        pattern: { value: /^[^\s@]+@[^\s@]+\.[^\s@]+$/, message: 'Enter a valid email address' },
                      })}
                      type="email"
                      placeholder="business@example.com"
                      className={inputClass}
                    />
                  </div>
                  {errors.emailId && <p className={errorClass}>{errors.emailId.message as string}</p>}
                </div>

                <div>
                  <label className={labelClass}>Password <span className="text-red-500">*</span></label>
                  <div className="relative">
                    <div className="absolute inset-y-0 left-0 pl-3.5 flex items-center pointer-events-none text-gray-400">
                      <Lock className="w-[18px] h-[18px]" />
                    </div>
                    <input
                      {...register('password', {
                        required: 'Password is required',
                        minLength: { value: 8, message: 'Password must be at least 8 characters' }
                      })}
                      type={showPassword ? 'text' : 'password'}
                      placeholder="••••••••"
                      className={inputClass}
                    />
                    <button type="button" onClick={() => setShowPassword(!showPassword)} className="absolute inset-y-0 right-0 pr-3.5 flex items-center text-gray-400 hover:text-gray-600 focus:outline-none">
                      {showPassword ? <EyeOff className="w-5 h-5" /> : <Eye className="w-5 h-5" />}
                    </button>
                  </div>
                  {errors.password && <p className={errorClass}>{errors.password.message as string}</p>}
                </div>

                <div>
                  <label className={labelClass}>Confirm Password <span className="text-red-500">*</span></label>
                  <div className="relative">
                    <div className="absolute inset-y-0 left-0 pl-3.5 flex items-center pointer-events-none text-gray-400">
                      <Lock className="w-[18px] h-[18px]" />
                    </div>
                    <input
                      {...register('confirmPassword', { required: 'Please confirm your password' })}
                      type={showConfirmPassword ? 'text' : 'password'}
                      placeholder="••••••••"
                      className={inputClass}
                    />
                    <button type="button" onClick={() => setShowConfirmPassword(!showConfirmPassword)} className="absolute inset-y-0 right-0 pr-3.5 flex items-center text-gray-400 hover:text-gray-600 focus:outline-none">
                      {showConfirmPassword ? <EyeOff className="w-5 h-5" /> : <Eye className="w-5 h-5" />}
                    </button>
                  </div>
                  {errors.confirmPassword && <p className={errorClass}>{errors.confirmPassword.message as string}</p>}
                </div>
              </div>
            </div>

            {/* ── Document Uploads ── */}
            <div>
              <h3 className="text-xs font-black uppercase tracking-widest text-gray-400 dark:text-gray-500 mb-5 pb-3 border-b border-gray-100 dark:border-gray-800">
                Document Uploads
              </h3>
              <div className="grid grid-cols-1 md:grid-cols-2 gap-5">
                <FileDropZone
                  label="Company Registration Document"
                  file={companyDocFile}
                  onChange={setCompanyDocFile}
                  required
                  hint="Certificate of incorporation or equivalent"
                />
                <FileDropZone
                  label="ID Proof"
                  file={idProofFile}
                  onChange={setIdProofFile}
                  required
                  hint="Aadhaar, Passport, or Driving License"
                />
              </div>
            </div>

            {/* ── Submit ── */}
            <button
              type="submit"
              disabled={isSubmitting}
              className="w-full flex items-center justify-center gap-2 py-3.5 px-4 bg-brand-500 hover:bg-brand-600 text-white font-semibold rounded-xl shadow-lg shadow-brand-500/20 transition-all disabled:opacity-70 disabled:cursor-not-allowed"
            >
              {isSubmitting ? (
                <><Loader2 className="w-5 h-5 animate-spin" /> Submitting...</>
              ) : (
                <>Register <ArrowRight className="w-[18px] h-[18px]" /></>
              )}
            </button>
          </form>

          <div className="mt-8 text-center">
            <p className="text-sm text-gray-500 dark:text-gray-400">
              Already have an account?{' '}
              <a href="/admin/login" className="text-brand-600 dark:text-brand-400 font-semibold hover:underline">
                Sign in
              </a>
            </p>
          </div>

          <div className="mt-6 flex items-center justify-center gap-1.5 text-xs text-gray-500 dark:text-gray-400">
            Protected by <span className="font-semibold text-gray-700 dark:text-gray-300">KELIRI Security</span>
            <span>·</span>
            Role-based access control
          </div>
        </div>
      </div>
    </div>
  );
}