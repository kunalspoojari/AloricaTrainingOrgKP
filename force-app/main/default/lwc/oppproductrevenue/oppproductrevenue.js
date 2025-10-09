import { LightningElement, wire, api, track } from "lwc";
/*import getMonthDetails from "@salesforce/apex/opportunityprod.getMonthDetails";
import deleteQuoteLineRecords from "@salesforce/apex/opportunityprod.deleteQuoteLineRecords";
import UpdateQuoteLineRecords from "@salesforce/apex/opportunityprod.UpdateQuoteLineRecords";
import { getRecord, getFieldValue } from "lightning/uiRecordApi";
import REVENUE_FIELD from "@salesforce/schema/SBQQ__QuoteLine__c.Calculated_Rev_per_FTE_Quantity__c";
import insertRevenueRecord from "@salesforce/apex/opportunityprod.insertRevenueRecord";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import { refreshApex } from "@salesforce/apex";
import { updateRecord } from "lightning/uiRecordApi";
import TARGET_TRAINING_LAUNCH_DATE_FIELD from "@salesforce/schema/SBQQ__QuoteLine__c.Target_Training_Launch_Date__c";

const fields = [REVENUE_FIELD,TARGET_TRAINING_LAUNCH_DATE_FIELD];*/

export default class Oppproductrevenue extends LightningElement {
 /* @track isDialogVisible = false;
  @track originalMessage;
  @track displayMessage =
    "Click on the 'Open Confirmation' button to test the dialog.";

  @api recordId;
  @api SBQQ_QuoteLine_c;
  @api Revenue_Forecast__c;

  @track setmonth;
  @track setquantity;
  @track setexprevenue = "";
  @track monthInfo = [];
  @track isLoadingIndicator = true;


/*  @wire(trainingdt) SBQQ__QuoteLine__c;

    get trainingdate() {
        return this.SBQQ__QuoteLine__c.data ? getSObjectValue(this.SBQQ__QuoteLine__c.data, trainingdatecurrentvalue) : '';
    }*/

