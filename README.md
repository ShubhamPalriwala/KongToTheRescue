# KongToTheRescue

A Kong API Gateway Plugin that adds an `is-suspicious` header to the response for any potentially harmful requests to the system

As of now, we test for:

- SQL Injection
- XSS (Cross Site Scripting)
- Directory Traversal

Currently we add it to the response header only to verify the legitimacy but later we can add it to the request header itself so that one can discard such requests before even processing them on the server.

## KongToTheRescue Architecture

![KongToTheRescue Architecure](./arch.png)

Currently, the plugin is only used for testing purposes. And has been created while I was exploring Kong.

This repo has 2 branches:

1. master:
   Has the custom plugin code
2. block-ip-plugin:
   Has a simple Lua web server that has been proxied via Kong to block certain IP addresses.

## How to use

### Via Docker Compose:
Run the following command in the `kong-to-the-rescue` directory:
```sh
docker-compose up
```
Now feel free to test out the plugin by accessing [http://localhost:8000/](http://localhost:8000/) and look for the header `is-suspicious` in the response. Happy messing around.

### Via Kong-Pongo

1. Install [Kong-Pongo CLI](https://github.com/Kong/kong-pongo)
2. Clone the repo using `git clone https://github.com/ShubhamPalriwala/KongToTheRescue.git`
3. Get into the project directory `cd KongToTheRescue`
4. Start a pongo shell, run `pongo shell` (if pongo isn't added to the path, then use `~/.local/bin/pongo shell`)
5. Once you are in the pongo shell, run the following scriptx:

```sh
kong migrations bootstrap --force
kong start

# create service
curl -i -X POST \
 --url http://localhost:8001/services/ \
 --data 'name=service-to-my-github' \
 --data 'url=https://shubhampalriwala.github.io/'

# create route
curl -i -X POST \
 --url http://localhost:8001/services/service-to-my-github/routes \
 --data 'hosts[]=mychapter.com'

# add plugin
curl -i -X POST \
 --url http://localhost:8001/services/service-to-my-github/plugins/ \
 --data 'name=kongtotherescue'
```

Now feel free to test out the plugin by accessing [http://localhost:8000/](http://localhost:8000/) and look for the header `is-suspicious` in the response. Happy messing around.

## File Structure

Inside kong/plugins/kongtotherescue, you’ll see two files:

- `handler.lua`: This is where the main functionality of your plugin resides. Each phase of the request/response lifecycle has a function, which the plugin implements to provide custom behavior. Basically the logic of the plugin.
  - plugin:initworker(): This is the first function called when the plugin is loaded and is used to initialize the plugin.
  - plugin:access(): This is the next function that is called when the plugin is loaded and is used to fetch data for our plugin from the request.
  - plugin:header_filter(): This is the next and the last function (for now) that is called when the plugin is loaded and is used to modify the headers of the request as per our requirements.

In handler.lua, one can have several methods that take the form of function plugin:<name>. These methods run during the execution lifecycle of Kong. The complete list of their descriptions in the API reference documentation.

- `schema.lua`: If the plugin requires additional configuration, such as key/value pairs a user can provide to alter behavior, the logic for that is stored here.

PS: I will be wokring on this to make it production ready soon and will release a release.

<p align="center">I hope this plugin will make me more Credible soon enough :)</p>
