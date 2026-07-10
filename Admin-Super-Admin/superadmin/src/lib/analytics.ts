import { API_BASE_URL, AuthError, getAuthSession } from './auth'

async function readApiResponse(response: Response, fallbackMessage: string) {
  const payload = await response.json().catch(() => null)

  if (!response.ok) {
    throw new AuthError(payload?.message || fallbackMessage, response.status)
  }

  return payload
}

function authHeaders() {
  const session = getAuthSession()
  return session?.token
    ? {
        Authorization: `Bearer ${session.token}`,
      }
    : undefined
}

export async function fetchSuperAdminAnalytics(range = 'LAST_30_DAYS', adType = '') {
  let url = `${API_BASE_URL}/api/superadmin/analytics?range=${encodeURIComponent(range)}`;
  if (adType && adType !== 'ALL') {
    url += `&adType=${encodeURIComponent(adType)}`;
  }
  const response = await fetch(url, {
    headers: authHeaders(),
  })

  return readApiResponse(response, 'Unable to load live analytics')
}

export async function fetchSuperAdminAnalyticsSummary() {
  const response = await fetch(`${API_BASE_URL}/api/superadmin/analytics/summary`, {
    headers: authHeaders(),
  })

  return readApiResponse(response, 'Unable to load live analytics summary')
}

export async function fetchRevenueAnalytics() {
  const response = await fetch(`${API_BASE_URL}/api/superadmin/analytics/revenue`, {
    headers: authHeaders(),
  })

  return readApiResponse(response, 'Unable to load revenue analytics')
}
