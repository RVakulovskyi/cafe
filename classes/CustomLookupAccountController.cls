public with sharing class CustomLookupAccountController {
    public Account account {
        get; set;
    } // new account to create
    public List<Account> results{
        get;set;
    } // search results
    public String searchString{
        get; set;
    } // search keyword

    public CustomLookupAccountController() {
        this.account = new Account();
        // get the current search string
        this.searchString = System.currentPageReference().getParameters().get('lksrch');
        runSearch();
    }

    // performs the keyword search
    public PageReference search() {
        runSearch();
        return null;
    }

    // prepare the query and issue the search command
    private void runSearch() {
        // TODO prepare query string for complex serarches & prevent injections
        this.results = performSearch(this.searchString);
    }

    // run the search and return the records found.
    private List<Account> performSearch(string searchString) {

        String soql = 'SELECT Id, Name FROM Account';
        if(!String.isEmpty(searchString))
            soql = soql +  ' WHERE NAME LIKE \'%' + searchString +'%\'';
        soql = soql + ' limit 25';

        System.debug(soql);
        return database.query(soql);
    }

    // save the new account record
    public PageReference saveAccount() {
        try{
        	insert account;
        } catch(Exception ex) {
           // ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage()));
        }
        // reset the account
//        account = new Account();
        return null;
    }

    // used by the visualforce page to send the link to the right dom element
    public string getFormTag() {
        return System.currentPageReference().getParameters().get('frm');
    }

    // used by the visualforce page to send the link to the right dom element for the text box
    public string getTextBox() {
        return System.currentPageReference().getParameters().get('lknm');
    }
}