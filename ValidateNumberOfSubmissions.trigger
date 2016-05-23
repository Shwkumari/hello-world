//trigger to limit restrict the number of submissions per contact.
trigger ValidateNumberOfSubmissions on Submission__c (before insert) {
    if(Trigger.isInsert){
        ValidateNumberOfSubmissionsClass.checklimit(Trigger.new);
    }    
}