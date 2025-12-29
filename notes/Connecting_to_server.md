---
title: Connecting to server
---

* TOC
{:toc}

In the course, you will be working on a Linux server. You can connect to
this server via `ssh`, using the same **username and password as for
AIS2**. In the computer classroom at the faculty, we recommend
connecting to the server from Linux.

## Connection through ssh

If connecting **from a Linux computer**, open a console (command-line
window) and run:

    ssh your_username@vyuka.compbio.fmph.uniba.sk -XC

The server will prompt you for **password**, but it will not display
anything while you type. Just type your password and press Enter.

If connecting from a **Windows 10 or Windows 11 computer**, open
command-line window in Ubuntu subsystem for Windows or Powershell or
cmd.exe Command Prompt and run

    ssh your_username@vyuka.compbio.fmph.uniba.sk

When prompted, type your password and press Enter, as for Linux. See
also more detailed instructions here
[1](https://support.cci.drexel.edu/cci-virtual-lab-resources/scp-or-ssh-or-sftp-gui-or-cli/scp-windows-10-powershell-cli-command-line-interface/)
or here
[2](https://www.howtogeek.com/336775/how-to-enable-and-use-windows-10s-built-in-ssh-commands/).

For Windows, this command allows text-only connection, which is
sufficient for most of the course. To enable support for graphics
applications, follow the instructions in the next section.

## Installation of X server on Windows

This is not needed for Linux, just use -XC option in ssh.

To use applications with GUIs, you need to tunnel X-server commands from
the server to your local machine (this is accomplished by your ssh
client), and you need a program that can interpret these commands on you
local machine (this is called X server).

  - Install [putty
    client](https://www.chiark.greenend.org.uk/~sgtatham/putty/latest.html)
    which you will use instead of ssh.
  - Install X server, such as
    [xming](https://sourceforge.net/projects/xming/)
  - Make sure that X server is running (you should have "X" icon in your
    app control bar)
  - Run putty, connect using ssh connection type and in your settings
    choose Connection-\>SSH-\>X11 and check "Enable X11 forwarding" box
  - Login to the vyuka.compbio.fmph.uniba.sk server in putty
  - `echo $DISPLAY` command on the server should show a non-empty string
    (e.g. localhost:11.0)
  - Try running `xeyes &`: this simple testing application should
    display a pair of eyes tracking your mouse cursor

## Copying files to/from the server via scp or WinSCP

  - You can copy files using `scp` command on the command line, both in
    Windows and Linux.
  - Alternatively use the graphical [WinSCP
    program](https://winscp.net/eng/downloads.php) for Windows.

Examples of using `scp` command

    # copies file protocol.txt to /submit/perl/username on server
    scp protocol.txt username@vyuka.compbio.fmph.uniba.sk:/submit/perl/username/
    
    # copies file protocol.txt to the home folder of the user on the server
    scp protocol.txt username@vyuka.compbio.fmph.uniba.sk:
    
    # copies file protocol.txt from home directory at the server to the current folder on the local computer
    scp username@vyuka.compbio.fmph.uniba.sk:protocol.txt .
    
    # copies folder /tasks/perl from the server to the current folder on the local computer
    # notice -r option for copying whole directories
    scp -r username@vyuka.compbio.fmph.uniba.sk:/tasks/perl .

## Mounting files from Linux server to your Linux computer via sshfs

On Linux, you can mount the filesystem from the server as a directory on
your machine using [sshfs](https://wiki.archlinux.org/title/SSHFS) tool,
and then work with it as with local folders, using both command-line and
graphical file managers and editors.

An example of using `sshfs` command for mounting a folder from a remote
server:

    mkdir vyuka  # create an empty folder with an arbitrary name
    sshfs username@vyuka.compbio.fmph.uniba.sk: vyuka   # mounting the remote folder to the empty folder

After running these commands, folder `vyuka` will contain your home
folder on vyuka server. You can copy files to and from the server and
even open them in editors as if they were on your computer, however with
network-related slowdown.

## MacOS

  - Command ssh in text mode should work on MacOS.
  - For GUIs you need an X server, try installing
    [XQuartz](https://www.xquartz.org/).
  - Alternatively, you can install sshfs from
    [macFUSE](https://osxfuse.github.io/) and mount vyuka as shown
    above.

