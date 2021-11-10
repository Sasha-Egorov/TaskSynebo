/**
 * Created by Synebo on 04.11.2021.
 */
@IsTest
public with sharing class DatatableControllerTest {
    @IsTest
    static void getContactTest() {
        //given
        Account account = new Account(Name = 'TestAccount');
        insert account;
        List<Contact> contacts = new List<Contact>();
        for (Integer i = 0; i < 10; i++) {
            contacts.add(new Contact(LastName = 'Test' + i, AccountId = account.Id));
        }
        insert contacts;

        //when
        List<DatatableController.Wrapper> wrappers = new List<DatatableController.Wrapper>();
        wrappers = DatatableController.getContacts(account.Id);

        //then
        System.assertEquals(10,wrappers.size());
    }

}