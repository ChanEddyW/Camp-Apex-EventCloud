// https://campapex.org/course/EventCloud
trigger EventTrigger on CAMPX__Event__c (before insert, before update) {
    EventTriggerHandler eventTriggerHandler = new EventTriggerHandler();

    switch on Trigger.operationType {
        when BEFORE_INSERT {
            // https://campapex.org/lesson/66104513e4271575745dbb7e (Initializing Event Status upon Creation)
            eventTriggerHandler.initializeStatus(Trigger.new);

            // https://campapex.org/lesson/66104513e4271575745dbb7f (Capturing Event Status Change Timestamp)
            eventTriggerHandler.captureDateAndTimeWhenStatusChanges(Trigger.new);

            // https://campapex.org/lesson/66104513e4271575745dbb84 (Automatic Update of Net Revenue on Financial Changes)
            eventTriggerHandler.updateNetRevenueOnFinancialChange(Trigger.new);
        }

        when BEFORE_UPDATE {
            // https://campapex.org/lesson/66104513e4271575745dbb7f (Capturing Event Status Change Timestamp)
            eventTriggerHandler.captureDateAndTimeWhenStatusChanges(Trigger.oldMap, Trigger.new);

            // https://campapex.org/lesson/66104513e4271575745dbb84 (Automatic Update of Net Revenue on Financial Changes)
            eventTriggerHandler.updateNetRevenueOnFinancialChange(Trigger.new);
        }
    }
}