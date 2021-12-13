# Toolbox DLL-Aufruf

Dieses Beispiel hier sol als Anleitung und Inspiration dienen, eine DLL aufzusetzen, deren Funktionen in der SelectLine Warenwirtschaft ausgelesen, dargestellt und aufgerufen werden können.


Zunächst einmal ist eine Class Library zu erzeugen, die unsere DLL darstellt.

## Funktionen mit Parametern aufrufen 

Dazu folgen Sie bitte den nachfolgenden Schritten:
1.	Eigene Funktionen implementieren
    
    a.	Verwenden Sie die Konvention `stdcall` für jede Funktion, die Sie später exportieren wollen.

    b.	Zuletzt exportieren Sie diese DLL-Funktionen am Ende der Datei:
```
exports
  EigeneFunktionA,
  EigeneFunktionB, 
  …;
```

2.	Schnittstellen Models implementieren (siehe vollständige Modelle am Ende unten)

    a.	Darin werden Sie die Objekte zur Kommunikation mit der SelectLine Warenwirtschaft finden:

     * Enum zur Definition, um welche Art des Aufrufes es sich handelt
     
     * Enum zur Definition, um welchen Datentyp es sich bei den zu übergebenen Parametern jeweils handelt
     
     * Enum zur Definition, um was für eine Art Parameter es sich handelt (Eingabe- oder/und Ausgabeparameter) 
     
     * Record zur Definition der Parameter
     
     * Record zur Definition der Funktionen
     
     * Record zur Definition der DLL-Informationen

3.	Bereitstellen der Funktion `GetToolBoxInfoW` , die den Pointer zu Ihren DLL-Informationen vom Typen `PToolBoxFctsW` zurückgibt:

    a.	Die dort zurückgebenen DLL-Informationen sehen Sie später in der SelectLine Warenwirtschaft, sobald Sie diese DLL in der SelectLine Warenwirtschaft eingebunden haben.

```
function GetToolBoxInfoW : PToolBoxFctsW; stdcall;
begin
  Result  := @CDllInformation; 
end;
```

4.	Funktion exportieren

```
exports
  GetToolBoxInfoW;
```

5.	Globale Konstante zu den DLL-Informationen definieren

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

6.	Globale Konstanten zu den Funktionen der DLL definieren

    a.	Damit bekommen Sie in der SelectLine Warenwirtschaft die Möglichkeit, die DLL-Funktionalitäten inkl. Parameter detailliert gelistet zu bekommen.

```
CFunctionsCount  = 1;
CFunctionsInfo : array[0..CFunctionsCount - 1] of TToolBoxFctInfoW =
(
    (
        Size        : sizeof(TToolBoxFctInfoW);
        Name        : 'SaveToFile';
        Description : 'Sum up two values and save result to file';
        Kind        : tbxcCallParams;
        ParamsCount : CSaveToFileParamsCount;
        Params      : @CSaveToFileParams;
    )
);
```

7.	Globale Konstanten zu den Funktionsparametern der DLL definieren

```
// --- parameter of function save to file  ----
CSaveToFileParamsCount = 2;
CSaveToFileParams : array[0..CSaveToFileParamsCount - 1] of TToolBoxFctParamW = (
    (
        Size        : sizeof(TToolBoxFctParamW);
        Name        : 'a';
        Description : 'first value';
        Typ         : tbxtInteger;
        Direction   : tbxdOut;
        IsDefault   : false; 		//Pflichtfeld: ja oder nein?
        Default     : '0'
    ),
    (
        Size        : sizeof(TToolBoxFctParamW);
        Name        : 'b';
        Description : 'second value';
        Typ         : tbxtInteger;
        Direction   : tbxdOut;
        IsDefault   : false; 			//Pflichtfeld: ja oder nein?
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
        Dummy           : Byte;                 // keine Relevanz, jedoch nicht zu löschen!
        Typ             : TToolBoxParamType;
        Direction       : TToolBoxParamDirection;
        IsDefault       : boolean;              // Is field required?
        Default         : PWideChar;            // default value
  end;
  PToolBoxFctParamW  = ^TToolBoxFctParamW;

  // --- record which contains information about dll-functions ---
  TToolBoxFctInfoW = packed record
    Size                : integer;             // sizeof(TToolBoxFctInfoW)
    Name                : PWideChar;
    Description         : PWideChar;
    Kind                : TToolBoxCallKind;
    Dummy               : Byte;                // keine Relevanz, jedoch nicht zu löschen!
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
