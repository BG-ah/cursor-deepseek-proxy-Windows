@echo off
chcp 65001 >nul
title DeepSeek 代理服务
echo 正在启动代理服务...
"E:\Cminiconda\python.exe" proxy.py
echo.
echo 代理服务已退出，请检查报错信息。
pause