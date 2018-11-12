public class updateTenantSortOrderHandler {

    public static void processUpdate (Set<ID> opportunityIds){
        Integer order=1;
        List<Tenant__c> tenantsToUpdate;
        for(Id oppid : opportunityIds){
            List<Tenant__c> tenants = 
      		[select id,Name,TenantBySqFtSortOder__c,Tenant_Square_Foot__c from Tenant__c where Opportunity__c =: oppid order by Tenant_Square_Foot__c DESC LIMIT 10];
    		for (Tenant__c t : tenants) {
            	t.TenantBySqFtSortOder__c =order++;
                }
            update tenants;
            order=1;
        }
    }
}