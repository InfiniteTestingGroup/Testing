export type TicketStatus = "Open" | "In Progress" | "Resolved" | "Closed"
export type TicketCategory = "Technical Issue" | "Payment Issue" | "Ad Issue" | "Other"

export interface Message {
  id: string
  sender: "Admin" | "Super Admin"
  content: string
  timestamp: string
  attachments?: {
    name: string
    url: string
    type: string
  }[]
}

export interface Ticket {
  id: string
  subject: string
  description: string
  category: TicketCategory
  status: TicketStatus
  priority?: "Urgent" | "High" | "Medium" | "Low"
  createdAt: string
  updatedAt: string
  messages: Message[]
}
