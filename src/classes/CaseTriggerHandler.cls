/**
 * Created by Synebo on 14.09.2021.
 */

public with sharing class CaseTriggerHandler extends TriggerHandler {

    public override void afterUpdate() {
        this.countCaseUpdate((List<Case>) Trigger.new, (Map<Id, Case>) Trigger.oldMap);
    }

    public override void afterInsert() {
        this.countCaseUpdate((List<Case>) Trigger.new, null);
    }

    public override void afterUndelete() {
        this.countCaseUpdate((List<Case>) Trigger.new, null);
    }
    public override void afterDelete() {
        this.countCaseUpdate(null, (Map<Id, Case>) Trigger.oldMap);
    }

    private void countCaseUpdate(List<Case> newList, Map<Id, Case>oldMap) {
        Map<Id, Case> mapOld = new Map<Id, Case>();
        List<Case> listCases = new List<Case>();
        Set<Id> caseWithStatus = new Set<Id>();

        if (newList != null) {
            listCases = newList;
            mapOld = oldMap;
        } else {
            mapOld = null;
            listCases = oldMap.values();
        }

        for (Case case_i : listCases) {
            if (mapOld == null || ((case_i.IsClosed != mapOld.get(case_i.Id).IsClosed ||
                    case_i.ContactId != mapOld.get(case_i.Id).ContactId))) {
                if (case_i.ContactId != null) {
                    caseWithStatus.add(case_i.ContactId);
                } if (mapOld != null && mapOld.get(case_i.Id).ContactId != null && case_i.ContactId != mapOld.get(case_i.Id).ContactId) {
                    caseWithStatus.add(mapOld.get(case_i.Id).ContactId);
                }
            }
        }

//        if (newList != null && oldMap != null) {
//            for (Case case_i : newList) {
//                if (case_i.IsClosed != oldMap.get(case_i.Id).IsClosed ||
//                        case_i.ContactId != oldMap.get(case_i.Id).ContactId) {
//                    if (case_i.Status != null && case_i.ContactId != null) {
//                        caseWithStatus.put(case_i.ContactId, case_i.Status);
//                    } if (case_i.Status != null && oldMap.get(case_i.Id).ContactId != null) {
//                        caseWithStatus.put(oldMap.get(case_i.Id).ContactId, oldMap.get(case_i.Id).Status);
//                    }
//                }
//            }
//        } else if (oldMap == null && newList != null) {
//            for (Case case_i : newList) {
//                if (case_i.ContactId != null) {
//                    caseWithStatus.put(case_i.ContactId, case_i.Status);
//                }
//            }
//        } else if (oldMap != null && newList == null) {
//            for (Case case_i : oldMap.values()) {
//                if (case_i.ContactId != null) {
//                    caseWithStatus.put(case_i.ContactId, case_i.Status);
//                }
//            }
//        }


        UpdateContacts updtContacts = new UpdateContacts();
        updtContacts.updateContactsAndCases(caseWithStatus);
    }

}