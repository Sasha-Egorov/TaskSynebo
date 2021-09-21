/**
 * Created by Synebo on 20.09.2021.
 */

public without sharing class UpdateContacts {
    public void updateContactsAndCases(Set<Id> caseWithStatus) {

        if (caseWithStatus.isEmpty()) {
            return;
        }
        List<Contact> contacts = [
                SELECT Id,Count_Closed_Case__c, Count_Open_Case__c
                FROM Contact
                WHERE Id = :caseWithStatus
        ];
        Map<Id, Integer> resultStatusClosed = new Map<Id, Integer>();
        Map<Id, Integer> resultStatusOpen = new Map<Id, Integer>();

        List<AggregateResult> aggregateResultsCases = [
                SELECT ContactId contact, IsClosed status, COUNT(Id) countStatus
                FROM Case
                WHERE ContactId = :caseWithStatus
                GROUP BY ContactId, IsClosed
        ];

        for (AggregateResult aggregateResult_i : aggregateResultsCases) {
            Id ContactsId = (Id) aggregateResult_i.get('contact');
            if ( caseWithStatus.contains(ContactsId)) {
                Boolean StatusClosed = (Boolean) aggregateResult_i.get('status');
                if (StatusClosed) {
                    Integer CountStatusClosed = (Integer) aggregateResult_i.get('countStatus');
                    resultStatusClosed.put(ContactsId, CountStatusClosed) ;
                }
                if (!StatusClosed) {
                    Integer CountStatusClosed1 = (Integer) aggregateResult_i.get('countStatus');
                    resultStatusOpen.put(ContactsId, CountStatusClosed1);
                }
            }
        }

        List<Contact> updateList = new List<Contact>();
        for (Contact contact_i : contacts) {
            contact_i.Count_Closed_Case__c = resultStatusClosed.get(contact_i.Id);
            contact_i.Count_Open_Case__c = resultStatusOpen.get(contact_i.Id);
            updateList.add(contact_i);
        }
        update updateList;
    }
}