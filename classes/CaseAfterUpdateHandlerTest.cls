@isTest
public with sharing class CaseAfterUpdateHandlerTest {
    
    @TestSetup
    static void makeData(){
        Case c = new Case(Status = 'New', Origin = 'Web');
        insert c;
    
    }

    @isTest
    static void testCaseFeedbackCreation(){
        Case c = [select Id, Status from Case LIMIT 1];
        c.Status = 'Closed';
        
        Test.startTest();
        update c;
        Test.stopTest();

        List<Feedback__c> feedbackList = [select Id from Feedback__c where Case__c =: c.Id];
        System.assertEquals(1, feedbackList.size(), 'Case updated to Closed but Feedback not created');
    }
}