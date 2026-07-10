import * as React from "react"
import {
  type ColumnDef,
  flexRender,
  getCoreRowModel,
  useReactTable,
} from "@tanstack/react-table"
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from "../ui/Table"
import { Badge } from "../ui/Badge"
import { Eye, Edit2, Power, PowerOff } from "lucide-react"
import type { Publisher } from "../../services/publishers"
import { Skeleton } from "../ui/Skeleton"
import { useNavigate } from "react-router-dom"
import { AnimatePresence } from "framer-motion"

interface PublisherTableProps {
  data: Publisher[]
  loading: boolean
  onToggleStatus: (id: string, name: string, isCurrentlyActive: boolean) => void
  totalItems: number
  page: number
  limit: number
  onPageChange: (page: number) => void
  onLimitChange: (limit: number) => void
}

export function PublisherTable({
  data,
  loading,
  onToggleStatus,
  totalItems,
  page,
  limit,
  onPageChange,
  onLimitChange,
}: PublisherTableProps) {
  const navigate = useNavigate()

  const columns = React.useMemo<ColumnDef<Publisher>[]>(
    () => [
      {
        accessorKey: "name",
        header: "Publisher Name",
        cell: ({ row }) => (
          <div className="font-semibold text-gray-900 dark:text-white">
            {row.getValue("name")}
          </div>
        ),
      },
      {
        accessorKey: "contactPerson",
        header: "Contact",
      },
      {
        accessorKey: "mobile",
        header: "Mobile",
      },
      {
        accessorKey: "email",
        header: "Email",
      },
      {
        accessorKey: "location",
        header: "Location",
      },
      {
        accessorKey: "status",
        header: "Status",
        cell: ({ row }) => {
          const status = row.getValue("status") as string
          return (
            <Badge variant={status === "Active" ? "success" : "neutral"}>
              {status}
            </Badge>
          )
        },
      },
      {
        accessorKey: "lastActive",
        header: "Last Active",
        cell: ({ row }) => {
           return <span className="text-gray-500 dark:text-gray-400 text-xs">{row.getValue("lastActive")}</span>
        }
      },
      {
        id: "actions",
        header: "Actions",
        cell: ({ row }) => {
          const publisher = row.original
          const isActive = publisher.status === "Active"
          
          return (
            <div className="flex items-center gap-3">
              <button
                onClick={() => navigate(`/admin/publishers/${publisher.id}`)}
                className="p-1.5 text-gray-400 hover:text-brand-600 dark:text-gray-500 dark:hover:text-brand-400 rounded-md hover:bg-brand-50 dark:hover:bg-brand-500/10 transition-colors"
                title="View Details"
              >
                <Eye className="w-[18px] h-[18px]" />
              </button>
              <button
                onClick={() => navigate(`/admin/publishers/${publisher.id}/edit`)}
                className="p-1.5 text-gray-400 hover:text-blue-600 dark:text-gray-500 dark:hover:text-blue-400 rounded-md hover:bg-blue-50 dark:hover:bg-blue-500/10 transition-colors"
                title="Edit"
              >
                <Edit2 className="w-[18px] h-[18px]" />
              </button>
              <button
                onClick={() => onToggleStatus(publisher.id, publisher.name, isActive)}
                className={`p-1.5 rounded-md transition-colors ${
                  isActive 
                    ? "text-gray-400 hover:text-red-500 dark:text-gray-500 dark:hover:text-red-400 hover:bg-red-50 dark:hover:bg-red-900/20" 
                    : "text-gray-400 hover:text-green-500 dark:text-gray-500 dark:hover:text-green-400 hover:bg-green-50 dark:hover:bg-green-900/20"
                }`}
                title={isActive ? "Deactivate" : "Activate"}
              >
                {isActive ? <PowerOff className="w-[18px] h-[18px]" /> : <Power className="w-[18px] h-[18px]" />}
              </button>
            </div>
          )
        },
      },
    ],
    [navigate, onToggleStatus]
  )

  const table = useReactTable({
    data,
    columns,
    getCoreRowModel: getCoreRowModel(),
  })

  // We should safely calculate total pages. If loading, rely on current passed totalItems to avoid flicker, or just fallback safely
  const totalPages = Math.ceil(totalItems / limit) || 1

  return (
    <div className="space-y-4">
      <div className="rounded-2xl border border-gray-200 dark:border-gray-800 bg-white dark:bg-[#1A1D24] shadow-sm overflow-hidden">
        <Table>
          <TableHeader>
            {table.getHeaderGroups().map((headerGroup) => (
              <TableRow key={headerGroup.id}>
                {headerGroup.headers.map((header) => {
                  return (
                    <TableHead key={header.id}>
                      {header.isPlaceholder
                        ? null
                        : flexRender(
                            header.column.columnDef.header,
                            header.getContext()
                          )}
                    </TableHead>
                  )
                })}
              </TableRow>
            ))}
          </TableHeader>
          <TableBody>
            {loading ? (
              // Skeleton rows matching the page limits
              Array.from({ length: limit }).map((_, idx) => (
                <TableRow key={`skeleton-${idx}`}>
                  {columns.map((_, colIdx) => (
                    <TableCell key={`cell-${idx}-${colIdx}`}>
                      <Skeleton className="h-5 w-full max-w-[120px]" />
                    </TableCell>
                  ))}
                </TableRow>
              ))
            ) : table.getRowModel().rows?.length ? (
              <AnimatePresence>
                {table.getRowModel().rows.map((row) => (
                  <TableRow
                    key={row.id}
                    data-state={row.getIsSelected() && "selected"}
                  >
                    {row.getVisibleCells().map((cell) => (
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
                    <p className="text-lg font-medium mb-1">No publishers found</p>
                    <p className="text-sm">Try adjusting your filters or search query.</p>
                  </div>
                </TableCell>
              </TableRow>
            )}
          </TableBody>
        </Table>
      </div>

      {/* Pagination Controls */}
      <div className="flex flex-col sm:flex-row items-center justify-between gap-4 px-2">
        <div className="flex items-center gap-2 text-sm text-gray-500 dark:text-gray-400 font-medium">
          <span>Rows per page:</span>
          <select
            value={limit}
            onChange={(e) => {
              onPageChange(1) // reset to page 1 on limit change
              onLimitChange(Number(e.target.value))
            }}
            className="h-8 rounded-md border border-gray-200 bg-white px-2 py-1 text-sm focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-brand-500 dark:border-gray-800 dark:bg-[#1C1F26] dark:text-white"
          >
            {[10, 25, 50].map((pageSize) => (
              <option key={pageSize} value={pageSize}>
                {pageSize}
              </option>
            ))}
          </select>
        </div>

        <div className="flex items-center gap-4">
          <span className="text-sm text-gray-500 dark:text-gray-400 font-medium">
            Page {page} of {totalPages}
          </span>
          <div className="flex items-center gap-1.5">
            <button
              onClick={() => onPageChange(page - 1)}
              disabled={page <= 1 || loading}
              className="px-3 py-1.5 rounded-md border border-gray-200 bg-white text-sm font-medium text-gray-700 hover:bg-gray-50 disabled:opacity-50 disabled:cursor-not-allowed dark:border-gray-800 dark:bg-[#1C1F26] dark:text-gray-300 dark:hover:bg-gray-800 transition-colors shadow-sm"
            >
              Previous
            </button>
            <button
              onClick={() => onPageChange(page + 1)}
              disabled={page >= totalPages || loading}
              className="px-3 py-1.5 rounded-md border border-gray-200 bg-white text-sm font-medium text-gray-700 hover:bg-gray-50 disabled:opacity-50 disabled:cursor-not-allowed dark:border-gray-800 dark:bg-[#1C1F26] dark:text-gray-300 dark:hover:bg-gray-800 transition-colors shadow-sm"
            >
              Next
            </button>
          </div>
        </div>
      </div>
    </div>
  )
}
