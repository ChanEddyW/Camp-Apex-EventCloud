// https://campapex.org/course/EventCloud
trigger SponsorTrigger on CAMPX__Sponsor__c (before insert, after insert, before update, after update) {
    SponsorTriggerHandler sponsorTriggerHandler = new SponsorTriggerHandler();

    switch on Trigger.operationType {
        when BEFORE_INSERT {
            // https://campapex.org/lesson/66104513e4271575745dbb80 (Defaulting Sponsor Status to Pending on Creation)
            sponsorTriggerHandler.defaultStatus(Trigger.new);

            // https://campapex.org/lesson/66104513e4271575745dbb81 (Enforcing Email Requirement for Sponsor Creation)
            sponsorTriggerHandler.enforceEmail(Trigger.new);

            // https://campapex.org/lesson/66104513e4271575745dbb82 (Updating Sponsor Tier Based on Contribution Amount)
            sponsorTriggerHandler.updateTierBasedOnContributionAmount(Trigger.new);

            // https://campapex.org/lesson/66104513e4271575745dbb83 (Conditional Sponsor Status Update Based on Event Association)
            sponsorTriggerHandler.preventAcceptingSponsorWithoutEvent(Trigger.new);
        }

        when BEFORE_UPDATE {
            // https://campapex.org/lesson/66104513e4271575745dbb82 (Updating Sponsor Tier Based on Contribution Amount)
            sponsorTriggerHandler.updateTierBasedOnContributionAmount(Trigger.new);

            // https://campapex.org/lesson/66104513e4271575745dbb83 (Conditional Sponsor Status Update Based on Event Association)
            sponsorTriggerHandler.preventAcceptingSponsorWithoutEvent(Trigger.oldMap, Trigger.new);
        }

        when AFTER_INSERT {
            // https://campapex.org/lesson/66104513e4271575745dbb85 (Updating Event Gross Revenue upon Sponsor Acceptance)
            sponsorTriggerHandler.increaseEventGrossRevenueUponSponsorAcceptance(Trigger.new);
        }

        when AFTER_UPDATE {
            // https://campapex.org/lesson/66104513e4271575745dbb85 (Updating Event Gross Revenue upon Sponsor Acceptance)
            sponsorTriggerHandler.increaseEventGrossRevenueUponSponsorAcceptance(Trigger.oldMap, Trigger.new);

            // https://campapex.org/lesson/66104513e4271575745dbb86 (Adjusting Event Gross Revenue for Cancelled Sponsorships Or Event Changes)
            sponsorTriggerHandler.decreaseEventGrossRevenueUponSponsorChange(Trigger.oldMap, Trigger.new);
        }
    }
}