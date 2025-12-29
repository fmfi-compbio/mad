---
title: Screen
---

* TOC
{:toc}

Screen is a command that allows you to have a program running on the
server even if you close the ssh connection (deliberately / by mistake /
due to network problems). It is particularly useful for longer-running
programs.

  - First run command `screen` and press Enter to dismiss the
    introductory information.
  - You will get a new shell (command line) on which you work as usual
  - Once the desired program starts running, you can press `Ctrl+A` and
    then press `D`.
  - This will *detach* the screen and return you to the shell from which
    you executed the screen command. Here you can work normally, the
    program running in screen runs in the background (even if you log
    out from your ssh session).
  - If you want to return to the screen (e.g. after the program finishes
    or to check its progress), run command `screen -r`
  - To terminate the screen, simply end the shell session, e.g. by
    command `exit` or by pressing Ctrl-D.

Other useful options

  - `screen -r -d` will detach screen first if it is attached somewhere
    else.
  - `screen -S some_name` will name your screen so that later you can
    distinguish more easily between different running screens

More information

  - [documentation](https://www.gnu.org/software/screen/manual/screen.html)
  - [Tmux](https://tmux.github.io/) is a more advanced program similar
    to screen

