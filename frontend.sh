echo -e "\e[32m >>>>>>>>>>>>>>>>> Copy Nginx configuration <<<<<<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
cp nginx-roboshop.conf /etc/nginx/default.d/nginx-roboshop.conf

echo -e "\e[32m >>>>>>>>>>>>>>>>> Install Nginx <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
dnf install nginx -y

echo -e "\e[32m >>>>>>>>>>>>>>>>> Remove the app content <<<<<<<<<<<<<<<<<<<<<<<\e[0m"
rm -rf /usr/share/nginx/html/*

echo -e "\e[32m >>>>>>>>>>>>>>>> Download and extract the app content <<<<<<<<<<<<<<<<\e[0m"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip
cd /usr/share/nginx/html
unzip /tmp/frontend.zip

echo -e "\e[32m >>>>>>>>>>>>>>> Restart the Nginx service <<<<<<<<<<<<<<<<<<<\e[0m"
systemctl restart nginx
systemctl enable nginx
