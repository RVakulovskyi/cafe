@isTest
public class CleanQuoteParserHandlerTest {
    
    private static testmethod void adminSolarTest() {
        String jsonText = '{"PPA__c":"Yes", "Market_Value__c":"", "Primary_Type__c":"Office", "Project_Name__c":"Santa Monica Boulevard, Los Angeles", "Property_Zip__c":"", "Partner_Email__c":"p.bogosta+admin@svitla.com", "Partner_Phone__c":"+1 (298) 739-1273", "Project_Notes__c":"", "Project_Scope__c":"Gut Rehab", "Project_Stage__c":"Planning", "Property_City__c":"Los Angeles", "Financing_Term__c":30, "Property_State__c":"CA", "Contractor_City__c":"", "Contractor_Last__c":"", "Partner_Company__c":"CleanFund", "Property_County__c":"Los Angeles County", "Contractor_Email__c":"", "Contractor_First__c":"", "Contractor_Phone__c":"", "Partner_Last_Name__c":"Test", "System_Size_kW_DC__c":10000, "Partner_First_Name__c":"Admin", "Project_Start_Date__c":"", "Property_Owner_Zip__c":"", "Current_Balance_1st__c":"", "Property_Owner_City__c":"", "Property_Scope_Text__c":"Solar", "Property_Owner_State__c":"", "Property_Owner_Street__c":"", "Year_1_Production_kWh__c":17088708, "Contractor_Company_Name__c":"", "Project_Size_In_Dollars__c":5000000, "Property_Street_Address__c":"Santa Monica Boulevard", "Desired_Project_Finish_Date__c":"", "Property_Geolocation__Latitude__s":34.04925209999999,"Property_Geolocation__Longitude__s":-118.4393665, "Estimated_Utility_Rate_Escalation__c":0.0300, "Property_Owner_Geolocation__Latitude__s":"", "Property_Owner_Geolocation__Longitude__s":"", "Year_1_Bill_Savings_pre_solar_bill_po__c":1367000, "Run_Duplicate_Rules__c":false, "CleanQuote_URL__c":"https://cf-quote-staging.herokuapp.com/quotes/kn4RxvyoLk29ocP3mqfrsDMW", "Next_Step__c":"Came in via CleanQuote", "Improvement_Cost_Est__c":5000000, "Close_Date__c":"", "Indicative_Quote_Sent_Date__c":"", "Prepayment__c":"5% (10), 4% (11), 3% (12), 2% (13), 1% (14)", "Benchmark_Type__c":"U.S. Treasury constant maturity yield", "Lead_Stage__c":"Quoted", "Total_PACE_financing_amount_Est__c":5553600.00, "Indicative_Interest_Rate__c":0.588e1, "Spread_at_Quote_bps__c":323, "Total_Financing_Fee__c":553600, "Benchmark_at_Indicative_Quote__c":0.295e1, "Benchmark_Date_at_Indicative_Quote__c":"","FirstName__c":"Unknown", "LastName__c":"Owner", "Phone__c":"+1 (298) 739-1273", "Email__c":"p.bogosta+admin@svitla.com", "CF_Lead_Source__c":"Web Quote Owner Rep", "CF_Sub_Lead_Source__c":"p.bogosta+admin@svitla.com", "Web_to_Lead_Who_Am_I__c":"Real Estate Advisor", "How_did_I_find_CleanQuote__c":"News Article", "Company__c":"CleanFund"}'; 
        System.debug(String.valueOf(Date.today()));
        Map<String, Object> mapOfObjects = ( Map<String, Object>)JSON.deserializeUntyped (jsonText);
        Map<String, Schema.SObjectField> mapOfLeadFields = Schema.SObjectType.Lead.fields.getMap();
        Test.setMock(HttpCalloutMock.class, new EgnyteHttpCalloutImpl());
        CleanQuote__c cleanQuoteObject = (CleanQuote__c)formObjectRecord(mapOfObjects);
        insert cleanQuoteObject;
        List<Lead> listOfLeads = new List<Lead>([SELECT Id FROM Lead]);
        System.assert(listOfLeads.size() > 0, 'Lead records should be created');
        Lead leadCreated = (Lead)ApexHelperUtility.queryAllFieldsObject('Lead', listOfLeads[0].Id);         
        Set<String> setOfMappedFields = new Set<String>{'AccountTypeNew__c', 'Application_Submission_Date__c', 'Contractor_or_EPC__c', 'Project_Finish_Date__c', 'FirstName', 'LastName', 'Is_there_a_groundlease_in_place_c__c', 'Indicative_Interest_Rate_at_Quote__c', 'Stage__c', 'Project_Scope__c', 'Channel_Partner_Main_Contact__c', 'Improvement_Cost_Est__c', 'Total_PACE_financing_amount_Est__c', 'Company', 'OwnerId', 'Property_Owner_Main_Contact__c', 'Total_PACE_financing_amount_Est__c','Total_Financing_Fee__c', 'Benchmark_at_Indicative_Quote__c'};
        for(String itemLeadField : mapOfObjects.keySet()) {
            if(mapOfLeadFields.containsKey(itemLeadField) && String.valueOf(leadCreated.get(itemLeadField)) != null && !setOfMappedFields.contains(itemLeadField)){
            	System.assert(String.valueOf(mapOfObjects.get(itemLeadField)).contains(String.valueOf(leadCreated.get(itemLeadField)).replace('.00','')), 'Parse should be successfull and its not.Field name :' + itemLeadField);
            }
        }
    }
    
