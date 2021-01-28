#!/bin/bash
# debug packer build from local

dir_repo_root="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

packer build -var-file ${dir_repo_root}/packer/packer-var-file.json ${dir_repo_root}/packer/packer.json
