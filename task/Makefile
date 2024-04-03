.PHONY: all
all: target/taskrc

target/taskrc: taskrc secret.conf
	mkdir -p target
	cat $^ > $@

install: target/taskrc
	install -m 0644 target/taskrc ~/.taskrc

clean:
	rm -rf target
