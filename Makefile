.PHONY: up down logs x_nuke

# Start the compose stack in detached mode
up:
	docker-compose up -d

# Stop the compose stack
down:
	docker-compose down

# View the stack logs
logs:
	docker-compose logs -f

# Run down and then remove all images and volumes
x_nuke: down
	docker-compose down -v --rmi all
	docker system prune -f
