;;; telegram.el m -- telegram process in a buffer ;;Adoped from cmuscheme.el 
;;and https://www.masteringemacs.org/article/comint-writing-command-interpreter

;; Author: Teodoro Fields Collin
;; Maintainer: teocollin1995@gmail.com
;; Keywords: telegram, chat

;;; Commenary:

;; Right now this is pretty much just a way of running the telegram cli in emacs  
;;without calling ansi-term or term or shell. It has no extra features. 
;; If you look around, you might see some of what I have planned, but I will add info
;; about that to the README.

;;; Notes
;;; For now, just run-telegram

;;; Code:
(require 'comint)

(defvar telegram-cli-file-path nil)

(defvar telegram-public-key-location nil)

(defvar telegram-cli-arguments (list "-k" telegram-public-key-location))

(defvar telegram-mode-map 
  (let ((map (nconc (make-sparse-keymap) comint-mode-map)))
    
    (define-key map "\t" 'completion-at-point)

    map))

(defvar target-name nil)

(defvar telegram-prompt-regexp "\"^>+ *\"")


(defun target-chat (str) 
  (if target-name  (concat "msg " target-name " " str)
   (str)))

;;a modified version of comint-simple-send
;; I blame the lack of comint documentation. 
(defun telegram-simple-send (proc string)
  "Default function for sending to PROC input STRING.
This just sends STRING plus a newline.  To override this,
set the hook `comint-input-sender'."
  ;;(kill-emacs) just ignore this...
  (let ((send-string
         (if comint-input-sender-no-newline
             (target-chat string)
           ;; Sending as two separate strings does not work
           ;; on Windows, so concat the \n before sending.
           (concat (target-chat string) "\n"))))
    (comint-send-string proc send-string))
  (if (and comint-input-sender-no-newline
	   (not (string-equal string "")))
      (process-send-eof)))

(defun telegram-set-target (target) ;;not yet useful/effectual
  (interactive "Sset target: \s")
  (setq target-name target))

(defun telegram-echo-target () ;;not yet useful/effectual
  (interactive)
  (message "%s" target-name))

(defun run-telegram ()
  "Runs an inferior telegram process, input and output vai buffer *telegram* 
This will create a buffer if it does not exist and switches to if it does.
The cli at telegram-cli-file-path is run with the key at 
telegram-public-key-location."   

  (interactive)
  (let* ((telegram-program telegram-cli-file-path)
	 (buffer (comint-check-proc "*Telegram*")))


    (pop-to-buffer-same-window
     (if (or buffer (not (derived-mode-p 'telegram-mode))
	     (comint-check-proc (current-buffer)))
	 (get-buffer-create (or buffer "*Telegram*"))
       (current-buffer)))

    (unless buffer 
      (apply 'make-comint-in-buffer "Telegram" buffer  telegram-cli-file-path nil (list "-k" telegram-public-key-location)) (telegram-mode))))

(defun telegram--initialize ()
  (setq comint-process-echoes t)
  (setq comint-use-prompt-regexp t))

(define-derived-mode telegram-mode comint-mode "Telegram"
  "Major mode for `run-telegram`

Currently, this is nothing but a way to avoid using ansi-term...
\\<telegram-mode-map>"
  nil "Telegram"
  (setq comit-prompt-regexp telegram-prompt-regexp)
  (setq comint-prompt-read-only t)
  (set comint-process-echoes t)
  (set (make-local-variable 'paragraph-seperate) "\\'")
  (set (make-local-variable 'pargraph-start) telegram-prompt-regexp))

(add-hook 'telegram-mode-hook 'telegram--initialize)
