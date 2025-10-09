trigger UserProvisioning on User (before insert) {
	String UserId, RoleId, firstname , lastname;
    for(User u : trigger.New){
        if(u.ADManager__c != '' && u.ADManager__c != null){
            Integer count=0;
            System.debug(u.ADManager__c);
            try{
                count = [SELECT COUNT() FROM User WHERE ADObjectId__c =: u.ADManager__c LIMIT 1 ];
                if(count > 0){
                   UserId = [SELECT Id FROM User WHERE ADObjectId__c =: u.ADManager__c ].Id;
                   u.ManagerId = UserId;
                }
            }
            catch(DmlException e) {
            System.debug('The following exception has occurred: ' + e.getMessage());
        	}
        }
        if(u.ADRole__c != '' && u.ADRole__c != null){
            Integer count=0;
            System.debug(u.ADRole__c);
            count = [SELECT COUNT() FROM UserRole WHERE Name =: u.ADRole__c LIMIT 1 ];
            if(count > 0){
               RoleId = [SELECT Id FROM UserRole WHERE Name =: u.ADRole__c LIMIT 1 ].Id;
               u.UserRoleId = RoleId;
            }
        }
    }
}