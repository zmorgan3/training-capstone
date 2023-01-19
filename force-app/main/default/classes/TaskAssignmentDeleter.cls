public with sharing class TaskAssignmentDeleter {
    public TaskAssignmentDeleter() {

    }

    @AuraEnabled
    public static void deleteTaskAssignments(List<Program_Assignment__c> selectedProgramAssignments){
        try {
            Id programId = selectedProgramAssignments[0].Program__c;
            List<Task_Assignment__c> taskAssignmentList = new List<Task_Assignment__c>();
            List<Id> idList = new List<Id>();
            
            for(Program_Assignment__c programAssignment: selectedProgramAssignments){
                idList.add(programAssignment.Program_Assignment__c);
            }
            System.debug(idList);

            taskAssignmentList = [SELECT Id, Name, Task_Assigned_To_Contact__c, Status__c
                                   FROM Task_Assignment__c
                                   WHERE Program__c =: programId AND Status__c != 'Completed' AND Task_Assigned_To_Contact__c IN :idList];

            System.debug(taskAssignmentList); 

            delete taskAssignmentList;

        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}
