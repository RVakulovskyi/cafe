@isTest
private class updateTenantSortOrderHandlerTest {

    private static testMethod void testInsertRecords() {

        List<Opportunity> opportunities = new List<Opportunity>();
        List<Tenant__c> tenants = new List<Tenant__c>();

        // insert some opportunities
        Opportunity o1 = new Opportunity(name='Opportunity 1',StageName='Pre-Qualified Lead', Project_Type__c='TBD',CloseDate=Date.today()+2,
                Est_Improvement_Cost__c = 50.00, Loan_Term__c = 24);
        Opportunity o2 = new Opportunity(name='Opportunity 2', StageName='Pre-Qualified Lead', Project_Type__c='TBD',CloseDate=Date.today()+2,
                Est_Improvement_Cost__c = 50.00, Loan_Term__c = 24);
        opportunities.add(o1);
        opportunities.add(o2);
        insert opportunities;

        Test.startTest();

        tenants.add(new Tenant__c(Opportunity__c=o1.Id, Name='Shop1', Tenant_Square_Foot__c=100));
        tenants.add(new Tenant__c(Opportunity__c=o1.Id, Name='Shop2', Tenant_Square_Foot__c=200));
        tenants.add(new Tenant__c(Opportunity__c=o2.Id, Name='Shop3', Tenant_Square_Foot__c=300));
        tenants.add(new Tenant__c(Opportunity__c=o2.Id, Name='Shop4', Tenant_Square_Foot__c=400));

        insert tenants;

        Test.stopTest();
        
        List<Tenant__c> tenantsRefreshed = 
      		[select id,Name,TenantBySqFtSortOder__c,Tenant_Square_Foot__c from Tenant__c where id IN :tenants];
 
        for (Tenant__c t : tenantsRefreshed) {
            if(t.Name.equals('Shop1'))
                System.assertEquals(2,t.TenantBySqFtSortOder__c);
            if(t.Name.equals('Shop2'))
                System.assertEquals(1,t.TenantBySqFtSortOder__c);
            if(t.Name.equals('Shop3'))
                System.assertEquals(2,t.TenantBySqFtSortOder__c);
            if(t.Name.equals('Shop4'))
                System.assertEquals(1,t.TenantBySqFtSortOder__c);
        }
       }

    private static testMethod void testDeleteRecords() {

        List<Opportunity> opportunities = new List<Opportunity>();
        List<Tenant__c> tenants = new List<Tenant__c>();

        // insert an opportunities

        Opportunity o1 = new Opportunity(name='Opportunity 1',StageName='Pre-Qualified Lead', Project_Type__c='TBD',CloseDate=Date.today()+2,
                Est_Improvement_Cost__c = 50.00, Loan_Term__c = 24);
        opportunities.add(o1);
        insert opportunities;

        tenants.add(new Tenant__c(Opportunity__c=o1.Id, Name='ShopDelete1', Tenant_Square_Foot__c=100));
        tenants.add(new Tenant__c(Opportunity__c=o1.Id, Name='ShopDelete2', Tenant_Square_Foot__c=200));
        
        insert tenants;
        
        Test.startTest();
        // now delete a record and reset recurrsion flag
        TriggerContextUtility.setFirstRunTrue();
        delete tenants.get(1);
        Test.stopTest();
        
        List<Tenant__c> tenantsRefreshed = 
      		[select id,Name,TenantBySqFtSortOder__c,Tenant_Square_Foot__c from Tenant__c where Opportunity__c=:o1.id];
 
        for (Tenant__c t : tenantsRefreshed) {
            if(t.Name.equals('ShopDelete1'))
                System.assertEquals(1,t.TenantBySqFtSortOder__c);
        }
    }

}