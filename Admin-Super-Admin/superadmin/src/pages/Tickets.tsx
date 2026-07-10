import { useState, useEffect } from 'react';
import { MessageSquare, Clock, AlertTriangle, Send, CheckCircle } from 'lucide-react';
import PageHeader from '../components/shared/PageHeader';
import DataTable from '../components/shared/DataTable';
import StatusBadge from '../components/shared/StatusBadge';
import DetailDrawer from '../components/shared/DetailDrawer';
import FilterBar from '../components/shared/FilterBar';
import TicketThread from '../components/support/TicketThread';
import { getAuthSession, API_BASE_URL } from '../lib/auth';

const formatStatus = (s: string) => {
    if (s === 'IN_PROGRESS') return 'In Progress';
    if (!s) return 'Open';
    return s.charAt(0).toUpperCase() + s.slice(1).toLowerCase();
};

const getPriorityByCategory = (category: string) => {
    if (!category) return 'Medium';
    const cat = category.toUpperCase();
    if (cat.includes('TECHNICAL')) return 'Urgent';
    if (cat.includes('PAYMENT')) return 'High';
    if (cat.includes('AD')) return 'Medium';
    return 'Low';
};

const mapTicketFromServer = (t: any) => ({
    id: t.id,
    subject: t.subject,
    category: t.category,
    priority: getPriorityByCategory(t.category),
    status: formatStatus(t.status),
    userName: `Admin_${t.adminId?.substring(0, 4) || 'Unk'}`,
    userType: 'Admin',
    createdDate: new Date(t.createdAt).toLocaleDateString(),
    createdAtRaw: t.createdAt,
    lastUpdated: new Date(t.updatedAt).toLocaleDateString(),
    messages: [] // Loaded lazily
});

interface TicketData {
    id: string;
    subject: string;
    category: string;
    priority: string;
    status: string;
    userName: string;
    userType: string;
    createdDate: string;
    createdAtRaw: string;
    lastUpdated: string;
    messages: any[];
}

interface TicketFilters {
    status: string | null;
    priority: string[] | null;
    searchTerm: string;
    category: string | null;
    createdDate: string | null;
}

