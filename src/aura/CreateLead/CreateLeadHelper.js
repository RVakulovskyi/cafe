({
	helperMethod : function() {
		
	},changeStageHelpr: function(component, event, helper) {
        var divForPreQual = component.find('PreQual');
        var divForQual = component.find('Qual');
        var divForQuote = component.find('Quoted');
        var leadStageValue = component.get('v.LeadToInsert.Stage__c');
        console.log(leadStageValue);
        $A.util.removeClass(divForPreQual, 'slds-hide');
        $A.util.removeClass(divForQual, 'slds-hide');
        $A.util.removeClass(divForQuote, 'slds-hide');
        $A.util.addClass(divForPreQual, 'slds-hide');
        $A.util.addClass(divForQuote, 'slds-hide');
        $A.util.addClass(divForQual, 'slds-hide');
        if (leadStageValue.indexOf('Pre-Qualified') != -1) {
            console.log('true11');
            $A.util.removeClass(divForPreQual, 'slds-hide');
        }
        if (leadStageValue == 'Qualified Lead') {
            $A.util.removeClass(divForQual, 'slds-hide');
        }
        if (leadStageValue == 'Quoted') {
            $A.util.removeClass(divForQuote, 'slds-hide');
        }
    },
    changeSolarHelpr: function(component, event, helper) {
        var divForSolar = component.find('SolarDiv');
        var leadSolarValue = component.get('v.LeadToInsert.Solar_Component__c');
        console.log(leadSolarValue);
        $A.util.removeClass(divForSolar, 'slds-hide');
        if (leadSolarValue == 'Yes') {
            $A.util.removeClass(divForSolar, 'slds-hide');
        } else {
            $A.util.addClass(divForSolar, 'slds-hide');
        }
    }
})