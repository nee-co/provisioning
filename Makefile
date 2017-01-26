PLAY = ansible-playbook ./playbooks/setup.yml $(PARAM)

install-ansible: PH
	. ./install_ansible.sh | sh -s -- 2.1.4.0

play: PH
ifneq (, $(findstring local, $(MAKECMDGOALS)))
	$(PLAY) --connection local
else
	$(PLAY)
endif

PH:
.PHONY: $(PH)