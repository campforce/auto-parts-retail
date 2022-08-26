/**
 * @author Dastan
 * @date 2022-08-25
 *
 * @description Component for Cuurency Converter calculator
 */
import { LightningElement, track } from 'lwc';

import convertAmount from '@salesforce/apex/CurrencyConverterIntegration.convertAmount';

export default class LwcCurrencyConverter extends LightningElement {
    sourceCurrency = 'USD';
    targetCurrency = 'AED';
    amount = '';
    todayDate;
    @track convertedAmount;


    get options() {
    return [
        { label: 'US Dollar', value: 'USD' },
        { label: 'Dirham', value: 'AED' },
        { label: 'Euro', value: 'EUR' }
        ];
    }

    handleSourceChange(event) {
        this.sourceCurrency = event.detail.value;
    }

    handleTargetChange(event) {
        this.targetCurrency = event.detail.value;
    }

    handleAmountChange(event) {
        this.amount = event.detail.value;
    }
  
    connectedCallback(){
        let today = new Date();
        var dd = String(today.getDate()).padStart(2, '0');
        var mm = String(today.getMonth() + 1).padStart(2, '0'); //January is 0!
        var yyyy = today.getFullYear();

        this.todayDate = yyyy + '-' + mm + '-' + dd;

    }
    handleConvert() {
        convertAmount({sourceCurrency:this.sourceCurrency, targetCurrency:this.targetCurrency, amount: this.amount, dateExc: this.todayDate})
        .then(result => {
            this.convertedAmount = result;
        });
    }

}