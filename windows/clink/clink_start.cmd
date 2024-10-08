@echo off

@REM cls 

set EDITOR=hx

:: Basic bash aliases
doskey ls=ls --show-control-chars -F --color $*
doskey vim=nvim $*
@REM doskey curl=D:\Users\atj\programs\msys2\usr\bin\curl.exe $*

:: yt-dlp
doskey ytfhd=yt-dlp.exe -f "bestvideo[height<=1080]+bestaudio/best[height<=1080]" $*
doskey yt2k=yt-dlp.exe -f "bestvideo[height<=1440]+bestaudio/best[height<=1440]" $*
doskey yt4k=yt-dlp.exe $*
doskey gibfhd=yt-dlp.exe -S "res:1080" -f "(bv*[vcodec~='^((he|a)vc|h26[45])']+ba) / (bv*+ba/b)" $*
doskey ffmpeg=ffmpeg -hide_banner $*
doskey ffprobe=ffprobe -hide_banner $*
@REM doskey cd=cd %USERPROFILE%
doskey lf=lfcd
doskey ~=cd %homepath%
doskey msyshere=C:/msys64/msys2_shell.cmd -defterm -here -no-start -msys
doskey ucrthere=C:/msys64/msys2_shell.cmd -defterm -here -no-start -ucrt64
