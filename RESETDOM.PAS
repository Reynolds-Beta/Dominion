Program Reset_Dominions;

Uses
  Dos, Crt;

		{This program will reset all Dominions! data to the correct }
		{BEGINNING form.  Use only if you're absolutely sure ya wanna }
		{do this.  This program is only for the Doctor's v1.60 }

		{AREA Effect radars added by The Doctor--May 1990}
		{Warpgates added by the Doctor--March 1991}

{$I DOM_VARS.PAS}  {Global declarations for dominions}

Var
	squadxyfile	: file of squadmappos;
	tech2file	: file of extratech;
	moretech:tech2;
	squadpos:squadxy;
	loopSA:integer;
	mdf:text;
	Empire : Empirerecs;
	Planet : Planetrecs;
	Squad : Squadronrecs;
	Messages : Messagerecs;
	Loop1, LoopGP : Integer;
	PosValid : Boolean;

procedure Create_Recent_Happenings;
Var
	RecentFile : Text;
Begin
	writeln('Erasing Old Recent Happenings');
	Assign (RecentFile, 'Yesterda.Dom');
	Rewrite (RecentFile);
	write (RecentFile, 'December 3000');
	write (RecentFile, ^M,^J);
	write (RecentFile, '~~~~~~~~~~~~~');
	write (RecentFile, ^M,^J);
	write (RecentFile, 'The Galactic Empire fell!');
	write (RecentFile, ^M,^J);
	Close (RecentFile);
	Assign (RecentFile, 'Today.Dom');
	Rewrite (RecentFile);
	write (RecentFile, ^M,^J);
	write (RecentFile, 'January 3001');
	write (RecentFile, ^M,^J);
	write (RecentFile, '~~~~~~~~~~~~');
	write (RecentFile, ^M,^J);
	Close (RecentFile);
	writeln('Creating New Recent Happenings');
End;

procedure Erase_Messages;
Var
	MessageFile : File of Messagerecord;
	LoopEM : Integer;
Begin
	writeln ('Erasing Old Messages');
	for LoopEM := 1 to Number_of_Messages do
		with Messages[LoopEM] do
		Begin
			Sent_By := 0;
			Sent_To := 0;
			Message := '';
		End;
		Assign (MessageFile, 'Messages.Dom');
		Rewrite (MessageFile);
		for LoopEM := 1 to Number_of_Messages do
			write (MessageFile, Messages[LoopEM]);
		Close (MessageFile);
End;

procedure Erase_Squads;
Var
	SquadFile : File of Squadronrecord;
	LoopES, LoopES2 : Integer;
Begin
	writeln('Erasing Squadrons');
	For LoopES := 1 to 600 do
		with Squad[LoopES] do
		Begin
			Owner := 0;
			Distance_Left := 0;
			Destination := 0;
			Speed := 0;
			for LoopES2 := 1 to 6 do
				Ships[LoopES2] := 0;
		End;
		Assign (SquadFile, 'Squads.Dom');
		Rewrite (SquadFile);
		for LoopES := 1 to 600 do
			write (SquadFile, Squad[LoopES]);
		Close (SquadFile);
End;

procedure Set_Date;
Const
	NewMonth : Integer = 1;
	NewYear : Integer = 3001;
Var
	File_for_Date : File of Integer;
	Laston_File : File of String160;
Begin
	Assign (File_for_Date, 'Date.Dom');
	Rewrite (File_for_Date);
	write (File_for_Date, NewMonth, NewYear);
	Close (File_for_Date);
	Assign (Laston_File, 'Laston.Dom');
	Rewrite (Laston_File);
	write ('11/04/92 Modified by The Doctor');
	Close (Laston_File);
End;

procedure Write_Maps;
Var
	MapFile          : Text;
	MapLoop, XLoop,
	YLoop, P         : Integer;
	PlanetHere       : Boolean;
Begin
	for MapLoop := 1 to 5 do
	Begin
		writeln('Writing Map Region ',MapLoop);
		Case MapLoop of
			1 : Assign (MapFile, 'Region1.Dom');
			2 : Assign (MapFile, 'Region2.Dom');
			3 : Assign (MapFile, 'Region3.Dom');
			4 : Assign (MapFile, 'Region4.Dom');
			5 : Assign (MapFile, 'Region5.Dom');
		End; {case}
		Rewrite (MapFile);
		for YLoop := 1 to 50 do
		Begin
			for XLoop := (-9 + 10 * MapLoop) to (0 + 10 * MapLoop) do
			Begin
				PlanetHere := false;
				for P := 1 to Number_of_Planets do
					with Planet[P] do
						if (X * 100 + Y) = (XLoop * 100 + YLoop) then
						Begin
							PlanetHere := true;
							write (MapFile, P:4);
						End;
				if not PlanetHere then write (MapFile, '    ');
			End;
			write (MapFile, ^M, ^J);
		End;
		Close (MapFile);
	End;
End;

procedure Make_HomeWorlds;
Var
	LoopMHW : Integer;
Begin
	writeln('Making HomeWorlds');
	for LoopMHW := 1 to 20 do
		with Planet[LoopMHW] do
		Begin
			writeln(LoopMHW);
			Planet_Name := '';
			Repeat
				PosValid := true;
				X := Random (50) + 1;
				Y := Random (50) + 1;
				if LoopMHW > 1 then
					for LoopGP := 1 to (LoopMHW - 1) do
						if (X * 100 + Y) = (Planet[LoopGP].X * 100 + Planet[LoopGP].Y)
							then PosValid := false;
			Until PosValid;
			Owner := LoopMHW;
			Population := 35000.0;
			Habitability := 75;
			Industry_Percent := 50;
			Technology_Percent := 50;
			Industrial_Level := 1.5;
			Ships[1] := 40;
			Ships[2] := 10;
			Ships[3] := 1;
			Ships[4] := 0;
			Ships[5] := 0;
			Ships[6] := 0;
			radars[1]:= 0;
			radars[2]:= 0;
			radars[3]:= 0;
			warpgate := 0;
			alignment:=random(19)+1;
		End;
End;

procedure Make_Empire_Worlds;
Var
	LoopMEW : Integer;
Begin
	writeln('Creating the Imperial Worlds');
	with Planet[21] do
	Begin
		writeln('21');
		Planet_Name := 'New Earth';
		Repeat
			PosValid := true;
			X := Random (50) + 1;
			Y := Random (50) + 1;
			for LoopGP := 1 to 20 do
				if (X * 100 + Y) = (Planet[LoopGP].X * 100 + Planet[LoopGP].Y)
					then PosValid := false;
		Until PosValid;
		Owner := 21;
		Population := 50000.0;
		Habitability := 100;
		Industry_Percent := 50;
		Technology_Percent := 50;
		Industrial_Level := 2.5;
		Ships[1] := 75;
		Ships[2] := 25;
		Ships[3] := 20;
		Ships[4] := 10;
		Ships[5] := 3;
		Ships[6] := 1;
    radars[1]:= 0;
		radars[2]:= 0;
		radars[3]:= 0;
		warpgate := 0;
		alignment:= 10;
	End;
	for LoopMEW := 22 to 25 do
		with Planet[LoopMEW] do
		Begin
			writeln(LoopMEW);
			Planet_Name := Planet_Names[LoopMEW];
			Repeat
				PosValid := true;
				X := Random (50) + 1;
				Y := Random (50) + 1;
				for LoopGP := 1 to (LoopMEW - 1) do
					if (X * 100 + Y) = (Planet[LoopGP].X * 100 + Planet[LoopGP].Y)
						then PosValid := false;
			Until PosValid;
			Owner := 21;
			Population := 25000.0;
			Habitability := 90;
			Industry_Percent := 50;
			Technology_Percent := 50;
			Industrial_Level := 2;
			Ships[1] := 50;
			Ships[2] := 15;
			Ships[3] := 5;
			Ships[4] := 1;
			Ships[5] := 0;
			Ships[6] := 0;
			radars[1]:= 0;
			radars[2]:= 0;
			radars[3]:= 0;
			warpgate := 0;
			alignment:= 10;
		End;
End;

procedure Make_Earth (Earth : Integer);
Begin
	with Planet[Earth] do
	Begin
		Planet_Name := 'Earth';
		Repeat
			PosValid := true;
			X := Random (50) + 1;
			Y := Random (50) + 1;
			for LoopGP := 1 to 25 do
				if (X * 100 + Y) = (Planet[LoopGP].X * 100 + Planet[LoopGP].Y)
					then PosValid := false;
		Until PosValid;
		Owner := 21;
		Population := 25000.0;
		Habitability := 100;
		Industry_Percent := 50;
		Technology_Percent := 50;
		Industrial_Level := 1.5;
		Ships[1] := 95;
		Ships[2] := 50;
		Ships[3] := 15;
		Ships[4] := 20;
		Ships[5] := 5;
		Ships[6] := 1;
		radars[1]:= 0;
		radars[2]:= 0;
		radars[3]:= 0;
		warpgate := 0;
		Alignment:= 10;
	End;
End;

procedure Make_Galaxy;
Var
	LoopMG, Earth : Integer;
	EarthMade : Boolean;
Begin
	writeln('Making the rest of the Galaxy');
	Earth := Random (175) + 26;
	Make_Earth (Earth);
	for LoopMG := 26 to Number_of_Planets do
	Begin
		writeln(LoopMG);
		if LoopMG <> Earth then
			with Planet[LoopMG] do
			Begin
				Planet_Name := '';
				Repeat
					PosValid := true;
					X := Random (50) + 1;
					Y := Random (50) + 1;
					for LoopGP := 1 to (LoopMG - 1) do
						if (X * 100 + Y) = (Planet[LoopGP].X * 100 + Planet[LoopGP].Y)
							then PosValid := false;
				Until PosValid;
				Owner := 0;
				Population := (Random (3000)) + 10001.0;
				Habitability := Random (90) + 11;
				Industry_Percent := 50;
				Technology_Percent := 50;
				Industrial_Level := (Random (2))/10+0.9;
				Ships[1] := Random (round(Habitability/3.5)) + 6;
				Ships[2] := random (round(Habitability/5));
				Ships[3] := random (round((Habitability-11)/15));
				Ships[4] := 0;
				Ships[5] := 0;
				Ships[6] := 0;
				radars[1]:= 0;
				radars[2]:= 0;
				radars[3]:= 0;
				warpgate := 0;
				Alignment:=random(19)+1;
			End;
	End;
End;

procedure Write_Planets;
Var
	PlanetFile : File of Planetrecord;
	LoopWP : Integer;
Begin
	writeln('Saving Galaxy');
	Assign (PlanetFile, 'Planets.Dom');
	Rewrite (PlanetFile);
	for LoopWP := 1 to Number_of_Planets do
	write (PlanetFile, Planet[LoopWP]);
	Close (PlanetFile);
End;

procedure Reset_Empires;
Var
	EmpireFile : File of Empirerecord;
	LoopRE : Integer;
Begin
	writeln('Erasing & Initializing Empires');
	for LoopRE := 1 to 20 do
		with Empire[LoopRE] do
		Begin
			writeln(LoopRE);
			User_Number := 0;
			User_Name := '';
			Empire_Name := '';
			Technology_Level := 1;
			Total_Population := 35000;
			Planets := 1;
			Intel_Reports := 10;
			Industry_Units := 10;
			Technology_Units := 4;
			Ships[1] := 40;
			Ships[2] := 10;
			Ships[3] := 1;
			Ships[4] := 0;
			Ships[5] := 0;
			Ships[6] := 0;
			radars[1]:= 0;
			radars[2]:= 0;
			radars[3]:= 0;
			Points := 30000.0 + 6000.0 + 15000.0;
			Expert := false;
			alignment:=planet[LoopRE].Alignment;
		End;
		writeln('Saving Empires');
		Assign (EmpireFile, 'Empires.Dom');
		Rewrite (EmpireFile);
		for LoopRE := 1 to 20 do
			write (EmpireFile, Empire[LoopRE]);
		Close (EmpireFile);
End;


{=============Main body of RESETDOM begins here=============}

Begin
	randomize;
	Create_Recent_Happenings;
	Erase_Messages;
	Erase_Squads;
	Set_Date;
	Make_HomeWorlds;
	Make_Empire_Worlds;
	Make_Galaxy;
	Write_Planets;
	Write_Maps;
	Reset_Empires;

	{ Some new Data files needed by this version 1.60 }

	assign(mdf,'mdays.dom');
	rewrite(mdf);
	writeln(mdf,' ');
	close(mdf);
	writeln('Creating new Squad coordinate file...');
	assign (squadxyfile, 'squadpos.dom');
	rewrite(squadxyfile);
	for LoopSA :=1 to Number_of_Squads do
	begin
		squadpos[LoopSA].maxspeed:=0;
		squadpos[LoopSA].xpos:=0;
		squadpos[LoopSA].ypos:=0;
		squadpos[LoopSA].xdest:=0;
		squadpos[LoopSA].ydest:=0;
		squadpos[LoopSA].stealth:=false;
		squadpos[LoopSA].stealtheff:=0;
		write (squadxyfile,squadpos[LoopSA]);
	end;
	close(squadxyfile);
	writeln('Creating new TECHNOLOGY file...');
	assign (tech2file,'tech2.dom');
	rewrite(tech2file);
	for LoopSA:=1 to Number_of_Players do
	begin
		moretech[LoopSA].warpmissle:=false;
		moretech[LoopSA].photontorp:=false;
		moretech[LoopSA].plasmatorp:=false;
		moretech[LoopSA].lasertrack:=false;
		moretech[LoopSA].laserarmor:=false;
		moretech[LoopSA].cloaking  :=false;
		moretech[LoopSA].transporter:=false;
		write(tech2file,moretech[LoopSA]);
	end;
	close(tech2file);
end.

End.
