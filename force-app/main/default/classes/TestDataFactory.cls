@IsTest
public with sharing class TestDataFactory {
    @TestVisible
    private List<CAMPX__Event__c> createEvents_setup_EventTest() {
        List<CAMPX__Event__c> events = new List<CAMPX__Event__c>();

        CAMPX__Event__c eventAlpha_null = new CAMPX__Event__c(Name = 'eventAlpha_null');

        events.add(eventAlpha_null);

        return events;
    }

    @TestVisible
    private List<CAMPX__Event__c> createEvents_updateNetRevenueOnFinancialChange_on_insert() {
        List<CAMPX__Event__c> events = new List<CAMPX__Event__c>();

        CAMPX__Event__c eventZulu_null = new CAMPX__Event__c(Name = 'eventZulu_null');

        events.add(eventZulu_null);

        CAMPX__Event__c eventYankee_WithRevenueAndExpense = new CAMPX__Event__c(
            Name = 'eventYankee_WithRevenueAndExpense', 
            CAMPX__GrossRevenue__c = 10000, 
            CAMPX__TotalExpenses__c = 5000
        );

        events.add(eventYankee_WithRevenueAndExpense);

        return events;
    }

    @TestVisible
    private List<CAMPX__Event__c> createEvents_setup_SponsorTest() {
        List<CAMPX__Event__c> events = new List<CAMPX__Event__c>();

        CAMPX__Event__c eventAlpha_null = new CAMPX__Event__c(Name = 'eventAlpha_null');

        events.add(eventAlpha_null);

        CAMPX__Event__c eventBravo_WithGrossRevenue = new CAMPX__Event__c(
            Name = 'eventBravo_WithGrossRevenue', 
            CAMPX__GrossRevenue__c = 1000
        );

        events.add(eventBravo_WithGrossRevenue);

        CAMPX__Event__c eventCharlie_WithGrossRevenue = new CAMPX__Event__c(
            Name = 'eventCharlie_WithGrossRevenue', 
            CAMPX__GrossRevenue__c = 1000
        );

        events.add(eventCharlie_WithGrossRevenue);

        CAMPX__Event__c eventDelta_WithGrossRevenue = new CAMPX__Event__c(Name = 'eventDelta_WithGrossRevenue');

        events.add(eventDelta_WithGrossRevenue);

        return events;
    }

    @TestVisible
    private List<CAMPX__Sponsor__c> createSponsors_setup(
        Id eventAlpha_nullId, 
        Id eventDelta_WithGrossRevenueId
    ) {
        List<CAMPX__Sponsor__c> sponsors = new List<CAMPX__Sponsor__c>();

        CAMPX__Sponsor__c sponsorAlpha_null = new CAMPX__Sponsor__c(
            Name = 'sponsorAlpha_null', 
            CAMPX__Email__c = 'sponsorAlpha_null@example.com', 
            CAMPX__Event__c = eventAlpha_nullId
        );

        sponsors.add(sponsorAlpha_null);

        CAMPX__Sponsor__c sponsorBravo_null = new CAMPX__Sponsor__c(
            Name = 'sponsorBravo_null', 
            CAMPX__Email__c = 'sponsorBravo_null@example.com', 
            CAMPX__Event__c = eventAlpha_nullId
        );

        sponsors.add(sponsorBravo_null);

        CAMPX__Sponsor__c sponsorCharlie_null = new CAMPX__Sponsor__c(
            Name = 'sponsorCharlie_null', 
            CAMPX__Email__c = 'sponsorCharlie_null@example.com', 
            CAMPX__Event__c = eventAlpha_nullId
        );

        sponsors.add(sponsorCharlie_null);

        CAMPX__Sponsor__c sponsorDelta_null = new CAMPX__Sponsor__c(
            Name = 'sponsorDelta_null', 
            CAMPX__Email__c = 'sponsorDelta_null@example.com', 
            CAMPX__Event__c = eventAlpha_nullId
        );

        sponsors.add(sponsorDelta_null);

        CAMPX__Sponsor__c sponsorEcho_Accepted_WithContributionAmount = new CAMPX__Sponsor__c(
            Name = 'sponsorEcho_Accepted_WithContributionAmount', 
            CAMPX__Email__c = 'sponsorEcho_Accepted_WithContributionAmount@example.com', 
            CAMPX__Status__c = 'Accepted', 
            CAMPX__ContributionAmount__c = 500, 
            CAMPX__Event__c = eventDelta_WithGrossRevenueId
        );

        sponsors.add(sponsorEcho_Accepted_WithContributionAmount);

        CAMPX__Sponsor__c sponsorFoxtrot_Accepted_WithContributionAmount = new CAMPX__Sponsor__c(
            Name = 'sponsorFoxtrot_Accepted_WithContributionAmount', 
            CAMPX__Email__c = 'sponsorFoxtrot_Accepted_WithContributionAmount@example.com', 
            CAMPX__Status__c = 'Accepted', 
            CAMPX__ContributionAmount__c = 500, 
            CAMPX__Event__c = eventDelta_WithGrossRevenueId
        );

        sponsors.add(sponsorFoxtrot_Accepted_WithContributionAmount);

        return sponsors;
    }

    @TestVisible
    private List<CAMPX__Sponsor__c> createSponsors_defaultStatus(Id eventAlpha_nullId) {
        List<CAMPX__Sponsor__c> sponsors = new List<CAMPX__Sponsor__c>();

        CAMPX__Sponsor__c sponsorZulu_null = new CAMPX__Sponsor__c(
            Name = 'sponsorZulu_null', 
            CAMPX__Email__c = 'sponsorZulu_null@example.com', 
            CAMPX__Event__c = eventAlpha_nullId
        );

        sponsors.add(sponsorZulu_null);

        CAMPX__Sponsor__c sponsorYankee_Accepted = new CAMPX__Sponsor__c(
            Name = 'sponsorYankee_Accepted', 
            CAMPX__Email__c = 'sponsorYankee_Accepted@example.com', 
            CAMPX__Status__c = 'Accepted', 
            CAMPX__Event__c = eventAlpha_nullId
        );

        sponsors.add(sponsorYankee_Accepted);

        return sponsors;
    }

    @TestVisible
    private List<CAMPX__Sponsor__c> createSponsors_updateTierBasedOnContributionAmount(Id eventAlpha_nullId) {
        List<CAMPX__Sponsor__c> sponsors = new List<CAMPX__Sponsor__c>();

        CAMPX__Sponsor__c sponsorZulu_null = new CAMPX__Sponsor__c(
            Name = 'sponsorZulu_null', 
            CAMPX__Email__c = 'sponsorZulu_null@example.com', 
            CAMPX__Event__c = eventAlpha_nullId
        );

        sponsors.add(sponsorZulu_null);

        CAMPX__Sponsor__c sponsorYankee_500 = new CAMPX__Sponsor__c(
            Name = 'sponsorYankee_500', 
            CAMPX__Email__c = 'sponsorYankee_500@example.com', 
            CAMPX__ContributionAmount__c = 500, 
            CAMPX__Event__c = eventAlpha_nullId
        );

        sponsors.add(sponsorYankee_500);

        CAMPX__Sponsor__c sponsorXray_3000 = new CAMPX__Sponsor__c(
            Name = 'sponsorXray_3000', 
            CAMPX__Email__c = 'sponsorXray_3000@example.com', 
            CAMPX__ContributionAmount__c = 3000, 
            CAMPX__Event__c = eventAlpha_nullId
        );

        sponsors.add(sponsorXray_3000);

        CAMPX__Sponsor__c sponsorWhiskey_10000 = new CAMPX__Sponsor__c(
            Name = 'sponsorWhiskey_10000', 
            CAMPX__Email__c = 'sponsorWhiskey_10000@example.com', 
            CAMPX__ContributionAmount__c = 10000, 
            CAMPX__Event__c = eventAlpha_nullId
        );

        sponsors.add(sponsorWhiskey_10000);

        return sponsors;
    }

    @TestVisible
    private List<CAMPX__Sponsor__c> createSponsors_increaseEventGrossRevenueUponSponsorAcceptance_on_insert(
        Id eventAlpha_nullId, 
        Id eventBravo_WithGrossRevenueId, 
        Id eventCharlie_WithGrossRevenueId
    ) {
        List<CAMPX__Sponsor__c> sponsors = new List<CAMPX__Sponsor__c>();

        CAMPX__Sponsor__c sponsorZulu_Accepted_WithContributionAmount = new CAMPX__Sponsor__c(
            Name = 'sponsorZulu_Accepted_WithContributionAmount', 
            CAMPX__Email__c = 'sponsorZulu_Accepted_WithContributionAmount@example.com', 
            CAMPX__Status__c = 'Accepted', 
            CAMPX__ContributionAmount__c = 1000, 
            CAMPX__Event__c = eventAlpha_nullId
        );

        sponsors.add(sponsorZulu_Accepted_WithContributionAmount);

        CAMPX__Sponsor__c sponsorYankee_Accepted_WithContributionAmount = new CAMPX__Sponsor__c(
            Name = 'sponsorYankee_Accepted_WithContributionAmount', 
            CAMPX__Email__c = 'sponsorYankee_Accepted_WithContributionAmount@example.com', 
            CAMPX__Status__c = 'Accepted', 
            CAMPX__ContributionAmount__c = 1000, 
            CAMPX__Event__c = eventBravo_WithGrossRevenueId
        );

        sponsors.add(sponsorYankee_Accepted_WithContributionAmount);

        CAMPX__Sponsor__c sponsorXray_Accepted_WithContributionAmount = new CAMPX__Sponsor__c(
            Name = 'sponsorXray_Accepted_WithContributionAmount', 
            CAMPX__Email__c = 'sponsorXray_Accepted_WithContributionAmount@example.com', 
            CAMPX__Status__c = 'Accepted', 
            CAMPX__ContributionAmount__c = 1000, 
            CAMPX__Event__c = eventBravo_WithGrossRevenueId
        );

        sponsors.add(sponsorXray_Accepted_WithContributionAmount);

        CAMPX__Sponsor__c sponsorWhiskey_Accepted_WithoutContributionAmount = new CAMPX__Sponsor__c(
            Name = 'sponsorWhiskey_Accepted_WithoutContributionAmount', 
            CAMPX__Email__c = 'sponsorWhiskey_Accepted_WithoutContributionAmount@example.com', 
            CAMPX__Status__c = 'Accepted', 
            CAMPX__Event__c = eventCharlie_WithGrossRevenueId
        );

        sponsors.add(sponsorWhiskey_Accepted_WithoutContributionAmount);

        return sponsors;
    }
}