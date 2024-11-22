# Event Scheduling System

# Tomoki Kyotani; Yuan-Cheng Su

## This Project is designed for a regional university/college resource management

### Below are required software knowledge or database tools

- Python
- Django
- Postgres SQL
- Azure Cosmos DB for NoSQL
- Azure Cosmos DB for Gremlin
- Azure Data Factory

### Navigating through this repository

- Django UI

> Within this folder, there are a simple design for an user interface that allows the administration to insert new schedules

- Query

> This folder includes following items(All SQL are in Postgres environment)
> - Database defenition language
> - Audit Trigger
> - Historical data import (In python notebook, can be alter to py file)
> - Doucment query for data pipeline in Azure Data Factory
> - Sample Data

- Graph DB Pipeline

> As Data Factory does not support direct connection from Azure Cosmos DB for Gremlin, the pipeline is designed with a customized Python script

- ERDS

<img src="/Database structure/DatabaseERdiagram(PostgresSQL).png"  title="SQL ERD">

<img src="/Database structure/DatabaseERdiagram(Graphic).png"  title="Graphic ERD">