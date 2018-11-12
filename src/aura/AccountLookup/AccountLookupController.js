({
    searchTab: function(component, event, helper) {
        var tab1 = component.find('searchId');
        var TabOnedata = component.find('searchTabId');
 
        var tab2 = component.find('accId');
        var TabTwoData = component.find('accTabId');
        $A.util.addClass(tab1, 'slds-active');
        $A.util.addClass(TabOnedata, 'slds-show');
        $A.util.removeClass(TabOnedata, 'slds-hide');
        // Hide and deactivate others tab
        $A.util.removeClass(tab2, 'slds-active');
        $A.util.removeClass(TabTwoData, 'slds-show');
        $A.util.addClass(TabTwoData, 'slds-hide');
        console.log(tab2);
    },
    accTab: function(component, event, helper) {
        var tab1 = component.find('searchId');
        var TabOnedata = component.find('searchTabId');
 		
        var tab2 = component.find('accId');
        var TabTwoData = component.find('accTabId');
 console.log(tab2);
        $A.util.addClass(tab2, 'slds-active');
        $A.util.removeClass(TabTwoData, 'slds-hide');
        $A.util.addClass(TabTwoData, 'slds-show');
        // Hide and deactivate others tab
        $A.util.removeClass(tab1, 'slds-active');
        $A.util.removeClass(TabOnedata, 'slds-show');
        $A.util.addClass(TabOnedata, 'slds-hide');
     //   console.log(component.get("v.lstOfRecordType").size());      
         var action = component.get("c.fetchRecordTypeValues");
      	 action.setCallback(this, function(response) {
         component.set("v.lstOfRecordType", response.getReturnValue());
      });
      $A.enqueueAction(action);
    },
    saveContactRecord : function(component, event, helper) {
        var conObj = component.get("v.objContact");
           //set the default accountId is null 
           conObj.AccountId = null ; 
           conObj.Id = component.get("v.recordId");
       // check if selectedLookupRecord is not equal to undefined then set the accountId from 
       // selected Lookup Object to Contact Object before passing this to Server side method
        if(component.get("v.selectedLookUpRecord").Id != undefined){
          conObj.AccountId = component.get("v.selectedLookUpRecord").Id;
        } 
        
       //call apex class method
      var action = component.get('c.saveContact');
        action.setParams({
            'con': conObj
        })
      action.setCallback(this, function(response) {
        //store state of response
        var state = response.getState();
        if (state === "SUCCESS") {
         console.log('Update');
        }
      });
      $A.enqueueAction(action);
      $A.get('e.force:refreshView').fire();
       var childComp = component.find("childComp");
         var pillTarget = childComp.find("lookup-pill");
         var lookUpTarget = childComp.find("lookupField"); 
        
         $A.util.addClass(pillTarget, 'slds-hide');
         $A.util.removeClass(pillTarget, 'slds-show');
        
         $A.util.addClass(lookUpTarget, 'slds-show');
         $A.util.removeClass(lookUpTarget, 'slds-hide');
      
         childComp.set("v.SearchKeyWord",null);
         childComp.set("v.listOfSearchRecords", null );
         childComp.set("v.selectedRecord", {} );   
	},
    saveContactRecordAccount : function(component, event, helper) {
        var conObj = component.get("v.objContact");
        var accObj = component.get("v.objAccount");
        conObj.Id = component.get("v.recordId");
        var recordTypeLabel = component.find("selectRecordTypeId").get("v.value");
        console.log(recordTypeLabel);
      var action = component.get('c.saveAccountAndUpdateContact');
        action.setParams({
            'con': conObj,
            'acc' : accObj,
            'rType' : recordTypeLabel
        })
      action.setCallback(this, function(response) {
        //store state of response
        var state = response.getState();
        if (state === "SUCCESS") {
         console.log('Update');
            component.set("v.objAccount.Name", null);
        }
      });
      $A.enqueueAction(action);
      $A.get('e.force:refreshView').fire();
        
      
	}
})