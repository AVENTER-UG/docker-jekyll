This Docker image will clone your jekyll GIT Repo, "compile" your website via jekyll and publish it via nginx. Important to know is, if you use bundle, this image will see it and use it too.

If you want to use this docker image via Mesos, here is a small example of a marathon json file.

{
  "id": "/homepages/<HOMEPAGENAME>",
  "cmd": null,
  "cpus": 0.2,
  "mem": 200,
  "disk": 0,
  "instances": 1,
  "container": {
    "type": "DOCKER",
    "volumes": [],
    "docker": {
      "image": "docker.io/avhost/jekyll",
      "network": "BRIDGE",
      "portMappings": [
        {
          "containerPort": 8888,
          "hostPort": 0,
          "protocol": "tcp",
          "labels": {}
        }
      ],
      "privileged": false,
      "forcePullImage": true
    }
  },
  "env": {
    "GIT_REPO": "https://github.com/<YOUR REPO>
  },
  "labels": {
    "HAPROXY_0_REDIRECT_TO_HTTPS": "true",
    "HAPROXY_GROUP": "external",
    "HAPROXY_0_VHOST": "aventer.<MESOS DOMAIN>
  }
}

