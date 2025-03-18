start:
	sudo -v
	sudo docker-compose -f docker-compose.yaml up -d
	sudo docker exec -d postgres psql -U postgres -d postgres -a -f /drop_structure.sql
	sudo docker exec -d postgres psql -U postgres -d postgres -a -f /tables_stucture.sql
	sudo docker exec -d postgres psql -U postgres -d postgres -a -f /insertion_values.sql
	sudo docker exec -d postgres psql -U postgres -d postgres -a -f /create_calculations.sql
	firefox Frontend/index.html

stop:
	sudo -v
	sudo docker-compose -f docker-compose.yaml down
	sudo docker ps
	