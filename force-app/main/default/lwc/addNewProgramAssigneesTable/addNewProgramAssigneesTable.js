import { LightningElement, api } from 'lwc';
import { CloseActionScreenEvent } from 'lightning/actions';

export default class AddNewProgramAssigneesTable extends LightningElement {

    @api programAssignees;
    selectedProgramAssignees = [];
    disableButton = true;

    columns = [
        {label: 'Employee', fieldName: 'Name'}, 
        {label: 'Number of Programs Currently Enrolled in', fieldName:'Number_of_Programs_Currently_Enrolled_In__c'}
    ];

    closeQuickAction() {
        this.dispatchEvent(new CloseActionScreenEvent());
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
        this.selectedProgramAssignees = selectedRows;
    }

    addSelectedProgramAssignees(){
        let detail = {
            programAssignees: this.selectedProgramAssignees
        };

        const addSelectedProgramAssigneesEvent = new CustomEvent('addselectedprogramassignees', {detail: detail});

        this.dispatchEvent(addSelectedProgramAssigneesEvent);
        A.get("e.force:closeQuickAction").fire();
    }
    
}