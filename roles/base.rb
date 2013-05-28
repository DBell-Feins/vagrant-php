name 'base'
description 'Role to install base packages: apt, build-essential, openssl, git, node.js, and npm'

run_list 'recipe[apt]',
          'recipe[build-essential]',
          'recipe[openssl]',
          'recipe[git]',
          'recipe[nodejs]',
          'recipe[nodejs::npm]'