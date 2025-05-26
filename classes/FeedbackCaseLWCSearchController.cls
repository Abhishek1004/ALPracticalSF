public with sharing class FeedbackCaseLWCSearchController {
    
    @AuraEnabled(cacheable = true)
    public static List<FeedbackWrapper> searchFeedbacks(String caseNumber){
        try {
            List<Feedback__c> feedbackList = new List<Feedback__c>();
            feedbackList = [select Id, Name, Case__r.CaseNumber, Rating__c, Comments__c, Submitted_Date__c from Feedback__c where Case__r.CaseNumber =: caseNumber ORDER BY LastModifiedDate DESC];

            if(feedbackList.isEmpty()){
                throw new AuraHandledException('No Record Found..');
            }

            List<FeedbackWrapper> feedbackWrapperList = new List<FeedbackWrapper>();
            for(Feedback__c feedbackRec : feedbackList){

                FeedbackWrapper fbWTemp = new FeedbackWrapper();
                fbWTemp.caseNumber = feedbackRec.Case__r.CaseNumber;
                fbWTemp.rating = feedbackRec.Rating__c;
                fbWTemp.comments = feedbackRec.Comments__c;
                fbWTemp.submittedDate = feedbackRec.Submitted_Date__c;
                fbWTemp.name = feedbackRec.Name;
                fbWTemp.Id = feedbackRec.Id;

                feedbackWrapperList.add(fbWTemp);

            }
            return feedbackWrapperList;

        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    public class FeedbackWrapper{
        @AuraEnabled public String caseNumber;
        @AuraEnabled public String rating;
        @AuraEnabled public String comments;
        @AuraEnabled public Date submittedDate;
        @AuraEnabled public String name;
        @AuraEnabled public String Id;
    }
}