/**
* @author Rodion Vakulovskyi
* @author Rodion Vakulovskyi
* @version 1.00
* @description Utility class for unit tests methods
* 
*/
public class TestHelperUtility  {
	public static Account createAccount(String entity, String subType, String accName, String clientSatus, String type) {
		 Account accForTest = new Account(
            Entity_Type__c = entity,
            Entity_Sub_Type__c = subType,
            Name = accName,
            Client_Status__c = clientSatus,
            Type = type
        );
		return accForTest;
	}

	public static Opportunity createOpportunity(String accId, String oppName, String solarStruct, String stageName, String stateProp, String secOppOwner, String losToLoi, String origMonth, String aAM, String projectType, Date closeDate, Decimal cost, Integer lCost) {
        createCustomSetting();
        Test.setMock(HttpCalloutMock.class, new EgnyteHttpCalloutImpl());
        Opportunity oppForTest = new Opportunity(
        	AccountId = accId,
        	App_Executed_Date__c = null,
        	CloseDate= closeDate,
        	CF_Due_Diligence_Deposit__c = null,
            Name = oppName,
            Solar_TPO_Structure__c = solarStruct,
            StageName = stageName,
            State_Prop__c = stateProp,
            secondary_opp_owner__c = secOppOwner,
         	Date_Dead_Lost__c = System.Today(),
			PACE_payment_amount_est__c = 100,
			LOI_Executed_Date__c = System.Today(),
			LOI_Sent_Date__c = System.Today(),
			LOI_Start_Date__c = System.Today(),
			LOS_to_LOI__c = losToLoi,
			Originally_Month_of_LOI_Exec__c = origMonth,
			Actual_Anticipated_Mo_of_LOI_Exec__c = aAM,
			Project_Type__c = projectType,
            Est_Improvement_Cost__c = cost,
            Loan_Term__c = lCost
        );
		return oppForTest;
	}
    
    public static Opportunity createOpportunityForBonds(String accId, String contactId, String bondId, String oppName, Decimal intrRest) {
        createCustomSetting();
        Test.setMock(HttpCalloutMock.class, new EgnyteHttpCalloutImpl());
		Opportunity oppForTest = new Opportunity(
        										Accountid = accId,
        										Name = oppName,
        										CloseDate =  Date.today()+2,
        										StageName = 'Pre-Qualified Lead',
        										LeadSource ='Channel Parnter',
        										Channel_Partner_Main_Contact__c = contactId,
        										LOI_Executed_Date__c = system.today(),
            									LOI_Sent_Date__c = system.today(),
        										Project_Type__c = 'TBD',
        										Type_of_Improvements__c ='EE',
        										Construction_Work_Status__c = 'N/A',
        										Project_Objective__c = 'Property Upgrades',
        										Mortgage_Lender__c = accId,
        										Type_of_Lender__c ='Permanent',
        										Type_of_Loan_First__c='Permanent',
        										Financing_Amount__c = 100.00,
        										Est_Improvement_Cost__c = 50.00,
        										Total_Financing_Fee__c=2.5,
        										Channel_Partner__c=2.5,
        										Project_Overview__c ='Overview',
        										Loan_Term__c = 24,
        										Interest_Rate__c = intrRest,
        										Transaction_Manager__c = userinfo.getUserId(),
        										Channel_Partner_Entity__c = accId,
        										Legal_Name_of_Property_Owner__c = 'John Cena',
        										Physical_Address__c = 'ABC lane',
        										County__c = 'Marion',
        										Municipality__c = 'MCF',
        										State_Prop__c = 'MN',
        										Zip_Code__c = '12108',
        										Building_Size__c = 95.0,
        										Building_Size_Type__c = 'Sq Ft',
        										Primary_Property_Type__c  = 'Office',
        										Sub_Vertical_Property_Type__c  = 'Big Box',
        										Solar_Component__c = 'Yes',
        										Project_Qualified_Date__c = system.today(),
        										Initial_App_Date__c =  system.today(),
        										Final_Program_Approval_Date__c = system.today(),
        										CF_Commitment_Date__c = system.today(),
        										Solar_TPO_Structure__c = 'PPA',
        										Solar_PV_System_Size_kW__c = 40,
        										Year_1_Electricity_kWh_Production_Est__c = 4500,
        										PPA_Services_Term_Yrs__c = 4500,
        										Optional_Partial_Bond_Prepayment__c = 'Yes',
        										Solar_System_Ownershipo__c = 'TBD',
        										Bond__c = bondId
                							);
		return oppForTest;
	}

