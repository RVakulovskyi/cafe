({
    fetchPickListVal: function(component) {
        var action = component.get("c.getselectOptions");
        var objName = component.get("v.objName");
        var pickListName = component.get("v.picklistName");
        var currentValue = component.get("v.currentValue");
        var currentControleValue = component.get("v.currentControlValue");
        console.log(objName);
        console.log(pickListName);
        console.log(currentValue);
        console.log(currentControleValue);
        action.setParams({
            "objObject": objName,
            "fld": pickListName,
            "controleObjectValue" : currentControleValue
        });
        var opts = [];
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                var allValues = response.getReturnValue();
 
                if (allValues != undefined && allValues.length > 0) {
                    opts.push({
                        class: "optionClass",
                        label: "--- None ---",
                        value: ""
                    });
                }
                for (var i = 0; i < allValues.length; i++) {
                    opts.push({
                        class: "optionClass",
                        label: allValues[i],
                        value: allValues[i]
                    });
                }
                component.find("picklistValueSelect").set("v.options", opts);
            }
        });
        $A.enqueueAction(action);
    },
})