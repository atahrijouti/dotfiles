@echo off

:: basic bash aliases
doskey ls=ls --show-control-chars -F --color $*
doskey vim=nvim $*
doskey curl=D:\Users\atj\programs\msys2\usr\bin\curl.exe $*

:: yt-dlp
doskey ytfhd=yt-dlp.exe -f "bestvideo[height<=1080]+bestaudio/best[height<=1080]" $*
doskey yt2k=yt-dlp.exe -f "bestvideo[height<=1440]+bestaudio/best[height<=1440]" $*
doskey yt4k=yt-dlp.exe $*
doskey gibfhd=yt-dlp.exe -S "res:1080" -f "(bv*[vcodec~='^((he|a)vc|h26[45])']+ba) / (bv*+ba/b)" $*