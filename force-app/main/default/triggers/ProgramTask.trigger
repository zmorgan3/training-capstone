trigger ProgramTask on Program_Task__c (after delete) {

    if(Trigger.isAfter && Trigger.isDelete){
        System.debug('in program task deletion trigger');
        ProgramTaskDeleter.deleteTaskAssignments(Trigger.old);
    }
}