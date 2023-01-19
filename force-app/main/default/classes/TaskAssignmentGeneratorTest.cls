@isTest
public class TaskAssignmentGeneratorTest {
    @isTest
    static void testCreateTaskUponProgramAssignment_givenProgramWithOneProgramTask_oneTaskAssignmentCreated() {
        
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;

        Contact testContact = new Contact(FirstName = 'Test', LastName = 'Contact', AccountId = testAccount.Id);
        insert testContact;

        Training_Program__c testProgram = new Training_Program__c(Name = 'Test Program');
        insert testProgram;

        Training_Task__c testTrainingTask = new Training_Task__c();
        testTrainingTask.Name = 'TestTT';
        testTrainingTask.Task_Description__c = 'test';
        testTrainingTask.Days_Needed_to_Complete__c = 4;
        insert testTrainingTask;

        Program_Task__c testProgramTask = new Program_Task__c( Program__c = testProgram.Id, 
                                                                Training_Task__c = testTrainingTask.Id, 
                                                                 Day_in_Program_Due__c = 1);
        insert testProgramTask;

        Test.startTest();
        Program_Assignment__c testProgramAssignment = new Program_Assignment__c(Program__c = testProgram.Id, 
                                                                                Program_Assigned_Date__c = Date.Today(), 
                                                                                Program_Assignment__c = testContact.Id);
        insert testProgramAssignment;
        Test.stopTest();

        List<Task_Assignment__c> taskAssignments = [SELECT Id 
                                                    FROM Task_Assignment__c 
                                                    WHERE Program__c = :testProgram.Id AND Task_Assigned_To_Contact__c = :testContact.Id];
        System.assertEquals(1, taskAssignments.size());
    }

    @isTest
    static void testCreateTaskUponProgramAssignment_givenProgramWithTwoProgramTasks_twoTaskAssignmentCreated() {
        
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;

        Contact testContact = new Contact(FirstName = 'Test', LastName = 'Contact', AccountId = testAccount.Id);
        insert testContact;

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

        Program_Task__c testProgramTask2 = new Program_Task__c( Program__c = testProgram.Id, 
                                                                 Training_Task__c = testTrainingTask2.Id, 
                                                                  Day_in_Program_Due__c = 1);
        insert testProgramTask;
        insert testProgramTask2;

        Test.startTest();
        Program_Assignment__c testProgramAssignment = new Program_Assignment__c(Program__c = testProgram.Id, 
                                                                                Program_Assigned_Date__c = Date.Today(), 
                                                                                Program_Assignment__c = testContact.Id);
        insert testProgramAssignment;
        Test.stopTest();

        List<Task_Assignment__c> taskAssignments = [SELECT Id 
                                                    FROM Task_Assignment__c 
                                                    WHERE Program__c = :testProgram.Id AND Task_Assigned_To_Contact__c = :testContact.Id];
        System.assertEquals(2, taskAssignments.size());
    }

    @isTest
    static void testCreateTaskUpon2ProgramAssignments_givenProgramWithTwoProgramTasks_fourTaskAssignmentCreated() {
        
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

        Program_Task__c testProgramTask2 = new Program_Task__c( Program__c = testProgram.Id, 
                                                                 Training_Task__c = testTrainingTask2.Id, 
                                                                  Day_in_Program_Due__c = 1);
        insert testProgramTask;
        insert testProgramTask2;

        Test.startTest();
        Program_Assignment__c testProgramAssignment = new Program_Assignment__c(Program__c = testProgram.Id, 
                                                                                Program_Assigned_Date__c = Date.Today(), 
                                                                                Program_Assignment__c = testContact.Id);
        insert testProgramAssignment;
        Program_Assignment__c testProgramAssignment2 = new Program_Assignment__c(Program__c = testProgram.Id, 
                                                                                Program_Assigned_Date__c = Date.Today(), 
                                                                                Program_Assignment__c = testContact2.Id);
        insert testProgramAssignment2;
        Test.stopTest();

        List<Task_Assignment__c> taskAssignments = [SELECT Id 
                                                    FROM Task_Assignment__c 
                                                    WHERE Program__c = :testProgram.Id];
        System.assertEquals(4, taskAssignments.size());
    }

    @isTest
    static void testCreateTaskUponProgramAssignment_given2ProgramsWithTwoProgramTasks_twoTaskAssignmentCreated() {
        
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;

        Contact testContact = new Contact(FirstName = 'Test', LastName = 'Contact', AccountId = testAccount.Id);
        insert testContact;

        Contact testContact2 = new Contact(FirstName = 'Test2', LastName = 'Contact2', AccountId = testAccount.Id);
        insert testContact2;


        Training_Program__c testProgram = new Training_Program__c(Name = 'Test Program');
        insert testProgram;

        //second program
        Training_Program__c testProgram2 = new Training_Program__c(Name = 'Test Program 2');
        insert testProgram2;

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

        Program_Task__c testProgramTask2 = new Program_Task__c( Program__c = testProgram.Id, 
                                                                 Training_Task__c = testTrainingTask2.Id, 
                                                                  Day_in_Program_Due__c = 1);

        Program_Task__c testProgram2Task = new Program_Task__c( Program__c = testProgram2.Id, 
                                                                Training_Task__c = testTrainingTask.Id, 
                                                                 Day_in_Program_Due__c = 1);

        Program_Task__c testProgram2Task2 = new Program_Task__c( Program__c = testProgram2.Id, 
                                                                 Training_Task__c = testTrainingTask2.Id, 
                                                                  Day_in_Program_Due__c = 1);
        insert testProgramTask;
        insert testProgramTask2;
        insert testProgram2Task;
        insert testProgram2Task2;

        Test.startTest();
        Program_Assignment__c testProgramAssignment = new Program_Assignment__c(Program__c = testProgram.Id, 
                                                                                Program_Assigned_Date__c = Date.Today(), 
                                                                                Program_Assignment__c = testContact.Id);
        insert testProgramAssignment;
        Program_Assignment__c testProgramAssignment2 = new Program_Assignment__c(Program__c = testProgram.Id, 
                                                                                Program_Assigned_Date__c = Date.Today(), 
                                                                                Program_Assignment__c = testContact2.Id);
        insert testProgramAssignment2;
        Test.stopTest();

        List<Task_Assignment__c> taskAssignments = [SELECT Id 
                                                    FROM Task_Assignment__c 
                                                    WHERE Program__c = :testProgram2.Id];
        System.assertEquals(0, taskAssignments.size());
    }
}