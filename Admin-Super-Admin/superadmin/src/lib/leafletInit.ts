import L from 'leaflet';

let initialized = false;

/**
 * Call once before using any Leaflet map component in Vite/React.
 * Fixes the default marker icon path issue that occurs with bundlers.
 */
export function initLeafletIcons(): void {
  if (initialized) return;
  initialized = true;

  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  delete (L.Icon.Default.prototype as any)._getIconUrl;
  L.Icon.Default.mergeOptions({
    iconRetinaUrl: 'https://unpkg.com/leaflet@1.9.4/dist/images/marker-icon-2x.png',
    iconUrl: 'https://unpkg.com/leaflet@1.9.4/dist/images/marker-icon.png',
    shadowUrl: 'https://unpkg.com/leaflet@1.9.4/dist/images/marker-shadow.png',
  });
}
