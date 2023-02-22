#!/bin/bash

token=`curl -H "Content-Type: application/json" -d '{"name":"initial-setup"}' -u gitea-admin:admin http://gitea.gunsmoke.local:31468/api/v1/users/gitea-admin/tokens | tr ',' '\n' | grep sha1 | cut -f2 -d':' | cut -f2 -d'"'`

curl -X 'POST' \
  'http://gitea.gunsmoke.local:31468/api/v1/repos/migrate' \
  -H "Authorization: token $token" \
  -H 'accept: application/json' \
  -H 'Content-Type: application/json' \
  -d "{
  \"auth_password\": \"admin\",
  \"auth_token\" : \"$token\",
  \"auth_username\": \"gitea-admin\",
  \"clone_addr\": \"https://github.com/hoyle1974/synthetic_infra.git\",
  \"description\": \"Github Synthetic Infra\",
  \"issues\": true,
  \"labels\": true,
  \"lfs\": true,
  \"lfs_endpoint\": \"string\",
  \"milestones\": true,
  \"mirror\": true,
  \"mirror_interval\": \"10m0s\",
  \"private\": false,
  \"pull_requests\": true,
  \"releases\": true,
  \"repo_name\": \"SyntheticInfra\",
  \"repo_owner\": \"gitea-admin\",
  \"service\": \"git\",
  \"uid\": 0,
  \"wiki\": true
}"
