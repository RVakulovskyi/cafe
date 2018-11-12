crmc.addCustomAction({
  itemID: "Lender_Ack",
  isAvailable: function(context) {
    // This function is called before the action item is displayed and returns a boolean if the item should be displayed
    // By default determine availability based on Feature Security for this action
    return this.featureSecurity.getSetting(context.objectDescribe.name, this.itemID) !== false;
  },
  isHeaderAvailable: function(context) {
    // This function determines if this item can be displayed from the column header menu
    return false;
  },
  isToolbarAvailable: function(context) {
    // This function determines if this item can be displayed in the Toolbar as a button
    return false;
  },
  getLabel: function(context) {
    // This function returns the display label of the action item and is called before the item is shown
    return "Lender Ack.";
  },
  createSubmenuItems: function(context) {
    // If this function returns additional action item objects, they will appear as submenu items
    return [];
  },
  click: function(context) {
    var ids = '';
    if (context.selectedRows.length > 0) {
      Object.each(context.selectedRows, function(item) {
        if (ids.length > 0) ids += "'|'";
        ids += item.Id;
      });
     var lienObj = '';
     var data = sfdc.query("SELECT Id, Opportunity__c, Opportunity__r.First_Mortgage_Lender_Contact_Name__c, Name FROM "+context.objectDescribe.name+" WHERE Id = '"+ids[0]+"');
     lienObj = data[0];
     var url =  "https://composer.congamerge.com" +
    "?sessionId=" + sforce.connection.sessionId +
    "&ServerUrl=" + context.actionGrid.settings.Partner_Server_URL_290 +
    "&Id=" + lienObj.Opportunity__c +
    "&TemplateId=a0hj0000005JxcM" +
    "&QueryId=[LIEN]a0Z0a00000EFikn" +
    "&DocuSignVisible=1" +
    "&DefaultPDF=1" +
    "&DocuSignR1ID=" + lienObj.Opportunity__r.First_Mortgage_Lender_Contact_Name__c + 
    "&DocuSignR1Role=Signer+1" +
    "&DocuSignR1Type=Signer" + 
    "&DocuSignR1RoutingOrder=1" + 
    "&SC0=1"+ 
    "&SC1=Attachments";
      window.open(url, 'Conga', 'width=700,height=450,menubar=0');
    }
    else {
      kendoPopup.popup('Please select records',
        'Select at least one record to send to Conga.');
      return;
    }
  }
});