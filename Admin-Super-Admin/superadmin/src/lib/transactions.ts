import { API_BASE_URL, AuthError, getAuthSession } from './auth'

export interface TransactionRecord {
    id: string
    date: string
    admin: string
    type: string
    amount: string
    status: 'Completed' | 'Pending' | 'Failed'
    incoming: boolean
    transactionId: string
    publisherName?: string
    adminId?: string
    latitude?: string
    longitude?: string
}

// Extracted so fetchAllTransactions and fetchTransactionById stay in sync
function mapTransaction(t: any): TransactionRecord {
    return {
        id: t.id || `TXN-${t.reference?.slice(-4) || 'XXXX'}`,
        date: t.date ? new Date(t.date).toLocaleString('en-IN', {
            day: '2-digit',
            month: 'short',
            year: 'numeric',
            hour: '2-digit',
            minute: '2-digit'
        }) : 'N/A',
        admin: t.adminName || "System",
        type: t.reference || "Platform Payment",
        amount: `₹${(t.amount || 0).toLocaleString()}`,
        status: t.status || 'Pending',
        incoming: t.incoming ?? true,
        transactionId: t.reference || t.id,
        publisherName: t.publisherName || undefined,
        adminId: t.adminId || undefined,
        latitude: t.latitude || undefined,
        longitude: t.longitude || undefined
    }
}

export async function fetchAllTransactions(): Promise<TransactionRecord[]> {
    const session = getAuthSession()

    const response = await fetch(`${API_BASE_URL}/api/superadmin/payments`, {
        headers: session?.token ? { Authorization: `Bearer ${session.token}` } : {}
    })

    const payload = await response.json().catch(() => ({}))
    const data = payload.data || (Array.isArray(payload) ? payload : [])

    if (!response.ok) {
        throw new AuthError(payload.message || 'Unable to fetch transactions', response.status)
    }

    return data.map(mapTransaction)
}

// New: single indexed lookup instead of fetching + filtering the whole collection
export async function fetchTransactionById(transactionId: string): Promise<TransactionRecord | null> {
    const session = getAuthSession()

    const response = await fetch(
        `${API_BASE_URL}/api/superadmin/payments/transaction/${encodeURIComponent(transactionId)}`,
        { headers: session?.token ? { Authorization: `Bearer ${session.token}` } : {} }
    )

    if (response.status === 404) return null

    const payload = await response.json().catch(() => ({}))

    if (!response.ok) {
        throw new AuthError(payload.message || 'Unable to fetch transaction', response.status)
    }

    const raw = payload.data || payload
    return raw ? mapTransaction(raw) : null
}