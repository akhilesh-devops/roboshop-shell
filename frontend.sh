log = /tmp/roboshop.log

echo -e "\e[32m >>>>>>>>>>>>>>>>> Copy Nginx configuration <<<<<<<<<<<<<<<<<<<<<<<<<<<<\e[0m" &>> ${log}
cp nginx-roboshop.conf /etc/nginx/default.d/nginx-roboshop.conf

echo -e "\e[32m >>>>>>>>>>>>>>>>> Install Nginx <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<\e[0m" &>> ${log}
dnf install nginx -y

echo -e "\e[32m >>>>>>>>>>>>>>>>> Remove the app content <<<<<<<<<<<<<<<<<<<<<<<\e[0m" &>> ${log}
rm -rf /usr/share/nginx/html/*

echo -e "\e[32m >>>>>>>>>>>>>>>> Download and extract the app content <<<<<<<<<<<<<<<<\e[0m" &>> ${log}
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip
cd /usr/share/nginx/html
unzip /tmp/frontend.zip

echo -e "\e[32m >>>>>>>>>>>>>>> Restart the Nginx service <<<<<<<<<<<<<<<<<<<\e[0m" &>> ${log}
systemctl restart nginx
systemctl enable nginx
