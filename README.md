# 🚀 RogueAP en WPA2 avec Phishing

Ce projet met en place un **Rogue Access Point (RogueAP)** en **WPA2** qui redirige les utilisateurs vers une fausse page de connexion (phishing) afin de capturer leurs identifiants.  

## 📌 **Fonctionnalités**
✅ Création d'un point d'accès Wi-Fi en WPA2  
✅ Capture et modification des paquets réseau  
✅ Redirection des victimes vers une page de phishing  
✅ Stockage des identifiants saisis  

---

## 🛠 **Prérequis**
Avant de commencer, assurez-vous d’avoir :  
- **Une carte Wi-Fi compatible mode AP** (ex: Alfa AWUS036ACH)  
- **Ubuntu / Kali Linux**  
- Les paquets suivants installés :  
  ```bash
  sudo apt update && sudo apt install -y hostapd dnsmasq iptables python3 flask tcpdump
  ```


---

## 🚀 **Installation et Lancement**
### 1️⃣ **Cloner le dépôt**
```bash
git clone https://github.com/votre-repo/RogueAP-WPA2-Phishing.git
cd RogueAP-WPA2-Phishing
```

### 2️⃣ **Configurer le point d'accès**
Modifiez `hostapd.conf` et `dnsmasq.conf` avec le nom de la carte wifi qui va servir de point d'accès.
Vous pouvez trouver le nom du point d'accès avec la commande 
```bash
iwconfig
```

### 3️⃣ **Lancer le RogueAP**
Modifier le fichier avant de le lancer, configurez les lignes de 4 à 7 pour configurer les informations de type clé WPA,SSID...
Remplacez également par les noms de vos cartes.

```bash
sudo ./rogueap.sh
```
📌 Cela démarre :  
- `hostapd` → Crée le Wi-Fi  
- `dnsmasq` → Configure DHCP et DNS  
- `iptables` → Redirige le trafic  
- `Flask` → Démarre le serveur de phishing  

### 4️⃣ **Se connecter et tester**
Sur un autre appareil, connectez-vous au Wi-Fi **"FreeWifi"** et ouvrez un navigateur.  
📌 Vous devriez voir **la page de phishing automatiquement**.  

---



---

## 🔍 **Logs et Résultats**
- **Vérifier si le RogueAP tourne bien** :  
  ```bash
  sudo netstat -tulnp | grep -E "53|80|8080"
  ```
- **Voir les identifiants capturés** :  
  ```bash
  cat creds.txt
  ```
- **Voir les paquets capturés** :  
  ```bash
  sudo tcpdump -i wlan0
  ```

---

## 🛑 **Arrêter et Nettoyer**
Une fois terminé, exécutez :  
```bash
sudo ./reset_network.sh
```
Cela **arrêtera tous les services et réinitialisera la configuration réseau**.

---


## 📜 **Avertissement**
⚠️ **Ce projet est strictement à des fins éducatives et de tests de sécurité.**  
**L'utilisation sur un réseau tiers sans autorisation est illégale.**  

---

## ✨ **Crédits**
Développé par **[wh0amix]**  
