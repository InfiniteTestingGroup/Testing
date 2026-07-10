import { api } from './api'
import type { Ticket, Message, TicketStatus, TicketCategory } from "../types/ticket"

const formatStatus = (str: string): TicketStatus => {
  if (!str) return 'Open';
  const s = str.toUpperCase();
  if (s === 'IN_PROGRESS') return 'In Progress';
  if (s === 'RESOLVED') return 'Resolved';
  if (s === 'CLOSED') return 'Closed';
  return 'Open';
};

const getPriorityByCategory = (category: string) => {
  if (!category) return 'Medium';
  const cat = category.toUpperCase();
  if (cat.includes('TECHNICAL')) return 'Urgent';
  if (cat.includes('PAYMENT')) return 'High';
  if (cat.includes('AD')) return 'Medium';
  return 'Low';
};

const formatCategory = (cat: string): TicketCategory => {
  if (!cat) return 'Other';
  const c = cat.toUpperCase();
  if (c.includes('TECHNICAL')) return 'Technical Issue';
  if (c.includes('PAYMENT')) return 'Payment Issue';
  if (c.includes('AD')) return 'Ad Issue';
  return 'Other';
};

export const fetchTickets = async (filters?: { status?: string; category?: string; query?: string }): Promise<Ticket[]> => {
  const response = await api.get('/api/admin/tickets')
  let tickets = response.data.tickets || []
  
  if (filters?.status && filters.status !== "All") {
    const rawStatus = filters.status === "In Progress" ? "IN_PROGRESS" : filters.status.toUpperCase()
    tickets = tickets.filter((t: any) => t.status === rawStatus)
  }
  if (filters?.category && filters.category !== "All") {
    // If frontend filter sends "Technical Issue", backend might be "TECHNICAL"
    const catSearch = filters.category.toUpperCase().replace(' ISSUE', '')
    tickets = tickets.filter((t: any) => (t.category || '').toUpperCase().includes(catSearch))
  }
  if (filters?.query) {
    const q = filters.query.toLowerCase()
    tickets = tickets.filter((t: any) => (t.subject || '').toLowerCase().includes(q) || t.id.toLowerCase().includes(q))
  }
  
  return tickets.map((t: any) => ({
    id: t.id,
    subject: t.subject,
    description: "Support Ticket",
    category: formatCategory(t.category),
    status: formatStatus(t.status),
    priority: getPriorityByCategory(t.category),
    createdAt: t.createdAt,
    updatedAt: t.updatedAt,
    messages: []
  }))
}

export const getTicketById = async (id: string): Promise<Ticket | null> => {
  try {
    const response = await api.get(`/api/admin/tickets/${id}`)
    const { ticket, messages } = response.data.data
    
    return {
      id: ticket.id,
      subject: ticket.subject,
      description: messages.length > 0 ? messages[0].message : "Support Ticket",
      category: formatCategory(ticket.category),
      status: formatStatus(ticket.status),
      priority: getPriorityByCategory(ticket.category),
      createdAt: ticket.createdAt,
      updatedAt: ticket.updatedAt,
      messages: messages.map((m: any) => ({
        id: m.id,
        sender: m.senderType === 'ADMIN' ? 'Admin' : 'Super Admin',
        content: m.message,
        timestamp: m.createdAt
      }))
    }
  } catch (error) {
    console.error("Failed to load ticket", error)
    return null;
  }
}

export const createTicket = async (data: { subject: string; category: TicketCategory; description: string }): Promise<Ticket> => {
  const response = await api.post('/api/admin/tickets', {
    subject: data.subject,
    category: data.category.toUpperCase().replace(' ISSUE', '').replace(' ', '_'),
    message: data.description
  })
  const t = response.data.ticket
  return {
    id: t.id,
    subject: t.subject,
    description: data.description,
    category: formatCategory(t.category),
    status: formatStatus(t.status),
    priority: getPriorityByCategory(t.category),
    createdAt: t.createdAt,
    updatedAt: t.updatedAt,
    messages: []
  }
}

export const replyToTicket = async (ticketId: string, content: string): Promise<Message> => {
  const response = await api.post(`/api/admin/tickets/${ticketId}/reply`, {
    message: content
  })
  const m = response.data.message
  return {
    id: m.id,
    sender: m.senderType === 'ADMIN' ? 'Admin' : 'Super Admin',
    content: m.message,
    timestamp: m.createdAt
  }
}

export const reopenTicket = async (ticketId: string): Promise<void> => {
  await api.patch(`/api/admin/tickets/${ticketId}/reopen`)
}
