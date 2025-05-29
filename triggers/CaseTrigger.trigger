trigger CaseTrigger on Case (after update) {
    if(Trigger.isAfter){
        if(Trigger.isUpdate){
            CaseAfterUpdateHandler.caseAfterUpdateHandlerMethod(Trigger.new, Trigger.old, Trigger.newMap, Trigger.oldMap);
        }
    }
}