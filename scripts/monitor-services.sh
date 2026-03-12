#!/bin/bash
# Script de surveillance des services de Raspberry Pi 5
# Auteur : Marvin
# Date : 11/03/2026

# Création des variables
LOG_FILE="/var/log/monitor-services.log"
SERVICES=("pihole-FTL" "unbound" "wg-quick@wg0" "fail2ban")

# Vérification de l'état des services
for SERVICE in "${SERVICES[@]}"; do
    if ! systemctl is-active --quiet $SERVICE; then
        echo "$(date '+%Y-%m-%d %H:%M:%S') - $SERVICE est tombé, redémarrage en cours..." >> $LOG_FILE
        systemctl restart $SERVICE
        echo "$(date '+%Y-%m-%d %H:%M:%S') - $SERVICE redémarré." >> $LOG_FILE
    fi
done

# Log de confirmation d'exécution
echo "$(date '+%Y-%m-%d %H:%M:%S') - Vérification terminée." >> $LOG_FILE
