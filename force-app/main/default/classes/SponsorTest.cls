// https://campapex.org/course/EventCloud
@IsTest
private with sharing class SponsorTest {
    private static TestDataFactory testDataFactory = new TestDataFactory();

    @TestSetup
    private static void setup() {
        List<CAMPX__Event__c> eventsToInsert = testDataFactory.createEvents_setup_SponsorTest();

        if (Schema.sObjectType.CAMPX__Event__c.isCreateable()) {
            insert as user eventsToInsert;
        }

        Id eventAlpha_nullId;
        Id eventDelta_WithGrossRevenueId;

        for (CAMPX__Event__c eventToInsert : eventsToInsert) {
            if (eventToInsert.Name == 'eventAlpha_null') {
                eventAlpha_nullId = eventToInsert.Id;
            } else if (eventToInsert.Name == 'eventDelta_WithGrossRevenue') {
                eventDelta_WithGrossRevenueId = eventToInsert.Id;
            }
        }

        List<CAMPX__Sponsor__c> sponsorsToInsert = testDataFactory.createSponsors_setup(
            eventAlpha_nullId, 
            eventDelta_WithGrossRevenueId
        );

        if (Schema.sObjectType.CAMPX__Sponsor__c.isCreateable()) {
            insert as user sponsorsToInsert;
        }
    }

    // https://campapex.org/lesson/66104513e4271575745dbb80 (Defaulting Sponsor Status to Pending on Creation)
    @IsTest
    private static void default_status_to_Pending_if_status_is_null_on_insert() {
        // GIVEN
        Map<String, Id> eventIdMap = getEventIdMap();

        Id eventAlpha_nullId = eventIdMap.get('eventAlpha_null');

        List<CAMPX__Sponsor__c> sponsorsToInsert = testDataFactory.createSponsors_defaultStatus(eventAlpha_nullId);

        // WHEN
        Test.startTest();

        if (Schema.sObjectType.CAMPX__Sponsor__c.isCreateable()) {
            insert as user sponsorsToInsert;
        }

        Test.stopTest();

        // THEN
        final List<String> NAMES = new List<String>{
            'sponsorZulu_null', 
            'sponsorYankee_Accepted'
        };

        final String PENDING = 'Pending';

        List<CAMPX__Sponsor__c> retrievedSponsors = [
            SELECT Id 
            FROM CAMPX__Sponsor__c 
            WHERE Name IN :NAMES 
                AND CAMPX__Status__c = :PENDING 
            WITH USER_MODE
        ];

        System.assertEquals(1, retrievedSponsors.size(), 'Expect 1 sponsor with Pending status');
    }

    private static Map<String, Id> getEventIdMap() {
        final List<String> NAMES = new List<String>{
            'eventAlpha_null', 
            'eventBravo_WithGrossRevenue', 
            'eventCharlie_WithGrossRevenue', 
            'eventDelta_WithGrossRevenue'
        };

        List<CAMPX__Event__c> retrievedEvents = [
            SELECT 
                Id, 
                Name 
            FROM CAMPX__Event__c 
            WHERE Name IN :NAMES
        ];

        Map<String, Id> eventIdMap = new Map<String, Id>();

        for (CAMPX__Event__c retrievedEvent : retrievedEvents) {
            if (retrievedEvent.Name == 'eventAlpha_null') {
                eventIdMap.put('eventAlpha_null', retrievedEvent.Id);
            } else if (retrievedEvent.Name == 'eventBravo_WithGrossRevenue') {
                eventIdMap.put('eventBravo_WithGrossRevenue', retrievedEvent.Id);
            } else if (retrievedEvent.Name == 'eventCharlie_WithGrossRevenue') {
                eventIdMap.put('eventCharlie_WithGrossRevenue', retrievedEvent.Id);
            } else if (retrievedEvent.Name == 'eventDelta_WithGrossRevenue') {
                eventIdMap.put('eventDelta_WithGrossRevenue', retrievedEvent.Id);
            }
        }

        return eventIdMap;
    }

    // https://campapex.org/lesson/66104513e4271575745dbb81 (Enforcing Email Requirement for Sponsor Creation)
    @IsTest
    private static void sponsor_cannot_be_created_without_email() {
        // GIVEN
        Map<String, Id> eventIdMap = getEventIdMap();

        Id eventAlpha_nullId = eventIdMap.get('eventAlpha_null');

        CAMPX__Sponsor__c sponsorZulu_WithoutEmail = new CAMPX__Sponsor__c(
            Name = 'sponsorZulu_WithoutEmail', 
            CAMPX__Event__c = eventAlpha_nullId
        );

        // WHEN
        Test.startTest();

        try {
            if (Schema.sObjectType.CAMPX__Sponsor__c.isCreateable()) {
                insert as user sponsorZulu_WithoutEmail;
            }

            Test.stopTest();

            // THEN
            Assert.fail('Expect exception');
        } catch (Exception e) {
            System.assertEquals(
                'FIELD_CUSTOM_VALIDATION_EXCEPTION, A sponsor can not be created without an email address', 
                e.getMessage().substringBetween('first error: ', ': ['), 
                'Exception message does not match: ' + e.getMessage()
            );
        }
    }

    // https://campapex.org/lesson/66104513e4271575745dbb82 (Updating Sponsor Tier Based on Contribution Amount)
    @IsTest
    private static void update_tier_based_on_contribution_amount_on_insert() {
        // GIVEN
        Map<String, Id> eventIdMap = getEventIdMap();

        Id eventAlpha_nullId = eventIdMap.get('eventAlpha_null');

        List<CAMPX__Sponsor__c> sponsorsToInsert = testDataFactory.createSponsors_updateTierBasedOnContributionAmount(eventAlpha_nullId);

        // WHEN
        Test.startTest();

        if (Schema.sObjectType.CAMPX__Sponsor__c.isCreateable()) {
            insert as user sponsorsToInsert;
        }

        Test.stopTest();

        // THEN
        final List<String> NAMES = new List<String>{
            'sponsorZulu_null', 
            'sponsorYankee_500', 
            'sponsorXray_3000', 
            'sponsorWhiskey_10000'
        };

        List<CAMPX__Sponsor__c> retrievedSponsors = [
            SELECT CAMPX__Tier__c 
            FROM CAMPX__Sponsor__c 
            WHERE Name IN :NAMES 
                AND CAMPX__Tier__c != null 
            WITH USER_MODE
        ];

        List<CAMPX__Sponsor__c> retrievedSponsors_Bronze = new List<CAMPX__Sponsor__c>();
        List<CAMPX__Sponsor__c> retrievedSponsors_Silver = new List<CAMPX__Sponsor__c>();
        List<CAMPX__Sponsor__c> retrievedSponsors_Gold = new List<CAMPX__Sponsor__c>();

        for (CAMPX__Sponsor__c retrievedSponsor : retrievedSponsors) {
            if (retrievedSponsor.CAMPX__Tier__c == 'Bronze') {
                retrievedSponsors_Bronze.add(retrievedSponsor);
            } else if (retrievedSponsor.CAMPX__Tier__c == 'Silver') {
                retrievedSponsors_Silver.add(retrievedSponsor);
            } else if (retrievedSponsor.CAMPX__Tier__c == 'Gold') {
                retrievedSponsors_Gold.add(retrievedSponsor);
            }
        }

        System.assertEquals(1, retrievedSponsors_Bronze.size(), 'Expect 1 sponsor with Bronze tier');
        System.assertEquals(1, retrievedSponsors_Silver.size(), 'Expect 1 sponsor with Silver tier');
        System.assertEquals(1, retrievedSponsors_Gold.size(), 'Expect 1 sponsor with Gold tier');
    }

    // https://campapex.org/lesson/66104513e4271575745dbb82 (Updating Sponsor Tier Based on Contribution Amount)
    @IsTest
    private static void update_tier_based_on_contribution_amount_on_update() {
        // GIVEN
        final List<String> NAMES = new List<String>{
            'sponsorAlpha_null', 
            'sponsorBravo_null', 
            'sponsorCharlie_null', 
            'sponsorDelta_null'
        };

        List<CAMPX__Sponsor__c> sponsorsToUpdate = [
            SELECT 
                Name, 
                CAMPX__ContributionAmount__c 
            FROM CAMPX__Sponsor__c 
            WHERE Name IN :NAMES 
            WITH USER_MODE
        ];

        for (CAMPX__Sponsor__c sponsorToUpdate : sponsorsToUpdate) {
            if (sponsorToUpdate.Name == 'sponsorAlpha_null') {
                sponsorToUpdate.CAMPX__ContributionAmount__c = 0;
            } else if (sponsorToUpdate.Name == 'sponsorBravo_null') {
                sponsorToUpdate.CAMPX__ContributionAmount__c = 500;
            } else if (sponsorToUpdate.Name == 'sponsorCharlie_null') {
                sponsorToUpdate.CAMPX__ContributionAmount__c = 3000;
            } else if (sponsorToUpdate.Name == 'sponsorDelta_null') {
                sponsorToUpdate.CAMPX__ContributionAmount__c = 10000;
            }
        }

        // WHEN
        Test.startTest();

        if (Schema.sObjectType.CAMPX__Sponsor__c.isUpdateable()) {
            update as user sponsorsToUpdate;
        }

        Test.stopTest();

        // THEN
        List<CAMPX__Sponsor__c> retrievedSponsors = [
            SELECT CAMPX__Tier__c 
            FROM CAMPX__Sponsor__c 
            WHERE Name IN :NAMES 
                AND CAMPX__Tier__c != null 
            WITH USER_MODE
        ];

        List<CAMPX__Sponsor__c> retrievedSponsors_Bronze = new List<CAMPX__Sponsor__c>();
        List<CAMPX__Sponsor__c> retrievedSponsors_Silver = new List<CAMPX__Sponsor__c>();
        List<CAMPX__Sponsor__c> retrievedSponsors_Gold = new List<CAMPX__Sponsor__c>();

        for (CAMPX__Sponsor__c retrievedSponsor : retrievedSponsors) {
            if (retrievedSponsor.CAMPX__Tier__c == 'Bronze') {
                retrievedSponsors_Bronze.add(retrievedSponsor);
            } else if (retrievedSponsor.CAMPX__Tier__c == 'Silver') {
                retrievedSponsors_Silver.add(retrievedSponsor);
            } else if (retrievedSponsor.CAMPX__Tier__c == 'Gold') {
                retrievedSponsors_Gold.add(retrievedSponsor);
            }
        }

        System.assertEquals(1, retrievedSponsors_Bronze.size(), 'Expect 1 sponsor with Bronze tier');
        System.assertEquals(1, retrievedSponsors_Silver.size(), 'Expect 1 sponsor with Silver tier');
        System.assertEquals(1, retrievedSponsors_Gold.size(), 'Expect 1 sponsor with Gold tier');
    }

    // https://campapex.org/lesson/66104513e4271575745dbb83 (Conditional Sponsor Status Update Based on Event Association)
    @IsTest
    private static void sponsor_cannot_be_accepted_without_event_on_insert() {
        // GIVEN
        Map<String, Id> eventIdMap = getEventIdMap();

        Id eventAlpha_nullId = eventIdMap.get('eventAlpha_null');

        CAMPX__Sponsor__c sponsorZulu_WithoutEvent = new CAMPX__Sponsor__c(
            Name = 'sponsorZulu_WithoutEvent', 
            CAMPX__Email__c = 'sponsorZulu_WithoutEvent@example.com', 
            CAMPX__Status__c = 'Accepted'
        );

        // WHEN
        Test.startTest();

        try {
            if (Schema.sObjectType.CAMPX__Sponsor__c.isCreateable()) {
                insert as user sponsorZulu_WithoutEvent;
            }

            Test.stopTest();

            // THEN
            Assert.fail('Expect exception');
        } catch (Exception e) {
            System.assertEquals(
                'FIELD_CUSTOM_VALIDATION_EXCEPTION, A Sponsor must be associated with an event before being Accepted.', 
                e.getMessage().substringBetween('first error: ', ': ['), 
                'Exception message does not match: ' + e.getMessage()
            );
        }
    }

    // https://campapex.org/lesson/66104513e4271575745dbb83 (Conditional Sponsor Status Update Based on Event Association)
    @IsTest
    private static void sponsor_cannot_be_accepted_without_event_on_update() {
        // GIVEN
        final String NAME = 'sponsorAlpha_null';

        List<CAMPX__Sponsor__c> sponsorsToUpdate = [
            SELECT 
                Name, 
                CAMPX__Event__c 
            FROM CAMPX__Sponsor__c 
            WHERE Name = :NAME 
            WITH USER_MODE 
            LIMIT 1
        ];

        for (CAMPX__Sponsor__c sponsorToUpdate : sponsorsToUpdate) {
            if (sponsorToUpdate.Name == 'sponsorAlpha_null') {
                sponsorToUpdate.CAMPX__Status__c = 'Accepted';
                sponsorToUpdate.CAMPX__Event__c = null;
            }
        }

        // WHEN
        Test.startTest();

        try {
            if (Schema.sObjectType.CAMPX__Sponsor__c.isUpdateable()) {
                update as user sponsorsToUpdate;
            }

            Test.stopTest();

            // THEN
            Assert.fail('Expect exception');
        } catch (Exception e) {
            System.assertEquals(
                'FIELD_CUSTOM_VALIDATION_EXCEPTION, A Sponsor must be associated with an event before being Accepted.', 
                e.getMessage().substringBetween('first error: ', ': ['), 
                'Exception message does not match: ' + e.getMessage()
            );
        }
    }

    // https://campapex.org/lesson/66104513e4271575745dbb85 (Updating Event Gross Revenue upon Sponsor Acceptance)
    @IsTest
    private static void accept_sponsor_increases_event_gross_revenue_on_insert() {
        // GIVEN
        Map<String, Id> eventIdMap = getEventIdMap();

        Id eventAlpha_nullId = eventIdMap.get('eventAlpha_null');
        Id eventBravo_WithGrossRevenueId = eventIdMap.get('eventBravo_WithGrossRevenue');
        Id eventCharlie_WithGrossRevenueId = eventIdMap.get('eventCharlie_WithGrossRevenue');

        List<CAMPX__Sponsor__c> sponsorsToInsert = testDataFactory.createSponsors_increaseEventGrossRevenueUponSponsorAcceptance_on_insert(
            eventAlpha_nullId, 
            eventBravo_WithGrossRevenueId, 
            eventCharlie_WithGrossRevenueId
        );

        // WHEN
        Test.startTest();

        if (Schema.sObjectType.CAMPX__Sponsor__c.isCreateable()) {
            insert as user sponsorsToInsert;
        }

        Test.stopTest();

        // THEN
        List<CAMPX__Event__c> retrievedEvents = [
            SELECT 
                Id, 
                Name, 
                CAMPX__GrossRevenue__c 
            FROM CAMPX__Event__c 
            WHERE Id IN (
                    :eventAlpha_nullId, 
                    :eventBravo_WithGrossRevenueId, 
                    :eventCharlie_WithGrossRevenueId
                ) 
            WITH USER_MODE
        ];

        List<CAMPX__Event__c> retrievedEvents_eventAlpha_null = new List<CAMPX__Event__c>();
        List<CAMPX__Event__c> retrievedEvents_eventBravo_WithGrossRevenue = new List<CAMPX__Event__c>();
        List<CAMPX__Event__c> retrievedEvents_eventCharlie_WithGrossRevenue = new List<CAMPX__Event__c>();

        for (CAMPX__Event__c retrievedEvent : retrievedEvents) {
            if (retrievedEvent.Name == 'eventAlpha_null' && retrievedEvent.CAMPX__GrossRevenue__c == 1000) {
                retrievedEvents_eventAlpha_null.add(retrievedEvent);
            } else if (retrievedEvent.Name == 'eventBravo_WithGrossRevenue' && retrievedEvent.CAMPX__GrossRevenue__c == 3000) {
                retrievedEvents_eventBravo_WithGrossRevenue.add(retrievedEvent);
            } else if (retrievedEvent.Name == 'eventCharlie_WithGrossRevenue' && retrievedEvent.CAMPX__GrossRevenue__c == 1000) {
                retrievedEvents_eventCharlie_WithGrossRevenue.add(retrievedEvent);
            }
        }

        System.assertEquals(1, retrievedEvents_eventAlpha_null.size(), 'Expect 1 event with gross revenue increased');
        System.assertEquals(1, retrievedEvents_eventBravo_WithGrossRevenue.size(), 'Expect 1 event with gross revenue increased');
        System.assertEquals(1, retrievedEvents_eventCharlie_WithGrossRevenue.size(), 'Expect 1 event with gross revenue unchanged');
    }

    // https://campapex.org/lesson/66104513e4271575745dbb85 (Updating Event Gross Revenue upon Sponsor Acceptance)
    @IsTest
    private static void accept_sponsor_increases_event_gross_revenue_on_update() {
        // GIVEN
        final List<String> NAMES = new List<String>{
            'sponsorAlpha_null', 
            'sponsorBravo_null', 
            'sponsorCharlie_null', 
            'sponsorDelta_null'
        };

        List<CAMPX__Sponsor__c> sponsorsToUpdate = [
            SELECT 
                Name, 
                CAMPX__Status__c, 
                CAMPX__ContributionAmount__c, 
                CAMPX__Event__c 
            FROM CAMPX__Sponsor__c 
            WHERE Name IN :NAMES 
            WITH USER_MODE
        ];

        Map<String, Id> eventIdMap = getEventIdMap();

        Id eventAlpha_nullId = eventIdMap.get('eventAlpha_null');
        Id eventBravo_WithGrossRevenueId = eventIdMap.get('eventBravo_WithGrossRevenue');
        Id eventCharlie_WithGrossRevenueId = eventIdMap.get('eventCharlie_WithGrossRevenue');

        for (CAMPX__Sponsor__c sponsorToUpdate : sponsorsToUpdate) {
            if (sponsorToUpdate.Name == 'sponsorAlpha_null') {
                sponsorToUpdate.CAMPX__Status__c = 'Accepted';
                sponsorToUpdate.CAMPX__ContributionAmount__c = 1000;
            } else if (sponsorToUpdate.Name == 'sponsorBravo_null') {
                sponsorToUpdate.CAMPX__Status__c = 'Accepted';
                sponsorToUpdate.CAMPX__ContributionAmount__c = 1000;
                sponsorToUpdate.CAMPX__Event__c = eventBravo_WithGrossRevenueId;
            } else if (sponsorToUpdate.Name == 'sponsorCharlie_null') {
                sponsorToUpdate.CAMPX__Status__c = 'Accepted';
                sponsorToUpdate.CAMPX__ContributionAmount__c = 1000;
                sponsorToUpdate.CAMPX__Event__c = eventBravo_WithGrossRevenueId;
            } else if (sponsorToUpdate.Name == 'sponsorDelta_null') {
                sponsorToUpdate.CAMPX__Status__c = 'Accepted';
                sponsorToUpdate.CAMPX__Event__c = eventCharlie_WithGrossRevenueId;
            }
        }

        // WHEN
        Test.startTest();

        if (Schema.sObjectType.CAMPX__Sponsor__c.isUpdateable()) {
            update as user sponsorsToUpdate;
        }

        Test.stopTest();

        // THEN
        List<CAMPX__Event__c> retrievedEvents = [
            SELECT 
                Id, 
                Name, 
                CAMPX__GrossRevenue__c 
            FROM CAMPX__Event__c 
            WHERE Id IN (
                    :eventAlpha_nullId, 
                    :eventBravo_WithGrossRevenueId, 
                    :eventCharlie_WithGrossRevenueId
                ) 
            WITH USER_MODE
        ];

        List<CAMPX__Event__c> retrievedEvents_eventAlpha_null = new List<CAMPX__Event__c>();
        List<CAMPX__Event__c> retrievedEvents_eventBravo_WithGrossRevenue = new List<CAMPX__Event__c>();
        List<CAMPX__Event__c> retrievedEvents_eventCharlie_WithGrossRevenue = new List<CAMPX__Event__c>();

        for (CAMPX__Event__c retrievedEvent : retrievedEvents) {
            if (retrievedEvent.Name == 'eventAlpha_null' && retrievedEvent.CAMPX__GrossRevenue__c == 1000) {
                retrievedEvents_eventAlpha_null.add(retrievedEvent);
            } else if (retrievedEvent.Name == 'eventBravo_WithGrossRevenue' && retrievedEvent.CAMPX__GrossRevenue__c == 3000) {
                retrievedEvents_eventBravo_WithGrossRevenue.add(retrievedEvent);
            } else if (retrievedEvent.Name == 'eventCharlie_WithGrossRevenue' && retrievedEvent.CAMPX__GrossRevenue__c == 1000) {
                retrievedEvents_eventCharlie_WithGrossRevenue.add(retrievedEvent);
            }
        }

        System.assertEquals(1, retrievedEvents_eventAlpha_null.size(), 'Expect 1 event with gross revenue increased');
        System.assertEquals(1, retrievedEvents_eventBravo_WithGrossRevenue.size(), 'Expect 1 event without gross revenue increased');
        System.assertEquals(1, retrievedEvents_eventCharlie_WithGrossRevenue.size(), 'Expect 1 event without gross revenue unchanged');
    }

    // https://campapex.org/lesson/66104513e4271575745dbb86 (Adjusting Event Gross Revenue for Cancelled Sponsorships Or Event Changes)
    @IsTest
    private static void change_sponsor_decreases_event_gross_revenue_on_update() {
        // GIVEN
        final List<String> NAMES = new List<String>{
            'sponsorAlpha_null', 
            'sponsorEcho_Accepted_WithContributionAmount', 
            'sponsorFoxtrot_Accepted_WithContributionAmount'
        };

        List<CAMPX__Sponsor__c> sponsorsToUpdate = [
            SELECT 
                Name, 
                CAMPX__Status__c, 
                CAMPX__ContributionAmount__c, 
                CAMPX__Event__c 
            FROM CAMPX__Sponsor__c 
            WHERE Name IN :NAMES 
            WITH USER_MODE
        ];

        Map<String, Id> eventIdMap = getEventIdMap();

        Id eventAlpha_nullId = eventIdMap.get('eventAlpha_null');
        Id eventCharlie_WithGrossRevenueId = eventIdMap.get('eventCharlie_WithGrossRevenue');
        Id eventDelta_WithGrossRevenueId = eventIdMap.get('eventDelta_WithGrossRevenue');

        for (CAMPX__Sponsor__c sponsorToUpdate : sponsorsToUpdate) {
            if (sponsorToUpdate.Name == 'sponsorAlpha_null') {
                sponsorToUpdate.CAMPX__Status__c = 'Rejected';
            } else if (sponsorToUpdate.Name == 'sponsorEcho_Accepted_WithContributionAmount') {
                sponsorToUpdate.CAMPX__Status__c = 'Pending';
            } else if (sponsorToUpdate.Name == 'sponsorFoxtrot_Accepted_WithContributionAmount') {
                sponsorToUpdate.CAMPX__Event__c = eventCharlie_WithGrossRevenueId;
            }
        }

        // WHEN
        Test.startTest();

        if (Schema.sObjectType.CAMPX__Sponsor__c.isUpdateable()) {
            update as user sponsorsToUpdate;
        }

        Test.stopTest();

        // THEN
        List<CAMPX__Event__c> retrievedEvents = [
            SELECT 
                Id, 
                Name, 
                CAMPX__GrossRevenue__c 
            FROM CAMPX__Event__c 
            WHERE Id IN (
                    :eventAlpha_nullId, 
                    :eventCharlie_WithGrossRevenueId, 
                    :eventDelta_WithGrossRevenueId
                ) 
            WITH USER_MODE
        ];

        List<CAMPX__Event__c> retrievedEvents_eventAlpha_null = new List<CAMPX__Event__c>();
        List<CAMPX__Event__c> retrievedEvents_eventCharlie_WithGrossRevenue = new List<CAMPX__Event__c>();
        List<CAMPX__Event__c> retrievedEvents_eventDelta_WithGrossRevenue = new List<CAMPX__Event__c>();

        for (CAMPX__Event__c retrievedEvent : retrievedEvents) {
            if (retrievedEvent.Name == 'eventAlpha_null' && retrievedEvent.CAMPX__GrossRevenue__c == null) {
                retrievedEvents_eventAlpha_null.add(retrievedEvent);
            } else if (retrievedEvent.Name == 'eventCharlie_WithGrossRevenue' && retrievedEvent.CAMPX__GrossRevenue__c == 1000) {
                retrievedEvents_eventCharlie_WithGrossRevenue.add(retrievedEvent);
            } else if (retrievedEvent.Name == 'eventDelta_WithGrossRevenue' && retrievedEvent.CAMPX__GrossRevenue__c == 0) {
                retrievedEvents_eventDelta_WithGrossRevenue.add(retrievedEvent);
            }
        }

        System.assertEquals(1, retrievedEvents_eventAlpha_null.size(), 'Expect 1 event with gross revenue unchanged');
        System.assertEquals(1, retrievedEvents_eventCharlie_WithGrossRevenue.size(), 'Expect 1 event without gross revenue unchanged');
        System.assertEquals(1, retrievedEvents_eventDelta_WithGrossRevenue.size(), 'Expect 1 event without gross revenue decreased');
    }
}