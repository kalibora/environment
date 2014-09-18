;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; .emacs
;;;

;---------------------------------------------------
; 端末のwindowにタイトルを表示させたいんだけどうまくいかないのでコメントアウト
;---------------------------------------------------
;(setq title '("%b  "
;       (buffer-file-name "::%f")))
;(setq frame-title-format '("%b  "
;                           (buffer-file-name "::%f")))
;(setq icon-title-format  '("%b  "
;                           (buffer-file-name "::%f")))

;---------------------------------------------------
; metaキーの変更 for cocoa emacs
; command キーと Option キーの動作を逆に
;---------------------------------------------------
(setq ns-command-modifier (quote meta))
(setq ns-alternate-modifier (quote super))

;---------------------------------------------------
; load-path
;---------------------------------------------------
(setq load-path (cons "~/.elisp/" load-path))

;---------------------------------------------------
; package
; See: http://emacs-jp.github.io/packages/package-management/package-el.html
;---------------------------------------------------
(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/"))
(add-to-list 'package-archives  '("marmalade" . "http://marmalade-repo.org/packages/"))
(package-initialize)

(defun pkgupdate ()
  (interactive)

  ;; パッケージ情報の更新
  (package-refresh-contents)

  ;; インストールするパッケージ
  (defvar my/favorite-packages
    '(
      go-mode
      web-mode
      php-mode
      color-moccur
      jinja2-mode
      markdown-mode
      yaml-mode
      ))

  ;; my/favorite-packagesからインストールしていないパッケージをインストール
  (dolist (package my/favorite-packages)
    (unless (package-installed-p package)
      (package-install package)))
  )

;---------------------------------------------------
; alist
;---------------------------------------------------
(add-to-list 'auto-mode-alist '("\\.tpl\\'" . php-mode))
(add-to-list 'auto-mode-alist '("\\.phpt\\'" . php-mode))
(add-to-list 'auto-mode-alist '("\\.js\\'" . javascript-mode))
(add-to-list 'auto-mode-alist '("\\.conf\\'" . shell-script-mode))
(add-to-list 'auto-mode-alist '("\\.SQL\\'" .  sql-mode))
(add-to-list 'auto-mode-alist '("\\.mod\\'" .  sgml-mode))
(add-to-list 'auto-mode-alist '("\\.yml$" .    yaml-mode))
(add-to-list 'auto-mode-alist '("\\.md$" .     markdown-mode))
(add-to-list 'auto-mode-alist '("\\.twig$" .   web-mode))
(add-to-list 'vc-handled-backends 'SVN)

;---------------------------------------------------
; ChangeLog のためにユーザ名などを設定
;---------------------------------------------------
(setq user-full-name "kalibora")
(setq user-mail-address "kalibora@gmail.com")

;---------------------------------------------------
; BackSpaceキーを普通に使えるように
;---------------------------------------------------
(load "term/bobcat")

