/**
 * Created by Synebo on 20.09.2021.
 */

public without sharing class UpdateContacts {
    public void updateContactsAndCases(Map<Id, String> caseWithStatus) {

        if (caseWithStatus.isEmpty()) {
            return;
        }
        List<Contact> contacts = [
                SELECT Id,Count_Closed_Case__c, Count_Open_Case__c
                FROM Contact
                WHERE Id = :caseWithStatus.keySet()
        ];


        Map<Id, Integer> resultStatusClosed = new Map<Id, Integer>();
        if (!caseWithStatus.isEmpty()) {
            List<AggregateResult> aggregateResultsClosedCases = [
                    SELECT ContactId, COUNT(Id) countStatus
                    FROM Case
                    WHERE Status = 'Closed' AND ContactId = :caseWithStatus.keySet()
                    GROUP BY ContactId
            ];

            for (AggregateResult aggregateResult_i : aggregateResultsClosedCases) {
                Id ContactsId = (Id) aggregateResult_i.get('ContactId');
                Integer CountStatusClosed = (Integer) aggregateResult_i.get('countStatus');
                resultStatusClosed.put(ContactsId, CountStatusClosed);
            }
        }
        Map<Id, Integer> resultStatusOpen = new Map<Id, Integer>();
        if (!caseWithStatus.isEmpty()) {
            List<AggregateResult> aggregateResultsOpenCases = [
                    SELECT ContactId, COUNT(Id) countStatus
                    FROM Case
                    WHERE Status != 'Closed' AND ContactId = :caseWithStatus.keySet()
                    GROUP BY ContactId
            ];

            for (AggregateResult aggregateResult_i : aggregateResultsOpenCases) {
                Id ContactsId = (Id) aggregateResult_i.get('ContactId');
                Integer CountStatusClosed = (Integer) aggregateResult_i.get('countStatus');
                resultStatusOpen.put(ContactsId, CountStatusClosed);
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