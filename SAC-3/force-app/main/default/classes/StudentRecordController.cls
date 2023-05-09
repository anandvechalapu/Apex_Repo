Apex Class
public with sharing class StudentRecordController {
    
    @AuraEnabled
    public static Student__c upsertStudentRecord(Student__c studentRecord) {
        try {
            // Perform validation
            List<String> errors = new List<String>();
            if (String.isBlank(studentRecord.Name)) {
                errors.add('The student name is required.');
            }
            if (String.isBlank(studentRecord.StudentID__c)) {
                errors.add('The student ID is required.');
            }
            if (String.isBlank(studentRecord.Grade__c)) {
                errors.add('The student grade is required.');
            }
            if (!errors.isEmpty()) {
                throw new AuraHandledException(String.join(errors, '\n'));
            }
            
            // Upsert the record
            upsert studentRecord;
            
            // Return the updated record
            return [SELECT Id, Name, StudentID__c, Grade__c FROM Student__c WHERE Id = :studentRecord.Id];
        } catch (DmlException e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}

Lightning Web Component
<template>
    <lightning-record-edit-form object-api-name="Student__c" 
        onsuccess={handleSuccess}>
        <lightning-messages></lightning-messages>
        <lightning-input-field field-name="Name"></lightning-input-field>
        <lightning-input-field field-name="StudentID__c"></lightning-input-field>
        <lightning-input-field field-name="Grade__c"></lightning-input-field>
        <lightning-button type="submit" label="Save" ></lightning-button>
    </lightning-record-edit-form>
</template>

import { LightningElement } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import upsertStudentRecord from '@salesforce/apex/StudentRecordController.upsertStudentRecord';

export default class StudentRecordEdit extends LightningElement {
    handleSuccess(event) {
        const studentRecord = event.detail.id;
        upsertStudentRecord({studentRecord})
            .then(() => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'Student record successfully updated',
                        variant: 'success'
                    })
                );
            })
            .catch(error => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error updating student record',
                        message: error.body.message,
                        variant: 'error'
                    })
                );
            });
    }
}