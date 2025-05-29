public with sharing class FeedbackBeforeUpdateHandler {
    public static void feedbackBeforeUpdateHandlerMethod(List<Feedback__c> newList, List<Feedback__c> oldList, Map<Id, Feedback__c> newMap, Map<Id, Feedback__c> oldMap){
        for(Feedback__c fb: newList){
            if(fb.Submitted__c && !oldMap.get(fb.Id).Submitted__c && fb.Submitted_Date__c == null){
                fb.Submitted_Date__c = Date.today();
            }
        }
    }
}