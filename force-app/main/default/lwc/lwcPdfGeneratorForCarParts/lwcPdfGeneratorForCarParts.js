import { LightningElement, api } from 'lwc';
import { loadScript } from 'lightning/platformResourceLoader'; 

import JSPDF from '@salesforce/resourceUrl/jspdf';

import getCarParts from '@salesforce/apex/LwcPdfGeneratorForCarPartsController.getCarParts';

export default class LwcPdfGeneratorForCarParts extends LightningElement {
    @api recordId; 
    carPartList = [];
    carName;
    headers = this.createHeaders([
        "Name",
        "Car__c",
        "Price__c",
        "Weight__c",
        "Is_Sold__c",
        "Is_Export__c"
    ]);
    renderedCallback(){
        Promise.all([loadScript(this, JSPDF)])
    }
    generatePdf(){
        const { jsPDF } = window.jspdf;
        const doc = new jsPDF();
        doc.text("CAR PARTS", 90, 20);
        doc.table(4, 30, this.carPartList, this.headers);
        doc.save(this.carName + this.recordId +".pdf");
    }
    
    generateData(){
        getCarParts({recordId: this.recordId})
        .then(result=>{
            let tempCarPartsList = [];
            result.forEach((record) =>{
                let tempCarPart = Object.assign({}, record);
                tempCarPart.Price__c = tempCarPart.Price__c.toString();
                tempCarPart.Car__c = tempCarPart.Car__r.Name;
                tempCarPart.Weight__c = tempCarPart.Weight__c.toString();
                tempCarPart.Is_Sold__c = tempCarPart.Is_Sold__c === true ? 'YES' : 'NO';
                tempCarPart.Is_Export__c = tempCarPart.Is_Export__c === true ? 'YES' : 'NO';
                tempCarPartsList.push(tempCarPart);
                this.carName = tempCarPart.Car__r.Name;        
            })
            this.carPartList = tempCarPartsList;
            console.log(this.carPartList);
            this.generatePdf();
        })
        .catch(error => {
            console.log('error = ' +error.body.message);
        });
    }
    createHeaders(keys) {

		let result = [];
		for (let i = 0; i < keys.length; i += 1) {
			result.push({
				id: keys[i],
				name: keys[i],
				prompt: keys[i],
				width: 45,
				align: "center",
				padding: 0
			});
		}
		return result;
	}
}