package org.jackfruit.keliri.model;

/**
 * Projection DTO for the MongoDB hit-count aggregation.
 * Holds the server-side grouped count for a single (campaignId, eventType) pair.
 * Avoids loading every raw hitRecord document into Java heap.
 */
public class HitCountResult {

    private String campaignId;
    private String eventType;
    private long count;

    public HitCountResult() {}

    public String getCampaignId() { return campaignId; }
    public void setCampaignId(String campaignId) { this.campaignId = campaignId; }

    public String getEventType() { return eventType; }
    public void setEventType(String eventType) { this.eventType = eventType; }

    public long getCount() { return count; }
    public void setCount(long count) { this.count = count; }
}
