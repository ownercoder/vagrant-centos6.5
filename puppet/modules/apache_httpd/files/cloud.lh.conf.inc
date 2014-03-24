NameVirtualHost 127.0.0.1:8080

<Virtualhost 127.0.0.1:8080>
	ServerName cloud.lh
	ServerAlias www.cloud.lh
	DocumentRoot /home/cloud/public_html
	<Directory /home/cloud/public_html>
		Options Indexes FollowSymLinks MultiViews
		AllowOverride None
		Order allow,deny
		allow from all
		DirectoryIndex index.php
	</Directory>
	ErrorLog logs/cloud.lh-error_log
	CustomLog logs/cloud.lh-access_log common
</Virtualhost>