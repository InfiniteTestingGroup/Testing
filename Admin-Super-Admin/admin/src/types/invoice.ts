export interface InvoiceItem {
  id: string
  description: string
  quantity: number
  rate: number
  amount: number
}

export interface Invoice {
  invoiceNumber: string
  date: string
  transactionId: string
  paymentMethod: string
  status: "Paid" | "Pending" | "Unpaid"

  from: {
    company: string
    address: string
    pan: string
  }

  to: {
    name: string
    company: string
    address: string
    email: string
    mobile: string
  }

  items: InvoiceItem[]

  subtotal: number
  tax: number
  total: number
}