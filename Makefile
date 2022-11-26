SHELL := bash

.PHONY: update
update:
	@$(CURDIR)/scripts/update.sh

.PHONY: switch
switch:
	NIXPKGS_ALLOW_UNFREE=1 darwin-rebuild switch --impure --flake .\#tony
