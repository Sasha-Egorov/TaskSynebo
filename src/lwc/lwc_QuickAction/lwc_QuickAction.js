
import { LightningElement,api } from 'lwc';
import { CloseActionScreenEvent } from 'lightning/actions';
import createAccountShare from '@salesforce/apex/ShareAccountController.createAccountShare';

export default class LwcQuickAction extends LightningElement {
@api recordId;
userOrGroupId;

    handleChange(event){
        this.userOrGroupId = event.target.value;
    }

    closeAction(){
        this.dispatchEvent(new CloseActionScreenEvent());
    }
    Save(){
        console.log(this.recordId);
        console.log(this.userOrGroupId);
        createAccountShare({recordId: this.recordId , userOrGroupId: this.userOrGroupId}).
        then(response => {
            console.log(response);
            }).catch(e => {
                console.log(e);
                });
        this.dispatchEvent(new CloseActionScreenEvent());
    }
}
