import { useEffect, useState } from "react";
import { useNavigate } from "react-router-dom";
import PublisherMapView from "../../components/admin/PublisherMapView";
import { fetchPublishers, type Publisher } from "../../services/publishers";

export default function PublisherMapPage() {
  const [publishers, setPublishers] = useState<Publisher[]>([]);
  const [loading, setLoading] = useState<boolean>(true);
  const [error, setError] = useState<string | null>(null);
  const navigate = useNavigate();

  useEffect(() => {
    const load = async () => {
      try {
        const result = await fetchPublishers({ page: 1, limit: 1000 });
        if (result && result.data) {
          setPublishers(result.data);
        } else {
          setPublishers([]);
        }
      } catch (e) {
        console.error('Failed to load publishers for map', e);
        setError('Unable to load publishers. Please ensure you are logged in.');
        // Provide fallback demo data
        setPublishers([
          { id: 'demo1', name: 'Demo Publisher', location: 'New Delhi, India', status: 'Active', contactPerson: 'N/A', lastActive: '', mobile: '', email: '' },
          { id: 'demo2', name: 'Sample Publisher', location: 'Mumbai, India', status: 'Inactive', contactPerson: 'N/A', lastActive: '', mobile: '', email: '' }
        ]);
      } finally {
        setLoading(false);
      }
    };
    load();
  }, []);

  return (
    <PublisherMapView
      isOpen={true}
      onClose={() => window.history.back()}
      publishers={publishers}
      onPublisherClick={(pub: Publisher) => navigate(`/admin/publishers/${pub.id}`)}
    />
  );
}