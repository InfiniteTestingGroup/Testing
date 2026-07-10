import { API_BASE_URL, AuthError, getAuthSession } from './auth'
import type { PermissionMap } from './auth'

export interface SubAdminRecord {
  id: string
  name: string
  email: string
  phone: string
  role: string
  locked: boolean
  permissions: PermissionMap
}

export interface CreateSubAdminRequest {
  name: string
  email: string
  phone: string
  password: string
  permissions: Partial<PermissionMap>
}

export interface UpdateSubAdminRequest {
  name?: string
  phone?: string
  permissions?: Partial<PermissionMap>
}

function authHeaders() {
  const session = getAuthSession()
  return session?.token
    ? {
        Authorization: `Bearer ${session.token}`,
      }
    : undefined
}

async function parseResponse<T>(response: Response, fallback: string): Promise<T> {
  const payload = await response.json().catch(() => null) as T | { message?: string; error?: string } | null
  if (!response.ok) {
    const errorMessage =
      (payload && typeof payload === 'object' && 'message' in payload && payload.message) ||
      (payload && typeof payload === 'object' && 'error' in payload && payload.error) ||
      fallback
    throw new AuthError(String(errorMessage), response.status)
  }
  return payload as T
}

export async function fetchSubAdmins(): Promise<SubAdminRecord[]> {
  const response = await fetch(`${API_BASE_URL}/api/superadmin/sub-admins`, { headers: authHeaders() })
  return parseResponse<SubAdminRecord[]>(response, 'Unable to fetch sub-admins')
}

export async function createSubAdmin(request: CreateSubAdminRequest): Promise<SubAdminRecord> {
  const response = await fetch(`${API_BASE_URL}/api/superadmin/sub-admins`, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      ...(authHeaders() ?? {}),
    },
    body: JSON.stringify(request),
  })
  return parseResponse<SubAdminRecord>(response, 'Unable to create sub-admin')
}

export async function updateSubAdmin(id: string, request: UpdateSubAdminRequest): Promise<SubAdminRecord> {
  const response = await fetch(`${API_BASE_URL}/api/superadmin/sub-admins/${id}`, {
    method: 'PUT',
    headers: {
      'Content-Type': 'application/json',
      ...(authHeaders() ?? {}),
    },
    body: JSON.stringify(request),
  })
  return parseResponse<SubAdminRecord>(response, 'Unable to update sub-admin')
}

export async function lockSubAdmin(id: string): Promise<SubAdminRecord> {
  const response = await fetch(`${API_BASE_URL}/api/superadmin/sub-admins/${id}/lock`, {
    method: 'POST',
    headers: authHeaders(),
  })
  return parseResponse<SubAdminRecord>(response, 'Unable to lock sub-admin')
}

export async function unlockSubAdmin(id: string): Promise<SubAdminRecord> {
  const response = await fetch(`${API_BASE_URL}/api/superadmin/sub-admins/${id}/unlock`, {
    method: 'POST',
    headers: authHeaders(),
  })
  return parseResponse<SubAdminRecord>(response, 'Unable to unlock sub-admin')
}

export async function deleteSubAdmin(id: string): Promise<void> {
  const response = await fetch(`${API_BASE_URL}/api/superadmin/sub-admins/${id}`, {
    method: 'DELETE',
    headers: authHeaders(),
  })

  if (!response.ok) {
    const payload = await response.json().catch(() => null) as { message?: string; error?: string } | null
    throw new AuthError(payload?.message || payload?.error || 'Unable to delete sub-admin', response.status)
  }
}
