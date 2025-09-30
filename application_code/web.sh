#!/bin/bash
set -e   # exit on error

# Download app-tier code


cd /home/ec2-user

sudo chown -R ec2-user:ec2-user /home/ec2-user
sudo chmod -R 755 /home/ec2-user

sudo rm -rf fully-auto--advanced-3-tier-modular-working-with-application-access
git clone https://github.com/HVAksh/fully-auto--advanced-3-tier-modular-working-with-application-access.git

cp -rf fully-auto--advanced-3-tier-modular-working-with-application-access/application_code/web_files .

cd /home/ec2-user/web_files

# # Ensure correct ownership/permissions
sudo chown -R ec2-user:ec2-user /home/ec2-user
sudo chmod -R 755 /home/ec2-user/web_files



# Run build as ec2-user
su - ec2-user <<'EOF'
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# Sync latest code
rsync -av --delete ~/fully-auto--advanced-3-tier-modular-working-with-application-access/application_code/web_files/ ~/web_files/

cd ~/web_files
npm install
npm run build
EOF