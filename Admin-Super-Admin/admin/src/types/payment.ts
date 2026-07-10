export interface RazorpayOrder {
  id: string
  amount: number
  currency: string
  keyId: string
}

export interface PaymentTransaction {
  id: string
  transactionId: string
  adName: string
  amount: number
  status: "Success" | "Failed" | "Pending"
  method: string
  date: string
  invoiceUrl: string
}
