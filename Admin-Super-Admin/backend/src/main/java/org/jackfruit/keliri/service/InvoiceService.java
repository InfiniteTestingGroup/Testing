package org.jackfruit.keliri.service;

import com.lowagie.text.*;
import com.lowagie.text.pdf.*;
import org.springframework.stereotype.Service;

import java.io.ByteArrayOutputStream;
import java.time.Instant;
import java.time.format.DateTimeFormatter;
import java.time.ZoneId;
import java.awt.Color;

@Service
public class InvoiceService {

    public byte[] generatePdfInvoice(String transactionId, String adName, double amount, String adminName) {
        try (ByteArrayOutputStream out = new ByteArrayOutputStream()) {
            Document document = new Document(PageSize.A4, 50, 50, 50, 50);
            PdfWriter.getInstance(document, out);
            document.open();

            // Font definitions
            Font brandFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 24, new Color(0, 67, 105));
            Font invoiceTitleFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 28, new Color(50, 50, 50));
            Font boldHeaderFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 11, new Color(80, 80, 80));
            Font normalFont = FontFactory.getFont(FontFactory.HELVETICA, 10, new Color(100, 100, 100));
            Font tableHeaderFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 10, Color.WHITE);
            Font tableBodyFont = FontFactory.getFont(FontFactory.HELVETICA, 10, new Color(50, 50, 50));
            Font totalFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 14, new Color(0, 67, 105));

            // Header block
            PdfPTable headerTable = new PdfPTable(2);
            headerTable.setWidthPercentage(100);
            headerTable.setWidths(new float[] { 1f, 1f });

            // Company info (Left)
            PdfPCell leftHeader = new PdfPCell();
            leftHeader.setBorder(Rectangle.NO_BORDER);
            leftHeader.addElement(new Paragraph("KELIRI", brandFont));
            leftHeader.addElement(new Paragraph("Keliri Platform Services", boldHeaderFont));
            leftHeader.addElement(new Paragraph("123 Business Park, Tech Zone", normalFont));
            leftHeader.addElement(new Paragraph("Gurgaon, Haryana - 122003", normalFont));
            leftHeader.addElement(new Paragraph("GST: 06AAAAA0000A1Z5", normalFont));
            headerTable.addCell(leftHeader);

            // Invoice text (Right)
            PdfPCell rightHeader = new PdfPCell();
            rightHeader.setBorder(Rectangle.NO_BORDER);
            rightHeader.setHorizontalAlignment(Element.ALIGN_RIGHT);
            Paragraph invoiceLabel = new Paragraph("INVOICE", invoiceTitleFont);
            invoiceLabel.setAlignment(Element.ALIGN_RIGHT);
            rightHeader.addElement(invoiceLabel);

            String dateStr = DateTimeFormatter.ofPattern("MMM dd, yyyy").withZone(ZoneId.systemDefault())
                    .format(Instant.now());
            Paragraph dateLabel = new Paragraph("Date: " + dateStr, normalFont);
            dateLabel.setAlignment(Element.ALIGN_RIGHT);
            rightHeader.addElement(dateLabel);

            Paragraph txnLabel = new Paragraph("Reference: " + transactionId, normalFont);
            txnLabel.setAlignment(Element.ALIGN_RIGHT);
            rightHeader.addElement(txnLabel);
            headerTable.addCell(rightHeader);

            document.add(headerTable);

            // Separator
            document.add(new Paragraph("\n"));
            PdfPTable line = new PdfPTable(1);
            line.setWidthPercentage(100);
            PdfPCell lineCell = new PdfPCell();
            lineCell.setBorder(Rectangle.BOTTOM);
            lineCell.setBorderColor(new Color(220, 220, 220));
            lineCell.setBorderWidth(1f);
            line.addCell(lineCell);
            document.add(line);
            document.add(new Paragraph("\n"));

            // Billed To
            PdfPTable billedTable = new PdfPTable(1);
            billedTable.setWidthPercentage(100);
            PdfPCell billedCell = new PdfPCell();
            billedCell.setBorder(Rectangle.NO_BORDER);
            billedCell.addElement(new Paragraph("BILLED TO", boldHeaderFont));
            billedCell.addElement(new Paragraph(adminName, tableBodyFont));
            billedCell.addElement(new Paragraph("Admin Advertiser", normalFont));
            billedTable.addCell(billedCell);
            document.add(billedTable);
            document.add(new Paragraph("\n\n"));

            // Invoice Items Table
            PdfPTable itemTable = new PdfPTable(4);
            itemTable.setWidthPercentage(100);
            itemTable.setWidths(new float[] { 0.5f, 3f, 1f, 1f });

            // Table Headers
            String[] headers = { "#", "Description", "Rate", "Amount" };
            for (String h : headers) {
                PdfPCell hCell = new PdfPCell(new Phrase(h, tableHeaderFont));
                hCell.setBackgroundColor(new Color(0, 67, 105));
                hCell.setPadding(8f);
                hCell.setBorder(Rectangle.NO_BORDER);
                if (!h.equals("Description"))
                    hCell.setHorizontalAlignment(Element.ALIGN_RIGHT);
                itemTable.addCell(hCell);
            }

            // Table Data Item 1
            PdfPCell cell1 = new PdfPCell(new Phrase("1", tableBodyFont));
            cell1.setPadding(8f);
            cell1.setBorderColor(new Color(230, 230, 230));
            cell1.setHorizontalAlignment(Element.ALIGN_RIGHT);
            itemTable.addCell(cell1);

            PdfPCell cell2 = new PdfPCell(new Phrase(
                    "Advertisement Placement: " + adName + "\nStatus: Paid (Razorpay Checkout)", tableBodyFont));
            cell2.setPadding(8f);
            cell2.setBorderColor(new Color(230, 230, 230));
            itemTable.addCell(cell2);

            PdfPCell cell3 = new PdfPCell(new Phrase("INR " + String.format("%.2f", amount), tableBodyFont));
            cell3.setPadding(8f);
            cell3.setBorderColor(new Color(230, 230, 230));
            cell3.setHorizontalAlignment(Element.ALIGN_RIGHT);
            itemTable.addCell(cell3);

            PdfPCell cell4 = new PdfPCell(new Phrase("INR " + String.format("%.2f", amount), tableBodyFont));
            cell4.setPadding(8f);
            cell4.setBorderColor(new Color(230, 230, 230));
            cell4.setHorizontalAlignment(Element.ALIGN_RIGHT);
            itemTable.addCell(cell4);

            document.add(itemTable);

            // Summary section
            document.add(new Paragraph("\n"));
            PdfPTable summaryTable = new PdfPTable(2);
            summaryTable.setWidthPercentage(100);
            summaryTable.setWidths(new float[] { 3f, 2f });

            PdfPCell emptySummary = new PdfPCell(new Phrase(""));
            emptySummary.setBorder(Rectangle.NO_BORDER);
            summaryTable.addCell(emptySummary);

            PdfPCell totalCell = new PdfPCell();
            totalCell.setBorder(Rectangle.TOP);
            totalCell.setBorderColor(new Color(0, 67, 105));
            totalCell.setBorderWidthTop(2f);

            PdfPTable innerSummary = new PdfPTable(2);
            innerSummary.setWidthPercentage(100);

            PdfPCell lbl1 = new PdfPCell(new Phrase("Subtotal", tableBodyFont));
            lbl1.setBorder(Rectangle.NO_BORDER);
            lbl1.setPadding(5f);
            PdfPCell val1 = new PdfPCell(new Phrase("INR " + String.format("%.2f", amount), tableBodyFont));
            val1.setBorder(Rectangle.NO_BORDER);
            val1.setHorizontalAlignment(Element.ALIGN_RIGHT);
            val1.setPadding(5f);
            innerSummary.addCell(lbl1);
            innerSummary.addCell(val1);

            PdfPCell lbl2 = new PdfPCell(new Phrase("Tax / GST", tableBodyFont));
            lbl2.setBorder(Rectangle.NO_BORDER);
            lbl2.setPadding(5f);
            PdfPCell val2 = new PdfPCell(new Phrase("INR 0.00", tableBodyFont));
            val2.setBorder(Rectangle.NO_BORDER);
            val2.setHorizontalAlignment(Element.ALIGN_RIGHT);
            val2.setPadding(5f);
            innerSummary.addCell(lbl2);
            innerSummary.addCell(val2);

            PdfPCell lbl3 = new PdfPCell(new Phrase("Total Paid", totalFont));
            lbl3.setBorder(Rectangle.NO_BORDER);
            lbl3.setPadding(5f);
            PdfPCell val3 = new PdfPCell(new Phrase("INR " + String.format("%.2f", amount), totalFont));
            val3.setBorder(Rectangle.NO_BORDER);
            val3.setHorizontalAlignment(Element.ALIGN_RIGHT);
            val3.setPadding(5f);
            innerSummary.addCell(lbl3);
            innerSummary.addCell(val3);

            totalCell.addElement(innerSummary);
            summaryTable.addCell(totalCell);

            document.add(summaryTable);

            // Footer
            document.add(new Paragraph("\n\n\n\n"));
            Paragraph pFooter = new Paragraph("Thank you for your business. For support, contact billing@keliri.com",
                    normalFont);
            pFooter.setAlignment(Element.ALIGN_CENTER);
            document.add(pFooter);

            document.close();
            return out.toByteArray();
        } catch (Exception e) {
            throw new RuntimeException("Error generating PDF invoice", e);
        }
    }
}
