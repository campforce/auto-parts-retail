/**
 * @author Dastan
 * @date 2022-08-23
 *
 * @description Component to show the report on Contact object with related car parts
 */
import { LightningElement, api, track, wire } from 'lwc';

import getCarQuantity from '@salesforce/apex/LwcReportForMastersController.getCarQuantity';
import getRelatedCarParts from '@salesforce/apex/LwcReportForMastersController.getRelatedCarParts';

const COLUMNS = [
    {label: 'Car', fieldName: 'carUrl', type: 'url', typeAttributes: { label: {fieldName: 'carName'}}},
    {label: 'Car Part', fieldName: 'carPartUrl', type: 'url', typeAttributes: { label: {fieldName: 'carPartName'}}}, 
    {label: 'Price', fieldName: 'price', type: 'currency'},
]

export default class LwcReportForMasters extends LightningElement {
    @api recordId;

    columns = COLUMNS;
    @track error;
    carPartList;
    carQuantity;
    
    @wire(getCarQuantity,{recordId: '$recordId'})
    cars({error,data}) {
        if(data){
            console.log('data '+data);
            this.carQuantity = data;
        } else if (error) {
            console.log('error '+error.body.message);
            this.error = error;
        }
    }

    @wire(getRelatedCarParts,{recordId: '$recordId'})
    carParts({error,data}) {
        if(data){
            console.log('data car parts'+data);
            this.carPartList = data;
        } else if (error) {
            console.log('error '+error);
        }
    }
}