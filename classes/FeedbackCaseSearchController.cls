/*
*   This class is the controller that handles the logic for the LWC component Feedback Case Search.
*   It contains the methods that are called from the LWC component. 
*   @author - Abhisek Prusty
*/ 

public with sharing class FeedbackCaseSearchController {
    
    /*
    * @param caseNumber - The Case Number of the Feedback record to be searched.
    * @return - List of FeedbackWrapper (a wrapper class created for easier access of data by LWC) objects. 
                They contain all the feedback records related to the case.
    *
    */
    @AuraEnabled(cacheable = true)
    public static List<FeedbackWrapper> searchFeedbacks(String caseNumber){
        try {
            List<Feedback__c> feedbackList = new List<Feedback__c>();
            feedbackList = [SELECT Id, Name, Case__r.CaseNumber, Rating__c, Comments__c, Submitted_Date__c FROM Feedback__c WHERE Case__r.CaseNumber =: caseNumber ORDER BY LastModifiedDate DESC];

            if(feedbackList.isEmpty()){
                throw new AuraHandledException('No Record Found..');
            }

            List<FeedbackWrapper> feedbackWrapperList = new List<FeedbackWrapper>();
            for(Feedback__c feedbackRec : feedbackList){

                FeedbackWrapper fbWTemp = new FeedbackWrapper(feedbackRec.Case__r.CaseNumber,
                                                            feedbackRec.Rating__c,
                                                            feedbackRec.Comments__c,
                                                            feedbackRec.Submitted_Date__c,
                                                            feedbackRec.Name,
                                                            feedbackRec.Id);

                feedbackWrapperList.add(fbWTemp);

            }
            return feedbackWrapperList;

        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

}