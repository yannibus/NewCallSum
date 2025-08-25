🚀 Guide : Déployer le Projet depuis GitHub avec Code Builder

Ce guide explique comment récupérer le projet depuis un dépôt GitHub et le déployer directement sur une organisation Salesforce en utilisant Code Builder.

⸻

✅ Prérequis
	•	🔑 Accès au dépôt GitHub : Vous devez avoir été invité comme collaborateur si le dépôt est privé.
	•	🖥️ Accès à Code Builder dans l’organisation Salesforce cible.

⸻

1️⃣ Étape 1 : Cloner le Dépôt dans Code Builder

La première étape consiste à télécharger une copie du projet dans votre environnement Code Builder.
	1.	Lancez Code Builder depuis votre organisation Salesforce.
	2.	Une fois l’environnement chargé, ouvrez un terminal :
   Terminal > Nouveau terminal
  3.	Sur la page du dépôt GitHub, cliquez sur le bouton vert <> Code et copiez l’URL HTTPS.
	4.	Dans le terminal de Code Builder, lancez la commande :
 
   git clone https://github.com/yannibus/NewCallSum
 
  👉 Un nouveau dossier contenant tous les fichiers du projet apparaîtra dans l’explorateur de fichiers de Code Builder.

⸻

2️⃣ Étape 2 : Ouvrir le Dossier du Projet ⚠️ (Étape Cruciale)

C’est l’étape qui corrige souvent l’erreur : vous devez entrer dans le dossier cloné.
	1.	Allez dans le menu Fichier (File) en haut à gauche.
	2.	Sélectionnez Ouvrir un dossier… (Open Folder…).
	3.	Choisissez le dossier du projet que vous venez de cloner (ex: salesforce-einstein-advanced-summary) et cliquez sur OK.

👉 L’interface de Code Builder va se recharger avec le dossier du projet comme répertoire principal.

⸻

3️⃣ Étape 3 : Vérifier la Connexion à l’Organisation 🔗

Normalement, Code Builder est déjà connecté à l’organisation Salesforce où il s’exécute.
	•	Vérifiez en bas à gauche de l’écran que l’alias de l’organisation est bien affiché.
	•	Dans le cas exceptionnel d’un autre déploiement, utilisez :
   SFDX: Authorize an Org
  4️⃣ Étape 4 : Déployer les Composants 📦

Une fois le projet cloné et ouvert, vous pouvez déployer les métadonnées.
	1.	Dans l’explorateur de fichiers, faites un clic droit sur le dossier force-app.
	2.	Sélectionnez SFDX: Deploy Source to Org.
	3.	Attendez la fin du déploiement → un message de succès apparaîtra dans le terminal.

⸻

5️⃣ Étape 5 : Effectuer les Opérations Post-Installation 🛠️

Le code est en place, mais il reste deux configurations manuelles :

🔹 Connecter le Flow au Prompt Template
	1.	Dans Salesforce Setup, recherchez Prompt Builder.
	2.	Modifiez le Prompt Template NewSumFlex.
	3.	Vérifiez que le Flow NewSum_Grounding_Flow_With_Transcript est bien sélectionné comme ressource.

🔹 Déployer le LWC sur la Page d’Enregistrement
	1.	Ouvrez un enregistrement Voice Call.
	2.	Cliquez sur la roue dentée ⚙️ → Modifier la page (App Builder).
	3.	Dans les composants, trouvez voiceCallSummarizer et glissez-le dans la mise en page.
	4.	Enregistrez et activez la page.

⸻

🎉 Résultat

Votre projet est maintenant entièrement déployé et configuré sur la nouvelle organisation Salesforce !
