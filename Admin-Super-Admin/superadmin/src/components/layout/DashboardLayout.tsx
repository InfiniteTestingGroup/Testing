import { useState, useEffect } from 'react';
import { Outlet } from 'react-router-dom';
import Sidebar from './Sidebar';
import TopNavbar from './TopNavbar';
import TermsModal from '../shared/TermsModal';

export default function DashboardLayout() {
  const [collapsed, setCollapsed] = useState(false);
  const [isModalOpen, setIsModalOpen] = useState(false);

  // Observe scroll‑animate elements for entrance animation
  useEffect(() => {
    const observer = new IntersectionObserver(
      entries => {
        entries.forEach(entry => {
          if (entry.isIntersecting) {
            entry.target.classList.add('is-visible');
            observer.unobserve(entry.target);
          }
        });
      },
      { threshold: 0.1, rootMargin: '0px 0px -20px 0px' }
    );

    const observeElements = () => {
      document
        .querySelectorAll('.scroll-animate:not(.is-visible)')
        .forEach(el => {
          if (el && el instanceof Element) {
            try {
              observer.observe(el);
            } catch (err) {
              console.error('Observer error:', err);
            }
          }
        });
    };

    observeElements(); // initial run
    const mutationObserver = new MutationObserver(observeElements);
    mutationObserver.observe(document.body, { childList: true, subtree: true });

    return () => {
      observer.disconnect();
      mutationObserver.disconnect();
    };
  }, []);

  return (
    <div className="flex h-full overflow-hidden bg-gray-50">
      {/* Sidebar */}
      <Sidebar collapsed={collapsed} onToggle={() => setCollapsed(!collapsed)} />

      {/* Main area */}
      <div className="flex flex-col flex-1 overflow-hidden">
        <TopNavbar onMenuToggle={() => setCollapsed(!collapsed)} />
        <main className="flex-1 overflow-y-auto p-6 dashboard-bg">
          <div className="relative z-10">
            <Outlet />
          </div>
        </main>
        {/* Premium glass‑morphism footer */}
        <footer className="bg-white bg-opacity-30 backdrop-blur-md pt-3 pb-4 text-right pr-8 rounded-t-lg shadow-inner">
          <a
            href="#"
            onClick={e => {
              e.preventDefault();
              setIsModalOpen(true);
            }}
            className="text-sm text-indigo-700 hover:text-indigo-900 font-medium underline"
          >
            Terms &amp; Conditions
          </a>
        </footer>
        {isModalOpen && <TermsModal isOpen={isModalOpen} onClose={() => setIsModalOpen(false)} />}
      </div>
    </div>
  );
}
