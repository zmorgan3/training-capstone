import { LightningElement, api, wire, track } from 'lwc'
import {refreshApex} from '@salesforce/apex'
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import { CloseActionScreenEvent } from 'lightning/actions';
import getTrainingTasks from '@salesforce/apex/AddTrainingTasksToProgramController.getTrainingTasks'
import getProgramAssignees from '@salesforce/apex/addTrainingTasksToProgramController.getProgramAssignees'
import addTaskAssignments from '@salesforce/apex/AddTrainingTasksToProgramController.addTaskAssignments'
import addTrainingTasksAsProgramTasks from '@salesforce/apex/AddTrainingTasksToProgramController.addTrainingTasksAsProgramTasks';
import getCurrentProgramTasks from '@salesforce/apex/AddTrainingTasksToProgramController.getCurrentProgramTasks'

export default class AddTrainingTasksToProgramContainer extends LightningElement {

    @api recordId;
    @track trainingTasks;
    @track currentProgramTasks
    @track programAssignees;
    taskAssignments;
    wiredTrainingTaskResponse;
    wiredProgramAssigneesResponse;
    wiredCurrentProgramTaskResponse;

    totalNumberOfRows=100;
    rowLimit=10;
    rowOffset=0;

    loadMoreStatus;
    targetDatatable;

    showNotification(title, message, variant) {
        this.dispatchEvent(new ShowToastEvent({
            title: title,
            message: message,
            variant: variant || 'success'
        }));   
    }

    closeQuickAction() {
        this.dispatchEvent(new CloseActionScreenEvent());
    }


    @wire(getCurrentProgramTasks, {programId: '$recordId'/*, limitSize: this.rowLimit, offset: this.rowOffset*/}) 
    wiredCurrentProgramTasks(value){
        this.wiredCurrentProgramTaskResponse=value;
        console.log(value);

        if(value.data){
            this.currentProgramTasks = value.data;
        }

        if(value.error){ 
            console.warn(value.error);
        }
    }
    
    @wire(getTrainingTasks, {programId: '$recordId'}) 
    wiredTrainingTasks(value){
        this.wiredTrainingTaskResponse = value;
        console.log(value);

        if(value.data){
            this.trainingTasks = value.data;
            
        }

        if(value.error){ 
            console.warn(value.error);
        }
    }


    handleAddedTrainingTasks(event){
        let trainingTasksToAdd = event.detail.trainingTasksToAdd;
        let daysToAdd = event.detail.daysToAdd;
        console.log(daysToAdd);

        addTrainingTasksAsProgramTasks({trainingTasks: trainingTasksToAdd, programId: this.recordId, inputMap: daysToAdd})
            .then(response => {
                console.log('tasks successfully added');
            })
            .catch(error =>{
                console.warn('ERROR HERE' + error);
            });

        if(this.programAssignees == 0)
        {
            this.closeQuickAction();
            this.showNotification('Success', "Tasks have been successfully added");
        }

    }

    @wire(getProgramAssignees, {programId: '$recordId'})
    wiredProgramAssignees(value){
        this.wiredProgramAssigneesResponse=value;
        console.log(value);

        if(value.data){
            this.programAssignees = value.data;

        }
        if(value.error){
            console.warn(value.error);
        }
    }
    

    handleAddedTrainingTaskAssignments(event){
        let trainingTasksToAdd = event.detail.trainingTasksToAdd;
        let programAssignees = event.detail.programAssignees;

        
        addTaskAssignments({programAssigneesList: programAssignees, trainingTasks: trainingTasksToAdd, programId: this.recordId})
            .then(response => {
                console.log('task assignments successfully added');
                this.showNotification('Success', "Tasks have been successfully added");
                this.closeQuickAction();
            })
            .catch(error =>{
                console.warn('this is broken' + error);
            });

    }

}