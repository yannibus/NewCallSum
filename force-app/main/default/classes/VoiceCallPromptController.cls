/**
 * @description Classe pour appeler un modèle de prompt Einstein (Prompt Template)
 * afin de générer un contenu à partir d'un enregistrement VoiceCall.
 */
public with sharing class VoiceCallPromptController {

    @AuraEnabled(cacheable=true)
    // Ajout du paramètre 'language' pour dynamiser la langue
    public static String generateContentFromVoiceCall(String voiceCallId, String language) {
        // --- 1. Préparation des entrées pour le modèle de prompt ---

        // Crée une map pour contenir tous les paramètres d'entrée.
        Map<String, ConnectApi.WrappedValue> inputParams = new Map<String, ConnectApi.WrappedValue>();

        // Prépare l'entrée pour l'objet VoiceCall.
        Map<String, String> voiceCallInput = new Map<String, String>();
        voiceCallInput.put('id', voiceCallId);

        ConnectApi.WrappedValue voiceCallValue = new ConnectApi.WrappedValue();
        voiceCallValue.value = voiceCallInput;
        inputParams.put('Input:VCInput', voiceCallValue);


        // --- 2. Configuration des paramètres d'invocation ---

        ConnectApi.EinsteinPromptTemplateGenerationsInput executeTemplateInput = new ConnectApi.EinsteinPromptTemplateGenerationsInput();
        executeTemplateInput.additionalConfig = new ConnectApi.EinsteinLlmAdditionalConfigInput();

        // Nom de l'application appelante.
        executeTemplateInput.additionalConfig.applicationName = 'PromptBuilderPreview';

        // Le paramètre de langue est maintenant défini dynamiquement via le paramètre de la méthode.
        // On utilise les codes de langue 'fr' ou 'en' passés depuis le LWC.
        executeTemplateInput.outputLanguage = language;
        executeTemplateInput.isPreview = false;
        executeTemplateInput.inputParams = inputParams;


        // --- 3. Appel du service et gestion de la réponse ---

        try {
            // Appelle le service Einstein LLM avec le nom d'API du modèle de prompt.
            ConnectApi.EinsteinPromptTemplateGenerationsRepresentation generationsOutput = ConnectApi.EinsteinLLM.generateMessagesForPromptTemplate(
                'NewSumFlex', // Nom d'API de votre Prompt Template
                executeTemplateInput
            );

            // Vérifie si des générations ont été retournées.
            if (generationsOutput != null && !generationsOutput.generations.isEmpty()) {
                // Extrait la première réponse générée.
                ConnectApi.EinsteinLLMGenerationItemOutput response = generationsOutput.generations[0];
                return response.text;
            } else {
                // Gérer le cas où aucune réponse n'est reçue.
                System.debug('Aucune réponse reçue du service Einstein LLM.');
                return 'Aucune réponse n\'a pu être générée.';
            }

        } catch (Exception e) {
            // En cas d'erreur, l'enregistre dans les logs de débogage et la propage.
            System.debug('Erreur lors de l\'appel au service Einstein LLM : ' + e.getMessage());
            throw new AuraHandledException('Erreur lors de la communication avec le service Einstein : ' + e.getMessage());
        }
    }
}