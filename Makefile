default: all

setup:
	./setup.sh

update:
	nix flake update
	nix flake archive

format:
	nixpkgs-fmt ./

deploy:
	NIX_BUILD_FLAGS="--no-check" nix build .#darwinConfigurations.tony.system  --show-trace\
	  --extra-experimental-features 'nix-command flakes'
	./result/sw/bin/darwin-rebuild switch --flake .#tony

deploy-debug:
	NIX_BUILD_FLAGS="--no-check" nix build .#darwinConfigurations.tony.system \
	  --extra-experimental-features 'nix-command flakes' --show-trace
	./result/sw/bin/darwin-rebuild switch --flake --show-trace .#tony

gc:
	nix-collect-garbage -d
	sudo nix-collect-garbage -d

clean-build:
	rm -f flake.lock
	rm -f result

clean: clean-build gc

reset:
	defaults write com.apple.dock ResetLaunchPad -bool true
	defaults write com.apple.dock tilesize -integer 48
	defaults write com.apple.dock size-immutable -bool yes
	killall Dock

brewup:
	./brewup.sh

all: format deploy brewup
