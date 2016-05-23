@isTest
public class Test_ValidateNumberOfSubmissions {    
    @testSetup //method to create portal user.
    static  void createData()
    {
        User u = [select id from user where profile.name = 'System Administrator' limit 1];
        UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
        Profile profile1 = [Select Id from Profile where name = 'System Administrator'];
 		User uAdmin = AbstractLab_TestDataHandlerUtility.getUserRec();
        uAdmin.UserRoleId = portalRole.Id;
        uAdmin.ProfileId = profile1.Id;
        uAdmin.Username = 'Shweta@kumari.com';
        System.runAs(u){                       
            insert uAdmin;            
        } 
        contact con = AbstractLab_TestDataHandlerUtility.getContactRec();
        contact con1 = AbstractLab_TestDataHandlerUtility.getContactRec();
        
        List<contact> conList = new List<contact>();
        List<User> userList = new List<User>();
        System.runAs(uAdmin){
            Account acc = new Account(); 
            acc.Name = 'Test Account';
            insert acc;
            con.AccountId = acc.id;
            conList.add(con);
            con1.AccountId = acc.id;
            conList.add(con1);
            Insert conList;
            Profile portalProfile = [SELECT Id FROM Profile where Name =: 'High Volume Customer Portal User' Limit 1];
            User uPortal = AbstractLab_TestDataHandlerUtility.getUserRec();
            uPortal.ProfileId = portalProfile.id;
            uPortal.ContactId = con.id;
            uPortal.CommunityNickname = 'test12345';
            uPortal.Username = 'Shweta1@test1.com';
            userList.add(uPortal);
            
            User uPortal1 = AbstractLab_TestDataHandlerUtility.getUserRec();
            uPortal1.ProfileId = portalProfile.id;
            uPortal1.ContactId = con1.id;
            uPortal1.CommunityNickname = 'test123456';
            uPortal1.Username = 'Shweta12@test1.com';
            userList.add(uPortal1);
            insert userList;
        }
        
    }
    //positive testing 
    static testMethod void testSubmissionPositive(){
         
        list<Submission__c> subList = new list<Submission__c>();
		User uPortal = [Select id,ContactId from User where Username =: 'Shweta1@test1.com'];
                
        Abstract_Call__c AC = AbstractLab_TestDataHandlerUtility.getAbstractCallRec();
        insert AC;
        
        Call_Topic__c CtRec = AbstractLab_TestDataHandlerUtility.getCallTopicRec();
        CtRec.Abstract_Call__c = AC.Id;
        insert CtRec;
       
        Submission__c sub1 = AbstractLab_TestDataHandlerUtility.getSubmissionRec();
        sub1.Call_Type__c = CtRec.Id;
        sub1.Contact__c=uPortal.ContactId;
        subList.add(sub1);
        
        
        Submission__c sub2 = AbstractLab_TestDataHandlerUtility.getSubmissionRec();
        sub2.Call_Type__c = CtRec.Id;
        sub2.Contact__c=uPortal.ContactId;
        subList.add(sub2);
         
        insert subList;
        test.startTest();
        system.runAs(uPortal){
            Submission__c sub3 = AbstractLab_TestDataHandlerUtility.getSubmissionRec();
            sub3.Call_Type__c = CtRec.Id;
            sub3.Contact__c=uPortal.ContactId;
            try{
                insert sub3;    
            }
            catch(Exception ex){
                system.debug(ex);
                Boolean expectedExceptionThrown =  ex.getMessage().contains('Number of submission can not be  greater than max number of Submission defined in related Abstract Call') ? true : false;
				System.AssertEquals(expectedExceptionThrown, true);                
            }
        }
        test.stopTest();
    } 
    //negative testing
    static testMethod void testSubmissionNegative(){
         
        list<Submission__c> subList = new list<Submission__c>();
		User uPortal = [Select id,ContactId from User where Username =: 'Shweta1@test1.com'];
        User uPortal1 = [Select id,ContactId from User where Username =: 'Shweta12@test1.com'];        
        Abstract_Call__c AC = AbstractLab_TestDataHandlerUtility.getAbstractCallRec();
        insert AC;
        
        Call_Topic__c CtRec = AbstractLab_TestDataHandlerUtility.getCallTopicRec();
        CtRec.Abstract_Call__c = AC.Id;
        insert CtRec;
       
        Submission__c sub1 = AbstractLab_TestDataHandlerUtility.getSubmissionRec();
        sub1.Call_Type__c = CtRec.Id;
        sub1.Contact__c=uPortal.ContactId;
        subList.add(sub1);
        
        
        Submission__c sub2 = AbstractLab_TestDataHandlerUtility.getSubmissionRec();
        sub2.Call_Type__c = CtRec.Id;
        sub2.Contact__c=uPortal.ContactId;
        subList.add(sub2);
         
        insert subList;
        test.startTest();
        system.runAs(uPortal1){
            Submission__c sub3 = AbstractLab_TestDataHandlerUtility.getSubmissionRec();
            sub3.Call_Type__c = CtRec.Id;
            try{
                insert sub3;    
            }
            catch(Exception ex){
                              
            }
            system.assertNotEquals(sub3.id, null);
        }
        test.stopTest();
    } 
	//bulk testing
    static testMethod void testSubmissionBulk(){
         
        list<Submission__c> subList = new list<Submission__c>();
		User uPortal = [Select id,ContactId from User where Username =: 'Shweta1@test1.com'];
                
        Abstract_Call__c AC = AbstractLab_TestDataHandlerUtility.getAbstractCallRec();
        insert AC;
        
        Call_Topic__c CtRec = AbstractLab_TestDataHandlerUtility.getCallTopicRec();
        CtRec.Abstract_Call__c = AC.Id;
        insert CtRec;
       
        Submission__c sub1 = AbstractLab_TestDataHandlerUtility.getSubmissionRec();
        sub1.Call_Type__c = CtRec.Id;
        sub1.Contact__c=uPortal.ContactId;
        subList.add(sub1);
        
        
        Submission__c sub2 = AbstractLab_TestDataHandlerUtility.getSubmissionRec();
        sub2.Call_Type__c = CtRec.Id;
        sub2.Contact__c=uPortal.ContactId;
        subList.add(sub2);
         
        insert subList;
        list<Submission__c> subList1 = new list<Submission__c>();
        test.startTest();
        system.runAs(uPortal){
            for(integer i=1 ; i<=5 ;i++){
                Submission__c sub = AbstractLab_TestDataHandlerUtility.getSubmissionRec();
                sub.Call_Type__c = CtRec.Id;
                subList1.add(sub);
            }
            try{
                insert subList1;    
            }
            catch(Exception ex){
                system.debug(ex);
                Boolean expectedExceptionThrown =  ex.getMessage().contains('Number of submission can not be  greater than max number of Submission defined in related Abstract Call') ? true : false;
				System.AssertEquals(expectedExceptionThrown, true);                
            }
        }
        test.stopTest();
    } 
}