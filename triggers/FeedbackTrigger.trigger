trigger FeedbackTrigger on Feedback__c (before update) {
    if(Trigger.isBefore){
        if(Trigger.isUpdate){
            FeedbackBeforeUpdateHandler.feedbackBeforeUpdateHandlerMethod(Trigger.new, Trigger.old, Trigger.newMap, Trigger.oldMap);
        }
    }
}