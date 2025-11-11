#!/usr/bin/env python3
TARGET = "/usr/local/bin/autoapp.real"
START = b"<html>"
END   = b"</html>"
REPL  = b"<html><p style=\"font-size:21px;color:#fff\">hexaplay <span style=\"color:#007bff\">robles</span></p></html>"
import sys
buf=open(TARGET,'rb').read()
i=buf.find(START); j=buf.find(END,i)+len(END)
if i<0 or j<0:
    sys.exit("No se encontr\u00f3 bloque HTML")
pad=len(buf[i:j])-len(REPL)
if pad<0:
    sys.exit("Reemplazo demasiado grande; ajusta estilos.")
open(TARGET,'wb').write(buf[:i]+REPL+b" "*pad+buf[j:])
print("OK: banner parcheado")
