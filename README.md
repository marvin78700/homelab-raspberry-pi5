# homelab-raspberry-pi5
Serveur domestique sécurisé sur Raspberry Pi 5 -Pi-hole, unbound, WireGuard, UFW, Fail2ban

# 🍓 Homelab Raspberry Pi 5 — Serveur domestique sécurisé

## 📋 Description

Mise en place d'un serveur domestique sécurisé sur Raspberry Pi 5 combinant filtrage DNS, résolution récursive locale, VPN personnel et durcissement système (hardening).

---

## 🛠️ Services installés

### 🔵 Pi-hole — Filtrage DNS
J'aurais pu utiliser AdGuard Home, le concurrent direct de Pi-hole, qui propose une interface plus moderne,
une configuration plus simplet supporte nativement le DNS-over-HTTPS (chiffrement des requêtes DNS dans du trafic HTTPS).

J'ai choisi Pi-hole car c'est l'outil le plus populaire dans la communauté homelab — grande communauté, documentation abondante et mises à jour régulières.
Conçu pour le Raspberry Pi, il offre une interface web claire permettant de visualiser en temps réel les domaines bloqués, les requêtes DNS et les statistiques.
De nombreuses listes de blocage communautaires sont disponibles et maintenues, et il s'intègre parfaitement avec Unbound pour une résolution DNS complètement locale.

---

### 🔵 Unbound — Résolveur DNS récursif local
Il existe plusieurs résolveurs DNS récursifs comme BIND9 ou Knot Resolver, mais j'ai choisi Unbound car il s'intègre parfaitement avec Pi-hole — cette combinaison est d'ailleurs officiellement recommandée par Pi-hole dans sa documentation.

Unbound est très léger en ressources, simple à configurer, très bien documenté et dispose d'une grande communauté avec beaucoup de ressources disponibles.
Il intègre également DNSSEC nativement, ce qui valide cryptographiquement les réponses DNS et protège contre les attaques d'empoisonnement DNS.

---

### 🔵 WireGuard — VPN personnel
Pour le VPN, j'ai utilisé PiVPN pour installer et configurer WireGuard sur mon Pi. PiVPN est un script qui automatise l'installation de WireGuard et simplifie la gestion des clients VPN.
J'aurais pu choisir OpenVPN mais il est ancien, lourd et assez complexe à configurer.

WireGuard est beaucoup plus moderne (conçu en 2015) et intégré directement dans le noyau Linux depuis 2020. Il est également léger (environ 4000 lignes de code contre 400 000 pour OpenVPN, moins de code signifie moins de failles potentielles),
rapide, simple à configurer et sécurisé car il utilise uniquement des algorithmes cryptographiques modernes. Ce qui, à mon sens, en fait un choix de taille.

---

### 🔴 UFW — Pare-feu
Pour le pare-feu j'ai installé UFW (Uncomplicated Firewall) en configurant des règles strictes : seuls mon réseau local (LAN) et mon tunnel WireGuard sont autorisés à accéder aux services sensibles.

J'ai notamment restreint le port DNS (53) au LAN uniquement pour éviter les attaques par amplification DNS, sans cette restriction, mon Pi aurait pu être utilisé comme outil d'attaque DDoS à mon insu.
Le port HTTP/HTTPS est également restreint au LAN pour empêcher l'accès à l'interface Pi-hole depuis internet. Enfin SSH est limité au LAN et au VPN pour se protéger contre les attaques brute-force.

---

### 🔴 Fail2ban — Protection anti brute-forceFail2ban est un outil open source qui protège les serveurs contre certaines attaques en analysant les journaux d'événements en temps réel.
Simple à installer et hautement personnalisable, il s'intègre facilement à de nombreux contextes.

Concrètement, si Fail2ban détecte trop de tentatives de connexion échouées sur SSH (5 tentatives en 10 minutes dans ma config),
il bannit automatiquement l'IP concernée pendant 1 heure via UFW. C'est une protection complémentaire à UFW — UFW ferme les portes inutiles, Fail2ban surveille les portes ouvertes.

---

## ⚙️ Automatisation

### 📦 Script de backup
Le premier script effectue un backup des configurations de tous mes outils, compresse l'archive et en conserve une copie locale sur le Pi ainsi qu'une copie distante sur mon PC via SCP.
Les archives de plus de 7 jours sont automatiquement supprimées pour éviter de saturer le stockage.

### 👁️ Script de monitoring
Le second surveille l'état de tous mes services (Pi-hole, Unbound, WireGuard, Fail2ban) toutes les 5 minutes.
Si un service tombe, il est redémarré automatiquement et l'incident est enregistré dans un fichier de log avec horodatage.

---

## 📁 Scripts

Les scripts bash sont disponibles dans le dossier [`scripts/`](./scripts)

---

## 💡 Ce que ce projet m'a appris

- Comprendre le fonctionnement réel de la résolution DNS
- Sécuriser un système Linux (hardening)
- Automatiser des tâches système avec bash et crontab
- Transférer des fichiers de manière sécurisée via SCP
- Documenter et justifier mes choix techniques
