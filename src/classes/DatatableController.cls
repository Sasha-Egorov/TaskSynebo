/**
 * Created by Synebo on 13.10.2021.
 */

public with sharing class DatatableController {

    @AuraEnabled(Cacheable=true)
    public static List<Wrapper> getContacts(String accountId) {
        List<Contact> contactsList = new List<Contact>();
        List<Wrapper> wrappers = new List<Wrapper>();
        String query = 'SELECT Id, Name, Phone, Title,AccountId, Account.Name, Account.Industry, Account.Rating FROM Contact';
        if(accountId != null) {
            query += ' WHERE AccountId = :accountId';
        }
        contactsList = Database.query(query);
        for(Contact contact_i : contactsList){
            Wrapper wrapper = new Wrapper();
            wrapper.contactName=contact_i.Name;
            wrapper.contactPhone=contact_i.Phone;
            wrapper.contactTitle=contact_i.Title;
            wrapper.accountId=contact_i.AccountId;
            wrapper.accountName=contact_i.Account.Name;
            wrapper.accountIndustry=contact_i.Account.Industry;
            wrapper.accountRating=contact_i.Account.Rating;
            wrappers.add(wrapper);
        }
        return wrappers;
    }
    public class Wrapper{
        @AuraEnabled
        public String contactName{get;set;}
        @AuraEnabled
        public String contactPhone{get;set;}
        @AuraEnabled
        public String contactTitle{get;set;}
         @AuraEnabled
        public String accountId{get;set;}
         @AuraEnabled
        public String accountName{get;set;}
         @AuraEnabled
        public String accountIndustry{get;set;}
         @AuraEnabled
        public String accountRating{get;set;}

        public Wrapper(){
        }
    }
}