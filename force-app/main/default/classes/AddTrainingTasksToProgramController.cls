public with sharing class AddTrainingTasksToProgramController {


    @AuraEnabled(cacheable=true)
    public static List<Training_Task__c> getTrainingTasks(Id programId/*Integer offset*/){

        List<Program_Task__c> PTList = new List<Program_Task__c>([SELECT Training_Task__r.Id
                                                FROM Program_Task__c
                                                WHERE Program__c =: programId
        ]);
        
        List<Id> idList = new List <Id>();
        for(Program_Task__c programTask : PTList){
            idList.add(programTask.Training_Task__r.Id);
        }

        List <Training_Task__c> trainingTasksList = new List <Training_Task__c> ([
                                                                                SELECT Name, Id, Days_Needed_to_Complete__c
                                                                                FROM Training_Task__c
                                                                                WHERE Id NOT IN  :idList
                                                                                ORDER BY Name
                                                                                /*LIMIT :limitSize*/
                                                                                /*OFFSET :offset*/]);
       
        return trainingTasksList;
    }

    @AuraEnabled
    public static List<Training_Task__c> getSelectedTrainingTasks(List<Id> selectedTrainingTasks){
        System.debug(selectedTrainingTasks);
        List <Training_Task__c> trainingTasksList = new List <Training_Task__c> ([
                                                                                SELECT Name, Id, Days_Needed_to_Complete__c
                                                                                FROM Training_Task__c
                                                                                WHERE Id IN  :selectedTrainingTasks
                                                                                ORDER BY Name
                                                                                /*LIMIT :limitSize*/
                                                                                /*OFFSET :offset*/]);
        System.debug(trainingTasksList);
       
        return trainingTasksList;
    }

    @AuraEnabled
    public static List<Id> getProgramTaskIds(Id programId){
        try {
                List<Program_Task__c> PTList = new List<Program_Task__c>([SELECT Training_Task__r.Id
                                                                            FROM Program_Task__c
                                                                            WHERE Program__c =: programId
                                                                            ]);

                List<Id> idList = new List <Id>();
                for(Program_Task__c programTask : PTList){
                    idList.add(programTask.Training_Task__r.Id);
                }

                return idList;

        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled(cacheable=true)
    public static List<Program_Task__c> getCurrentProgramTasks(Id programId){

        List <Program_Task__c> programTasksList = new List <Program_Task__c> ([
                                                                                SELECT Name, Id, Training_Task__c, Day_in_Program_Due__c
                                                                                FROM Program_Task__c
                                                                                WHERE Program__c =:programId
                                                                                ORDER BY Name
                                                                                /*LIMIT :limitSize
                                                                                OFFSET :offset*/]);
       
        return programTasksList;
    }


    @AuraEnabled
    public static void addTrainingTasksAsProgramTasks(List<Training_Task__c> trainingTasks, Id programId, Map<Id, Integer> inputMap){

        try{
            List <Program_Task__c> programTasksList = new List<Program_Task__c>();
            Integer daysNeeded;
            Decimal dueDate;
            System.debug(inputMap);
            for(Training_Task__c trainingTask: trainingTasks){
                //for(day: inputMap)
                    Program_Task__c PT = new Program_Task__c();
                    PT.Program__c = programId;
                    PT.Training_Task__c = trainingTask.Id;
                    PT.Day_in_Program_Due__c = Integer.ValueOf(inputMap.get(trainingTask.Id));
                    programTasksList.add(PT);
            }
            System.debug(programTasksList);
            insert programTasksList;

        }
        catch(exception e){
            throw new AuraHandledException('Not Added');
        }
    }

    @AuraEnabled(cacheable=true)
    public static List<Program_Assignment__c> getProgramAssignees(Id programId){
        try {
            List<Program_Assignment__c> programAssigneesList = new List<Program_Assignment__c>([SELECT Name, Id, Program_Assignment__c, Status__c, Contact_Name__c, Program_Due_Date__c
                                                                                                FROM Program_Assignment__c
                                                                                                WHERE Program__c =: programId AND Status__c != 'Completed'
                                                                                                ]);
            System.debug(programAssigneesList);
            return programAssigneesList;
            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static void addTaskAssignments(List<Program_Assignment__c> programAssigneesList, List<Training_Task__c> trainingTasks, Id programId){
        try {
            System.debug('Querying program assignees');
            System.debug(programAssigneesList);
            
            List<Task_Assignment__c> TAList = new List<Task_Assignment__c>();

            for(Training_Task__c trainingTask: trainingTasks){
                for(Program_Assignment__c programAssignee: programAssigneesList){
                    Task_Assignment__c TA = new Task_Assignment__c();
                    TA.Program__c = programId;
                    TA.Training_Task__c = trainingTask.Id;
                    TA.Task_Assigned_To_Contact__c =  programAssignee.Program_Assignment__c;
                    TAList.add(TA);
                }
            
            }
            System.debug(TAList);
            insert TAList;

            
        } catch (Exception e) {
            throw new AuraHandledException('function failed' + e.getMessage());
        }
    }

    @AuraEnabled(cacheable=true)
    public static List<Training_Task__c> searchTrainingTasks(String searchTerm, Id programId) {

        searchTerm = '%'+searchTerm+'%';

        List<Id> idList = new List<Id>();
        idList= getProgramTaskIds(programId);

        System.debug(searchTerm);
        System.debug(idList);

        return [SELECT Id, Name, Days_Needed_to_Complete__c
                 FROM Training_Task__c 
                 WHERE Name LIKE :searchTerm AND Id NOT IN :idList ORDER BY Name];
    }


    //TriggerFunction
    public static void createTaskAssignmentUponNewProgramTask(List<Program_Task__c> insertedProgramTasks){
        try{
            List<Task_Assignment__c> taskAssignmentList = new List<Task_Assignment__c>();
            Id programId = insertedProgramTasks[0].Program__c;
            Date today = System.today();
        
            List <Program_Assignment__c> programAssignmentsList = [SELECT Id, Name, Contact_Name__c, Status__c   
                                                                FROM Program_Assignment__c
                                                                WHERE Program__c =: programId AND Status__c != 'Completed'];
                                                                                                        
            for(Program_Assignment__c programAssignment : programAssignmentsList){
                for(Program_Task__c programTask : insertedProgramTasks){

                    Task_Assignment__c TA = new Task_Assignment__c();
                    TA.Program__c = programId;
                    TA.Training_Task__c = programTask.Training_Task__c;
                    
                    TA.Task_Assigned_To_Contact__c =  programAssignment.Contact_Name__c;
                    TA.Status__c = 'Incomplete';
                    taskAssignmentList.add(TA);
                }         
            }

                insert taskAssignmentList;    

        }

        catch(exception e){
            throw new AuraHandledException(e.getMessage() + 'HELLO');
        }
        
    }
}
