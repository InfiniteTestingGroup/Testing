package org.jackfruit.keliri.repository;

import org.bson.types.ObjectId;
import org.jackfruit.keliri.model.HitCountResult;
import org.jackfruit.keliri.model.hitRecord;
import org.springframework.data.mongodb.repository.Aggregation;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

import java.util.Date;
import java.util.List;

@Repository
public interface hitRecordRepository extends MongoRepository<hitRecord, ObjectId> {

    long countByCampaignIdAndEventType(String campaignId, String eventType);

    /**
     * Legacy bulk-fetch — kept for analytics/reporting use-cases that need raw records.
     * Do NOT use this for simple counting: it loads every document into Java heap.
     * Use aggregateHitCounts instead.
     */
    List<hitRecord> findByCampaignIdIn(List<String> campaignIds);

    List<hitRecord> findByCampaignIdInAndTimestampAfter(List<String> campaignIds, Date timestamp);
    List<hitRecord> findByCampaignIdInAndTimestampBetween(List<String> campaignIds, Date startDate, Date endDate);

    /**
     * Server-side MongoDB aggregation: groups hit records by (campaignId, eventType)
     * and returns only the counts — no raw document data transferred.
     *
     * Pipeline:
     *   1. $match  — filter to the requested campaign IDs
     *   2. $group  — count per (campaignId, eventType) pair
     *   3. $project — reshape to flat { campaignId, eventType, count }
     *
     * This replaces the previous findByCampaignIdIn() approach which was loading
     * every hit record (with latitude, longitude, userAgent, etc.) into Java heap
     * just to count them — the main cause of the 5+ minute /ads load time.
     */
    @Aggregation(pipeline = {
        "{ '$match': { 'campaignId': { '$in': ?0 } } }",
        "{ '$group': { '_id': { 'campaignId': '$campaignId', 'eventType': '$eventType' }, 'count': { '$sum': 1 } } }",
        "{ '$project': { '_id': 0, 'campaignId': '$_id.campaignId', 'eventType': '$_id.eventType', 'count': 1 } }"
    })
    List<HitCountResult> aggregateHitCounts(List<?> campaignIds);
}
