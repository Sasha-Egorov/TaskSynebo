/**
 * Created by Synebo on 12.10.2021.
 */
@IsTest
public with sharing class ShareAccountControllerTest {

    @IsTest private static void createAccountShareTest() {
        Profile profileForTest = [SELECT Id FROM Profile LIMIT 1];
        User userForTest = new User(
                Username = 'john12@acme1.com',
                LastName = 'Testing',
                Email = 'ASD@ukr.net',
                Alias = 'tt',
                TimeZoneSidKey = 'Europe/Dublin',
                LocaleSidKey = 'en_IE_EURO',
                EmailEncodingKey = 'UTF-8',
                ProfileId = profileForTest.Id,
                LanguageLocaleKey = 'en_US'
        );
        insert userForTest;
        Account accountForTest = new Account(Name = 'Test');
        insert accountForTest;
        ShareAccountController.createAccountShare(accountForTest.Id, userForTest.Id);
        List<AccountShare> accountSharesList = [
                SELECT Id, AccountId, UserOrGroupId
                FROM AccountShare
                WHERE AccountId = :accountForTest.Id AND UserOrGroupId = :userForTest.Id
        ];
        System.assertEquals(1, accountSharesList.size());

    }
}

