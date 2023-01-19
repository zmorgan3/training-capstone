
trigger ProgramAssignment on Program_Assignment__c (after insert, after delete) {

    if (Trigger.isInsert && Trigger.isAfter)
    {
        TaskAssignmentGenerator.createTaskUponProgramAssignment(Trigger.new);
    }

    if(Trigger.isDelete && Trigger.isAfter)
    {
        System.debug('In delete trigger');
        TaskAssignmentDeleter.deleteTaskAssignments(Trigger.old);
        
    }

}