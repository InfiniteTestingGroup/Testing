package org.jackfruit.keliri.service;

import java.time.LocalDate;
import java.time.ZoneId;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.jackfruit.keliri.model.Content;
import org.jackfruit.keliri.model.DashboardSeedRequest;
import org.jackfruit.keliri.model.ad_campaigns;
import org.jackfruit.keliri.model.advertisements;
import org.jackfruit.keliri.model.dateRange;
import org.jackfruit.keliri.model.location;
import org.jackfruit.keliri.model.phoneNumber;
import org.jackfruit.keliri.model.txn_user_locations;
import org.jackfruit.keliri.model.users;
import org.jackfruit.keliri.repository.ad_campaignsRepository;
import org.jackfruit.keliri.repository.advertisementsRepository;
import org.jackfruit.keliri.repository.txn_user_locationsRepository;
import org.jackfruit.keliri.repository.usersRepository;
import org.springframework.data.mongodb.core.geo.GeoJsonPoint;
import org.springframework.stereotype.Service;

@Service
public class DashboardSeedService {
    private final usersRepository usersRepository;
    private final txn_user_locationsRepository userLocationsRepository;
    private final advertisementsRepository advertisementsRepository;
    private final ad_campaignsRepository campaignsRepository;

    public DashboardSeedService(
            usersRepository usersRepository,
            txn_user_locationsRepository userLocationsRepository,
            advertisementsRepository advertisementsRepository,
            ad_campaignsRepository campaignsRepository) {
        this.usersRepository = usersRepository;
        this.userLocationsRepository = userLocationsRepository;
        this.advertisementsRepository = advertisementsRepository;
        this.campaignsRepository = campaignsRepository;
    }

    public Map<String, Object> seed(DashboardSeedRequest request) {
        Map<String, Object> result = new HashMap<>();
        List<String> publisherIds = new ArrayList<>();
        List<String> creatorIds = new ArrayList<>();
        List<String> adIds = new ArrayList<>();
        List<String> campaignIds = new ArrayList<>();

        if (request.getPublishers() != null) {
            for (DashboardSeedRequest.PublisherSeed publisherSeed : request.getPublishers()) {
                users publisher = createUser(
                        publisherSeed.getName(),
                        publisherSeed.getEmail(),
                        publisherSeed.getCountryCode(),
                        publisherSeed.getPhone(),
                        "PUBLISHER");
                publisher.setLatitude(publisherSeed.getLatitude());
                publisher.setLongitude(publisherSeed.getLongitude());
                publisher = usersRepository.save(publisher);

                txn_user_locations publisherLocation = new txn_user_locations();
                publisherLocation.setUserId(publisher.getId());
                publisherLocation.setUserType("PUBLISHER");
                publisherLocation.setLocation(new GeoJsonPoint(publisherSeed.getLongitude(), publisherSeed.getLatitude()));
                publisherLocation = userLocationsRepository.save(publisherLocation);

                publisher.setLastKnownLocation(publisherLocation.getId());
                usersRepository.save(publisher);
                publisherIds.add(publisher.getId());
            }
        }

        if (request.getCampaigns() != null) {
            for (DashboardSeedRequest.CampaignSeed campaignSeed : request.getCampaigns()) {
                users creator = createUser(
                        campaignSeed.getCreatorName(),
                        campaignSeed.getCreatorEmail(),
                        campaignSeed.getCreatorCountryCode(),
                        campaignSeed.getCreatorPhone(),
                        "ADMIN");
                creator = usersRepository.save(creator);
                creatorIds.add(creator.getId());

                advertisements advertisement = new advertisements();
                advertisement.setTitle(campaignSeed.getTitle());
                advertisement.setDescription(campaignSeed.getDescription());
                advertisement.setCompany(campaignSeed.getCompany());
                advertisement.setAdType(campaignSeed.getAdType());
                advertisement.setThumbnail("");
                Content content = new Content();
                content.setAdText(campaignSeed.getDescription());
                advertisement.setContent(content);
                advertisement = advertisementsRepository.save(advertisement);
                adIds.add(advertisement.getId());

                ad_campaigns campaign = new ad_campaigns();
                campaign.setCreatedBy(creator.getId());
                campaign.setAdvertisementId(advertisement.getId());
                campaign.setCompaignsStatus(campaignSeed.getStatus());
                campaign.setCampaignCategories(new ArrayList<>());
                campaign.setLocation(buildLocation(campaignSeed));
                campaign.setDateRange(buildDateRange(campaignSeed));
                campaign = campaignsRepository.save(campaign);
                campaignIds.add(campaign.getId());
            }
        }

        result.put("createdPublishers", publisherIds);
        result.put("createdCreators", creatorIds);
        result.put("createdAdvertisements", adIds);
        result.put("createdCampaigns", campaignIds);
        return result;
    }

    private users createUser(String name, String email, String countryCode, String dialNumber, String userType) {
        users user = new users();
        user.setFullName(name);
        user.setEmailAddress(email);
        user.setUserType(userType);
        phoneNumber phone = new phoneNumber();
        phone.setCountryCode(countryCode == null || countryCode.isBlank() ? "+91" : countryCode);
        phone.setDialNumber(dialNumber);
        user.setPhoneNumber(phone);
        return user;
    }

    private location buildLocation(DashboardSeedRequest.CampaignSeed seed) {
        location location = new location();
        location.setLocationName(seed.getLocationName());
        location.setLat(Double.toString(seed.getLatitude()));
        location.setLng(Double.toString(seed.getLongitude()));
        location.setRange(seed.getRadiusKm() * 1000);
        return location;
    }

    private dateRange buildDateRange(DashboardSeedRequest.CampaignSeed seed) {
        dateRange range = new dateRange();
        if (seed.getStartDate() != null) {
            range.setFromDate(java.util.Date.from(LocalDate.parse(seed.getStartDate()).atStartOfDay(ZoneId.systemDefault()).toInstant()));
        }
        if (seed.getEndDate() != null) {
            range.setToDate(java.util.Date.from(LocalDate.parse(seed.getEndDate()).atStartOfDay(ZoneId.systemDefault()).toInstant()));
        }
        return range;
    }
}
