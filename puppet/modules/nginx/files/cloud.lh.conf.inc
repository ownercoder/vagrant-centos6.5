# Main virtualhost
server {
  listen 80;
  server_name cloud.lh;
  root /home/cloud/public_html;
  access_log /var/log/nginx/cloud.lh-access.log main;
  error_log /var/log/nginx/cloud.lh-error.log;
}