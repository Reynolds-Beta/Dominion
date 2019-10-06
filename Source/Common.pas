CONST
     Esc 		= #27;
     AllOff 	= Esc + '[0';
     Bold 		= Esc + '[1';
     Underline 	= Esc + '[4';
     Blink 		= Esc + '[5';
     BlackF 	= Esc + '[30'; {0}
     RedF 		= Esc + '[31'; {1}
     GreenF 	= Esc + '[32'; {2}
     YellowF 	= Esc + '[33'; {3}
     BlueF 		= Esc + '[34'; {4}
     MagentaF 	= Esc + '[35'; {5}
     CyanF 		= Esc + '[36'; {6}
     WhiteF 	= Esc + '[37'; {7}
     BlackB 	= Esc + '[40';
     RedB 		= Esc + '[41';
     GreenB 	= Esc + '[42';
     YellowB 	= Esc + '[43';
     BlueB 		= Esc + '[44';
     MagentaB 	= Esc + '[45';
     CyanB 		= Esc + '[46';
     WhiteB 	= Esc + '[47';

procedure print(b:string);
Begin
	WriteLn(b);
End;

procedure prompt(b:string);
Begin
	Write(b);
End;

procedure Ansic(s:string);
Begin
	prompt(s);
End;

procedure Onek (Var OneChar:Char; validChars:string);
VAR
	tempChar: Char;
Begin
	read(tempChar);
	if (POS('' + tempChar, validChars) > 0) then
		OneChar := tempChar
	else
		OneChar := ' ';
End;

procedure cls;
begin
     prompt(Esc + '[2J');
end;

procedure nl;
begin
     WriteLn;
end;

procedure PauseScr;
VAR
	tempChar : Char;
begin
	read(tempChar);
end;

procedure PrintAcr(s:string; abort:boolean; next:boolean);
begin
	WriteLn(s);
end;

procedure Input(var s:string; maxLen:integer; b:boolean);
var
	tempStr:string;
begin
	ReadLn(tempStr);
	s := copy(tempStr, 1, maxLen);
end;

procedure Ynq(s:string);
begin
	Write(s + '(Y/N) ');
end;

Function Yn:boolean;
var
	tempChar:char;
begin
	tempChar := #0;
	Onek(tempChar, 'YNyn');
	case tempChar of
		'Y' : Yn := true;
		'y' : Yn := true;
		'N' : Yn := false;
		'n' : Yn := false;
	end;
end;

Function Value(s:string):integer;
var
	return:integer;
	code:integer;
begin
	code:=0;
	return:=0;
	val(s, return, code);
	Value:= return;
end;

procedure TLeft; { Prints time remaining }
begin
	{do nothing}
end;

Function Hangup:boolean;
begin
	Hangup:=false;
end;

procedure PrintFile(s:string); {prints the contents of a file w/ pausing}
begin
	{do nothing}
end;
