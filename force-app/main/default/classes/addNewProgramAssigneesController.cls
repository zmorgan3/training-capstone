public with sharing class addNewProgramAssigneesController {
    public addNewProgramAssigneesController() {

    }

    @AuraEnabled(cacheable=true)
    public static List<Contact> getProgramAssignees(Id programId){
        try {

            List<Program_Assignment__c> currentAssignees = new List<Program_Assignment__c>([SELECT Name, Program_Assignment__c, Program__c 
                                                                                            FROM Program_Assignment__c
                                                                                            WHERE Program__c =: programId]);
            List<Id> idList = new List<Id>();
            for(Program_Assignment__c currentAssignee: currentAssignees){
                idList.add(currentAssignee.Program_Assignment__c);
            }
            System.debug(idList);
            List<Contact> programAssigneesList = new List<Contact>([SELECT Name, Id, Number_of_Programs_Currently_Enrolled_In__c
                                                                    FROM Contact
                                                                    WHERE Id NOT IN :idList
                                                                    ORDER BY Name]);
            return programAssigneesList;
            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static void addProgramAssignments(List<Contact> contacts, Id programId){
        try {

            System.debug('In apex funtion');
            System.debug(contacts);
            List<Program_Assignment__c> PAList = new List<Program_Assignment__c>();

            for(Contact selectedcontact: contacts){
                Program_Assignment__c PA = new Program_Assignment__c();
                PA.Program__c = programId;
                System.debug(PA);
                PA.Program_Assignment__c = selectedcontact.Id;
                PAList.add(PA);
            }

            System.debug(PAList);
            insert PAList;
            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}
