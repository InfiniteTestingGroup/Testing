import * as React from "react"
import { 
  createColumnHelper, 
  flexRender, 
  getCoreRowModel, 
  useReactTable,
  getSortedRowModel,
  type SortingState
} from "@tanstack/react-table"
import { Eye, RotateCcw, ArrowUpDown, Clock, MoreHorizontal } from "lucide-react"
import { useNavigate } from "react-router-dom"
import type { Ticket } from "../../types/ticket"
import { 
  Table, 
  TableBody, 
  TableCell, 
  TableHead, 
  TableHeader, 
  TableRow 
} from "../ui/Table"
import { Badge } from "../ui/Badge"

interface TicketTableProps {
  data: Ticket[]
  isLoading: boolean
  onReopen: (id: string) => void
}

const columnHelper = createColumnHelper<Ticket>()

export function TicketTable({ data, isLoading, onReopen }: TicketTableProps) {
  const navigate = useNavigate()
  const [sorting, setSorting] = React.useState<SortingState>([])

  const columns = React.useMemo(() => [
    columnHelper.accessor("id", {
      header: ({ column }) => (
        <button 
          className="flex items-center gap-1 hover:text-brand-500 transition-colors"
          onClick={() => column.toggleSorting(column.getIsSorted() === "asc")}
        >
          Ticket ID
          <ArrowUpDown className="w-3 h-3" />
        </button>
      ),
      cell: info => <span className="font-mono font-bold text-gray-400 uppercase">{info.getValue()}</span>,
    }),
    columnHelper.accessor("subject", {
      header: "Subject",
      cell: info => (
        <div className="max-w-[300px]">
          <p className="font-bold text-gray-900 dark:text-white truncate">{info.getValue()}</p>
          <p className="text-[10px] text-gray-400 truncate opacity-60 font-medium">{info.row.original.description}</p>
        </div>
      ),
    }),
    columnHelper.accessor("category", {
      header: "Category",
      cell: info => (
         <span className="text-xs font-semibold text-gray-500 bg-gray-100 dark:bg-gray-800 px-2 py-1 rounded-md">
            {info.getValue()}
         </span>
      ),
    }),
    columnHelper.accessor("priority", {
      header: "Priority",
      cell: info => {
        const priority = info.getValue() || "Medium"
        const variant = priority === "Urgent" ? "danger" : priority === "High" ? "warning" : priority === "Medium" ? "info" : "success"
        return (
          <Badge variant={variant as any} className="uppercase tracking-[0.1em] text-[9px] font-black py-1 px-3">
            {priority}
          </Badge>
        )
      },
    }),
    columnHelper.accessor("status", {
      header: "Status",
      cell: info => {
        const status = info.getValue()
        const variant = status === "Open" ? "info" : status === "In Progress" ? "warning" : "success"
        return (
          <Badge variant={variant as any} className="uppercase tracking-[0.1em] text-[9px] font-black py-1 px-3">
            {status}
          </Badge>
        )
      },
    }),
    columnHelper.accessor("createdAt", {
      header: "Created",
      cell: info => (
        <div className="flex flex-col">
          <span className="text-xs font-bold text-gray-700 dark:text-gray-300">
            {new Date(info.getValue()).toLocaleDateString()}
          </span>
          <span className="text-[10px] text-gray-400 font-medium">
            {new Date(info.getValue()).toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' })}
          </span>
        </div>
      ),
    }),
    columnHelper.display({
      id: "actions",
      header: "Actions",
      cell: info => (
        <div className="flex items-center gap-2">
           <button
             onClick={() => navigate(`/admin/tickets/${info.row.original.id}`)}
             className="p-2 hover:bg-brand-50 dark:hover:bg-brand-500/10 text-brand-600 transition-all rounded-xl group"
             title="View Conversation"
           >
             <Eye className="w-4 h-4 transition-transform group-hover:scale-110" />
           </button>
           {info.row.original.status === "Resolved" && (
             <button
                onClick={() => onReopen(info.row.original.id)}
                className="p-2 hover:bg-amber-50 dark:hover:bg-amber-500/10 text-amber-600 transition-all rounded-xl group"
                title="Re-open Ticket"
             >
               <RotateCcw className="w-4 h-4 transition-transform group-hover:rotate-180 duration-500" />
             </button>
           )}
        </div>
      ),
    }),
  ], [navigate, onReopen])

  const table = useReactTable({
    data,
    columns,
    state: { sorting },
    onSortingChange: setSorting,
    getCoreRowModel: getCoreRowModel(),
    getSortedRowModel: getSortedRowModel(),
  })

  return (
    <div className="bg-white dark:bg-[#1A1D24] p-2 rounded-[2rem] border border-gray-100 dark:border-gray-800 shadow-sm overflow-hidden transition-colors">
      <Table>
        <TableHeader>
          {table.getHeaderGroups().map(headerGroup => (
            <TableRow key={headerGroup.id} className="hover:bg-transparent border-none">
              {headerGroup.headers.map(header => (
                <TableHead key={header.id} className="text-[10px] font-black uppercase tracking-[0.2em] text-gray-400 py-6 px-6">
                  {flexRender(header.column.columnDef.header, header.getContext())}
                </TableHead>
              ))}
            </TableRow>
          ))}
        </TableHeader>
        <TableBody>
          {isLoading ? (
            Array.from({ length: 5 }).map((_, i) => (
              <TableRow key={i}>
                {columns.map((_, j) => (
                  <TableCell key={j} className="py-6 px-6">
                    <div className="h-4 bg-gray-100 dark:bg-gray-800 rounded animate-pulse w-2/3" />
                  </TableCell>
                ))}
              </TableRow>
            ))
          ) : table.getRowModel().rows.length > 0 ? (
            table.getRowModel().rows.map(row => (
              <TableRow key={row.id} className="group hover:bg-gray-50/50 dark:hover:bg-gray-800/20 border-gray-50 dark:border-gray-800/50 transition-colors">
                {row.getVisibleCells().map(cell => (
                  <TableCell key={cell.id} className="py-6 px-6">
                    {flexRender(cell.column.columnDef.cell, cell.getContext())}
                  </TableCell>
                ))}
              </TableRow>
            ))
          ) : (
            <TableRow>
              <TableCell colSpan={columns.length} className="h-64 text-center">
                <div className="flex flex-col items-center justify-center gap-3">
                   <Clock className="w-12 h-12 text-gray-200 dark:text-gray-800" />
                   <p className="text-sm font-bold text-gray-400">No support tickets found</p>
                </div>
              </TableCell>
            </TableRow>
          )}
        </TableBody>
      </Table>
    </div>
  )
}
