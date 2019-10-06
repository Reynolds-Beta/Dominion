{ for Dominions! version 1.50 - December 1989 }

{ *!*!*!*!* The following procedures are called from more than one procedure.
  The procedures from which they are called are listed after the procedure's
  name is declared. *!*!*!*!*!* }

function Check_Planets : Boolean;
Begin
	Check_Planets := true;
	if Empire[Player_Number].Planets <= 0 then
	Begin
		print ('You have no planets!');
		Check_Planets := false;
	End;
End;

function RoundOff (RON : Real) : Real;
Var
	P : Real;
Begin
	p:=frac(ron);
	if P < 0.5 then RoundOff := RON - P;
	if P >= 0.5 then RoundOff := RON + 1 - P;
End;

function Score (Which_Empire : Integer) : Real;
Var
	LoopSC : Byte;
	Temp_Score : Real;
	hab:longint;
	hab2:real;
	ploop:integer;
Begin
	with Empire[Which_Empire] do
	Begin
		hab:=0;
		for ploop:=1 to number_of_planets do
		begin
			if planet[ploop].owner=which_empire then
			begin
				hab:=hab+planet[ploop].habitability;
			end;
		end;
		if planets>0 then
		begin
			hab2:=(hab/planets);
		end else
		begin
			hab2:=0;
		end;
		Temp_Score :=Total_Population + Ships[1] * 100 +
			Ships[2] * 200 + Ships[3] * 400 + Ships[4] * 800 +
			Ships[5] * 1600 + Ships[6] * 3200;
		for LoopSC := 1 to Planets do
			Temp_Score := Temp_Score + (300*hab2);
	End;
	Score := Temp_Score;
End;

procedure Print_Empire (Which_Empire : Byte);
Var
	LoopPE : Byte;
Begin
	with Empire[Which_Empire] do
	begin
		cls;
		nl;
		Ansic(MagentaF);
		print ('Empire Number : '+ CyanF + St(Which_Empire));
		print ('Name : '+CyanF + Empire_Name);
		print ('Alignment: '+CyanF+align_name[alignment]);
		print ('Planets : '+CyanF + St(Planets));
		print ('Technology Level : '+CyanF + StReal(Technology_Level,1));
		print ('Total Population : '+CyanF + St(Total_Population));
		print ('Industry Units : '+CyanF + St(Industry_Units));
		print ('Technology Units : '+CyanF + St(Technology_Units));
		if Player_Number = Which_Empire then
			print ('Intelligence Actions Left : '+CyanF + St(Intel_Reports));
		Ansic(YellowF);
		print ('Ships :');
		for LoopPE := 1 to Number_of_Ships do
			print ('   ' + Ship_Name[LoopPE] + ' : '+CyanF + St(Ships[LoopPe]));
		if radars[1] >0 then
			print(St(radars[1])+CyanF+' short range radar(s) installed.');
		if radars[2] >0 then
			print(St(radars[2])+CyanF+' mid range radar(s) installed.');
		if radars[3] >0 then
			print(St(radars[3])+CyanF+' long range radar(s) installed.');
		writeln;
		PauseScr;
	end;
End;

procedure Print_Planet (Which_Planet : Integer);
      { -= Called from Spy_Planet & Planet_Menu =- }
Var
	LoopPP : integer;
