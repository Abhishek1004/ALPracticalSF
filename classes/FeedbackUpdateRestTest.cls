@IsTest
private with sharing class FeedbackUpdateRestTest {
    
    @TestSetup
    private static void makeData(){
        Case c = new Case(Status = 'New', Origin = 'Web');
        insert c;
        c.Status = 'Closed';
        update c;
    }

    @IsTest
    private static void testFeedbackUpdateRestSuccessful(){

        Case c = [SELECT Id, CaseNumber FROM Case LIMIT 1];
        String ratingStr = '5';
        String commentsStr = 'Good Support';

        String requestBody = JSON.serialize(new Map<String, Object>{
            'caseNumber' => c.CaseNumber,
            'rating' => ratingStr,
            'comments' => commentsStr
        });

        RestRequest req = new RestRequest();
        req.requestURI = '/services/apexrest/v1/FeedbackUpdate/';
        req.httpMethod = 'PATCH';
        req.requestBody = Blob.valueOf(requestBody);

        RestContext.request = req;
        RestContext.response = new RestResponse();

        Test.startTest();
        String result = FeedbackUpdateRest.updateFeedback();
        Test.stopTest();

        Feedback__c fb = [SELECT Id, Rating__c, Comments__c, Submitted__c FROM Feedback__c WHERE Case__c =: c.Id LIMIT 1];
        Assert.areEqual('Feedback updated successfully', result, 'Feedback did not update');
        Assert.areEqual(ratingStr, fb.Rating__c, 'Feedback rating did not update');
        Assert.areEqual(commentsStr, fb.Comments__c, 'Feedback comments did not update');
        Assert.areEqual(true, fb.Submitted__c, 'Feedback submit field did not update');
        
    }

    @IsTest
    private static void testFeedbackUpdateRestCaseNotFound(){
        
        String ratingStr = '5';
        String commentsStr = 'Good Support';

        String requestBody = JSON.serialize(new Map<String, Object>{
            'caseNumber' => '00100291',
            'rating' => ratingStr,
            'comments' => commentsStr
        });

        RestRequest req = new RestRequest();
        req.requestURI = '/services/apexrest/v1/FeedbackUpdate/';
        req.httpMethod = 'PATCH';
        req.requestBody = Blob.valueOf(requestBody);

        RestContext.request = req;
        RestContext.response = new RestResponse();

        Test.startTest();
        String result = FeedbackUpdateRest.updateFeedback();
        Test.stopTest();

        Assert.areEqual('Bad request', result, 'Case should not exist');

    }

    @IsTest
    private static void testFeedbackUpdateRestCaseNumberBlank(){
        
        String ratingStr = '5';
        String commentsStr = 'Good Support';

        String requestBody = JSON.serialize(new Map<String, Object>{
            'caseNumber' => ' ',
            'rating' => ratingStr,
            'comments' => commentsStr
        });

        RestRequest req = new RestRequest();
        req.requestURI = '/services/apexrest/v1/FeedbackUpdate/';
        req.httpMethod = 'PATCH';
        req.requestBody = Blob.valueOf(requestBody);

        RestContext.request = req;
        RestContext.response = new RestResponse();

        Test.startTest();
        String result = FeedbackUpdateRest.updateFeedback();
        Test.stopTest();

        Assert.areEqual('Invalid Case Number', result, 'Case should not exist');

    }

    @IsTest
    private static void testFeedbackUpdateRestResubmittedFeedback(){

        Case c = [SELECT Id, CaseNumber FROM Case LIMIT 1];
        String ratingStr = '5';
        String commentsStr = 'Good Support';

        String requestBody = JSON.serialize(new Map<String, Object>{
            'caseNumber' => c.CaseNumber,
            'rating' => ratingStr,
            'comments' => commentsStr
        });

        RestRequest req = new RestRequest();
        req.requestURI = '/services/apexrest/v1/FeedbackUpdate/';
        req.httpMethod = 'PATCH';
        req.requestBody = Blob.valueOf(requestBody);

        RestContext.request = req;
        RestContext.response = new RestResponse();

        Test.startTest();
        String result = FeedbackUpdateRest.updateFeedback();
        String result2 = FeedbackUpdateRest.updateFeedback();
        Test.stopTest();

        
        Assert.areEqual('Feedback already submitted', result2, 'Feedback should not be updated');
        
    }

}