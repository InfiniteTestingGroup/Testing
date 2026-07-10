const fs = require('fs');
const file = 'd:/ssss/Testing-main/Admin-Super-Admin/superadmin/src/pages/Dashboard.tsx';
let content = fs.readFileSync(file, 'utf8');

if(!content.includes("import { useDashboardCache }")) {
    content = content.replace(
        "import { fetchAdmins } from '../lib/management';",
        "import { fetchAdmins } from '../lib/management';\nimport { useDashboardCache } from '../context/DashboardCacheContext';"
    );
}

content = content.replace("  Activity,\n  Megaphone,\n", "");
content = content.replace("import { AuthError } from '../lib/auth';\n", "");

content = content.replace("useState([]);", "useState<any[]>([]);");

content = content.replace("  const [detailsLoading, setDetailsLoading] = useState(true);\n", "");
content = content.replace("  const [detailsError, setDetailsError] = useState('');\n", "");
content = content.replace(/[ \t]*if \(!cancelled\) setDetailsLoading\(false\);\n/g, "");
content = content.replace(/[ \t]*if \(!cancelled\) setDetailsError\('Failed to load chart\\/activity data\\.'\);\n/g, "");

content = content.replace(/\.map\(\(kpi\) => \{/g, ".map((kpi: any) => {");
content = content.replace(/\.filter\(\(kpi\) =>/g, ".filter((kpi: any) =>");
content = content.replace(/countsResult\.kpis\.map\(\(kpi\) => \(\{/g, "countsResult.kpis.map((kpi: any) => ({");

content = content.replace("  const hiddenTitles = new Set();\n", "");

if (!content.includes("const { cache, setCache } = useDashboardCache();")) {
    content = content.replace(
        "// const [revenueData, setRevenueData] = useState<any>(null); // revenue state removed",
        "// const [revenueData, setRevenueData] = useState<any>(null); // revenue state removed\n\n  const { cache, setCache } = useDashboardCache();"
    );
}

const cacheLogic = `
    // If cached data exists, use it
    if (cache.kpisWithIds && cache.rev && cache.countsResult && cache.detailsData && cache.admins) {
      if (cancelled) return;
      setAllAdmins(cache.admins);
      const visible = loadVisibility(cache.kpisWithIds);
      visible.add('revenue');
      setVisibleIds(visible);
      setDashboard({
        summary: cache.countsResult.summary,
        kpis: cache.kpisWithIds,
        publishingTrend: cache.detailsData?.publishingTrend ?? [],
        recentActivities: cache.detailsData?.recentActivities ?? [],
        adTypeBreakdown: cache.detailsData?.adTypeBreakdown ?? [],
        locationBreakdown: cache.detailsData?.locationBreakdown ?? [],
        topCreators: [],
      });
      setLoading(false);
      return;
    }
`;

if (!content.includes("// If cached data exists, use it")) {
    content = content.replace(
        "let cancelled = false;",
        "let cancelled = false;\n" + cacheLogic
    );
}

const setCacheCall = `
        setCache({
          countsResult,
          rev,
          kpisWithIds,
          detailsData,
          admins,
        });
`;

if (!content.includes("setCache({")) {
    content = content.replace(
        "topCreators: [],\n        });",
        "topCreators: [],\n        });\n" + setCacheCall
    );
}

content = content.replace("  }, []);", "  }, [cache, setCache]);");

const startIdx = content.indexOf("  }, [cache, setCache]);");
if(startIdx !== -1) {
    const nextCancelled = content.indexOf("    let cancelled = false;", startIdx);
    const endToggleKpi = content.indexOf("  const toggleKpi = useCallback((id: string) => {", startIdx);
    if(nextCancelled !== -1 && endToggleKpi !== -1 && nextCancelled < endToggleKpi) {
        content = content.slice(0, nextCancelled) + content.slice(endToggleKpi);
    }
}

fs.writeFileSync(file, content);
console.log('Fixed Dashboard.tsx cleanly');
