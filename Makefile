PLAY = ansible-playbook ./playbooks/setup.yml $(PARAM)

install-ansible: PH
	. ./install_ansible.sh

play: PH
ifneq (, $(findstring local, $(MAKECMDGOALS)))
	$(PLAY) --connection local
else
	$(PLAY)
endif

PH:
.PHONY: $(PH)