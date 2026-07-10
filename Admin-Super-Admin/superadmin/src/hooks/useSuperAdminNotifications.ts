import { useCallback, useEffect, useMemo, useState } from 'react'
import { useLocation } from 'react-router-dom'
import { API_BASE_URL, getAuthSession } from '../lib/auth'
import { fetchAdmins, fetchSuperAdminTickets, type AdminRecord } from '../lib/management'

export type SuperAdminNotificationType =
    | 'admin_pending'
    | 'ticket_raised'
    | 'ticket_replied'

export interface SuperAdminNotification {
    id: string
    type: SuperAdminNotificationType
    title: string
    message: string
    time: string
    timestamp: number
    unread: boolean
    entityId?: string
}

interface TicketRecord {
    id?: string
    _id?: string
    ticketId?: string
    subject?: string
    title?: string
    description?: string
    status?: string
    adminId?: string
    adminName?: string
    company?: string
    companyName?: string
    createdByName?: string
    raisedBy?: string
    raisedByRole?: string
    createdByRole?: string
    userType?: string
    role?: string
    createdAt?: string
    created_at?: string
    updatedAt?: string
    updated_at?: string
    timestamp?: string
}

interface TicketMessageRecord {
    id?: string
    _id?: string
    message?: string
    text?: string
    senderType?: string
    sender?: string
    senderRole?: string
    createdAt?: string
    created_at?: string
    timestamp?: string
}

interface TicketDetailRecord extends TicketRecord {
    messages?: TicketMessageRecord[]
}

const DISMISSED_KEY = 'superadmin_dismissed_notifications'
const ONE_DAY_MS = 24 * 60 * 60 * 1000

function getDismissedIds(): string[] {
    try {
        const value = localStorage.getItem(DISMISSED_KEY)
        return value ? JSON.parse(value) : []
    } catch {
        return []
    }
}

function saveDismissedIds(ids: string[]) {
    localStorage.setItem(DISMISSED_KEY, JSON.stringify(Array.from(new Set(ids))))
}

function authHeaders(): Record<string, string> {
    const session = getAuthSession()
    return session ? { Authorization: `Bearer ${session.token}` } : {}
}

function isDateOnly(value: string): boolean {
    return !/[tT]\d{2}:\d{2}|\d{1,2}:\d{2}/.test(value)
}

function parseDateOnlyAsLocalStart(value: string, fallback: number): number {
    const isoMatch = value.match(/^(\d{4})-(\d{1,2})-(\d{1,2})/)
    if (isoMatch) {
        const [, year, month, day] = isoMatch
        return new Date(Number(year), Number(month) - 1, Number(day), 0, 0, 0, 0).getTime()
    }

    const indianMatch = value.match(/^(\d{1,2})\/(\d{1,2})\/(\d{4})/)
    if (indianMatch) {
        const [, day, month, year] = indianMatch
        return new Date(Number(year), Number(month) - 1, Number(day), 0, 0, 0, 0).getTime()
    }

    const parsed = new Date(value).getTime()
    return Number.isFinite(parsed) ? parsed : fallback
}

function toTime(value: string | undefined, fallback = 0): number {
    if (!value) return fallback
    const time = new Date(value).getTime()
    return Number.isFinite(time) ? time : fallback
}

function getAdminCreatedTime(admin: AdminRecord, now: number): number {
    const adminAny = admin as AdminRecord & {
        createdAt?: string
        created_at?: string
        submittedAt?: string
        timestamp?: string
    }

    const raw =
        adminAny.createdAt ??
        adminAny.created_at ??
        adminAny.submittedAt ??
        adminAny.timestamp ??
        admin.registeredDate

    if (!raw) return now
    if (isDateOnly(raw)) return parseDateOnlyAsLocalStart(raw, now)

    return toTime(raw, now)
}

function getTicketId(ticket: TicketRecord): string {
    return String(ticket.id ?? ticket._id ?? ticket.ticketId ?? '')
}

function getTicketCreatedTime(ticket: TicketRecord): number {
    return toTime(ticket.createdAt ?? ticket.created_at ?? ticket.timestamp ?? ticket.updatedAt, Date.now())
}

function getTicketUpdatedTime(ticket: TicketRecord): number {
    return toTime(ticket.updatedAt ?? ticket.updated_at ?? ticket.timestamp, 0)
}

function getMessageId(message: TicketMessageRecord): string {
    return String(message.id ?? message._id ?? '')
}

