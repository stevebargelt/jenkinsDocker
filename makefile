build:
	@docker-compose -p jenkins build nginx master slave
run:
	@docker-compose -p jenkins up -d nginx master
stop:
	@docker-compose -p jenkins stop
clean:	stop
	@docker-compose -p jenkins rm master nginx
clean-images: clean
	@docker image prune -a
