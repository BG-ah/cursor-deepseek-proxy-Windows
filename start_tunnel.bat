@echo off
chcp 65001 >nul
title Cloudflare 隧道服务
echo 正在启动隧道服务...
.\cloudflared-windows-amd64.exe tunnel --url http://127.0.0.1:9000
echo.
echo 隧道服务已断开。
pause