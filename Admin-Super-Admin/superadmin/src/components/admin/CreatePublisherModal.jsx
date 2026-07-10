import React, { useState } from 'react';
import { createPortal } from 'react-dom';
import {
  Building2,
  MapPin,
  User,
  Phone,
  Mail,
  Loader2,
  X,
  Plus,
  Navigation,
  ChevronDown,
} from 'lucide-react';
import { LoadScript, GoogleMap, Marker } from '@react-google-maps/api';
import { createPublisherRecord } from '../../lib/management';
import toast from 'react-hot-toast';

// Google Maps integration, no Leaflet init needed

const DEFAULT_CENTER = [20.5937, 78.9629]; // India centre

// ── Shared style tokens ───────────────────────────────────────────────────────
const inputClass =
  'block w-full pl-10 pr-4 py-2.5 bg-gray-50 border border-gray-200 rounded-xl text-gray-900 placeholder-gray-400 focus:outline-none focus:ring-2 focus:ring-orange-400/20 focus:border-orange-400 transition-all text-sm';

const selectClass =
  'block w-full pl-10 pr-10 py-2.5 bg-gray-50 border border-gray-200 rounded-xl text-gray-900 focus:outline-none focus:ring-2 focus:ring-orange-400/20 focus:border-orange-400 transition-all text-sm cursor-pointer appearance-none';

const textareaClass =
  'block w-full pl-10 pr-4 py-2.5 bg-gray-50 border border-gray-200 rounded-xl text-gray-900 placeholder-gray-400 focus:outline-none focus:ring-2 focus:ring-orange-400/20 focus:border-orange-400 transition-all text-sm resize-y min-h-[80px]';

const labelClass = 'block text-xs font-bold text-gray-700 mb-1.5';
const sectionCard = 'bg-white border border-gray-100 rounded-2xl p-5 shadow-sm';

