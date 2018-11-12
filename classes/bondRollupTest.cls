@isTest
private class bondRollupTest{
    static Account acc;
    static Bond__c bond;
    static Parcel__c parcel;
    static Parcel__c parcel2;
    static list<contact> contacts;
    static list<Payments__c> payments;
    static Opportunity op1;
    
    static void dataSetup()
    {
       acc = new Account();
       acc.Name = 'TestAccounts';
       acc.Type = 'Channel Partner';
       acc.Client_Status__c = 'Pre-Contact';
       acc.Sub_Lead_Source__c ='test';
       acc.CF_Lead_Source__c ='Other';
       acc.Account_Type__c = 'N/A';
       
       insert acc;

        bond = new Bond__c();
        insert bond;

       contacts = new list<Contact>();
       
       // Create two contacts
       Contact ct1 = new Contact( accountid = acc.Id );
       Contact ct2 = new Contact( accountid = acc.Id );
       ct1.FirstName = 'Larrys';
       ct1.LastName = 'Page';
       ct2.FirstName = 'Marc';
       ct2.LastName = 'Buymeoff';
       contacts.add(ct1);
       contacts.add(ct2);
       Insert contacts;   
       
       op1 = new Opportunity( accountid = acc.Id );
       op1.name = 'Opportunity Contact Insertion Test';
       op1.CloseDate =  Date.today()+2;
       op1.StageName = 'Qualified Lead';
       op1.LeadSource ='Channel Parnter';
       op1.Channel_Partner_Main_Contact__c = contacts[0].Id ;
       op1.LOI_Executed_Date__c = system.today();
       op1.LOI_Sent_Date__c = system.today();
       op1.Project_Type__c = 'TBD';
       op1.Type_of_Improvements__c ='EE';
       op1.Construction_Work_Status__c = 'N/A';
       op1.Project_Objective__c = 'Property Upgrades';
       op1.Mortgage_Lender__c = acc.Id;
       op1.Type_of_Lender__c ='Permanent';
       op1.Type_of_Loan_First__c='Permanent';
       op1.Financing_Amount__c = 100.00;
       op1.Est_Improvement_Cost__c = 50.00;
        op1.Total_Financing_Fee__c=2.5;
        op1.Channel_Partner__c=2.5;
       op1.Project_Overview__c ='Overview';
       op1.Loan_Term__c = 24;
       op1.Interest_Rate__c = 7.5;
       op1.Transaction_Manager__c = userinfo.getUserId();
       op1.Channel_Partner_Entity__c = acc.Id;
       op1.Legal_Name_of_Property_Owner__c = 'John Cena';
       op1.Physical_Address__c = 'ABC lane';
       op1.County__c = 'Marion';
       op1.Municipality__c = 'MCF';
       op1.State_Prop__c = 'MN';
       op1.Zip_Code__c = '12108';
       op1.Building_Size__c = 95.0;
       op1.Building_Size_Type__c = 'Sq Ft';
       op1.Primary_Property_Type__c  = 'Office';
       op1.Sub_Vertical_Property_Type__c  = 'Big Box';
       op1.Solar_Component__c = 'Yes';
       op1.Project_Qualified_Date__c = system.today();
       op1.Initial_App_Date__c =  system.today();
       op1.Final_Program_Approval_Date__c = system.today();
       op1.CF_Commitment_Date__c = system.today();
       op1.Solar_TPO_Structure__c = 'PPA';
       op1.Solar_PV_System_Size_kW__c = 40;
       op1.Year_1_Electricity_kWh_Production_Est__c = 4500 ;
       op1.PPA_Services_Term_Yrs__c = 4500;
       op1.Optional_Partial_Bond_Prepayment__c = 'Yes';
       op1.Solar_System_Ownershipo__c = 'TBD';
        op1.Bond__c = bond.Id;

        insert op1;



        parcel = new Parcel__c();
        parcel.Name = '123456';
        parcel.Opportunity__c = op1.Id;
        insert parcel;




    }
    
    static testmethod void TestOpportunityTrgr1() {

        Decimal expectedAmount=5000.00;
        list<Bond__c> testBond;
        
        dataSetup();

        payments = new list<Payments__c>();

        Payments__c pay1 = new Payments__c();
        Payments__c pay2 = new Payments__c();

        pay1.Parcel__c = parcel.Id;
        pay1.Payment__c = 1000;
        pay1.Interest__c = 1000;
        pay2.Parcel__c = parcel.Id;
        pay2.Payment__c = 4000;
        pay2.Interest__c = 1000;

        payments.add(pay1);
        payments.add(pay2);

        Test.startTest();

            Insert payments;

        Test.stopTest();


        testBond = [
                SELECT Id, Bond_Amount__c
                FROM Bond__c
                WHERE Id = :bond.Id
        ];

        System.assert(testBond.size()>0
                ,'Found a record');
        System.assertEquals(expectedAmount, testBond[0].Bond_Amount__c);

     }        
     
     static testmethod void TestOpportunityTrgr2() {

         Decimal expectedAmount=7000.00;
         list<Bond__c> testBond;
         
         dataSetup();

         parcel2 = new Parcel__c();
         parcel2.Name = '123ee456s';
         parcel2.Opportunity__c = op1.Id;
         insert parcel2;


         payments = new list<Payments__c>();

         Payments__c pay1 = new Payments__c();
         Payments__c pay2 = new Payments__c();

         pay1.Parcel__c = parcel.Id;
         pay1.Payment__c = 3000;
         pay1.Interest__c = 3000;
         pay2.Parcel__c = parcel2.Id;
         pay2.Payment__c = 4000;
         pay2.Interest__c = 1000;

         payments.add(pay1);
         payments.add(pay2);
          
         Test.startTest();
            Insert payments;
         Test.stopTest();

         testBond = [
                 SELECT Id, Bond_Amount__c
                 FROM Bond__c
                 WHERE Id = :bond.Id
         ];

         System.assert(testBond.size()>0
                 ,'Found a record');

         System.assertEquals(expectedAmount, testBond[0].Bond_Amount__c);
     }
}