    private static testmethod void ownerNotSolarTest() {
        String jsonText = '{"Market_Value__c":1550000, "Primary_Type__c":"Office", "Project_Name__c":"d808 El Camino Real, Burlingame", "Property_Zip__c":"94010", "Partner_Email__c":"", "Partner_Phone__c":"", "Project_Scope__c":"Upgrade/Retrofit", "Project_Stage__c":"Planning", "Property_City__c":"Burlingame", "Financing_Term__c":30, "Property_State__c":"CA", "Contractor_City__c":"", "Contractor_Last__c":"", "Partner_Company__c":"", "Property_County__c":"San Mateo County", "Contractor_Email__c":"", "Contractor_First__c":"", "Contractor_Phone__c":"", "Partner_Last_Name__c":"", "Partner_First_Name__c":"", "Project_Start_Date__c":"", "Property_Owner_Zip__c":"", "Current_Balance_1st__c":25, "Property_Owner_City__c":"", "Property_Owner_Last__c":"test 120", "Property_Scope_Text__c":"Energy Efficiency, Other", "Property_Owner_Email__c":"tstcfq+owner.test120@gmail.com", "Property_Owner_First__c":"owner ", "Property_Owner_Phone__c":"08764645352343", "Property_Owner_State__c":"", "Property_Owner_Street__c":"", "Contractor_Company_Name__c":"", "Project_Size_In_Dollars__c":240000, "Property_Street_Address__c":"d808 El Camino Real", "Desired_Project_Finish_Date__c":"", "Property_Geolocation__Latitude__s":37.58087, "Property_Geolocation__Longitude__s":-122.35998660000001, "Estimated_Utility_Rate_Escalation__c":0.0000, "Property_Owner_Geolocation__Latitude__s":"", "Property_Owner_Geolocation__Longitude__s":"", "Run_Duplicate_Rules__c":false, "CleanQuote_URL__c":"https://cf-quote-staging.herokuapp.com/quotes/ypK77TMkkP3nqZZXwYWVnzUw", "Next_Step__c":"Came in via CleanQuote", "Improvement_Cost_Est__c":240000, "Close_Date__c":"", "Indicative_Quote_Sent_Date__c":"", "Prepayment__c":"5% (10), 4% (11), 3% (12), 2% (13), 1% (14)", "Benchmark_Type__c":"U.S. Treasury constant maturity yield", "Lead_Stage__c":"Quoted", "Lead_Owner_Notes__c":"No matches can be found", "Total_PACE_financing_amount_Est__c":279784, "Indicative_Interest_Rate__c":0.629e1, "Spread_at_Quote_bps__c":364, "Total_Financing_Fee__c":39784, "Benchmark_at_Indicative_Quote__c":0.295e1, "Benchmark_Date_at_Indicative_Quote__c":"", "FirstName__c":"owner ", "LastName__c":"test 120", "Phone__c":"08764645352343", "Email__c":"tstcfq+owner.test120@gmail.com", "CF_Lead_Source__c":"Web Quote Owner", "CF_Sub_Lead_Source__c":"tstcfq+owner.test120@gmail.com", "Web_to_Lead_Who_Am_I__c":"", "Company__c":"tstcfq+owner.test120@gmail.com"}';
    	Map<String, Object> mapOfObjects = ( Map<String, Object>)JSON.deserializeUntyped (jsonText);
        Map<String, Schema.SObjectField> mapOfLeadFields = Schema.SObjectType.Lead.fields.getMap();
        Test.setMock(HttpCalloutMock.class, new EgnyteHttpCalloutImpl());
        CleanQuote__c cleanQuoteObject = (CleanQuote__c)formObjectRecord(mapOfObjects);
        insert cleanQuoteObject;
        List<Lead> listOfLeads = new List<Lead>([SELECT Id FROM Lead]);
        System.assert(listOfLeads.size() > 0, 'Lead records should be created');
        Lead leadCreated = (Lead)ApexHelperUtility.queryAllFieldsObject('Lead', listOfLeads[0].Id);         
        Set<String> setOfMappedFields = new Set<String>{'AccountTypeNew__c', 'Application_Submission_Date__c', 'Contractor_or_EPC__c', 'Project_Finish_Date__c', 'FirstName', 'LastName', 'Is_there_a_groundlease_in_place_c__c', 'Indicative_Interest_Rate_at_Quote__c', 'Stage__c', 'Project_Scope__c', 'Channel_Partner_Main_Contact__c', 'Improvement_Cost_Est__c', 'Total_PACE_financing_amount_Est__c', 'Company', 'OwnerId', 'Property_Owner_Main_Contact__c', 'Total_PACE_financing_amount_Est__c','Total_Financing_Fee__c', 'Benchmark_at_Indicative_Quote__c'};
        for(String itemLeadField : mapOfObjects.keySet()) {
            if(mapOfLeadFields.containsKey(itemLeadField) && String.valueOf(leadCreated.get(itemLeadField)) != null && !setOfMappedFields.contains(itemLeadField)){
            	System.assert(String.valueOf(mapOfObjects.get(itemLeadField)).contains(String.valueOf(leadCreated.get(itemLeadField)).replace('.00','')) || String.valueOf(leadCreated.get(itemLeadField)).replace('.00','').contains(String.valueOf(mapOfObjects.get(itemLeadField))), 'Parse should be successfull and its not.Field name :' + itemLeadField);
            }
        }
    }
    