	public static DRL_Template_Item__c createDRLTemp(String itemString, String drName, String drTempNumb, String drlNumber, String notes, String rParty, String stage) {
		DRL_Template_Item__c tempTest = new DRL_Template_Item__c(Item__c = itemString, 
        															Document_Name__c = drName, 
        															DRL_Template_Number_Map__c = drTempNumb + drlNumber,
        															Notes_and_Comments__c = notes,
        															Responsible_Party__c= rParty,
        															Stage__c = stage
																);
		return tempTest;
	}

	public static User createUser(String alias, String emailTest, String firstName, String lastName, String commName, String profileId, String userName) {
		User userTest = new User(
								Alias = alias,
								Email = emailTest, 
								EmailEncodingKey = 'UTF-8',
								FirstName = firstName,
								LastName = lastName,
								CommunityNickname = commName,
								IsActive = true,
								LanguageLocaleKey = 'en_US', 
								LocaleSidKey = 'en_US',
								ProfileId = profileId,
								TimeZoneSidKey = 'America/Los_Angeles',
								UserName = userName+UserInfo.getOrganizationId()+emailTest
								);
       	return userTest;
	}

	public static Payments__c createPayment(String parcelId, Integer payment, Integer interest, String pType) {
		Payments__c testPayment = new Payments__c(
												Parcel__c = parcelId,
												Payment__c = payment,
												Interest__c = interest,
            									Payment_Type__c = pType
												);
		return testPayment;
	}

	public static Parcel__c createParcel(String oppId, String parcelName) {
		Parcel__c testParcel = new Parcel__c(
											Name = parcelName,
											Opportunity__c = oppId
											);
		return testParcel;
	}

	public static Bond__c createBond() {
		Bond__c testBond = new Bond__c();
		return testBond;
	}

	public static Contact createContact(String accountId, String firstName, String lastName) {
		Contact testContact = new Contact(
            							AccountId = accountId,
										FirstName = firstName,
										LastName = lastName
										 );
		return testContact;
	}

	public static Tenant__c createTenant(String oppId, String tenantName, Integer tenantSquareFoot) {
		Tenant__c testTenant = new Tenant__c(
											Opportunity__c = oppId,
											Name = tenantName,
											Tenant_Square_Foot__c = tenantSquareFoot
											);
		return testTenant;
	}
    
    public static Lead createLead() {
        createCustomSetting();
        Test.setMock(HttpCalloutMock.class, new EgnyteHttpCalloutImpl());
        Lead leadToCreate = new Lead(
        							CF_Sub_Lead_Source__c = 'Test',
        							Company = 'Test',
        							LastName = 'Test',
        							Legal_Name_of_Property_Owner__c = 'Test TEst',
        							Partner_Company__c = 'TestPartnerCompany',
                                    Property_Owner_Last__c = 'Test',
        							Partner_Last_Name__c = 'TestPartnerLastName',
        							MORTGAGE_LENDER_2ND__C = 'TestMRL2',
        							MORTGAGE_LENDER_1ST__C = 'TestMRL1',
        							MORE_THAN_2_LENDERS__C = true,
        							Number_of_Parcels__c = 2,
        							NUM_OF_TENANTS__C = 2,
                                    Project_Name__c = 'Test',
        							STAGE_TO_CONVERT_OPP_TO__C = 'TEst',
        							Application_Submission_Date__c = System.today()		
        							);
        return leadToCreate;
    }
    
    public static Lien__c createLien(String oppId, String morLenderId, Date acknowDate) {
        Lien__c lienToCreate = new Lien__c(Opportunity__c=oppId, 
                                           Mortgage_Lender__c=morLenderId, 
                                           Lender_Acknowledgement__c =acknowDate);
        return lienToCreate;
    }

    public static Attachment createAttachment(String nameAndValue, String parentId) {
        Attachment attToInsert = new Attachment(
                                                ParentId = parentId, 
                                                Name = nameAndValue, 
                                                Body = Blob.valueOf(nameAndValue));
        return attToInsert;
    }

    private static void createCustomSetting() {
        Egnyte__c egnCs = Egnyte__c.getOrgDefaults();
        egnCs.Value__c = '1111111111111111111111';
        upsert egnCs Egnyte__c.Id;
        EgnyteGeneral__c egnCsGent = EgnyteGeneral__c.getOrgDefaults();
        egnCsGent.Value__c = '1111111111111111111111';
        upsert egnCsGent EgnyteGeneral__c.Id;
    }
}