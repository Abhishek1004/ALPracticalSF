/*
*   This class contains the functionality when HTTP request is sent by an external system to update a particular Feedback record.
*   The class is annotated with @RestResource to expose this class as Rest API.
*   @author Abhisek Prusty
*/

@RestResource(urlMapping='/v1/FeedbackUpdate/*')
global with sharing class FeedbackUpdateRest {
    
    /*
    This method contains the functionality of updating a Feedback request when a PATCH request is received.
    @param String requestBody - JSON request body containing the Case Number, Rating and Comments.
    @return String - Response message.
    */
    @HttpPatch
    global static String updateFeedback() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;

        FeedbackWrapper feedbackData = (FeedbackWrapper)JSON.deserialize(req.requestBody.toString(), FeedbackWrapper.class);

        if(String.isBlank(feedbackData.caseNumber)){
            res.statusCode = 400;
            return 'Invalid Case Number';
        }

        Savepoint sp = Database.setSavepoint();

        try{
            Feedback__c feedbackObj = [SELECT Id, Rating__c, Comments__c, Submitted__c FROM Feedback__c WHERE Case__r.CaseNumber =: feedbackData.caseNumber ORDER BY CreatedDate DESC LIMIT 1];
            if(feedbackObj.Submitted__c){
                res.statusCode = 400;
                return 'Feedback already submitted';
            }
            
            feedbackObj.Rating__c = feedbackData.rating;
            feedbackObj.Comments__c = feedbackData.comments;
            feedbackObj.Submitted__c = true;

            update feedbackObj;
        }
        
        catch(Exception e){

            Database.rollback(sp);
            
            res.statusCode = 500;
            return 'Bad request';
        }

        return 'Feedback updated successfully';
    }

}