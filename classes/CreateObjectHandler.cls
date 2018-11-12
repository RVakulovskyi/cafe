public class CreateObjectHandler {

    public static Account checkAccDupes(String accName, Boolean bankingAcc) {
        String queryAcc = 'SELECT Id, Name FROM Account WHERE Name = :accName';
        List<Account> accToReturn = new List<Account>();
        if(bankingAcc) {
            queryAcc += ' AND Client_Status__c = \'Pre-Contact\' AND Type = \'Bank\'';
        }
        queryAcc += ' LIMIT 1';
        accToReturn = Database.query(queryAcc);
        if(accToReturn.size() > 0) {
            return accToReturn[0];
        } else {
            return null;
        }
    }
    
    public static Contact searchContactDupes(String email, String firstName, String lastName) {
        List<Contact> contactToCheck = new List<Contact>([SELECT Id, AccountId, Account.Name FROM Contact WHERE Email = :email AND FirstName = :firstName AND LastName = :lastName]);
        if(contactToCheck.size() > 0) {
            return contactToCheck[0];
        } else {
            return null;
        }
    }
    
    public static Contact createOrUpdateContact(String email, String firstName, String lastName, String phone, String inputAccountId, String objId) {
        Contact contactToInsert = new Contact();
            contactToInsert.Can_contact_with_marketing_materials__c = 'Yes';
            contactToInsert.LeadSource = 'CleanQuote';
            contactToInsert.Sub_Lead_Source__c = 'CleanQuote';
        	if(!String.isEmpty(inputAccountId)) {
            	contactToInsert.AccountId = inputAccountId;
        	}
        	contactToInsert.Email = email;
        	contactToInsert.FirstName = firstName;
        	contactToInsert.LastName = lastName;
        	contactToInsert.Phone = phone;
        	if(!String.isEmpty(objId)) {
				contactToInsert.Id = objId;
            	update contactToInsert;
        	} else {
            	insert contactToInsert;
        	}
        return contactToInsert;
    }
    
    public static Account createOrUpdateAccount(String accName, String inputLeadSource, String city, String state, String streetAddress, String zipCode, String EntityType, String objId) {
        Account accToInsert = new Account(Name = accName);
        System.debug(accToInsert);
        accToInsert.Client_Status__c = 'Pre-Contact';
        if(inputLeadSource == 'Web Quote Owner') {
            accToInsert.Type = 'Owner';     
        } else {
            if(inputLeadSource == 'Web Quote Owner Rep') {
                accToInsert.Type = 'Owner Rep'; 
            }
        }
        accToInsert.CF_Lead_Source__c = 'CleanQuote';
        accToInsert.City__c = city;
        accToInsert.State__c = state;
        accToInsert.Street_Address__c = streetAddress;
        accToInsert.Zip_Code__c = zipCode;
        accToInsert.Entity_Type__c = EntityType;
        if(!String.isEmpty(objId)) {
			accToInsert.Id = objId;
            update accToInsert;
        } else {
            insert accToInsert;
        }
        return accToInsert;
    }
    
    public static CreateRecordsWrapper stringifyRecord(CreateRecordsWrapper inputWrapperVar) {
        if(String.isEmpty(inputWrapperVar.AccName)) {
            inputWrapperVar.AccName = '';
        }
        if(String.isEmpty(inputWrapperVar.ISPARTNERACC)) {
            inputWrapperVar.ISPARTNERACC = 'false';
        }
        if(String.isEmpty(inputWrapperVar.LEADSOURCE)) {
            inputWrapperVar.LEADSOURCE = '';
        }
        if(String.isEmpty(inputWrapperVar.EMAIL)) {
            inputWrapperVar.EMAIL = '';
        }
        if(String.isEmpty(inputWrapperVar.FIRSTNAME)) {
            inputWrapperVar.FIRSTNAME = '';
        }
        if(String.isEmpty(inputWrapperVar.LASTNAME)) {
            inputWrapperVar.LASTNAME = '';
        }
        if(String.isEmpty(inputWrapperVar.PHONE)) {
            inputWrapperVar.PHONE = '';
        }
        if(String.isEmpty(inputWrapperVar.CITY)) {
            inputWrapperVar.CITY = '';
        }
        if(String.isEmpty(inputWrapperVar.STATE)) {
            inputWrapperVar.STATE = '';
        }
        if(String.isEmpty(inputWrapperVar.STREETADDRESS)) {
            inputWrapperVar.STREETADDRESS = '';
        }
        if(String.isEmpty(inputWrapperVar.ZIPCODE)) {
            inputWrapperVar.ZIPCODE = '';
        }
        if(String.isEmpty(inputWrapperVar.ENTITYTYPE)) {
            inputWrapperVar.ENTITYTYPE = '';
        }
        return inputWrapperVar;
    }
}