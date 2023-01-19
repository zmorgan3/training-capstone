import { LightningElement, api } from 'lwc';
import {refreshApex} from '@salesforce/apex';


export default class MassUnassignProgramsTable extends LightningElement {

    @api programAssignees;
    selectedProgramAssignees = [];

    disableButton=true;

    columns = [
        {label: 'Employee', fieldName: 'Contact_Name__c'},
        {label: 'Program Status', fieldName: 'Status__c'}
    ];

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

    handleDeletedProgramAssignments(){
        let detail = {
            programAssignees: this.selectedProgramAssignees
        };

        const deleteSelectedProgramAssigneesEvent = new CustomEvent('deleteselectedprogramassignees', {detail: detail});

        this.dispatchEvent(deleteSelectedProgramAssigneesEvent);
    }

}