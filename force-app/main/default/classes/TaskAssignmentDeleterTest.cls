@isTest
public class TaskAssignmentDeleterTest {
   
    @isTest
    static void testTaskAssignmentDeleter_givenProgramWithTwoProgramTasks_deleteOneProgramTask_taskAssignmentsWillBeDeleted(){

        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;

        Contact testContact = new Contact(FirstName = 'Test', LastName = 'Contact', AccountId = testAccount.Id);
        insert testContact;

        Contact testContact2 = new Contact(FirstName = 'Test2', LastName = 'Contact2', AccountId = testAccount.Id);
        insert testContact2;

        Training_Program__c testProgram = new Training_Program__c(Name = 'Test Program');
        insert testProgram;

        Training_Task__c testTrainingTask = new Training_Task__c();
        testTrainingTask.Name = 'TestTT';
        testTrainingTask.Task_Description__c = 'test';
        testTrainingTask.Days_Needed_to_Complete__c = 4;
        insert testTrainingTask;

        Training_Task__c testTrainingTask2 = new Training_Task__c();
        testTrainingTask.Name = 'TestTT2';
        testTrainingTask.Task_Description__c = 'test2';
        testTrainingTask.Days_Needed_to_Complete__c = 4;
        insert testTrainingTask2;

        Program_Task__c testProgramTask = new Program_Task__c( Program__c = testProgram.Id, 
                                                                Training_Task__c = testTrainingTask.Id, 
                                                                 Day_in_Program_Due__c = 1);

        insert testProgramTask;
        Program_Task__c testProgramTask2 = new Program_Task__c( Program__c = testProgram.Id, 
                                                                 Training_Task__c = testTrainingTask.Id, 
                                                                  Day_in_Program_Due__c = 1);
        insert testProgramTask2;

        Program_Assignment__c testProgramAssignment = new Program_Assignment__c(Program__c = testProgram.Id, 
                                                                                Program_Assigned_Date__c = Date.Today(), 
                                                                                Program_Assignment__c = testContact.Id);
        insert testProgramAssignment;

         Program_Assignment__c testProgramAssignment2 = new Program_Assignment__c(Program__c = testProgram.Id, 
                                                                                Program_Assigned_Date__c = Date.Today(), 
                                                                                Program_Assignment__c = testContact2.Id);                                                                        
        insert testProgramAssignment2;
        System.debug(testProgramAssignment2);
        List<Task_Assignment__c> taskAssignments = [SELECT Id 
                                                    FROM Task_Assignment__c 
                                                    WHERE Program__c = :testProgram.Id];

        System.debug(taskAssignments);

        Test.startTest();
        delete testProgramTask2;
        update taskAssignments;
        Test.stopTest();

        
        System.assertEquals(1, taskAssignments.size());
        System.debug('Test Successful');
    }
    
}
