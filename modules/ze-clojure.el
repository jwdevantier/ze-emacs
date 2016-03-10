(defvar ze-clojure/deps '(clojure-mode cider))
;; TODO - should load clojurescript mode separately
(defun ze-clojure/init ()
  ;; autoload - only load modules in when clojure-mode is requested
  (autoload 'clojure-mode "clojure-mode" "Major mode for editing Clojure code" t)

  ;; ensure .clj/.cljs files trigger clojure-mode
  (add-to-list 'auto-mode-alist '("\\.clj[s]?$" . clojure-mode))

  (eval-after-load 'clojure-mode
    '(progn
       (defun ze-clojure-mode-defaults ()
	 nil)

       (setq ze-clojure-mode-hook 'ze-clojure-mode-defaults)
       (add-hook 'clojure-mode-hook
		 (lambda () (run-hooks 'ze-clojure-mode-hook)))))

  (eval-after-load 'cider
    '(progn
       (setq nrepl-log-messages t)
       (setq nrepl-hide-special-buffers t)

       (defun ze-cider-repl-mode-defaults ()
	 (setq cider-popup-stacktraces nil)
	 (define-key cider-mode-map (kbd "<f4>") 'cider-connect)
	 (define-key cider-mode-map (kbd "<f5>") 'cider-test-run-tests))

       (setq ze-cider-mode-hook 'ze-cider-mode-defaults)
       (add-hook 'cider-mode-hook
		 (lambda () (run-hooks 'ze-cider-mode-hook))))))

(provide 'ze-clojure)
