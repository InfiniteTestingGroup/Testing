import { api } from './api'
import type { Activity } from '../components/dashboard/RecentActivity'

export interface DashboardStats {
  totalAds: number
  activeAds: number
  totalCampaigns: number
  totalPublishers: number
  totalSpend: number
  totalClicks: number
}

export interface ChartDataPoint {
  name: string
  impressions?: number
  clicks: number
  spend?: number
}

export interface DashboardData {
  stats: DashboardStats
  performanceChart: ChartDataPoint[]
  engagementChart: ChartDataPoint[]
  spendChart: ChartDataPoint[]
  recentActivities: Activity[]
}

const formatChartMonth = (dateStr: string): string => {
  if (!dateStr) return ''
  const parts = dateStr.split('-')
  if (parts.length !== 3) return dateStr
  const [year, month, day] = parts.map(Number)
  const d = new Date(year, month - 1, day)
  if (isNaN(d.getTime())) return dateStr
  return d.toLocaleDateString('en-US', { month: 'short' })
}

export const fetchDashboardData = async (
  companyUID?: string
): Promise<DashboardData> => {
  const res = await api.get('/api/admin/dashboard', {
    params: { companyUID },
    timeout: 10000,
  })

  const d = res.data

  const mapChartData = (arr: any[]): ChartDataPoint[] => {
    const byMonth = new Map<string, ChartDataPoint>()

      ; (arr || []).forEach((p: any) => {
        const dateStr = p.date ?? p.name ?? ''
        const monthName = formatChartMonth(dateStr)
        if (!monthName) return

        const existing = byMonth.get(monthName) || {
          name: monthName,
          impressions: 0,
          clicks: 0,
          spend: 0,
        }

        existing.impressions = (existing.impressions || 0) + (p.impressions ?? 0)
        existing.clicks = (existing.clicks || 0) + (p.clicks ?? 0)
        existing.spend = (existing.spend || 0) + (p.spend ?? 0)

        byMonth.set(monthName, existing)
      })

    const monthOrder = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec']
    return Array.from(byMonth.values()).sort(
      (a, b) => monthOrder.indexOf(a.name) - monthOrder.indexOf(b.name)
    )
  }

  return {
    stats: {
      totalAds: d.totalAds ?? 0,
      activeAds: d.activeAds ?? 0,
      totalCampaigns: d.totalCampaigns ?? 0,
      totalPublishers: d.totalPublishers ?? 0,
      totalSpend: d.totalSpend ?? 0,
      totalClicks: d.totalClicks ?? 0,
    },
    performanceChart: mapChartData(d.performanceTrend),
    engagementChart: mapChartData(d.engagementTrend),
    spendChart: mapChartData(d.spendVsPerformance),
    recentActivities: [],
  }
}