Begin
	with Planet[Which_Planet] do
	begin
		cls;
		nl;
		Ansic(GreenF);
		print ('Planet Number : ' +CyanF+ St(Which_Planet));
		Ansic(GreenF);
		print ('Name : '+CyanF + Planet_Name);
		print ('Alignment: '+CyanF+Align_name[alignment]);
		if Owner <> Player_Number then
			print (GreenF+'Owner : '+CyanF + St(Owner));
		Ansic(GreenF);
		print ('Location [X,Y] : '+CyanF + St(X) + ',' +
			St(Y));
		Ansic(GreenF);
		print ('Population : ' +CyanF+ St(Population));
		Ansic(GreenF);
		print ('Habitability : '+CyanF + St(Habitability) + ' %');
		Ansic(GreenF);
		print ('Industrial Level : '+CyanF + StReal(Industrial_Level,2));
		if Owner = Player_Number then
		Begin
			Ansic(MagentaF);
			print ('Work Allocation :');
			Ansic(BlueF);
			print ('   Industry : '+CyanF + St(Industry_Percent) + ' %');
			Ansic(BlueF);
			print ('   Technology : '+CyanF + St(Technology_Percent) + ' %');
		End;
		Ansic(YellowF);
		print ('Defenses :');
		for LoopPP := 1 to Number_of_Ships do
			print ('   '+ Ship_Name[LoopPP] + 's : '+CyanF + St(Ships[LoopPP]));
		if radars[1] =1 then
			print('A short range radar is installed.');
		if radars[2] =1 then
			print('A mid range radar is installed.');
		if radars[3] =1 then
			print('A long range radar is installed.');
		if warpgate>0 then
			print(WhiteF+'A '+RedF+warpgate_name[warpgate]+
				WhiteF+' is installed.');
		nl;
		PauseScr;
	end;
End;

procedure List_Empires;
      { -= Called from Spy_Empire =- }
Var
	LoopLE : Byte;
Begin
	for LoopLE := 1 to Number_of_Players do
	Begin
		prompt (addfront(St(LoopLE),2) + '  ');
		if Empire[LoopLE].User_Number = 0 then
			print ('Unowned')
		else
			print (Empire[LoopLE].Empire_Name);
	End;
	PauseScr;
End;

procedure List_Planets;
      { -= Called from Spy_Planet & Planet Menu =- }
Var
	LoopLP     : integer;
	planetname : string[28];
	abort      : boolean;
	next       : boolean;
	which_empire:integer;
Begin
	nl;
	abort := false;
	looplp := 0;
	Ansic(GreenF);
	prompt('List by (E)mpire or (A)ll ?');
	onek(onechar,'AE');
	nl;
	case onechar of
		'A'	: 
			Begin
				repeat
					looplp := looplp + 1;
					planetname := addfront(st(looplp),3)+'     ';
					if Planet[LoopLP].Owner > 0 then
						planetname := planetname + addrear(Planet[LoopLP].Planet_Name,20);
					Ansic(YellowF);
					if Planet[LoopLP].Owner>0 then
						printacr(planetname + RedF+addfront(St(Planet[LoopLP].Owner),5),abort,next);
					if (LoopLP / 20) = Int(LoopLP /20) then
						PauseScr;
				until (looplp = number_of_planets) or abort;
			end;
		'E'	: 
			Begin
				Ansic(GreenF);
				prompt('Planet list according to which Empire? ');
				input(bigstring,2,true);
				val(bigstring,which_empire,eq);
				nl;
				if (which_empire=0) or (eq<>0) then exit;
				repeat
					planetname := addfront(st(looplp),3)+'     ';
					if Planet[LoopLP].Owner =which_empire then
					begin
						if planet[LoopLP].planet_name='' then
							begin
								planetname := planetname + addrear('>Planet Not Named<',20);
							end else
							begin
								planetname := planetname + addrear(Planet[LoopLP].Planet_Name,20);
							end;
							Ansic(YellowF);
							printacr(planetname + RedF+addfront(St(Planet[LoopLP].Owner),5),abort,next);
							if (LoopLP / 20) = Int(LoopLP /20) then
								PauseScr;
					end;
					looplp := looplp + 1;
				until (looplp = number_of_planets) or abort;
			End;
	end;{case}
End;

procedure Add_On (Article : String160);
Var
	Recent_Happenings : Text;
Begin
	Assign (Recent_Happenings, 'Today.Dom');
	Append (Recent_Happenings);
	writeln (Recent_Happenings, Article);
	close (Recent_Happenings);
