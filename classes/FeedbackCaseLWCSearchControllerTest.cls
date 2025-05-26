@isTest
public with sharing class FeedbackCaseLWCSearchControllerTest {
    
    @testSetup
    static void makeData(){
        Case c = new Case(Status = 'New', Origin = 'Web');
        insert c;
        c.Status = 'Closed';
        update c;
    }

    @isTest
    static void testFeedbackCaseLWCrecordRetrieval(){


        Case c = [select Id, CaseNumber from Case LIMIT 1];

        Test.startTest();
        List<FeedbackCaseLWCSearchController.FeedbackWrapper> feedbackWrapperList = FeedbackCaseLWCSearchController.searchFeedbacks(c.CaseNumber);
        Test.stopTest();

        System.assertEquals(1, feedbackWrapperList.size(), 'Only 1 feedback should have been present in the list');
    }
    
    @isTest
    static void testFeedbackCaseLWCnoRecords(){
        
        String invalidCaseNumber = '912332';
        Test.startTest();
        try{
            List<FeedbackCaseLWCSearchController.FeedbackWrapper> feedbackWrapperList = FeedbackCaseLWCSearchController.searchFeedbacks(invalidCaseNumber);
        }
        catch(AuraHandledException ex){
            System.debug(ex.getMessage());
            System.assert(!String.isBlank(ex.getMessage()), 'Not getting the expected error');
        }
        Test.stopTest();
    }
    
    @isTest
    static void testFeedbackCaseLWCnoRecordsNullCheck(){
        
        Test.startTest();
        try{
            List<FeedbackCaseLWCSearchController.FeedbackWrapper> feedbackWrapperList = FeedbackCaseLWCSearchController.searchFeedbacks(null);
        }
        catch(AuraHandledException ex){
            System.debug(ex.getMessage());
            System.assert(!String.isBlank(ex.getMessage()), 'Not getting the expected error');
        }
        Test.stopTest();
    }
    
}