function getMessageTime(message: TicketMessageRecord): number {
    return toTime(message.createdAt ?? message.created_at ?? message.timestamp, 0)
}

function isSuperAdminMessage(message: TicketMessageRecord): boolean {
    const value = String(message.senderType ?? message.senderRole ?? message.sender ?? '').toUpperCase()
    return value.includes('SUPER_ADMIN') || value.includes('SUPER ADMIN')
}

function isAdminMessage(message: TicketMessageRecord): boolean {
    const value = String(message.senderType ?? message.senderRole ?? message.sender ?? '').toUpperCase()
    return value.includes('ADMIN') && !isSuperAdminMessage(message)
}

function getMessageText(message: TicketMessageRecord): string {
    return message.message ?? message.text ?? 'Admin replied on this ticket.'
}

function normalizeTickets(result: unknown): TicketRecord[] {
    if (Array.isArray(result)) return result as TicketRecord[]

    const data = result as {
        data?: TicketRecord[]
        tickets?: TicketRecord[]
        content?: TicketRecord[]
        items?: TicketRecord[]
    } | null

    if (Array.isArray(data?.data)) return data.data
    if (Array.isArray(data?.tickets)) return data.tickets
    if (Array.isArray(data?.content)) return data.content
    if (Array.isArray(data?.items)) return data.items

    return []
}

async function fetchTicketDetail(ticketId: string): Promise<TicketDetailRecord | null> {
    try {
        const response = await fetch(`${API_BASE_URL}/api/superadmin/tickets/${ticketId}`, {
            headers: authHeaders(),
        })

        const payload = await response.json().catch(() => null)

        if (!response.ok || !payload?.success) return null

        return payload.data ?? null
    } catch {
        return null
    }
}

function isAdminPage(pathname: string): boolean {
    return pathname.toLowerCase().includes('/admins')
}

function isTicketPage(pathname: string): boolean {
    const path = pathname.toLowerCase()
    return path.includes('/tickets') || path.includes('/support')
}

