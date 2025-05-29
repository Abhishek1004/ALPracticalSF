public with sharing class CaseAfterUpdateHandler {
    public static void caseAfterUpdateHandlerMethod(List<Case> newList, List<Case> oldList, Map<Id, Case> newMap, Map<Id, Case> oldMap) {
        List<Feedback__c> newFeedbacktoInsert = new List<Feedback__c>();

        for(Case c: newList){
            if(c.Status == 'Closed' && oldMap.get(c.Id).Status != 'Closed'){
                Feedback__c fb = new Feedback__c(
                    Case__c = c.Id,
                    OwnerId = c.OwnerId
                );
                newFeedbacktoInsert.add(fb);
            }
        }

        if(!newFeedbacktoInsert.isEmpty()){
            Database.insert(newFeedbacktoInsert, false);
        }
    }
}