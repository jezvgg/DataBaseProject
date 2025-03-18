# Запуск приложения
start:
	sudo -v
	make build
	sudo docker-compose -f docker-compose.yaml up -d
	sudo docker exec postgres psql -U postgres -d postgres -a -f /script.sql --echo-errors
	firefox Frontend/index.html

# Остановка приложения
stop:
	sudo -v
	sudo docker-compose -f docker-compose.yaml down
	sudo docker ps

# Сборка в один скрипт
build:
	cat Database/drop_structure.sql Database/tables_stucture.sql Database/insertion_values.sql Database/create_calculations.sql > script.sql