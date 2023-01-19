trigger TaskAssignment on Program_Task__c (after insert) {

    if (Trigger.isInsert && Trigger.isAfter)
    {
        //AddTaskAssignmentsUponNewProgramTask.createTaskAssignmentUponNewProgramTask(Trigger.new);
    }

}

