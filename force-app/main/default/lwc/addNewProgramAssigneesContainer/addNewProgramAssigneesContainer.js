import { LightningElement, api, wire, track } from 'lwc'
0
import getProgramAssignees from '@salesforce/apex/addNewProgramAssigneesController.getProgramAssignees'
import addProgramAssignments from '@salesforce/apex/addNewProgramAssigneesController.addProgramAssignments'
//import getProgramAssignees from '@salesforce/apex/addTrainingTasksToProgramController.getProgramAssignees'


export default class AddNewProgramAssigneesContainer extends LightningElement {

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

    handleAddedProgramAssignments(event){
        let programAssignmentsToAdd = event.detail.programAssignees;

        addProgramAssignments({contacts: programAssignmentsToAdd, programId: this.recordId})
            .then(response => {
                console.log('successfully added Program Assignments')
                this.showNotification('Success', "Program Assignments have been successfully added");
                this.closeQuickAction();  
            })
            .catch(error =>{
                console.warn('this is broken' + error);
            });

    }

}