import * as React from "react"
import {
  createColumnHelper,
  flexRender,
  getCoreRowModel,
  useReactTable,
  getSortedRowModel,
  type SortingState,
} from "@tanstack/react-table"
import { FileText, MoreHorizontal, ArrowUpDown, ExternalLink, Download } from "lucide-react"
import { useNavigate } from "react-router-dom"
import type { PaymentTransaction } from "../../types/payment"
import { 
  Table, 
  TableBody, 
  TableCell, 
  TableHead, 
  TableHeader, 
  TableRow 
} from "../ui/Table"
import { Badge } from "../ui/Badge"
interface PaymentTableProps {
  data: PaymentTransaction[]
  isLoading: boolean
}
const columnHelper = createColumnHelper<PaymentTransaction>()
export function PaymentTable({ data, isLoading }: PaymentTableProps) {
  const navigate = useNavigate()
  const [sorting, setSorting] = React.useState<SortingState>([])
  const columns = React.useMemo(() => [
    columnHelper.accessor("transactionId", {
      header: "Transaction ID",
      cell: info => <span className="font-mono text-xs font-bold text-gray-500">{info.getValue()}</span>,
    }),
    columnHelper.accessor("adName", {
      header: "Advertisement",
      cell: info => <span className="font-semibold text-gray-900 dark:text-gray-200">{info.getValue()}</span>,
    }),
    columnHelper.accessor("amount", {
      header: ({ column }) => (
        <button
          className="flex items-center gap-1 hover:text-brand-500 transition-colors"
          onClick={() => column.toggleSorting(column.getIsSorted() === "asc")}
        >
          Amount
          <ArrowUpDown className="w-3 h-3" />
        </button>
      ),
      cell: info => <span className="font-black text-gray-900 dark:text-gray-100">₹{info.getValue().toLocaleString()}</span>,
    }),
    columnHelper.accessor("date", {
      header: ({ column }) => (
        <button
          className="flex items-center gap-1 hover:text-brand-500 transition-colors"
          onClick={() => column.toggleSorting(column.getIsSorted() === "asc")}
        >
          Date
          <ArrowUpDown className="w-3 h-3" />
        </button>
      ),
      cell: info => <span className="text-gray-500 dark:text-gray-400 whitespace-nowrap">{info.getValue()}</span>,
    }),
    columnHelper.accessor("status", {
      header: "Status",
      cell: info => {
        const val = info.getValue()
        const variant = val === "Success" ? "success" : val === "Failed" ? "danger" : "warning"
        return <Badge variant={variant}>{val}</Badge>
      },
    }),
    columnHelper.accessor("method", {
      header: "Method",
      cell: info => <span className="text-xs font-medium text-gray-400">{info.getValue()}</span>,
    }),
    columnHelper.display({
      id: "invoice",
      header: "Invoice",
      cell: info => (
        <button 
          onClick={() => navigate(`/admin/invoice/${info.row.original.id}`)}
          className="flex items-center gap-1.5 px-3 py-1.5 text-[10px] font-bold uppercase tracking-wider bg-gray-100 dark:bg-gray-800 text-gray-600 dark:text-gray-400 rounded-lg hover:bg-brand-500 hover:text-white dark:hover:bg-brand-500 dark:hover:text-white transition-all group"
        >
          <Download className="w-3 h-3 transition-transform group-hover:-translate-y-0.5" />
          PDF
        </button>
      ),
    }),
    columnHelper.display({
      id: "actions",
      header: "",
      cell: () => (
        <button className="p-2 text-gray-400 hover:text-brand-500 hover:bg-brand-50 dark:hover:bg-brand-500/10 rounded-lg transition-colors">
          <MoreHorizontal className="w-5 h-5" />
        </button>
      ),
    }),
  ], [])
  const table = useReactTable({
    data,
    columns,
    state: {
      sorting,
    },
    onSortingChange: setSorting,
    getCoreRowModel: getCoreRowModel(),
    getSortedRowModel: getSortedRowModel(),
  })
  if (isLoading) {
    return (
      <div className="bg-white dark:bg-[#1A1D24] rounded-2xl border border-gray-200 dark:border-gray-800 overflow-hidden shadow-sm">
        <div className="animate-pulse">
          <div className="h-12 bg-gray-50 dark:bg-[#1C1F26] border-b border-gray-100 dark:border-gray-800" />
          {[...Array(6)].map((_, i) => (
            <div key={i} className="h-16 border-b border-gray-50 dark:border-gray-800/50 flex items-center px-4 gap-4">
               <div className="w-24 h-4 bg-gray-100 dark:bg-gray-800 rounded" />
               <div className="flex-1 h-4 bg-gray-100 dark:bg-gray-800 rounded" />
               <div className="w-16 h-4 bg-gray-100 dark:bg-gray-800 rounded" />
               <div className="w-20 h-4 bg-gray-100 dark:bg-gray-800 rounded" />
            </div>
          ))}
        </div>
      </div>
    )
  }
  return (
    <div className="bg-white dark:bg-[#1A1D24] rounded-2xl border border-gray-200 dark:border-gray-800 overflow-hidden shadow-sm transition-colors">
      <Table>
        <TableHeader>
          {table.getHeaderGroups().map(headerGroup => (
            <TableRow key={headerGroup.id} className="hover:bg-transparent">
              {headerGroup.headers.map(header => (
                <TableHead key={header.id}>
                  {header.isPlaceholder
                    ? null
                    : flexRender(
                        header.column.columnDef.header,
                        header.getContext()
                      )}
                </TableHead>
              ))}
            </TableRow>
          ))}
        </TableHeader>
        <TableBody>
          {table.getRowModel().rows.length > 0 ? (
            table.getRowModel().rows.map(row => (
              <TableRow key={row.id}>
                {row.getVisibleCells().map(cell => (
                  <TableCell key={cell.id}>
                    {flexRender(cell.column.columnDef.cell, cell.getContext())}
                  </TableCell>
                ))}
              </TableRow>
            ))
          ) : (
            <TableRow>
              <TableCell colSpan={columns.length} className="h-32 text-center text-gray-500">
                No transactions found matching your criteria.
              </TableCell>
            </TableRow>
          )}
        </TableBody>
      </Table>
    </div>
  )
}
