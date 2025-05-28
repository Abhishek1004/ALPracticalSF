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

        Case c = [SELECT Id, Status FROM Case LIMIT 1];
        Feedback__c fb = [SELECT Id, Submitted__c, Submitted_Date__c FROM Feedback__c WHERE Case__c =: c.Id LIMIT 1];

        Test.startTest();
        fb.Submitted__c = true;
        update fb;
        Test.stopTest();
		
        Feedback__c fbUpdated = [SELECT Id, Submitted_Date__c FROM Feedback__c LIMIT 1];
        Assert.areEqual(Date.today(), fbUpdated.Submitted_Date__c, 'Submitted Date should equal to today');
    
    }
}