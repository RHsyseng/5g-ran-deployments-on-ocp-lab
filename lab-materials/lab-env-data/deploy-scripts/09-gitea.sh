#!/bin/bash

mkdir -p /opt/gitea/
chown -R 1000:1000 /opt/gitea/
cat << EOF > /etc/systemd/system/podman-gitea.service
[Unit]
Description=Podman container - Gitea Server
After=network.target

[Service]
Type=simple
WorkingDirectory=/root
TimeoutStartSec=300
ExecStartPre=-/usr/bin/podman rm -f gitea
ExecStart=podman run --name gitea --hostname infra.5g-deployment.lab -e USER_UID=1000 -e USER_GID=1000 -e GITEA__server__ROOT_URL=http://infra.5g-deployment.lab:3000 -e GITEA__server__SSH_PORT=2222 -e GITEA__server__SSH_LISTEN_PORT=22 -e GITEA__service__DISABLE_REGISTRATION=true -e GITEA__security__SECRET_KEY=97Vy1tGr1Ds5X9GVgbEdYuVx7CkGdoWam6fIRVgeKptAcLVB4Dg3DSVdmXAKz7et -e GITEA__security__INTERNAL_TOKEN=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJuYmYiOjE2NjkzODk4MjB9.h-Pr9FEOUZTYEuZeH1oajUMw7dtwNopiiSfwtNB36vk -e GITEA__security__INSTALL_LOCK=true -p 3000:3000 -p 2222:22 -v /opt/gitea/:/data:Z -v /etc/localtime:/etc/localtime:ro docker.io/gitea/gitea:1.17.3
ExecStop=-/usr/bin/podman rm -f gitea
Restart=always
RestartSec=30s
StartLimitInterval=60s
StartLimitBurst=99

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable podman-gitea --now

until [ "`podman inspect -f {{.State.Running}} gitea`" == "true" ]; do
    sleep 5
done

podman exec --user 1000 gitea /bin/sh -c 'gitea admin user create --username student --password student --email student@5g-deployment.lab --must-change-password=false --admin'
curl -u 'student:student' -H 'Content-Type: application/json' -X POST --data '{"service":"2","clone_addr":"https://github.com/RHsyseng/5g-ran-deployments-on-ocp-lab.git","uid":1,"repo_name":"5g-ran-deployments-on-ocp-lab"}' http://infra.5g-deployment.lab:3000/api/v1/repos/migrate
curl -u 'student:student' -H 'Content-Type: application/json' -X POST --data '{"service":"2","clone_addr":"https://github.com/ewsiegel/aap-integration-tools.git","uid":1,"repo_name":"aap-integration-tools"}' http://infra.5g-deployment.lab:3000/api/v1/repos/migrate