// ── Component ─────────────────────────────────────────────────────────────────
const CreatePublisherModal = ({ isOpen, onClose, onSuccess, admins }) => {
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [isDetecting, setIsDetecting] = useState(false);
  const [markerPos, setMarkerPos] = useState(null); // [lat, lng] tuple

  const [formData, setFormData] = useState({
    name: '',
    contactPerson: '',
    email: '',
    mobile: '',
    address: '',
    latitude: '',
    longitude: '',
    adminId: '',
  });

  if (!isOpen) return null;

  // Sync form fields → marker
  const handleChange = (e) => {
    const { name, value } = e.target;
    setFormData((prev) => ({ ...prev, [name]: value }));

    if (name === 'latitude' || name === 'longitude') {
      const lat = name === 'latitude' ? parseFloat(value) : parseFloat(formData.latitude);
      const lng = name === 'longitude' ? parseFloat(value) : parseFloat(formData.longitude);
      if (!isNaN(lat) && !isNaN(lng)) setMarkerPos([lat, lng]);
    }
  };

  // Map click → fill lat/lng + move marker
  const handleMapClick = ([lat, lng]) => {
    const latStr = lat.toFixed(6);
    const lngStr = lng.toFixed(6);
    setMarkerPos([parseFloat(latStr), parseFloat(lngStr)]);
    setFormData((prev) => ({ ...prev, latitude: latStr, longitude: lngStr }));
  };

  // GPS auto-detect
  const handleAutoDetect = () => {
    if (!navigator.geolocation) {
      toast.error('Geolocation is not supported by your browser.');
      return;
    }
    setIsDetecting(true);
    navigator.geolocation.getCurrentPosition(
      (pos) => {
        const lat = pos.coords.latitude.toFixed(6);
        const lng = pos.coords.longitude.toFixed(6);
        setFormData((prev) => ({ ...prev, latitude: lat, longitude: lng }));
        setMarkerPos([parseFloat(lat), parseFloat(lng)]);
        toast.success('Location detected!');
        setIsDetecting(false);
      },
      (err) => {
        toast.error('Could not detect location: ' + err.message);
        setIsDetecting(false);
      }
    );
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    if (!formData.adminId) {
      toast.error('Please select a managing Admin');
      return;
    }
    setIsSubmitting(true);
    try {
      const location =
        formData.latitude && formData.longitude
          ? `${formData.latitude}, ${formData.longitude}`
          : formData.address;
      await createPublisherRecord({ ...formData, location });
      toast.success('Publisher created successfully');
      onSuccess();
      onClose();
    } catch (err) {
      console.error(err);
      toast.error(err.message || 'Failed to create publisher');
    } finally {
      setIsSubmitting(false);
    }
  };

  const mapCenter = markerPos || DEFAULT_CENTER;

  return createPortal(
    <div className="fixed inset-0 z-[9999] flex items-center justify-center p-4">
      {/* Backdrop */}
      <div
        className="absolute inset-0 bg-gray-900/40 backdrop-blur-sm animate-fade-in"
        onClick={onClose}
      />

      {/* Modal */}
      <div className="relative w-full max-w-2xl max-h-[92vh] bg-gray-50 rounded-3xl shadow-2xl flex flex-col overflow-hidden animate-fade-in-scale border border-gray-200">

        {/* ── Header ── */}
        <div className="flex items-center justify-between px-8 py-5 bg-white border-b border-gray-100 sticky top-0 z-10">
          <div>
            <h2 className="text-xl font-black text-gray-900 tracking-tight">Create Publisher</h2>
            <p className="text-xs font-medium text-gray-400 mt-0.5">
              Register a new publisher and link to a managing admin
            </p>
          </div>
          <button
            onClick={onClose}
            className="p-2 rounded-xl bg-gray-100 text-gray-400 hover:bg-gray-200 hover:text-gray-700 transition-all active:scale-90"
          >
            <X size={18} />
          </button>
        </div>

        {/* ── Form ── */}
        <form onSubmit={handleSubmit} className="flex-1 overflow-y-auto p-6 space-y-4">

          {/* Managing Admin */}
          <div className={sectionCard}>
            <div className="flex items-center gap-3 mb-4">
              <div className="w-9 h-9 rounded-xl bg-purple-100 flex items-center justify-center">
                <User size={17} className="text-purple-500" />
              </div>
              <div>
                <p className="text-sm font-bold text-gray-900">Managing Admin</p>
                <p className="text-xs text-gray-400">Link this publisher to an ecosystem admin</p>
              </div>
            </div>
            <div className="relative">
              <div className="absolute inset-y-0 left-0 pl-3.5 flex items-center pointer-events-none text-gray-400">
                <User size={15} />
              </div>
              <select
                name="adminId"
                value={formData.adminId}
                onChange={handleChange}
                className={selectClass}
                required
              >
                <option value="">Select Managing Admin</option>
                {admins && admins.map((admin) => (
                  <option key={admin.id} value={admin.id}>
                    {admin.name} ({admin.company || 'Ecosystem Admin'})
                  </option>
                ))}
              </select>
              <div className="absolute right-3.5 top-1/2 -translate-y-1/2 text-gray-400 pointer-events-none">
                <ChevronDown size={15} />
              </div>
            </div>
          </div>

          {/* Basic Information */}
          <div className={sectionCard}>
            <div className="flex items-center gap-3 mb-5">
              <div className="w-9 h-9 rounded-xl bg-orange-100 flex items-center justify-center">
                <Building2 size={17} className="text-orange-500" />
              </div>
              <div>
                <p className="text-sm font-bold text-gray-900">Basic Information</p>
                <p className="text-xs text-gray-400">Essential details about the publisher or branch.</p>
              </div>
            </div>

            <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
              <div>
                <label className={labelClass}>Publisher / Branch Name <span className="text-red-500">*</span></label>
                <div className="relative">
                  <div className="absolute inset-y-0 left-0 pl-3.5 flex items-center pointer-events-none text-gray-400"><Building2 size={15} /></div>
                  <input type="text" name="name" value={formData.name} onChange={handleChange} placeholder="e.g. Phoenix Mall Outlet" className={inputClass} required />
                </div>
              </div>

              <div>
                <label className={labelClass}>Contact Person <span className="text-red-500">*</span></label>
                <div className="relative">
                  <div className="absolute inset-y-0 left-0 pl-3.5 flex items-center pointer-events-none text-gray-400"><User size={15} /></div>
                  <input type="text" name="contactPerson" value={formData.contactPerson} onChange={handleChange} placeholder="e.g. Rahul Sharma" className={inputClass} required />
                </div>
              </div>

              <div>
                <label className={labelClass}>Email Address <span className="text-red-500">*</span></label>
                <div className="relative">
                  <div className="absolute inset-y-0 left-0 pl-3.5 flex items-center pointer-events-none text-gray-400"><Mail size={15} /></div>
                  <input type="email" name="email" value={formData.email} onChange={handleChange} placeholder="contact@outlet.com" className={inputClass} required />
                </div>
              </div>

              <div>
                <label className={labelClass}>Mobile Number <span className="text-red-500">*</span></label>
                <div className="relative">
                  <div className="absolute inset-y-0 left-0 pl-3.5 flex items-center pointer-events-none text-gray-400"><Phone size={15} /></div>
                  <input type="tel" name="mobile" value={formData.mobile} onChange={handleChange} placeholder="9876543210" className={inputClass} required />
                </div>
              </div>
            </div>
          </div>

          {/* Location Information */}
          <div className={sectionCard}>
            <div className="flex items-center justify-between mb-5">
              <div className="flex items-center gap-3">
                <div className="w-9 h-9 rounded-xl bg-blue-100 flex items-center justify-center">
                  <MapPin size={17} className="text-blue-500" />
                </div>
                <div>
                  <p className="text-sm font-bold text-gray-900">Location Information</p>
                  <p className="text-xs text-gray-400">Used for geo-targeted ad delivery.</p>
                </div>
              </div>
              <button
                type="button"
                onClick={handleAutoDetect}
                disabled={isDetecting}
                className="flex items-center gap-2 px-4 py-2 bg-gray-900 hover:bg-gray-700 text-white rounded-xl text-xs font-bold transition-all active:scale-95 disabled:opacity-60 shadow-sm"
              >
                {isDetecting ? <Loader2 size={13} className="animate-spin" /> : <Navigation size={13} />}
                {isDetecting ? 'Detecting...' : 'Auto-Detect Location'}
              </button>
            </div>

            {/* ── Google Map picker ── */}
            <div className="rounded-2xl overflow-hidden border border-gray-200 mb-4" style={{ height: 220 }}>
              <LoadScript googleMapsApiKey={import.meta.env.VITE_GOOGLE_MAPS_API_KEY || ""}>
                <GoogleMap
                  mapContainerStyle={{ width: '100%', height: '100%' }}
                  center={markerPos ? { lat: markerPos[0], lng: markerPos[1] } : { lat: DEFAULT_CENTER[0], lng: DEFAULT_CENTER[1] }}
                  zoom={markerPos ? 14 : 5}
                  onClick={(e) => {
                    const lat = e.latLng.lat();
                    const lng = e.latLng.lng();
                    handleMapClick([lat, lng]);
                  }}
                  options={{ mapTypeControl: false, streetViewControl: false, fullscreenControl: false }}
                >
                  {markerPos && <Marker position={{ lat: markerPos[0], lng: markerPos[1] }} />}
                </GoogleMap>
              </LoadScript>
            </div>
            <p className="text-[10px] text-gray-400 font-medium mb-4 flex items-center gap-1">
              <MapPin size={11} /> Click anywhere on the map to pin the publisher location
            </p>

            {/* Address */}
            <div className="mb-4">
              <label className={labelClass}>Complete Address <span className="text-red-500">*</span></label>
              <div className="relative">
                <div className="absolute top-3 left-0 pl-3.5 flex items-start pointer-events-none text-gray-400">
                  <MapPin size={15} />
                </div>
                <textarea
                  name="address"
                  value={formData.address}
                  onChange={handleChange}
                  placeholder="Enter complete business address..."
                  className={textareaClass}
                  required
                />
              </div>
            </div>

            {/* Lat / Lng */}
            <div className="grid grid-cols-2 gap-4">
              <div>
                <label className={labelClass}>Latitude <span className="text-red-500">*</span></label>
                <input
                  type="number"
                  step="any"
                  name="latitude"
                  value={formData.latitude}
                  onChange={handleChange}
                  placeholder="e.g. 19.0760"
                  className="block w-full px-4 py-2.5 bg-gray-50 border border-gray-200 rounded-xl text-gray-900 placeholder-gray-400 focus:outline-none focus:ring-2 focus:ring-orange-400/20 focus:border-orange-400 transition-all text-sm"
                  required
                />
              </div>
              <div>
                <label className={labelClass}>Longitude <span className="text-red-500">*</span></label>
                <input
                  type="number"
                  step="any"
                  name="longitude"
                  value={formData.longitude}
                  onChange={handleChange}
                  placeholder="e.g. 72.8777"
                  className="block w-full px-4 py-2.5 bg-gray-50 border border-gray-200 rounded-xl text-gray-900 placeholder-gray-400 focus:outline-none focus:ring-2 focus:ring-orange-400/20 focus:border-orange-400 transition-all text-sm"
                  required
                />
              </div>
            </div>
          </div>

          {/* Submit */}
          <div className="pb-2">
            <button
              type="submit"
              disabled={isSubmitting}
              className="w-full flex items-center justify-center gap-2 py-3 px-4 bg-orange-500 hover:bg-orange-600 text-white font-bold rounded-xl shadow-lg shadow-orange-500/20 active:scale-95 transition-all disabled:opacity-75 disabled:cursor-not-allowed text-sm"
            >
              {isSubmitting ? (
                <><Loader2 className="w-4 h-4 animate-spin" /> Creating Publisher...</>
              ) : (
                <><Plus className="w-4 h-4" /> Create Publisher</>
              )}
            </button>
          </div>
        </form>
      </div>
    </div>,
    document.body
  );
};

export default CreatePublisherModal;
