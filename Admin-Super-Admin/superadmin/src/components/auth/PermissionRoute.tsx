import { Navigate, Outlet, useLocation } from 'react-router-dom'
import { hasModuleAccess } from '../../lib/auth'
import type { PermissionKey } from '../../lib/auth'

interface PermissionRouteProps {
  permission: PermissionKey
}

export default function PermissionRoute({ permission }: PermissionRouteProps) {
  const location = useLocation()

  if (!hasModuleAccess(permission)) {
    return <Navigate to="/?reason=forbidden" replace state={{ from: location.pathname }} />
  }

  return <Outlet />
}
