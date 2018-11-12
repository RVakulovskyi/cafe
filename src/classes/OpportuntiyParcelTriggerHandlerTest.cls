/**
 * Created by wendysadeh on 4/27/17.
 * Updated by Rodion Vakulovskyi 02/16/2018
 */

@isTest
private class OpportuntiyParcelTriggerHandlerTest {

    private static testMethod void testInsertRecords() {
        List<Opportunity> opportunities = new List<Opportunity>();
        List<Parcel__c> parcels = new List<Parcel__c>();
        // insert some opportunities
        Opportunity o1 = TestHelperUtility.createOpportunity(null, 'Opportunity 1', null, 'Pre-Qualified Lead', null, null, null, null, null, 'TBD',Date.today()+2, 50.00, 24);
        Opportunity o2 = TestHelperUtility.createOpportunity(null, 'Opportunity 2', null, 'Pre-Qualified Lead', null, null, null, null, null, 'TBD',Date.today()+2, 50.00, 24);
        opportunities.add(o1);
        opportunities.add(o2);
        insert opportunities;
        Test.startTest();
        	parcels.add(TestHelperUtility.createParcel(o1.Id, '123'));
        	parcels.add(TestHelperUtility.createParcel(o1.Id, '456'));
        	parcels.add(TestHelperUtility.createParcel(o2.Id, '789'));
        	parcels.add(TestHelperUtility.createParcel(o2.Id, '100'));
        	insert parcels;
        Test.stopTest();
        Long startTime = DateTime.now().getTime();
        Long finishTime = DateTime.now().getTime();
        while ((finishTime - startTime) < 2000) {
            //sleep for 1s
            finishTime = DateTime.now().getTime();
        }
        // since async, check for the opportunities AFTER tests stop
        List<Opportunity> updatedOpportunities = [SELECT Id, Name, Property_Parcel_Number__c FROM Opportunity WHERE Id IN :opportunities];
        System.assertEquals('123, 456',updatedOpportunities.get(0).Property_Parcel_Number__c);
        System.assertEquals('100, 789',updatedOpportunities.get(1).Property_Parcel_Number__c);

    }

    private static testMethod void testDeleteRecords() {
        List<Opportunity> opportunities = new List<Opportunity>();
        List<Parcel__c> parcels = new List<Parcel__c>();
        // insert an opportunities
        Opportunity o1 = TestHelperUtility.createOpportunity(null, 'Opportunity 1', null, 'Pre-Qualified Lead', null, null, null, null, null, 'TBD',Date.today()+2, 50.00, 24);
        opportunities.add(o1);
        insert opportunities;
        Test.startTest();
        	parcels.add(TestHelperUtility.createParcel(o1.Id, '100'));
        	parcels.add(TestHelperUtility.createParcel(o1.Id, '200'));
        	parcels.add(TestHelperUtility.createParcel(o1.Id, '300'));
        	parcels.add(TestHelperUtility.createParcel(o1.Id, '400'));
        	insert parcels;
       		// now delete a record
        	delete parcels.get(3);
        Test.stopTest();
        Long startTime = DateTime.now().getTime();
        Long finishTime = DateTime.now().getTime();
        while ((finishTime - startTime) < 1000) {
            //sleep for 1s
            finishTime = DateTime.now().getTime();
        }
        List<Opportunity> updatedOpportunities = [SELECT Id, Name, Property_Parcel_Number__c FROM Opportunity WHERE Id IN :opportunities];
        System.assertEquals('100, 200, 300',updatedOpportunities.get(0).Property_Parcel_Number__c);
    }

}