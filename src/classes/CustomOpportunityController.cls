public without sharing class CustomOpportunityController
{

 public String  opportunityName {get; set;}
 public String  ppProjectNumber {get; set;}
 public String  accountName {get; set;}
 public String  companyName {get; set;}
 public String  mainContact {get; set;}
 public String  pp_project_number {get; set;}
 
 public CustomOpportunityController () {}
 
 public PageReference createOpportunity() 
 {
    Opportunity opportunity = new Opportunity();
        
    try {
        system.debug('Oppurtunity Name : ' + opportunityName);
        system.debug('Pace Project Number : ' + ppProjectNumber);
        system.debug('Account Name : ' + accountName);

        Id UserId = UserInfo.getUserId();
        Id companyId;
        Id contactId;
        Id opportunityId;
        String BaseURL;
        String refUrl;

        String Email;
        String Phone;
        String Street_Address;
        String City;
        String State;
        String ZipCode;

        system.debug('Current logged in User ID : ' + UserId);

        if (UserId != null) {

            List<User> userlst = [
                    SELECT Name, Account.Id, Account.Name, Contact.Id,
                            Contact.Email, Contact.Phone,
                            Account.Street_Address__c, Account.City__c,
                            Account.State__c, Account.zip_code__c
                    FROM User
                    WHERE Id = :UserId
                    LIMIT 1
            ];

            User user;

            if (userlst.size() > 0) {
                user = userlst[0];
                companyName = user.Account.Name;
                companyId = user.Account.Id;
                contactId = user.Contact.Id;

                mainContact = user.Name;
                Email = user.Contact.Email;
                Phone = user.Contact.Phone;
                Street_Address = user.Account.Street_Address__c;
                City = user.Account.City__c;
                State = user.Account.State__c;
                ZipCode = user.Account.zip_code__c;

                system.debug('Users - company name : ' + companyName);
                system.debug('Users - main contact : ' + mainContact);
                system.debug('Users - companyId    : ' + companyId);
                system.debug('Users - contactId    : ' + contactId);

            } else {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'User Company Name not found'));
            }
        }

        Account account;
        List<Account> accountlst = [
                SELECT Id, Name
                FROM Account
                WHERE Name = :accountName
                LIMIT 1
        ];

        if (accountlst.size() > 0) {
            account = accountlst[0];
            system.debug('Successfully account retrieved ' + account.Name + ' with Id:' + account.Id);
        } else {
            account = new Account();
            account.Name = accountName;
            account.Client_Status__c = 'Pre-Contact';
            account.Sub_Lead_Source__c ='test';
            account.CF_Lead_Source__c ='Other';
            account.Account_Type__c = 'N/A';
            insert account;
            system.debug('Successfully account created ' + account.Name + ' with Id:' + account.Id);

            accountlst = [
                    SELECT Id
                    FROM Account
                    WHERE Name = :accountName
                    LIMIT 1
            ];

            if (accountlst.size() > 0) {
                account = accountlst[0];
            }
        }
        opportunity.accountId = account.id;
        opportunity.Name = opportunityName;
        opportunity.StageName = 'Pre-Qualified Lead';
        opportunity.Loan_Term__c = 20;
        opportunity.PACEPartner_Project_Number__c = ppProjectNumber;
        opportunity.Initial_Entry_Date__c = system.today();
        opportunity.CloseDate = system.today().addDays(90);
        opportunity.LeadSource = 'Channel Partner';
        opportunity.Channel_Partner_Entity__c = companyId;
        opportunity.Channel_Partner_Main_Contact__c = contactId;
        opportunity.Validated_by_CF__c = false;
        opportunity.Sub_Lead_Source__c = companyName;
        opportunity.PACEPartner_Mailing_City__c = City;
        opportunity.PACEPartner_Email__c = Email;
        opportunity.PACEPartner_Name__c = contactId;
        opportunity.PACEPartner_Phone__c = Phone;
        opportunity.PACEPartner_Mailing_State__c = State;
        opportunity.PACEPartner_Mailing_Street_Address__c = Street_Address;
        opportunity.PACEPartner_Mailing_Zip_Code__c = ZipCode;
      /* Renee Pifer is default transaction manager */
        opportunity.Transaction_Manager__c = '005j000000CAYj4AAH';
        /* Set the identifier to the PARTNER */
        opportunity.PACEPartner_Identifier__c = opportunity.Channel_Partner_Entity__c;

        list<OpportunityShare> lstOpportunityShare = [Select UserOrGroupId, OpportunityId, OpportunityAccessLevel,Id, RowCause From OpportunityShare];

        system.debug('------------ list all the current shares1 -----------' + lstOpportunityShare[0]);


        /* Set up the default Opportunity Owner */

      /* Solar City - Brandon is Owner*/
        if (opportunity.Channel_Partner_Entity__c == '001j000000YSGyd') {
           opportunity.OwnerID = '005j000000CAPu5';
        } /* Solar Engine - Brandon is Owner */
        else if (opportunity.Channel_Partner_Entity__c == '001j000000khX8m') {
            opportunity.OwnerID = '005j000000CAPu5';
        } /* View Glass - Chris Robbins is owner*/
        else if (opportunity.Channel_Partner_Entity__c == '001j000000Sd0sR') {
            opportunity.OwnerID = '005j000000BcK6J';
        } /* Minerva - Chris Robbins is owner*/
        else if (opportunity.Channel_Partner_Entity__c == '001j000000khGar') {
            opportunity.OwnerID = '005j000000BcK6J';
        }/* Pace Houston - Joshua is the owner */
        else if (opportunity.Channel_Partner_Entity__c == '001j000000WDrWj') {
            opportunity.OwnerID = '005j000000BcK6x';
        } /* NRG Answers - Chris is the owner */
        else if (opportunity.Channel_Partner_Entity__c == '001j000000VZFSa') {
            opportunity.OwnerID = '005j000000BcK6J';
        } /* Stok - Chris is the owner */
        else if (opportunity.Channel_Partner_Entity__c == '001j000000j9ZVB') {
            opportunity.OwnerID = '005j000000BcK6J';
        }/* CBJ - Chris is the owner */
        else if (opportunity.Channel_Partner_Entity__c == '001j000000Wuxl0') {
            opportunity.OwnerID = '005j000000BcK6J';
        }/* Integral - Chris is the owner */
        else if (opportunity.Channel_Partner_Entity__c == '001j000000Sd0ol') {
            opportunity.OwnerID = '005j000000BcK6J';
        }/* Comfort Systems - Chris is the owner */
        else if (opportunity.Channel_Partner_Entity__c == '001j000000Vayxp') {
            opportunity.OwnerID = '005j000000BcK6J';
        } /* PACE Sage - Joshua is the Opportunity Owner */
        else if (opportunity.Channel_Partner_Entity__c == '001j000000WZrTL') {
            opportunity.OwnerID = '005j000000BcK6x';
        } /* Platinum Solar - Brandon is the owner */
        else if (opportunity.Channel_Partner_Entity__c == '001j000000re5Eq') {
            opportunity.OwnerID = '005j000000CAPu5';
        } /* Frank Owens - Chris is the owner */
        else if (opportunity.Channel_Partner_Entity__c == '001j000000l9tk9') {
            opportunity.OwnerID = '005j000000BcK6J';
        } /* Resolve Finance - Joshua is the owner */
        else if (opportunity.Channel_Partner_Entity__c == '001j000000kfQMd') {
            opportunity.OwnerID = '005j000000BcK6x';
        } /* Onital Energy - Joshua is owner */
        else if (opportunity.Channel_Partner_Entity__c == '001j000000ul7bA') {
            opportunity.OwnerID = '005j000000BcK6x';
        } /* Donovan Energe - Joe is owner */
        else if (opportunity.Channel_Partner_Entity__c == '0010a00001A9HQA') {
            opportunity.OwnerID = '005j000000BcK6d';
        }
        /* Chris Robbins is default owner,  PACEPartner Tier 2 Partner Manager is default share */
        else {
           opportunity.OwnerID = '005j000000BcK6J';
        }

        system.debug('Just before opportunity insertion ');
        insert opportunity;
        opportunityId = opportunity.Id;
        system.debug('Just after opportunity insertion ');
        BaseURL = ApexPages.currentPage().getHeaders().get('Host');
        system.debug('Just after getting BaseURL ' + BaseURL);
        system.debug('Just after getting Opportunity ID : ' + opportunityId);
        refUrl = '/' + opportunityId ;
        system.debug('Just after getting refUrl : ' + refUrl);

        system.debug('------------ opportunity  -----------' + opportunity);
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO, 'Opportunity created successfully'));

        PageReference ref = new PageReference(refUrl);
        ref.setRedirect(true);


        system.debug('------------ opportunity owneer  -----------' + opportunity.OwnerID);

        system.debug('------------ opportunity owneer  -----------' +ref);


        return ref;
  } 
  catch (DMLException e) 
  {
      ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error while creating Opportunity'));
      return null;
  } 
  finally 
  {
  }
    
    return null;
 }

}