    private static testmethod void partnerNotSolarTest() {
        String jsonText = '{"Market_Value__c":"", "Primary_Type__c":"Hospitality", "Project_Name__c":"Saarinen Circle, Sterling", "Property_Zip__c":"20166", "Partner_Email__c":"tstcfq+partner.test79@gmail.com", "Partner_Phone__c":"+1 (098) 765-467", "Project_Notes__c":"", "Project_Scope__c":"New Construction", "Project_Stage__c":"Construction", "Property_City__c":"Sterling", "Financing_Term__c":30, "Property_State__c":"VA", "Contractor_City__c":"", "Contractor_Last__c":"", "Partner_Company__c":"ddd", "Property_County__c":"Loudoun County", "Contractor_Email__c":"", "Contractor_First__c":"", "Contractor_Phone__c":"", "Partner_Last_Name__c":"test 79", "Partner_First_Name__c":"partner", "Project_Start_Date__c":"", "Property_Owner_Zip__c":"", "Current_Balance_1st__c":0, "Property_Owner_City__c":"", "Property_Scope_Text__c":"Energy Efficiency", "Property_Owner_State__c":"", "Property_Owner_Street__c":"", "Contractor_Company_Name__c":"", "Project_Size_In_Dollars__c":1000000, "Property_Street_Address__c":"Saarinen Circle", "Desired_Project_Finish_Date__c":"", "Property_Geolocation__Latitude__s":38.9533408, "Property_Geolocation__Longitude__s":-77.447877, "Estimated_Utility_Rate_Escalation__c":0.0000, "Property_Owner_Geolocation__Latitude__s":"", "Property_Owner_Geolocation__Longitude__s":"", "Run_Duplicate_Rules__c":false, "CleanQuote_URL__c":"https://cf-quote-staging.herokuapp.com/quotes/BL3A4qYMbwDzxVsmPTH4xsvM", "Next_Step__c":"Came in via CleanQuote", "Improvement_Cost_Est__c":1000000, "Close_Date__c":"", "Indicative_Quote_Sent_Date__c":"", "Prepayment__c":"5% (10), 4% (11), 3% (12), 2% (13), 1% (14)", "Benchmark_Type__c":"U.S. Treasury constant maturity yield", "Lead_Stage__c":"Quoted", "Total_PACE_financing_amount_Est__c":1138367, "Indicative_Interest_Rate__c":0.68e1, "Spread_at_Quote_bps__c":345, "Total_Financing_Fee__c":138367, "Benchmark_at_Indicative_Quote__c":0.295e1, "Benchmark_Date_at_Indicative_Quote__c":"", "FirstName__c":"Unknown", "LastName__c":"Owner", "Phone__c":"+1 (098) 765-467", "Email__c":"tstcfq+partner.test79@gmail.com", "CF_Lead_Source__c":"Web Quote Owner Rep", "CF_Sub_Lead_Source__c":"tstcfq+partner.test79@gmail.com", "Web_to_Lead_Who_Am_I__c":"Contractor", "How_did_I_find_CleanQuote__c":"Other", "Company__c":"ddd"}';
        Map<String, Object> mapOfObjects = ( Map<String, Object>)JSON.deserializeUntyped (jsonText);
        Map<String, Schema.SObjectField> mapOfLeadFields = Schema.SObjectType.Lead.fields.getMap();
        Test.setMock(HttpCalloutMock.class, new EgnyteHttpCalloutImpl());
        CleanQuote__c cleanQuoteObject = (CleanQuote__c)formObjectRecord(mapOfObjects);
        insert cleanQuoteObject;
        List<Lead> listOfLeads = new List<Lead>([SELECT Id FROM Lead]);
        System.assert(listOfLeads.size() > 0, 'Lead records should be created');
        Lead leadCreated = (Lead)ApexHelperUtility.queryAllFieldsObject('Lead', listOfLeads[0].Id);         
        Set<String> setOfMappedFields = new Set<String>{'AccountTypeNew__c', 'Application_Submission_Date__c', 'Contractor_or_EPC__c', 'Project_Finish_Date__c', 'FirstName', 'LastName', 'Is_there_a_groundlease_in_place_c__c', 'Indicative_Interest_Rate_at_Quote__c', 'Stage__c', 'Project_Scope__c', 'Channel_Partner_Main_Contact__c', 'Improvement_Cost_Est__c', 'Total_PACE_financing_amount_Est__c', 'Company', 'OwnerId', 'Property_Owner_Main_Contact__c', 'Total_PACE_financing_amount_Est__c','Total_Financing_Fee__c', 'Benchmark_at_Indicative_Quote__c'};
        for(String itemLeadField : mapOfObjects.keySet()) {
            if(mapOfLeadFields.containsKey(itemLeadField) && String.valueOf(leadCreated.get(itemLeadField)) != null && !setOfMappedFields.contains(itemLeadField)){
                System.debug(String.valueOf(mapOfObjects.get(itemLeadField)));
            	System.debug(String.valueOf(leadCreated.get(itemLeadField)).replace('.00',''));
            	System.assert(String.valueOf(mapOfObjects.get(itemLeadField)).contains(String.valueOf(leadCreated.get(itemLeadField)).replace('.00','')) || String.valueOf(leadCreated.get(itemLeadField)).replace('.00','').contains(String.valueOf(mapOfObjects.get(itemLeadField))), 'Parse should be successfull and its not.Field name :' + itemLeadField);
            }
        }
    }
    
