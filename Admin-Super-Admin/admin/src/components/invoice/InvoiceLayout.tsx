import * as React from "react"
import type { Invoice } from "../../types/invoice"
import { InvoiceTable } from "./InvoiceTable"
import { ShieldCheck, Clock, AlertCircle } from "lucide-react"

// Import the logo image
import keliriLogo from "../../assets/keliriicon.png"

interface InvoiceLayoutProps {
  invoice: Invoice
}

export const InvoiceLayout = React.forwardRef<HTMLDivElement, InvoiceLayoutProps>(
  ({ invoice }, ref) => {
    const isPaid = invoice.status === 'Paid';
    // Using (invoice.status as string) prevents TypeScript errors if your interface uses 'Unpaid' instead of 'Failed'
    const isUnpaidOrFailed = invoice.status === 'Unpaid' || (invoice.status as string) === 'Failed';

    return (
      <div
        ref={ref}
        className="bg-white p-12 md:p-16 w-full max-w-[850px] mx-auto shadow-2xl rounded-sm border border-gray-100 print:shadow-none print:border-none print:p-0 print:w-full print:max-w-none text-gray-900"
      >
        {/* Header */}
        <div className="flex justify-between items-start mb-16">
          <div className="space-y-4">
            <div className="flex items-center gap-3">
              <img
                src={keliriLogo}
                alt="Keliri Logo"
                className="w-12 h-12 object-contain"
              />
              <div>
                <h1 className="text-2xl font-black text-gray-900 tracking-tighter">KELIRI</h1>
                <p className="text-[10px] uppercase tracking-[0.2em] font-bold text-gray-400">Platform Services</p>
              </div>
            </div>
          </div>

          <div className="text-right">
            <h1 className="text-5xl font-black text-gray-200 uppercase tracking-tighter mb-2">Invoice</h1>
            <div className="space-y-1">
              <p className="text-sm font-bold text-gray-900"># {invoice.invoiceNumber}</p>
              <p className="text-xs text-gray-500">Date: {invoice.date}</p>
            </div>
          </div>
        </div>

        {/* Billing Info */}
        <div className="grid grid-cols-2 gap-12 mb-16">
          {/* Left: Seller / FROM */}
          <div>
            <p className="text-[10px] font-black text-gray-400 uppercase tracking-widest mb-4">From</p>
            <div className="space-y-1">
              <p className="text-sm font-bold text-gray-900">{invoice.from.company}</p>
              <p className="text-xs text-gray-500 leading-relaxed max-w-[200px]">{invoice.from.address}</p>
              <p className="text-xs font-medium text-gray-700 pt-2">PAN: {invoice.from.pan}</p>
            </div>
          </div>

          {/* Right: Customer / BILL TO */}
          <div className="text-right">
            <p className="text-[10px] font-black text-gray-400 uppercase tracking-widest mb-4">Bill To</p>
            <div className="space-y-1">
              <p className="text-sm font-bold text-gray-900">{invoice.to.name}</p>
              <p className="text-xs font-semibold text-gray-600">{invoice.to.company}</p>
              <p className="text-xs text-gray-500 leading-relaxed ml-auto max-w-[200px]">{invoice.to.address}</p>
              <p className="text-xs text-gray-700 pt-2">{invoice.to.email}</p>
              <p className="text-xs text-gray-700">{invoice.to.mobile}</p>
            </div>
          </div>
        </div>

        {/* Line Items */}
        <InvoiceTable items={invoice.items} />

        {/* Totals */}
        <div className="mt-8 flex justify-end">
          <div className="w-64 space-y-3">
            <div className="flex justify-between text-sm py-2">
              <span className="text-gray-500">Subtotal</span>
              <span className="text-gray-900 font-medium">₹{invoice.subtotal.toLocaleString()}</span>
            </div>
            <div className="flex justify-between text-sm py-2">
              <span className="text-gray-500">Tax (GST 0%)</span>
              <span className="text-gray-900 font-medium">₹{invoice.tax.toLocaleString()}</span>
            </div>
            <div className="flex justify-between border-t-2 border-gray-900 pt-4">
              <span className="text-base font-black uppercase">Amount {isPaid ? 'Paid' : 'Due'}</span>
              <span className="text-xl font-black text-brand-600 tabular-nums">₹{invoice.total.toLocaleString()}</span>
            </div>
          </div>
        </div>

        {/* Payment Confirmation */}
        <div className="mt-16 pt-8 border-t border-gray-100 grid grid-cols-2 gap-8 items-center">
          <div className="flex items-center gap-3">
            <div className={`w-10 h-10 rounded-full flex items-center justify-center ${isPaid ? 'bg-green-50 text-green-600' :
              isUnpaidOrFailed ? 'bg-red-50 text-red-600' : 'bg-yellow-50 text-yellow-600'
              }`}>
              {isPaid ? <ShieldCheck className="w-5 h-5" /> : isUnpaidOrFailed ? <AlertCircle className="w-5 h-5" /> : <Clock className="w-5 h-5" />}
            </div>
            <div>
              <p className={`text-[10px] font-bold uppercase tracking-widest leading-none ${isPaid ? 'text-green-600' :
                isUnpaidOrFailed ? 'text-red-600' : 'text-yellow-600'
                }`}>Status</p>
              {/* Removed Paid in Full -> Now dynamically shows Paid, Unpaid, or Pending */}
              <p className="text-sm font-black text-gray-900 uppercase">
                {isPaid ? 'Paid' : isUnpaidOrFailed ? 'Unpaid' : 'Pending'}
              </p>
            </div>
          </div>

          <div className="text-right">
            <p className="text-[10px] font-bold text-gray-400 uppercase tracking-widest">Transaction Reference</p>
            <p className="text-xs font-mono font-bold text-gray-600 uppercase">{invoice.transactionId}</p>
            <p className="text-[10px] font-medium text-gray-400 mt-1">via {invoice.paymentMethod}</p>
          </div>
        </div>

        {/* Footer */}
        <div className="mt-20 text-center">
          <p className="text-[11px] text-gray-400 italic">"Thank you for your business. We appreciate your partnership with KELIRI Platform."</p>
          <div className="mt-6 pt-6 border-t border-gray-50 flex justify-center gap-8 text-[9px] font-bold text-gray-400 uppercase tracking-widest">
            <span>keliri.com</span>
            <span>support@keliri.com</span>
            <span>+91 1800-ADS-HELP</span>
          </div>
        </div>
      </div >
    )
  }
)

InvoiceLayout.displayName = "InvoiceLayout"