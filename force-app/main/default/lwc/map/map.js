import { LightningElement, api, wire, track } from 'lwc';
import getAccountById from '@salesforce/apex/MapController.getAccountById';
import { getRecord } from 'lightning/uiRecordApi';

export default class Map extends LightningElement {

    @api recordId;
    @track error;

    accountId;
    street;
    city;
    country;

    @wire(getRecord, { recordId: '$recordId', fields: ['Car__c.Account__c']})
    getAccountId({error, data}) {
        if (data){            
            this.accountId = data.fields.Account__c.value;   
            console.log('accountId: ' + this.accountId);                
        } else if (error) {
            this.error = error;
        }
    }

    @wire(getAccountById, { accountId : '$accountId'})
    auction({error, data}) {
        if (data){            
            this.street = data.BillingStreet;
            this.city = data.BillingCity;
            this.country = data.BillingCountry;                     
        } else if (error) {
            this.error = error;
        }
    }

    get mapMarkers() {
        return [
            {
                location: {
                    City: this.city,
                    Country: this.country,
                    Street: this.street,
                },           
                icon: 'standard:account',
            },
            {
                location: {
                    City: 'Grantville',
                    Country: 'United States',
                    Street: '8 Park Drive',
                },           
                icon: 'standard:account',
            },
        ];
    }
}