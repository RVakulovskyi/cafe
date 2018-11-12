global class CreateRecordsResponse {
	public String RESULTMESSAGE{get;set;}
    public String RESULTCODE{get;set;}
    public String RECORDID{get;set;}
    
    public CreateRecordsResponse(String resultMessage, String resultCode, String RECORDID) {
        this.RESULTMESSAGE = resultMessage;
        this.RESULTCODE = resultCode;
        this.RECORDID = RECORDID;
    } 
}