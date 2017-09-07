# kong
Open-source Microservice &amp; API Management layer built on top of NGINX. debian flavoured

# This is just a simple debian version of the official dockerhub image https://hub.docker.com/_/kong/
This also has a patch for kong to output to standard dockerlogs by using a pipefile


# Changelog
- 0.11.0 added, removed custom patch, removed htpasswd file and auth section, now its basically the same as upstream with logs pushed to STDOUT/STDERR
- Add patch program
- Add htpasswd file
- Add patch to allow basic auth to be enabled on the admin api.
  - By default its disabled, to enable it, set an environment variable: KONG_NGINX_ADMIN_AUTH_BASIC to something other than 'off' which is default, this becomes the sitename
  - The username is admin and the default password is admin, the password can be overwritten using the environment variable: ADMIN_AUTH_PASSWORD
- Add patch to exclude 127.0.0.1 from the password auth for the admin api
- Fix rework patch
