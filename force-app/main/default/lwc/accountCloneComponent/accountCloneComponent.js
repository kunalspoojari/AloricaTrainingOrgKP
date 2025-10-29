import { LightningElement,api,wire } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import cloneContactsForAccount from '@salesforce/apex/AccountCloneController.cloneContactsForAccount';

const FIELDS = [
        'Account.Name',
        'Account.Type',
        'Account.Demandbase_Industry__c',
        'Account.Demandbase_Account_Name__c',
        'Account.ParentId',
        'Account.Inactive__c',
        'Account.Primary_NAICS_Code__c',
        'Account.Sic',
        'Account.SicDesc',
        'Account.Primary_NAICS_Description__c',
        'Account.engagio__qualification_score__c',
        'Account.engagio__pipeline_predict_score__c',
        'Account.engagio__Status__c',
        'Account.Alorica_Industry__c',
        'Account.Sub_Industry__c',
        'Account.Alorica_Vertical__c',
        'Account.Category__c',
        'Account.CPM_Zone__c',
        'Account.Strategic_Account__c',
        'Account.Target_Account__c',
        'Account.OwnerId',
        'Account.Client_Account_Manager_1__c',
        'Account.Client_Account_Manager_2__c',
        'Account.Client_Account_Manager_3__c',
        'Account.Client_Account_Manager_4__c',
        'Account.Client_Account_Manager_5__c',
        'Account.Client_Account_Manager_6__c',
        'Account.Client_Account_Manager_7__c',
        'Account.Sales_Executive__c',
        'Account.CS_BDE_Assignee__c',
        'Account.Strategic_Account_Sales_Executive__c',
        'Account.Inside_Sales_Strategy__c',
        'Account.Client_Technology_Manager__c',
        'Account.Client_Technology_Manager_Secondary__c',
        'Account.IT_Complexity__c',
        'Account.Support_Model__c',
        'Account.Description',
        'Account.Year_Founded__c',
        'Account.Ownership',
        'Account.NumberOfEmployees',
        'Account.AnnualRevenue',
        'Account.Fortune_Ranking__c',
        'Account.Outsourcing_Maturity__c',
        'Account.Company_Market_Maturity__c',
        'Account.Phone',
        'Account.Website',
        'Account.TickerSymbol',
        'Account.Twitter__c',
        'Account.Facebook__c',
        'Account.LinkedIn__c',
        'Account.Technology__c',
        'Account.HQ_Street__c',
        'Account.HQ_City__c',
        'Account.HQ_State__c',
        'Account.HQ_Country__c',
        'Account.RecordTypeId'
    ];

export default class AccountCloneComponent extends NavigationMixin(LightningElement) {
    @api recordId;
    accountData;
    cloneContacts = false;  
    isLoading = false;

    @wire(getRecord, { recordId: '$recordId', fields: FIELDS })
    wiredAccount({ error, data }) {
        if (data) {
            this.accountData = data;
        } else if (error) {
            this.showToast('Error', error.body.message, 'error');
        }
    }

    handleSubmit(event) {
        // Prevent auto submit
        event.preventDefault();
 
        // You can access form data
        const fields = event.detail.fields;
        console.log('Fields before save:', fields);
 
        // Custom validation or logic
        if (!fields.Name) {
            alert('Name is required!');
            return;
        }

        this.isLoading = true;

        // Programmatically submit
        this.template.querySelector('lightning-record-edit-form').submit(fields);
    }
 
    handleCustomSubmit() {
        // Trigger form submission programmatically
        this.isLoading = true;
        this.template.querySelector('lightning-record-edit-form').submit();
    }
 
    handleSuccess(event) {
        console.log('Record saved:', event.detail.id);

        if (this.cloneContacts) {
            this.cloneRelatedContacts(event.detail.id);
        }
        else{
            this.isLoading = false;
            this.navigateToNewAccount(event.detail.id);
            this.showToast('Account cloned', 'Account Created Successfully', 'success');
        }

    }

    cloneRelatedContacts(newAccId) {
        cloneContactsForAccount({
            sourceAccountId: this.recordId,
            targetAccountId: newAccId
        })
            .then(() => {
                this.isLoading = false;
                this.navigateToNewAccount(newAccId);
                this.showToast('Contacts cloned', 'All related contacts were cloned.', 'success');
            })
            .catch(error => {
                this.isLoading = false;
                this.showToast('Error cloning contacts', error.body.message, 'error');
            });
    }

    handleCloneContactsChange(event) {
        this.cloneContacts = event.target.checked;
    }

    navigateToNewAccount(newAccId) {
            this[NavigationMixin.Navigate]({
                type: 'standard__recordPage',
                attributes: {
                    recordId: newAccId,
                    objectApiName: 'Account',
                    actionName: 'view'
                }
            });
    }

    showToast(title, message, variant) {
        this.dispatchEvent(new ShowToastEvent({ title, message, variant }));
    }
}