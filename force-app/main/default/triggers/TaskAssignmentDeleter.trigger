trigger TaskAssignmentDeleter on Program_Assignment__c (after delete) {

    if(trigger.isAfter && trigger.isDelete){

        //TaskAssignmentGenerator.deleteTaskAssignments(Trigger.new);
    }

}