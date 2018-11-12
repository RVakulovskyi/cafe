@IsTest public without sharing class CustomOpportunitySaveExtensionTest
        {
        @IsTest(SeeAllData=true) public static void testCustomOpportunitySaveExtension()
        {
//                Opportunity opp;
//                List<Opportunity> opplst = [
//                                                SELECT Id
//                                                FROM Opportunity
//                                                LIMIT 1
//                                            ];
//
//                  if ( opplst.size() > 0 )
//                  {
//                      opp = opplst[0];
//                      system.debug('Successfully account retrieved ');
//                  }

                // set up opp and Verify that the results are as expected.
//                Opportunity o = new Opportunity(AccountId=null, Name=opportunityName,
//                        StageName='Pre-Qualified Lead', CloseDate=Date.today(), Loan_Term__c=20,
//                        LeadSource='Channel Partner', Sub_Lead_Source__c='Cool Patner');
//                insert o;
//                Opportunity opp = [SELECT Name FROM Opportunity WHERE Id = :o.Id];

                CustomOpportunityController controller = new CustomOpportunityController();
                controller.opportunityName = 'TestOpportunityName';
                controller.ppProjectNumber = '91919191734';
                controller.accountName     = 'Acct Test Opportunity';
                controller.companyName     = 'GowebEz';
                controller.mainContact     = 'Sakthivel Palanivelu';
                controller.pp_project_number   = '91919191734';


                controller.createOpportunity();

                Opportunity opp;

                List<Opportunity> opplst = [
                                                SELECT Id, Name
                                                FROM Opportunity
                                                WHERE Name = 'TestOpportunityName'
                                                LIMIT 1
                                            ];

                  if ( opplst.size() > 0 )
                  {
                      opp = opplst[0];
                      system.debug('Successfully opportunity retrieved ');
                  }

//                System.assertEquals('TestOpportunityName', opp.Name);

          
                Test.Starttest();
                ApexPages.StandardController stdController = new ApexPages.StandardController(opp);
                CustomOpportunitySaveExtension ext = new CustomOpportunitySaveExtension(stdController);
                ext.CheckAndValidate();
                System.assertNotEquals(ext.validationMessage,null);
            
                opp.Owner_Occupied__c = 'Yes';
                opp.Business_Revenue__c = null;
                opp.Financial_Crime__c = null;
                opp.Primary_Property_Type__c = 'Retail';
                opp.Physical_Address__c = null;
                opp.Municipality__c = null;
                opp.Property_Purchase_Price__c = null;
                opp.PACEPartner_Mailing_City__c = null;
                opp.PACEPartner_Email__c = null;
                opp.PACEPartner_Mailing_Zip_Code__c = null;


                UPDATE opp;
            
                system.debug('This is the owner_occupied value ' + opp.Owner_Occupied__c);
                system.debug('This is the Business_Revenue__c value ' + opp.Business_Revenue__c);
                system.debug('This is a new debug messagesddddddd.........' + ext.validationMessage);
                ext.CheckAndValidate();
                System.assert(ext.validationMessage.contains('Business Revenue'));
                System.assert(ext.validationMessage.contains('Financial Crime'));
                System.assert(!ext.validationMessage.contains('Primary Property'));
                System.assert(ext.validationMessage.contains('Property Information - City'));
                System.assert(ext.validationMessage.contains('Property Information - Street Addres'));
                System.assert(ext.validationMessage.contains('Property Information - Property Purchase Price'));
                System.assert(ext.validationMessage.contains('PACEPartner Contact Information - City'));
                System.assert(ext.validationMessage.contains('PACEPartner Contact Information - Email'));
                System.assert(ext.validationMessage.contains('PACEPartner Contact Information - Zip Code'));


                opp.Owner_Occupied__c = 'No';
                opp.Physical_Address__c = '123 Main';
                opp.Municipality__c = 'oakland';
                opp.Property_Purchase_Price__c = 10;
                opp.PACEPartner_Mailing_City__c = 'Alameda';
                opp.PACEPartner_Email__c = 'joe@example.com';
                opp.PACEPartner_Mailing_Zip_Code__c = '1234';

                UPDATE opp;
                ext.CheckAndValidate();
                system.debug('This is a new owner occupied.........' + ext.validationMessage);
                System.assert(!ext.validationMessage.contains('Property Information - Street Addres'));
                System.assert(!ext.validationMessage.contains('PACEPartner Contact Information - City'));
                System.assert(!ext.validationMessage.contains('PACEPartner Contact Information - Email'));
                System.assert(!ext.validationMessage.contains('PACEPartner Contact Information - Zip Code'));


                opp.Is_there_a_groundlease_in_place__c = 'Yes';
                opp.If_groundlease_expiration_date__c = null;
                UPDATE opp;
                ext.CheckAndValidate();
                System.assert(ext.validationMessage.contains('If groundlease, expiration date'));

                system.debug('This is the stage name........................ ' + opp.StageName);


                Test.Stoptest();
        }

   }