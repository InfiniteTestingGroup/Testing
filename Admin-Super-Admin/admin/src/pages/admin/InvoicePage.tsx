import * as React from "react"
import { useParams, useNavigate } from "react-router-dom"
import { useReactToPrint } from "react-to-print"
import { Download, ArrowLeft, Loader2, FileCheck } from "lucide-react"
import { getInvoiceById } from "../../services/payment"
import type { Invoice } from "../../types/invoice"
import { InvoiceLayout } from "../../components/invoice/InvoiceLayout"

export default function InvoicePage() {
    const { id } = useParams()
    const navigate = useNavigate()
    const [invoice, setInvoice] = React.useState<Invoice | null>(null)
    const [loading, setLoading] = React.useState(true)

    const componentRef = React.useRef<HTMLDivElement>(null)

    // Strict print styles preserve colors, borders, and prevent content cutting in the downloaded PDF
    const handlePrint = useReactToPrint({
        contentRef: componentRef,
        documentTitle: `Invoice_${id || 'Keliri'}`,
        pageStyle: `
          @page {
            size: A4;
            margin: 15mm;
          }
          @media print {
            body {
              -webkit-print-color-adjust: exact !important;
              print-color-adjust: exact !important;
            }
          }
        `,
    })

    React.useEffect(() => {
        async function load() {
            if (!id) return
            try {
                const data = await getInvoiceById(id)
                setInvoice(data)
            } catch (err) {
                console.error("Failed to fetch invoice details", err)
                navigate("/admin/payments")
            } finally {
                setLoading(false)
            }
        }
        load()
    }, [id, navigate])

    if (loading || !invoice) {
        return (
            <div className="min-h-screen bg-gray-50 flex items-center justify-center">
                <Loader2 className="w-10 h-10 text-brand-500 animate-spin" />
            </div>
        )
    }

    return (
        <div className="min-h-screen bg-[#F8F9FB] pb-20 transition-colors duration-200">

            {/* Actions Bar (Hidden in PDF Download) */}
            <div className="sticky top-0 z-50 bg-white/80 backdrop-blur-md border-b border-gray-200 print:hidden">
                <div className="max-w-[850px] mx-auto px-6 py-4 flex items-center justify-between">
                    <button
                        onClick={() => navigate(-1)}
                        className="flex items-center gap-2 text-sm font-bold text-gray-500 hover:text-gray-900 transition-colors"
                    >
                        <ArrowLeft className="w-4 h-4" />
                        Back
                    </button>

                    <div className="flex gap-3">
                        <button
                            onClick={() => handlePrint()}
                            className="flex items-center gap-2 px-5 py-2.5 bg-gray-900 text-white rounded-xl font-bold text-xs uppercase tracking-widest hover:bg-gray-800 transition-all active:scale-95 shadow-lg shadow-gray-900/10"
                        >
                            <Download className="w-4 h-4" />
                            Download PDF
                        </button>
                        {/* Print button removed as requested */}
                    </div>
                </div>
            </div>

            <main className="max-w-[850px] mx-auto mt-12 px-6 animate-fade-in print:mt-0 print:px-0">
                {/* Top Verification Banner (Hidden in PDF Download) */}
                <div className="mb-10 flex items-center justify-between p-6 bg-green-50 rounded-2xl border border-green-100 print:hidden">
                    <div className="flex items-center gap-4">
                        <div className="w-12 h-12 bg-green-500 rounded-full flex items-center justify-center text-white">
                            <FileCheck className="w-6 h-6" />
                        </div>
                        <div>
                            <h2 className="text-green-900 font-bold tracking-tight">Payment Verified</h2>
                            <p className="text-green-700 text-xs font-medium">This document is a valid confirmation of your transaction.</p>
                        </div>
                    </div>
                    <div className="text-right">
                        <p className="text-[10px] font-bold text-green-400 uppercase tracking-widest">Transaction ID</p>
                        <p className="text-xs font-mono font-bold text-green-800 uppercase">{invoice.transactionId}</p>
                    </div>
                </div>

                {/* The actual Invoice Component */}
                <InvoiceLayout ref={componentRef} invoice={invoice} />
            </main>
        </div>
    )
}