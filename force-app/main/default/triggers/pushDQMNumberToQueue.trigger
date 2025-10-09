trigger pushDQMNumberToQueue on DQMSnapshot__c (after insert) {
    for(DQMSnapshot__c dqmSnapShot : Trigger.NEW){
        SFDC_DQM_Queue.SaveDQMNumberToQueue(dqmSnapShot.Name);
    }
}