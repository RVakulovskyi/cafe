({
	saveUserEgnyte : function(component, event, helper) {
		var action = component.get('c.updateEgnyteCreds');
        var ltnCard1 = component.find("egnyte");
    	var ltnCard2 = component.find("egnyteHasCreds");
    	action.setParams({
        	"userLogin" : component.get("v.egnyteLogin"),
        	"userPassword" : component.get("v.egnytePassword")  
    	});
        action.setCallback(this,function(response){
            var ltnCard = component.find("egnyte");
            $A.util.addClass(ltnCard1, 'slds-hide');
            $A.util.removeClass(ltnCard2, 'slds-hide');
        });
        $A.enqueueAction(action);
        console.log(component.find("inputSecret").get("v.value"));
        component.get("v.egnyteLogin",null);
        component.get("v.egnytePassword",null);
	},
    doInit : function(component, event, helper) {
        var ltnCard1 = component.find("egnyte");
    	var ltnCard2 = component.find("egnyteHasCreds");
        $A.util.removeClass(ltnCard1, 'slds-hide');
        var action = component.get('c.findEgnyteCreds');
    	action.setParams({});
        action.setCallback(this,function(response){
            console.log(response.getReturnValue());
            if(response.getReturnValue() == true){
            	$A.util.removeClass(ltnCard2, 'slds-hide');
                $A.util.addClass(ltnCard1, 'slds-hide');
            }
        });
        $A.enqueueAction(action);
    },
    showAndHide : function(component, event, helper) {
    	var ltnCard1 = component.find("egnyte");
    	var ltnCard2 = component.find("egnyteHasCreds");
    	$A.util.removeClass(ltnCard1, 'slds-hide');
        $A.util.addClass(ltnCard2, 'slds-hide');
    }
})