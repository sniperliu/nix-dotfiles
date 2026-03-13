;;; init.el --- Summary:
;;; Commentary:
;;; Emacs configs for org & clojure development

;;; Code:
;; Avoid garbage collection at statup
(setq gc-cons-threshold most-positive-fixnum ; 2^61 bytes
      gc-cons-percentage 0.6)

;; All the settings and package installation is set in configuration.org
(org-babel-load-file (expand-file-name "configuration.org"
                                       user-emacs-directory))

(add-hook 'emacs-startup-hook
  (lambda ()
    (setq gc-cons-threshold 300000000 ; 300mb
          gc-cons-percentage 0.1)))

(provide 'init)
;;; init.el ends here
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("95ee4d370f4b66ff2287d8075f8fe5f58c4a9b9c1e65d663b15174f1a8c57717"
     "84d2f9eeb3f82d619ca4bfffe5f157282f4779732f48a5ac1484d94d5ff5b279"
     "c74e83f8aa4c78a121b52146eadb792c9facc5b1f02c917e3dbb454fca931223"
     default))
 '(package-selected-packages
   '(ag ai-code beacon beancount cargo clay clj-refactor clojure-snippets
        company corfu counsel dockerfile-mode edts elfeed
        embark-consult exec-path-from-shell expand-region fic-mode
        fill-column-indicator flx flycheck-joker flycheck-rust
        git-gutter go-mode gotest gradle-mode helm-bibtex
        helm-descbinds helm-lsp helm-projectile htmlize
        ido-vertical-mode inf-clojure lsp-ivy lsp-java lsp-ui magit
        marginalia markdown-preview-mode nix-mode orderless
        org-bullets org-contrib org-noter org-roam ox-reveal pdf-tools
        plantuml-mode rainbow-delimiters rustic sbt-mode scala-mode
        smart-mode-line-powerline-theme smex toml-mode undo-tree
        vertico vterm wgsl-mode yaml-mode yasnippet-snippets
        zenburn-theme)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
