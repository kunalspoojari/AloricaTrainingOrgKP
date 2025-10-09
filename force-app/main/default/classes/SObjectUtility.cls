/**
* This class contains generic helper methods to assist with RecordTypes, Collections, and 
* comparing old field values to new field values, etc.
* Created : 02/25/19
* @author CJ Fabiano
*/
public class SObjectUtility  {
	
	//this method returns record type informations for the given object api
    public static List<Schema.RecordTypeInfo> getRecordTypeInfoForObject(String objectApi) {
        return Schema.getGlobalDescribe().get(objectApi).getDescribe().getRecordTypeInfos();
    }

    //this method returns picklist information for the given picklist api of the given object api
    public static List<Schema.PicklistEntry> getPicklistInfoForObject(String picklistApi, String objectApi) {
        return Schema.getGlobalDescribe().get(objectApi).getDescribe().fields.getMap().get(picklistApi).getDescribe().getPicklistValues();
    }

    //this method returns a set of the given id fields from the given list of objects
    public static Set<Id> getIdsFromList(String idField, List<sObject> objectList) {

        Set<Id> idSet = new Set<Id>();
        //add id field value to set
        for (sObject obj : objectList) {
            idSet.add((Id)obj.get(idField));
        }

        return idSet;
    }

    //this method returns a map of the objects provided using the id field given as a key
    public static Map<Id, List<sObject>> createMapWithIdKeyFromList(String idField, List<sObject> objectList) {

        Map<Id, List<sObject>> objectMap = new Map<Id, List<sObject>>();
        for (sObject obj : objectList) {

            Id key = (Id)obj.get(idField);
            //if key is in map, add value to mapping
            if (objectMap.containsKey(key)) {
                objectMap.get(key).add(obj);
            }
            //add new mapping
            else {
                objectMap.put(key, new List<sObject>{obj});
            }
        }

        return objectMap;
    }

    //this method returns a map of the objects provided using the string field given as a key
    public static Map<String, List<sObject>> createMapWithStringKeyFromList(String stringField, List<sObject> objectList) {

        Map<String, List<sObject>> objectMap = new Map<String, List<sObject>>();
        for (sObject obj : objectList) {

            String key = (String)obj.get(stringField);
            //if key is in map, add value to mapping
            if (objectMap.containsKey(key)) {
                objectMap.get(key).add(obj);
            }
            //add new mapping
            else {
                objectMap.put(key, new List<sObject>{obj});
            }
        }

        return objectMap;
    }

    //this method returns objects where any of the given fields have changed
    public static List<sObject> getRecordsWhereFieldsChanged(
        List<sObject> newObjectList, Map<Id, sObject> oldObjectMap, List<String> fieldList) {

        List<sObject> objectsToReturn = new List<sObject>();
        for (sObject newObj : newObjectList) {

            //get old object from map based on id
            sObject oldObj = oldObjectMap.get(newObj.Id);
            //loop thru fields and see if values are different between old an new
            for (String field : fieldList) {

                if (newObj.get(field) != oldObj.get(field)) {
                    objectsToReturn.add(newObj);
                    break;
                }
            }
        }

        return objectsToReturn;
    }
}