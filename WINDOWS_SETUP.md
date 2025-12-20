# Windows Hadoop Setup für PySpark

Dieses Projekt benötigt `winutils.exe` für PySpark auf Windows.

## Automatische Installation (empfohlen)

Führe das Setup-Skript **als Administrator** aus:

```powershell
# PowerShell als Administrator öffnen
# Dann im Projekt-Root:
.\setup_hadoop_windows.ps1
```

Das Skript:
1. Erstellt `C:\hadoop\bin\`
2. Lädt `winutils.exe` herunter (Hadoop 3.3.1, kompatibel mit Spark 3.x)
3. Setzt die Umgebungsvariable `HADOOP_HOME=C:\hadoop`

**Danach PyCharm/Jupyter KOMPLETT neu starten!**

---

## Manuelle Installation (Alternative)

Falls das Skript nicht funktioniert:

### 1. Verzeichnis erstellen
```powershell
mkdir C:\hadoop\bin
```

### 2. winutils.exe herunterladen

Lade `winutils.exe` für deine Hadoop-Version herunter:
- **Hadoop 3.3.1** (empfohlen für Spark 3.x): https://github.com/cdarlint/winutils/raw/master/hadoop-3.3.1/bin/winutils.exe
- Andere Versionen: https://github.com/cdarlint/winutils

Platziere die Datei unter: `C:\hadoop\bin\winutils.exe`

### 3. Umgebungsvariable setzen

**Option A: PowerShell (als Administrator)**
```powershell
[Environment]::SetEnvironmentVariable('HADOOP_HOME','C:\hadoop','Machine')
```

**Option B: Windows GUI**
1. Systemsteuerung → System → Erweiterte Systemeinstellungen
2. Umgebungsvariablen → Neu (System)
3. Name: `HADOOP_HOME`, Wert: `C:\hadoop`

### 4. PyCharm/Jupyter neu starten

**Wichtig:** Nach dem Setzen der Umgebungsvariable PyCharm/Jupyter **komplett schließen und neu starten** (nicht nur Kernel neu starten).

---

## Überprüfung

Nach dem Setup:

```python
import os
print("HADOOP_HOME:", os.environ.get('HADOOP_HOME'))
print("winutils.exe existiert:", os.path.exists(r'C:\hadoop\bin\winutils.exe'))
```

Sollte ausgeben:
```
HADOOP_HOME: C:\hadoop
winutils.exe existiert: True
```

---

## Fehlerbehebung

### Fehler bleibt bestehen
- **Neustart vergessen?** PyCharm/Jupyter muss komplett neu gestartet werden
- **Kernel-Neustart reicht nicht** - die IDE selbst muss geschlossen werden

### Admin-Rechte fehlen
Falls du keine Admin-Rechte hast, setze die Variable nur für deinen User:
```powershell
[Environment]::SetEnvironmentVariable('HADOOP_HOME','C:\hadoop','User')
```

### Workaround im Code
Das Notebook enthält bereits einen Workaround, der `HADOOP_HOME` vor der SparkSession setzt:
```python
if sys.platform == "win32":
    os.environ['HADOOP_HOME'] = os.environ.get('HADOOP_HOME', r'C:\hadoop')
```

Dieser funktioniert auch ohne globale Umgebungsvariable, **solange `winutils.exe` existiert**.

---

## Weitere Infos

- Apache Wiki: https://wiki.apache.org/hadoop/WindowsProblems
- GitHub winutils: https://github.com/cdarlint/winutils

