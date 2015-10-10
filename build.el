 (defun ciob (mnemonic compileCommand)
   (let* (
          (kill-buffer-query-functions '())
          (compilation-buffer-name (format "*compilation* %s" mnemonic) )
          (compilation-buffer-name-function (lambda (x) compilation-buffer-name) ))
     (if (get-buffer compilation-buffer-name)
         (kill-buffer compilation-buffer-name))
     (compile compileCommand)))

(defun numpties () (ciob "numpties" "cd ~/repos/qix && dub --force --config=numpties"))
(defun numpties2 () (ciob "numpties2" "cd ~/repos/qix && dub --force --config=numpties"))

(defun qix      () (ciob "qix"      "cd ~/repos/qix && dub --force --config=qix"))
(defun ttf      () (ciob "ttf"      "cd ~/repos/qix && dub --force --config=ttf"))
(defun vortex   () (ciob "vortex"   "cd ~/repos/qix && dub --force --config=vortex"))
(defun platform () (ciob "platform" "cd ~/repos/qix && dub --force --config=platform"))

(numpties)

(numpties2)

(qix)
(ttf)
(vortex)
(platform)
