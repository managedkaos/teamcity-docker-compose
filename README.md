# AI Coding Agent Comparison: Generate a Docker Compose Environment for Teamcity

Testing out AI agents and how they implement a docker compose project.

## The `docker run` Template

The following file is the basis for the prompt given to the agent for creating the docker compose project:

- [docker-run.sh](./docker-run.sh)

```bash
docker run --name teamcity-server-instance \
    -v <path to data directory>:/data/teamcity_server/datadir \
    -v <path to logs directory>:/opt/teamcity/logs \
    -p <port on host>:8111 \
    jetbrains/teamcity-server
```

## Prompt

The current directory contains the file `@docker-run.sh` with commands for running a teamcity image.  Use the run commands to create a docker compose configuration.  For volumes, add directories in the CWD under `./volumes`.  In the compose configuration, add a postgresql database on the same network as the teamcity container.  use `teamcity` for the default username, password, and database name.  Add a Makefile to the project with targets for `up` to start the compose stack in detached mode; `down` to stop the compose stack; `logs` to view the stacks logs; and `x_nuke` to run `down` and then remove all images and volumes.

> [!TIP]
> Use the following field to easily copy the prompt.

```text
The current directory contains the file @docker-run.sh with commands for running a teamcity image.
Use the run commands to create a docker compose configuration.  For volumes, add directories in the
CWD under `./volumes`.  In the compose configuration, add a postgresql database on the same network
 as the teamcity container.  use `teamcity` for the default username, password, and database name.
Add a Makefile to the project with targets for `up` to start the compose stack in detached mode;
`down` to stop the compose stack; `logs` to view the stacks logs; and `x_nuke` to run `down` and
then remove all images and volumes.
```

## Google Gemini CLI

- First attempt using the entire prompt resulted in too many requests
- Second pass attempted to break the prompt into smaller parts
- The Gemini model was able to read the `docker-run.sh` file and create a `docker-compose.yml` file, but it encountered an error when trying to write the file due to a relative path issue. It then corrected this by using an absolute path.
- The model successfully created the `docker-compose.yml` file with the specified volumes along with the `./volume` directory.
- It then attempted to read the `docker-compose.yml` file to add the PostgreSQL database, but encountered a rate limit error.
- The compose file worked as expected but required commands to be run directly instead of with `make`.

## Cursor (Using Claude Sonnet models)

- Handled the prompt very well in one pass.
- Added the files as requested and then went above and beyond.
- Created the `./volumes` directory with sub-dirs to match the compose configuration
- The compose configuration was very complete with good naming conventions
- I was already thinking that I would need to update the projects `.gitignore` file to disregard the volume files.
- Documentation was added in a markdown file
- When the stack was started, it was revealed that the compose configuration used a deprecated attribute, `version`:

  > WARN[0000] /tmp/TMP_DIRS/2025-06-25/teamcity-docker-compose/cursor/docker-compose.yml: the attribute `version` is obsolete, it will be ignored, please remove it to avoid potential confusion

  This setting was noted and manually removed from the configuration to minimize notificaitons down the road.

- The `TEAMCITY_DB...` environment variables seemed promising but were not applied to the install out of the box (the DB still needed to be configured; perhaps because the database driver needed to be downloaded first?).  But Cursor did a decent job of trying to set this up ahead of time:

  From the web:

  > TeamCity uses environment variables to configure its database connection and other settings. Key variables include TEAMCITY_DB_URL, TEAMCITY_DB_USER, and TEAMCITY_DB_PASSWORD for database connection details. These variables, along with others, can be set in the TeamCity server's environment or within specific build configurations.

  And implemented in the compose configuration with a bit of halucenation.  Specifically, it did not use `TEAMCITY_DB_URL` but added `TEAMCITY_DB_TYPE`, `TEAMCITY_DB_HOST`, and `TEAMCITY_DB_PORT` which are not mentioned in the documentation.

  ```yaml
      environment:
      - TEAMCITY_DB_TYPE=postgresql
      - TEAMCITY_DB_HOST=postgres
      - TEAMCITY_DB_PORT=5432
      - TEAMCITY_DB_NAME=teamcity
      - TEAMCITY_DB_USER=teamcity
      - TEAMCITY_DB_PASSWORD=teamcity
  ```

## Goose

- Handled the prompt on the first pass
- Didn't attempt to create the `./volumes` directory but the compose configuration include the paths.

