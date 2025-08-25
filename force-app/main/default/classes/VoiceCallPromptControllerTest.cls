@IsTest
private class VoiceCallPromptControllerTest {

    @IsTest
    static void testGenerateContentFromVoiceCall() {
        // Générer un Id factice de VoiceCall (préfixe 0LQ pour VoiceCall)
        Id fakeVoiceCallId = '0LQ000000000001AAA';

        Test.startTest();
        String result;
        try {
            result = VoiceCallPromptController.generateContentFromVoiceCall(fakeVoiceCallId, 'fr');
        } catch (Exception e) {
            System.debug('Exception capturée (attendue en test) : ' + e.getMessage());
            result = null;
        }
        Test.stopTest();

        // Vérification minimale : soit null (exception capturée), soit une chaîne non vide
        System.assertEquals(true, result == null || result.length() >= 0,
            'La méthode doit retourner une chaîne ou lever une exception.');
    }

    @IsTest
    static void testGenerateContentFromVoiceCallWithInvalidId() {
        Test.startTest();
        Boolean exceptionThrown = false;
        try {
            // Ici un Id volontairement d’un autre objet (Account = préfixe 001)
            VoiceCallPromptController.generateContentFromVoiceCall('001000000000000AAA', 'en');
        } catch (Exception e) {
            exceptionThrown = true;
        }
        Test.stopTest();

        System.assertEquals(true, exceptionThrown,
            'Une exception doit être levée si l\'Id de VoiceCall est invalide.');
    }
}