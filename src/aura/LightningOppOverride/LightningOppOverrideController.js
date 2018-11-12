({
	doInit: function(component, event, helper) {
   		helper.initMethod(component, event, helper);
    },
    changeFunction : function(component, event, helper) {
        	var maps = component.get("v.MapOfLabels");
        	var keyArr = component.find("Keys");
        	var LabelArr = component.find("labelValues");
        	for(var i = 0 ;i < keyArr.length;i++) {
            	var keyForLabel  = keyArr[i].get("v.key");
             	for(var key in maps) {
                	if(maps[key].key == keyForLabel){
                 		LabelArr[i].set("v.value", maps[key].value);
                	}
        		}   
        	}
            var mapsOfValue = component.get("v.MapOfValues");
        	var ValuelArr = component.find("fieldValues");
        	for(var i = 0 ;i < keyArr.length;i++) {
            	var keyForLabel  = keyArr[i].get("v.key");
             	for(var key in mapsOfValue) {
                	if(mapsOfValue[key].key == keyForLabel){
                 		ValuelArr[i].set("v.value", mapsOfValue[key].value);
                	}
        		}   
        	}
            var mapsOfHelper = component.get("v.MapOfHelperText");
        	var helperArr = component.find("HelperText");
        	var ifsArr = component.find("renderList");
        	for(var i = 0 ;i < keyArr.length;i++) {
            	var keyForLabel  = keyArr[i].get("v.key");
             	for(var key in mapsOfHelper) {
                	if(mapsOfHelper[key].key.toLowerCase() == keyForLabel.toLowerCase()){
                 		helperArr[i].set("v.content", mapsOfHelper[key].value);
                        ifsArr[i].set("v.isTrue", true);
                    }
        		}   
        	}
    },
    changeOppInfiMode : function(component, event, helper) {
        helper.cancelMethod(component, event, helper);
        var viewMode = component.find("OppView");
        var editMode = component.find("OppEditOppInfor");
        var editButton = component.find("editButton");
        var cancelButton = component.find("cancelButton");
        $A.util.removeClass(viewMode, 'slds-hide');
        $A.util.removeClass(editMode, 'slds-hide');
        $A.util.removeClass(cancelButton, 'slds-hide');
        $A.util.removeClass(editButton, 'slds-hide');
        $A.util.addClass(viewMode, 'slds-hide');
    },
    changeOppOwnerMode : function(component, event, helper) {
        helper.cancelMethod(component, event, helper);
        var viewMode = component.find("OppView");
        var editMode = component.find("OppEditOwnInfor");
        var editButton = component.find("editButton");
        var cancelButton = component.find("cancelButton");
        $A.util.removeClass(viewMode, 'slds-hide');
        $A.util.removeClass(editMode, 'slds-hide');
        $A.util.removeClass(cancelButton, 'slds-hide');
        $A.util.removeClass(editButton, 'slds-hide');
        $A.util.addClass(viewMode, 'slds-hide');
    },
    changeOppProjectScope : function(component, event, helper) {
        helper.cancelMethod(component, event, helper);
        var viewMode = component.find("OppView");
        var editMode = component.find("OppEditProjectScope");
        var editButton = component.find("editButton");
        var cancelButton = component.find("cancelButton");
        $A.util.removeClass(viewMode, 'slds-hide');
        $A.util.removeClass(editMode, 'slds-hide');
        $A.util.removeClass(cancelButton, 'slds-hide');
        $A.util.removeClass(editButton, 'slds-hide');
        $A.util.addClass(viewMode, 'slds-hide');
    },
    changeOppProjectPricingAdv : function(component, event, helper) {
        helper.cancelMethod(component, event, helper);
        var viewMode = component.find("OppView");
        var editMode = component.find("OppEditProjectPricingAdvanced");
        var editButton = component.find("editButton");
        var cancelButton = component.find("cancelButton");
        $A.util.removeClass(viewMode, 'slds-hide');
        $A.util.removeClass(editMode, 'slds-hide');
        $A.util.removeClass(cancelButton, 'slds-hide');
        $A.util.removeClass(editButton, 'slds-hide');
        $A.util.addClass(viewMode, 'slds-hide');
    },
    changeOppProjectPricing : function(component, event, helper) {
        helper.cancelMethod(component, event, helper);
        var viewMode = component.find("OppView");
        var editMode = component.find("OppEditProjectPricing");
        var editButton = component.find("editButton");
        var cancelButton = component.find("cancelButton");
        $A.util.removeClass(viewMode, 'slds-hide');
        $A.util.removeClass(editMode, 'slds-hide');
        $A.util.removeClass(cancelButton, 'slds-hide');
        $A.util.removeClass(editButton, 'slds-hide');
        $A.util.addClass(viewMode, 'slds-hide');
    },
    changeOppPropertyInfo : function(component, event, helper) {
        helper.cancelMethod(component, event, helper);
        var viewMode = component.find("OppView");
        var editMode = component.find("OppEditPropertyDetails");
        var editButton = component.find("editButton");
        var cancelButton = component.find("cancelButton");
        $A.util.removeClass(viewMode, 'slds-hide');
        $A.util.removeClass(editMode, 'slds-hide');
        $A.util.removeClass(cancelButton, 'slds-hide');
        $A.util.removeClass(editButton, 'slds-hide');
        $A.util.addClass(viewMode, 'slds-hide');
    },
    changeOppPropertyDetails : function(component, event, helper) {
        helper.cancelMethod(component, event, helper);
        var viewMode = component.find("OppView");
        var editMode = component.find("OppEditProjectInformation");
        var editButton = component.find("editButton");
        var cancelButton = component.find("cancelButton");
        $A.util.removeClass(viewMode, 'slds-hide');
        $A.util.removeClass(editMode, 'slds-hide');
        $A.util.removeClass(cancelButton, 'slds-hide');
        $A.util.removeClass(editButton, 'slds-hide');
        $A.util.addClass(viewMode, 'slds-hide');
    },
    changeOppPropertyOwner : function(component, event, helper) {
        helper.cancelMethod(component, event, helper);
        var viewMode = component.find("OppView");
        var editMode = component.find("OppEditPropertyOwner");
        var editButton = component.find("editButton");
        var cancelButton = component.find("cancelButton");
        $A.util.removeClass(viewMode, 'slds-hide');
        $A.util.removeClass(editMode, 'slds-hide');
        $A.util.removeClass(cancelButton, 'slds-hide');
        $A.util.removeClass(editButton, 'slds-hide');
        $A.util.addClass(viewMode, 'slds-hide');
    },
    changeOppPropertyValuation : function(component, event, helper) {
        helper.cancelMethod(component, event, helper);
        var viewMode = component.find("OppView");
        var editMode = component.find("OppEditPropertyValuation");
        var editButton = component.find("editButton");
        var cancelButton = component.find("cancelButton");
        $A.util.removeClass(viewMode, 'slds-hide');
        $A.util.removeClass(editMode, 'slds-hide');
        $A.util.removeClass(cancelButton, 'slds-hide');
        $A.util.removeClass(editButton, 'slds-hide');
        $A.util.addClass(viewMode, 'slds-hide');
    },
    changeOppSolarInfo : function(component, event, helper) {
        helper.cancelMethod(component, event, helper);
        var viewMode = component.find("OppView");
        var editMode = component.find("OppEditSolarInfo");
        var editButton = component.find("editButton");
        var cancelButton = component.find("cancelButton");
        $A.util.removeClass(viewMode, 'slds-hide');
        $A.util.removeClass(editMode, 'slds-hide');
        $A.util.removeClass(cancelButton, 'slds-hide');
        $A.util.removeClass(editButton, 'slds-hide');
        $A.util.addClass(viewMode, 'slds-hide');
    },
    changeOppStageDead : function(component, event, helper) {
        helper.cancelMethod(component, event, helper);
        var viewMode = component.find("OppView");
        var editMode = component.find("OppEditStageDead");
        var editButton = component.find("editButton");
        var cancelButton = component.find("cancelButton");
        $A.util.removeClass(viewMode, 'slds-hide');
        $A.util.removeClass(editMode, 'slds-hide');
        $A.util.removeClass(cancelButton, 'slds-hide');
        $A.util.removeClass(editButton, 'slds-hide');
        $A.util.addClass(viewMode, 'slds-hide');
    },
    changeOppStageInfo : function(component, event, helper) {
        helper.cancelMethod(component, event, helper);
        var viewMode = component.find("OppView");
        var editMode = component.find("OppEditStageInfo");
        var editButton = component.find("editButton");
        var cancelButton = component.find("cancelButton");
        $A.util.removeClass(viewMode, 'slds-hide');
        $A.util.removeClass(editMode, 'slds-hide');
        $A.util.removeClass(cancelButton, 'slds-hide');
        $A.util.removeClass(editButton, 'slds-hide');
        $A.util.addClass(viewMode, 'slds-hide');
    },
    saveRecordOppInfo : function(component, event, helper) {
        helper.cancelMethod(component, event, helper);
        var viewMode = component.find("OppView");
        var editMode = component.find("OppEditOppInfor");
        var editButton = component.find("editButton");
        var cancelButton = component.find("cancelButton");
        var action = component.get('c.saveOpp');
        var inputOpp = component.get("v.simpleOpp");
    		action.setParams({
        		"inputOpp" : inputOpp  
    		});
        $A.enqueueAction(action);
        $A.util.removeClass(viewMode, 'slds-hide');
        $A.util.removeClass(editMode, 'slds-hide');
        $A.util.removeClass(cancelButton, 'slds-hide');
        $A.util.removeClass(editButton, 'slds-hide');
        $A.util.addClass(editMode, 'slds-hide');
        $A.util.addClass(cancelButton, 'slds-hide');
        console.log(event);  
        helper.initMethod(component, event, helper);
        $A.get('e.force:refreshView').fire();
    },
    cancelEdit : function(component, event, helper) {
   		helper.cancelMethod(component, event, helper);
	},
    eventHandler : function(component, event, helper) {
        var simpleOpp = component.get('v.simpleOpp');
        var picklistValue = event.getParam('picklistValue');
        var fieldName = event.getParam('fieldName');
        console.log(picklistValue);
        console.log(fieldName);
        var variable = "v.simpleOpp." + fieldName + "";
        component.set(variable, picklistValue);
	},
    eventLookupHandler : function(component, event, helper) {
        var simpleOpp = component.get('v.simpleOpp');
        var picklistValue = event.getParam('idValue');
        var fieldName = event.getParam('fieldName');
        var variable = "v.simpleOpp." + fieldName + "";
        component.set(variable, picklistValue);
        console.log(simpleOpp.AccountId);
	}
})