({
	cancelMethod : function(component, event, helper) {
		var viewMode = component.find("OppView");
        var editMode1 = component.find("OppEditOppInfor");
        var editMode2 = component.find("OppEditOwnInfor");
        var editMode3 = component.find("OppEditProjectScope");
        var editMode4 = component.find("OppEditProjectPricing");
        var editMode5 = component.find("OppEditProjectPricingAdvanced");
        var editMode6 = component.find("OppEditPropertyDetails");
        var editMode7 = component.find("OppEditProjectInformation");
        var editMode8 = component.find("OppEditPropertyOwner");
        var editMode9 = component.find("OppEditPropertyValuation");
        var editMode10 = component.find("OppEditSolarInfo");
        var editMode11 = component.find("OppEditStageDead");
        var editMode12 = component.find("OppEditStageInfo");
        var editButton = component.find("editButton");
        var cancelButton = component.find("cancelButton");
        $A.util.removeClass(viewMode, 'slds-hide');
        $A.util.removeClass(editMode1, 'slds-hide');
        $A.util.removeClass(editMode2, 'slds-hide');
        $A.util.removeClass(editMode3, 'slds-hide');
        $A.util.removeClass(editMode4, 'slds-hide');
        $A.util.removeClass(editMode5, 'slds-hide');
        $A.util.removeClass(editMode6, 'slds-hide');
        $A.util.removeClass(editMode7, 'slds-hide');
        $A.util.removeClass(editMode8, 'slds-hide');
        $A.util.removeClass(editMode9, 'slds-hide');
        $A.util.removeClass(editMode10, 'slds-hide');
        $A.util.removeClass(editMode11, 'slds-hide');
        $A.util.removeClass(editMode12, 'slds-hide');
        $A.util.removeClass(cancelButton, 'slds-hide');
        $A.util.removeClass(editButton, 'slds-hide');
        $A.util.addClass(cancelButton, 'slds-hide');
        $A.util.addClass(editButton, 'slds-hide');
        $A.util.addClass(editMode1, 'slds-hide');
        $A.util.addClass(editMode2, 'slds-hide');
        $A.util.addClass(editMode3, 'slds-hide');
        $A.util.addClass(editMode4, 'slds-hide');
        $A.util.addClass(editMode5, 'slds-hide');
        $A.util.addClass(editMode6, 'slds-hide');
        $A.util.addClass(editMode7, 'slds-hide');
        $A.util.addClass(editMode8, 'slds-hide');
        $A.util.addClass(editMode9, 'slds-hide');
        $A.util.addClass(editMode10, 'slds-hide');
        $A.util.addClass(editMode11, 'slds-hide');
        $A.util.addClass(editMode12, 'slds-hide');
    	$A.get('e.force:refreshView').fire();
	},
    initMethod : function(component, event, helper) {
    var action = component.get('c.returnFieldSets');
    action.setParams({
        "oppId" : component.get("v.recordId")  
    });
   	action.setCallback(this,function(response){
    var state = response.getState();
      if (state === "SUCCESS") {
        var listMap = [];
        var maps = response.getReturnValue();
        var fieldList = [];
        for(var key in maps) {
            listMap.push({value : maps[key], key : key});   
            fieldList.push(maps[key]);
            for(var fieldName in maps[key]) {
                var elementArray = maps[key][fieldName];
                if(!Array.isArray(elementArray)) {
                  fieldList.push(elementArray);
                }
                

            }
        }
          var arr = [];
          for(var item in fieldList) {
              if(!Array.isArray(fieldList[item])) {
                  arr+=fieldList[item]+',';
              }
          }
        arr = arr.substring(0, arr.length -1);
          console.log(arr);
        component.set('v.PageFieldSets',listMap);
        component.set('v.fieldList', arr);
   	  }
    });  
    $A.enqueueAction(action);
    var action2 = component.get('c.returnMapOfValues');
   		action2.setCallback(this,function(response){
    	var state = response.getState();
      	if (state === "SUCCESS") {
        	var listMap = [];
        	var maps = response.getReturnValue();
        	for(var key in maps) {
            	listMap.push({value : maps[key], key : key});   
        	}
        	component.set('v.MapOfValues',listMap);
            console.log(listMap);
   	  	}
    });       
    $A.enqueueAction(action2);
    var action3 = component.get('c.returnMapOfHelperText');
   		action3.setCallback(this,function(response){
    	var state = response.getState();
      	if (state === "SUCCESS") {
        	var listMap = [];
        	var maps = response.getReturnValue();
        	for(var key in maps) {
            	listMap.push({value : maps[key], key : key});   
        	}
            console.log(listMap);
        	component.set('v.MapOfHelperText',listMap);
   	  	}
    });       
    $A.enqueueAction(action3);
    var action4 = component.get('c.returnMapOfLabels');
   		action4.setCallback(this,function(response){
    	var state = response.getState();
      	if (state === "SUCCESS") {
        	var listMap = [];
        	var maps = response.getReturnValue();
        	for(var key in maps) {
            	listMap.push({value : maps[key], key : key});   
        	}
        	component.set('v.MapOfLabels',listMap);
   	  	}     
    });       
    $A.enqueueAction(action4);
    }
})