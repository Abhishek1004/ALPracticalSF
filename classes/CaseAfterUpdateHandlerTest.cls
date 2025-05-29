@IsTest
private class CaseAfterUpdateHandlerTest {
    
    @TestSetup
    private static void makeData(){
        Case c = new Case(Status = 'New', Origin = 'Web');
        insert c;
    
    }

    @IsTest
    private static void testCaseFeedbackCreationPositive(){
        Case c = [SELECT Id, Status FROM Case LIMIT 1];
        c.Status = 'Closed';
        
        Test.startTest();
        update c;
        Test.stopTest();

        List<Feedback__c> feedbackList = [SELECT Id FROM Feedback__c WHERE Case__c =: c.Id];
        Assert.areEqual(1, feedbackList.size(), 'Case updated to Closed but Feedback not created');
    }

    @IsTest
    private static void testCaseFeedbackCreationNegative(){

        Case c = [SELECT Id, Status FROM Case LIMIT 1];
        c.Status = 'Working';


        Test.startTest();
        update c;
        Test.stopTest();

        List<Feedback__c> feedbackList = [SELECT Id FROM Feedback__c WHERE Case__c =: c.Id];
        Assert.areEqual(0, feedbackList.size(), 'Feedback should not be created for this case status');

    }
}