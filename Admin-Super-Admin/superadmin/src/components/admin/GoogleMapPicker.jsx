import React, { useCallback, useRef } from 'react';
import { LoadScript, GoogleMap, Marker } from '@react-google-maps/api';

// Google Maps API key – provided by the user
const GOOGLE_MAPS_API_KEY = import.meta.env.VITE_GOOGLE_MAPS_API_KEY || '';

// Default map options – can be customized later
const mapContainerStyle = {
  width: '100%',
  height: '100%',
};

// Default options – you can customize as needed
const defaultOptions = {
  disableDefaultUI: true,
  zoomControl: true,
};

/**
 * GoogleMapPicker – a thin wrapper around @react-google-maps/api.
 * Props:
 *   center: [lat, lng] – initial centre of the map.
 *   zoom: number – initial zoom level.
 *   markerPos: [lat, lng] | null – position of the marker (if any).
 *   onMapClick: (latLng: [number, number]) => void – called when the user clicks the map.
 */
export default function GoogleMapPicker({ center, zoom = 5, markerPos, onMapClick }) {
  const { isLoaded, loadError } = useLoadScript({
    googleMapsApiKey: GOOGLE_MAPS_API_KEY,
    // libraries can be added here if you need Places, etc.
  });

  const mapRef = useRef(null);

  const onLoad = useCallback((mapInstance) => {
    mapRef.current = mapInstance;
    // Attach click listener
    mapInstance.addListener('click', (e) => {
      const lat = e.latLng.lat();
      const lng = e.latLng.lng();
      onMapClick([lat, lng]);
    });
  }, [onMapClick]);

  if (loadError) {
    return <div className="text-sm text-red-500">Failed to load Google Maps.</div>;
  }
  if (!isLoaded) {
    return <div className="flex items-center justify-center h-full"><span className="text-gray-500">Loading map…</span></div>;
  }

  return (
    <GoogleMap
      mapContainerStyle={mapContainerStyle}
      center={center}
      zoom={zoom}
      options={defaultOptions}
      onLoad={onLoad}
    >
      {markerPos && <Marker position={{ lat: markerPos[0], lng: markerPos[1] }} />}
    </GoogleMap>
  );
}
