# to test our plugin
sudo ~/.local/bin/pongo run

# to start the kong shell
sudo ~/.local/bin/pongo shell

# run inside the kong shell
kong migrations bootstrap --force
kong start

# create service
curl -i -X POST \
 --url http://localhost:8001/services/ \
 --data 'name=service-to-my-github' \
 --data 'url=https://ieeevit.org'

# create route
curl -i -X POST \
 --url http://localhost:8001/services/service-to-my-github/routes \
 --data 'hosts[]=mychapter.com'

# add plugin
curl -i -X POST \
 --url http://localhost:8001/services/service-to-my-github/plugins/ \
 --data 'name=kluaong'

# test
curl -I -H "Host: mychapter.com" http://localhost:8000/