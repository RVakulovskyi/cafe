({
	doInit : function(component, event, helper) {
		helper.changeSolarHelpr(component, event, helper);
         var actionAssignAcc = component.get('c.getAccount');
            actionAssignAcc.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var account = response.getReturnValue();
                    console.log(account);
                    component.set('v.defaultAcc', account.Id);
                }
            });
            $A.enqueueAction(actionAssignAcc);
	},
    saveLead: function(component, event, helper) {
        var action = component.get('c.saveLeadCntr');
        var leadToInsert = component.get('v.LeadToInsert');
        var accountToView = component.get('v.simpleAcc');
        console.log(leadToInsert);
        console.log(accountToView);
        leadToInsert.Account_Name__c = accountToView.Id;
        leadToInsert.Account_Name__r = null;
        leadToInsert.Property_Owner_Main_Contact__r = null;
        leadToInsert.Originations_Team_Member__r = null;
        console.log(accountToView.AccTypeNew__c);
        if(accountToView.AccTypeNew__c == 'Channel Partner'){
            var testAccId;
            leadToInsert.Channel_Partner_Name__c  = accountToView.Id;
            console.log(component.get('v.defaultAcc'));
            leadToInsert.Account_Name__c = component.get('v.defaultAcc');
           
        }
        if(accountToView.AccTypeNew__c == 'Owner') {
            leadToInsert.Company = accountToView.Name;
        }
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
})