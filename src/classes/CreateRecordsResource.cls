@RestResource(urlMapping='/createRecords/*')
global class CreateRecordsResource {
    
@HttpPost
    global  static CreateRecordsResponse createRecord() {
        CreateRecordsResponse resultMessage;
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        System.debug(req.requestBody.toString());
        CreateRecordsWrapper wrapperClass = CreateObjectHandler.stringifyRecord((CreateRecordsWrapper) JSON.deserialize(req.requestBody.toString(), CreateRecordsWrapper.class));
        try{
            if(wrapperClass.objName == 'Account' ) {
                Account accDupe = CreateObjectHandler.checkAccDupes(wrapperClass.AccName, Boolean.valueOf(wrapperClass.isPartnerAcc));
                if(accDupe != null) {
                    accDupe = CreateObjectHandler.createOrUpdateAccount(wrapperClass.AccName, wrapperClass.LeadSource, wrapperClass.City, wrapperClass.State, wrapperClass.StreetAddress, wrapperClass.ZipCode, wrapperClass.EntityType, accDupe.Id);
					resultMessage = new CreateRecordsResponse('The record already exists.It was updated.', '200', accDupe.Id);
                } else {
                    Account insertedAcc = CreateObjectHandler.createOrUpdateAccount(wrapperClass.AccName, wrapperClass.LeadSource, wrapperClass.City, wrapperClass.State, wrapperClass.StreetAddress, wrapperClass.ZipCode, wrapperClass.EntityType, '');
                    resultMessage = new CreateRecordsResponse('The record was successfully inserted.', '200', insertedAcc.Id);
                }
            }
            if(wrapperClass.objName == 'Contact' ) {
                String accId = '';
                if(!String.isEmpty(wrapperClass.AccName)) {
                	List<Account> accountToRetrieve = new List<Account>([SELECT Id FROM ACCOUNT WHERE Name = :wrapperClass.AccName]);
                	if(accountToRetrieve.size() > 0) {
                    	accId =  accountToRetrieve[0].Id;
                	}
                }
				Contact contactDupe = CreateObjectHandler.searchContactDupes(wrapperClass.Email, wrapperClass.FirstName, wrapperClass.LastName);
                if(contactDupe != null) {
                    contactDupe = CreateObjectHandler.createOrUpdateContact(wrapperClass.Email, wrapperClass.FirstName, wrapperClass.LastName, wrapperClass.Phone, accId, contactDupe.Id);
					resultMessage = new CreateRecordsResponse('The record already exists.It was updated.', '200', contactDupe.Id);
                } else {
                    Contact insertedContact = CreateObjectHandler.createOrUpdateContact(wrapperClass.Email, wrapperClass.FirstName, wrapperClass.LastName, wrapperClass.Phone, accId, '');
                    resultMessage = new CreateRecordsResponse('The record was successfully inserted.', '200', insertedContact.Id);
                }
            }
        	
        } catch (Exception ex) {
           resultMessage = new CreateRecordsResponse(ex.getMessage(), '400','');
        }
        return resultMessage;
    }
}