@isTest
public with sharing class FeedbackBeforeUpdateHandlerTest {
    
    @TestSetup
    static void makeData(){
        
        Case c = new Case(Origin = 'Web', Status = 'New');
        insert c;
        c.Status = 'Closed';
        update c;
    }

    @isTest
    static void testFeedbackSubmission(){

        Case c = [select Id, Status from Case limit 1];
        Feedback__c fb = [select Id, Submitted__c, Submitted_Date__c from Feedback__c where Case__c =: c.Id limit 1];

        Test.startTest();
        fb.Submitted__c = true;
        update fb;
        Test.stopTest();
		
        Feedback__c fbUpdated = [select Id, Submitted_Date__c from Feedback__c LIMIT 1];
        System.assertEquals(Date.today(), fbUpdated.Submitted_Date__c, 'Submitted Date should equal to today');
    
    }
}