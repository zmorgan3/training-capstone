public with sharing class ProgramTaskDeleter {
    public ProgramTaskDeleter() {

    }

    @AuraEnabled
    public static void deleteTaskAssignments(List<Program_Task__c> selectedProgramTasks){
        try {
            Id programId = selectedProgramTasks[0].Program__c;
            List<Program_Assignment__c> programAssignmentList = new List<Program_Assignment__c>();                               
            List<Task_Assignment__c> taskAssignmentList = new List<Task_Assignment__c>();
            List<Id> idList = new List<Id>();
            
            for(Program_Task__c programTask: selectedProgramTasks){
                idList.add(programTask.Training_Task__c);
            }
            System.debug(idList);

            taskAssignmentList = [SELECT Id, Name, Task_Assigned_To_Contact__c, Training_Task__c, Status__c
                                   FROM Task_Assignment__c
                                   WHERE Program__c =: programId AND Status__c != 'Completed' AND Training_Task__c IN :idList];

            System.debug(taskAssignmentList); 

            delete taskAssignmentList;

        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}
