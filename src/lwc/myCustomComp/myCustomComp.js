import { LightningElement,api } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
export default class MyCustomComp extends NavigationMixin(LightningElement) {
        @api accountRating;
        @api accountIndustry;
        @api accountName;
        @api accountId;
        checked;

        openPop() {
            this[NavigationMixin.Navigate]({
                type: 'standard__recordPage',
                attributes: {
                    recordId: this.accountId,
                    actionName: 'view',
                },
            });
        }
        showData(event){
            if( this.accountIndustry != null || this.accountRating!=null){
            this.checked = true;
            }
        }
        hideData(event){
            this.checked = false;
        }
}