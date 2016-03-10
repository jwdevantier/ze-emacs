(defvar -ze-mod-deps-lst '())
(defvar -ze-mod-init-fns '())

(defmacro load-path/with-dir (dir &rest body)
  "add a directory to the load-path while processing 'body'."
  (let ((d dir))
    `(progn (add-to-list 'load-path ,d)
	    (progn ,@body)
	    (setq load-path (cdr load-path)))))

(defun -ze-pkg-init ()
  (require 'package)
  (package-initialize)
  (add-to-list 'package-archives
	       '("melpa" . "http://melpa.milkbox.net/packages/") t))

(defun -ze-pkg-install (pkglist)
  "Ensure each pkg in pkglist is installed (install if not)."
  (dolist (p pkglist)
    (when (not (package-installed-p p))
      (unless (boundp '-ze-pkglist-refreshed)
	(progn
	  (message "Missing packages, refreshing package list!")
	  (package-refresh-contents)
	  (setq -ze-pkglist-refreshed t)))
      (package-install p))))

;; include local module name
(defmacro ze-mod-load-old (mod-name)
  "load module"
  (let ((mn (format "ze-%s" mod-name)))
    (let ((init/fn (format "%s/init" mn)))
      `(progn
	 (load-path/with-dir "~/.emacs.d/modules"
			     (require (intern ,mn)))
	 (let ((deps/lst (intern (format "%s/deps" ,mn))))
	   (when (boundp deps/lst)
	     (message (format "is list?: %s" (listp deps/lst)))
	     (message (format "is string?: %s" (stringp deps/lst)))
	     (message (format "is symbol?: %s" (symbolp deps/lst))) ;;true
	     (message (format "val: '%s'" deps/lst))
	     (message (format "sym cmp: '%s'" 'ze-fsharp/deps))
	     (dolist (d "ssas")
	       (message (symbol-name d)))))
	   ;;(setq -ze-mod-deps-lst (append -ze-mod-deps-lst ,(intern-soft ,deps/lst)))
	   ;;(message (format "%s: dependencies detected" ,mn)))
	 (when (fboundp (intern-soft ,init/fn))
	   (add-to-list '-ze-mod-init-fns (intern-soft ,init/fn))
	   (message (format "%s: initialization fn found" ,mn)))))))

(defmacro ze-mod-load (mod-name)
  "load module"
  (let ((mn (format "ze-%s" mod-name)))
    (let ((init/fn (format "%s/init" mn)))
      `(progn
	 (load-path/with-dir "~/.emacs.d/modules"
			     (require (intern ,mn)))
	 (let ((deps/sym (intern (format "%s/deps" ,mn)))
	       (init/sym (intern (format "%s/init" ,mn))))
	   (when (boundp deps/sym)
	     (message (format "%s: dependencies found..." ,mn))
	     (setq -ze-mod-deps-lst (append -ze-mod-deps-lst (symbol-value deps/sym))))
	   (when (fboundp init/sym)
	     (message (format "%s: initialization fn found..." ,mn))
	     (setq -ze-mod-init-fns (add-to-list '-ze-mod-init-fns init/sym t))))))))

(defun ze-init ()
  "initalise ze-emacs - install deps & initialise modules"
  (-ze-pkg-init)
  (-ze-pkg-install -ze-mod-deps-lst)
  (dolist (init-fn -ze-mod-init-fns)
    (funcall (symbol-function init-fn))))

(provide 'ze-pkg)
