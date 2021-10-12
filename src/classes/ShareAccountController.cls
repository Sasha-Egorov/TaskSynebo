/**
 * Created by Synebo on 12.10.2021.
 */

public with sharing class ShareAccountController {
    @AuraEnabled
    public static void createAccountShare(Id recordId, Id userOrGroupId) {
        AccountShare Acctshr = new AccountShare();
        Acctshr.AccountId = recordId;
        Acctshr.UserOrGroupId = userOrGroupId;
        Acctshr.AccountAccessLevel = 'Edit';
        Acctshr.OpportunityAccessLevel = 'Edit';
        insert Acctshr;
    }
}