import { LightningElement, track } from 'lwc';
import searchFeedbacks from '@salesforce/apex/FeedbackCaseSearchController.searchFeedbacks';

export default class FeedbackSearch extends LightningElement {

    @track data = [];
    error;
    sortedBy = 'caseNumber';
    sortDirection = 'asc';

    columns = [
        {label: 'Feedback Number', fieldName: 'feedbackUrl', type: 'url', typeAttributes: {label: {fieldName: 'feedbackNumber'}, target: '_blank'}, sortable: false},
        {label: 'Case Number', fieldName: 'caseNumber', type: 'text', sortable: false},
        {label: 'Rating', fieldName:'rating', type: 'text', sortable: true},
        {label: 'Comments', fieldName:'comments', type: 'text'},
        {label: 'Submitted Date', fieldName:'submittedDate', type: 'date', sortable: true}
    ];


    async handleSearch(){
        const inputCS = this.template.querySelector('.case-number-input');
        const caseNumber = inputCS ? inputCS.value.trim() : '';

        if(!caseNumber){
            this.error = 'Enter Case Number';
            this.data = [];
            return;
        }

        this.error = undefined;
        try{
            const result = await searchFeedbacks({caseNumber: caseNumber});
            this.data = result.map((record) => ({...record, feedbackNumber: record.feedbackName, feedbackUrl: '/' + record.feedbackId}));
            this.error = undefined;
        }
        catch(error){
            this.error = error.body ? error.body.message : 'Unknown error';
        }
    }

    handleSort(event){

        const sortedBy = event.detail.fieldName;
        const sortDirection = this.sortDirection === 'asc' ? 'desc' : 'asc' ;
        const sortedData = [...this.data].sort((a,b) => {
            const valueA = a[sortedBy];
            const valueB = b[sortedBy];
            
            if(valueA == valueB){
                return 0;
            }
            if(typeof valueA === 'string'){
                return sortDirection === 'asc' ? valueA.localeCompare(valueB) : valueB.localeCompare(valueA);
            }
            return sortDirection === 'asc' ? valueA - valueB : valueB - valueA;
        });

        this.data = sortedData;
        this.sortedBy = sortedBy;
        this.sortDirection = sortDirection;
    }
    
    get showTable(){
        return Array.isArray(this.data) && this.data.length > 0 && Array.isArray(this.columns) && this.columns.length > 0;
    }
}