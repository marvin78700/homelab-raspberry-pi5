#!/bin/bash
# script de backup des configurations du Raspberry Pi 5
# Auteur : Marvin
# Date : 10/03/2026

# Création des variables
DATE=$(date +%Y-%m-%d_%H-%M-%S)
BACKUP_DIR="/home/marvin/backups"
BACKUP_NAME="backup-config_$DATE"

# Crée le dossier
mkdir -p $BACKUP_DIR/$BACKUP_NAME

# Copie des configurations de mes utilitaires
cp -r /etc/unbound $BACKUP_DIR/$BACKUP_NAME/
cp -r /etc/pihole $BACKUP_DIR/$BACKUP_NAME/
cp -r /etc/wireguard $BACKUP_DIR/$BACKUP_NAME/
cp -r /etc/fail2ban/jail.local $BACKUP_DIR/$BACKUP_NAME/
cp -r /etc/ufw $BACKUP_DIR/$BACKUP_NAME/
cp -r /etc/prometheus $BACKUP_DIR/$BACKUP_NAME/
cp -r /etc/grafana $BACKUP_DIR/$BACKUP_NAME/
cp /etc/systemd/system/node_exporter.service $BACKUP_DIR/$BACKUP_NAME/

# Compression des fichiers de backups
tar -czf $BACKUP_DIR/$BACKUP_NAME.tar.gz -C $BACKUP_DIR $BACKUP_NAME
rm -rf $BACKUP_DIR/$BACKUP_NAME

# Suppresion des vieux backups (une semaine)
find $BACKUP_DIR -name "backup-config_*.tar.gz" -mtime +7 -delete

# Transfert de fichier via SCP
for HOST in "IP sans VPN" "IP avec VPN"; do
    if ssh -o ConnectTimeout=3 -o BatchMode=yes marvin@$HOST exit 2>/dev/null; then
        scp $BACKUP_DIR/$BACKUP_NAME.tar.gz "USER@$HOST:chemin"
        break
    fi
done

# Message de confirmation
echo "Backup terminé : $BACKUP_DIR/$BACKUP_NAME.tar.gz"
echo "Date : $DATE"