;---------------------------------------------------
; diredでRETでも新規バッファを開かない
; see http://www.pshared.net/diary/20071207.html
;---------------------------------------------------
(require 'dired)
(put 'dired-find-alternate-file 'disabled nil)
(define-key dired-mode-map (kbd "RET") 'dired-find-alternate-file)
(define-key dired-mode-map "a" 'dired-advertised-find-file)

;(add-hook 'dired-mode-hook
;          '(lambda ()
;             (define-key dired-mode-map (kbd "RET")
;               'dired-find-alternate-file)))

;---------------------------------------------------
; MemoLogのときだけ曜日を入れる
;---------------------------------------------------
(defvar change-log-diary-file-name-regexp "/MemoLog$")
(defun add-log-iso8601-time-string-with-weekday ()
  (let ((system-time-locale "C"))
    (concat (add-log-iso8601-time-string)
            " " "(" (format-time-string "%a") ")")))
(add-hook 'change-log-mode-hook
          (function
           (lambda ()
             (if (string-match change-log-diary-file-name-regexp
                               (buffer-file-name))
                 (set (make-local-variable 'add-log-time-format)
                      'add-log-iso8601-time-string-with-weekday)))))

;---------------------------------------------------
; C-x M でメモを記録できるようにする
;---------------------------------------------------
(defun memo ()
  (interactive)
    (add-change-log-entry
     nil
     (expand-file-name "~/MemoLog")))
(define-key ctl-x-map "M" 'memo)

;---------------------------------------------------
; 行末の折り返し
;---------------------------------------------------
(defun truncate-lines-on ()
  (interactive)
  (setq-default truncate-lines t)
  (setq-default truncate-partial-width-windows t))

(defun truncate-lines-off ()
  (interactive)
  (setq-default truncate-lines nil)
  (setq-default truncate-partial-width-windows nil))

;---------------------------------------------------
; 日本語
;---------------------------------------------------
(defun eucjp ()
  (interactive)
  (set-language-environment "Japanese")
  (set-default-coding-systems 'euc-jp-unix)
  (set-terminal-coding-system 'euc-jp-unix)
  (set-keyboard-coding-system 'euc-jp-unix)
  (set-buffer-file-coding-system 'euc-jp-unix)
  (setq default-buffer-file-coding-system 'euc-jp-unix))

(defun utf8 ()
  (interactive)
  (set-language-environment "Japanese")
  (set-default-coding-systems 'utf-8-unix)
  (set-terminal-coding-system 'utf-8-unix)
  (set-keyboard-coding-system 'utf-8-unix)
  (set-buffer-file-coding-system 'utf-8-unix)
  (setq default-buffer-file-coding-system 'utf-8-unix))

;(eucjp)
(utf8)

; charset と coding-system の優先度設定
; See http://nijino.homelinux.net/emacs/emacs23-ja.html
(set-charset-priority 'ascii 'japanese-jisx0208 'latin-jisx0201
                      'katakana-jisx0201 'iso-8859-1 'cp1252 'unicode)
(set-coding-system-priority 'utf-8 'euc-jp 'iso-2022-jp 'cp932)

; See http://www.sakito.com/2010/05/mac-os-x-normalization.html
(require 'ucs-normalize)
(setq file-name-coding-system 'utf-8-hfs-unix)
(setq locale-coding-system 'utf-8-hfs-unix)
;---------------------------------------------------
; モード切り替え
;---------------------------------------------------
(defun m-php ()
  (interactive)
  (php-mode)
  (ac-mode)
)
(defun m-js ()
  (interactive)
  (javascript-mode)
  (ac-mode)
)
(defun m-html ()
  (interactive)
  (html-mode)
  (ac-mode)
)

;---------------------------------------------------
; バックアップファイルの設定
;---------------------------------------------------
; バックアップファイルを作らない
(setq make-backup-files nil)

; cvsのバックアップファイルも作らない
(defadvice vc-before-save
  (around examine-vc-make-backup-files activate)
  "examine `vc-make-backup-files' (in vc-hooks.el) at first"
  (and vc-make-backup-files ad-do-it))

; バックアップファイルを~/bak/以下に作成する
;(setq make-backup-files-t)
;(setq backup-directory-alist
;      (cons (cons "\\.*$" (expand-file-name "~/bak"))
;      backup-directory-alist))

;---------------------------------------------------
; auto insert
;---------------------------------------------------
(add-hook 'find-file-hooks 'auto-insert)
(setq auto-insert-directory "~/.elisp/insert/")
(load "autoinsert")
(setq auto-insert-alist
      (append
       '(
         ("\\.html$" . "insert.html")
         ("\\.pl$" . "insert.pl")
         ("\\.class.php$" . "insert.class.php")
         ("\\.php$" . "insert.php")
         ("\\.inc$" . "insert.php")
         (html-mode . "insert.html")
         (php-mode . "insert.php")
         (perl-mode . "insert.pl")
         )
       auto-insert-alist))

;---------------------------------------------------
; defaultタブ幅
;---------------------------------------------------
(setq default-tab-width 4)
(setq-default indent-tabs-mode nil)

(defun tab2 ()

  (interactive)
  (setq indent-tabs-mode nil)
  (setq tab-width 2)
  (setq c-basic-offset 2)
  (setq javascript-indent-level 2))

(defun tab4 ()
  (interactive)
  (setq indent-tabs-mode nil)
  (setq tab-width 4)
  (setq c-basic-offset 4)
  (setq javascript-indent-level 4))

;---------------------------------------------------
; c-mode のタブ幅
;---------------------------------------------------
(add-hook 'c-mode-common-hook
          '(lambda ()
             (c-set-style "k&r")
             (progn
               (setq tab-width 4)
               (setq c-basic-offset 4 indent-tabs-mode nil))))

;---------------------------------------------------
; ruby-mode
;---------------------------------------------------
(autoload 'ruby-mode "ruby-mode" "Mode for editing ruby source files" t)
(setq auto-mode-alist
      (append '(("\\.rb$" . ruby-mode)) auto-mode-alist))
(setq interpreter-mode-alist (append '(("^#!.*ruby" . ruby-mode))  interpreter-mode-alist))

;---------------------------------------------------
; javascript-mode
;---------------------------------------------------
(autoload 'javascript-mode "javascript" nil t)
(setq javascript-indent-level 2)

;---------------------------------------------------
; yaml-mode
;---------------------------------------------------
(require 'yaml-mode)

;---------------------------------------------------
; html-mode
;---------------------------------------------------
(add-hook 'html-mode-hook
          (lambda ()
            (setq sgml-basic-offset 1)))

;---------------------------------------------------
; jinja2-mode
;---------------------------------------------------
(require 'jinja2-mode)

;---------------------------------------------------
; web-mode
; See: http://web-mode.org/
;---------------------------------------------------
(setq web-mode-markup-indent-offset 2)
(setq web-mode-css-indent-offset 2)
(setq web-mode-code-indent-offset 2)
(setq web-mode-style-padding 2)
(setq web-mode-script-padding 2)
(setq web-mode-block-padding 0)
(setq web-mode-comment-style 2)

;---------------------------------------------------
; php-mode
;---------------------------------------------------
(require 'php-mode)
(add-hook 'php-mode-hook
          '(lambda ()
             (c-set-offset 'case-label '+)
             (c-set-offset 'arglist-intro '+)
             (c-set-offset 'arglist-cont 0)
             (c-set-offset 'arglist-cont-nonempty '+)
             (c-set-offset 'arglist-close 0)
             (setq tab-width 4)
             (setq c-basic-offset 4)
             (setq indent-tabs-mode nil)
             (php-enable-symfony2-coding-style)
             (subword-mode 1)
             )
          )

(custom-set-variables '(php-executable "/usr/bin/env/ php"))
; pearのコーディング規約に沿った設定
;(defun php-mode-hook ()
;  (setq tab-width 4
; c-basic-offset 4
;        c-hanging-comment-ender-p nil
; indent-tabs-mode
; (not
;  (and (string-match "/\\(PEAR\\|pear\\)/" (buffer-file-name))
;       (string-match "\.php$" (buffer-file-name))))))

;---------------------------------------------------
; markdown-mode
;---------------------------------------------------
(autoload 'markdown-mode "markdown-mode.el" "Major mode for editing Markdown files" t)

;---------------------------------------------------
; 行番号表示 wb-line-number
;---------------------------------------------------
;(set-scroll-bar-mode nil)
;(require 'wb-line-number)
;(setq truncate-partial-width-windows nil)
;(setq wb-line-number-scroll-bar nil)
;(setq wb-line-number-text-width 6)
;(wb-line-number-toggle)

;---------------------------------------------------
; psvn
;---------------------------------------------------
(require 'psvn)

;---------------------------------------------------
; ac-mode
;  http://komatsu.webmasters.gr.jp/elisp/ac-mode/
;---------------------------------------------------
(load "ac-mode")
(setq ac-mode-exception '(dired-mode hex-mode))
(add-hook 'find-file-hooks 'ac-mode-without-exception)
(setq ac-mode-goto-end-of-word t)

;---------------------------------------------------
; kill-summary
; カーソルキーで選択してSPACEでyankなど
;---------------------------------------------------
(autoload 'kill-summary "kill-summary" nil t)
(global-set-key "\M-y" 'kill-summary)

;---------------------------------------------------
; Dynamic Macro
;---------------------------------------------------
(defconst *dmacro-key* "\C-t" "繰返し指定キー")
(global-set-key *dmacro-key* 'dmacro-exec)
(autoload 'dmacro-exec "dmacro" nil t)

;---------------------------------------------------
; マークした箇所の可視化
;---------------------------------------------------
(setq-default transient-mark-mode t)

;---------------------------------------------------
; hs-minor-mode
;---------------------------------------------------
(load-library "hideshow")
(add-hook 'c-mode-common-hook
          '(lambda () (hs-minor-mode 1)))
(eval-after-load "hideshow"
  '(define-key c-mode-base-map "\C-\M-x" 'hs-toggle-hiding))

;---------------------------------------------------
; wdired
;---------------------------------------------------
(require 'wdired)
(define-key dired-mode-map "r" 'wdired-change-to-wdired-mode)

;---------------------------------------------------
; タブ, 全角スペースに色を付ける
;---------------------------------------------------
(defface my-face-b-1 '((t (:background "white"))) nil)
(defface my-face-b-2 '((t (:background "blue"))) nil)
;(defface my-face-u-1 '((t (:foreground "SteelBlue" :underline t))) nil)
(defface my-face-u-1 '((t (:foreground "cyan" :underline t))) nil)
(defvar my-face-b-1 'my-face-b-1)
(defvar my-face-b-2 'my-face-b-2)
(defvar my-face-u-1 'my-face-u-1)

(defadvice font-lock-mode (before my-font-lock-mode ())
  (font-lock-add-keywords
   major-mode
   '(("\t" 0 my-face-b-2 append)
     ("　" 0 my-face-b-1 append)
     ("[ \t]+$" 0 my-face-u-1 append)
     )))
(ad-enable-advice 'font-lock-mode 'before 'my-font-lock-mode)
(ad-activate 'font-lock-mode)

;---------------------------------------------------
; moccur
;---------------------------------------------------
(require 'color-moccur)
(load "moccur-edit")
(setq dmoccur-exclusion-mask
      (append '("\\~$" "\\.svn\\/\*") dmoccur-exclusion-mask))

;;; moccur-grep-find のキーバインド
(global-set-key "\M-\C-m" 'moccur-grep-find)

;---------------------------------------------------
; find-fileのファイル名補完で大文字小文字を区別しない設定
;---------------------------------------------------
(setq read-file-name-completion-ignore-case t)

;---------------------------------------------------
; 同名のファイルを開いたとき Switch to buffer などで
; ファイル名がわかりやすく見えるようになる設定
;---------------------------------------------------
(require 'uniquify)
(setq uniquify-buffer-name-style 'post-forward-angle-brackets)

;---------------------------------------------------
; 一括置換 grep-edit
;---------------------------------------------------
;なんかうまくいかないのでコメントアウト
;(require 'grep-edit)

;---------------------------------------------------
; gdb
;---------------------------------------------------
(setq gdb-many-windows t)
(setq gdb-use-separate-io-buffer t)

;---------------------------------------------------
; sense-region
; 普通のリージョン指定と矩形指定を交互に切り替えられる
; http://taiyaki.org/elisp/sense-region/
;---------------------------------------------------
(autoload 'sense-region-on "sense-region"
  "System to toggle region and rectangle." t nil)
(sense-region-on)

;---------------------------------------------------
; ウインドウのサイズ
;---------------------------------------------------
(if window-system (progn
 (setq initial-frame-alist '((width . 85) (height . 60)))))

;---------------------------------------------------
; flymake (Emacs22から標準添付されている)
; see http://openlab.dino.co.jp/wp-content/uploads/2008/08/dot-emacs.txt
; see http://openlab.dino.co.jp/2008/08/05/223548324.html
;---------------------------------------------------
(when (require 'flymake nil t)
  (global-set-key "\C-cd" 'flymake-display-err-menu-for-current-line)
  ;; PHP用設定
  (when (not (fboundp 'flymake-php-init))
    ;; flymake-php-initが未定義のバージョンだったら、自分で定義する
    (defun flymake-php-init ()
      (let* ((temp-file   (flymake-init-create-temp-buffer-copy
                           'flymake-create-temp-inplace))
             (local-file  (file-relative-name
                           temp-file
                           (file-name-directory buffer-file-name))))
        (list "php" (list "-f" local-file "-l"))))
    (setq flymake-allowed-file-name-masks
          (append
           flymake-allowed-file-name-masks
           '(("\\.php[345]?$" flymake-php-init)
             ("\\.inc$" flymake-php-init))))
    (setq flymake-err-line-patterns
          (cons
           '("\\(\\(?:Parse error\\|Fatal error\\|Warning\\): .*\\) in \\(.*\\) on line \\([0-9]+\\)" 2 3 nil 1)
           flymake-err-line-patterns)))
  ;; JavaScript用設定
  (when (not (fboundp 'flymake-javascript-init))
    ;; flymake-javascript-initが未定義のバージョンだったら、自分で定義する
    (defun flymake-javascript-init ()
      (let* ((temp-file (flymake-init-create-temp-buffer-copy
                         'flymake-create-temp-inplace))
             (local-file (file-relative-name
                          temp-file
                          (file-name-directory buffer-file-name))))
        ;;(list "js" (list "-s" local-file))
        (list "jsl" (list "-process" local-file))
        ))
    (setq flymake-allowed-file-name-masks
          (append
           flymake-allowed-file-name-masks
           '(("\\.json$" flymake-javascript-init)
             ("\\.js$" flymake-javascript-init))))
    (setq flymake-err-line-patterns
          (cons
           '("\\(.+\\)(\\([0-9]+\\)): \\(?:lint \\)?\\(\\(?:warning\\|SyntaxError\\):.+\\)" 1 2 nil 3)
           flymake-err-line-patterns)))
  (add-hook 'php-mode-hook
            '(lambda() (flymake-mode t)))
  (add-hook 'javascript-mode-hook
            '(lambda() (flymake-mode t))))

;---------------------------------------------------
; 保存できない文字を置換
; リージョンを選択し，M-x my-check-encode-ableとすると，
; 保存できない文字を順番に置換か削除していくことができます．
; バッファ全体は C-x h M-x my-check-encode-able
;---------------------------------------------------
(defun my-check-encode-able (beg end)
  (interactive "r")
  (save-excursion
    (let* (
           (mycodingsystem buffer-file-coding-system)
           mychar
           mycharname
           (mycount 0)
          ;;;encoding に対応する charset のリストを取得する。
          ;;;Meadow2 (Emacs21) でも動くかどうか未確認
          ;;;うまくいかなければ、自分で対応を定義すれば良い
           (mycharsetlist (coding-system-get mycodingsystem 'safe-charsets))
           )
      (goto-char beg) ;;;リージョンの先頭に移動
      (while (< (point) end) ;;;リージョン内を順に調べる
        (setq mychar (following-char))
        (setq mycharsetname (char-charset mychar))
        ;;合成文字に対する処理。 Meadow2 (Emacs21) では不要かも????
        (if (equal 'composition mycharsetname)
            (setq mycharsetname
                  (char-charset (string-to-char
                                 (decompose-string (char-to-string mychar))))))
        ;;encode できない文字だったら色をつける
        (if (or (equal mycharsetlist t) (member mycharsetname mycharsetlist))
            nil ;;;encode できる時は何もしない。 encode できない時↓
          (if (y-or-n-p (format "Delete %s?" (buffer-substring-no-properties
                                              (point) (1+ (point)))))
              (delete-region (point) (1+ (point)))
            (delete-region (point) (1+ (point)))
            (insert (read-from-minibuffer "Replace String: "))
            (setq mycount (1+ mycount))))
        (forward-char) ;;;次の文字へ
        )
      ;;結果の表示
      (if (< 0 mycount)
          (message "%s で encode できない文字が%d 個ありました。"
                   mycodingsystem mycount))
      )))


;---------------------------------------------------
; color
;---------------------------------------------------
;;; color-theme
(load "color-theme")
(color-theme-calm-forest)
;(color-theme-lawrence)

;;; 色の設定
;(require 'hilit19)
(global-font-lock-mode t)
;(add-hook 'font-lock-mode-hook
;   '(lambda ()
;      (make-face 'comment-face "bisque1")
;      (setq font-lock-comment-face 'comment-face)
;))

;(setq font-lock-verbose nil)
;(put 'yatex-mode 'font-lock-defaults 'tex-mode)
;(put 'yahtml-mode 'font-lock-defaults 'html-mode)


(put 'upcase-region 'disabled nil)
