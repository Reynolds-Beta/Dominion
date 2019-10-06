{-----===== Sub menus to the Main Menu =====-----}

procedure Counterintelligence_Menu;
Begin
	Repeat
	nl;
	Ansic(GreenF);
	print ('Counterintelligence Menu');
	Ansic(MagentaF);
	print ('~~~~~~~~~~~~~~~~~~~~~~~~');
	if not (Empire[Player_Number].Expert) then
	Begin
		print (MagentaF+'Spy on an ('+CyanF+'E'+MagentaF+')mpire');
		print (MagentaF+'Spy on a ('+CyanF+'P'+MagentaF+')lanet');
		print (MagentaF+'Close intelligence ('+CyanF+'C'+MagentaF+')hannels');
		print (GreenF+'('+CyanF+'H'+GreenF+')elp');
		print (WhiteF+'('+CyanF+'Q'+WhiteF+')uit to Main Menu');
		nl;
	End;
	print ('Actions Remaining : ' + St(Empire[player_number].Intel_Reports));
	Ansic(RedF);
	tleft;
	if hangup then Exit;
	if Empire[Player_Number].Expert then
		prompt ('Option (E,C,H,P,Q) > ')
	else
		prompt ('Option > ');
	Onek (OneChar, 'ECHPQX');
	Case OneChar of
		'E' : Spy_Empire;                      {Case of... Sends }
		'H' : PrintFile ('HelpCoun.Dom');      {Program to Correct }
		'C' : Close_Channels;
		'P' : Spy_Planet;                      {Procedure for Counterintel. Input.}
		'X' : Empire[Player_Number].Expert := not (Empire[Player_Number].Expert);
	End; {case}
	Until onechar = 'Q';
End;

procedure Empire_Menu;
Begin
	Repeat
		nl;
		Ansic(GreenF);
		print ('Empire Management Menu');
		Ansic(MagentaF);
		print ('~~~~~~~~~~~~~~~~~~~~~~');
		if not (Empire[Player_Number].Expert) then
		Begin
			print (YellowF+'Make an ('+CyanF+'A'+YellowF+')nnouncement');
			print (YellowF+'('+CyanF+'C'+YellowF+')hange Empire''s Name');
			print (YellowF+'('+CyanF+'E'+YellowF+')nter Galaxy Trade Center');
			print (YellowF+'('+CyanF+'L'+YellowF+')ist Empires');
			print (YellowF+'Send ('+CyanF+'M'+YellowF+')essage to Another Player');
			print (YellowF+'('+CyanF+'S'+YellowF+')tatus of the Empire');
			print (YellowF+'Increase ('+CyanF+'T'+YellowF+')echnology Level');
			print (GreenF+'('+CyanF+'H'+GreenF+')elp');
			print (WhiteF+'('+CyanF+'Q'+WhiteF+')uit to Main Menu');
			nl;
		End;
		Ansic(RedF);
		tleft;
		if hangup then Exit;
		if Empire[Player_Number].Expert then
			prompt ('Option (A,C,H,E,L,M,Q,S,T) > ')
		else
			prompt ('Option > ');
		Onek (OneChar, 'ACEHLMQSTX');
		Case OneChar of
			 'A' : Announcement;
			 'C' : Change_Empire_Name;
			 'E' : Galaxy_Trade;
			 'H' : PrintFile ('HelpEmpi.Dom');
			 'L' : List_Empires;
			 'M' : Message;
			 'S' : Print_Empire (Player_Number);
			 'T' : Increase_Technology;
			 'X' : Empire[Player_Number].Expert := not (Empire[Player_Number].Expert);
		End;
	Until onechar = 'Q';
End;

procedure Maps;
Begin
	nl;
	Ansic(BlueF);
	prompt('|~~~|~~~|~~~|~~~|~~~|');
	Ansic(BlueF);
	print(' Each region is');
	Ansic(BlueF);
	prompt('|   |   |   |   |   |');
	Ansic(BlueF);
	print(' 10 x 50 light');
	Ansic(BlueF);
	prompt('|   |   |   |   |   |');
	Ansic(BlueF);
	print(' years');
	Ansic(BlueF);
	print('|   |   |   |   |   |');
	Ansic(BlueF);
	prompt('| 1 | 2 | 3 | 4 | 5 |');
	Ansic(BlueF);
	print(' Whole map is');
	Ansic(BlueF);
	prompt('|   |   |   |   |   |');
	Ansic(BlueF);
	print(' 50 x 50 ly');
	Ansic(BlueF);
	print('|   |   |   |   |   |');
	Ansic(BlueF);
	print('|   |   |   |   |   |');
	Ansic(BlueF);
	print('|___|___|___|___|___|');
	nl;
	Ansic(MagentaF);
	tleft;
	if hangup then Exit;
	prompt ('Print which map region? ');
	Onek (OneChar, 'Q12345');
	Case onechar of
		'1' : printfile('Region1.Dom');
		'2' : printfile('Region2.Dom');
		'3' : printfile('Region3.Dom');
		'4' : printfile('Region4.Dom');
		'5' : printfile('Region5.Dom');
	End;{case}
	nl;
	if onechar <> 'Q' then PauseScr;
