# shell.nix

{ pkgs ? import <nixpkgs> { }
}:
let
  LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath [ pkgs.stdenv.cc.cc.lib ];
  env-python = pkgs.python39;
  env-python-with-packages = env-python.withPackages (ps: with ps; [
    # pip
    # wheel
    # Neovim pylsp and tools
    setuptools
    pydocstyle
    python-lsp-server
    pyls-flake8
    # Formatter
    black
    isort
    #python-olm
  ]);

in

pkgs.mkShell {
  name = "python-environment";
  buildInputs = [
    pkgs.stdenv.cc.cc.lib
    env-python
    env-python-with-packages
  ];
  shellHook =
    ''
      function log_header {
        echo -ne "==> \e[32m\e[1m$1\e[0m\n\n"
      }
      function log_subheader {
        echo -ne "--> \e[33m\e[1m$1\e[0m\n\n"
      }
      function log {
        echo -ne "    $1\n"
      }

      # Tells pip to put packages into $PIP_PREFIX instead of the usual locations.
      # See https://pip.pypa.io/en/stable/user_guide/#environment-variables.

      export PIP_PREFIX="$(pwd)/.venv"
      export PYTHONPATH="$PIP_PREFIX/${pkgs.python39.sitePackages}:$PYTHONPATH"
      #PYTHONPATH=${env-python-with-packages}/${env-python-with-packages.sitePackages}

      export PATH="$PIP_PREFIX/bin:$PATH"
      export PIPENV_VENV_IN_PROJECT=1
      export PIP_IGNORE_INSTALLED=1
      export PIP_NO_CACHE_DIR=true
      unset SOURCE_DATE_EPOCH

      echo ""
      log_header "python_environment"
      if [ ! -d .venv ]; then
        python -m venv .venv
      fi
      source .venv/bin/activate
      log_subheader "upgrading pip"
      pip install --upgrade pip
      pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple

      echo ""
      if [ -s requirements.txt ]; then
        log_subheader "found requirements.txt, installing packages"
        pip install -r requirements.txt
        echo ""
      fi
      log_header "package versions"
      log "$(python --version)"
      log "$(pip --version)"
      log "Start developing...";
    '';
}
