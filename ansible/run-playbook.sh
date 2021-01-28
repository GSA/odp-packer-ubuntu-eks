#!/bin/bash

dir_here="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
dir_repo_root="$( dirname ${dir_here} )"

ansible-galaxy install -r requirements.yml
ansible-playbook ${dir_here}/playbook.yml
