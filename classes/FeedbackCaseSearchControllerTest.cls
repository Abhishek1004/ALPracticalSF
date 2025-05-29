@IsTest
public with sharing class FeedbackCaseSearchControllerTest {
    
    @testSetup
    static void makeData(){
        Case c = new Case(Status = 'New', Origin = 'Web');
        insert c;
        c.Status = 'Closed';
        update c;
    }

    @IsTest
    static void testFeedbackCaseLWCrecordRetrieval(){


        Case c = [SELECT Id, CaseNumber FROM Case LIMIT 1];

        Test.startTest();
        List<FeedbackWrapper> feedbackWrapperList = FeedbackCaseSearchController.searchFeedbacks(c.CaseNumber);
        Test.stopTest();

        Assert.areEqual(1, feedbackWrapperList.size(), 'Only 1 feedback should have been present in the list');
    }
    
    @IsTest
    static void testFeedbackCaseLWCnoRecords(){
        
        String invalidCaseNumber = '912332';
        Test.startTest();
        try{
            List<FeedbackWrapper> feedbackWrapperList = FeedbackCaseSearchController.searchFeedbacks(invalidCaseNumber);
        }
        catch(AuraHandledException ex){
            System.debug(ex.getMessage());
            Assert.isFalse(String.isBlank(ex.getMessage()), 'Not getting the expected error');
        }
        Test.stopTest();
    }
    
    @IsTest
    static void testFeedbackCaseLWCnoRecordsNullCheck(){
        
        Test.startTest();
        try{
            List<FeedbackWrapper> feedbackWrapperList = FeedbackCaseSearchController.searchFeedbacks(null);
        }
        catch(AuraHandledException ex){
            System.debug(ex.getMessage());
            Assert.isFalse(String.isBlank(ex.getMessage()), 'Not getting the expected error');
        }
        Test.stopTest();
    }
    
}