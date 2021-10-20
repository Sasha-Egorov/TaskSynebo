/**
 * Created by Synebo on 12.10.2021.
 */

public with sharing class ShareAccountController {
    @AuraEnabled
    public static void createAccountShare(Id recordId, Id userOrGroupId) {
        List<AccountShare> checkForAvailability = [
                SELECT Id, AccountId,UserOrGroupId
                FROM AccountShare
                WHERE AccountId = :recordId
                AND UserOrGroupId = :userOrGroupId
        ];
        if (checkForAvailability.isEmpty()) {
            AccountShare Acctshr = new AccountShare();
            Acctshr.AccountId = recordId;
            Acctshr.UserOrGroupId = userOrGroupId;
            Acctshr.AccountAccessLevel = 'Edit';
            Acctshr.OpportunityAccessLevel = 'Edit';
            insert Acctshr;
        }
    }
}