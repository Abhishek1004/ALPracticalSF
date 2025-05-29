/*
*   This class contains a wrapper class which is used while retrieval of Feedback object records for easier data access.
*   @author - Abhisek Prusty
*/
global class FeedbackWrapper{
    @AuraEnabled public String caseNumber{get; set;}
    @AuraEnabled public String rating{get; set;}
    @AuraEnabled public String comments{get; set;}
    @AuraEnabled public Date submittedDate{get; set;}
    @AuraEnabled public String feedbackId{get; set;}
    @AuraEnabled public String feedbackName{get; set;}
    
    
    global FeedbackWrapper(String caseNumber, String rating, String comments, Date submittedDate, String feedbackName, String feedbackId){
        this.caseNumber = caseNumber;
        this.rating = rating;
        this.comments = comments;
        this.submittedDate = submittedDate;
        this.feedbackId = feedbackId;
        this.feedbackName = feedbackName;
    }
}