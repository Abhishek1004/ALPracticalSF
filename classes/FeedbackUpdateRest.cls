@RestResource(urlMapping='/FeedbackUpdate/*')
global with sharing class FeedbackUpdateRest {
    
    @HttpPatch
    global static String updateFeedback() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;

        FeedbackWrapper feedbackData = (FeedbackWrapper)JSON.deserialize(req.requestBody.toString(), FeedbackWrapper.class);

        if(String.isBlank(feedbackData.caseNumber)){
            res.statusCode = 400;
            return 'Invalid Case Number';
        }

        try{
            Feedback__c feedbackObj = [Select Id, Rating__c, Comments__c, Submitted__c from Feedback__c where Case__r.CaseNumber =: feedbackData.caseNumber ORDER BY CreatedDate DESC LIMIT 1];
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
            res.statusCode = 500;
            return 'Bad request';
        }

        return 'Feedback updated successfully';
    }

    global class FeedbackWrapper{
        public String caseNumber;
        public String rating;
        public String comments;
    }
}