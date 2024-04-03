head = head.sh
dash_part = dash-compatible.sh
ash_part = busybox-ash-compatible.sh
bash_part = lib/preexec.sh bash-compatible.sh lib/z.sh lib/fzf.sh lib/complete-alias.sh
tail = tail.sh personal.sh

dash_components = $(head) $(dash_part) $(tail)
ash_components = $(head) $(dash_part) $(ash_part) $(tail)
bash_components = $(head) $(dash_part) $(ash_part) $(bash_part) $(tail)

.PHONY: all
all: target/profile target/bashrc target/ash_profile

target/bashrc: $(bash_components)
	mkdir -p target
	cat $^ > $@

target/ash_profile: $(ash_components)
	mkdir -p target
	cat $^ > $@

target/profile: $(dash_components)
	mkdir -p target
	cat $^ > $@

.PHONY: install
install: target/bashrc
	cp $^ ~/.bashrc
	@echo "run 'exec bash' to reload config"

.PHONY: clean
clean:
	rm -f target/*
