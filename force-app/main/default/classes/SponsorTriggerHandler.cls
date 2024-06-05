// https://campapex.org/course/EventCloud
public with sharing class SponsorTriggerHandler {
    // https://campapex.org/lesson/66104513e4271575745dbb80 (Defaulting Sponsor Status to Pending on Creation)
    public void defaultStatus(List<CAMPX__Sponsor__c> triggerDotNew) {
        for (CAMPX__Sponsor__c newSponsor : triggerDotNew) {
            if (newSponsor.CAMPX__Status__c == null) {
                newSponsor.CAMPX__Status__c = 'Pending';
            }
        }
    }

    // https://campapex.org/lesson/66104513e4271575745dbb81 (Enforcing Email Requirement for Sponsor Creation)
    public void enforceEmail(List<CAMPX__Sponsor__c> triggerDotNew) {
        for (CAMPX__Sponsor__c newSponsor : triggerDotNew) {
            if (newSponsor.CAMPX__Email__c == null) {
                String ERROR = 'A sponsor can not be created without an email address';

                newSponsor.addError(ERROR);
            }
        }
    }

    // https://campapex.org/lesson/66104513e4271575745dbb82 (Updating Sponsor Tier Based on Contribution Amount)
    public void updateTierBasedOnContributionAmount(List<CAMPX__Sponsor__c> triggerDotNew) {
        for (CAMPX__Sponsor__c newSponsor : triggerDotNew) {
            final Decimal NEW_AMOUNT = newSponsor.CAMPX__ContributionAmount__c;

            if (NEW_AMOUNT == null || NEW_AMOUNT <= 0) {
                continue;
            } else if (NEW_AMOUNT > 0 && NEW_AMOUNT < 1000) {
                newSponsor.CAMPX__Tier__c = 'Bronze';
            } else if (NEW_AMOUNT >= 1000 && NEW_AMOUNT < 5000) {
                newSponsor.CAMPX__Tier__c = 'Silver';
            } else if (NEW_AMOUNT >= 5000) {
                newSponsor.CAMPX__Tier__c = 'Gold';
            }
        }
    }

    // https://campapex.org/lesson/66104513e4271575745dbb83 (Conditional Sponsor Status Update Based on Event Association)
    public void preventAcceptingSponsorWithoutEvent(List<CAMPX__Sponsor__c> triggerDotNew) {
        for (CAMPX__Sponsor__c newSponsor : triggerDotNew) {
            if (newSponsor.CAMPX__Status__c == 'Accepted' && newSponsor.CAMPX__Event__c == null) {
                String ERROR = 'A Sponsor must be associated with an event before being Accepted.';

                newSponsor.addError(ERROR);
            }
        }
    }


    // https://campapex.org/lesson/66104513e4271575745dbb83 (Conditional Sponsor Status Update Based on Event Association)
    public void preventAcceptingSponsorWithoutEvent(Map<Id, CAMPX__Sponsor__c> triggerDotOldMap, List<CAMPX__Sponsor__c> triggerDotNew) {
        for (CAMPX__Sponsor__c newSponsor : triggerDotNew) {
            final STRING OLD_STATUS = triggerDotOldMap.get(newSponsor.Id).CAMPX__Status__c;
            final STRING NEW_STATUS = newSponsor.CAMPX__Status__c;

            if (
                OLD_STATUS != NEW_STATUS 
                && NEW_STATUS == 'Accepted' 
                && newSponsor.CAMPX__Event__c == null
            ) {
                String ERROR = 'A Sponsor must be associated with an event before being Accepted.';

                newSponsor.addError(ERROR);
            }
        }
    }

    // https://campapex.org/lesson/66104513e4271575745dbb85 (Updating Event Gross Revenue upon Sponsor Acceptance)
    public void increaseEventGrossRevenueUponSponsorAcceptance(List<CAMPX__Sponsor__c> triggerDotNew) {
        Map<Id, Decimal> newAmountsByNewEventId = new Map<Id, Decimal>();

        for (CAMPX__Sponsor__c newSponsor : triggerDotNew) {
            final Decimal NEW_AMOUNT = newSponsor.CAMPX__ContributionAmount__c;

            final Id NEW_EVENT_ID = newSponsor.CAMPX__Event__c;

            if (
                NEW_AMOUNT == null 
                || NEW_AMOUNT == 0 
                || newSponsor.CAMPX__Status__c != 'Accepted'
            ) {
                continue;
            } else if (newAmountsByNewEventId.containsKey(NEW_EVENT_ID)) {
                final Decimal AMOUNT = newAmountsByNewEventId.get(NEW_EVENT_ID);

                newAmountsByNewEventId.put(NEW_EVENT_ID, AMOUNT + NEW_AMOUNT);
            } else if (!newAmountsByNewEventId.containsKey(NEW_EVENT_ID)) {
                newAmountsByNewEventId.put(NEW_EVENT_ID, NEW_AMOUNT);
            }
        }

        if (newAmountsByNewEventId.isEmpty()) {
            return;
        }

        List<CAMPX__Event__c> eventToUpdates = [
            SELECT 
                Id, 
                CAMPX__GrossRevenue__c 
            FROM CAMPX__Event__c 
            WHERE Id IN :newAmountsByNewEventId.keySet()
        ];

        for (CAMPX__Event__c eventToUpdate : eventToUpdates) {
            final Id EVENT_ID = eventToUpdate.Id;

            if (eventToUpdate.CAMPX__GrossRevenue__c == null) {
                eventToUpdate.CAMPX__GrossRevenue__c = newAmountsByNewEventId.get(EVENT_ID);
            } else {
                eventToUpdate.CAMPX__GrossRevenue__c += newAmountsByNewEventId.get(EVENT_ID);
            }
        }

        if (Schema.sObjectType.CAMPX__Event__c.isUpdateable()) {
            update as user eventToUpdates;
        }
    }

    // https://campapex.org/lesson/66104513e4271575745dbb85 (Updating Event Gross Revenue upon Sponsor Acceptance)
    public void increaseEventGrossRevenueUponSponsorAcceptance(Map<Id, CAMPX__Sponsor__c> triggerDotOldMap, List<CAMPX__Sponsor__c> triggerDotNew) {
        Map<Id, Decimal> newAmountsByNewEventId = new Map<Id, Decimal>();

        for (CAMPX__Sponsor__c newSponsor : triggerDotNew) {
            final Decimal NEW_AMOUNT = newSponsor.CAMPX__ContributionAmount__c;

            final STRING OLD_STATUS = triggerDotOldMap.get(newSponsor.Id).CAMPX__Status__c;
            final STRING NEW_STATUS = newSponsor.CAMPX__Status__c;

            final Id NEW_EVENT_ID = newSponsor.CAMPX__Event__c;

            if (
                NEW_AMOUNT == null 
                || NEW_AMOUNT == 0 
                || OLD_STATUS == NEW_STATUS 
                || NEW_STATUS != 'Accepted'
            ) {
                continue;
            } else if (newAmountsByNewEventId.containsKey(NEW_EVENT_ID)) {
                final Decimal AMOUNT = newAmountsByNewEventId.get(NEW_EVENT_ID);

                newAmountsByNewEventId.put(NEW_EVENT_ID, AMOUNT + NEW_AMOUNT);
            } else if (!newAmountsByNewEventId.containsKey(NEW_EVENT_ID)) {
                newAmountsByNewEventId.put(NEW_EVENT_ID, NEW_AMOUNT);
            }
        }

        if (newAmountsByNewEventId.isEmpty()) {
            return;
        }

        List<CAMPX__Event__c> eventToUpdates = [
            SELECT 
                Id, 
                CAMPX__GrossRevenue__c 
            FROM CAMPX__Event__c 
            WHERE Id IN :newAmountsByNewEventId.keySet()
        ];

        for (CAMPX__Event__c eventToUpdate : eventToUpdates) {
            final Id EVENT_ID = eventToUpdate.Id;

            if (eventToUpdate.CAMPX__GrossRevenue__c == null) {
                eventToUpdate.CAMPX__GrossRevenue__c = newAmountsByNewEventId.get(EVENT_ID);
            } else {
                eventToUpdate.CAMPX__GrossRevenue__c += newAmountsByNewEventId.get(EVENT_ID);
            }
        }

        if (Schema.sObjectType.CAMPX__Event__c.isUpdateable()) {
            update as user eventToUpdates;
        }
    }

    // https://campapex.org/lesson/66104513e4271575745dbb86 (Adjusting Event Gross Revenue for Cancelled Sponsorships Or Event Changes)
    public void decreaseEventGrossRevenueUponSponsorChange(Map<Id, CAMPX__Sponsor__c> triggerDotOldMap, List<CAMPX__Sponsor__c> triggerDotNew) {
        Map<Id, Decimal> oldAmountsByOldEventId = new Map<Id, Decimal>();

        for (CAMPX__Sponsor__c newSponsor : triggerDotNew) {
            final Decimal OLD_AMOUNT = triggerDotOldMap.get(newSponsor.Id).CAMPX__ContributionAmount__c;

            final Id OLD_EVENT_ID = triggerDotOldMap.get(newSponsor.Id).CAMPX__Event__c;
            final Id NEW_EVENT_ID = newSponsor.CAMPX__Event__c;

            final String OLD_STATUS = triggerDotOldMap.get(newSponsor.Id).CAMPX__Status__c;
            final String NEW_STATUS = newSponsor.CAMPX__Status__c;

            if (
                OLD_AMOUNT == null 
                || OLD_AMOUNT == 0 
                || (
                    OLD_EVENT_ID == NEW_EVENT_ID 
                    && (OLD_STATUS == NEW_STATUS || OLD_STATUS != 'Accepted')
                ) 
                || (
                    OLD_EVENT_ID == NEW_EVENT_ID 
                    && OLD_STATUS != NEW_STATUS 
                    && OLD_STATUS == 'Accepted' 
                    && NEW_STATUS != 'Rejected' 
                    && NEW_STATUS != 'Pending'
                )
            ) {
                continue;
            } else if (oldAmountsByOldEventId.containsKey(OLD_EVENT_ID)) {
                final Decimal AMOUNT = oldAmountsByOldEventId.get(OLD_EVENT_ID);

                oldAmountsByOldEventId.put(OLD_EVENT_ID, AMOUNT + OLD_AMOUNT);
            } else if (!oldAmountsByOldEventId.containsKey(OLD_EVENT_ID)) {
                oldAmountsByOldEventId.put(OLD_EVENT_ID, OLD_AMOUNT);
            }
        }

        if (oldAmountsByOldEventId.isEmpty()) {
            return;
        }

        List<CAMPX__Event__c> eventToUpdates = [
            SELECT 
                Id, 
                CAMPX__GrossRevenue__c 
            FROM CAMPX__Event__c 
            WHERE Id IN :oldAmountsByOldEventId.keySet()
        ];

        for (CAMPX__Event__c eventToUpdate : eventToUpdates) {
            final Id EVENT_ID = eventToUpdate.Id;

            final Decimal GROSS_REVENUE = eventToUpdate.CAMPX__GrossRevenue__c;

            if (GROSS_REVENUE != null && GROSS_REVENUE != 0) {
                eventToUpdate.CAMPX__GrossRevenue__c -= oldAmountsByOldEventId.get(EVENT_ID);
            }
        }

        if (Schema.sObjectType.CAMPX__Event__c.isUpdateable()) {
            update as user eventToUpdates;
        }
    }
}