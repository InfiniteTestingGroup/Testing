import { TrendingUp, TrendingDown } from 'lucide-react'
import type { TopCreator } from '../../lib/dashboard'

const rankBadge = [
  'bg-yellow-400 text-white',
  'bg-gray-300 text-gray-700',
  'bg-orange-300 text-white',
  'bg-gray-100 text-gray-500',
  'bg-gray-100 text-gray-500',
]

const avatarGradients = [
  'from-orange-300 to-primary-500',
  'from-blue-300 to-blue-500',
  'from-purple-300 to-purple-500',
  'from-teal-300 to-teal-500',
  'from-indigo-300 to-indigo-500',
]

function getInitials(name: string) {
  return name.split(' ').map((n) => n[0]).join('').toUpperCase()
}

interface TopAdminsTableProps {
  creators: TopCreator[]
}

export default function TopAdminsTable({ creators }: TopAdminsTableProps) {
  return (
    <div className="glass-card p-6 animate-fade-in h-full overflow-hidden">
      <div className="flex items-center justify-between mb-5">
        <div>
          <h3 className="text-sm font-semibold text-gray-900">Top Campaign Creators</h3>
          <p className="text-xs text-gray-400 mt-0.5">Who is publishing the most location-based campaigns</p>
        </div>
      </div>

      <div className="overflow-x-auto">
        <table className="w-full">
          <thead>
            <tr>
              <th className="text-[10px] font-semibold text-gray-400 uppercase tracking-wider pb-3 text-left w-8">#</th>
              <th className="text-[10px] font-semibold text-gray-400 uppercase tracking-wider pb-3 text-left">Creator</th>
              <th className="text-[10px] font-semibold text-gray-400 uppercase tracking-wider pb-3 text-right">Campaigns</th>
              <th className="text-[10px] font-semibold text-gray-400 uppercase tracking-wider pb-3 text-center">Active</th>
              <th className="text-[10px] font-semibold text-gray-400 uppercase tracking-wider pb-3 text-center">Locations</th>
              <th className="text-[10px] font-semibold text-gray-400 uppercase tracking-wider pb-3 text-right">Trend</th>
            </tr>
          </thead>
          <tbody>
            {creators.map((creator, i) => (
              <tr
                key={`${creator.email}-${creator.rank}`}
                className="hover:bg-gray-50/70 transition-colors group border-t border-gray-50"
              >
                <td className="py-3 pr-2">
                  <span className={`w-6 h-6 rounded-full text-[11px] font-bold flex items-center justify-center ${rankBadge[i] ?? rankBadge[4]}`}>
                    {creator.rank}
                  </span>
                </td>

                <td className="py-3">
                  <div className="flex items-center gap-2.5">
                    <div className={`w-8 h-8 bg-gradient-to-br ${avatarGradients[i] ?? avatarGradients[4]} rounded-full flex items-center justify-center text-white text-xs font-bold flex-shrink-0`}>
                      {getInitials(creator.name)}
                    </div>
                    <div>
                      <p className="text-sm font-medium text-gray-800 leading-none">{creator.name}</p>
                      <p className="text-[11px] text-gray-400 mt-0.5">{creator.email}</p>
                    </div>
                  </div>
                </td>

                <td className="py-3 text-right">
                  <span className="text-sm font-semibold text-gray-800">{creator.campaignCount}</span>
                </td>

                <td className="py-3 text-center">
                  <span className="text-xs bg-gray-100 text-gray-600 font-medium px-2 py-0.5 rounded-full">
                    {creator.activeCampaignCount}
                  </span>
                </td>

                <td className="py-3 text-center">
                  <span className="text-xs bg-orange-50 text-orange-700 font-medium px-2 py-0.5 rounded-full">
                    {creator.locationCount}
                  </span>
                </td>

                <td className="py-3 text-right">
                  <span className={`inline-flex items-center gap-0.5 text-xs font-semibold ${creator.change >= 0 ? 'text-green-600' : 'text-red-500'}`}>
                    {creator.change >= 0 ? <TrendingUp size={12} /> : <TrendingDown size={12} />}
                    {Math.abs(creator.change)}%
                  </span>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  )
}
