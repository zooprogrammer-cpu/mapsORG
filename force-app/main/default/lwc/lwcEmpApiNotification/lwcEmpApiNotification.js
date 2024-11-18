import { LightningElement, api, track } from 'lwc';
import { subscribe, unsubscribe, onError, setDebugFlag, isEmpEnabled } from 'lightning/empApi';
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import currentUserId from '@salesforce/user/Id';

export default class LwcEmpApiNotification extends LightningElement {
    @track message = "";
    @track toastMessage;
    @api recordId;
    channelName = "/event/empApiEvent__e";
    isSubscribeDisabled = false;
    isUnsubscribeDisabled = !this.isSubscribeDisabled;
    subscription = {};

    // Tracks changes to channelName text field
    handleChannelName(event) {
        this.channelName = event.target.value;
    }

    // Initializes the component
    connectedCallback() {
        const self = this;
        const toastCallback = function (response){
            console.log('response data:', JSON.parse(JSON.stringify(response)));
            console.log('message received: ', response.data.payload.message__c);
            self.message = response.data.payload.message__c;
            console.log('self.message: ', self.message);
            if (self.message){
                self.showToast("Success",self.message,"success")
            }
        }


        // Register error listener
        this.registerErrorListener();

        // Invoke subscribe method of empApi. Pass reference to messageCallback
        subscribe(this.channelName, -1, toastCallback).then((response) => {
            // Response contains the subscription information on subscribe call
            console.log(
                'Subscription request sent to: ',
                JSON.stringify(response.channel)
            );
            this.subscription = response;
        });
        onError(error => {
            console.log('Error in Platform Event Toast');
            console.log(error);
        });
    }

    registerErrorListener() {
        // Invoke onError empApi method
        onError((error) => {
            console.log('Received error from server: ', JSON.stringify(error));
            // Error contains the server-side error
        });
    }

    toastHandler(){
        this.showToast("Success",this.message,"success")
    }

    showToast(title,message,variant){
        const evt = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant
        })
        this.dispatchEvent(evt)
    }

    disconnectedCallback() {
        unsubscribe(this.subscription, response => {
            console.log('Un-Subscribed from Platform Event Toast');
            console.log(response);
        });
    }

}