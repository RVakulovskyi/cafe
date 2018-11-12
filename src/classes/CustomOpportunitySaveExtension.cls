public class CustomOpportunitySaveExtension
{

    private final Opportunity opp;
    public Id OpportunityId {get; set;}
    public String validationMessage {get; set;}

    public CustomOpportunitySaveExtension (ApexPages.StandardController stdController)
    {
        this.opp = (Opportunity)stdController.getRecord();
        this.validationMessage='';
    }

    public PageReference getBack()
    {
        String refUrl;
        refUrl = '/'+ opp.Id ;
        PageReference ref = new PageReference(refUrl);
        ref.setRedirect(true);
        return ref;
    }

    public void CheckAndValidate()
    {
        List<Opportunity> opportunitylst = [
                SELECT Id, Name, PACEPartner_Project_Number__c, Transaction_Manager__c, StageName,
                        Initial_Entry_Date__c, Underwriting_Complete_Date__c, CloseDate,
                        Channel_Partner_Entity__c, PACEPartner_Mailing_Street_Address__c,
                        PACEPartner_Name__c, PACEPartner_Mailing_City__c,
                        PACEPartner_Phone__c, PACEPartner_Mailing_State__c,
                        PACEPartner_Email__c, PACEPartner_Mailing_Zip_Code__c,
                        PACEPartner_Relationship_to_Owner__c, Type_of_Improvements__c,
                        Physical_Address__c, Municipality__c, Property_Acquisition_Date__c,
                        Property_Purchase_Price__c,
                        Zip_Code__c, Property_Market_Value_Est__c, Description_of_Improvements__c,
                        County__c, Property_Market_Value_Based_Upon__c,
                        Primary_Property_Type__c, Total_Annual_Property_Tax_Pmt__c,
                        Property_Use_Description__c, Property_Parcel_Number__c,
                        Occupancy_Rate__c, Net_Operating_Income__c,
                        Number_of_Tenants__c, Owner_Occupied__c, Years_in_Business_Location__c,
                        Is_there_a_groundlease_in_place__c, If_groundlease_expiration_date__c, Name_of_Land_Owner__c,
                        Owner_Mailing_Street_Address__c,
                        AccountID, Owner_Mailing_City__c,
                        Legal_Name_of_Property_Owner__c, Owner_Mailing_State__c,
                        Owner_Tax_ID__c, Owner_Mailing_Zip_Code__c,
                        Property_Owner_Main_Contact__c, Property_Owner_Main_Contact_Phone__c,
                        Property_Owner_Main_Contact_Title__c, Property_Owner_Main_Contact_Email__c,
                        Business_Revenue__c, Current_Assets__c, Cost_of_Goods_Sold__c, Current_Liabilities__c,
                        Business_Net_Operating_Income__c, Total_Assets_of_Owner_Occupant__c,
                        Total_Liabilities__c, Intangible_Assets_of_Owner_Occupant__c,
                        First_Mortgage__c, Mortgage_Lender__c,
                        Type_of_Loan_First__c, Type_of_Financing_First__c,
                        Current_Balance_First_Mortgage__c, First_Mortgage_Lender_Contact_Name__c,
                        Interest_Rate_1st__c, First_Mortgage_Lender_Contact_Email__c,
                        Annual_1st_Mortgage_Payments__c, First_Mortgage_Lender_Contact_Phone__c,
                        Second_Mortgage__c, Second_Mortgage_Lender__c,
                        Type_of_Loan_Second__c, Type_of_Financing_Second__c,
                        Current_Balance_Second_Mortgage__c, Second_Mortgage_Lender_Contact_Name__c,
                        Interest_Rate_2nd__c, Second_Mortgage_Lender_Contact_Email__c,
                        Annual_2nd_Mortgage_Payments__c, Second_Mortgage_Lender_Contact_Phone__c,
                        Type_of_Improvements_Multi__c, Desired_Project_Start_Date__c, Loan_Term__c,
                        Est_Improvement_Cost__c, PACE_payment_amount_est__c,
                        Capitalized_Interest_NotPrepaid__c, Total_Financing_Amount__c,
                        Solar_PV_System_Size_kW__c, Estimated_Utility_Rate_Escalation_yr__c,
                        Year_1_Electricity_kWh_Production_Est__c, Avoided_Cost_of_Electricity_ACOE__c,
                        Incentive_Measures_Already_Applied__c, Name_of_Incentive_Program__c,
                        Incentive_Measures_Plan_to_Apply__c, Amount_of_Incentive_est__c,
                        Sensitive_Industries__c, Hazardous_Substances__c, Contamination__c,
                        Regulatory_Government_Actions__c, Pending_Proceedings_or_Lawsuits__c,
                        Risk_Studies_or_Assessments__c, Environmental_Studies_Performed__c,
                        Environmental_Study_Report_Date__c, Environmental_Status_Explanation__c,
                        Mortgage_Delinquencies_or_Default__c, Tax_Defaults_or_Delinquencies__c,
                        Involuntary_Liens__c, Bankruptcy_Proceedings_or_Litigation__c, Property_Status_Explanation__c,
                        Owner_Bankruptcy__c, Owner_as_Defendent__c, Forclosure_Short_Sale_or_Deed_in_Lieu__c,
                        Financial_Crime__c, Owner_Status_Explanation__c
                FROM Opportunity WHERE Id = :opp.Id
                LIMIT 1
        ];

        Opportunity opportunity;

        String validationMessage = '';
        Boolean isMissed = false;

        if ( opportunitylst.size() > 0 )
        {
            opportunity = opportunitylst[0];

            system.debug('Oppurtunity Name : ' + opportunity.Name);

            // Project Status - Section Starts

            if(opportunity.Name == null)
            {
                validationMessage += 'Project Name - Opportunity Name';
                isMissed = true;
            }
//            if(opportunity.PACEPartner_Project_Number__c == null)
//            {
//                validationMessage += '<br/>Project Name - PACEPartner Project Number';
//                isMissed = true;
//            }
            if(opportunity.Transaction_Manager__c == null)
            {
                validationMessage += '<br/>Project Name - Transaction Manager';
                isMissed = true;
            }

            // Project Status - Section Starts

            if(opportunity.StageName == null)
            {
                validationMessage += '<br/>Project Status - Stage not filled';
                isMissed = true;
            }
            if(opportunity.Initial_Entry_Date__c == null)
            {
                validationMessage += '<br/>Project Status - Initial Pipeline Entry Date';
                isMissed = true;
            }
            if(opportunity.CloseDate == null)
            {
                validationMessage += '<br/>Project Status - Close Date';
                isMissed = true;
            }

            // PACEPartner Contact Information

            if(opportunity.Channel_Partner_Entity__c == null)
            {
                validationMessage += '<br/>PACEPartner Contact Information - Company Name';
                isMissed = true;
            }
            if(opportunity.PACEPartner_Mailing_Street_Address__c == null)
            {
                validationMessage += '<br/>PACEPartner Contact Information - Street Address';
                isMissed = true;
            }
            if(opportunity.PACEPartner_Name__c == null)
            {
                validationMessage += '<br/>PACEPartner Contact Information - Name';
                isMissed = true;
            }
            if(opportunity.PACEPartner_Mailing_City__c == null)
            {
                validationMessage += '<br/>PACEPartner Contact Information - City';
                isMissed = true;
            }
            if(opportunity.PACEPartner_Phone__c == null)
            {
                validationMessage += '<br/>PACEPartner Contact Information - Phone';
                isMissed = true;
            }
            if(opportunity.PACEPartner_Mailing_State__c == null)
            {
                validationMessage += '<br/>PACEPartner Contact Information - State';
                isMissed = true;
            }
            if(opportunity.PACEPartner_Email__c == null)
            {
                validationMessage += '<br/>PACEPartner Contact Information - Email';
                isMissed = true;
            }
            if(opportunity.PACEPartner_Mailing_Zip_Code__c == null)
            {
                validationMessage += '<br/>PACEPartner Contact Information - Zip Code';
                isMissed = true;
            }
            if(opportunity.PACEPartner_Relationship_to_Owner__c == null)
            {
                validationMessage += '<br/>PACEPartner Contact Information - Relationship to Owner';
                isMissed = true;
            }

            // Property Information - Section Starts

            if(opportunity.Physical_Address__c == null)
            {
                validationMessage += '<br/>Property Information - Street Address';
                isMissed = true;
            }
            if(opportunity.Property_Acquisition_Date__c == null)
            {
                validationMessage += '<br/>Property Information - Property Acquisition Date';
                isMissed = true;
            }
            if(opportunity.Municipality__c== null)
            {
                validationMessage += '<br/>Property Information - City';
                isMissed = true;
            }
            if(opportunity.Property_Purchase_Price__c == null)
            {
                validationMessage += '<br/>Property Information - Property Purchase Price';
                isMissed = true;
            }

            if(opportunity.Zip_Code__c == null)
            {
                validationMessage += '<br/>Property Information - Zip Code';
                isMissed = true;
            }
            if(opportunity.Property_Market_Value_Est__c == null)
            {
                validationMessage += '<br/>Property Information - Property Market Value (Est.)';
                isMissed = true;
            }
            if(opportunity.County__c == null)
            {
                validationMessage += '<br/>Property Information - County';
                isMissed = true;
            }
            if(opportunity.Property_Market_Value_Based_Upon__c == null)
            {
                validationMessage += '<br/>Property Information - Property Market Value Based Upon';
                isMissed = true;
            }
            if(opportunity.Primary_Property_Type__c == null)
            {
                validationMessage += '<br/>Property Information - Primary Property Type';
                isMissed = true;
            }
            if(opportunity.Total_Annual_Property_Tax_Pmt__c == null)
            {
                validationMessage += '<br/>Property Information - Total Annual Proprty Tax Payment';
                isMissed = true;
            }
            if(opportunity.Property_Use_Description__c == null)
            {
                validationMessage += '<br/>Property Information - Property Use Description';
                isMissed = true;
            }
            if(opportunity.Property_Parcel_Number__c == null)
            {
                validationMessage += '<br/>Property Information - Property Parcel Number(s)';
                isMissed = true;
            }
            if(opportunity.Occupancy_Rate__c == null)
            {
                validationMessage += '<br/>Property Information - Occupancy Rate(%)';
                isMissed = true;
            }
            if(opportunity.Net_Operating_Income__c == null)
            {
                validationMessage += '<br/>Property Information - Net Operating Income';
                isMissed = true;
            }

            if(opportunity.Number_of_Tenants__c == null)
            {
                validationMessage += '<br/>Property Information - Number of Tenants';
                isMissed = true;
            }
            if(opportunity.Owner_Occupied__c == null)
            {
                validationMessage += '<br/>Property Information - Owner Occupied';
                isMissed = true;
            }
            if(opportunity.Years_in_Business_Location__c == null)
            {
                validationMessage += '<br/>Property Information - Years in Business Location';
                isMissed = true;
            }

            // Property Information (Ground Lease) - Section Starts

            if(opportunity.Is_there_a_groundlease_in_place__c == null)
            {
                validationMessage += '<br/>Property Information - Is there a groundlease in place?';
                isMissed = true;
            }
            if( opportunity.Is_there_a_groundlease_in_place__c == 'Yes') {
                if (opportunity.If_groundlease_expiration_date__c == null)
                {
                    validationMessage += '<br/>Property Information - If groundlease, expiration date';
                    isMissed = true;
                }
                if(opportunity.Name_of_Land_Owner__c == null)
                {
                    validationMessage += '<br/>Property Information - Name of Land Owner';
                    isMissed = true;
                }
            }


            // Property Owner Information - Section Starts


            if(opportunity.Owner_Mailing_Street_Address__c == null)
            {
                validationMessage += '<br/>Property Owner Information - Mailing Address';
                isMissed = true;
            }
            if(opportunity.AccountId == null)
            {
                validationMessage += '<br/>Property Owner Information - Account Name';
                isMissed = true;
            }
            if(opportunity.Owner_Mailing_City__c == null)
            {
                validationMessage += '<br/>Property Owner Information - City';
                isMissed = true;
            }
            // if(opportunity.Legal_Name_of_Property_Owner__c == null)
            //{
            //    validationMessage += '<br/>Property Owner Information - Legal Name';
            //    isMissed = true;
            //}
            if(opportunity.Owner_Mailing_State__c == null)
            {
                validationMessage += '<br/>Property Owner Information - State';
                isMissed = true;
            }
            if(opportunity.Owner_Tax_ID__c == null)
            {
                validationMessage += '<br/>Property Owner Information - Tax ID';
                isMissed = true;
            }
            if(opportunity.Owner_Mailing_Zip_Code__c == null)
            {
                validationMessage += '<br/>Property Owner Information - ZipCode';
                isMissed = true;
            }

            // Owner Contact - Section starts


            if(opportunity.Property_Owner_Main_Contact__c == null)
            {
                validationMessage += '<br/>Owner Contact - Main Contact';
                isMissed = true;
            }

            if(opportunity.Property_Owner_Main_Contact_Phone__c == null)
            {
                validationMessage += '<br/>Owner Contact - Main Contact Phone';
                isMissed = true;
            }

            if(opportunity.Property_Owner_Main_Contact_Title__c == null)
            {
                validationMessage += '<br/>Owner Contact - Main Contact Title';
                isMissed = true;
            }

            if(opportunity.Property_Owner_Main_Contact_Email__c == null)
            {
                validationMessage += '<br/>Owner Contact - Main Contact Email';
                isMissed = true;
            }



            // Property Owner Financials (only req. if Owner Occupied) - Section starts
            //
            system.debug('This is the value of owner occupied in extention class' + opportunity.Owner_Occupied__c);
            if(opportunity.Owner_Occupied__c == 'Yes') {

                system.debug('This is the value of business revenue in extention class' + opportunity.Business_Revenue__c);


                if(opportunity.Business_Revenue__c == null)
                {
                    validationMessage += '<br/>Property Owner Financials - Business Revenue';
                    isMissed = true;
                }

                if(opportunity.Current_Assets__c == null)
                {
                    validationMessage += '<br/>Property Owner Financials - Current Assets';
                    isMissed = true;
                }

                if(opportunity.Cost_of_Goods_Sold__c == null)
                {
                    validationMessage += '<br/>Property Owner Financials - Cost of Goods Sold';
                    isMissed = true;
                }

                if(opportunity.Current_Liabilities__c == null)
                {
                    validationMessage += '<br/>Property Owner Financials - Current Liabilities';
                    isMissed = true;
                }


                if(opportunity.Total_Assets_of_Owner_Occupant__c == null)
                {
                    validationMessage += '<br/>Property Owner Financials - Total Assets of Owner Account';
                    isMissed = true;
                }

                if(opportunity.Total_Liabilities__c == null)
                {
                    validationMessage += '<br/>Property Owner Financials - Total Liabilities';
                    isMissed = true;
                }

                if(opportunity.Intangible_Assets_of_Owner_Occupant__c == null)
                {
                    validationMessage += '<br/>Property Owner Financials - Intagible Assets';
                    isMissed = true;
                }
            }



            // First Mortgage - Section starts

            if(opportunity.First_Mortgage__c == null)
            {
                validationMessage += '<br/>First Mortgage - First Mortgage';
                isMissed = true;
            }

            if(opportunity.First_Mortgage__c == 'Yes') {
                if(opportunity.Mortgage_Lender__c  == null)
                {
                    validationMessage += '<br/>First Mortgage - Mortgage Lender (1st)';
                    isMissed = true;
                }

                if(opportunity.Type_of_Loan_First__c  == null)
                {
                    validationMessage += '<br/>First Mortgage - Type of Mortgage (1st)';
                    isMissed = true;
                }

                if(opportunity.Type_of_Financing_First__c  == null)
                {
                    validationMessage += '<br/>First Mortgage - Type of Financing (1st)';
                    isMissed = true;
                }

                if(opportunity.Current_Balance_First_Mortgage__c  == null)
                {
                    validationMessage += '<br/>First Mortgage - Current Balance';
                    isMissed = true;
                }

                if(opportunity.First_Mortgage_Lender_Contact_Name__c  == null)
                {
                    validationMessage += '<br/>First Mortgage - Lender Contact Name';
                    isMissed = true;
                }

                if(opportunity.Interest_Rate_1st__c  == null)
                {
                    validationMessage += '<br/>First Mortgage - Interest Rate';
                    isMissed = true;
                }

                if(opportunity.First_Mortgage_Lender_Contact_Email__c  == null)
                {
                    validationMessage += '<br/>First Mortgage - Lender Contact Email';
                    isMissed = true;
                }

                if(opportunity.Annual_1st_Mortgage_Payments__c == null)
                {
                    validationMessage += '<br/>First Mortgage - Annual Mortgage Payment';
                    isMissed = true;
                }

                if(opportunity.First_Mortgage_Lender_Contact_Phone__c == null)
                {
                    validationMessage += '<br/>First Mortgage - Lender Contact Phone';
                    isMissed = true;
                }
            }

            // Second Mortgage - Section starts

            if(opportunity.Second_Mortgage__c  == null)
            {
                validationMessage += '<br/>Second Mortgage - Second Mortgage';
                isMissed = true;
            }

            if(opportunity.Second_Mortgage__c  == 'Yes') {
                if(opportunity.Second_Mortgage_Lender__c  == null)
                {
                    validationMessage += '<br/>Second Mortgage - Mortgage Lender (2nd)';
                    isMissed = true;
                }

                if(opportunity.Type_of_Loan_Second__c  == null)
                {
                    validationMessage += '<br/>Second Mortgage - Type of Mortgage (2nd)';
                    isMissed = true;
                }

                if(opportunity.Type_of_Financing_Second__c  == null)
                {
                    validationMessage += '<br/>Second Mortgage - Type of Financing (2nd)';
                    isMissed = true;
                }

                if(opportunity.Current_Balance_Second_Mortgage__c  == null)
                {
                    validationMessage += '<br/>Second Mortgage - Current Balance';
                    isMissed = true;
                }

                if(opportunity.Second_Mortgage_Lender_Contact_Name__c  == null)
                {
                    validationMessage += '<br/>Second Mortgage - Lender Contact Name';
                    isMissed = true;
                }

                if(opportunity.Interest_Rate_2nd__c  == null)
                {
                    validationMessage += '<br/>Second Mortgage - Interest Rate';
                    isMissed = true;
                }

                if(opportunity.Second_Mortgage_Lender_Contact_Email__c == null)
                {
                    validationMessage += '<br/>Second Mortgage - Lender Contact Email';
                    isMissed = true;
                }

                if(opportunity.Annual_2nd_Mortgage_Payments__c == null)
                {
                    validationMessage += '<br/>Second Mortgage - Annual Mortgage Payment';
                    isMissed = true;
                }

                if(opportunity.Second_Mortgage_Lender_Contact_Phone__c == null)
                {
                    validationMessage += '<br/>Second Mortgage - Lender Contact Phone';
                    isMissed = true;
                }
            }

            // Project Information - Section starts

            if(opportunity.Type_of_Improvements_Multi__c == null)
            {
                validationMessage += '<br/>Project Information - Type of Improvements';
                isMissed = true;
            }
            if(opportunity.Desired_Project_Start_Date__c == null)
            {
                validationMessage += '<br/>Project Information - Desired Project Start Date';
                isMissed = true;
            }
            if(opportunity.Description_of_Improvements__c == null)
            {
                validationMessage += '<br/>Project Information - Detail of Improvements';
                isMissed = true;
            }
            if(opportunity.Loan_Term__c == null)
            {
                validationMessage += '<br/>Project Information - Financing Term';
                isMissed = true;
            }
            if(opportunity.Est_Improvement_Cost__c == null)
            {
                validationMessage += '<br/>Project Information - Improvement Cost (Est.)';
                isMissed = true;
            }

            if(opportunity.PACE_payment_amount_est__c == null)
            {
                validationMessage += '<br/>Project Information - PACE Payment Amount (Est.)';
                isMissed = true;
            }
            if(opportunity.Capitalized_Interest_NotPrepaid__c == null)
            {
                validationMessage += '<br/>Project Information - Capitalized Interest';
                isMissed = true;
            }
            if(opportunity.Total_Financing_Amount__c == null)
            {
                validationMessage += '<br/>Project Information - Total PACE financing amount (Est.)';
                isMissed = true;
            }

            // Project Information-Solar Specific - Section starts

            if(opportunity.Solar_PV_System_Size_kW__c == null)
            {
                validationMessage += '<br/>Project Information - Solar PV System Size (kW)';
                isMissed = true;
            }
            if(opportunity.Estimated_Utility_Rate_Escalation_yr__c == null)
            {
                validationMessage += '<br/>Project Information - Estimated Utility Rate Escalation (%/yr)';
                isMissed = true;
            }
            if(opportunity.Year_1_Electricity_kWh_Production_Est__c == null)
            {
                validationMessage += '<br/>Project Information - Year 1 Electricity kWh Production (Est.)';
                isMissed = true;
            }
            if(opportunity.Avoided_Cost_of_Electricity_ACOE__c == null)
            {
                validationMessage += '<br/>Project Information - Avoided Cost of Electricity (ACOE)';
                isMissed = true;
            }

            // Incentive Programs - Section Starts

//            if(opportunity.Incentive_Measures_Already_Applied__c == null)
//            {
//                validationMessage += '<br/>Project Information - Incentive Measures Already Applied?';
//                isMissed = true;
//            }
//            if(opportunity.Incentive_Measures_Already_Applied__c == 'Yes' ||
//                    opportunity.Incentive_Measures_Plan_to_Apply__c == 'Yes') {
//                if(opportunity.Name_of_Incentive_Program__c == null)
//                {
//                    validationMessage += '<br/>Project Information - Name of Incentive Program';
//                    isMissed = true;
//                }
//                if(opportunity.Amount_of_Incentive_est__c == null)
//                {
//                    validationMessage += '<br/>Project Information - Amount of Incentive (est.)';
//                    isMissed = true;
//                }
//            }

            if(opportunity.Incentive_Measures_Plan_to_Apply__c == null)
            {
                validationMessage += '<br/>Project Information - Incentive Measures Plan to Apply?';
                isMissed = true;
            }


            // Environmental Status (Please Choose One) - Section starts

            if(opportunity.Sensitive_Industries__c == null)
            {
                validationMessage += '<br/>Environmental Status - Sensitive Industries';
                isMissed = true;
            }
            if(opportunity.Hazardous_Substances__c == null)
            {
                validationMessage += '<br/>Environmental Status - Hazardous Substances';
                isMissed = true;
            }
            if(opportunity.Contamination__c == null)
            {
                validationMessage += '<br/>Environmental Status - Contamination';
                isMissed = true;
            }
            if(opportunity.Regulatory_Government_Actions__c == null)
            {
                validationMessage += '<br/>Environment Status - Regulatory Government Actions';
                isMissed = true;
            }
            if(opportunity.Pending_Proceedings_or_Lawsuits__c == null)
            {
                validationMessage += '<br/>Environment Status - Pending Proceedings or Lawsuits';
                isMissed = true;
            }
            if(opportunity.Risk_Studies_or_Assessments__c == null)
            {
                validationMessage += '<br/>Environment Status - Risk Studies or Assessments';
                isMissed = true;
            }
            if(opportunity.Environmental_Studies_Performed__c != null) {
                if(opportunity.Environmental_Study_Report_Date__c == null)
                {
                    validationMessage += '<br/>Environmental Status - Report Date';
                    isMissed = true;
                }
            }

//            if(opportunity.Environmental_Status_Explanation__c == null)
//            {
//                validationMessage += '<br/>Environmental Status - Explanation';
//                isMissed = true;
//            }

            // Property Status (Please Choose One) - Section starts

            if(opportunity.Mortgage_Delinquencies_or_Default__c == null)
            {
                validationMessage += '<br/>Property Status - Mortgage Delinquencies or Default';
                isMissed = true;
            }

            if(opportunity.Tax_Defaults_or_Delinquencies__c == null)
            {
                validationMessage += '<br/>Property Status - Tax Defaults or Delinquencies';
                isMissed = true;
            }

            if(opportunity.Involuntary_Liens__c == null)
            {
                validationMessage += '<br/>Property Status - Involuntary Liens';
                isMissed = true;
            }

            if(opportunity.Bankruptcy_Proceedings_or_Litigation__c == null)
            {
                validationMessage += '<br/>Property Status - Bankruptcy Proceedings or Litigation';
                isMissed = true;
            }

//            if(opportunity.Property_Status_Explanation__c == null)
//            {
//                validationMessage += '<br/>Property Status - Property Status Explanation';
//                isMissed = true;
//            }

            // Owner Entity Status (Please Choose One) - Section starts

            if(opportunity.Owner_Bankruptcy__c == null)
            {
                validationMessage += '<br/>Owner Entity Status - Owner Bankruptcy';
                isMissed = true;
            }
            if(opportunity.Owner_as_Defendent__c == null)
            {
                validationMessage += '<br/>Owner Entity Status - Owner as Defendent';
                isMissed = true;
            }
            if(opportunity.Forclosure_Short_Sale_or_Deed_in_Lieu__c == null)
            {
                validationMessage += '<br/>Owner Entity Status - Forclosure Short Sale or Deed in Lieu';
                isMissed = true;
            }
            if(opportunity.Financial_Crime__c == null)
            {
                validationMessage += '<br/>Owner Entity Status - Financial Crime';
                isMissed = true;
            }

            if(!isMissed)
            {
                opp.StageName = 'Qualified Lead';
                opp.LeadSource='Channel Partner';
                opp.Construction_Work_Status__c = 'Scope Identified';
                opp.Project_Type__c = 'TBD';
                opp.Project_Objective__c = 'Property Upgrades';
                opp.Type_of_Improvements__c = 'EE';

                update opp;
                validationMessage += 'Your application is submitted successfully';
            }
        }

        this.validationMessage = validationMessage;
    }

}