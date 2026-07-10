import { ArrowDownRight, ArrowUpRight, CheckCircle2, Clock, XCircle, Loader2 } from 'lucide-react'
import { useNavigate } from 'react-router-dom'
import { useEffect, useState } from 'react'
import { fetchAllTransactions, type TransactionRecord } from '../../lib/transactions'

export default function TransactionsTable() {
  const navigate = useNavigate()
  const [loading, setLoading] = useState(true)
  const [data, setData] = useState<TransactionRecord[]>([])

  useEffect(() => {
    async function load() {
      try {
        const txs = await fetchAllTransactions()
        setData(txs.slice(0, 6)) // Show top 6 for the summary table
      } catch (err) {
        console.error("Revenue: Failed to load transactions", err)
      } finally {
        setLoading(false)
      }
    }
    load()
  }, [])

  return (
    <div className="glass-card p-6 animate-fade-in h-full overflow-hidden flex flex-col">
      <div className="flex items-center justify-between mb-5">
        <div>
          <h3 className="text-sm font-semibold text-gray-900">Recent Transactions</h3>
          <p className="text-xs text-gray-400 mt-0.5">Platform payments and payouts</p>
        </div>
        <div className="flex gap-2">
          <button className="bg-gray-50 border border-gray-200 text-gray-600 px-3 py-1.5 rounded-lg text-xs font-semibold hover:bg-gray-100 transition-colors">
            Filter
          </button>
          <button
            onClick={() => navigate('/transactions')}
            className="bg-primary-50 text-primary-600 px-3 py-1.5 rounded-lg text-xs font-semibold hover:bg-primary-100 transition-colors"
          >
            View All
          </button>
        </div>
      </div>

      <div className="overflow-x-auto flex-1">
        {loading ? (
          <div className="flex items-center justify-center h-40">
            <Loader2 className="animate-spin text-primary-500" size={32} />
          </div>
        ) : (
          <table className="w-full text-left border-collapse">
            <thead>
              <tr>
                <th className="text-[10px] font-semibold text-gray-400 uppercase tracking-wider pb-3 border-b border-gray-100">Transaction</th>
                <th className="text-[10px] font-semibold text-gray-400 uppercase tracking-wider pb-3 border-b border-gray-100">Admin</th>
                <th className="text-[10px] font-semibold text-gray-400 uppercase tracking-wider pb-3 border-b border-gray-100">Reference</th>
                <th className="text-[10px] font-semibold text-gray-400 uppercase tracking-wider pb-3 border-b border-gray-100 text-right">Amount</th>
                <th className="text-[10px] font-semibold text-gray-400 uppercase tracking-wider pb-3 border-b border-gray-100 text-center">Status</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-gray-50 text-sm">
              {data.map((tx) => (
                <tr key={tx.id} className="hover:bg-gray-50/50 transition-colors cursor-pointer group">
                  <td className="py-3">
                    <div className="flex items-center gap-3">
                      <div className={`w-8 h-8 rounded-full flex items-center justify-center flex-shrink-0
                        ${tx.incoming ? 'bg-green-50 text-green-500' : 'bg-red-50 text-red-500'}`}>
                        {tx.incoming ? <ArrowDownRight size={14} /> : <ArrowUpRight size={14} />}
                      </div>
                      <div>
                        <p className="font-semibold text-gray-900 leading-none">{tx.id}</p>
                        <p className="text-[11px] text-gray-400 mt-1">{tx.date}</p>
                      </div>
                    </div>
                  </td>
                  <td className="py-3 text-gray-700 font-medium">{tx.admin}</td>
                  <td className="py-3 text-gray-500 text-xs">{tx.type}</td>
                  <td className="py-3 text-right">
                    <span className="font-bold text-gray-900">
                      {tx.incoming ? '+' : '-'}{tx.amount}
                    </span>
                  </td>
                  <td className="py-3 text-center">
                    {tx.status === 'Completed' && (
                      <span className="inline-flex items-center gap-1 bg-green-50 text-green-600 px-2 py-1 rounded-full text-[10px] font-bold uppercase tracking-wide">
                        <CheckCircle2 size={10} /> Completed
                      </span>
                    )}
                    {tx.status === 'Pending' && (
                      <span className="inline-flex items-center gap-1 bg-yellow-50 text-yellow-600 px-2 py-1 rounded-full text-[10px] font-bold uppercase tracking-wide">
                        <Clock size={10} /> Pending
                      </span>
                    )}
                    {tx.status === 'Failed' && (
                      <span className="inline-flex items-center gap-1 bg-red-50 text-red-600 px-2 py-1 rounded-full text-[10px] font-bold uppercase tracking-wide">
                        <XCircle size={10} /> Failed
                      </span>
                    )}
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        )}
      </div>
    </div>
  )
}
