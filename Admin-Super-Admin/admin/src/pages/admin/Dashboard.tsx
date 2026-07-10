import { useState, useEffect } from "react"
import {
  LayoutDashboard,
  Megaphone,
  Target,
  Users,
  IndianRupee,
  MousePointerClick,
} from "lucide-react"
import { KpiCard } from "../../components/dashboard/KpiCard"
import { PerformanceChart } from "../../components/dashboard/Charts"
import { Skeleton } from "../../components/ui/Skeleton"
import { MapView } from "../../components/dashboard/MapView"
import { fetchDashboardData, type DashboardData } from "../../services/dashboard"

export default function Dashboard() {
  const [data, setData] = useState<DashboardData | null>(null)
  const [loading, setLoading] = useState(true)
  const [companyUID, setCompanyUID] = useState<string | undefined>(undefined)

  useEffect(() => {
    const loadData = async () => {
      setLoading(true)
      try {
        let uid = undefined;
        const userStr = localStorage.getItem('admin_user');
        if (userStr) {
          const user = JSON.parse(userStr);
          uid = user.companyUID || user.companyId || user.uid;
          setCompanyUID(uid)
        }
        const result = await fetchDashboardData(uid)
        setData(result)
      } catch (error) {
        console.error("Failed to load dashboard data", error)
      } finally {
        setLoading(false)
      }
    }
    loadData()
  }, [])

  const formatCurrency = (value: number) => {
    return new Intl.NumberFormat('en-IN', {
      style: 'currency',
      currency: 'INR',
      maximumFractionDigits: 0
    }).format(value)
  }

  const formatNumber = (value: number) => {
    return new Intl.NumberFormat('en-IN').format(value)
  }

  const getAverageClicks = () => {
    if (!data?.performanceChart || data.performanceChart.length === 0) {
      return data?.stats.totalClicks || 0
    }
    const totalClicks = data.performanceChart.reduce((sum, item) => sum + (item.clicks || 0), 0)
    return Math.round(totalClicks / data.performanceChart.length)
  }

  return (
    <div className="min-h-screen bg-gray-50 dark:bg-[#0E1117] transition-colors duration-200">
      <main className="w-full px-4 sm:px-6 lg:px-8 xl:px-12 py-8">
        <div className="flex flex-col md:flex-row md:items-center justify-between mb-8 gap-4">
          <div>
            <h2 className="text-2xl font-bold text-gray-900 dark:text-white">Dashboard Overview</h2>
            <p className="text-gray-500 dark:text-gray-400 mt-1">Welcome back, here's what's happening today.</p>
          </div>
        </div>

        <section className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6 mb-8">
          {loading || !data ? (
            Array.from({ length: 6 }).map((_, i) => (
              <Skeleton key={i} className="h-32 w-full rounded-2xl" />
            ))
          ) : (
            <>
              <KpiCard
                title="Total Ads Created"
                value={formatNumber(data.stats.totalAds)}
                icon={<LayoutDashboard className="w-6 h-6" />}
                delay={0.1}
              />
              <KpiCard
                title="Active Ads"
                value={formatNumber(data.stats.activeAds)}
                icon={<Megaphone className="w-6 h-6" />}
                delay={0.15}
              />
              <KpiCard
                title="Total Campaigns"
                value={formatNumber(data.stats.totalCampaigns)}
                icon={<Target className="w-6 h-6" />}
                delay={0.2}
              />
              <KpiCard
                title="Total Publishers"
                value={formatNumber(data.stats.totalPublishers)}
                icon={<Users className="w-6 h-6" />}
                delay={0.25}
              />
              <KpiCard
                title="Total Spend"
                value={formatCurrency(data.stats.totalSpend)}
                icon={<IndianRupee className="w-6 h-6" />}
                delay={0.3}
              />
              <KpiCard
                title="Average Clicks"
                value={formatNumber(getAverageClicks())}
                icon={<MousePointerClick className="w-6 h-6" />}
                delay={0.35}
              />
            </>
          )}
        </section>

        <section className="grid grid-cols-1 lg:grid-cols-2 gap-6">
          {loading || !data ? (
            <>
              <Skeleton className="h-[400px] w-full rounded-2xl" />
              <Skeleton className="h-[400px] w-full rounded-2xl" />
            </>
          ) : (
            <>
              <PerformanceChart data={data.performanceChart} title="Ad Performance Trend" delay={0.4} />
              <div className="h-[400px] rounded-2xl overflow-hidden">
                <MapView
                  isOpen={true}
                  onClose={() => { }}
                  companyUID={companyUID}
                  embedded={true}
                />
              </div>
            </>
          )}
        </section>
      </main>
    </div>
  )
}