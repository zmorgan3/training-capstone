public with sharing class TaskAssignmentGenerator {

    public TaskAssignmentGenerator(){

    }

    public static void createTaskUponProgramAssignment(List<Program_Assignment__c> insertedProgramAssignments){
        try{
            List<Task_Assignment__c> taskAssignmentList = new List<Task_Assignment__c>();
            Id programId = insertedProgramAssignments[0].Program__c;
            string contact;
            Date assignmentDate = insertedProgramAssignments[0].Program_Assigned_Date__c;//will be used for incrementing due date
            Decimal addedDays;
            Integer dueDate;

            System.debug(insertedProgramAssignments);

            List <Program_Task__c> programTaskList = [SELECT Id, Name, Training_Task__c, Day_in_Program_Due__c   
                                                                FROM Program_Task__c
                                                                WHERE Program__c =: programId];
                                                                                                        
            for(Program_Assignment__c programAssignment : insertedProgramAssignments){
                for(Program_Task__c programTask : programTaskList){
                    
                    addedDays = programTask.Day_in_Program_Due__c;
                    dueDate = Integer.ValueOf(addedDays);

                    Task_Assignment__c TA = new Task_Assignment__c();
                    TA.Program__c = programId;
                    TA.Training_Task__c = programTask.Training_Task__c;
                    TA.Task_Assigned_To_Contact__c = programAssignment.Program_Assignment__c;
                    TA.Task_Due_Date__c = assignmentDate.addDays(dueDate);
                    taskAssignmentList.add(TA);
                }         
            }
            System.debug('Hello');

                insert taskAssignmentList;    

        }

        catch(Exception e){
            throw new AuraHandledException(e.getMessage());
        }
    }
}

