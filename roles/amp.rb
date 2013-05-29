name 'amp'
description 'Role to install AMP stack: apache2, mysql, php, and xml'

run_list 'recipe[apache2]',
          'recipe[apache2::mod_expires]',
          'recipe[apache2::mod_php5]',
          'recipe[apache2::mod_rewrite]',
          'recipe[mysql::server]',
          'recipe[database::mysql]',
          'recipe[php]',
          'recipe[xml]',
          'recipe[phpplugins]',
          'recipe[phpapacheconf]'