const Tickets = () => {
    const [tickets, setTickets] = useState<TicketData[]>([]);
    const [isLoading, setIsLoading] = useState(true);
    const [selectedTicket, setSelectedTicket] = useState<TicketData | null>(null);
    const [isDrawerLoading, setIsDrawerLoading] = useState(false);
    const [isDrawerOpen, setIsDrawerOpen] = useState(false);
    const [replyText, setReplyText] = useState('');
    const [activeFilters, setActiveFilters] = useState<TicketFilters>({ status: null, priority: null, searchTerm: '', category: null, createdDate: null });
    const [ticketTab, setTicketTab] = useState<'active' | 'closed'>('active');

    const handleTabChange = (tab: 'active' | 'closed') => {
        setTicketTab(tab);
        setActiveFilters(prev => ({ ...prev, status: null }));
    };

    const loadTickets = async () => {
        setIsLoading(true);
        try {
            const session = getAuthSession();
            const res = await fetch(`${API_BASE_URL}/api/superadmin/tickets`, {
                headers: session ? { Authorization: `Bearer ${session.token}` } : {}
            });
            const data = await res.json();
            if (data.success && data.tickets) {
                setTickets(data.tickets.map(mapTicketFromServer));
            }
        } catch (e) {
            console.error(e);
        } finally {
            setIsLoading(false);
        }
    };

    useEffect(() => {
        loadTickets();
    }, []);

    const handleRowClick = async (row: any) => {
        setIsDrawerOpen(true);
        setIsDrawerLoading(true);
        setSelectedTicket({ ...row, messages: [] });

        try {
            const session = getAuthSession();
            const res = await fetch(`${API_BASE_URL}/api/superadmin/tickets/${row.id}`, {
                headers: session ? { Authorization: `Bearer ${session.token}` } : {}
            });
            const data = await res.json();
            if (data.success && data.data && data.data.messages) {
                const activeMsgs = data.data.messages.map((m: any) => ({
                    id: m.id,
                    sender: m.senderType === 'SUPER_ADMIN' ? 'Super Admin' : 'Admin',
                    text: m.message,
                    timestamp: new Date(m.createdAt).toLocaleString(),
                    isMe: m.senderType === 'SUPER_ADMIN'
                }));
                setSelectedTicket(prev => prev ? { ...prev, messages: activeMsgs } : null);
            }
        } catch (e) {
            console.error(e);
        } finally {
            setIsDrawerLoading(false);
        }
    };

    const columns = [
        { key: 'id', label: 'ID', className: 'font-mono text-[10px] font-bold text-gray-400' },
        {
            key: 'subject',
            label: 'Subject',
            render: (val: any, row: any) => (
                <div className="flex flex-col">
                    <span className="font-bold text-gray-900 line-clamp-1">{val}</span>
                    <span className="text-[10px] text-gray-400 font-medium">by {row.userName} ({row.userType})</span>
                </div>
            )
        },
        { key: 'category', label: 'Category', className: 'text-xs font-semibold' },
        { key: 'priority', label: 'Priority', render: (val: string) => <StatusBadge status={val} /> },
        { key: 'status', label: 'Status', render: (val: string) => <StatusBadge status={val} /> },
        { key: 'lastUpdated', label: 'Last Updated', className: 'text-xs font-medium text-gray-400' },
    ];

    const filterOptions = [
        {
            key: 'searchTerm',
            label: 'Quick Search',
            type: 'search',
            appliedValue: activeFilters.searchTerm
        },
        {
            key: 'status',
            label: 'Status',
            type: 'select',
            options: ticketTab === 'active'
                ? [
                    { label: 'Open', value: 'Open' },
                    { label: 'In Progress', value: 'In Progress' }
                  ]
                : [
                    { label: 'Resolved', value: 'Resolved' },
                    { label: 'Closed', value: 'Closed' }
                  ],
            appliedValue: activeFilters.status
        },
        {
            key: 'category',
            label: 'Category',
            type: 'select',
            options: [
                { label: 'Technical Issue', value: 'TECHNICAL_ISSUE' },
                { label: 'Payment Issue', value: 'PAYMENT_ISSUE' },
                { label: 'Ad Issue', value: 'AD_ISSUE' },
                { label: 'Other', value: 'OTHER' }
            ],
            appliedValue: activeFilters.category
        },
        {
            key: 'createdDate',
            label: 'Created Date',
            type: 'date',
            appliedValue: activeFilters.createdDate
        },
        {
            key: 'priority',
            label: 'Priority',
            type: 'checkbox',
            options: [
                { label: 'Urgent', value: 'Urgent' },
                { label: 'High', value: 'High' },
                { label: 'Medium', value: 'Medium' },
                { label: 'Low', value: 'Low' }
            ],
            appliedValue: activeFilters.priority
        }
    ];

    const filteredData = tickets.filter(ticket => {
        const isClosed = ticket.status === 'Resolved' || ticket.status === 'Closed';
        if (ticketTab === 'active' && isClosed) return false;
        if (ticketTab === 'closed' && !isClosed) return false;

        if (activeFilters.status && ticket.status !== activeFilters.status) return false;
        if (activeFilters.category && ticket.category !== activeFilters.category) return false;
        if (activeFilters.priority && !activeFilters.priority.includes(ticket.priority)) return false;
        if (activeFilters.searchTerm && !ticket.subject.toLowerCase().includes(activeFilters.searchTerm.toLowerCase()) && !ticket.id.toLowerCase().includes(activeFilters.searchTerm.toLowerCase())) return false;
        if (activeFilters.createdDate) {
            const d = new Date(ticket.createdAtRaw);
            const year = d.getFullYear();
            const month = String(d.getMonth() + 1).padStart(2, '0');
            const day = String(d.getDate()).padStart(2, '0');
            const ticketLocalDate = `${year}-${month}-${day}`;
            if (ticketLocalDate !== activeFilters.createdDate) return false;
        }
        return true;
    });

    const handleFilterChange = (key: keyof TicketFilters, value: any) => {
        setActiveFilters(prev => ({ ...prev, [key]: value }));
    };

    const handleSendReply = async () => {
        if (!replyText.trim() || !selectedTicket) return;

        try {
            const session = getAuthSession();
            const res = await fetch(`${API_BASE_URL}/api/superadmin/tickets/${selectedTicket.id}/reply`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    ...(session ? { Authorization: `Bearer ${session.token}` } : {})
                },
                body: JSON.stringify({ message: replyText })
            });

            const data = await res.json();
            if (data.success && data.message) {
                const newMessage = {
                    id: data.message.id,
                    sender: 'Super Admin',
                    text: data.message.message,
                    timestamp: new Date(data.message.createdAt).toLocaleString(),
                    isMe: true
                };

                const newStatus = selectedTicket.status === 'Open' ? 'In Progress' : selectedTicket.status;

                const updatedTicket = {
                    ...selectedTicket,
                    messages: [...selectedTicket.messages, newMessage],
                    lastUpdated: 'Just now',
                    status: newStatus
                };

                setTickets(prev => prev.map(t => t.id === selectedTicket.id ? updatedTicket : t));
                setSelectedTicket(updatedTicket);
                setReplyText('');
            }
        } catch (e) {
            console.error(e);
        }
    };

    const handleStatusChange = async (newStatusText: string) => {
        if (!selectedTicket) return;
        try {
            const serverStatus = newStatusText.replace(' ', '_').toUpperCase();
            const session = getAuthSession();
            const res = await fetch(`${API_BASE_URL}/api/superadmin/tickets/${selectedTicket.id}/status`, {
                method: 'PATCH',
                headers: {
                    'Content-Type': 'application/json',
                    ...(session ? { Authorization: `Bearer ${session.token}` } : {})
                },
                body: JSON.stringify({ status: serverStatus })
            });
            const data = await res.json();
            if (data.success) {
                const updated = { ...selectedTicket, status: newStatusText };
                setTickets(prev => prev.map(t => t.id === selectedTicket.id ? updated : t));
                setSelectedTicket(updated);
            }
        } catch (e) {
            console.error(e);
        }
    };

    const kpis = [
        { label: 'Pending Response', value: tickets.filter(t => t.status === 'Open').length, icon: MessageSquare, color: 'text-blue-600', bg: 'bg-blue-50' },
        { label: 'In Progress', value: tickets.filter(t => t.status === 'In Progress').length, icon: Clock, color: 'text-amber-600', bg: 'bg-amber-50' },
        { label: 'Urgent Action', value: tickets.filter(t => t.priority === 'Urgent').length, icon: AlertTriangle, color: 'text-rose-600', bg: 'bg-rose-50' },
        { label: 'Resolved', value: tickets.filter(t => t.status === 'Resolved').length, icon: CheckCircle, color: 'text-emerald-600', bg: 'bg-emerald-50' },
    ];

    return (
        <div className="pb-10 space-y-8 animate-fade-in px-4 sm:px-0">
            <div className="animate-fade-in-scale">
                <PageHeader
                    title="Tickets & Support"
                    subtitle="Manage administrative queries and technical support requests from the KELIRI ecosystem"
                    actions={null}
                />
            </div>

            {/* Support KPIs */}
            <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4 animate-fade-in-scale delay-75">
                {kpis.map((kpi, idx) => (
                    <div key={idx} className="bg-white p-5 rounded-[2rem] border border-gray-100 shadow-sm flex items-center gap-4 group hover:shadow-lg transition-all">
                        <div className={`p-4 rounded-2xl ${kpi.bg} ${kpi.color} group-hover:scale-110 transition-transform`}>
                            <kpi.icon size={24} />
                        </div>
                        <div>
                            <p className="text-[10px] font-black text-gray-400 uppercase tracking-[0.15em] mb-0.5">{kpi.label}</p>
                            <p className="text-2xl font-black text-gray-900 tracking-tight">{kpi.value}</p>
                        </div>
                    </div>
                ))}
            </div>

            {/* Ticket Category Tabs */}
            <div className="flex items-center gap-1 bg-gray-100/50 p-1 rounded-2xl w-fit animate-fade-in-scale delay-100">
                <button
                    onClick={() => handleTabChange('active')}
                    className={`flex items-center gap-2 px-5 py-2.5 rounded-xl text-xs font-black uppercase tracking-widest transition-all ${
                        ticketTab === 'active' ? 'bg-white text-primary-600 shadow-sm' : 'text-gray-500 hover:text-gray-900'
                    }`}
                >
                    <Clock size={14} />
                    Active Tickets
                </button>
                <button
                    onClick={() => handleTabChange('closed')}
                    className={`flex items-center gap-2 px-5 py-2.5 rounded-xl text-xs font-black uppercase tracking-widest transition-all ${
                        ticketTab === 'closed' ? 'bg-white text-primary-600 shadow-sm' : 'text-gray-500 hover:text-gray-900'
                    }`}
                >
                    <CheckCircle size={14} />
                    Closed Tickets
                </button>
            </div>

            {/* Main Content Card */}
            <div className="bg-white rounded-[2.5rem] border border-gray-100 shadow-sm overflow-hidden animate-fade-in-scale delay-150">
                <FilterBar
                    filters={filterOptions}
                    onFilterChange={handleFilterChange}
                    onReset={() => setActiveFilters({ status: null, priority: null, searchTerm: '', category: null, createdDate: null })}
                    activeFiltersCount={Object.values(activeFilters).filter(Boolean).length}
                />
                <DataTable
                    columns={columns}
                    data={filteredData}
                    isLoading={isLoading}
                    onRowClick={handleRowClick}
                    exportFileName="support_tickets"
                />
            </div>

            {/* Ticket Deep-Dive Drawer */}
            <DetailDrawer
                isOpen={isDrawerOpen}
                onClose={() => setIsDrawerOpen(false)}
                title={`Ticket: ${selectedTicket?.id}`}
                footerActions={
                    <select
                        className="bg-gray-100 border-none rounded-xl px-3 py-1.5 text-[10px] font-black uppercase tracking-widest text-gray-700 focus:ring-0 cursor-pointer"
                        value={selectedTicket?.status}
                        onChange={(e) => handleStatusChange(e.target.value)}
                    >
                        <option value="Open">Status: Open</option>
                        <option value="In Progress">Status: In Progress</option>
                        <option value="Resolved">Status: Resolved</option>
                        <option value="Closed">Status: Closed</option>
                    </select>
                }
            >
                {selectedTicket && (
                    <div className="flex flex-col h-full space-y-8 animate-fade-in">
                        {/* Summary Header */}
                        <div className="bg-white p-6 rounded-[2rem] border border-gray-100 shadow-sm space-y-4">
                            <div className="flex items-start justify-between">
                                <div className="space-y-1">
                                    <h3 className="text-xl font-black text-gray-900 tracking-tight">{selectedTicket.subject}</h3>
                                    <p className="text-xs font-semibold text-primary-500 uppercase tracking-wider">{selectedTicket.category.replace('_', ' ')} Query</p>
                                </div>
                                <StatusBadge status={selectedTicket.priority} />
                            </div>

                            <div className="pt-4 border-t border-gray-50 flex items-center justify-between gap-4">
                                <div className="flex items-center gap-2">
                                    <div className="w-8 h-8 rounded-full bg-indigo-100 flex items-center justify-center text-xs font-bold text-indigo-700 uppercase">
                                        {selectedTicket.userName.charAt(0)}
                                    </div>
                                    <div className="flex flex-col">
                                        <span className="text-sm font-black text-gray-900">{selectedTicket.userName}</span>
                                        <span className="text-[10px] font-bold text-gray-400 capitalize">{selectedTicket.userType} Account</span>
                                    </div>
                                </div>
                                <div className="text-right">
                                    <p className="text-[10px] font-bold text-gray-400 uppercase tracking-widest">Created On</p>
                                    <p className="text-xs font-black text-gray-900">{selectedTicket.createdDate}</p>
                                </div>
                            </div>
                        </div>

                        {/* Thread View */}
                        <div className="flex-1 space-y-4">
                            <h4 className="text-[10px] font-black text-gray-400 uppercase tracking-[0.2em] px-1">Conversation History</h4>
                            <div className="bg-gray-50/50 rounded-[2rem] p-6 border border-gray-50">
                                {isDrawerLoading ? (
                                    <div className="text-center text-sm text-gray-400">Loading conversation...</div>
                                ) : (
                                    <TicketThread messages={selectedTicket.messages} />
                                )}
                            </div>
                        </div>

                        {/* Quick Reply Box */}
                        <div className="bg-white p-4 rounded-[1.5rem] border border-gray-100 shadow-xl shadow-primary-500/5 sticky bottom-0">
                            <div className="relative">
                                <textarea
                                    className="w-full bg-gray-50 border-none rounded-2xl p-4 text-sm font-medium focus:ring-2 focus:ring-primary-500/10 placeholder:text-gray-400 resize-none no-scrollbar"
                                    placeholder="Type your reply here..."
                                    rows={3}
                                    value={replyText}
                                    onChange={(e) => setReplyText(e.target.value)}
                                />
                                <button
                                    onClick={handleSendReply}
                                    disabled={!replyText.trim()}
                                    className="absolute bottom-3 right-3 p-3 bg-primary-600 text-white rounded-xl shadow-lg shadow-primary-600/20 active:scale-90 transition-all disabled:opacity-50 disabled:cursor-not-allowed"
                                >
                                    <Send size={18} />
                                </button>
                            </div>
                        </div>
                    </div>
                )}
            </DetailDrawer>
        </div>
    );
};

export default Tickets;
