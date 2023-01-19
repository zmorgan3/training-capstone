import { LightningElement, api, wire, track} from 'lwc'
import { CloseActionScreenEvent } from 'lightning/actions';
import searchTrainingTasks from '@salesforce/apex/AddTrainingTasksToProgramController.searchTrainingTasks';
//import Training_Task__C from '@salesforce/schema/TrainingTask__c.Name';
export default class AddTrainingTasksToProgramTable extends LightningElement {

    @api trainingTasks;
    @api programAssignees;
    @api recordId;
    @api field;
    @api fieldApiName = 'Program_Task__c.Day_in_Program_Due__c';
    @track disableButton = true;
    @track dueDateNotAdded = false;
    @track data;
    @track selectedRows = [];

    wiredTrainingTaskResponse;
    wiredCurrentProgramTaskResponse;
    dueDay;
    selectedTrainingTasks = [];
    selectedTaskAssignments = [];
    inputMap={};
    page1Shown=true;
    page2Shown=false;
    page3Shown=false;
    modalShown = true;
    disableAddSelectedTaskAssignments = true;

    maxRows=5;

    columns = [
        {label: 'Training Task', fieldName: 'Name'},
        {label: 'Days Needed to Complete', fieldName: 'Days_Needed_to_Complete__c'}
    ];

    existingProgramTasksColumns = [
        {label: 'Current Tasks', fieldName: 'Name'},
        {label: 'Day in Program Due', fieldName: 'Day_in_Program_Due__c'}
    ];

    columnsProgramAssignees = [
        {label: 'Program Assignees', fieldName: 'Contact_Name__c'},
        {label: 'Program Due Date', fieldName: 'Program_Due_Date__c'}
    ]

    @track searchTerm = '';



    handleSearch(event) {
        
        this.searchTerm = event.target.value;
        this.selectedTrainingTasks = searchTrainingTasks;
        

        searchTrainingTasks({searchTerm: this.searchTerm, programId: this.recordId})
        .then(result => {
            this.trainingTasks = result;
            //this.template.querySelector('[data-id="datatable"]').selectedRows = this.selectedTrainingTasks;
        })
        .catch(error => {
            // Handle error
        });
        console.log(this.selectedRows);
    }
    
    getSelectedRows(event){
        const selectedRows = event.detail.selectedRows;
        console.log(this.disableButton);
        console.log(selectedRows);
        if(selectedRows.length > 0){
            this.disableButton = false;
        }
        else{
            this.disableButton = true;
        }
        this.selectedTrainingTasks = selectedRows;
        
    }

    showPage1(){
        this.page1Shown=true;
        this.page2Shown= false;
        this.page3Shown=false;
        this.disableButton = true;
    }

    showPage2(){
        this.page2Shown=true;
        this.page1Shown=false;
        this.page3Shown=false;
    }

    closeQuickAction() {
        this.dispatchEvent(new CloseActionScreenEvent());
    }

    showNotification(title, message, variant) {
        this.dispatchEvent(new ShowToastEvent({
            title: title,
            message: message,
            variant: variant || 'success'
        }));   
    }

    handleInput(event){
        let taskId = event.currentTarget.dataset.key;
        console.log(taskId);
        let day = event.detail.value;
        console.log(day);
        this.inputMap[taskId] = day;
        console.log(this.inputMap);

        console.log(this.selectedTrainingTasks.length + ' size of selected training tasks');
        console.log(this.inputMap.length + ' size of input map');

        
    }
    handleAddDayInProgramDueSaveClick(){
        this.field.setValue(this.fieldApiName, this.dueDay);
        this.page2Shown = false;
        this.page3Shown = true;
        
    }



    addSelectedTasks(){
        let detail = {
            trainingTasksToAdd: this.selectedTrainingTasks, 
            daysToAdd: this.inputMap
        };

        const addSelectedTasksEvent = new CustomEvent('addselectedtrainingtasks', {detail: detail});
        this.page2Shown = false;
        this.page3Shown = true;
        this.dispatchEvent(addSelectedTasksEvent);
    }

    getSelectedTaskAssignmentRows(event){
        const selectedRows = event.detail.selectedRows;
        console.log(selectedRows);
        this.selectedTaskAssignments = selectedRows;
        if(selectedRows.length > 0){
            this.disableAddSelectedTaskAssignments = false;
        }
        else{
            this.disableAddSelectedTaskAssignments = true;
        }
    }

    closePage(){
        A.get("e.force:closeQuickAction").fire();
    }

    addSelectedTaskAssignments(){
        let detail = {
            programAssignees: this.selectedTaskAssignments,
            trainingTasksToAdd: this.selectedTrainingTasks
        };

        if(this.programAssignees.length == 0)
        {
            A.get("e.force:closeQuickAction").fire();
        }

        const addSelectedTaskAssignmentsEvent = new CustomEvent('addselectedtaskassignments', {detail: detail});

        console.log(detail);
        this.dispatchEvent(addSelectedTaskAssignmentsEvent);
        console.log('closing event');
        A.get("e.force:closeQuickAction").fire();

    }

}