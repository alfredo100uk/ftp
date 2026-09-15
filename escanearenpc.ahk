#Requires AutoHotkey v2.0
#SingleInstance Force
; ==============================================================================
; Script AHK v2 - Descarga Completa y Lanzamiento Portátil de FTPServer
; ==============================================================================

RutaAppLocal := EnvGet("LocalAppData") . "\FtpPortable"
RutaExe := RutaAppLocal . "\FTPServer.exe"
RutaChm := RutaAppLocal . "\FTPServer.chm"
RutaTrace := RutaAppLocal . "\ftptrace.txt"
RutaUsers := RutaAppLocal . "\users.xml"
CarpetaDestino := "C:\escaneado"

; 1. Asegurar que los directorios necesarios existan
if !DirExist(RutaAppLocal) {
    DirCreate(RutaAppLocal)
}
if !DirExist(CarpetaDestino) {
    DirCreate(CarpetaDestino)
}

; 2. Cerrar cualquier instancia previa para evitar bloqueos en los archivos
try {
    RunWait('taskkill /f /im FTPServer.exe', , "Hide")
} catch {
    ; Si no hay procesos previos, se ignora
}

; 3. Función auxiliar para descargar archivos desde GitHub de forma limpia
DescargarSiNoExiste(url, destino, nombreArchivo) {
    if !FileExist(destino) {
        ToolTip("Descargando " . nombreArchivo . " desde GitHub...")
        try {
            Download(url, destino)
        } catch {
            ; Se continúa aunque falle algún archivo secundario menor
        }
        ToolTip()
    }
}

; 4. Descargar todos los componentes necesarios
DescargarSiNoExiste("https://raw.githubusercontent.com/alfredo100uk/ftp/main/FTPServer.exe", RutaExe, "FTPServer.exe")
DescargarSiNoExiste("https://raw.githubusercontent.com/alfredo100uk/ftp/main/FTPServer.chm", RutaChm, "FTPServer.chm")
DescargarSiNoExiste("https://raw.githubusercontent.com/alfredo100uk/ftp/main/ftptrace.txt", RutaTrace, "ftptrace.txt")
DescargarSiNoExiste("https://raw.githubusercontent.com/alfredo100uk/ftp/main/users.xml", RutaUsers, "users.xml")

; 5. Lanzar el servidor FTP fijando el directorio de trabajo en la carpeta AppData
if FileExist(RutaExe) {
    Run('"' . RutaExe . '"', RutaAppLocal)
} else {
    MsgBox("El archivo ejecutable no está disponible.", "Error", 16)
}

ExitApp