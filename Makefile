IMAGE=landoop/fast-data-dev
CONTAINER_ID=$(shell docker container ls | awk '$$2 == "'${IMAGE}'" {print $$1}')

container-id:
	@echo ${CONTAINER_ID}

start:
	docker run -itd  \
		-p 2181:2181 \
		-p 3030:3030 \
		-p 8081:8081 \
		-p 8082:8082 \
		-p 8083:8083 \
		-p 9581-9585:9581-9585 \
		-p 9092:9092 \
		-e RUNNING_SAMPLEDATA=1 \
		-e KAFKA_AUTO_CREATE_TOPICS_ENABLE='true' \
		-e ADV_HOST=docker.for.mac.localhost \
	${IMAGE}

stop:
	docker stop ${CONTAINER_ID}

restart:
	docker restart ${CONTAINER_ID}

remove:
	docker container rm --force ${CONTAINER_ID}

check-running:
	@if [ -z "${CONTAINER_ID}" ]; then\
		make start;\
	fi \

status:
	@curl -f -s 0.0.0.0:8082 > /dev/null && echo ok || echo fail

logs:
	docker logs -f ${CONTAINER_ID}

bash:
	docker exec -it ${CONTAINER_ID} bash
