Program Dominions;
{$V-}

Uses Dos, Crt;


{$I DOM_VARS.PAS}  {Global constants and type definitions for dominions}
{$I COMMON.PAS}

Var
	GenFile		: file;
	eplayer		: boolean;
	pcount		: integer;
	detects		: integer;
	moretech	: tech2;
	squadpos	: squadxy;
	BigString 	: String160;
	OneChar 	: Char;
	EC:Longint;
	Player_Number,eq,ED,rounds, CurMonth, Year, Len : Integer;
	Empire 		: Empirerecs;
	Planet 		: Planetrecs;
	Squadron 	: Squadronrecs;
	Messages 	: Messagerecs;
	Filled_Up 	: Boolean;
	date_now 	: string160;

Function addfront(b:string;l:integer): string;
Begin
  while length(b)< l do
    b := ' '+b;
  addfront := b;
End;

Function addrear(b:string;l:integer): string;
Begin
  while length(b)< l do
    b := b+' ';
  addrear := b;
End;

function St (StA : Real) : String160;
Var
  BS : String160;
  SN : Byte;
Begin
	sta:=sta-frac(sta);
	str (StA:0:0,BS);
	SN := length (BS);
	if SN > 4 then
		While SN > 3 do
		Begin
			SN := SN - 3;
			if not ((SN = 1) and (BS[1] = '-')) then insert (',', BS, SN+1);
		End;
	St := BS;
End;

function StReal (Z : Real; W : Integer) : String160;
Var
	SV : String160;
Begin
	Str (Z:0:W,SV);
	StReal := SV;
End;

{$I DOM3.PAS}       {Fourth generation procedures.}
{$I DOM2.PAS}       {Third generation procedures.}
{$I DOM1.PAS}       {Second generation procedures.}
{$I MAINTNEW.PAS}   {Maintenence procedures.}

procedure Main_Menu;
Begin
	Repeat
		if eplayer then
		begin
		nl;
		nl;
		Ansic(BlueF);
		print ('Dominions! Main Menu');
		Ansic(RedF);
		print ('~~~~~~~~~~~~~~~~~~~~');
		if not Empire[Player_Number].Expert then
		Begin
			print (GreenF+'('+CyanF+'C'+GreenF+')ounterintelligence');
			print (GreenF+'('+CyanF+'E'+GreenF+')mpire Management');
			print (GreenF+'('+CyanF+'I'+GreenF+')nstructions');
			print (GreenF+'('+CyanF+'M'+GreenF+')ap of the Galaxy');
			print (GreenF+'('+CyanF+'N'+GreenF+')avy Management');
			print (GreenF+'('+CyanF+'P'+GreenF+')lanet Management');
			print (GreenF+'('+CyanF+'R'+GreenF+')ecent Happenings');
			print (GreenF+'('+CyanF+'S'+GreenF+')cores');
			print (GreenF+'('+CyanF+'X'+GreenF+')pert Mode Toggle');
			print (GreenF+'('+CyanF+'H'+GreenF+')elp');
			print (WhiteF+'('+CyanF+'Q'+WhiteF+')uit');
			writeln;
		End;
		Ansic(GreenF);
		tleft;
		if hangup then begin
			hangup:=false;
			print('*** Saving current status ***');
			hangup:=true;
			Exit;
		end;
		if Empire[Player_Number].Expert then
			prompt ('Option (C,E,H,I,M,N,P,Q,R,S,X) > ')
		else
			prompt ('Option > ');
		Onek (OneChar, 'CEHIMNPQRSX');
		Case OneChar of
			'C' : Counterintelligence_Menu;    {Case of... }
			'E' : Empire_Menu;                 {Sends Game to Correct }
			'H' : PrintFile ('HelpMain.Dom');  {Procedure for Main }
			'I' : PrintFile ('Instruct.Dom');  {Input.}
			'M' : Maps;
			'N' : Navy_Menu;
			'P' : Planet_Menu;
			'Q' : Begin
							nl;
							Ansic(CyanF);
							prompt ('Are you sure ? ');
							if YN then Exit;
						End;
			'R' : Read_Recent_Happenings;
			'S' : Scores;
			'X' : Empire[Player_Number].Expert := not Empire[Player_Number].Expert;
		End; {case}
	end else
	begin
		Ansic(YellowF);
		print('This game needs at least '+st(Players_needed-pcount)+' more players to begin!');
		nl;
		print (GreenF+'('+CyanF+'H'+GreenF+')elp');
		print (GreenF+'('+CyanF+'I'+GreenF+')nstructions');
		print (GreenF+'('+CyanF+'M'+GreenF+')ap of the Galaxy');
		print (WhiteF+'('+CyanF+'Q'+WhiteF+')uit');
		nl;
		prompt ('Option > ');
		Onek (OneChar, 'HIMQ');
		Case OneChar of
			'H' : PrintFile ('HelpMain.Dom');  {Procedure for Main }
			'I' : PrintFile ('Instruct.Dom');  {Input.}
			'M' : Maps;
			'Q' : Begin
							nl;
							Ansic(CyanF);
							prompt ('Are you sure ? ');
							if YN then Exit;
						End;
		End; {case}
	end;
	Until IsFalse or hangup;