End;

procedure Navy_Menu;
Begin
	Repeat
		nl;
		Ansic(GreenF);
		print ('Navy Management Menu');
		Ansic(MagentaF);
		print ('~~~~~~~~~~~~~~~~~~~~');
		if not Empire[Player_Number].Expert then
		Begin
			print (YellowF+'('+CyanF+'B'+YellowF+')uild New Ships');
			print (YellowF+'('+CyanF+'I'+YellowF+')nstall New Radar');
			print (YellowF+'('+CyanF+'C'+YellowF+')ompute Distance Between Planets');
			print (YellowF+'('+CyanF+'F'+YellowF+')leets in Flight');
			print (YellowF+'('+CyanF+'M'+YellowF+')ove Ships');
			print (YellowF+'('+CyanF+'P'+YellowF+')lanetary Status');
			print (YellowF+'('+CyanF+'S'+YellowF+')tatus of the Navy');
			print (YellowF+'('+CyanF+'E'+YellowF+')xamine Radars');
			print (YellowF+'('+CyanF+'R'+YellowF+')edirect Squadron');
			print (GreenF+'('+CyanF+'H'+GreenF+')elp');
			print (WhiteF+'('+CyanF+'Q'+WhiteF+')uit to Main Menu');
			writeln;
		End;
		Ansic(RedF);
		tleft;
		if hangup then Exit;
		if Empire[Player_Number].Expert then
			prompt ('Option (B,I,C,F,H,M,P,Q,S,E,R) > ')
		else
			prompt ('Option > ');
		Onek (OneChar, 'BICFHMSEPQXR');
		Case OneChar of
			'B' : Build_Ships;
			'I' : Build_radar;
			'C' : Compute_Distance;
			'F' : fleets_in_flight;
			'H' : PrintFile ('HelpNava.Dom');
			'M' : Move_Ships;
			'S' : Navy_Status;
			'E' : Examine_radar;
			'P' : planet_status;
			'X' : Empire[Player_Number].Expert := not Empire[Player_Number].Expert;
			'R' : Redirect_Squadron;
		End;
	Until onechar = 'Q';
End;

procedure Planet_Menu;
	Begin
		Repeat
		nl;
		Ansic(GreenF);
		print ('Planet Management Menu');
		Ansic(MagentaF);
		print ('~~~~~~~~~~~~~~~~~~~~~~');
		if not Empire[Player_Number].Expert then
		Begin
			print (YellowF+'('+CyanF+'A'+YellowF+')llocation for ALL Planets');
			print (YellowF+'('+CyanF+'C'+YellowF+')hange the Name of a Planet');
			print (YellowF+'('+CyanF+'D'+YellowF+')ecrease Industry Level of a Planet');
			print (YellowF+'('+CyanF+'E'+YellowF+')nhanced Area Planetary Scan');
			print (YellowF+'('+CyanF+'I'+YellowF+')ncrease Industry Level of a Planet');
			print (YellowF+'('+CyanF+'L'+YellowF+')ist All Planets');
			print (YellowF+'('+CyanF+'M'+YellowF+')anpower Allocation of a Planet');
			print (YellowF+'('+CyanF+'S'+YellowF+')tatus of a Planet');
			print (YellowF+'('+CyanF+'Z'+YellowF+')oom View Planets');
			print (YellowF+'('+CyanF+'B'+YellowF+')uild Warpgate');
			print (GreenF+'('+CyanF+'H'+GreenF+')elp');
			print (WhiteF+'('+CyanF+'Q'+WhiteF+')uit to Main Menu');
			writeln;
		End;
		Ansic(RedF);
		tleft;
		if hangup then Exit;
		if Empire[Player_Number].Expert then
			prompt ('Option (A,B,C,D,E,H,I,L,M,Q,S,Z) > ')
		else
			prompt ('Option > ');
		Onek (OneChar, 'ABCDEHILMQSXZ');
		Case OneChar of
			'A' : All_Manpower;
			'B'	: Build_Warpgate;
			'C' : Change_Planet_Name;
			'D' : Decrease_Industry;
			'E' : Spatial_Scan;
			'H' : PrintFile ('HelpPlan.Dom');
			'I' : Increase_Industry;
			'L' : List_Planets;
			'M' : Change_Manpower;
			'S' : Planet_Status;
			'X' : Empire[Player_Number].Expert := not Empire[Player_Number].Expert;
			'Z' : Zoom_View;
		End;
	Until onechar = 'Q';
