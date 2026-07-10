package org.jackfruit.keliri.model;

import java.util.List;

public class SuperAdminRevenueResponse {
    private double totalRevenue;
    private double avgRevenuePerAd;
    private double pendingPayouts;
    private long totalTransactions;

    private double revenueChange;
    private double avgRevenueChange;
    private double payoutChange;
    private double transactionChange;

    private List<DataPoint> chartData;
    private List<CategoryMetric> breakdown;

    public static class DataPoint {
        private String label;
        private double value;

        public DataPoint(String label, double value) {
            this.label = label;
            this.value = value;
        }

        public String getLabel() {
            return label;
        }

        public void setLabel(String label) {
            this.label = label;
        }

        public double getValue() {
            return value;
        }

        public void setValue(double value) {
            this.value = value;
        }
    }

    public static class CategoryMetric {
        private String category;
        private double amount;
        private String color;

        public CategoryMetric(String category, double amount, String color) {
            this.category = category;
            this.amount = amount;
            this.color = color;
        }

        public String getCategory() {
            return category;
        }

        public void setCategory(String category) {
            this.category = category;
        }

        public double getAmount() {
            return amount;
        }

        public void setAmount(double amount) {
            this.amount = amount;
        }

        public String getColor() {
            return color;
        }

        public void setColor(String color) {
            this.color = color;
        }
    }

    // Getters and Setters
    public double getTotalRevenue() {
        return totalRevenue;
    }

    public void setTotalRevenue(double totalRevenue) {
        this.totalRevenue = totalRevenue;
    }

    public double getAvgRevenuePerAd() {
        return avgRevenuePerAd;
    }

    public void setAvgRevenuePerAd(double avgRevenuePerAd) {
        this.avgRevenuePerAd = avgRevenuePerAd;
    }

    public double getPendingPayouts() {
        return pendingPayouts;
    }

    public void setPendingPayouts(double pendingPayouts) {
        this.pendingPayouts = pendingPayouts;
    }

    public long getTotalTransactions() {
        return totalTransactions;
    }

    public void setTotalTransactions(long totalTransactions) {
        this.totalTransactions = totalTransactions;
    }

    public double getRevenueChange() {
        return revenueChange;
    }

    public void setRevenueChange(double revenueChange) {
        this.revenueChange = revenueChange;
    }

    public double getAvgRevenueChange() {
        return avgRevenueChange;
    }

    public void setAvgRevenueChange(double avgRevenueChange) {
        this.avgRevenueChange = avgRevenueChange;
    }

    public double getPayoutChange() {
        return payoutChange;
    }

    public void setPayoutChange(double payoutChange) {
        this.payoutChange = payoutChange;
    }

    public double getTransactionChange() {
        return transactionChange;
    }

    public void setTransactionChange(double transactionChange) {
        this.transactionChange = transactionChange;
    }

    public List<DataPoint> getChartData() {
        return chartData;
    }

    public void setChartData(List<DataPoint> chartData) {
        this.chartData = chartData;
    }

    public List<CategoryMetric> getBreakdown() {
        return breakdown;
    }

    public void setBreakdown(List<CategoryMetric> breakdown) {
        this.breakdown = breakdown;
    }
}
