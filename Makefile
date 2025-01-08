#  __  __       _         __ _ _      
# |  \/  | __ _| | _____ / _(_) | ___ 
# | |\/| |/ _` | |/ / _ \ |_| | |/ _ \
# | |  | | (_| |   <  __/  _| | |  __/
# |_|  |_|\__,_|_|\_\___|_| |_|_|\___|
# -------------------------------------------------------------------------------------------------
SHELL := /bin/sh
TIME  := $(shell date '+%s')
GIT   ?= git

.DEFAULT_GOAL = git-status
REPOS_TARGETS = git-status git-push git-commit-amend git-tag-list git-diff git-reset-soft git-rm-cached git-branch
# -------------------------------------------------------------------------------------------------
.PHONY: clean

# -------------------------------------------------------------------------------------------------
git-status:
	$(GIT) status

push: git-push
git-push:
	@ for v in `$(GIT) remote show | grep -v origin`; do \
		printf "[%s]\n" $$v; \
		$(GIT) push --tags $$v `$(MAKE) git-current-branch`; \
	done

git-tag-list:
	$(GIT) tag -l

git-diff:
	$(GIT) diff -w

git-branch:
	$(GIT) branch -a

git-reset-soft:
	$(GIT) reset --soft HEAD^

git-commit-amend:
	$(GIT) commit --amend

git-current-branch:
	@$(GIT) branch --contains=HEAD | grep '*' | awk '{ print $$2 }'

git-follow-log:
	$(GIT) log --follow -p $(V) || printf "\nUsage:\n %% make $@ V=<filename>\n"

git-branch-tree:
	$(GIT) log --graph --pretty='format:%C(yellow)%h%Creset %s %Cgreen(%an)%Creset %Cred%d%Creset'

git-rm-cached:
	$(GIT) rm -f --cached $(V) || printf "\nUsage:\n %% make $@ V=<filename>\n"

# -------------------------------------------------------------------------------------------------
clean:

