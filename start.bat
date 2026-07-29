@echo off
cd /d "%~dp0"
where node >nul 2>nul
if errorlevel 1 (
 echo Node.js nao encontrado. Instale em https://nodejs.org/
 pause
 exit /b 1
)
if not exist node_modules (
 echo Instalando dependencias pela primeira vez...
 call npm install
)
start "" http://localhost:5173
call npm run dev
pause
