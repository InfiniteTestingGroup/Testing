import type { Invoice } from "../types/invoice";
import { API_BASE_URL, getAuthSession } from "./auth";
import { fetchTransactionById } from "./transactions";
import { fetchAdminDetail } from "./management";

function authHeaders(): Record<string, string> {
    const session = getAuthSession();
    return session?.token ? { Authorization: `Bearer ${session.token}` } : {};
}

export async function getInvoiceByTransactionId(transactionId: string): Promise<Invoice> {
    // 1. Fetch the single transaction record directly (was: fetch all + client-side find)
    const txn = await fetchTransactionById(transactionId).catch(() => null);

    const amountStr = txn?.amount?.replace(/[₹,]/g, "") || "0";
    const amount = parseFloat(amountStr) || 0;
    const rzpTxnId = txn?.transactionId || transactionId;
    const statusStr =
        txn?.status === "Completed"
            ? "Paid"
            : txn?.status === "Failed"
                ? "Failed"
                : "Pending";

    // 2. Fetch admin billing details
    const adminDetail = txn?.adminId
        ? await fetchAdminDetail(txn.adminId).catch(() => null)
        : null;

    const billToName =
        adminDetail?.registration?.authorizedPerson ||
        adminDetail?.name ||
        txn?.admin ||
        "Admin";

    const billToCompany =
        adminDetail?.company ||
        (adminDetail?.registration as any)?.companyName ||
        "Keliri Admin Account";

    const billToAddress =
        adminDetail?.registration?.businessAddress ||
        adminDetail?.businessAddress ||
        "";

    const billToEmail = adminDetail?.email || "Not available";

    const billToMobile =
        adminDetail?.registration?.mobileNumber ||
        adminDetail?.phone ||
        "Not available";

    return {
        invoiceNumber: `INV-${rzpTxnId.slice(-6).toUpperCase()}`,
        date: txn?.date || new Date().toISOString().split("T")[0],
        transactionId: rzpTxnId,
        paymentMethod: "Razorpay Checkout",
        status: statusStr as any,

        from: {
            company: "Jackfruit Software Labs Pvt. Ltd.",
            address:
                "No.473, 16th Main, Poornapragna Layout, Uttarahalli, Bangalore, Karnataka, India, 560061",
            pan: "AADCJ7471Q",
        },

        to: {
            name: billToName,
            company: billToCompany,
            address: billToAddress,
            email: billToEmail,
            mobile: billToMobile,
        },

        items: [
            {
                id: "1",
                description: "Advertisement Placement System",
                quantity: 1,
                rate: amount,
                amount: amount,
            },
        ],

        subtotal: amount,
        tax: 0,
        total: amount,
    };
}