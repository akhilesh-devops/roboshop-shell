echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>> install Nginx <<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
yum install nginx -y

echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>> copy the roboshop configuration <<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
cp nginx-roboshop.conf \etc/nginx/default.d/roboshop.conf

echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>> cleaning the old content <<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
rm -rf /usr/share/nginx/html/*

echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>> Download application content <<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip

echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>> Extract application content <<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
cd /usr/share/nginx/html
unzip /tmp/frontend.zip

echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>> Start the service <<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
systemctl enable nginx
systemctl restart nginx
