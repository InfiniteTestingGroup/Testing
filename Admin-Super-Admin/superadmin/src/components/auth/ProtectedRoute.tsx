import { useEffect, useState } from 'react'
import { Navigate, Outlet, useLocation } from 'react-router-dom'
import { AuthError, clearAuthSession, getAuthSession, refreshAuthSession } from '../../lib/auth'

export default function ProtectedRoute() {
  const location = useLocation()
  const [session, setSession] = useState(() => getAuthSession())
  const [checking, setChecking] = useState(true)

  useEffect(() => {
    let active = true

    const syncSession = async () => {
      const existingSession = getAuthSession()
      if (!existingSession) {
        if (active) {
          setSession(null)
          setChecking(false)
        }
        return
      }

      try {
        const nextSession = await refreshAuthSession()
        if (active) {
          setSession(nextSession)
        }
      } catch (error) {
        if (error instanceof AuthError && (error.status === 401 || error.status === 403)) {
          clearAuthSession()
        }
        if (active) {
          setSession(getAuthSession())
        }
      } finally {
        if (active) {
          setChecking(false)
        }
      }
    }

    syncSession()

    return () => {
      active = false
    }
  }, [location.pathname])

  if (checking) {
    return <div className="min-h-screen bg-gray-50" />
  }

  if (!session) {
    clearAuthSession()
    const reason = localStorage.getItem('keliri_session_expired') === 'true' ? 'session-expired' : 'unauthorized'
    localStorage.removeItem('keliri_session_expired')
    return <Navigate to={`/?reason=${reason}`} replace state={{ from: location.pathname }} />
  }

  return <Outlet />
}
