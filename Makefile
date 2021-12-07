IMAGE_NAME=elixir-dev
HISTORY_FILE=.image_bash_history

cli:
	touch $(PWD)/$(HISTORY_FILE)
	docker run -it \
			   --rm \
			   -e HISTFILE=/root/$(HISTORY_FILE) \
			   -v $(PWD)/$(HISTORY_FILE):/root/$(HISTORY_FILE) \
			   -v $(PWD):/root/ \
			   $(IMAGE_NAME)
build:
	docker build -t $(IMAGE_NAME) .

run:
	touch $(PWD)/$(HISTORY_FILE)
	docker run -it \
			   --rm \
                           --entrypoint=bash \
			   -e HISTFILE=/root/$(HISTORY_FILE) \
			   -v $(PWD)/$(HISTORY_FILE):/root/$(HISTORY_FILE) \
                           $(IMAGE_NAME)

