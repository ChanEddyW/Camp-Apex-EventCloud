// https://campapex.org/course/EventCloud
@IsTest
private with sharing class EventTest {
    private static TestDataFactory testDataFactory = new TestDataFactory();

    @TestSetup
    private static void setup() {
        List<CAMPX__Event__c> eventsToInsert = testDataFactory.createEvents_setup_EventTest();

        if (Schema.sObjectType.CAMPX__Event__c.isCreateable()) {
            insert as user eventsToInsert;
        }
    }

    // https://campapex.org/lesson/66104513e4271575745dbb7e (Initializing Event Status upon Creation)
    @IsTest
    private static void set_status_to_Planning_on_insert() {
        // GIVEN
        CAMPX__Event__c eventZulu_null = new CAMPX__Event__c(Name = 'eventZulu_null');

        // WHEN
        Test.startTest();

        if (Schema.sObjectType.CAMPX__Event__c.isCreateable()) {
            insert as user eventZulu_null;
        }

        Test.stopTest();

        // THEN
        final String NAME = 'eventZulu_null';
        final String PLANNING = 'Planning';

        List<CAMPX__Event__c> retrievedEvents = [
            SELECT Id 
            FROM CAMPX__Event__c 
            WHERE Name = :NAME 
                AND CAMPX__Status__c = :PLANNING 
            WITH USER_MODE
        ];

        System.assertEquals(1, retrievedEvents.size(), 'Expect 1 event with Planning status');
    }

    // https://campapex.org/lesson/66104513e4271575745dbb7f (Capturing Event Status Change Timestamp)
    @IsTest
    private static void capture_status_change_timestamp_on_insert() {
        // GIVEN
        CAMPX__Event__c eventZulu_null = new CAMPX__Event__c(Name = 'eventZulu_null');

        // WHEN
        Test.startTest();

        if (Schema.sObjectType.CAMPX__Event__c.isCreateable()) {
            insert as user eventZulu_null;
        }

        Test.stopTest();

        // THEN
        final String NAME = 'eventZulu_null';
        final Datetime TIMESTAMP = System.now();

        List<CAMPX__Event__c> retrievedEvents = [
            SELECT Id 
            FROM CAMPX__Event__c 
            WHERE Name = :NAME 
                AND CAMPX__StatusChangeDate__c = :TIMESTAMP 
            WITH USER_MODE
        ];

        System.assertEquals(1, retrievedEvents.size(), 'Expect 1 event with status change timestamp');
    }

    // https://campapex.org/lesson/66104513e4271575745dbb7f (Capturing Event Status Change Timestamp)
    @IsTest
    private static void capture_status_change_timestamp_on_update() {
        // GIVEN
        final String NAME = 'eventAlpha_null';

        List<CAMPX__Event__c> eventsToUpdate = [
            SELECT 
                Name, 
                CAMPX__Status__c 
            FROM CAMPX__Event__c 
            WHERE Name = :NAME 
            WITH USER_MODE 
            LIMIT 1
        ];

        for (CAMPX__Event__c eventToUpdate : eventsToUpdate) {
            if (eventToUpdate.Name == 'eventAlpha_null') {
                eventToUpdate.CAMPX__Status__c = 'Cancelled';
            }
        }

        // WHEN
        Test.startTest();

        if (Schema.sObjectType.CAMPX__Event__c.isUpdateable()) {
            update as user eventsToUpdate;
        }

        Test.stopTest();

        // THEN
        final Datetime TIMESTAMP = System.now();

        List<CAMPX__Event__c> retrievedEvents = [
            SELECT Id 
            FROM CAMPX__Event__c 
            WHERE Name = :NAME 
                AND CAMPX__StatusChangeDate__c = :TIMESTAMP 
            WITH USER_MODE
        ];

        System.assertEquals(1, retrievedEvents.size(), 'Expect 1 event with status change timestamp');
    }

    // https://campapex.org/lesson/66104513e4271575745dbb84 (Automatic Update of Net Revenue on Financial Changes)
    @IsTest
    private static void update_net_revenue_on_financial_change_on_insert() {
        // GIVEN
        List<CAMPX__Event__c> eventsToInsert = testDataFactory.createEvents_updateNetRevenueOnFinancialChange_on_insert();

        // WHEN
        Test.startTest();

        if (Schema.sObjectType.CAMPX__Event__c.isCreateable()) {
            insert as user eventsToInsert;
        }

        Test.stopTest();

        // THEN
        final List<String> NAMES = new List<String>{
            'eventZulu_null', 
            'eventYankee_WithRevenueAndExpense'
        };

        final Decimal NET_REVENUE = 5000;

        List<CAMPX__Event__c> retrievedEvents = [
            SELECT Id 
            FROM CAMPX__Event__c 
            WHERE Name IN :NAMES 
                AND CAMPX__NetRevenue__c = :NET_REVENUE 
            WITH USER_MODE
        ];

        System.assertEquals(1, retrievedEvents.size(), 'Expect 1 event with the net revenue updated');
    }

    // https://campapex.org/lesson/66104513e4271575745dbb84 (Automatic Update of Net Revenue on Financial Changes)
    @IsTest
    private static void update_net_revenue_on_financial_change_on_update() {
        // GIVEN
        final String NAME = 'eventAlpha_null';

        List<CAMPX__Event__c> eventsToUpdate = [
            SELECT 
                Name, 
                CAMPX__Status__c 
            FROM CAMPX__Event__c 
            WHERE Name = :NAME 
            WITH USER_MODE 
            LIMIT 1
        ];

        for (CAMPX__Event__c eventToUpdate : eventsToUpdate) {
            if (eventToUpdate.Name == 'eventAlpha_null') {
                eventToUpdate.CAMPX__GrossRevenue__c = 10000;
                eventToUpdate.CAMPX__TotalExpenses__c = 5000;
            }
        }

        // WHEN
        Test.startTest();

        if (Schema.sObjectType.CAMPX__Event__c.isUpdateable()) {
            update as user eventsToUpdate;
        }

        Test.stopTest();

        // THEN
        final Decimal NET_REVENUE = 5000;

        List<CAMPX__Event__c> retrievedEvents = [
            SELECT Id 
            FROM CAMPX__Event__c 
            WHERE Name = :NAME 
                AND CAMPX__NetRevenue__c = :NET_REVENUE 
            WITH USER_MODE
        ];

        System.assertEquals(1, retrievedEvents.size(), 'Expect 1 event with the net revenue updated');
    }
}