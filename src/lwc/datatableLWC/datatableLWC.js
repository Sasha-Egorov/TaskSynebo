import { LightningElement,api,track} from 'lwc';
import getContacts from '@salesforce/apex/DatatableController.getContacts';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class DatatableLwc extends LightningElement {
@api recordId;
@track data=[];
 columns = [
        { label: 'Contact', fieldName: 'contactName', type: 'text' },
        { label: 'Phone', fieldName: 'contactPhone',  type: 'phone'},
        { label: 'Title', fieldName: 'contactTitle',  type: 'text'},
        { label: 'Account', fieldName: 'accountName',  type: 'text'},
        { label: 'Account', type: 'accountInfo', fieldName: 'accountName',
        typeAttributes:
        {
            accountId: { fieldName: 'accountId'},
            accountIndustry: { fieldName: 'accountIndustry'},
            accountRating: { fieldName: 'accountRating'},
                }
        }

    ];

    connectedCallback(){

        getContacts({accountId: this.recordId}). then(response => {
            this.data=response;
            }).catch(e => {
                const event = new ShowToastEvent({
                            title: 'Get Help',
                            message: e
                        });
                        this.dispatchEvent(event);
                });
    }

}