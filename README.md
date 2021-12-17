# Toolboc DLL-Aufruf und COM

In diesem Repository finden Sie sowohl Beispiel für einen Dll-Aufruf aus der SelectLine Warenwirtschaft heraus als auch ein Beispiel für einen COM-Aufruf

## Toolbox DLL-Aufruf

### Einrichtung in der Warenwirtschaft
In den SelectLine Produkten (Warenwirtschaft, Rechnungswesen, ...) gibt es unter "Eigene Daten > Makro Assistent" die Möglichkeit, einen Toolbox-DLL-Aufruf einzubinden.

![image](https://user-images.githubusercontent.com/34538107/145825177-f2378e15-daff-4116-a39e-61caa2ac9660.png)

Spezielle DLLs können dann von den SelectLine Produkten angesprochen werden. Ebenso können hier Parameter an die DLL übergeben, als auch Ergebnisse bspw. zur Warenwirtschaft zurückgesendet werden.

![image](https://user-images.githubusercontent.com/34538107/145825729-28edc780-1297-40f1-9eb6-7108fc481bc3.png)

Dafür stellt Ihnen das jeweilige SelectLine Produkt ebenfalls Ihre Funktionen und Eingabe-, als auch Ausgabeparameter optisch aufbereitet dar.

![image](https://user-images.githubusercontent.com/34538107/145825405-6bd74054-14a9-4b72-ae6c-f3386401c796.png)

Um dieses Feature nutzen zu können, muss Ihre DLL jedoch eine spezielle Schnittstelle bereitstellen.
Daher bieten wir Ihnen hier einige Beispiele an, um Ihnen die Anbindung verständlich darzulegen oder einmal auszuprobieren.

In dem Beispiel `Delphi-Example1` finden Sie eine DLL, in der eine Funktion Ihnen zwei beliebige Werte addiert und das Ergebnis in einer Datei `example.txt` unter `C:\Temp` ablegt.

![image](https://user-images.githubusercontent.com/34538107/145825474-68427f3b-3a68-467c-a071-beabfb623053.png)

Weiterhin steht eine Funktionalität zur Verfügung, die einen beliebigen Text in einem kleinen Fenster darstellt und ggf. auf ihren Standardwert zurückgreift, sollte kein Text vom Benutzer angegeben werden.

![image](https://user-images.githubusercontent.com/34538107/145825540-72f961c4-a668-4fba-b21c-b4391b70b12e.png)

Im zweiten Beispiel, welches in Delphi programmiert wurde, steht Ihnen eine DLL zur Verfügung, welche zwei Eingabewerte addiert und deren Ergebnis zurückgibt.
Zum Schluss kann mithilfe der exportierten Prozedur FreeToolBoxResultsW(...) der Speicher des Rückgabeobjektes freigegeben werden.

![dll-addupnumbers-with-result](https://user-images.githubusercontent.com/34538107/146389824-0d566c88-f417-4b3f-8bb0-a02aa24575ab.png)

Falls Sie selbst eine DLL bereitstellen wollen, empfehlen wir die folgende Anleitung. 
Diese hilft Ihnen dabei eine DLL aufzusetzen, die Funktionen mit Eingabeparametern anspricht. 

### Funktionen der DLL mit Parametern aufrufen 

1.	Zunächst einmal ist eine Class Library zu erzeugen, die später unsere DLL darstellt.	
2.	Eigene Funktionen implementieren
    
    a.	Verwenden Sie die Konvention `stdcall` für jede Funktion, die Sie später exportieren wollen.

    b.	Zuletzt exportieren Sie diese DLL-Funktionen am Ende der Datei:
```
exports
  EigeneFunktionA,
  ...;
```

3.	Schnittstellen Models implementieren (siehe vollständige Modelle am Ende unten)

    a.	Darin werden Sie die Objekte zur Kommunikation mit der SelectLine finden:

     * Enum zur Definition, um welche Art des Aufrufes es sich handelt
     
     * Enum zur Definition, um welchen Datentyp es sich bei den zu übergebenen Parametern jeweils handelt
     
     * Enum zur Definition, um was für eine Art Parameter es sich handelt (Eingabe- oder/und Ausgabeparameter) 
     
     * Record zur Definition der Parameter
     
     * Record zur Definition der Funktionen
     
     * Record zur Definition der DLL-Informationen

4.	Bereitstellen der Funktion `GetToolBoxInfoW` , die den Pointer zu Ihren DLL-Informationen vom Typen `PToolBoxFctsW` zurückgibt:

    a.	Die dort zurückgebenen DLL-Informationen sehen Sie später in dem jeweiligen SelectLine Produkt, sobald Sie diese DLL in der SelectLine eingebunden haben.

```
function GetToolBoxInfoW : PToolBoxFctsW; stdcall;
begin
  Result  := @CDllInformation; 
end;
```

5.	Funktion exportieren

```
exports
  GetToolBoxInfoW;
```

6.	Globale Konstante zu den DLL-Informationen definieren

```
CDllInformation : TToolBoxFctsW =
(
    Size          :  sizeof(TToolBoxFctsW);
    VersionMajor  :  1;
    VersionMinor  :  0;
    CopyRight     :  'SelectLine GmbH Magdeburg';
    Description   : 'Calculation of values';
    FctsCount     : CFunctionsCount;
    Fcts          : @CFunctionsInfo;
);
```

7.	Globale Konstanten zu den Funktionen der DLL definieren

    a.	Damit bekommen Sie in der SelectLine die Möglichkeit, die DLL-Funktionalitäten inkl. Parameter detailliert gelistet zu bekommen.

```
CFunctionsCount  = 1;
CFunctionsInfo : array[0..CFunctionsCount - 1] of TToolBoxFctInfoW =
(
    (
        Size        : sizeof(TToolBoxFctInfoW);
        Name        : 'FunctionA';
        Description : 'Here you can describe your function';
        Kind        : tbxcCallParams;
        ParamsCount : CFunctionAParamsCount;
        Params      : @CFunctionAParams;
    )
);
```

8.	Globale Konstanten zu den Funktionsparametern der DLL definieren

```
// --- parameter of function A  ----
CFunctionAParamsCount = 2;
CFunctionAParams : array[0..CFunctionACount - 1] of TToolBoxFctParamW = (
    (
        Size        : sizeof(TToolBoxFctParamW);
        Name        : 'a';
        Description : 'first value';
        Typ         : tbxtInteger;
        Direction   : tbxdOut;
        IsDefault   : false; 			// Determines whether the parameter is a mandatory field
        Default     : '0'
    ),
    (
        Size        : sizeof(TToolBoxFctParamW);
        Name        : 'b';
        Description : 'second value';
        Typ         : tbxtInteger;
        Direction   : tbxdOut;
        IsDefault   : false; 			// Determines whether the parameter is a mandatory field
        Default     : '0'
    )
);
```

### Hinweise zum DLL-Aufruf
1.	An Parametern kann das Property `„IsDefault“` gesetzt werden. Dies gibt Auskunft, ob das jeweilige Property ein Pflichtfeld ist. Falls Sie ein Parameter als Pflichtfeld kennzeichnen wollen, setzen Sie das Property `IsDefault` auf den Wert `true`.

2.	Ebenfalls kann dort bestimmt werden, ob der Parameter zur Eingabe, Ausgabe oder generell zu beidem dient. (siehe `TToolBoxParamDirection`). Dabei steht `„tbxdIn“` für die Rückgabeparameter der DLL-Funktionalitäten und `„tbxdOut“` für die Eingabemöglichkeiten des Benutzers, die der DLL zugeschickt werden.

3.	Das Verwenden der Standardwerte für Parameter muss händisch von Ihnen programmiert werden. Dabei greifen Sie dann auf Ihre Konstanten zu, die Sie für die Anzeige in der SelectLine angelegt haben.

4.  DLL-Aufrufe sind möglich und mit überschaubarem Aufwand für Sie realisierbar, sofern Sie auf native Programmiersprachen, wie Delphi, zurückgreifen können.
Dazu finden Sie ein Beispiel hier auf GitHub.
Klare Hürden sehen wir in der Unterstützung von DLLs, die in z.B. noch einen Aufsatz, wie .NET Framework in C#, aufweisen. Daher entfällt deren Unterstützung von unserer Seite aus.

### Modelle zur erfolgreichen Kommunikation mit der SelectLine DLL Schnittstelle
```
type
  TToolBoxCallKind  = ( tbxcNone, tbxcCall, tbxcCallMsg, tbxcCallParams, tbxcCallDBParams,
                        tbxcCallResult, tbxcCallMsgResult, tbxcCallParamsResult, tbxcCallDBParamsResult );

  TToolBoxParamType       = (
            tbxtString,       // Dekodierer: implizit
            tbxtInteger,      // Dekodierer: StrToInt
            tbxtDouble,       // Dekodierer: StrToFloat
            tbxtDateTime,     // Dekodierer: StrToDateTime
            tbxtDate,         // Dekodierer: StrToDate
            tbxtTime,         // Dekodierer: StrToTime
            tbxtBoolean       // Dekodierer: StrToBoolDef
  );

  TToolBoxParamDirection  = (
            tbxdOut,          // input of dll-function
            tbxdIn,           // response of dll-function
            tbxdInOut         // both
  );

  // --- record which contains information about params of dll-functions ---
  TToolBoxFctParamW = packed record
        Size            : integer;              // sizeof(TToolBoxFctParamW)
        Name            : PWideChar;
        Description     : PWideChar;
        Dummy           : Byte;                 // This has no relevance, but must not be deleted
        Typ             : TToolBoxParamType;
        Direction       : TToolBoxParamDirection;
        IsDefault       : boolean;              // Determines whether the parameter is a mandatory field
        Default         : PWideChar;            // default value
  end;
  PToolBoxFctParamW  = ^TToolBoxFctParamW;

  // --- record which contains information about dll-functions ---
  TToolBoxFctInfoW = packed record
    Size                : integer;             // sizeof(TToolBoxFctInfoW)
    Name                : PWideChar;
    Description         : PWideChar;
    Kind                : TToolBoxCallKind;
    Dummy               : Byte;                // This has no relevance, but must not be deleted
    ParamsCount         : integer;
    Params              : PToolBoxFctParamW;
  end;
  PToolBoxFctInfoW = ^TToolBoxFctInfoW;

  // --- record which contains information about dll ---
  TToolBoxFctsW  = packed record
    Size                : integer;             // sizeof(TToolBoxFctsW)
    VersionMajor,
    VersionMinor        : word;
    CopyRight           : PWideChar;
    Description         : PWideChar;
    FctsCount           : integer;
    Fcts                :  PToolBoxFctInfoW;
  end;
  PToolBoxFctsW  = ^TToolBoxFctsW;
```

## COM-Aufruf
Im Beispiel für einen COM-Aufruf wird ein .NET ClassLibrary mit C# gezeigt. Diese können Sie direkt beim Bauen in Visual Studio als COM registrieren oder aber anschließend per `REGASM.EXE`:

`C:\Windows\Microsoft.NET\Framework64\v4.0.30319\REGASM.EXE COMClassLibrary.dll /tlb`

![image](https://user-images.githubusercontent.com/52783185/146541680-97deac86-ffd3-488a-a4b5-d98d27c55eb6.png)

Im Makro-Assistenten  der Warenwirtschaft wählen Sie bei "Server" `localhost` und bei "Schnittstelle" die ProgId (hier im Beispiel "SelectLine.COMDemo1").

![image](https://user-images.githubusercontent.com/52783185/146541578-d8f06e11-296d-41c0-99ad-7387481e5b6f.png)

Die COM-DLL selbst erzeugt je nach Aufrufart eine Textdatei auf D:\ in der die ggf. mitgesendeten Parameter angezeigt werden.
