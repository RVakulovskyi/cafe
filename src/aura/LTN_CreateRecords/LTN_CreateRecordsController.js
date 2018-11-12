({
    selectObjType: function(component, event, helper) {
        var selectedValue = component.get("v.selectedValue");
        console.log(selectedValue);
        var acc = component.find("account");
        var lead = component.find("leadComp");
        var contact = component.find("contact");
        if (selectedValue == '--None--') {
            $A.util.removeClass(acc, 'slds-hide');
            $A.util.removeClass(lead, 'slds-hide');
            $A.util.removeClass(contact, 'slds-hide');
            $A.util.addClass(acc, 'slds-hide');
            $A.util.addClass(lead, 'slds-hide');
            $A.util.addClass(contact, 'slds-hide');
        }
        if (selectedValue == 'Lead') {
            $A.util.removeClass(acc, 'slds-hide');
            $A.util.removeClass(lead, 'slds-hide');
            $A.util.removeClass(contact, 'slds-hide');
            $A.util.addClass(contact, 'slds-hide');
            $A.util.addClass(acc, 'slds-hide');
            helper.changeSolarHelpr(component, event, helper);
            helper.changeStageHelpr(component, event, helper);
            component.set('v.LeadToInsert.Solar_Component__c', 'TBD');
        }
        if (selectedValue == 'Contact') {
            $A.util.removeClass(acc, 'slds-hide');
            $A.util.removeClass(lead, 'slds-hide');
            $A.util.removeClass(contact, 'slds-hide');
            $A.util.addClass(lead, 'slds-hide');
            $A.util.addClass(acc, 'slds-hide');
        }
        if (selectedValue == 'Account') {
            $A.util.removeClass(acc, 'slds-hide');
            $A.util.removeClass(lead, 'slds-hide');
            $A.util.removeClass(contact, 'slds-hide');
            $A.util.addClass(lead, 'slds-hide');
            $A.util.addClass(contact, 'slds-hide');
            var action = component.get("c.fetchRecordTypeValues");
            action.setCallback(this, function(response) {
                component.set("v.lstOfRecordType", response.getReturnValue());
                console.log(response.getReturnValue());
            });
            $A.enqueueAction(action);
            var action1 = component.get("c.getRecTypeId");
            action1.setParams({
                "recordTypeLabel": "Public Account"
            });
            action1.setCallback(this, function(response) {
                console.log(response.getReturnValue());
                component.set("v.RecTypeId", response.getReturnValue());
            });
            $A.enqueueAction(action1);
        }
    },
    saveContact: function(component, event, helper) {
        var action = component.get('c.saveContactCntr');
        var inputContact = component.get("v.ContactToInsert");
        console.log(inputContact);
        inputContact.Account = null;
        action.setParams({
            "inputContact": inputContact
        });
        action.setCallback(this, function(response) {
            //store state of response
            var state = response.getState();
            console.log(state);
            if (state === "SUCCESS") {
                console.log('success');
                var contactId =  response.getReturnValue();
                var navEvt = $A.get("e.force:navigateToSObject");
    			navEvt.setParams({
      				"recordId": contactId,
      				"slideDevName": "Detail"
    				});
    			navEvt.fire();
                component.set("v.inputContact", null);
            } else {
                console.log(state);
            }
        });
        $A.enqueueAction(action);
    },
    saveLead: function(component, event, helper) {
        var action = component.get('c.saveLeadCntr');
        var leadToInsert = component.get('v.LeadToInsert');
        console.log(leadToInsert);
        leadToInsert.Account_Name__r = null;
        leadToInsert.Property_Owner_Main_Contact__r = null;
        leadToInsert.Originations_Team_Member__r = null;
        action.setParams({
            'inputLead': leadToInsert
        })
        action.setCallback(this, function(response) {
            //store state of response
            var state = response.getState();
            console.log(state);
            if (state === "SUCCESS") {
                var leadId = response.getReturnValue();
                console.log(leadId);
                var navEvt = $A.get("e.force:navigateToSObject");
    			navEvt.setParams({
      				"recordId": leadId,
      				"slideDevName": "Detail"
    				});
    			navEvt.fire();
                component.set("v.inputLead", null);
            } else {
                console.log(state);
            }
        });
        $A.enqueueAction(action);
    },
    onchangeRecordType: function(component, event, helper) {
        var recordTypeLabel1 = component.find("selectRecordTypeId").get("v.value");
        console.log(recordTypeLabel1);
        var action1 = component.get("c.getRecTypeId");
        action1.setParams({
            "recordTypeLabel": recordTypeLabel1
        });
        action1.setCallback(this, function(response) {
            console.log(response.getReturnValue());
            component.set("v.RecTypeId", response.getReturnValue());
        });
        $A.enqueueAction(action1);
    },
    useDefault: function(component, event, helper) {
        var action = component.get('c.saveLeadCntrDefault');
        var leadToInsert = component.get('v.LeadToInsert');
        console.log(leadToInsert);
        leadToInsert.Account_Name__r = null;
        leadToInsert.Property_Owner_Main_Contact__r = null;
        leadToInsert.Originations_Team_Member__r = null;
        console.log(leadToInsert + 'default');
        action.setParams({
            'inputLead': leadToInsert
        })
        action.setCallback(this, function(response) {
            //store state of response
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log('success');
                var leadId = response.getReturnValue();
                var navEvt = $A.get("e.force:navigateToSObject");
                console.log(leadId);
    			navEvt.setParams({
      				"recordId": leadId,
      				"slideDevName": "Detail"
    				});
    			navEvt.fire();
                component.set("v.inputLead", null);
            } else {
                console.log(state);
            }
        });
        $A.enqueueAction(action);
        /*helper.clear(component, event, helper);
        component.set("v.selectedValue", '--None--');
        $A.get('e.force:refreshView').fire();
        component.get('v.inputLead', null);*/
    },
    changeStage: function(component, event, helper) {
        helper.changeStageHelpr(component, event, helper);
    },
    changeSolar: function(component, event, helper) {
        helper.changeSolarHelpr(component, event, helper);
    },
    handleSuccess : function(component, event, helper) {
		var payload = event.getParams().response;
        console.log(payload.id);
		var navEvt = $A.get("e.force:navigateToSObject");
    			navEvt.setParams({
      				"recordId": payload.id,
      				"slideDevName": "Detail"
    				});
    	navEvt.fire();
	}
})