/**
 * Created by Synebo on 04.10.2021.
 */

@IsTest
public with sharing class UpdateContactsTest {
    @IsTest
    private static void updateContactsAndCasesTest(){
        Contact contact = new Contact(LastName = 'Test');
        insert contact;

        List<Case> cases = new List<Case>();
        for(Integer i =0; i<5;i++){
            cases.add(new Case(ContactId = contact.Id, Status = 'Closed'));
            cases.add(new Case(ContactId = contact.Id , Status = 'New'));
        }
        insert cases;

        List<Case> selectCases = [SELECT Id,IsClosed FROM Case];
        Set<Id> ids = new Set<Id>();
        for(Case case_i : selectCases){
            ids.add(case_i.Id);
        }


        UpdateContacts updateContacts = new UpdateContacts();
        updateContacts.updateContactsAndCases(ids);
        Contact contact2 = [SELECT Id,Count_Closed_Case__c,Count_Open_Case__c FROM Contact WHERE Id =: contact.Id];
        System.assertEquals(5, contact2.Count_Open_Case__c);
        System.assertEquals(5, contact2.Count_Closed_Case__c);
    }
}