export function useSuperAdminNotifications() {
    const location = useLocation()
    const [notifications, setNotifications] = useState<SuperAdminNotification[]>([])
    const [loading, setLoading] = useState(true)

    const dismissByType = useCallback((type: SuperAdminNotificationType) => {
        setNotifications((prev) => {
            const idsToDismiss = prev
                .filter((notification) => notification.type === type)
                .map((notification) => notification.id)

            if (idsToDismiss.length > 0) {
                saveDismissedIds([...getDismissedIds(), ...idsToDismiss])
            }

            return prev.filter((notification) => notification.type !== type)
        })
    }, [])

    const dismissTicketNotifications = useCallback(() => {
        setNotifications((prev) => {
            const idsToDismiss = prev
                .filter(
                    (notification) =>
                        notification.type === 'ticket_raised' || notification.type === 'ticket_replied',
                )
                .map((notification) => notification.id)

            if (idsToDismiss.length > 0) {
                saveDismissedIds([...getDismissedIds(), ...idsToDismiss])
            }

            return prev.filter(
                (notification) =>
                    notification.type !== 'ticket_raised' && notification.type !== 'ticket_replied',
            )
        })
    }, [])

    const loadNotifications = useCallback(async () => {
        setLoading(true)

        try {
            const now = Date.now()
            const dismissedIds = getDismissedIds()

            const [adminsResult, ticketsResult] = await Promise.all([
                fetchAdmins({ status: 'Pending' }).catch(() => []),
                fetchSuperAdminTickets().catch(() => []),
            ])

            const list: SuperAdminNotification[] = []
            const tickets = normalizeTickets(ticketsResult)

            adminsResult.forEach((admin) => {
                const status = String(admin.status ?? '').toLowerCase()
                if (status !== 'pending') return

                const notificationId = `admin-pending-${admin.id}`
                if (dismissedIds.includes(notificationId)) return

                const createdTime = getAdminCreatedTime(admin, now)
                if (now - createdTime > ONE_DAY_MS) return

                list.push({
                    id: notificationId,
                    type: 'admin_pending',
                    title: 'New admin pending approval',
                    message: `${admin.name || admin.company || 'New admin'} registered and is waiting for approval.`,
                    time: new Date(createdTime).toISOString(),
                    timestamp: createdTime,
                    unread: true,
                    entityId: admin.id,
                })
            })

            await Promise.all(
                tickets.map(async (ticket) => {
                    const ticketId = getTicketId(ticket)
                    if (!ticketId) return

                    const createdTime = getTicketCreatedTime(ticket)
                    const updatedTime = getTicketUpdatedTime(ticket)
                    const subject = ticket.subject ?? ticket.title ?? 'Support ticket'
                    const adminName =
                        ticket.adminName ??
                        ticket.companyName ??
                        ticket.company ??
                        ticket.createdByName ??
                        ticket.raisedBy ??
                        (ticket.adminId ? `Admin_${ticket.adminId.substring(0, 4)}` : 'Admin')

                    const raisedNotificationId = `ticket-raised-${ticketId}`
                    if (
                        now - createdTime <= ONE_DAY_MS &&
                        !dismissedIds.includes(raisedNotificationId)
                    ) {
                        list.push({
                            id: raisedNotificationId,
                            type: 'ticket_raised',
                            title: 'New support ticket raised',
                            message: `${adminName} raised a ticket: "${subject}".`,
                            time: new Date(createdTime).toISOString(),
                            timestamp: createdTime,
                            unread: true,
                            entityId: ticketId,
                        })
                    }

                    // Admin reply detection is based on conversation history from ticket detail API.
                    // /api/superadmin/tickets list does not include messages, so checking updatedAt alone is not enough.
                    if (!updatedTime || updatedTime <= createdTime || now - updatedTime > ONE_DAY_MS) return

                    const detail = await fetchTicketDetail(ticketId)
                    const messages = detail?.messages ?? []
                    if (messages.length === 0) return

                    const latestMessage = [...messages].sort((a, b) => getMessageTime(b) - getMessageTime(a))[0]
                    if (!latestMessage || !isAdminMessage(latestMessage)) return

                    const latestMessageTime = getMessageTime(latestMessage)
                    if (!latestMessageTime || latestMessageTime <= createdTime || now - latestMessageTime > ONE_DAY_MS) return

                    const messageId = getMessageId(latestMessage)
                    const repliedNotificationId = `ticket-replied-${ticketId}-${messageId || latestMessageTime}`
                    if (dismissedIds.includes(repliedNotificationId)) return

                    list.push({
                        id: repliedNotificationId,
                        type: 'ticket_replied',
                        title: 'Admin replied to ticket',
                        message: `${adminName} replied on ticket "${subject}": "${getMessageText(latestMessage)}"`,
                        time: new Date(latestMessageTime).toISOString(),
                        timestamp: latestMessageTime,
                        unread: true,
                        entityId: ticketId,
                    })
                }),
            )

            const idsToDismissBecauseCurrentPage: string[] = []
            const visibleList = list.filter((notification) => {
                if (isAdminPage(location.pathname) && notification.type === 'admin_pending') {
                    idsToDismissBecauseCurrentPage.push(notification.id)
                    return false
                }

                if (
                    isTicketPage(location.pathname) &&
                    (notification.type === 'ticket_raised' || notification.type === 'ticket_replied')
                ) {
                    idsToDismissBecauseCurrentPage.push(notification.id)
                    return false
                }

                return true
            })

            if (idsToDismissBecauseCurrentPage.length > 0) {
                saveDismissedIds([...getDismissedIds(), ...idsToDismissBecauseCurrentPage])
            }

            visibleList.sort((a, b) => b.timestamp - a.timestamp)
            setNotifications(visibleList)
        } finally {
            setLoading(false)
        }
    }, [location.pathname])

    useEffect(() => {
        loadNotifications()

        const intervalId = window.setInterval(loadNotifications, 60_000)
        return () => window.clearInterval(intervalId)
    }, [])

    useEffect(() => {
        if (isAdminPage(location.pathname)) {
            dismissByType('admin_pending')
        }

        if (isTicketPage(location.pathname)) {
            dismissTicketNotifications()
        }
    }, [dismissByType, dismissTicketNotifications, location.pathname])

    const unreadCount = useMemo(() => notifications.length, [notifications])

    const markRead = useCallback((id: string) => {
        const notification = notifications.find((item) => item.id === id)

        if (notification?.type === 'admin_pending') {
            dismissByType('admin_pending')
            return
        }

        if (notification?.type === 'ticket_raised' || notification?.type === 'ticket_replied') {
            dismissTicketNotifications()
            return
        }

        saveDismissedIds([...getDismissedIds(), id])
        setNotifications((prev) => prev.filter((item) => item.id !== id))
    }, [dismissByType, dismissTicketNotifications, notifications])

    return {
        notifications,
        unreadCount,
        loading,
        reload: loadNotifications,
        markRead,
        dismissByType,
        dismissTicketNotifications,
    }
}
