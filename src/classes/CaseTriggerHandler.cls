/**
 * Created by Synebo on 14.09.2021.
 */

public with sharing class CaseTriggerHandler extends TriggerHandler {

    public override void afterUpdate() {
        this.countCaseUpdate((List<Case>) Trigger.new, (Map<Id, Case>) Trigger.oldMap);
    }

    public override void afterInsert() {
        this.countCaseInsert((List<Case>) Trigger.new);
    }

    public override void afterUndelete() {
        this.countCaseInsert((List<Case>) Trigger.new);
    }
    public override void afterDelete() {
        this.countCaseDelete((Map<Id, Case>) Trigger.oldMap);
    }

    private void countCaseDelete(Map<Id, Case>oldMap){
        Map<Id, String> caseWithStatus = new Map<Id, String>();
        if (!oldMap.isEmpty()) {
            for (Case case_i : oldMap.values()) {
                if (case_i.Status != null && case_i.ContactId != null) {
                    caseWithStatus.put(case_i.ContactId, case_i.Status);
                }
            }
        }
        List<Contact> contacts = [
                SELECT Id,Count_Closed_Case__c, Count_Open_Case__c
                FROM Contact
                WHERE Id = :caseWithStatus.keySet()
        ];
        updateCases(caseWithStatus, contacts);
    }

    private void countCaseInsert(List<Case> newList) {
        Map<Id, String> caseWithStatus = new Map<Id, String>();
        if (!newList.isEmpty()) {
            for (Case case_i : newList) {
                if (case_i.Status != null && case_i.ContactId != null) {
                    caseWithStatus.put(case_i.ContactId, case_i.Status);
                }
            }
        }
        List<Contact> contacts = [
                SELECT Id,Count_Closed_Case__c, Count_Open_Case__c
                FROM Contact
                WHERE Id = :caseWithStatus.keySet()
        ];
        updateCases(caseWithStatus, contacts);
    }
    private void countCaseUpdate(List<Case> newList, Map<Id, Case>oldMap) {
        Map<Id, String> caseWithStatus = new Map<Id, String>();
        if (!newList.isEmpty() && !oldMap.isEmpty()) {
            for (Case case_i : newList) {
                if (case_i.IsClosed && !oldMap.get(case_i.Id).IsClosed ||
                        !case_i.IsClosed && oldMap.get(case_i.Id).IsClosed ||
                        case_i.ContactId != null && oldMap.get(case_i.Id).ContactId == null ||
                        case_i.ContactId == null && oldMap.get(case_i.Id).ContactId != null) {
                    if (case_i.Status == null) {
                        continue;
                    } else if (case_i.Status != null && case_i.ContactId != null) {
                        caseWithStatus.put(case_i.ContactId, case_i.Status);
                    } else if (case_i.Status != null && oldMap.get(case_i.Id).ContactId != null) {
                        caseWithStatus.put(oldMap.get(case_i.Id).ContactId, oldMap.get(case_i.Id).Status);
                    }
                }
            }
        } else if (oldMap.isEmpty() && !newList.isEmpty()) {
            for (Case case_i : newList) {
                if (case_i.Status == null) {
                    break;
                } else if (case_i.Status != null) {
                    caseWithStatus.put(case_i.ContactId, case_i.Status);
                }
            }
        }

        List<Contact> contacts = [
                SELECT Id,Count_Closed_Case__c, Count_Open_Case__c
                FROM Contact
                WHERE Id = :caseWithStatus.keySet()
        ];
        updateCases(caseWithStatus, contacts);

    }
    private void updateCases(Map<Id, String> caseWithStatus, List<Contact> contacts) {

        Map<Id, Integer> resultStatusClosed = new Map<Id, Integer>();

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
        Map<Id, Integer> resultStatusOpen = new Map<Id, Integer>();

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

        Map<Id, Contact> contactsMap = new Map<Id, Contact>();
        for (Contact contact_i : contacts) {
            contactsMap.put(contact_i.Id, contact_i);
        }
        List<Contact> updateList = new List<Contact>();
        for (Contact contact_i : contactsMap.values()) {
            contact_i.Count_Closed_Case__c = resultStatusClosed.get(contact_i.Id);
            contact_i.Count_Open_Case__c = resultStatusOpen.get(contact_i.Id);
            updateList.add(contact_i);
        }

        update updateList;

    }
}