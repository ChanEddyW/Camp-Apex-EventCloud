// https://campapex.org/course/EventCloud
public with sharing class EventTriggerHandler {
    // https://campapex.org/lesson/66104513e4271575745dbb7e (Initializing Event Status upon Creation)
    public void initializeStatus(List<CAMPX__Event__c> triggerDotNew) {
        for (CAMPX__Event__c newEvent : triggerDotNew) {
            newEvent.CAMPX__Status__c = 'Planning';
        }
    }

    // https://campapex.org/lesson/66104513e4271575745dbb7f (Capturing Event Status Change Timestamp)
    public void captureDateAndTimeWhenStatusChanges(List<CAMPX__Event__c> triggerDotNew) {
        for (CAMPX__Event__c newEvent : triggerDotNew) {
            newEvent.CAMPX__StatusChangeDate__c = System.now();
        }
    }

    // https://campapex.org/lesson/66104513e4271575745dbb7f (Capturing Event Status Change Timestamp)
    public void captureDateAndTimeWhenStatusChanges(Map<Id, CAMPX__Event__c> triggerDotOldMap, List<CAMPX__Event__c> triggerDotNew) {
        for (CAMPX__Event__c newEvent : triggerDotNew) {
            if (triggerDotOldMap.get(newEvent.Id).CAMPX__Status__c != newEvent.CAMPX__Status__c) {
                newEvent.CAMPX__StatusChangeDate__c = System.now();
            }
        }
    }

    // https://campapex.org/lesson/66104513e4271575745dbb84 (Automatic Update of Net Revenue on Financial Changes)
    public void updateNetRevenueOnFinancialChange(List<CAMPX__Event__c> triggerDotNew) {
        for (CAMPX__Event__c newEvent : triggerDotNew) {
            final Decimal GROSS_REVENUE = newEvent.CAMPX__GrossRevenue__c;
            final Decimal TOTAL_EXPENSES = newEvent.CAMPX__TotalExpenses__c;

            if (GROSS_REVENUE == null || TOTAL_EXPENSES == null) {
                newEvent.CAMPX__NetRevenue__c = null;
            } else {
                newEvent.CAMPX__NetRevenue__c = GROSS_REVENUE - TOTAL_EXPENSES;
            }
        }
    }
}