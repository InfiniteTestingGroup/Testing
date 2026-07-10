import * as React from "react"
import type { InvoiceItem } from "../../types/invoice"

interface InvoiceTableProps {
  items: InvoiceItem[]
}

export function InvoiceTable({ items }: InvoiceTableProps) {
  return (
    <div className="w-full overflow-hidden rounded-lg border border-gray-200">
      <table className="w-full text-left text-sm">
        <thead className="bg-gray-50 border-b border-gray-200">
          <tr>
            <th className="px-6 py-4 font-bold text-gray-900">Description</th>
            <th className="px-6 py-4 font-bold text-gray-900 text-center">Qty</th>
            <th className="px-6 py-4 font-bold text-gray-900 text-right">Rate</th>
            <th className="px-6 py-4 font-bold text-gray-900 text-right">Amount</th>
          </tr>
        </thead>
        <tbody className="divide-y divide-gray-100 bg-white">
          {items.map((item) => (
            <tr key={item.id} className="hover:bg-gray-50/50 transition-colors">
              <td className="px-6 py-5 text-gray-700 font-medium">
                {item.description}
              </td>
              <td className="px-6 py-5 text-gray-600 text-center">
                {item.quantity}
              </td>
              <td className="px-6 py-5 text-gray-600 text-right tabular-nums">
                ₹{item.rate.toLocaleString()}
              </td>
              <td className="px-6 py-5 text-gray-900 font-bold text-right tabular-nums">
                ₹{item.amount.toLocaleString()}
              </td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  )
}
