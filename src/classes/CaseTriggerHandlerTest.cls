/**
 * Created by Synebo on 21.09.2021.
 */
@IsTest
public with sharing class CaseTriggerHandlerTest {

    @IsTest static void caseTriggerTests() {

        UpdateContacts upd = new UpdateContacts();
        Set<Id> setId = new Set<Id>();
        upd.updateContactsAndCases(setId);

        Contact contact = new Contact(LastName = 'Test');
        insert contact;

        List<Case> cases = new List<Case>();
        for (Integer i = 0; i < 10; i++) {
            cases.add(new Case(Status = 'New', ContactId = contact.Id));
        }
        for (Integer i = 0; i < 10; i++) {
            cases.add(new Case(Status = 'Closed', ContactId = contact.Id));
        }
        insert cases;

        Contact result = [
                SELECT Id, Count_Open_Case__c,Count_Closed_Case__c
                FROM Contact
                WHERE Id = :contact.Id
        ];
        System.assertEquals(10, result.Count_Open_Case__c);
        System.assertEquals(10, result.Count_Closed_Case__c);

        List<Case> caseUpdate = [
                SELECT Id, Status
                FROM Case
                WHERE Status = 'New'
                LIMIT 5
        ];
        for (Case case_i : caseUpdate) {
            case_i.Status = 'Closed';
        }
        update caseUpdate;

        result = [
                SELECT Id, Count_Open_Case__c,Count_Closed_Case__c
                FROM Contact
                WHERE Id = :contact.Id
        ];
        System.assertEquals(5, result.Count_Open_Case__c);
        System.assertEquals(15, result.Count_Closed_Case__c);

        Contact contact2 = new Contact(LastName = 'Test2');
        insert contact2;

        List<Case> caseChangeContact = [
                SELECT Id, Status
                FROM Case
                WHERE Status = 'Closed'
                LIMIT 5
        ];
        for (Case case_i : caseChangeContact) {
            case_i.ContactId = contact2.Id;
        }
        update caseChangeContact;
        result = [
                SELECT Id, Count_Open_Case__c,Count_Closed_Case__c
                FROM Contact
                WHERE Id = :contact.Id
        ];
        Contact result2 = [
                SELECT Id, Count_Open_Case__c,Count_Closed_Case__c
                FROM Contact
                WHERE Id = :contact2.Id
        ];

        System.assertEquals(5, result.Count_Open_Case__c);
        System.assertEquals(10, result.Count_Closed_Case__c);
        System.assertEquals(5, result2.Count_Closed_Case__c);

        List<Case> casesForDelete = [
                SELECT Id, Status
                FROM Case
                WHERE Status = 'Closed' AND ContactId = :contact.Id
                LIMIT 5
        ];
        delete casesForDelete;

        result = [
                SELECT Id, Count_Open_Case__c,Count_Closed_Case__c
                FROM Contact
                WHERE Id = :contact.Id
        ];

        System.assertEquals(5, result.Count_Closed_Case__c);

        undelete casesForDelete;

        result = [
                SELECT Id, Count_Open_Case__c,Count_Closed_Case__c
                FROM Contact
                WHERE Id = :contact.Id
        ];

        System.assertEquals(10, result.Count_Closed_Case__c);

    }

}