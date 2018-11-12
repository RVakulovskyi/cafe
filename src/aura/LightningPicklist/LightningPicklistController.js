({
    doInit: function(component, event, helper) {
        var picklistName = component.get("v.picklistName");
        var objName = component.get("v.objName");
        var testVal = component.get("v.currentControlValue");
        helper.fetchPickListVal(component);
    },
    onPicklistChange: function(component, event, helper) {
        var cmpEvent = component.getEvent("picklistEvent");
        var selectedPicklistValue = event.getSource().get("v.value");
        var picklistName = component.get("v.picklistName");
        console.log(selectedPicklistValue);
        console.log('test');
        cmpEvent.setParams({
            "picklistValue" : selectedPicklistValue,
            "fieldName" : picklistName
        });
        cmpEvent.fire();
    }
})