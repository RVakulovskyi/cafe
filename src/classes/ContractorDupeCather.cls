public class ContractorDupeCather  {
    private static final String RTYPE = 'Contractor';
    public static void onBeforeInsert(List<Account> inputList) {
        processDupes(inputList);
    }

    private static void processDupes(List<Account> inputList) {
        Set<String> setOfContractors = new Set<String>();
        RecordType rTypeContractor = [SELECT Id, DeveloperName FROM RecordType WHERE DeveloperName = :RTYPE];
        for(Account itemAccount : [SELECT Id, Name FROM Account WHERE RecordTypeId = :rTypeContractor.Id]) {
            setOfContractors.add(itemAccount.Name);
        }
        for(Account itemNewAccount : inputList) {
            if(setOfContractors.contains(itemNewAccount.Name)) {
                itemNewAccount.addError('Contractor with the same name already exist.');
            }
        }
    }
}