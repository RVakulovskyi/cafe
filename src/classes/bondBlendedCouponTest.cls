/**
 * Created by wendysadeh on 10/20/16.
 */
@isTest
public with sharing class bondBlendedCouponTest {
    static Account acc;
    static Bond__c bond;
    static Parcel__c parcel;
    static Parcel__c parcel2;
    static list<contact> contacts;
    static list<Payments__c> payments;
    static Opportunity op1;
    static Opportunity op2;

    static void dataSetup() {
        acc = TestHelperUtility.createAccount(null, null, 'TestAccountss', 'Pre-Contact', 'Channel Partner');
        insert acc;
        bond = TestHelperUtility.createBond();
        insert bond;
        contacts = new list<Contact>();
        // Create two contacts
        Contact ct1 = TestHelperUtility.createContact(acc.Id, 'Larrys', 'Page');
        Contact ct2 = TestHelperUtility.createContact(acc.Id, 'Marc', 'Buymeoff');
        contacts.add(ct1);
        contacts.add(ct2);
        Insert contacts;
        op1 = TestHelperUtility.createOpportunityForBonds(acc.Id, contacts[0].Id, bond.Id, 'Opportunity Contact Insertion Test', 7.5);
        insert op1;
        op2 = TestHelperUtility.createOpportunityForBonds(acc.Id, contacts[0].Id, bond.Id, 'Opportunity Contact Insertion Test2', 5.5);
        insert op2;
        parcel = TestHelperUtility.createParcel(op1.Id, '123456');
        insert parcel;
        parcel2 = TestHelperUtility.createParcel(op2.Id, '123ee456s');
        insert parcel2;
    }

    static testmethod void TestOpportunityTrgr1() {
        Decimal expectedAmount = 5.9;
        list<Bond__c> testBond;
        dataSetup();
        payments = new list<Payments__c>();
        Payments__c pay1 = TestHelperUtility.createPayment(parcel.Id, 1000, 1000, 'P & I');
        Payments__c pay2 = TestHelperUtility.createPayment(parcel2.Id, 4000, 1000, 'P & I');
        payments.add(pay1);
        payments.add(pay2);
        Test.startTest();
            insert payments;
        Test.stopTest();
        testBond = [SELECT Id, Blended_Coupon__c FROM Bond__c WHERE Id = :bond.Id];
        System.assert(testBond.size() > 0 ,'Found a record');
        System.assertEquals(expectedAmount, testBond[0].Blended_Coupon__c);
    }

    static testmethod void TestOpportunityTrgr2() {
        Decimal expectedAmount = 6.357;
        list<Bond__c> testBond;
        dataSetup();
        payments = new list<Payments__c>();
        Payments__c pay1 = TestHelperUtility.createPayment(parcel.Id, 3000, 3000, 'P & I');
        Payments__c pay2 = TestHelperUtility.createPayment(parcel2.Id, 4000, 1000, 'P & I');
        payments.add(pay1);
        payments.add(pay2);
        Test.startTest();
            insert payments;
        Test.stopTest();
        testBond = [SELECT Id, Blended_Coupon__c FROM Bond__c WHERE Id = :bond.Id];
        System.assert(testBond.size() >0 ,'Found a record');
        System.assertEquals(expectedAmount, testBond[0].Blended_Coupon__c);
    }

}