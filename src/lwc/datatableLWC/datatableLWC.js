import { LightningElement,api,track} from 'lwc';
import getContacts from '@salesforce/apex/DatatableController.getContacts';

export default class DatatableLwc extends LightningElement {
@api recordId;
@track data=[];
 columns = [
        { label: 'Contact', fieldName: 'contactName', type: 'text' },
        { label: 'Phone', fieldName: 'contactPhone',  type: 'phone'},
        { label: 'Title', fieldName: 'contactTitle',  type: 'text'},
        { label: 'Account', type: 'accountInfo', fieldName: 'accountName',
        typeAttributes:
        {
            accountId: { fieldName: 'accountId'},
            accountName: { fieldName: 'accountName'},
            accountIndustry: { fieldName: 'accountIndustry'},
            accountRating: { fieldName: 'accountRating'},

                }
        }

    ];

    connectedCallback(){
        getContacts({accountId: this.recordId}). then(response => {
            this.data=response;
            }).catch(e => {
                console.log(e);
                });
    }




    //Handler for custom column interations - like handle what to do when toggle button is pressed
//    handleSelectedRec(event){
//        console.log(event.detail.value);
//        //Write your logic to handle button interations
//    }
}