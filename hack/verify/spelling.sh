#!/usr/bin/env bash
# Copyright 2019 The Kubernetes Authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set -o errexit
set -o nounset
set -o pipefail

# cd to the repo root
REPO_ROOT=$(git rev-parse --show-toplevel)
cd "${REPO_ROOT}"

# enable modules and the proxy cache
export GO111MODULE="on"
GOPROXY="${GOPROXY:-https://proxy.golang.org}"
export GOPROXY

# build staticcheck
BINDIR="${REPO_ROOT}/bin"
# use the tools module
cd "hack/tools"
go build -o "${BINDIR}/misspell" github.com/client9/misspell/cmd/misspell
# go back to the root
cd "${REPO_ROOT}"

# check spelling
# NOTE add 'error' to each line to highlight in e2e status
git ls-files | grep -v -e "vendor\|go.\(sum\|mod\)" | xargs "${BINDIR}/misspell" -error | sed 's/^/error: /'
