# Main virtualhost
server {
	listen 80;
	server_name cloud.lh www.cloud.lh;
	root /home/cloud/public_html;
	access_log /var/log/nginx/cloud.lh-access.log main;
	error_log /var/log/nginx/cloud.lh-error.log;

	location / {
		error_page 404 = @backend;
		root /home/cloud/public_html/;
	}

	location ~ \.php$ {
		error_page 404 = @backend;
		return 404;
	}

	location @backend {
		proxy_pass  http://apache;
		proxy_set_header Host $host;
		proxy_set_header X-Real-IP $remote_addr;
		proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;

		client_max_body_size 100M;
		client_body_buffer_size 1m;
		proxy_intercept_errors on;
		proxy_buffering on;
		proxy_buffer_size 128k;
		proxy_buffers 256 16k;
		proxy_busy_buffers_size 256k;
		proxy_temp_file_write_size 256k;
		proxy_max_temp_file_size 0;
		proxy_read_timeout 300;
	}
}