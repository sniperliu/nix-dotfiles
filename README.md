# My dotfiles with nix

```shell
;; First time
$ sudo ./install.sh

;; Upgrade
$ sudo nix flake update
$ sudo ./install.sh

;; Rollback
$sudo darwin-rebuild --list-generations
$sudo darwin-rebuild switch --rollback
;; or
$sudo darwin-rebuild switch --generation 24

;; Cleanup
sudo nix-collect-garbage -d

;; apple store
$ mas search App
```
