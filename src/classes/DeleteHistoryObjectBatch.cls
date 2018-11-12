global class DeleteHistoryObjectBatch implements Database.Batchable<sObject>{
	global Database.QueryLocator start(Database.BatchableContext BC) {
        String query = 'SELECT Id FROM IntegrationHistory__c WHERE CreatedDate < THIS_MONTH';
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<Account> scope) {
        delete scope;
    }  
    
    global void finish(Database.BatchableContext BC){
    }
}