import React, { createContext, useContext, useState } from 'react';
import type { ReactNode } from 'react';

interface DashboardCache {
  countsResult?: any;
  rev?: any;
  kpisWithIds?: any;
  detailsData?: any;
  admins?: any;
}

interface DashboardCacheContextType {
  cache: DashboardCache;
  setCache: React.Dispatch<React.SetStateAction<DashboardCache>>;
}

const DashboardCacheContext = createContext<DashboardCacheContextType | undefined>(undefined);

export function DashboardCacheProvider({ children }: { children: ReactNode }) {
  const [cache, setCache] = useState<DashboardCache>({});

  return (
    <DashboardCacheContext.Provider value={{ cache, setCache }}>
      {children}
    </DashboardCacheContext.Provider>
  );
}

export function useDashboardCache() {
  const context = useContext(DashboardCacheContext);
  if (context === undefined) {
    throw new Error('useDashboardCache must be used within a DashboardCacheProvider');
  }
  return context;
}