End;

procedure Introduction;
Begin
	cls;
	Ansic(GreenF);
	print ('Original Programming...    Apocalypse');
	Ansic(RedF);
	print ('Miscellaneous Assistance...The Catt');
	Ansic(RedF);
	print ('                           Mr. Bill');
	nl;
	Ansic(MagentaF);
	print ('Enhancements...            Tarl Cabot');
	Ansic(MagentaF);
	print ('Rewrite and mods for 1.60  the Doctor');
	Ansic(MagentaF);
	print ('                           the Master');
	PauseScr;
	cls;
	PrintFile ('Picture.Dom');
End;

procedure Load_Information;
Var
	EmpireFile  : file of Empirerecord;
	PlanetFile  : file of Planetrecord;
	SquadFile   : file of Squadronrecord;
	MessageFile : file of Messagerecord;
	squadxyfile : file of squadmappos;
	tech2file	: file of extratech;
	LastOnFile  : file of String160;
	LastPlayed  : String160;
	DateFile    : File of Integer;
	LoopLI      : Integer;
Begin
	randomize;
	detects:=random(100)+1;
	Assign (EmpireFile, 'Empires.Dom');
	Reset (EmpireFile);
	for LoopLI := 1 to Number_of_Players do
		Read (EmpireFile, Empire[LoopLI]);
	Close (EmpireFile);
	for loopli:=1 to Number_of_Players do
	begin
		with empire[loopli] do
			begin
				if user_number>0 then pcount:=pcount+1;
			end;
	end;
	eplayer:=false;
	if (pcount>=Players_Needed) or (paramstr(1)='TEST') then eplayer:=true;
	assign (squadxyfile, 'squadpos.dom');
	reset(squadxyfile);
	for LoopLI :=1 to Number_of_Squads do
		read (squadxyfile,squadpos[LoopLI]);
	close(squadxyfile);
	assign (tech2file,'tech2.dom');
	reset(tech2file);
	for LoopLI:=1 to Number_of_Players do
		read(tech2file,moretech[LoopLI]);
	close(tech2file);
	Assign (PlanetFile, 'Planets.Dom');
	Reset (PlanetFile);
	for LoopLI := 1 to Number_of_Planets do
		Read (PlanetFile, Planet[LoopLI]);
	Close (PlanetFile);
	for LoopLI:=1 to Number_of_Planets do
	begin
		if (Planet[LoopLI].Owner<1) or (Planet[LoopLI].Owner>Number_of_Players) then
		begin
			Planet[LoopLI].radars[1]:=0;
			Planet[LoopLI].radars[2]:=0;
			Planet[LoopLI].radars[3]:=0;
		end;
	end;
	Assign (SquadFile, 'Squads.Dom');
	Reset (SquadFile);
	for LoopLI := 1 to Number_of_Squads do
		read (SquadFile, Squadron[LoopLI]);
	Close (SquadFile);
	Assign (MessageFile, 'Messages.Dom');
	Reset (MessageFile);
	for LoopLI := 1 to Number_of_Messages do
		read (MessageFile, Messages[LoopLI]);
	Close (MessageFile);
	Assign (LastOnFile, 'LastOn.Dom');
	if Empire[1].User_Number > 0 then
	Begin
		Reset (LastOnFile);
		Read (LastOnFile, Lastplayed);
	End;
	Date_Now := date;
	Assign (DateFile, 'Date.Dom');
	Reset (DateFile);
	Read (DateFile, CurMonth, Year);
	Close (DateFile);
	cls;
	if (mdays>0) and (paramstr(1)<>'TEST') then
	begin
		if (Lastplayed <> Date_Now) and (Empire[Players_Needed].User_Number > 0) then Maintenence;
	end else
	begin
		maintenence;
	end;
	for LoopLI := 1 to 20 do
		if (Empire[LoopLI].User_Number = UserNum) and
			(Empire[LoopLI].User_Name = ThisUser.Name) then
				Player_Number := LoopLI;
	if Player_Number = 0 then
	Begin
		LoopLI := 0;
		Repeat
			loopLI := LoopLI + 1;
		Until (Empire[LoopLI].User_Number = 0) or (LoopLI = 21);
		if LoopLI < 21 then
		begin
			Make_New_Player(LoopLI);
		end else
		begin
			Ansic(MagentaF);
			print ('Sorry, but all twenty empires are are taken.');
			Ansic(GreenF);
			print ('Please wait for the game to be reset in order');
			Ansic(GreenF);
			print ('to play.');
			nl;
			halt;
		End;
	End;
