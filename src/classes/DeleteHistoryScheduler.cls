global class DeleteHistoryScheduler implements Schedulable {
   global void execute(SchedulableContext ctx) {
		DeleteHistoryObjectBatch batchToDelete = new DeleteHistoryObjectBatch();
       database.executeBatch(batchToDelete);
   }   
}