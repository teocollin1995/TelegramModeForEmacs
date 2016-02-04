# TelegramModeForEmacs
A comint mode for running the telegram cli in emacs. 

## Basics
You need to set the variables telegram-public-key-location and  telegram-cli-file-path: (setq telegram-public-key-location "/home/teodoro/tg/tg-server.pub") and (setq telegram-cli-file-path "/home/teodoro/tg/bin/telegram-cli"). You also need to use load-file to load the file.

You run this with M-x run-telegram.

## Features
Currently, none. Right now, this is nothing more than a way of running telegram in emacs without ansi-term. This is fine and good, but kind of useless. I intend to eventually make this an improvement upon the cli. I will filter the input and output to allow various shortcuts and notifications. E.g., you could set one person as a recipient of a message and only type your messages in instead of "msg target blah blah".

## Todo