End;

procedure Print_Messages;
Var
	LoopPM, TotalMsgs : Byte;
Begin
	cls;
	TotalMsgs := 0;
	for LoopPM := 1 to Number_of_Messages do
		if Messages[LoopPM].Sent_To = Player_Number then
			with Messages[LoopPM] do
			Begin
				if TotalMsgs > 6 then
				Begin
					PauseScr;
					TotalMsgs := 0;
				End;
				TotalMsgs := TotalMsgs + 1;
				if Sent_By > 0 then
					print ('A message from ' + Empire[Sent_By].Empire_Name +
						'[' + St(Sent_By) + ']...');
				print (Message);
				print ('---------------------------------------');
				Sent_By := 0;
				Sent_To := 0;
				Message := '';
			End;
End;

procedure Save_All;
Var
	squadxyfile : file of squadmappos;
	tech2file	 	: file of extratech;
	EmpireFile  : file of Empirerecord;
	PlanetFile  : file of Planetrecord;
	SquadFile   : file of Squadronrecord;
	MessageFile : file of Messagerecord;
	DateFile    : file of Integer;
	LastonFile  : file of String160;
	LoopSA      : Integer;
	Loopsh      : integer;
Begin
	writeln;
	print (YellowF+Blink+'=!=!=!=Saving=!=!=!='+ AllOff );
	for loopsa:=1 to number_of_planets do
	begin
		planet[loopsa].industrial_level:=abs(planet[loopsa].industrial_level);
		for loopsh:=1 to number_of_ships do
			if planet[loopsa].ships[loopsh]<0 then
				planet[loopsa].ships[loopsh]:=-(planet[loopsa].ships[loopsh]);
	end;
	Assign (DateFile, 'Date.Dom');
	Rewrite (DateFile);
	Write (DateFile, CurMonth, Year);
	Close (DateFile);
	Assign (LastonFile, 'LastOn.Dom');
	Rewrite (LastonFile);
	Write (LastOnFile, Date_Now);
	Close (LastOnFile);
	Empire[Player_Number].Points := Score(Player_Number);

	print('  Saving squads');
	assign (squadxyfile, 'squadpos.dom');
	Ansic(redf);
	rewrite(squadxyfile);
	for LoopSA :=1 to Number_of_Squads do begin
		write (squadxyfile,squadpos[LoopSA]);
	end;
	close(squadxyfile);
	Assign (SquadFile, 'Squads.Dom');
	Rewrite (SquadFile);
	for LoopSA := 1 to Number_of_Squads do
		write (SquadFile, Squadron[LoopSA]);
	Close (SquadFile);
	assign (tech2file,'tech2.dom');
	rewrite(tech2file);
	for LoopSA:=1 to Number_of_Players do begin
		write(tech2file,moretech[LoopSA]);
	end;
	close(tech2file);

	print('  Saving empires');
	Assign (EmpireFile, 'Empires.Dom');
	Rewrite (EmpireFile);
	for LoopSA := 1 to Number_of_Players do
		write (EmpireFile, Empire[LoopSA]);
	Close (EmpireFile);
  Assign (MessageFile, 'Messages.Dom');
	Rewrite (MessageFile);
	for LoopSA:= 1 to Number_of_Messages do
		write (MessageFile, Messages[LoopSA]);
	Close (MessageFile);

	print('  Saving planets');
	Assign (PlanetFile, 'Planets.Dom');
	Rewrite (PlanetFile);
	for LoopSA := 1 to Number_of_Planets do
		write (PlanetFIle, Planet[LoopSA]);
	Close (PlanetFile);
End;

{ +!+!+!+ The Main Body of the Program! +!+!+!+ }

Begin
	pcount:=0;
	if upper(paramstr(1))='TEST' then
	begin
		val(paramstr(2),usernum,eq);
		thisuser.name:=paramstr(3);
		timeleft:=600;
		thisuser.linelen:=80;
		thisuser.pagelen:=25;
		timeon:=timer;
		okansi:=true;
		hangup:=false;
		print('>> >  >   >Test Mode<   <  < <<');
	end else
	begin
		Iport;
		assign(GenFile, 'Graphics.Sys');
		{$I-}
		reset(GenFile);
		{$I+}
		if IOResult<>0 then
		begin
			{writeln('File Not Found');}
		end
		else
		begin
			close(GenFile);
			okansi:=true;
		end;
    Introduction;
	end;
	Player_Number := 0;
  Load_Information;
  cls;
  Print_Messages;
  writeln;
  print (Month[CurMonth] + ' ' + St(Year));
  Main_Menu;
	Save_All;
	Ansic(MagentaF);
End.
