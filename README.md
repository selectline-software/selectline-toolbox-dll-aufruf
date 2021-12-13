# Toolbox DLL-Aufruf

In der SelectLine Warenwirtschaft gibt es unter "Eigene Daten > Makro Assistent" die Möglichkeit einen Toolbox-DLL-Aufruf einzubinden.
Spezielle DLLs können dann von der SelectLine Warenwirtschaft angesprochen werden. Ebenso können hier Parameter an die DLL übergeben, als auch Ergebnisse zur Warenwirtschaft zurückgesendet werden.
Dabei stellt Ihnen die SelectLine Warenwirtschaft ebenfalls Ihre Funktionen und Eingabe-, als auch Ausgabeparameter optisch aufbereitet dar.

Um dieses Feature nutzen zu können, muss Ihre DLL jedoch eine spezielle Schnittstelle bereitstellen.
Daher bieten wir Ihnen hier einige Beispiele an, um Ihnen die Anbindung verständlich darzulegen oder einmal auszuprobieren.

In dem Beispiel `Delphi-Example1` finden Sie eine DLL, in der eine Funktion Ihnen zwei beliebige Werte addiert und das Ergebnis in einer Datei `example.txt` unter `C:\Temp` ablegt.
Weiterhin steht eine Funktionalität zur Verfügung, die einen beliebigen Text in einem kleinen Fenster darstellt und ggf. auf ihren Standardwert zurückgreift, sollte kein Text vom Benutzer angegeben werden.

Falls Sie selbst eine DLL bereitstellen wollen, empfehlen wir die folgende Anleitung.
Diese hilft Ihnen dabei eine DLL aufzusetzen, die Funktionen mit Eingabeparametern anspricht.
In Zukunft wird es ein weiteres Beispiel geben, indem die Rückgabewerte Ihrer Funktionen an die Warenwirtschaft gesendet werden.

## Funktionen mit Parametern aufrufen 

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

    a.	Darin werden Sie die Objekte zur Kommunikation mit der SelectLine Warenwirtschaft finden:

     * Enum zur Definition, um welche Art des Aufrufes es sich handelt
     
     * Enum zur Definition, um welchen Datentyp es sich bei den zu übergebenen Parametern jeweils handelt
     
     * Enum zur Definition, um was für eine Art Parameter es sich handelt (Eingabe- oder/und Ausgabeparameter) 
     
     * Record zur Definition der Parameter
     
     * Record zur Definition der Funktionen
     
     * Record zur Definition der DLL-Informationen

4.	Bereitstellen der Funktion `GetToolBoxInfoW` , die den Pointer zu Ihren DLL-Informationen vom Typen `PToolBoxFctsW` zurückgibt:

    a.	Die dort zurückgebenen DLL-Informationen sehen Sie später in der SelectLine Warenwirtschaft, sobald Sie diese DLL in der SelectLine Warenwirtschaft eingebunden haben.

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

    a.	Damit bekommen Sie in der SelectLine Warenwirtschaft die Möglichkeit, die DLL-Funktionalitäten inkl. Parameter detailliert gelistet zu bekommen.

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

# Hinweise
1.	An Parametern kann das Property `„IsDefault“` gesetzt werden. Dies gibt Auskunft, ob das jeweilige Property ein Pflichtfeld ist.

2.	Ebenfalls kann dort bestimmt werden, ob der Parameter zur Eingabe, Ausgabe oder generell zu beidem dient. (siehe `TToolBoxParamDirection`). Dabei steht `„tbxdIn“` für die Rückgabeparameter der DLL-Funktionalitäten und `„tbxdOut“` für die Eingabemöglichkeiten des Benutzers, die der DLL zugeschickt werden.

3.	Das Verwenden der Standardwerte für Parameter muss händisch von Ihnen programmiert werden. Dabei greifen Sie dann auf Ihre Konstanten zu, die Sie für die Anzeige in der Warenwirtschaft angelegt haben.


# Modelle zur erfolgreichen Kommunikation mit der SelectLine Warenwirtschaft
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
