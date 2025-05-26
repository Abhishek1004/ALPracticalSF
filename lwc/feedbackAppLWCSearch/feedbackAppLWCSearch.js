import { LightningElement, track } from 'lwc';
import searchFeedbacks from '@salesforce/apex/FeedbackCaseLWCSearchController.searchFeedbacks';

export default class FeedbackAppLWCSearch extends LightningElement {
    @track data = [];
    @track error;
    @track sortedBy = 'caseNumber';
    @track sortDirection = 'asc';

    columns = [
        {label: '#', fieldName: 'rowNumber', type: 'number', initialWidth: 50},
        {label: 'Feedback Number', fieldName: 'feedbackUrl', type: 'url', typeAttributes: {label: {fieldName: 'feedbackNumber'}, target: '_blank'}, sortable: false},
        {label: 'Case Number', fieldName: 'caseNumber', type: 'text', sortable: true},
        {label: 'Rating', fieldName:'rating', type: 'text', sortable: true},
        {label: 'Comments', fieldName:'comments', type: 'text'},
        {label: 'Submitted Date', fieldName:'submittedDate', type: 'date', sortable: true}
    ];


    handleSearch(){
        const inputCS = this.template.querySelector('.case-number-input');
        const caseNumber = inputCS ? inputCS.value.trim() : '';

        if(!caseNumber){
            this.error = 'Enter Case Number';
            this.data = [];
            return;
        }

        this.error = undefined;
        searchFeedbacks({caseNumber: caseNumber})
        .then(result => {
            this.data = result.map((record, index) => ({...record, rowNumber: index + 1, feedbackNumber: record.name, feedbackUrl: '/' + record.Id}));
            this.error = undefined;
            console.log('DATA  ', this.data);
            console.log(this.columns);
        })
        .catch(error => {
            this.error = error.body ? error.body.message : 'Unknown error';
        });

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