//class to validate total number of submission 
public class ValidateNumberOfSubmissionsClass {
    
    public static void checklimit(List<Submission__c> subList){
        id userContactId;
        set<id> CallTopicId = new set<id>();
        Map<id,id> abstractCallId = new Map<id,id>();
        set<id> contactIdSet = new set<id>();
        Map<id,Abstract_Call__c> abstractCallMap;
        AggregateResult[] allSubmissionList;
        Map<id,integer> submissionCountmap = new Map<id,integer>();
        //get login user contact id
        userContactId = [SELECT contactId FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1].contactId;
        //userContactId = '0033600000DHA73'; 
        //get set of abstract call ids 
        for(Submission__c subRec : subList){            
            CallTopicId.add(subRec.Call_Type__c);
        }
        List<Call_Topic__c> callTopicList = [Select id,Abstract_Call__c from Call_Topic__c where id IN : CallTopicId];
        for(Call_Topic__c call : callTopicList ){
            abstractCallId.put(call.id,call.Abstract_Call__c);
        }
        //map of abstract call
        abstractCallMap = new Map<id,Abstract_Call__c>([Select id,Maximum_Number_of_Submissions__c from Abstract_Call__c where id IN: abstractCallId.values()]);
        //list of all submission realted to abstract cal and login user contact
        allSubmissionList = [Select Count(id) subCount,Call_Type__r.Abstract_Call__c abstrId from Submission__c where Call_Type__r.Abstract_Call__c IN: abstractCallId.values() and Contact__c =: userContactId  group by Call_Type__r.Abstract_Call__c]; 
        //get count of total submission
        for(AggregateResult ar : allSubmissionList){
            submissionCountmap.put(string.valueof(ar.get('abstrId')),integer.valueof(ar.get('subCount')));    
        } 
        for(Submission__c subRec : subList){
            if(abstractCallId.containskey(subRec.Call_Type__c) && abstractCallMap.containskey(abstractCallId.get(subRec.Call_Type__c)) && submissionCountmap.containsKey(abstractCallId.get(subRec.Call_Type__c))){
                if(abstractCallMap.get(abstractCallId.get(subRec.Call_Type__c)).Maximum_Number_of_Submissions__c <= submissionCountmap.get(abstractCallId.get(subRec.Call_Type__c))){
                     subRec.addError('Number of submission can not be  greater than max number of Submission defined in related Abstract Call');   
                }
            }   
        }        
    }
}