End;

procedure Read_Recent_Happenings;
Var
	Recent_Happenings : Text;
	Next_Line : String80;
Begin
	writeln;
	tleft;
	if hangup then Exit;
	writeln;
	print (YellowF+'('+CyanF+'T'+YellowF+')his month''s, ('+
	CyanF+'L'+YellowF+')ast month''s,');
	prompt (YellowF+'or ('+CyanF+'B'+YellowF+')oth ? ');
	Onek (OneChar, 'BLT');
	cls;
	if (OneChar = 'L') or (OneChar = 'B') then
	begin
		printfile('Yesterda.dom');
		PauseScr;
	end;
	if (OneChar = 'T') or (OneChar = 'B') then
	begin
		printfile('Today.dom');
		PauseScr;
	end;
End;

procedure Scores;
Var
	LoopS : Byte;
Begin
	print ('Scoring');
	Empire[Player_Number].Points := Score (Player_Number);
	for LoopS := 1 to 20 do
	begin
		if (not moretech[loops].transporter) and (not moretech[loops].cloaking) then
		begin
			print(addrear(addfront(St(LoopS),2),5)+addrear(Empire[LoopS].Empire_Name,25)+addfront(St(Empire[LoopS].Points),25));
		end else
		begin
			print(addrear(addfront(St(LoopS),2),5)+addrear(Empire[LoopS].Empire_Name,25)+addfront('xxxxxxxxx',25));
		end;
	end;
	pausescr;
End;

{ -=*=*=*=*=> Make New Player is called from Load_Information <=*=*=*=*=- }

procedure Make_New_Player (What_Slot : Integer);
Var
	Name_of_Empire : String25;
	Name_of_HomeWorld : String20;
Begin
	cls;
	Ansic(GreenF);
	print ('Welcome New Warlord!');
	nl;
	ynq('Are you sure you want to play Dominions! ? ');
	if not YN then Halt;
	writeln;
	with Empire[What_Slot] do
	Begin
		User_Number := UserNum;
		User_Name := ThisUser.Name;
		radars[1] := 0;
		radars[2] := 1;
		radars[3] := 0;
		Planet[What_Slot].radars[1]:=0;
		Planet[What_Slot].radars[2]:=1;
		Planet[What_Slot].radars[3]:=0;
		Repeat
			writeln;
			print ('Enter the name of your Empire');
			prompt ('>');
			Input(BigString,25,false);
			nl;
			Empire_Name := BigString;
		Until Empire_Name > '';
	End;
	Repeat
		writeln;
		print ('Enter the name of your Homeworld');
		prompt ('>');
		Input(BigString, 20,false);
		nl;
		Planet[What_Slot].Planet_Name := BigString;
		Planet[What_Slot].radars[2] :=1;
	Until Planet[What_Slot].Planet_Name > '';
	Player_Number := What_Slot;
	prompt ('Your Empire is number ');
	Ansic(1);
	print (St(Player_Number));
	nl;
	pcount:=pcount+1;
	if pcount>=players_needed then eplayer:=true;
	PauseScr;
	cls;
	nl;
	print ('Please read the Instructions before playing Dominions!');
	print ('This will help you greatly and save you a lot of grief.');
	print ('All Menus have (H)elp commands if you need it.');
	nl;
	print ('Also, it is VERY neccessary to line capture or print the');
	print ('Maps of the Galaxy (command M from the Main Menu) if you');
	print ('wish to play effectively.  Some SysOps may place the map');
	print ('files in the download area to make it easier for you.');
	nl;
	Ansic(GreenF);
	print ('Thank you for playing Dominions!');
	nl;
	PauseScr;