    private static sObject formObjectRecord(Map<String, Object> mapOfMappedFields) {
        sObject objToReturn = Schema.getGlobalDescribe().get('CleanQuote__c').newSObject() ;
        Map<String, Schema.SObjectField> mapOfLeadFields = Schema.SObjectType.CleanQuote__c.fields.getMap();
        for(String itemFieldName : mapOfMappedFields.keySet()) {
            if(mapOfMappedFields.containsKey(itemFieldName) && mapOfLeadFields.get(itemFieldName).getDescribe().isUpdateable() && !String.isEmpty(String.valueOf(mapOfMappedFields.get(itemFieldName)))){
              //  System.debug(mapOfMappedFields.get(itemFieldName) + 'Value FieldName');
            	Object objToAssign = mapOfMappedFields.get(itemFieldName);
            	if(objToAssign instanceof Integer) {
                	objToReturn.put(itemFieldName, Integer.valueOf(objToAssign));
            	}
            	if(objToAssign instanceof String) {
                	objToReturn.put(itemFieldName, String.valueOf(objToAssign));
            	}
                if(objToAssign instanceof DateTime && !(objToAssign instanceof Date)) {
                    objToReturn.put(itemFieldName, (DateTime)objToAssign);
                }
            	if(objToAssign instanceof Date && !(objToAssign instanceof DateTime)) {
                	objToReturn.put(itemFieldName, (Date)objToAssign);
                } 
            	if(objToAssign instanceof Boolean) {
                	objToReturn.put(itemFieldName, Boolean.valueOf(objToAssign));
            	}
                if(objToAssign instanceof Decimal) {
                	objToReturn.put(itemFieldName, Decimal.valueOf(String.valueOf(objToAssign)));
            	}
                if(objToAssign instanceof Double) {
                    objToReturn.put(itemFieldName, Double.valueOf(objToAssign));
                }
                if(itemFieldName == 'Total_PACE_financing_amount_Est__c') {
                    objToReturn.get(itemFieldName);
                }
            }
        }
        return objToReturn;
    }

}