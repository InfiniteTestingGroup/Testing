export const API_BASE_URL = import.meta.env.VITE_API_BASE_URL ?? ''

const AUTH_STORAGE_KEY = 'keliri_superadmin_auth'

export type SuperAdminRole = 'MASTER_SUPER_ADMIN' | 'SUB_SUPER_ADMIN'

export type PermissionKey =
  | 'dashboard'
  | 'analytics'
  | 'admins'
  | 'publishers'
  | 'ads'
  | 'revenue'
  | 'transactions'
  | 'tickets'
  | 'auditLogs'
  | 'profile'
  | 'subAdmins'

export type PermissionMap = Record<PermissionKey, boolean>

export interface AuthSession {
  token: string
  email: string
  name?: string
  phone?: string
  role: SuperAdminRole
  permissions: PermissionMap
  expiresAt: number
}

export interface LoginResponse {
  token: string
  message: string
  expiresInHours?: number
  email: string
  name?: string
  phone?: string
  role: string
  permissions: Partial<PermissionMap>
}

export class AuthError extends Error {
  status: number

  constructor(message: string, status: number) {
    super(message)
    this.name = 'AuthError'
    this.status = status
  }
}

const defaultPermissions: PermissionMap = {
  dashboard: false,
  analytics: false,
  admins: false,
  publishers: false,
  ads: false,
  revenue: false,
  transactions: false,
  tickets: false,
  auditLogs: false,
  profile: true,
  subAdmins: false,
}

function normalizePermissions(role: SuperAdminRole, permissions?: Partial<PermissionMap>): PermissionMap {
  if (role === 'MASTER_SUPER_ADMIN') {
    return {
      dashboard: true,
      analytics: true,
      admins: true,
      publishers: true,
      ads: true,
      revenue: true,
      transactions: true,
      tickets: true,
      auditLogs: true,
      profile: true,
      subAdmins: true,
    }
  }

  return {
    ...defaultPermissions,
    ...(permissions ?? {}),
    subAdmins: false,
  }
}

function normalizeRole(role?: string): SuperAdminRole {
  const normalized = (role ?? '').trim().toUpperCase()
  if (normalized === 'MASTER_SUPER_ADMIN' || normalized === 'SUPER_ADMIN') {
    return 'MASTER_SUPER_ADMIN'
  }
  return 'SUB_SUPER_ADMIN'
}

export function getAuthSession(): AuthSession | null {
  const raw = localStorage.getItem(AUTH_STORAGE_KEY)
  if (!raw) return null

  try {
    const session = JSON.parse(raw) as AuthSession
    if (!session.token || !session.email || !session.expiresAt || !session.role) {
      clearAuthSession()
      return null
    }

    if (Date.now() >= session.expiresAt) {
      localStorage.setItem('keliri_session_expired', 'true')
      clearAuthSession()
      return null
    }

    session.role = normalizeRole(session.role)
    session.permissions = normalizePermissions(session.role, session.permissions)
    return session
  } catch {
    clearAuthSession()
    return null
  }
}

export function isAuthenticated(): boolean {
  return getAuthSession() !== null
}

export function isMasterSuperAdmin(): boolean {
  const session = getAuthSession()
  return session?.role === 'MASTER_SUPER_ADMIN'
}

export function hasModuleAccess(permission: PermissionKey): boolean {
  const session = getAuthSession()
  if (!session) return false
  return Boolean(session.permissions?.[permission])
}

export function clearAuthSession() {
  localStorage.removeItem(AUTH_STORAGE_KEY)
}

function buildSession(login: LoginResponse): AuthSession {
  const expiresInHours = login.expiresInHours ?? 24
  const role = normalizeRole(login.role)

  return {
    token: login.token,
    email: login.email,
    name: login.name,
    phone: login.phone,
    role,
    permissions: normalizePermissions(role, login.permissions),
    expiresAt: Date.now() + expiresInHours * 60 * 60 * 1000,
  }
}

export async function loginSuperAdmin(email: string, password: string): Promise<LoginResponse> {
  const response = await fetch(`${API_BASE_URL}/api/auth/superadmin/login`, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({ email, password }),
  })

  const payload = await response.json().catch(() => null) as LoginResponse | { error?: string; message?: string } | null

  if (!response.ok) {
    const errorMessage =
      (payload && 'message' in payload && payload.message) ||
      (payload && 'error' in payload && payload.error) ||
      'Login failed'
    throw new AuthError(errorMessage, response.status)
  }

  if (!payload || !('token' in payload) || !payload.token) {
    throw new AuthError('Login failed', response.status)
  }

  return payload
}

export function persistAuthSession(login: LoginResponse) {
  localStorage.setItem(AUTH_STORAGE_KEY, JSON.stringify(buildSession(login)))
}

export async function refreshAuthSession(): Promise<AuthSession | null> {
  const session = getAuthSession()
  if (!session?.token) return null

  const response = await fetch(`${API_BASE_URL}/api/auth/superadmin/me`, {
    headers: {
      Authorization: `Bearer ${session.token}`,
    },
  })

  const payload = await response.json().catch(() => null) as LoginResponse | { error?: string; message?: string } | null

  if (!response.ok) {
    const errorMessage =
      (payload && 'message' in payload && payload.message) ||
      (payload && 'error' in payload && payload.error) ||
      'Unable to refresh session'
    throw new AuthError(errorMessage, response.status)
  }

  if (!payload || !('token' in payload) || !payload.token) {
    throw new AuthError('Unable to refresh session', response.status)
  }

  const nextSession = buildSession(payload)
  localStorage.setItem(AUTH_STORAGE_KEY, JSON.stringify(nextSession))
  return nextSession
}

export function getRoleLabel(role?: SuperAdminRole): string {
  if (role === 'MASTER_SUPER_ADMIN') return 'Master Super Admin'
  if (role === 'SUB_SUPER_ADMIN') return 'Sub-Super Admin'
  return 'Super Admin'
}

export async function logoutSuperAdmin() {
  const session = getAuthSession()

  try {
    await fetch(`${API_BASE_URL}/api/auth/superadmin/logout`, {
      method: 'POST',
      headers: session?.token
        ? {
          Authorization: `Bearer ${session.token}`,
        }
        : undefined,
    })
  } catch {
    // Logout should still clear local state if the backend is unreachable.
  } finally {
    clearAuthSession()
  }
}
