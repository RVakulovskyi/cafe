global class EgnyteAccessTokenSchedule implements Schedulable {
	/**
	 * @description Executes the scheduled Apex job. 
	 * @param sc contains the job ID
	 */ 
	global void execute(SchedulableContext sc) {
        
		EgnyteAPIHandler.formEgnyteRequest();
	}
}