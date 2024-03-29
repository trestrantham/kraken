exports.config = {
  // See http://brunch.io/#documentation for docs.
  files: {
    javascripts: {
      joinTo: "js/app.js",
      order: {
        before: [
          "web/static/vendor/js/jquery-2.1.4.min.js",
          "web/static/vendor/js/jquery.nicescroll.min.js",
          "web/static/vendor/js/tether.min.js",
          "web/static/vendor/js/bootstrap.min.js",
          "web/static/vendor/js/bootstrap-select.min.js",
        ]
      }
    },
    stylesheets: {
      joinTo: "css/app.css",
      order: {
        before: [
          "web/static/vendor/css/bootstrap.min.css",
          "web/static/vendor/css/bootstrap-select.min.css",
          "web/static/vendor/css/animate.min.css",
        ]
      }
    },
    templates: {
      joinTo: "js/app.js"
    }
  },

  conventions: {
    // This option sets where we should place non-css and non-js assets in.
    // By default, we set this to "/web/static/assets". Files in this directory
    // will be copied to `paths.public`, which is "priv/static" by default.
    assets: /^(web\/static\/assets)/
  },

  // Phoenix paths configuration
  paths: {
    // Dependencies and current project directories to watch
    watched: [
      "web/static",
      "test/static"
    ],

    // Where to compile files to
    public: "priv/static"
  },

  // Configure your plugins
  plugins: {
    babel: {
      presets: ["es2015", "react"],
      // Do not use ES6 compiler in vendor code
      ignore: [/web\/static\/vendor/]
    }
  },

  modules: {
    autoRequire: {
      "js/app.js": ["web/static/js/app"]
    }
  },

  npm: {
    enabled: true,
    whitelist: ["phoenix", "phoenix_html", "react", "react-dom", "underscore.string"]
  }
};
