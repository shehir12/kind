/*
Copyright 2019 The Kubernetes Authors.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/

package docker

import (
	"github.com/pkg/errors"
	"sigs.k8s.io/kind/pkg/exec"
)

// ImageInspect return low-level information on containers images
func ImageInspect(containerNameOrID, format string) ([]string, error) {
	cmd := exec.Command("docker", "image", "inspect",
		"-f", format,
		containerNameOrID, // ... against the container
	)

	return exec.CombinedOutputLines(cmd)
}

// ImageID return the Id of the container image
func ImageID(containerNameOrID string) (string, error) {
	lines, err := ImageInspect(containerNameOrID, "{{ .Id }}")
	if err != nil {
		return "", err
	}
	if len(lines) != 1 {
		return "", errors.Errorf("Docker image ID should only be one line, got %d lines", len(lines))
	}
	return lines[0], nil
}