 /* @wire(getRecord, { recordId: "$recordId", fields })
  SBQQ__QuoteLine__c;

  get revenue() {
    return getFieldValue(this.SBQQ__QuoteLine__c.data, REVENUE_FIELD);
  }
  get targetTrainingLaunchDate() {
    return getFieldValue(this.SBQQ__QuoteLine__c.data, TARGET_TRAINING_LAUNCH_DATE_FIELD);
  }

  updateRecordView(recordId) {
    updateRecord({ fields: { Id: recordId } });
  }

  onHandlechange(event) {
    //this.revenuesave.setexprevenue = event.target.value;
    const index = event.target.name;
    const q = event.target.value;
    let tempList = [...JSON.parse(JSON.stringify(this.monthInfo))];
    let i = 0;
    tempList.map((e) => {
      if (i == index) {
        e.exprevenue = parseInt(q) * parseInt(this.revenue);
        e.quantity = q;
        e.monthNo = i + 1;
      }
      i++;
    });

    console.log(tempList);
    this.monthInfo = tempList;
  }

  onFocusChange(event){

    const index = event.target.name;
    const q = event.target.value;

    let tempList = [...JSON.parse(JSON.stringify(this.monthInfo))];

    let isDatesMatch=true;
    let i = 0;
    tempList.map((e) => {
      if (i == 0) {

        //var date1=(new Date(e.month));
        //var date2=new Date(new Date(this.targetTrainingLaunchDate).setHours(0,0,0,0));
        var date2=this.targetTrainingLaunchDate.toLocaleString("en-US", {timeZone: "America/Los_Angeles"});
        var date1=new Date(e.month.toLocaleString("en-US", {timeZone: "America/Los_Angeles"}));
        var dd = date1.getDate();
        var mm = date1.getMonth()+1;
        var yyyy = date1.getFullYear();
        if(mm<10) { mm='0'+mm; }
        if(dd<10) { dd='0'+dd; }
        var formatteddate=yyyy+'-'+mm+'-'+dd;
        
        console.log("formatteddate:"+formatteddate);
        


       // console.log("month start date:"+date1);
        console.log("Target training date:"+date2);

        if(formatteddate==date2 )
        {
          console.log('Both dates are equal');
        }else{
          isDatesMatch=false;
          console.log('Both dates are not equal');
        }
      }
      i++;
    });

    if(!isDatesMatch){
      alert('Please Refresh Revenue Forcast');
      event.target.blur();
    }
  }

  onRevenuechange(event) {
    const index = event.target.name;
    const q = event.target.value;

    let tempList = [...JSON.parse(JSON.stringify(this.monthInfo))];

    let i = 0;
    tempList.map((e) => {
      if (i == index) {
        e.exprevenue = q;
      }
      i++;
    });

    console.log(tempList);
    this.monthInfo = tempList;
  }

  onCommentchange(event) {
    //this.revenuesave.setexprevenue = event.target.value;
    const index = event.target.name;
    const q = event.target.value;

    let tempList = [...JSON.parse(JSON.stringify(this.monthInfo))];

    let i = 0;
    tempList.map((e) => {
      if (i == index) {
        e.comment = q;
      }
      i++;
    });

    console.log(tempList);
    this.monthInfo = tempList;
  }

  createrev() {
    this.isLoadingIndicator = true;
    let tempList = [...JSON.parse(JSON.stringify(this.monthInfo))];

    insertRevenueRecord({ revenueList: tempList, quoteId: this.recordId })
      .then((result) => {
        //window.top.location.reload();

        const evt = new ShowToastEvent({
          title: "Success",
          message: "Revenue Details Updated Successfully.",
          variant: "success",
          mode: "dismissable",
        });
        this.updateRecordView(this.recordId);
        this.isLoadingIndicator = false;
        this.dispatchEvent(evt);
        // window.top.location.reload();
        // document.location.reload();
      })
      .catch((error) => {
        console.log(error);
        const evt = new ShowToastEvent({
          title: "Error",
          message: "Some unexpected error",
          variant: "error",
          mode: "dismissable",
        });
        this.isLoadingIndicator = false;
        this.dispatchEvent(evt);
      });
  }

  deleteRecords(event) {
    if (event.target != undefined) {
      if (event.target.name === "openConfirmation") {
        //it can be set dynamically based on your logic
        this.originalMessage = "test message";
        //shows the component
        this.isDialogVisible = true;
      } else if (event.target.name === "confirmModal") {
        //when user clicks outside of the dialog area, the event is dispatched with detail value  as 1
        if (event.detail !== 1) {
          if (event.detail.status === "confirm") {
            this.isLoadingIndicator = true;
            deleteQuoteLineRecords({ quoteLineId: this.recordId })
              .then((result) => {
                this.monthInfo = result;
                const evt = new ShowToastEvent({
                  title: "Success",
                  message: "Revenue Details Deleted Successfully.",
                  variant: "success",
                  mode: "dismissable",
                });
                this.updateRecordView(this.recordId);
                this.isLoadingIndicator = false;
                this.dispatchEvent(evt);

                //return refreshApex(this.monthInfo);
              })
              .catch((error) => {
                console.log(error);
                const evt = new ShowToastEvent({
                  title: "Error",
                  message: "Some unexpected error",
                  variant: "error",
                  mode: "dismissable",
                });
                this.isLoadingIndicator = false;
                this.dispatchEvent(evt);
              });
          } else if (event.detail.status === "cancel") {
          }
        }

        this.isDialogVisible = false;
      }
    }
  }

  UpdateQuoteLineRecords() {
    // this.isLoadingIndicator = true;
    UpdateQuoteLineRecords({ quoteId: this.recordId })
      .then((result) => {
        this.getMonthDetails = result;
        const evt = new ShowToastEvent({
          title: "Success",
          message: "Revenue Details refresh Successfully.",
          variant: "success",
          mode: "dismissable",
        });
        // this.isLoadingIndicator = false;
        this.dispatchEvent(evt);
        this.updateRecordView(this.recordId);
      })
      .catch((error) => {
        console.log(error);
        const evt = new ShowToastEvent({
          title: "Error",
          message: "Some unexpected error",
          variant: "error",
          mode: "dismissable",
        });
        // this.isLoadingIndicator = false;
        this.dispatchEvent(evt);
      });
  }

  refreshRevenue() {

    //debugger;
    this.isLoadingIndicator = true;
    //refreshApex(this.monthInfo);
    getMonthDetails({ quoteId: this.recordId })
      .then((result) => {
      //  debugger;

        this.monthInfo = result;
        console.log('Data:   '+this.monthInfo)
        this.updateRecordView(this.recordId);
        this.isLoadingIndicator = false;
        //window.location.reload();
      })
      .catch((error) => {
        console.log('Error:   '+error);
        this.contacts = undefined;
        this.isLoadingIndicator = false;
      });
  }
  error;

  columns = [
    // { label: 'Month Number', fieldName: 'id' },
    { label: "Month", fieldName: "month" },
    { label: "Quantity", fieldName: "quantity" },
    { label: "Revenue", fieldName: "exprevenue" },
    { label: "Comments", fieldName: "comments" },
  ];

  
  connectedCallback() {
    this.isLoadingIndicator = false;
    getMonthDetails({ quoteId: this.recordId })
      .then((result) => {
        this.monthInfo = result;
      })
      .catch((error) => {
        this.error = error;
        this.contacts = undefined;
      });
  }
  // wiredMonthList({ error, data }) {
  //   if (data) {
  //     debugger;
  //     console.log("opp++" + JSON.stringify(data));

  //     this.monthInfo = data;
  //     this.error = undefined;
  //   } else if (error) {
  //     debugger;
  //     console.log("error++" + error);

  //     //this.error = error;
  //     // this.opp = undefined;
  //   }
  // }*/
}