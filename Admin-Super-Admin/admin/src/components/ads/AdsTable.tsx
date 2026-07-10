import * as React from "react"
import {
  type ColumnDef,
  flexRender,
  getCoreRowModel,
  useReactTable,
} from "@tanstack/react-table"
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from "../ui/Table"
import { Badge } from "../ui/Badge"
import { Eye, Edit2, Send, Copy, Archive } from "lucide-react"
import type { Advertisement } from "../../services/ads"
import { Skeleton } from "../ui/Skeleton"
import { AnimatePresence } from "framer-motion"

interface AdsTableProps {
  data: Advertisement[]
  loading: boolean
  totalItems: number
  page: number
  limit: number
  onPageChange: (p: number) => void
  onLimitChange: (l: number) => void
  onView: (id: string) => void
  onEdit: (id: string) => void
  onPublish: (id: string, title: string) => void
  onDuplicate: (id: string, title: string) => void
  onArchive: (id: string, title: string) => void
}

export function AdsTable({
  data, loading, totalItems, page, limit,
  onPageChange, onLimitChange,
  onView, onEdit, onPublish, onDuplicate, onArchive
}: AdsTableProps) {

  const columns = React.useMemo<ColumnDef<Advertisement>[]>(() => [
    {
      accessorKey: "title",
      header: "Ad Title",
      cell: ({ row }) => {
        const ad = row.original
        return (
          <div>
            <div className="font-semibold text-gray-900 dark:text-white">{ad.title}</div>
            <div className="text-xs text-gray-500 dark:text-gray-400 mt-0.5">{ad.id}</div>
          </div>
        )
      }
    },
    {
      accessorKey: "publishers",
      header: "Publisher(s)",
      cell: ({ row }) => {
        const pubs = row.original.publishers
        return (
          <div className="flex flex-col gap-1">
            {pubs.map(p => (
              <span key={p} className="text-sm border border-gray-200 dark:border-gray-800 bg-gray-50 dark:bg-[#1A1D24] px-2 py-0.5 rounded-md truncate max-w-[150px]" title={p}>
                {p}
              </span>
            ))}
          </div>
        )
      }
    },
    {
      accessorKey: "status",
      header: "Status",
      cell: ({ row }) => {
        const s = row.original.status
        if (s === "Active") return <Badge variant="success">Active</Badge>
        if (s === "Pending") return <Badge variant="warning">Pending</Badge>
        if (s === "Suspended") return <Badge variant="danger" className="bg-red-800 text-red-100">Suspended</Badge>
        if (s === "Expired") return <Badge variant="danger">Expired</Badge>
        return <Badge variant="neutral">Draft</Badge>
      }
    },
    {
      header: "Timeline",
      cell: ({ row }) => (
        <div className="text-sm text-gray-600 dark:text-gray-300">
          <div>{row.original.startDate}</div>
          <div className="text-gray-400">- {row.original.endDate}</div>
        </div>
      )
    },
    {
      accessorKey: "impressions",
      header: "Metrics",
      cell: ({ row }) => {
        const imp = row.original.impressions
        const clk = row.original.clicks
        const ctr = row.original.ctr
        return (
          <div className="text-right flex items-center gap-4">
            <div>
              <p className="text-xs text-gray-500">Imp.</p>
              <p className="font-medium text-gray-900 dark:text-gray-200">{imp > 0 ? imp.toLocaleString() : "-"}</p>
            </div>
            <div>
              <p className="text-xs text-gray-500">Clicks</p>
              <p className="font-medium text-gray-900 dark:text-gray-200">{clk > 0 ? clk.toLocaleString() : "-"}</p>
            </div>
            <div>
              <p className="text-xs text-brand-500">CTR</p>
              <p className="font-bold text-brand-600 dark:text-brand-400">{ctr > 0 ? `${ctr}%` : "-"}</p>
            </div>
          </div>
        )
      }
    },
    {
      accessorKey: "paymentStatus",
      header: "Payment",
      cell: ({ row }) => {
        const ps = row.original.paymentStatus
        return (
          <span className={`inline-flex items-center px-2 py-0.5 rounded text-xs font-semibold
             ${ps === "Paid" ? 'bg-green-100 text-green-700 dark:bg-green-500/20 dark:text-green-400' :
              ps === "Pending" ? 'bg-amber-100 text-amber-700 dark:bg-amber-500/20 dark:text-amber-400' :
                'bg-red-100 text-red-700 dark:bg-red-500/20 dark:text-red-400'
            }
           `}>
            {ps}
          </span>
        )
      }
    },
    {
      id: "actions",
      header: "Actions",
      cell: ({ row }) => {
        const ad = row.original
        const isDraft = ad.status === "Draft"

        return (
          <div className="flex items-center gap-2">
            <button
              onClick={() => onView(ad.id)}
              className="p-1.5 text-gray-400 hover:text-brand-600 dark:hover:text-brand-400 hover:bg-brand-50 dark:hover:bg-brand-500/10 rounded-md transition-colors"
              title="View Details"
            >
              <Eye className="w-[18px] h-[18px]" />
            </button>
            <button
              onClick={() => isDraft && onEdit(ad.id)}
              disabled={!isDraft}
              className={`p-1.5 rounded-md transition-colors ${isDraft
                ? "text-gray-400 hover:text-blue-600 hover:bg-blue-50 dark:hover:text-blue-400 dark:hover:bg-blue-500/10"
                : "text-gray-300 dark:text-gray-700 cursor-not-allowed"
                }`}
              title={isDraft ? "Edit Ad" : "Cannot edit non-draft ads"}
            >
              <Edit2 className="w-[18px] h-[18px]" />
            </button>
            <button
              onClick={() => isDraft && onPublish(ad.id, ad.title)}
              disabled={!isDraft}
              className={`p-1.5 rounded-md transition-colors ${isDraft
                ? "text-gray-400 hover:text-emerald-600 hover:bg-emerald-50 dark:hover:text-emerald-400 dark:hover:bg-emerald-500/10"
                : "text-gray-300 dark:text-gray-700 cursor-not-allowed"
                }`}
              title={isDraft ? "Publish Ad" : "Ad already active or expired"}
            >
              <Send className="w-[18px] h-[18px]" />
            </button>

            <button
              onClick={() => onDuplicate(ad.id, ad.title)}
              className="p-1.5 text-gray-400 hover:text-indigo-600 dark:hover:text-indigo-400 hover:bg-indigo-50 dark:hover:bg-indigo-500/10 rounded-md transition-colors"
              title="Duplicate Ad"
            >
              <Copy className="w-[18px] h-[18px]" />
            </button>
            <button
              onClick={() => onArchive(ad.id, ad.title)}
              className="p-1.5 text-gray-400 hover:text-red-600 dark:hover:text-red-400 hover:bg-red-50 dark:hover:bg-red-500/10 rounded-md transition-colors"
              title="Archive Ad"
            >
              <Archive className="w-[18px] h-[18px]" />
            </button>
          </div>
        )
      }
    }
  ], [onView, onEdit, onPublish, onDuplicate, onArchive])

  const table = useReactTable({
    data,
    columns,
    getCoreRowModel: getCoreRowModel()
  })

  const totalPages = Math.max(1, Math.ceil(totalItems / limit))

  return (
    <div className="space-y-4">
      <div className="rounded-2xl border border-gray-200 dark:border-gray-800 bg-white dark:bg-[#1A1D24] shadow-sm overflow-hidden">
        <div className="overflow-x-auto">
          <Table>
            <TableHeader>
              {table.getHeaderGroups().map((group) => (
                <TableRow key={group.id}>
                  {group.headers.map((header) => (
                    <TableHead key={header.id} className="whitespace-nowrap">
                      {header.isPlaceholder ? null : flexRender(header.column.columnDef.header, header.getContext())}
                    </TableHead>
                  ))}
                </TableRow>
              ))}
            </TableHeader>
            <TableBody>
              {loading ? (
                Array.from({ length: Math.min(limit, 10) }).map((_, i) => (
                  <TableRow key={i}>
                    {columns.map((_, col) => (
                      <TableCell key={col}><Skeleton className="h-6 w-full max-w-[100px]" /></TableCell>
                    ))}
                  </TableRow>
                ))
              ) : table.getRowModel().rows?.length ? (
                <AnimatePresence>
                  {table.getRowModel().rows.map(row => (
                    <TableRow key={row.id}>
                      {row.getVisibleCells().map(cell => (
                        <TableCell key={cell.id} className="text-gray-600 dark:text-gray-300">
                          {flexRender(cell.column.columnDef.cell, cell.getContext())}
                        </TableCell>
                      ))}
                    </TableRow>
                  ))}
                </AnimatePresence>
              ) : (
                <TableRow>
                  <TableCell colSpan={columns.length} className="h-48 text-center bg-white dark:bg-[#1A1D24]">
                    <div className="flex flex-col items-center justify-center text-gray-500 dark:text-gray-400">
                      <p className="text-lg font-medium mb-1">No ads found</p>
                      <p className="text-sm">Create an ad or adjust your filters.</p>
                    </div>
                  </TableCell>
                </TableRow>
              )}
            </TableBody>
          </Table>
        </div>
      </div>

      {/* Pagination */}
      <div className="flex flex-col sm:flex-row items-center justify-between gap-4 px-2">
        <div className="flex items-center gap-2 text-sm text-gray-500 dark:text-gray-400 font-medium">
          <span>Rows per page:</span>
          <select
            value={limit}
            onChange={(e) => {
              onPageChange(1)
              onLimitChange(Number(e.target.value))
            }}
            className="h-8 rounded-md border border-gray-200 bg-white px-2 py-1 text-sm focus-visible:outline-none focus-[color-scheme:dark] dark:border-gray-800 dark:bg-[#1C1F26] dark:text-white"
          >
            {[10, 25, 50].map((sz) => (
              <option key={sz} value={sz}>{sz}</option>
            ))}
          </select>
        </div>

        <div className="flex items-center gap-4">
          <span className="text-sm text-gray-500 dark:text-gray-400 font-medium">
            Showing {(page - 1) * limit + 1} to {Math.min(page * limit, totalItems)} of {totalItems} results
          </span>

          <span className="text-sm text-gray-500 dark:text-gray-400 font-medium">
            Page {page} of {totalPages}
          </span>

          <div className="flex items-center gap-1.5">
            <button
              onClick={() => onPageChange(page - 1)}
              disabled={page <= 1 || loading}
              className="px-3 py-1.5 rounded-md border border-gray-200 bg-white text-sm font-medium text-gray-700 hover:bg-gray-50 disabled:opacity-50 dark:border-gray-800 dark:bg-[#1C1F26] dark:text-gray-300 dark:hover:bg-gray-800 transition-colors"
            >
              Previous
            </button>
            <button
              onClick={() => onPageChange(page + 1)}
              disabled={page >= totalPages || loading}
              className="px-3 py-1.5 rounded-md border border-gray-200 bg-white text-sm font-medium text-gray-700 hover:bg-gray-50 disabled:opacity-50 dark:border-gray-800 dark:bg-[#1C1F26] dark:text-gray-300 dark:hover:bg-gray-800 transition-colors"
            >
              Next
            </button>
          </div>
        </div>
      </div>
    </div>
  )
}
