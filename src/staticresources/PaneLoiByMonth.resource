crmc.require(['sfdc', 'CustomSettings'], function(sfdc, customSettings){
  crmc.addReadingPane({
    itemID: "PaneLoiByMonth",
    isAvailable: function(context) {
      // This function is called before the action item is displayed and returns a boolean if the item should be displayed\
      // By default determine availability based on Feature Security for this action
      return customSettings.getSetting(context.objectDescribe.name, this.itemID) !== false;
    },
    getLabel: function(context) {
      // This function returns the display label of the action item and is called before the item is shown
      return "LOI by Month";
    },
    saveView: function(context, mainDiv, viewInfo) {
      //This is executed before the view is saved, allowing you to persist information in the view.
      try {
        if (!viewInfo.readingPane)
          return;
        if (!viewInfo.readingPane[this.itemID]) {
          viewInfo.readingPane[this.itemID] = {};
        }
        viewInfo.readingPane[this.itemID].persistedValue = 'some persisted value';
      } catch(e){
        //something's gone wrong, let's not let it bubble up and cause issues with saving.
        console.log(e);
      }   
    },
    loadView: function(context) {
      // TODO
    },
    select: function(context, mainDiv) {
      console.log('select()');//TODO
      console.log(context);//TODO
      // declare and initialize local varaibles
      var los = 0;
      var sent = 0;
      var executed = 0;
      var filteredTotal = 0;
      // prior to calculating the formula fields, verify that both object: context and array: context.selectedRows exist
      if((context) && (context.selectedRows) && (context.selectedRows.length>=0)) {
        // calculate formula fields
        for(var i=0; i<context.selectedRows.length; i++) {
          // LOS Dead
          if(context.selectedRows[i].Date_Dead_Lost__c) {
            los += Number(context.selectedRows[i].Financing_Amount__c);
          }
          // LOI Sent
          if(context.selectedRows[i].LOI_Sent_Date__c) {
            sent += Number(context.selectedRows[i].Financing_Amount__c);
          }
          // LOI Executed
          if(context.selectedRows[i].LOI_Executed_Date__c) {
            executed += Number(context.selectedRows[i].Financing_Amount__c);
          }
          // Filtered Total
          filteredTotal += Number(context.selectedRows[i].Financing_Amount__c);
        }
        
        // format currency
        kendo.culture('en-US');
        los = kendo.toString(los, 'c');
        sent = kendo.toString(sent, 'c');
        executed = kendo.toString(executed, 'c');
        filteredTotal = kendo.toString(filteredTotal, 'c');
        
        // empty the reading panel element, then construct and append the new dynamic HTML
        mainDiv.empty();
        mainDiv.append(
          '<div class="k-grid k-widget k-reorderable k-pane" style="border: 0;">'+
            '<div style="border: 1px solid #ccc;">'+
              '<h3 style="padding: 5px 10px;display: block;color: #fff;background-color: #1797c0;font-size: 14px;letter-spacing: 0.0625em;">YTD Totals</h3>'+
              '<div class="k-grid-header">'+
                '<div class="k-grid-header-wrap">'+
                  '<table>'+
                    '<thead>'+
                      '<tr>'+
                        '<th class="k-header" style="padding: 10px;">LOS</th>'+
                        '<th class="k-header" style="padding: 10px;">Sent</th>'+
                        '<th class="k-header" style="padding: 10px;">Executed</th>'+
                      '</tr>'+
                    '</thead>'+
                  '</table>'+
                '</div>'+
              '</div>'+
              '<div class="k-grid-content">'+
                '<table>'+
                  '<tbody>'+
                    '<tr>'+
                      '<td style="padding:10px;">'+los+'</td>'+
                      '<td style="padding:10px;">'+sent+'</td>'+
                      '<td style="padding:10px;">'+executed+'</td>'+
                    '</tr>'+
                  '</tbody>'+
                '</table>'+
              '</div>'+
            '</div>'+
            '<div style="margin-top: 30px;">'+
              '<div style="border: 1px solid #ccc;">'+
                '<h3 style="padding: 5px 10px;display: block;color: #fff;background-color: #1797c0;font-size: 14px;letter-spacing: 0.0625em;">Filtered Total</h3>'+
                '<div class="k-grid-header">'+
                  '<div class="k-grid-header-wrap">'+
                    '<table>'+
                      '<thead>'+
                        '<tr>'+
                          '<th class="k-header" style="padding: 10px;">Filtered Total</th>'+
                        '</tr>'+
                      '</thead>'+
                    '</table>'+
                  '</div>'+
                '</div>'+
                '<div class="k-grid-content">'+
                  '<table>'+
                    '<tbody>'+
                      '<tr>'+
                        '<td style="padding:10px;">'+filteredTotal+'</td>'+
                      '</tr>'+
                    '</tbody>'+
                  '</table>'+
                '</div>'+
              '</div>'+
          '</div>'
        );
      }
    }
  });
});