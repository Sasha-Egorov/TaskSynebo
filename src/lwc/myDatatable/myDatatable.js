import LightningDatatable from 'lightning/datatable';
import account from './account.html';

export default class MyDatatable extends LightningDatatable {
    static customTypes={
        accountInfo:{
            template: account,
            standardCellLayout : true,
            typeAttributes:['accountIndustry', 'accountRating', 'accountId']
        }
    };
}

