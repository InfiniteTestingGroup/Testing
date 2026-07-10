import { api } from './api'

export interface AnalyticsFilters {
  dateRange: string
  adId: string
  publisherId: string
  adType: string
  status: string
  companyUID?: string
}

export interface KpiData {
  impressions: number
  clicks: number
  ctr: number
  spend: number
  activeCampaigns: number
  trends: {
    impressions: number
    clicks: number
    ctr: number
    spend: number
  }
}

export interface TrendData {
  time: string
  impressions: number
  clicks: number
  spend: number
}

export interface BreakdownItem {
  name: string
  value: number
  percentage: number
}

export interface AnalyticsData {
  kpis: KpiData
  trends: TrendData[]
  breakdowns: {
    byAd: BreakdownItem[]
    byPublisher: BreakdownItem[]
    byLocation: BreakdownItem[]
  }
  insights: string[]
}

const getDates = (range: string) => {
  const end = new Date();
  const start = new Date();
  
  switch (range) {
    case "Today":
      break;
    case "Last 7 Days":
      start.setDate(end.getDate() - 7);
      break;
    case "Last 30 Days":
      start.setDate(end.getDate() - 30);
      break;
    default:
      start.setDate(end.getDate() - 30);
  }
  
  return {
    startDate: start.toISOString().split('T')[0],
    endDate: end.toISOString().split('T')[0]
  }
}

export const fetchAnalytics = async (filters: AnalyticsFilters): Promise<AnalyticsData> => {
  const { startDate, endDate } = getDates(filters.dateRange)
  
  try {
    const response = await api.get('/api/admin/analytics', {
      params: {
        startDate,
        endDate,
        adId: filters.adId,
        publisherId: filters.publisherId,
        adType: filters.adType,
        status: filters.status,
        companyUID: filters.companyUID
      }
    })
    return response.data
  } catch (error) {
    console.error('Error fetching analytics from Spring Boot:', error)
    // Return empty analytics if backend fails
    return {
      kpis: {
        impressions: 0,
        clicks: 0,
        ctr: 0,
        spend: 0,
        activeCampaigns: 0,
        trends: { impressions: 0, clicks: 0, ctr: 0, spend: 0 }
      },
      trends: [],
      breakdowns: { byAd: [], byPublisher: [], byLocation: [] },
      insights: ['Unable to fetch analytics data from server.']
    }
  }
}

export const exportAnalyticsCSV = (data: AnalyticsData) => {
  const headers = ["Metric", "Value"]
  const rows = [
    ["Total Impressions", data.kpis.impressions],
    ["Total Clicks", data.kpis.clicks],
    ["CTR %", data.kpis.ctr],
    ["Total Spend", data.kpis.spend],
    ["Active Campaigns", data.kpis.activeCampaigns]
  ]
  
  const csvContent = "data:text/csv;charset=utf-8," 
    + headers.join(",") + "\n"
    + rows.map(e => e.join(",")).join("\n")
    
  const encodedUri = encodeURI(csvContent)
  const link = document.createElement("a")
  link.setAttribute("href", encodedUri)
  link.setAttribute("download", `analytics_export_${new Date().toISOString()}.csv`)
  document.body.appendChild(link)
  link.click()
  document.body.removeChild(link)
}
