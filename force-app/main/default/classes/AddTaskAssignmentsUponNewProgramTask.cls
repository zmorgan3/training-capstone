public with sharing class AddTaskAssignmentsUponNewProgramTask {
    public AddTaskAssignmentsUponNewProgramTask() {

    }

    public static void createTaskAssignmentUponNewProgramTask(List<Program_Task__c> insertedProgramTasks){
        try{
            List<Task_Assignment__c> taskAssignmentList = new List<Task_Assignment__c>();
            Id programId = insertedProgramTasks[0].Program__c;
            
        
            List <Program_Assignment__c> programAssignmentsList = new List<Program_Assignment__c>([SELECT Name, Id, Program_Assignment__c, Status__c, Contact_Name__c, Program_Due_Date__c   
                                                                                                    FROM Program_Assignment__c
                                                                                                    WHERE Program__c =: programId AND Status__c != 'Completed']);
            
            for(Program_Task__c programTask : insertedProgramTasks){                                                    
                for(Program_Assignment__c programAssignment : programAssignmentsList){

                    Task_Assignment__c TA = new Task_Assignment__c();
                    TA.Program__c = programId;
                    TA.Training_Task__c = programTask.Training_Task__c;
                    TA.Task_Assigned_To_Contact__c =  programAssignment.Program_Assignment__c;
                    TA.Status__c = 'Incomplete';
                    taskAssignmentList.add(TA);
                }         
            }

                insert taskAssignmentList;    

        }

        catch(exception e){
            System.debug(e.getMessage());
            throw new AuraHandledException('HELLO');
        }
        
    }
}
