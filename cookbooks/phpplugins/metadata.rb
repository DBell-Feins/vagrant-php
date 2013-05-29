name          "phpplugins"
maintainer        "Dave Bell-Feins"
maintainer_email  "David_Bell-Feins@abtassoc.com"
license           "Apache 2.0"
description       "Installs various PHP plugins including"
version           "1.0"
recipe            "php-plugins", "Installs all configurations"

depends "apache2"
depends "php"
depends "mysql"

attribute "phpplugins/cypher",
  :display_name => "Blowfish_secret key",
  :description => "A blowfish encrypted string to do cookie auth for PHPMyAdmin.",
  :default => "xV66(E1Ra+|]E3}_MKULXBh+mSP%6v8w[d6z6G[f"