import { LightningElement, api, track, wire } from 'lwc'
import { CloseActionScreenEvent } from 'lightning/actions';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import getProgramAssignees from '@salesforce/apex/massUnassignProgramsController.getProgramAssignees'
import deleteProgramAssignments from '@salesforce/apex/massUnassignProgramsController.deleteProgramAssignments'
export default class MassUnnassignPrograms extends LightningElement {

    @api recordId;
    @track programAssignees;
    wiredProgramAssigneesResponse;

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

    @wire(getProgramAssignees, {programId: '$recordId'})
    wiredProgramAssignees(value){
        this.wiredProgramAssigneesResponse=value;


        if(value.data){
            this.programAssignees = value.data;
            console.log(value);
        }
        if(value.error){
            console.warn(value.error);
        }
    }

    handleDeletedProgramAssignments(event){

        let programAssignmentsToDelete = event.detail.programAssignees;

        deleteProgramAssignments({selectedProgramAssignments: programAssignmentsToDelete, programId: this.recordId})
            .then(response => {
                this.showNotification('Success', "Program Assignments have been successfully deleted");
                this.closeQuickAction();

            })
            .catch(error=>{
                console.warn('this is broken' + error)
            });
    }

}