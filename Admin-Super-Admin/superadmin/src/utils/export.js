/**
 * Export data to CSV format
 * @param {Array} data - Array of objects to export
 * @param {Array} columns - Column configuration with key and label
 * @param {string} fileName - Name of the file to save
 */
export const exportToCSV = (data, columns, fileName = 'export') => {
    if (!data || !data.length) return;

    const header = columns.map(col => col.label).join(',');
    const rows = data.map(row => {
        return columns.map(col => {
            let cell = row[col.key] || '';

            // Handle rendering if present (simple text representation)
            if (col.render && typeof col.render === 'function') {
                // This is tricky as render returns JSX. 
                // For basic data, we just use the raw value.
            }

            // Escape quotes and commas
            cell = String(cell).replace(/"/g, '""');
            if (cell.includes(',') || cell.includes('"') || cell.includes('\n')) {
                cell = `"${cell}"`;
            }
            return cell;
        }).join(',');
    });

    const csvContent = [header, ...rows].join('\n');
    const blob = new Blob([csvContent], { type: 'text/csv;charset=utf-8;' });
    const url = URL.createObjectURL(blob);

    const link = document.createElement('a');
    link.setAttribute('href', url);
    link.setAttribute('download', `${fileName}_${new Date().toISOString().split('T')[0]}.csv`);
    link.style.visibility = 'hidden';
    document.body.appendChild(link);
    link.click();
    document.body.removeChild(link);
};
