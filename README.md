# Docker image to use jekyll


This Docker image will clone your jekyll GIT Repo, "compile" your website via jekyll and publish it via nginx. Important to know is, if you use bundle, this image will see it and use it too.

## How to use?

```bash
docker run p 80:8888 -e GIT_REPO=https://<MY_GIT_REPO_WITH_THE_JEKYLL_WEBSITE> avhost/docker-jekyll:latest
```

To use TLS please you a TLS Proxy.


