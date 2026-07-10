import React, { useState } from 'react';
import { createPortal } from 'react-dom';
import { GoogleMap, Marker, Circle, useJsApiLoader } from '@react-google-maps/api';
import {
  Building2,
  MapPin,
  MapPinned,
  FileText,
  User,
  Phone,
  Mail,
  Lock,
  Eye,
  EyeOff,
  Upload,
  ArrowRight,
  Loader2,
  X
} from 'lucide-react';
import { createAdminRecord } from '../../lib/management';
import toast from 'react-hot-toast';

const CreateAdminModal = ({ isOpen, onClose, onSuccess }) => {
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [showPassword, setShowPassword] = useState(false);
  const [showConfirmPassword, setShowConfirmPassword] = useState(false);
  const [latitude, setLatitude] = useState(null);
  const [longitude, setLongitude] = useState(null);
  const [locationLoading, setLocationLoading] = useState(false);
  const { isLoaded } = useJsApiLoader({
    googleMapsApiKey: import.meta.env.VITE_GOOGLE_MAPS_API_KEY || "",
  });

  // Form states
  const [formData, setFormData] = useState({
    companyName: '',
    companyType: '',
    businessAddress: '',
    addressLine2: '',
    city: '',
    state: '',
    zipCode: '',
    country: 'India',
    gstNumber: '',
    authorizedPerson: '',
    countryCode: '+91',
    mobileNumber: '',
    emailId: '',
    password: '',
    confirmPassword: ''
  });

  const [gstCertFile, setGstCertFile] = useState(null);
  const [companyDocFile, setCompanyDocFile] = useState(null);
  const [idProofFile, setIdProofFile] = useState(null);

  if (!isOpen) return null;

  const handleChange = (e) => {
    const { name, value } = e.target;
    setFormData((prev) => ({ ...prev, [name]: value }));
  };

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

  const handleFileChange = (setter) => (e) => {
    setter(e.target.files?.[0] ?? null);
  };

  const showGstCertificate = Boolean(formData.gstNumber?.trim());

  const handleSubmit = async (e) => {
    e.preventDefault();

    if (formData.password && formData.password !== formData.confirmPassword) {
      toast.error('Passwords do not match');
      return;
    }

    setIsSubmitting(true);
    try {
      // 1. Build JSON Payload for Ad Mobile (EC2)
      const jsonPayload = {
        name: formData.companyName || "Company_" + Date.now(),
        email: formData.emailId || "temp_" + Date.now() + "@example.com",
        companyType: formData.companyType || 'PRODUCTS_SERVICES',
        phoneNumber: {
          countryCode: formData.countryCode || '+91',
          dialNumber: formData.mobileNumber,
        },
        billingAddress: {
          addressLine1: formData.businessAddress || '',
          city: formData.city || '',
          state: formData.state || '',
          zipCode: formData.zipCode || '',
          country: formData.country || 'India',
        },
        primaryContact: {
          name: formData.authorizedPerson || '',
          email: formData.emailId || '',
          isSameAsBilling: true,
          phoneNumber: {
            countryCode: formData.countryCode || '+91',
            dialNumber: formData.mobileNumber,
          },
        },
        password: formData.password || '',
        latitude: latitude,
        longitude: longitude,
      };

      if (formData.gstNumber) {
        jsonPayload.tax = {
          taxType: 'GST',
          taxNumber: formData.gstNumber,
        };
      }

      // 2. Build FormData Payload for Spring Boot (Local)
      const formPayload = new FormData();
      const fullAddress = formData.businessAddress
        ? `${formData.businessAddress}${formData.city ? `, ${formData.city}` : ''}${formData.state ? `, ${formData.state}` : ''}`
        : (formData.companyName || 'New Company');

      formPayload.append('companyName', formData.companyName || '');
      formPayload.append('authorizedPerson', formData.authorizedPerson || '');
      formPayload.append('businessAddress', fullAddress);
      if (formData.gstNumber) formPayload.append('gstNumber', formData.gstNumber);
      formPayload.append('mobileNumber', formData.mobileNumber || '');
      formPayload.append('countryCode', formData.countryCode || '+91');
      formPayload.append('emailId', formData.emailId || '');
      formPayload.append('password', formData.password || '');
      formPayload.append('latitude', latitude?.toString() || '');
      formPayload.append('longitude', longitude?.toString() || '');

      // Add files if they exist
      if (gstCertFile) formPayload.append('gstCertificate', gstCertFile);
      if (companyDocFile) formPayload.append('companyRegistrationDoc', companyDocFile);
      if (idProofFile) formPayload.append('idProof', idProofFile);
      for (const [key, value] of formPayload.entries()) {
        console.log(key, value);
      }

      await createAdminRecord(formPayload, jsonPayload);

      toast.success('Admin account created successfully');
      onSuccess();
      onClose();
    } catch (err) {
      console.error(err);
      toast.error(err.message || 'Failed to create admin');
    } finally {
      setIsSubmitting(false);
    }
  };

  const inputClass =
    'block w-full pl-10 pr-4 py-2.5 bg-gray-50 border border-gray-100 rounded-xl text-gray-900 placeholder-gray-400 focus:outline-none focus:ring-2 focus:ring-primary-500/20 focus:border-primary-500 transition-all text-sm shadow-sm';

  const selectClass =
    'block w-full pl-10 pr-10 py-2.5 bg-gray-50 border border-gray-100 rounded-xl text-gray-900 focus:outline-none focus:ring-2 focus:ring-primary-500/20 focus:border-primary-500 transition-all text-sm shadow-sm cursor-pointer appearance-none';

  const labelClass = 'block text-xs font-bold text-gray-500 dark:text-gray-400 mb-1.5';

  const FileDropZone = ({ label, file, onChange, hint, required }) => (
    <div className="space-y-2">
      <label className={labelClass}>{label}</label>
      <label className="group flex flex-col items-center justify-center w-full h-28 border-2 border-dashed border-gray-200 dark:border-gray-700 rounded-xl cursor-pointer bg-gray-50 dark:bg-[#1C1F26] hover:border-primary-400 hover:bg-primary-50/30 transition-all">
        <div className="flex flex-col items-center gap-1.5 text-center px-4">
          {file ? (
            <>
              <FileText className="w-6 h-6 text-primary-500" />
              <p className="text-xs font-bold text-primary-600 truncate max-w-[200px]">{file.name}</p>
              <p className="text-[10px] text-gray-400 uppercase font-black tracking-wider">Click to change</p>
            </>
          ) : (
            <>
              <Upload className="w-6 h-6 text-gray-400 group-hover:text-primary-500 transition-colors" />
              <p className="text-xs font-semibold text-gray-500">
                <span className="text-primary-500 font-bold">Click to upload</span> or drag & drop
              </p>
              <p className="text-[10px] text-gray-400 font-medium">{hint}</p>
            </>
          )}
        </div>
        <input
          type="file"
          accept=".pdf,.jpg,.jpeg,.png"
          className="hidden"
          onChange={onChange}
          required={required}
        />
      </label>
    </div>
  );

  return createPortal(
    <div className="fixed inset-0 z-[9999] flex items-center justify-center p-4">
      <div
        className="absolute inset-0 bg-gray-900/60 backdrop-blur-md animate-fade-in"
        onClick={onClose}
      />

      <div className="relative w-full max-w-2xl max-h-[90vh] bg-white rounded-[2.5rem] shadow-2xl flex flex-col overflow-hidden animate-fade-in-scale">

        <div className="flex items-center justify-between px-8 py-6 border-b border-gray-100 bg-white sticky top-0 z-10">
          <div>
            <h2 className="text-2xl font-black text-gray-900 tracking-tight">Create Admin</h2>
            <p className="text-xs font-medium text-gray-400 mt-1">Register a new administrator into the ecosystem</p>
          </div>
          <button
            onClick={onClose}
            className="p-2.5 rounded-2xl bg-gray-100 text-gray-400 hover:bg-gray-200 hover:text-gray-900 transition-all active:scale-90"
          >
            <X size={20} />
          </button>
        </div>

        <form onSubmit={handleSubmit} className="flex-1 overflow-y-auto p-8 space-y-8 custom-scrollbar bg-white">

          <div className="space-y-5">
            <h3 className="text-[10px] font-black uppercase tracking-widest text-gray-400 pb-2 border-b border-gray-100">
              Company Information
            </h3>

            <div className="grid grid-cols-1 md:grid-cols-2 gap-5">
              <div>
                <label className={labelClass}>Company Name</label>
                <div className="relative">
                  <div className="absolute inset-y-0 left-0 pl-3.5 flex items-center pointer-events-none text-gray-400">
                    <Building2 className="w-[18px] h-[18px]" />
                  </div>
                  <input
                    type="text"
                    name="companyName"
                    value={formData.companyName}
                    onChange={handleChange}
                    placeholder="Your company name"
                    className={inputClass}
                  />
                </div>
              </div>

              <div>
                <label className={labelClass}>Company Type</label>
                <div className="relative group">
                  <div className="absolute inset-y-0 left-0 pl-3.5 flex items-center pointer-events-none text-gray-400">
                    <Building2 className="w-[18px] h-[18px]" />
                  </div>
                  <select
                    name="companyType"
                    value={formData.companyType}
                    onChange={handleChange}
                    className={selectClass}
                  >
                    <option value="">Select Type</option>
                    <option value="PRODUCTS_SERVICES">Products & Services</option>
                    <option value="PUBLISHER">Publisher</option>
                  </select>
                  <div className="absolute right-3.5 top-1/2 -translate-y-1/2 text-gray-400 pointer-events-none group-hover:text-gray-600 transition-colors">
                    <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M19 9l-7 7-7-7" />
                    </svg>
                  </div>
                </div>
              </div>

              <div className="md:col-span-2 space-y-3">
                <label className={labelClass}>Business Address</label>

                <div className="relative">
                  <div className="absolute inset-y-0 left-0 pl-3.5 flex items-center pointer-events-none text-gray-400">
                    <MapPinned className="w-[18px] h-[18px]" />
                  </div>
                  <input
                    type="text"
                    name="businessAddress"
                    value={formData.businessAddress}
                    onChange={handleChange}
                    placeholder="Address Line 1"
                    className={inputClass}
                  />
                </div>

                <div className="relative">
                  <div className="absolute inset-y-0 left-0 pl-3.5 flex items-center pointer-events-none text-gray-400">
                    <MapPinned className="w-[18px] h-[18px]" />
                  </div>
                  <input
                    type="text"
                    name="addressLine2"
                    value={formData.addressLine2}
                    onChange={handleChange}
                    placeholder="Address Line 2 (Optional)"
                    className={inputClass}
                  />
                </div>

                <div className="grid grid-cols-2 gap-4">
                  <input
                    type="text"
                    name="city"
                    value={formData.city}
                    onChange={handleChange}
                    placeholder="City"
                    className="block w-full px-4 py-2.5 bg-gray-50 border border-gray-100 rounded-xl text-gray-900 placeholder-gray-400 focus:outline-none focus:ring-2 focus:ring-primary-500/20 focus:border-primary-500 transition-all text-sm shadow-sm"
                  />
                  <input
                    type="text"
                    name="state"
                    value={formData.state}
                    onChange={handleChange}
                    placeholder="State"
                    className="block w-full px-4 py-2.5 bg-gray-50 border border-gray-100 rounded-xl text-gray-900 placeholder-gray-400 focus:outline-none focus:ring-2 focus:ring-primary-500/20 focus:border-primary-500 transition-all text-sm shadow-sm"
                  />
                </div>

                <div className="grid grid-cols-2 gap-4">
                  <input
                    type="text"
                    name="zipCode"
                    value={formData.zipCode}
                    onChange={handleChange}
                    placeholder="Zip/Postal Code"
                    className="block w-full px-4 py-2.5 bg-gray-50 border border-gray-100 rounded-xl text-gray-900 placeholder-gray-400 focus:outline-none focus:ring-2 focus:ring-primary-500/20 focus:border-primary-500 transition-all text-sm shadow-sm"
                  />
                  <input
                    type="text"
                    name="country"
                    value={formData.country}
                    onChange={handleChange}
                    placeholder="Country"
                    className="block w-full px-4 py-2.5 bg-gray-50 border border-gray-100 rounded-xl text-gray-900 placeholder-gray-400 focus:outline-none focus:ring-2 focus:ring-primary-500/20 focus:border-primary-500 transition-all text-sm shadow-sm"
                  />
                </div>
              </div>

              <div className={showGstCertificate ? 'md:col-span-1' : 'md:col-span-2'}>
                <label className={labelClass}>GST Number <span className="text-gray-400 font-normal">(Optional)</span></label>
                <div className="relative">
                  <div className="absolute inset-y-0 left-0 pl-3.5 flex items-center pointer-events-none text-gray-400">
                    <FileText className="w-[18px] h-[18px]" />
                  </div>
                  <input
                    type="text"
                    name="gstNumber"
                    value={formData.gstNumber}
                    onChange={handleChange}
                    placeholder="e.g. 27AAPCS1234C1ZV"
                    className={inputClass}
                  />
                </div>
                <p className="text-[10px] text-gray-400 mt-1.5 font-semibold">GST certificate upload will appear if you enter a number</p>
              </div>

              {showGstCertificate && (
                <div className="animate-fade-in">
                  <FileDropZone
                    label="GST Certificate"
                    file={gstCertFile}
                    onChange={handleFileChange(setGstCertFile)}
                    required={showGstCertificate}
                    hint="PDF, JPG, PNG — max 5MB"
                  />
                </div>
              )}
            </div>

            {/* Location Section */}
            <div className="space-y-4 mt-5">
              <h3 className="text-xs font-black uppercase tracking-wider text-gray-400 dark:text-gray-500 mb-2">
                Location
              </h3>
              <div className="grid grid-cols-2 gap-4">
                <div>
                  <label className={labelClass}>Latitude <span className="text-red-500">*</span></label>
                  <input
                    type="number"
                    step="any"
                    value={latitude ?? ''}
                    onChange={(e) => setLatitude(Number(e.target.value))}
                    placeholder="Enter Latitude"
                    className={`${inputClass} px-4`}
                  />
                </div>
                <div>
                  <label className={labelClass}>Longitude <span className="text-red-500">*</span></label>
                  <input
                    type="number"
                    step="any"
                    value={longitude ?? ''}
                    onChange={(e) => setLongitude(Number(e.target.value))}
                    placeholder="Enter Longitude"
                    className={`${inputClass} px-4`}
                  />
                </div>
              </div>
              <button
                type="button"
                onClick={detectLocation}
                disabled={locationLoading}
                className="mt-2 px-4 py-2 bg-primary-500 hover:bg-primary-600 text-white rounded-xl text-sm"
              >
                {locationLoading ? 'Detecting…' : 'Detect Current Location'}
              </button>
              {latitude && longitude && isLoaded && (
                <div className="mt-4 rounded-xl overflow-hidden border border-gray-200">
                  <GoogleMap
                    mapContainerStyle={{ height: '300px', width: '100%' }}
                    center={{ lat: latitude, lng: longitude }}
                    zoom={12}
                    options={{ mapTypeControl: false, streetViewControl: false, fullscreenControl: false }}
                  >
                    <Marker position={{ lat: latitude, lng: longitude }} />
                    <Circle
                      center={{ lat: latitude, lng: longitude }}
                      radius={10000}
                      options={{ fillOpacity: 0.2, strokeWeight: 2 }}
                    />
                  </GoogleMap>
                </div>
              )}
            </div>
            {/* End Location Section */}

            {/* Contact Information Header */}
            <h3 className="text-xs font-black uppercase tracking-wider text-gray-400 dark:text-gray-500 mb-5 pb-3 border-b border-gray-100 dark:border-gray-800">
              Contact Information
            </h3>

            <div className="grid grid-cols-1 md:grid-cols-2 gap-5">
              <div className="md:col-span-2">
                <label className={labelClass}>Authorized Person Name</label>
                <div className="relative">
                  <div className="absolute inset-y-0 left-0 pl-3.5 flex items-center pointer-events-none text-gray-400">
                    <User className="w-[18px] h-[18px]" />
                  </div>
                  <input
                    type="text"
                    name="authorizedPerson"
                    value={formData.authorizedPerson}
                    onChange={handleChange}
                    placeholder="Enter your full name"
                    className={inputClass}
                  />
                </div>
              </div>

              {/* Mobile Number */}
              <div>
                <label className={labelClass}>Mobile Number</label>
                <div className="flex relative">
                  <select
                    name="countryCode"
                    value={formData.countryCode}
                    onChange={handleChange}
                    className="block w-24 pl-3 pr-2 py-2.5 bg-gray-50 border border-gray-100 rounded-l-xl text-gray-900 focus:outline-none focus:ring-2 focus:ring-primary-500/20 focus:border-primary-500 transition-all text-sm shadow-sm cursor-pointer"
                  >
                    <option value="+91">+91</option>
                    <option value="+1">+1</option>
                    <option value="+44">+44</option>
                  </select>
                  <div className="absolute inset-y-0 left-24 pl-3.5 flex items-center pointer-events-none text-gray-400">
                    <Phone className="w-[18px] h-[18px]" />
                  </div>
                  <input
                    type="tel"
                    name="mobileNumber"
                    value={formData.mobileNumber}
                    onChange={handleChange}
                    placeholder="10-digit mobile number"
                    className={`${inputClass} rounded-l-none pl-10 border-l-0`}
                  />
                </div>
              </div>

              {/* Email ID */}
              <div>
                <label className={labelClass}>Email ID</label>
                <div className="relative">
                  <div className="absolute inset-y-0 left-0 pl-3.5 flex items-center pointer-events-none text-gray-400">
                    <Mail className="w-[18px] h-[18px]" />
                  </div>
                  <input
                    type="email"
                    name="emailId"
                    value={formData.emailId}
                    onChange={handleChange}
                    placeholder="business@example.com"
                    className={inputClass}
                  />
                </div>
              </div>

              {/* Password */}
              <div>
                <label className={labelClass}>Password</label>
                <div className="relative">
                  <div className="absolute inset-y-0 left-0 pl-3.5 flex items-center pointer-events-none text-gray-400">
                    <Lock className="w-[18px] h-[18px]" />
                  </div>
                  <input
                    type={showPassword ? 'text' : 'password'}
                    name="password"
                    value={formData.password}
                    onChange={handleChange}
                    placeholder="••••••••"
                    className={inputClass}
                  />
                  <button
                    type="button"
                    onClick={() => setShowPassword(!showPassword)}
                    className="absolute inset-y-0 right-0 pr-3.5 flex items-center text-gray-400 hover:text-gray-600 focus:outline-none"
                  >
                    {showPassword ? <EyeOff className="w-4 h-4" /> : <Eye className="w-4 h-4" />}
                  </button>
                </div>
              </div>

              {/* Confirm Password */}
              <div>
                <label className={labelClass}>Confirm Password</label>
                <div className="relative">
                  <div className="absolute inset-y-0 left-0 pl-3.5 flex items-center pointer-events-none text-gray-400">
                    <Lock className="w-[18px] h-[18px]" />
                  </div>
                  <input
                    type={showConfirmPassword ? 'text' : 'password'}
                    name="confirmPassword"
                    value={formData.confirmPassword}
                    onChange={handleChange}
                    placeholder="••••••••"
                    className={inputClass}
                  />
                  <button
                    type="button"
                    onClick={() => setShowConfirmPassword(!showConfirmPassword)}
                    className="absolute inset-y-0 right-0 pr-3.5 flex items-center text-gray-400 hover:text-gray-600 focus:outline-none"
                  >
                    {showConfirmPassword ? <EyeOff className="w-4 h-4" /> : <Eye className="w-4 h-4" />}
                  </button>
                </div>
              </div>
            </div>
          </div>

          {/* Section: Document Uploads */}
          <div className="space-y-5">
            <h3 className="text-[10px] font-black uppercase tracking-widest text-gray-400 pb-2 border-b border-gray-100">
              Document Uploads
            </h3>

            <div className="grid grid-cols-1 md:grid-cols-2 gap-5">
              <FileDropZone
                label="Company Registration Document"
                file={companyDocFile}
                onChange={handleFileChange(setCompanyDocFile)}
                hint="Certificate of incorporation or equivalent"
              />

              <FileDropZone
                label="ID Proof"
                file={idProofFile}
                onChange={handleFileChange(setIdProofFile)}
                hint="Aadhaar, Passport, or Driving License"
              />
            </div>
          </div>

          {/* Action Button */}
          <div className="pt-4">
            <button
              type="submit"
              disabled={isSubmitting}
              className="w-full flex items-center justify-center gap-2 py-3.5 px-4 bg-primary-500 hover:bg-primary-600 text-white font-bold rounded-xl shadow-lg shadow-primary-500/20 active:scale-95 transition-all disabled:opacity-75 disabled:cursor-not-allowed text-sm"
            >
              {isSubmitting ? (
                <><Loader2 className="w-5 h-5 animate-spin" /> Creating Admin...</>
              ) : (
                <>Register <ArrowRight className="w-[18px] h-[18px]" /></>
              )}
            </button>
          </div>
        </form>
      </div>
    </div>,
    document.body
  );
};

export default CreateAdminModal;
