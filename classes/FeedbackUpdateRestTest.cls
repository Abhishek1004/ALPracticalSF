@isTest
public with sharing class FeedbackUpdateRestTest {
    
    @TestSetup
    static void makeData(){
        Case c = new Case(Status = 'New', Origin = 'Web');
        insert c;
        c.Status = 'Closed';
        update c;
    }

    @isTest
    static void testFeedbackUpdateRestSuccessful(){

        Case c = [select Id, CaseNumber from Case LIMIT 1];
        String ratingStr = '5';
        String commentsStr = 'Good Support';

        String requestBody = JSON.serialize(new Map<String, Object>{
            'caseNumber' => c.CaseNumber,
            'rating' => ratingStr,
            'comments' => commentsStr
        });

        RestRequest req = new RestRequest();
        req.requestURI = '/services/apexrest/FeedbackUpdate/';
        req.httpMethod = 'PATCH';
        req.requestBody = Blob.valueOf(requestBody);

        RestContext.request = req;
        RestContext.response = new RestResponse();

        Test.startTest();
        String result = FeedbackUpdateRest.updateFeedback();
        Test.stopTest();

        Feedback__c fb = [select Id, Rating__c, Comments__c, Submitted__c from Feedback__c where Case__c =: c.Id LIMIT 1];
        System.assertEquals('Feedback updated successfully', result, 'Feedback did not update');
        System.assertEquals(ratingStr, fb.Rating__c, 'Feedback rating did not update');
        System.assertEquals(commentsStr, fb.Comments__c, 'Feedback comments did not update');
        System.assertEquals(true, fb.Submitted__c, 'Feedback submit field did not update');
        
    }

    @isTest
    static void testFeedbackUpdateRestCaseNotFound(){
        
        String ratingStr = '5';
        String commentsStr = 'Good Support';

        String requestBody = JSON.serialize(new Map<String, Object>{
            'caseNumber' => '00100291',
            'rating' => ratingStr,
            'comments' => commentsStr
        });

        RestRequest req = new RestRequest();
        req.requestURI = '/services/apexrest/FeedbackUpdate/';
        req.httpMethod = 'PATCH';
        req.requestBody = Blob.valueOf(requestBody);

        RestContext.request = req;
        RestContext.response = new RestResponse();

        Test.startTest();
        String result = FeedbackUpdateRest.updateFeedback();
        Test.stopTest();

        System.assertEquals('Bad request', result, 'Case should not exist');

    }

    @isTest
    static void testFeedbackUpdateRestCaseNumberBlank(){
        
        String ratingStr = '5';
        String commentsStr = 'Good Support';

        String requestBody = JSON.serialize(new Map<String, Object>{
            'caseNumber' => ' ',
            'rating' => ratingStr,
            'comments' => commentsStr
        });

        RestRequest req = new RestRequest();
        req.requestURI = '/services/apexrest/FeedbackUpdate/';
        req.httpMethod = 'PATCH';
        req.requestBody = Blob.valueOf(requestBody);

        RestContext.request = req;
        RestContext.response = new RestResponse();

        Test.startTest();
        String result = FeedbackUpdateRest.updateFeedback();
        Test.stopTest();

        System.assertEquals('Invalid Case Number', result, 'Case should not exist');

    }

    @isTest
    static void testFeedbackUpdateRestResubmittedFeedback(){

        Case c = [select Id, CaseNumber from Case LIMIT 1];
        String ratingStr = '5';
        String commentsStr = 'Good Support';

        String requestBody = JSON.serialize(new Map<String, Object>{
            'caseNumber' => c.CaseNumber,
            'rating' => ratingStr,
            'comments' => commentsStr
        });

        RestRequest req = new RestRequest();
        req.requestURI = '/services/apexrest/FeedbackUpdate/';
        req.httpMethod = 'PATCH';
        req.requestBody = Blob.valueOf(requestBody);

        RestContext.request = req;
        RestContext.response = new RestResponse();

        Test.startTest();
        String result = FeedbackUpdateRest.updateFeedback();
        String result2 = FeedbackUpdateRest.updateFeedback();
        Test.stopTest();

        
        System.assertEquals('Feedback already submitted', result2, 'Feedback should not be updated');
        
    }

}