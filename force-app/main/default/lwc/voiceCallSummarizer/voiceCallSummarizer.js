import { LightningElement, api, track, wire } from 'lwc';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { updateRecord } from 'lightning/uiRecordApi';

// Import de la méthode Apex
import generateContentFromVoiceCall from '@salesforce/apex/VoiceCallPromptController.generateContentFromVoiceCall';

// Import des champs de l'objet VoiceCall
import ID_FIELD from '@salesforce/schema/VoiceCall.Id';
import NEWSUM_FIELD from '@salesforce/schema/VoiceCall.NewSum__c';
import LAST_MODIFIED_FIELD from '@salesforce/schema/VoiceCall.LastModifiedDate';

// On définit les champs à récupérer pour le wire service
const FIELDS = [NEWSUM_FIELD, LAST_MODIFIED_FIELD];

export default class VoiceCallSummarizer extends LightningElement {
   @api recordId; // Récupère automatiquement l'ID de la page d'enregistrement

   @track summary;
   @track isLoading = false;
   @track error;
   
   voiceCall;

   // Wire service pour récupérer les données du VoiceCall
   @wire(getRecord, { recordId: '$recordId', fields: FIELDS })
    wiredRecord({ error, data }) {
        if (data) {
            this.voiceCall = data;
            this.error = undefined;
        } else if (error) {
            this.error = 'Erreur lors de la récupération des données du VoiceCall.';
            this.voiceCall = undefined;
        }
    }

    // Getter pour accéder facilement au champ NewSum__c
    get previousSummary() {
        return getFieldValue(this.voiceCall, NEWSUM_FIELD);
    }

    // Getter pour accéder facilement au champ LastModifiedDate
    get lastModifiedDate() {
        return getFieldValue(this.voiceCall, LAST_MODIFIED_FIELD);
    }


   // Gère le clic sur le bouton "Résumé"
   handleGenerateFrenchClick() {
       this.callApexGenerator('fr');
   }

   // Gère le clic sur le bouton "Summary"
   handleGenerateEnglishClick() {
       this.callApexGenerator('en');
   }

   // Gère le clic sur le bouton "まとめ"
   handleGenerateJapaneseClick() {
       this.callApexGenerator('ja');
   }

   // Méthode générique pour appeler Apex avec la langue choisie
   callApexGenerator(language) {
        this.isLoading = true;
        this.error = undefined;

        generateContentFromVoiceCall({ voiceCallId: this.recordId, language: language })
            .then(result => {
                this.summary = result;
            })
            .catch(error => {
                this.error = 'Une erreur est survenue lors de la génération du résumé : ' + this.getErrorMessage(error);
                this.showToast('Erreur', this.error, 'error');
            })
            .finally(() => {
                this.isLoading = false;
            });
   }

   // Met à jour la variable 'summary' lorsque l'utilisateur modifie le texte
   handleTextChange(event) {
       this.summary = event.target.value;
   }

   // Gère le clic sur le bouton "Save"
   handleSaveClick() {
       this.isLoading = true;
       this.error = undefined;

       const fields = {};
       fields[ID_FIELD.fieldApiName] = this.recordId;
       fields[NEWSUM_FIELD.fieldApiName] = this.summary;

       const recordInput = { fields };

       updateRecord(recordInput)
           .then(() => {
               this.showToast('Succès', 'Le résumé a été enregistré avec succès.', 'success');
               this.summary = undefined;
           })
           .catch(error => {
               this.error = 'Une erreur est survenue lors de l\'enregistrement : ' + this.getErrorMessage(error);
               this.showToast('Erreur', this.error, 'error');
           })
           .finally(() => {
               this.isLoading = false;
           });
   }

   // Affiche une notification (toast)
   showToast(title, message, variant) {
       const event = new ShowToastEvent({
           title: title,
           message: message,
           variant: variant,
       });
       this.dispatchEvent(event);
   }

   // Extrait un message d'erreur lisible
   getErrorMessage(error) {
       if (error) {
           if (error.body && error.body.message) {
               return error.body.message;
           }
           if (error.message) {
               return error.message;
           }
       }
       return 'Erreur inconnue.';
   }
}