public with sharing class massUnassignProgramsController {
    public massUnassignProgramsController() {

    }

    @AuraEnabled(cacheable=true)
    public static List<Program_Assignment__c> getProgramAssignees(Id programId){
        try {

            List<Program_Assignment__c> currentAssignees = new List<Program_Assignment__c>([SELECT Name, Program_Assignment__c, Program__c, Contact_Name__c, Status__c
                                                                                            FROM Program_Assignment__c
                                                                                            WHERE Program__c =: programId AND Status__c != 'Completed']);
            return currentAssignees;
            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static void deleteProgramAssignments(List<Program_Assignment__c> selectedProgramAssignments, Id programId){
        try {

            delete selectedProgramAssignments;

        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

}
