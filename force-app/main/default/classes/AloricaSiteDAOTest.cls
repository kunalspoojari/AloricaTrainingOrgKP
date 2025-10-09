/*
*   @Author: Ariel Tribunal
*   @Date: 10/2/2019
*   @Apex Name: AloricaSiteDAOTest
*   @Description: This test class is use for AloricaSiteDAO coverage
*
*/
@isTest
private class AloricaSiteDAOTest {
    private static testMethod void testcontroller() {
        TestDataFactory.loadReferenceData();
        
        Map<String, Site__c> siteMap = AloricaSiteDAO.getSitesMapByName(new List<String>{'Cutler Bay'});
        System.assertEquals(1, siteMap.size());
        
        Id siteId = [SELECT Id, Name from Site__c where Name = 'Cutler Bay' limit 1].Id;
        Set<Id> lsiteId = new Set<Id>();
        lsiteId.add(siteId);
        Map<Id, Site__c> siteMapId = AloricaSiteDAO.getSitesMapByIds(lsiteId);
        
    }
}