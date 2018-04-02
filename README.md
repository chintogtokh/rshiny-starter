# Shiny Starter

This is a Shiny template based off of [Shiny's KMeans clustering example](https://shiny.rstudio.com/gallery/kmeans-example.html) and [Bootstrap's Jumbotron example](https://getbootstrap.com/docs/4.0/examples/jumbotron/). It includes a Leaflet map and the K-means clustering interactive graph.

Essentially, it's a starter app to create Shiny apps using plain HTML instead of their templating system.

## Getting started

Install the Shiny and Leaflet R packages:

```
install.packages(c('shiny','leaflet'), repos='http://cran.rstudio.com/')
```

This app should work out of the box when running it from RStudio.

![Screenshot](https://raw.githubusercontent.com/chintogtokh/Shiny-starter/master/www/images/screenshot.png)

### Structure
The app is structured as follows:

```
├── README.md
├── data
│   └── test.csv
├── server.R
├── template.html
├── ui.R
└── www
    ├── css
    │   └── css.css
    ├── favicon.ico
    ├── images
    └── js
        └── js.js
```

In general, the `www` directory has the files the webpage will directly call, while the `data` directory is where the data resides, to be processed by R.


### Deployment to Linux

To deploy an R app onto a real Linux server, do the following:

* Install R and Shiny. Assuming you're using Ubuntu, [this tutorial from DigitalOcean](digitalocean.com/community/tutorials/how-to-set-up-shiny-server-on-ubuntu-16-04) is great.
* Install nginx and set up a reverse proxy to map (for example, in the following) the `/shiny` path to the Shiny server.

```
map $http_upgrade $connection_upgrade {
  default upgrade;
  ''      close;
}

server {
   charset utf-8;
   client_max_body_size 128M;
   sendfile off;

   listen 80 default_server; ## listen for ipv4

   root PATH_TO_A_NON-Shiny_APP;

   location / {
      index index.html;
      autoindex on;
   }

   location /shiny/ {
      rewrite ^/shiny/(.*)$ /$1 break;
      proxy_pass http://localhost:3838;
      proxy_redirect http://localhost:3838/ $scheme://$host/shiny/;
      proxy_http_version 1.1;
      proxy_set_header Upgrade $http_upgrade;
      proxy_set_header Connection $connection_upgrade;
      proxy_read_timeout 20d;
      proxy_buffering off;
   }
}
```
* Copy over your code (or this project) to `srv/shiny-server` (the default location, you can change it in the Shiny server configuration in `/etc/shiny-server/shiny-server.conf`) and restart Shiny using `sudo service shiny-server restart`. You should be able to see your site at `http://YOUSITE/shiny/`.

## Notes and Quirks
* Shiny has a quirk whereby if **any inputs or forms are on the page and not used in Shiny** (such as an errant search box), it will completely kill Shiny interactivity. Don't use non-Shiny inputs or forms. See https://groups.google.com/forum/#!topic/shiny-discuss/vd_nB-BH8sw
* Shiny seems to use HTML ids to map its `input$variable_name` variables.
* Shiny already includes jQuery by default, and adding your own jQuery will break the site.

## Links
* [Shiny documentation](https://shiny.rstudio.com/articles/basics.html)
* [Leaflet on Shiny](https://rstudio.github.io/leaflet/shiny.html)
* [JavaScript events](https://shiny.rstudio.com/articles/js-events.html) - these can be used, for example, to show a "Loading" bar when Shiny is processing data. Two example event handlers, just printing to the console, are added in `www/js/js.js`