End;

procedure Send_Message (From, To_Whom : Integer; Msg : String160);
Var
	LoopSM : Byte;
Begin
	LoopSM := 0;
	Repeat
		LoopSM := LoopSM + 1;
		if LoopSM > Number_of_Messages then
		Begin
			print ('>All Message Records are Filled<');
			Exit;
		End;
	Until (Messages[LoopSM].Sent_To = 0);
	with Messages[LoopSM] do
	Begin
		Sent_By := From;
		Sent_To := To_Whom;
		Message := Msg;
	End;
End;

Procedure Destroy_Squad(mode,dkind,dTo,d1,d2,d3,d4,d5,d6:integer);
var
	LoopDS:integer;
	d,How_many:array[1..6] of integer;
begin
	d[1]:=d1;
	d[2]:=d2;
	d[3]:=d3;
	d[4]:=d4;
	d[5]:=d5;
	d[6]:=d6;
  	Ansic(WhiteF);
	Ansic(blink);
	case mode of
		0	:	print('Power Failure!  No transfer.');
		1	:	print('Warp Instability!  Partial transfer.');
	end;{case}
	Ansic(AllOff);
	nl;
	for LoopDS:=1 to Number_of_Ships do
	begin
		if d[LoopDS]>0 then
		begin
			how_many[LoopDS]:=random(d[LoopDS]);
			d[LoopDS]:=d[LoopDS]-How_Many[LoopDS];
			Ansic(MagentaF);
			print(st(how_many[LoopDS])+RedF+' '+Ship_Name[LoopDS]+' lost.');
		end else
		begin
			how_many[LoopDS]:=0;
		end;
	end;
	with planet[dto] do
	begin
		for LoopDS:=1 to Number_of_Ships do
		begin
			ships[LoopDS]:=ships[LoopDS]+d[LoopDS];
			empire[player_number].ships[LoopDS]:=empire[player_number].ships[LoopDS]-how_many[LoopDS];
		end;
		nl;
		Ansic(CyanF);
		if dkind>1 then
		begin
			Print(warpgate_name[dkind]+' degenerating to a '+warpgate_name[dkind-1]+'.');
			dkind:=dkind-1;
      warpgate:=dkind;
		end;
	end;
end;

Procedure Warp_Squad(pFrom,pTo,wgkind,s1,s2,s3,s4,s5,s6:integer);
var
	eff:integer;
	event:integer;
	LoopWS:integer;
	s:array[1..6] of integer;
begin
	s[1]:=s1;
	s[2]:=s2;
	s[3]:=s3;
	s[4]:=s4;
	s[5]:=s5;
	s[6]:=s6;
	nl;
	Ansic(Blink);
	Ansic(YellowF);
	print('Engaging '+warpgate_name[wgkind]+'.  Standing by at Planet '+st(pto)+'.');
	Ansic(AllOff);
	with planet[pfrom] do
	begin
		for LoopWS:=1 to Number_of_Ships do
		begin
			ships[LoopWS]:=ships[LoopWS]-s[LoopWS];
		end;
	end;
	randomize;
	eff:=warpgate_eff[wgkind]+(round((empire[player_number].technology_level-warpgate_tech[wgkind])/2));
	event:=random(100);
	if event>eff then
	begin
		event:=random(9)+1;
		case event of
			1..4	:	Destroy_Squad(1,wgkind,pTo,s[1],s[2],s[3],s[4],s[5],s[6]);
			5..10	: Destroy_Squad(0,wgkind,pFrom,s[1],s[2],s[3],s[4],s[5],s[6]);
		end;{case}
		exit;
	end;
	Ansic(GreenF);
	print('Squad has arrived safely at planet '+st(pTo)+'.');
	with planet[pto] do
	begin
		for LoopWS:=1 to Number_of_Ships do
		begin
			ships[LoopWS]:=ships[LoopWS]+s[LoopWS];
		end;
	end;
end;
