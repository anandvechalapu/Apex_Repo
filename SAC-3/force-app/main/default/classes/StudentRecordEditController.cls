Apex Class
public with sharing class StudentRecordEditController {
    @AuraEnabled
    public static Student__c updateStudentRecord(Id studentId, String studentName, String studentId, String studentGrade) {
        // Validate the input parameters
        List<String> validationErrors = new List<String>();
        if (studentId == null) {
            validationErrors.add('Student ID is required.');
        }
        if (studentName == null) {
            validationErrors.add('Student Name is required.');
        }
        if (studentGrade == null) {
            validationErrors.add('Student Grade is required.');
        }
        if (!validationErrors.isEmpty()) {
            throw new AuraHandledException(String.join(validationErrors, '\n'));
        }
        
        // Update the student record
        Student__c student = new Student__c(
            Id = studentId,
            Name = studentName,
            Student_ID__c = studentId,
            Grade__c = studentGrade
        );
        update student;
        return student;
    }
}

Lightning Web Component
<template>
    <lightning-record-edit-form object-api-name="Student__c"
                               record-id={studentId}
                               onsuccess={handleSuccess}
                               onsubmit={handleSubmit}
                               onerror={handleError}>
        <lightning-messages></lightning-messages>
        <lightning-input-field field-name="Name"></lightning-input-field>
        <lightning-input-field field-name="Student_ID__c"></lightning-input-field>
        <lightning-input-field field-name="Grade__c"></lightning-input-field>
        <lightning-button variant="brand" type="submit" label="Save">
        </lightning-button>
    </lightning-record-edit-form>
</template>

import { LightningElement, api, track } from 'lwc';
import updateStudentRecord from '@salesforce/apex/StudentRecordEditController.updateStudentRecord';

export default class StudentRecordEditForm extends LightningElement {
    @api studentId;
    @track errors;
    @track success;
    
    handleSubmit(event) {
        const fields = event.detail.fields;
        updateStudentRecord({
            studentId: this.studentId,
            studentName: fields.Name,
            studentId: fields.Student_ID__c,
            studentGrade: fields.Grade__c
        })
        .then(result => {
            this.success = result;
            this.errors = undefined;
        })
        .catch(error => {
            this.success = undefined;
            this.errors = error;
        });
    }
    
    handleSuccess() {
        // Navigate to the student record detail page
    }
    
    handleError(event) {
        this.errors = event.detail.detail;
    }
}