/**
 * Created by Synebo on 14.09.2021.
 */

trigger CaseTrigger on Case (after insert, after update, after delete, after undelete) {

    CaseTriggerHandler projectTrigger = new CaseTriggerHandler();
    projectTrigger.run();
}