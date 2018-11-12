@IsTest public without sharing class CustomOpportunityControllerTest {
        @IsTest(SeeAllData=true) public static void testCustomOpportunityController()
        {
            CustomOpportunityController controller = new CustomOpportunityController();
            controller.opportunityName = 'Test Opportunity Name';
            controller.ppProjectNumber = '91919191734';
            controller.accountName     = 'Acct Test Opportunity';
            controller.companyName     = 'GowebEz';
            controller.mainContact     = 'Sakthivel Palanivelu';
            controller.pp_project_number   = '91919191734';

            PageReference returnValue;

            returnValue = controller.createOpportunity();

            system.debug('------------ page ref  -----------' +returnValue);
                                  
            System.assertNotEquals(returnValue,null);

        }
}