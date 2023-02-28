#!/bin/bash

URL="http://gocd.gunsmoke.local:31468"

# https://api.gocd.org/current/#create-a-config-repo
ConfigRepo() {
curl $URL'/go/api/admin/config_repos' \
  -H 'Accept:application/vnd.go.cd.v4+json' \
  -H 'Content-Type:application/json' \
  -X POST -d '{
    "id": "synthetic",
    "plugin_id": "yaml.config.plugin",
    "material": {
      "type": "git",
      "attributes": {
        "url": "http://gitea-http.gitea.svc.cluster.local:3000/gitea-admin/SyntheticInfra.git",
        "branch": "main",
        "auto_update": true
      }
    },
    "configuration": [
      {
       "key": "pattern",
       "value": "*.myextension"
     }
    ],
    "rules": [
      {
        "directive": "allow",
        "action": "refer",
        "type": "*",
        "resource": "*"
      }
    ]
  }'
}

# https://api.gocd.org/current/#create-an-elastic-agent-profile
ElasticAgentProfile() {
curl $URL'/go/api/elastic/profiles' \
      -H 'Accept: application/vnd.go.cd.v2+json' \
      -H 'Content-Type: application/json' \
      -X POST -d '{
        "id": "buildah",
        "cluster_profile_id": "k8-cluster-profile",
        "properties": [
          {
            "key": "PodSpecType",
            "value" : "yaml"
          },
          {
            "key": "PodConfiguration",
            "value" : "apiVersion: v1
kind: Pod
metadata:
  name: gocd-agent-buildah
  labels:
    app: web
spec:
  containers:
    - name: gocd-agent-container-buildah
      image: docker.io/jstrohm/gocd-agent-buildah
      env:
        - name: DOCKER_PASSWORD
          valueFrom: 
            secretKeyRef: 
              name: docker-password 
              key: password
      securityContext:
        privileged: true"
          }
        ]
      }'
}

ConfigRepo
ElasticAgentProfile
