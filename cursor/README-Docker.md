# TeamCity Docker Compose Setup

This project provides a Docker Compose configuration for running TeamCity Server with PostgreSQL database.

## Services

- **TeamCity Server**: JetBrains TeamCity server running on port 8111
- **PostgreSQL**: Database server for TeamCity data storage

## Quick Start

1. **Start the services**:

   ```bash
   make up
   ```

2. **Access TeamCity**:
   - Open your browser and navigate to `http://localhost:8111`
   - Follow the initial setup wizard

3. **View logs**:

   ```bash
   make logs
   ```

4. **Stop the services**:

   ```bash
   make down
   ```

## Available Make Targets

- `make up` - Start the compose stack in detached mode
- `make down` - Stop the compose stack
- `make logs` - View the stack logs
- `make x_nuke` - Stop the stack and remove all images and volumes

## Configuration

### Database Settings

- **Database Type**: PostgreSQL
- **Host**: postgres (internal Docker network)
- **Port**: 5432
- **Database Name**: teamcity
- **Username**: teamcity
- **Password**: teamcity

### Volumes

Data is persisted in the following local directories:

- `./volumes/teamcity-data` - TeamCity server data
- `./volumes/teamcity-logs` - TeamCity server logs
- `./volumes/postgres-data` - PostgreSQL data

## Network

Both services run on a custom bridge network named `teamcity-network`.

## Environment Variables

The TeamCity server is configured with the following environment variables:

- `TEAMCITY_DB_TYPE=postgresql`
- `TEAMCITY_DB_HOST=postgres`
- `TEAMCITY_DB_PORT=5432`
- `TEAMCITY_DB_NAME=teamcity`
- `TEAMCITY_DB_USER=teamcity`
- `TEAMCITY_DB_PASSWORD=teamcity`

## Cleanup

To completely remove all containers, images, and volumes:

```bash
make x_nuke
```

**Warning**: This will delete all TeamCity data and PostgreSQL data permanently.
