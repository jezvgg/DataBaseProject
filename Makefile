start:
	sudo -v
	sudo docker-compose -f docker-compose.yaml up -d
	firefox Frontend/index.html