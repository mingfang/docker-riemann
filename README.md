docker-riemann
==============
Runs Riemann inside Docker.

Sets up Varnish to proxy both Riemann websocket and Riemann Dashboard.

Use ```build``` to build Docker image.

Use ```shell``` to start the Docker container.

Once inside the container, use ```supervisord&``` to start everything.

Point your browser to http://localhost:49081

On the Dashboard, change the websocket port to 49081 also.
