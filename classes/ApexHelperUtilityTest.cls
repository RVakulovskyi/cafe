@isTest
public class ApexHelperUtilityTest  {

    private static testmethod void testQueryAll() {
        Task taskCreated = new Task();
        insert taskCreated;
        Task taskRetrieved = (Task)ApexHelperUtility.queryAllFieldsObject('Task', taskCreated.Id);
        System.assertEquals(taskRetrieved.Id, taskCreated.Id, 'Ids should be the same');
    }

    private static testmethod void testQueryMeta() {
       TriggerSettings__mdt metaForTest =  (TriggerSettings__mdt)ApexHelperUtility.queryCustomMetaType('TriggerSettings__mdt','Lead');
       System.assertEquals(true, metaForTest !=null, 'Something should be retrieved');

    }
}