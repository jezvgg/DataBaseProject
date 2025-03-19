# DataBaseProject

Проект реализующий планшет для расчётов артелерических выстрелов.
Основная фишка проекта - полная реализация backend'а на Postgres с использованием postgREST и PLpgSQL.

![](./Docs/_Images/tables_meteo.jpg)
![](./Docs/_Images/history_meteo.jpg)

## Структура
```
.
├── Database # Скрипты для создания БД
│   ├── create_calculations.sql # 4. Реализация рассчётных функций и процедур
│   ├── drop_structure.sql # 1. Удаления старой структуры, если таковая имеется
│   ├── insertion_values.sql # 3. Вставка значений для поправок
│   ├── mock_script.sql # Скрипт создающий тестовых пользователей и записи к ним
│   └── tables_stucture.sql # 2. Создание структуры и таблиц
├── Docs # Техническое задание по проекту
│   ├── AlgoritmBp.md
│   ├── AlgoritmDmk.md
│   ├── _Images
│   └── TechnicalTask.md
├── Frontend # Интерфейс планшета
│   ├── index.html
│   ├── main.css
│   └── main.scss
├── docker-compose.yaml
├── Makefile
└── README.md
```

## Инструкции по сборке

В проекте прописан файл для его сборки, а также docker-compose.
Поэтому если у вас установлен docker и docker-compose, то достаточно написать команду:
```
make start
```

Когда вы захотите остановить систему, то используйте:
```
make stop
```

Если вам нужен один скрипт, создающий базу данных, для вставки в свою базу, то можно использовать:
```
make build
```

