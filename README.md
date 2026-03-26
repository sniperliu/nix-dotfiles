# My dotfiles with nix

```shell
;; First time
$ ./install.sh

;; Upgrade
$ nix flake update
$ ./install.sh

;; Rollback
$ darwin-rebuild --list-generations
$ sudo darwin-rebuild switch --rollback
;; or
$ sudo darwin-rebuild switch --generation 24

;; Cleanup
$ nix-collect-garbage -d

;; apple store
$ mas search App
```
