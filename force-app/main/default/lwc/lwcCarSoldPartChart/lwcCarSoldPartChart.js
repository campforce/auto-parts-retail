import { LightningElement, wire, api } from 'lwc';
import { loadScript } from 'lightning/platformResourceLoader';
import chartjs from '@salesforce/resourceUrl/chartJs';
import getStatistics from '@salesforce/apex/LwcCarSoldPartChartController.getStatistics';

export default class LwcCarSoldPartChart extends LightningElement {
    @api recordId;

    error;
    chart;
    chartjsInitialized = false;
    types = [];
    totals = [];
    records;
    @wire(getStatistics,{recordId: '$recordId'})
    properties({ error, data }) {
        if (data) {
            console.log('data ===' +data);
            this.records = data;
            for (const [key, value] of Object.entries(this.records)) {
                
                this.types.push(key);
                this.totals.push(value);
                console.log(this.types);
                console.log(this.totals);
            }
            this.error = undefined;
            if (this.chartjsInitialized) {
                return;
            }
            this.chartjsInitialized = true;
            loadScript(this, chartjs)
                .then(() => {
                    console.log('LOAD SCRIPT...')
                    const canvas = document.createElement('canvas');
                    this.template.querySelector('div.chart').appendChild(canvas);
                    const ctx = canvas.getContext('2d');
                    this.chart = new window.Chart(ctx, this.config);
                })
        } else if (error) {
            this.error = error;
            this.record = undefined;
        }
    }
    config = {
        type: 'pie',
        data: {
            datasets: [
                {
                    data: this.totals,
                    backgroundColor: [
                         'rgb(255, 99, 132)',
                         'rgb(255, 159, 64)',
                         'rgb(255, 205, 86)',
                         'rgb(75, 192, 192)',
                         'rgb(54, 162, 235)'
                    ],
                    label: 'Dataset 1'
                }
            ],
            labels: this.types
        },
        options: {
            responsive: false,
            plugins: {
                legend: {
                    position: 'bottom'
                }
            },
            animation: {
                animateScale: true,
                animateRotate: true
            }
        }
    };
}