{-----===== Counter Intelligence Menu Procedures =====-----}

procedure Close_Channels;
var
	cost:longint;
begin
	with empire[player_number] do
	begin
		cost:=round((planets*50)+(Total_Population/10000));
		if cost=0 then cost:=30;
		if (moretech[player_number].transporter) or (moretech[player_number].cloaking) then
		begin
			nl;
			Ansic(GreenF);
			print('You have already sealed all channels!');
			exit;
		end;
		if industry_units<cost then
		begin
			nl;
			Ansic(GreenF);
			print('You need '+st(cost-industry_units)+' more industry units to do this!');
			exit;
		end;
		nl;
		Ansic(CyanF);
		print('This will cost you '+st(cost)+' industry units.');
		prompt('Proceed (Y/N)? ');
		if YN then
		begin
			industry_units:=industry_units-cost;
			moretech[player_number].transporter:=TRUE;
			nl;
			print('All intelligence channels closed!');
		end;
	end;
end;

procedure Spy_Empire;
Var
	Spy_Empire_Number : Integer;
Begin
	if Empire[Player_Number].Intel_Reports = 0 then
	Begin
		print ('You can not spy anymore this month.');
		Exit;
	End;
	Repeat                          {Repeats Until the Player no longer }
		writeln;                     {wants to see the List.}
		prompt ('Spy on Which Empire (? for List) > ');
		Input(BigString,2,true);
		nl;
		if BigString = '?' then List_Empires;
	Until BigString <> '?';
	Spy_Empire_Number := 0;
	Val (BigString, Spy_Empire_Number, eq);
	if (Spy_Empire_Number <= 0) or (eq <> 0) then Exit;
	if Spy_Empire_Number = Player_Number then
	Begin
		print ('You''re empire ' + St(Player_Number) + '!');
		Exit;
	End;
	if (Spy_Empire_Number > 0) and (Spy_Empire_Number <= Number_of_Players) then
	Begin
		if (moretech[spy_empire_number].transporter) or (moretech[spy_empire_number].cloaking) then
		begin
			print('All intelligence corridores to that empire are blocked!');
			exit;
		end;
		Print_Empire (Spy_Empire_Number);
		Empire[Player_Number].Intel_Reports := Empire[Player_Number].Intel_Reports - 1;
	End;
End;

procedure Spy_Planet;
Var
	Spy_Planet_Number : Integer;
Begin
	if Empire[Player_Number].Intel_Reports = 0 then
	Begin
		print ('You can not spy anymore this month.');
		Exit;
	End;
	Repeat
		writeln;
		prompt ('Spy on Which Planet (? for List) > ');
		Input(BigString,3,true);
		nl;
		if BigString = '?' then List_Planets;
	Until BigString <> '?';
	Spy_Planet_Number := 0;
	Val (BigString, Spy_Planet_Number, eq);
	if (Spy_Planet_Number <= 0) or (eq <> 0) then Exit;
	if Planet[Spy_Planet_Number].Owner = Player_Number then
		print ('You own planet ' + St(Spy_Planet_Number) + '!');
	if (Spy_Planet_Number > 0) and (Spy_Planet_Number <=
		Number_of_Planets) and (Planet[Spy_Planet_Number].Owner <>
		Player_Number) then
		Begin
			if (moretech[spy_planet_number].transporter) or (moretech[spy_planet_number].cloaking) then
			begin
				print('All intelligence channels to that planet are blocked!');
				exit;
			end;
			Print_Planet (Spy_Planet_Number);
			Empire[Player_Number].Intel_Reports := Empire[Player_Number].Intel_Reports - 1;
		End;
End;

{ -----=======>*>*> Empire Management Menu Procedures <*<*<======------ }
   { All of the following procedures were called from the Empire
     Management Menu.}

procedure Give(mode:integer);
var
	How_Much,
	Which_Planet,
	Which_Empire,
	loop:integer;
	ships_there:boolean;
begin
	ships_there:=false;
	with empire[player_number] do
	begin
		case mode of
			1:begin
					prompt ('You have '+st(Industry_Units)+' Industry Units.  How many will you give? ');
					Input(BigString, 3,true);
					nl;
					Val (BigString, How_Much, eq);
					if BigString = '' then Exit;
					If eq <> 0 then Exit;
					if how_much<1 then exit;
					if how_much>industry_units then
					begin
						Ansic(redf);
						print('You do not have that many Industry Units!');
						exit;
					end;
				end;
			2:begin
					prompt ('You have '+st(Technology_Units)+' Technology Units.  How many will you give? ');
					Input(BigString, 3,true);
					nl;
					Val (BigString, How_Much, eq);
					if BigString = '' then Exit;
					If eq <> 0 then Exit;
					if how_much<1 then exit;
					if how_much>Technology_units then
					begin
						Ansic(redf);
						print('You do not have that many Technology Units!');
						exit;
					end;
				end;
			3:begin
					prompt ('Which planet will you give away? ');
					Input(BigString, 3,true);
					nl;
					Val (BigString, which_planet, eq);
					if BigString = '' then Exit;
					If eq <> 0 then Exit;
					if (which_planet<1) or (which_planet>number_of_planets) then exit;
					if planet[which_planet].owner<>player_number then
					begin
						Ansic(redf);
						print('You do not own that planet!');
						exit;
					end;
					for loop:=1 to Number_of_Ships do
					begin
						if planet[which_planet].ships[loop]<>0 then ships_there:=true;
					end;
					if ships_there then begin
						nl;
						Ansic(YellowF);
						print('WARNING!!  Ships present on planet '+st(which_planet)+' will change ownership!');
					end;
				end;
		end;{case}
		prompt ('To which Empire will this go? [1-'+st(pcount)+',0=Abort] ');
		Input(BigString, 2,true);
		nl;
		Val (BigString, which_empire, eq);
		if BigString = '' then Exit;
		If eq <> 0 then Exit;
		if (which_empire<1) or (which_empire>pcount) then exit;
		if which_empire=player_number then exit;
		Ansic(WhiteF);
		prompt('Confirm transaction by typing CONFIRM, all else aborts: ');
		input(bigstring,8,true);
		nl;
		if bigstring<>'CONFIRM' then exit;
		case mode of
			1:begin
					empire[which_empire].industry_units:=empire[which_empire].industry_units+how_much;
					industry_units:=industry_units-how_much;
					send_message(0,Which_empire,'You recieved '+st(how_much)+' Industry Units from '+Empire_name+' ['+st(player_number)+'].');
				end;
			2:begin
					empire[which_empire].technology_units:=empire[which_empire].technology_units+how_much;
					technology_units:=technology_units-how_much;
					send_message(0,Which_empire,'You recieved '+st(how_much)+' Technology Units from '+Empire_name+
						' ['+st(player_number)+'].');
				end;
			3:begin
					planet[which_planet].owner:=which_empire;
					for loop:=1 to Number_of_Ships do
					begin
						empire[which_empire].ships[loop]:=empire[which_empire].ships[loop]+planet[which_planet].ships[loop];
						ships[loop]:=ships[loop]-planet[which_planet].ships[loop];
					end;
					empire[which_empire].total_population:=empire[which_empire].total_population+planet[which_planet].population;
					total_population:=total_population-planet[which_planet].population;
					empire[which_empire].planets:=empire[which_empire].planets+1;
					planets:=planets-1;
					send_message(0,which_empire,empire_name+' ['+st(player_number)+'] gave you planet '+st(which_planet)+'!');
				end;
		end;{case}
		Ansic(GreenF);
		print('Transaction complete!');
	end;
end;

procedure Galaxy_Trade;
begin
	nl;
	Ansic(CyanF);
	print('You can choose to give the following to an Empire...');
	Ansic(BlueF);
	print('('+YellowF+'I'+BlueF+')ndustry Units, ('+YellowF+'T'+BlueF+')echnology Units, or');
	Ansic(BlueF);
	prompt('('+YellowF+'P'+BlueF+')lanetary system.  [I,T,P,Q=Abort] ');
	onek(onechar,'ITPQ');
	case onechar of
		'I':Give(1);
		'T':Give(2);
		'P':Give(3);
		'Q':exit
	end;{case}
end;

procedure Announcement;
Var
	Recent_Happenings : Text;
Begin
	writeln;
	print ('Enter Announcement (Up to 75 characters).  Hit <Return> to abort.');
	prompt ('>');
	Input(BigString, 75,false);
	nl;
	if BigString = '' then
	Begin
		print ('Aborted');
		Exit;
	End;
	Add_On ('==> '+Empire[Player_Number].Empire_Name +' made an announcement...');
	Add_On (BigString);
	print ('Announcement Saved');
End;

procedure Change_Empire_Name;
Begin
	writeln;
	print ('Input New Empire Name (25 Characters Max)');
	prompt ('>');
	Input(BigString, 25,false);
	nl;
	if BigString = '' then
	Begin
		print ('Aborted.');
		Exit;
	End;
	Add_On (Empire[Player_Number].Empire_Name + ' changed it''s name to ' +
		BigString);
	Empire[Player_Number].Empire_Name := BigString;
	print ('New Empire name is ' + Empire[Player_Number].Empire_Name);
End;

procedure Message;
Var
	Send_To_Whom : Integer;
	Send_To_Valid : Boolean;
Begin
	Repeat
		Send_To_Valid := false;
		prompt ('Send Message to what Empire? ');
		Input (BigString, 2,true);
		nl;
		if BigString = '' then Exit;
		Val (BigString, Send_To_Whom, eq);
		if eq <> 0 then Exit;
		if (Send_To_Whom = 0) or (Send_To_Whom = Player_Number) then Exit;
		if (Send_To_Whom > 0) and (Send_To_Whom <= Number_of_Players)
			and (Empire[Player_Number].User_Number > 0)
			then Send_To_Valid := true;
	Until Send_To_Valid;
	print ('Enter Message (Up to 75 Characters).  Type <Return> to abort.');
	prompt ('>');
	Input(BigString, 75,false);
	nl;
	if BigString = '' then
	Begin
		print ('Aborted.');
		Exit;
	End;
	Send_Message (Player_Number, Send_To_Whom, BigString);
End;

procedure Increase_Technology;
Var
	IntIncrease : Integer;
	Increase : Real;
Begin
	print ('You have ' + St(Empire[Player_Number].Technology_Units) + ' technology units.');
	print ('Each .1 increase costs '+St(5+round(tech_modifier*empire[player_number].planets))+' technology units.');
	prompt ('Increase Technology Level by how much? ');
	Input(BigString, 3,true);
	nl;
	Val (BigString, Increase, eq);
	if BigString = '' then Exit;
	If eq <> 0 then Exit;
	if Increase <= 0.09 then Exit;
	Increase := Increase * 10;
	IntIncrease := round (Increase);
	Increase := IntIncrease / 10;
	if (Increase * (5+round(tech_modifier*empire[player_number].planets))*10) > Empire[Player_Number].Technology_Units then
		print ('Not enough Technology Units available');
	if (Increase * (5+round(tech_modifier*empire[player_number].planets))*10) <= Empire[Player_Number].Technology_Units then
	Begin
		Empire[Player_Number].Technology_Level := Empire[Player_Number].Technology_Level + Increase;
		Empire[Player_Number].Technology_Units := Empire[Player_Number].Technology_Units -
		round (Increase * (5+round(tech_modifier*empire[player_number].planets))*10);
		print ('Technology Level is now ' + StReal(Empire[Player_Number].Technology_Level,1));
	End;
End;

{--------========>*>*> Navy Menu Procedures <*<*<=========--------}

   { All of the following procedures were called from the Navy Management
     Menu.}

procedure Redirect_Squadron;
var
	LoopRS,Loop2				:	integer;
	Squadron_to_Redirect:	real;
	New_Destination,hyp	:   real;
	ndest,ndx,
	ndy,px,py,rdsquad		:	integer;
	newspeed						:	real;
begin
	Ansic(GreenF);
	print('   Target   Warp   Distance');
	Ansic(GreenF);
	Print(' # Planet  Factor  to Target      FR      DR      CR      BS      DN      SDN');
	Ansic(BlueF);
	Print('-----------------------------------------------------------------------------');
	Ansic(CyanF);
	for LoopRS:=1 to Number_of_Squads do
	begin
		if Squadron[LoopRS].Owner=Player_Number then
		begin
			with Squadron[LoopRS] do
			Begin
			  prompt(addfront(st(LoopRS),3)+addfront(st(Destination),4)+
				addfront(St(Speed),8)+addfront(StReal(Distance_Left,2),10)+'   ');
			  for Loop2:=1 to Number_of_Ships do
				Begin
				  prompt (addfront(st(Ships[Loop2]),8));
				end;
			  writeln;
			end;
		end;
	end;
	Ansic(MagentaF);
	nl;
	prompt('Change which Squadron >');
	Input(BigString, 4,true);
	nl;
	if BigString='' then exit;
	Val (BigString, Squadron_to_Redirect, eq);
	if eq<>0 then exit;
	rdsquad:=round(Squadron_to_Redirect);
	if Squadron[rdsquad].Owner<>Player_Number then
	begin
		Ansic(CyanF);
		print('You do not own that squadron!');
		exit;
	end;
	prompt('New planetary destination >');
	input(BigString,4,true);
	nl;
	if BigString='' then exit;
	val (BigString,New_Destination,eq);
	if eq<>0 then exit;
	ndest:=round(New_Destination);
	if (ndest<1) or (ndest>Number_of_Planets) then exit;
	if ndest<21 then
	begin
		if Planet[ndest].Owner=0 then
		begin
			print('You cannot Redirect to unowned Homeworlds!');
			exit;
		end;
	end;
	newspeed:=-1;
	nl;
	Ansic(GreenF);
	prompt('Would you like to change speed?  (Y/N)');
	if YN then
	begin
		prompt('Enter new speed [0 - '+st(squadpos[rdsquad].maxspeed)+'] >');
		input(BigString,2,true);
		nl;
		if BigString='' then exit;
		val (BigString,newspeed,eq);
		if eq<>0 then exit;
		if newspeed<0 then
		begin
			Ansic(CyanF);
			print('You cannot go backwards!');
			exit;
		end;
		if newspeed>squadpos[rdsquad].maxspeed then
		begin
			Ansic(CyanF);
			print('You cannot go faster than your slowest ship!');
			exit;
		end;
	end;
	Ansic(CyanF);
	prompt('Are you sure you wish to alter squadron '+st(rdsquad)+'? (Y/N)');
	if YN then
	begin
		ndx:=Planet[ndest].X;
		ndy:=Planet[ndest].Y;
		px:=squadpos[rdsquad].xpos;
		py:=squadpos[rdsquad].ypos;
		hyp:=sqrt(sqr(px-ndx)+sqr(py-ndy));
		Squadron[rdsquad].Destination:=ndest;
		squadpos[rdsquad].xdest:=ndx;
		squadpos[rdsquad].ydest:=ndy;
		Squadron[rdsquad].Distance_Left:=hyp;
		if newspeed<>-1 then
			Squadron[rdsquad].Speed:=round(newspeed);
		print('Squadron responding to corrections.');
		print('Target:'+st(ndest)+'  Speed:'+st(Squadron[rdsquad].Speed));
	end;
end;

procedure Fleets_in_Flight;
Var
	Loop, Loop2 : Integer;
	Temp        : Array[1..6] of Real;
	with_stealth:	boolean;
	schar:char;

Begin
	with_stealth:=false;
	for Loop:=1 to Number_of_Ships do Temp[Loop] := 0;
	writeln;
	print(YellowF+'Target   Warp   Distance');
	Print(YellowF+'Planet  Factor  to Target      FR      DR      CR      BS      DN      SDN');
	Print(BlueF+'--------------------------------------------------------------------------');
	for Loop:=1 to Number_of_Squads do
		if Squadron[Loop].Owner = Player_Number then
      with Squadron[Loop] do
			Begin
				if squadpos[loop].stealth then
				begin
					schar:='S';
					with_stealth:=true;
					Ansic(YellowF);
				end else
				begin
					schar:=' ';
				end;
				prompt(addfront(st(Destination),4)+addfront(St(Speed)+' '+schar,8)+
					addfront(StReal(Distance_Left,2),10)+'   ');
				for Loop2:=1 to Number_of_Ships do
				Begin
					prompt (addfront(st(Ships[Loop2]),8));
					Temp[Loop2] := Round (Temp[Loop2] + Ships[Loop2]);
				End;
				nl;
			End;
	Ansic(BlueF);
	Print('--------------------------------------------------------------------------');
	Ansic(YellowF);
	prompt('            Ship Totals: ');
	for Loop:=1 to Number_of_Ships do
	begin
		prompt (GreenF+addfront(streal(Temp[Loop],0),8));
	end;
	nl;
	nl;
	if with_stealth then
	begin
		Ansic(YellowF);
		print('           S denotes a Stealth equipped squadron.');
	end;
	PauseScr;
	writeln;
End;

procedure Build_Ships;
Var
	Building_Options : String[8];
	Which_Ship,
	Place_Where,H    : Integer;
	How_Many         : real;
	Can_Build        : Boolean;
Begin
	Building_Options := '0';
	writeln;
	if not Check_Planets then Exit;
	Can_Build := false;
	print (MagentaF+'(' +CyanF+St(0)+MagentaF+') Abort');
	for h := 1 to Number_of_Ships do
	Begin
		if Ship_Tech[H] <= Empire[Player_Number].Technology_Level then
		Begin
			print (MagentaF+'(' +CyanF+St(H)+MagentaF+') ' + Ship_Name[H]);
			Building_Options := Building_Options + St(H);
		End;
	End;
	writeln;
	prompt ('Build which kind of ship? ');
	Onek (OneChar, Building_Options);
	Val (OneChar, Which_Ship, eq);
	if eq <> 0 then Exit;
	if Which_Ship = 0 then Exit;
	nl;
	print (St(Empire[Player_Number].Industry_Units) + ' Industry Units available.');
	print ('Each ' + Ship_Name[Which_Ship] + ' costs ' + St(Ship_Cost[Which_Ship]) +
		' Industry Units.');
	prompt ('Build how many ' + Ship_Name[Which_Ship] + 's? ');
	Input(BigString, 4,true);
	nl;
	if BigString = '' then Exit;
	Val (BigString, How_Many, eq);
	if eq <> 0 then Exit;
	How_Many := How_Many - Frac(How_Many);
	if How_Many < 1 then Exit;
	if (How_Many + Empire[Player_Number].Ships[Which_Ship]) > 32700 then
	Begin
		print ('Your war computers can not control that many ' +
			Ship_Name[Which_Ship] + 's at one time');
		Exit;
	End;
	if (How_Many * Ship_Cost[Which_Ship]) > Empire[Player_Number].Industry_Units
		then print ('Not enough Industry Units available for production.');
	if (How_Many * Ship_Cost[Which_Ship]) <= Empire[Player_Number].Industry_Units	then
	Begin
		writeln;
		prompt ('Put Ships on what Planet? ');
		Input(BigString,3,true);
		nl;
		Val (BigString, Place_Where, eq);
		if eq <> 0 then Exit;
		if (Place_Where <= 0) or (Place_Where > Number_of_Planets)
			or (BigString = '') then
			Begin
				print ('Aborted.');
				Exit;
			End;
		if (Place_Where <= Number_of_Planets) and
			(Planet[Place_Where].Owner = Player_Number) then
			Begin
				if (How_Many * round(Ship_Crew[Which_Ship]/4))>=Planet[Place_Where].Population then
				begin
					print('You do not have enough people to minimally crew the ships!');
					exit;
				end;
				Planet[Place_Where].Population:=Planet[Place_Where].Population-
					(How_Many*round(Ship_Crew[Which_Ship]/4));
				Empire[Player_Number].Total_Population:=Empire[Player_Number].Total_Population-
					(How_Many*round(Ship_Crew[Which_Ship]/4));
				Planet[Place_Where].Ships[Which_Ship] := Planet[Place_Where].Ships[Which_Ship] +
					trunc(How_Many);
				Empire[Player_Number].Ships[Which_Ship] := Empire[Player_Number].Ships[Which_Ship] +
					trunc(How_Many);
				Empire[Player_Number].Industry_Units := Empire[Player_Number].Industry_Units -
					How_Many * Ship_Cost[Which_Ship];
				print (St(How_Many) + ' ' + Ship_Name[Which_Ship] + '(s) built on planet ' +
					St(Place_Where) + '.');
			End;
			if Planet[Place_Where].Owner <> Player_Number then
				print  ('You do not own that planet!');
			nl;
	End;
End;

procedure Compute_Distance;
Var
	Planet1, Planet2 : Integer;
	Distance : Real;
Begin
	Repeat
		writeln;
		prompt ('Compute distance from planet ');
		Input (BigString, 3,true);
		nl;
		Planet1 := 0;
		Val (BigString, Planet1, eq);
		if (Planet1 <= 0) or (eq <> 0) then Exit;
	Until (Planet1 > 0) and (Planet1 <= Number_of_Planets);
	Repeat
		prompt ('to planet ');
		Input (BigString, 3,true);
		nl;
		Val (BigString, Planet2, eq);
		if (Planet2 <= 0) or (eq <> 0) then Exit;
	Until (Planet2 > 0) and (Planet2 <= Number_of_Planets);
	Distance := Sqrt(Sqr(Planet[Planet1].X - Planet[Planet2].X) +
		Sqr(Planet[Planet1].Y - Planet[Planet2].Y));
	nl;
	print ('The distance is ' + StReal(Distance,2) + ' light years.');
End;

procedure Move_Ships;
Var
	temppop:	real;
	From_Where, To_Where,
	Temp_Owner, How_Many,
	Tloopms,LoopMS, LoopMS2,
	zeroloop             : Integer;
	stealthcost	:longint;
	effect	:longint;
	stealthyes	:boolean;
	kindf,kindt:integer;
	timer1,
	timer2:real;
	timei:integer;
Begin
	stealthyes:=false;
	nl;
	if not Check_Planets then Exit;
	LoopMS := 0;
	Repeat
		LoopMS := LoopMS + 1;
	Until (Squadron[LoopMS].Destination = 0) or (LoopMS > Number_of_Squads);
	if LoopMS > Number_of_Squads then
	Begin
		Ansic(WhiteF);
		Ansic(blink);
		print ('WARN SYSOP!  All squadron data records are full!');
		Ansic(AllOff);
		Exit;
	End;
	Repeat
		Repeat
      prompt ('Move ships From what planet? ');
      Input (BigString, 3,true);
      nl;
      if BigString = '' then Exit;
      Val (BigString, From_Where, eq);
      if eq <> 0 then Exit;
      if From_Where = 0 then Exit;
		Until (From_Where > 0) and (From_Where <= Number_of_Planets);
	Until Planet[From_Where].Owner = Player_Number;
	Repeat
		temppop:=Planet[From_Where].Population;
		prompt ('Send ships To what planet? ');
		Input (BigString, 3,true);
		nl;
		nl;
		Val (BigString, To_Where, eq);
		if (eq <> 0) then Exit;
	Until (To_Where > 0) and (To_Where <= Number_of_Planets);
	Temp_Owner := Planet[To_Where].Owner;
	if (To_Where <= Number_of_Players) and (Empire[Temp_Owner].User_Number = 0) then
	Begin
		print ('You can''t attack unowned Home planets.');
		Exit;
	End;
	for zeroloop := 1 to number_of_ships do
		squadron[loopms].ships[zeroloop] := 0;
	for LoopMS2 := 1 to Number_of_Ships do
		if Planet[From_Where].Ships[LoopMS2] > 0 then
		Begin
			Repeat
				Ansic(GreenF);
				prompt ('Send how many ' + Ship_Name[LoopMS2] + 's [0 - '
					+ St(Planet[From_Where].Ships[LoopMS2]) + '] ');
				Input (BigString, 5,true);
				nl;
				Val (BigString, How_Many, eq);
				if eq <> 0 then How_Many := 0;
				if BigString = '' then How_Many := 0;
				if how_many < 1 then how_many := 0;
				if How_Many > Planet[From_Where].Ships[LoopMS2] then
					print  (RedF+'  You don''t have that many!');
			Until (How_Many <= Planet[From_Where].Ships[LoopMS2]);
			Squadron[LoopMS].Ships[LoopMS2] := How_Many;
		End;
	with Squadron[LoopMS] do
	begin
		ec:=0;
		for ed:=1 to number_of_ships do ec:=ec+Ships[ed];
		if ec = 0 then Exit;
		Distance_Left := Sqrt(Sqr(Planet[From_Where].X - Planet[To_Where].X) +
			Sqr(Planet[From_Where].Y - Planet[To_Where].Y));
		kindf:=planet[from_where].warpgate;
		kindt:=0;
		if planet[to_where].owner=player_number then
			kindt:=planet[to_where].warpgate;
		if (distance_left<warpgate_range[kindf]) and (kindf>0) and (kindt>0) then
		begin
			nl;
			prompt(MagentaF+'Use the '+warpgate_name[kindf]+YellowF+' (Y/N)? ');
			if yn then
			begin
				warp_squad(From_where,To_where,kindf,ships[1],ships[2],ships[3],ships[4],ships[5],ships[6]);
				nl;
				exit;
			end;
		end;
		if (Ships[4] > 0) or (Ships[5] > 0) then Speed := 6;
		if (Ships[3] > 0) or (Ships[6] > 0) then Speed := 5;
		if (Ships[1] > 0) or (Ships[2] > 0) then Speed := 4;
		timer1:=(mdays*distance_left/Speed);
		timer2:=timer1;
		if frac(timer1)>0 then timer1:=timer1+(1-frac(timer2));
		timei:=round(timer1);
		nl;
		Ansic(YellowF);
		print ('The squadron will travel ' +WhiteF+ StReal(Distance_Left,2) + YellowF+' light years,');
		Ansic(YellowF);
		print ('at a speed of warp ' +WhiteF+ St(Speed)+YellowF+'.');
		nl;
		Ansic(MagentaF);
		prompt ('ETA: '+CyanF+st(timei));
		Ansic(MagentaF);
		if timei>1 then
		begin
			print(' months.');
		end else
		begin
			print(' month.');
		end;
		nl;

		stealthcost:=0;
		effect:=0;
		for zeroloop:=1 to Number_of_Ships do
			stealthcost:=stealthcost+round(Ship_Cost[zeroloop]*Ships[zeroloop]);
		ec:=0;
		effect:=0;
		for ed:=1 to Number_of_ships do
		begin
			ec:=ec+ships[ed];
			effect:=effect+(Ships[ed]*Eff[ed]);
		end;
		effect:=round(effect/ec);
		stealthcost:=stealthcost+ec;
		if Empire[Player_Number].Industry_Units<Stealthcost then
		begin
			effect:=effect-abs(round((Empire[Player_Number].Industry_Units-Stealthcost)/3.5));
			if effect<1 then effect:=0;
			Stealthcost:=trunc(Empire[Player_number].Industry_Units);
		end;
		if (effect>0) and (Stealthcost>0) then
		begin
			Ansic(MagentaF);
			print ('Squadron can be refit with '+YellowF+st(effect)+'%'+MagentaF+' effective STEALTH Anti-Radar technology');
			Ansic(MagentaF);
			prompt('for '+YellowF+st(stealthcost)+MagentaF+' Industry Units. (Y/N)? ');
			if YN then stealthyes:=true;
		end else
		begin
			Ansic(redf);
			print('Squadron cannot be refit with Stealth.');
		end;
		nl;
		Ansic(WhiteF);
		prompt ('Are you sure you want to send these ships? ');
		if YN then
		Begin
			tloopms:=loopms;
			for LoopMS2 := 1 to Number_of_Ships do
			begin
				Planet[From_Where].Population:=Planet[From_Where].Population-(round(Ship_Crew[LoopMS2]*0.75)*Ships[LoopMS2]);
				if Planet[From_Where].Population<0 then
				begin
					Planet[From_Where].Population:=temppop;
					print('Not enough people to crew these ships!');
					for ed:=1 to number_of_ships do Ships[ed]:=0;
					speed:=0;
					Distance_Left:=0;
					owner:=0;
					destination:=0;
					exit;
				end;
			end;
			if stealthyes then
			begin
				Squadpos[LoopMS].stealth:=true;
				Squadpos[LoopMS].stealtheff:=effect;
				Empire[Player_Number].Industry_Units:=Empire[Player_Number].Industry_Units-stealthcost;
			end;
			for LoopMS2 := 1 to Number_of_Ships do
			begin
				Planet[From_Where].Ships[LoopMS2] := Planet[From_Where].Ships[LoopMS2] -
					Ships[LoopMS2];
				Empire[Player_Number].Total_Population:=Empire[Player_Number].Total_Population-
					(round(Ship_Crew[LoopMS2]*0.75)*Ships[LoopMS2]);
			end;
			print ('Squadron Sent');
			Owner := Player_Number;
			Destination := To_Where;
			Squadpos[tLoopMS].xpos:=Planet[From_Where].X;
			Squadpos[tLoopMS].ypos:=Planet[From_Where].Y;
			Squadpos[tLoopMS].xdest:=Planet[To_Where].X;
			Squadpos[tLoopMS].ydest:=Planet[To_Where].Y;
			Squadpos[tLoopMS].maxspeed:=Speed;
		End;
	end;
End;

procedure Navy_Status;
Var
	Loop : integer;
	LoopSKA:integer;
	counter:integer;
	flag:boolean;
	abort,next : boolean;
	wg:string[1];
	wgt:boolean;
	rad:string[1];
	radt:boolean;
Begin
	nl;
	abort := false;
	print ('Technology Level : ' + StReal(Empire[Player_Number].Technology_Level,1));
	nl;
	Ansic(YellowF);
	print ('Planet     Percent');
	Ansic(YellowF);
	print ('Number   Habitability    FR     DS     CR     BS     DN     SDN');
	Ansic(BlueF);
	print ('----------------------------------------------------------------');
	loop := 1;
	wgt:=false;
	radt:=false;
	while (not abort) and (loop <= number_of_planets) do
	Begin
		if Planet[Loop].Owner = Player_Number then
			with Planet[Loop] do
			begin
				if warpgate=0 then
				begin
					wg:=' ';
				end else
				begin
					wg:='*';
					wgt:=true;
				end;
				if radars[1]+radars[2]+radars[3]>0 then
				begin
					rad:='R';
					radt:=true;
				end else
				begin
					rad:=' ';
				end;
				Ansic(GreenF);
				printacr(addfront(St(Loop),3) +YellowF+wg+MagentaF+rad+CyanF+addfront(st(habitability),10)+
					addfront(St(Ships[1]),12) + addfront(St(Ships[2]),7) +
					addfront(St(Ships[3]),7) + addfront(St(Ships[4]),7) +
					addfront(St(Ships[5]),7) + addfront(St(Ships[6]),7),abort,next);
			end;
		loop := loop + 1;
	End;
	if Empire[Player_Number].Planets > 0 then
	Ansic(BlueF);
	print ('----------------------------------------------------------------');
	with Empire[Player_Number] do
		print (WhiteF+'Totals '+GreenF+addfront(St(Ships[1]),20)+addfront(St(Ships[2]),7) +
			addfront(St(Ships[3]),7) + addfront(St(Ships[4]),7) +addfront(St(Ships[5]),7)+addfront(St(Ships[6]),7));
	nl;
	if wgt then print(YellowF+'   * Indicates a planet with a Warpgate.');
	if radt then print(MagentaF+'    R Indicates a Radar equipped planet.');
	PauseScr;
	nl;
End;

{-------===========***** Radar Procedures Begin *****=========-------}

procedure Build_radar;
var
	Building_Options : string[8];
	Which_radar,
	Place_Where,
	H,
	flag             : integer;
Begin
	flag:=0;
	Building_Options:='0';
	nl;
	if not Check_Planets then Exit;
	Ansic(MagentaF);
	print('('+GreenF+'0'+MagentaF+') Abort');
	for H:=1 to Number_of_radars do
	Begin
		if radar_tech[H] <= Empire[Player_Number].Technology_level then
		begin
			Ansic(MagentaF);
			print('('+GreenF+St(H)+MagentaF+') '+radar_name[H]);
			Building_Options:=Building_Options + St(H);
			flag:=1;
		end;
	end;
	if flag = 0 then
	begin
		print('Your tech level is too low to build radars!!');
		Exit;
	end;
	writeln;
	prompt('Build which type of radar? ');
	Onek (OneChar,Building_Options);
	val(OneChar,Which_radar,eq);
	if eq <> 0 then Exit;
	if Which_radar = 0 then Exit;
	nl;
	print(CyanF+St(Empire[Player_Number].Industry_Units)+MagentaF+' Industry units available.');
	Ansic(MagentaF);
	print('A '+radar_name[Which_radar]+' costs '+GreenF+St(radar_cost[Which_radar])+MagentaF+' Industry units.');
	Ansic(YellowF);
	prompt ('Are you sure you want to install a radar? ');
	if YN then
	begin
		if (radar_cost[Which_radar]) > Empire[Player_Number].Industry_Units then
		print ('Not enough Industry Units available to build the radar!');
		if (radar_cost[Which_radar]) <= Empire[Player_Number].Industry_Units then
		begin
			nl;
			Ansic(MagentaF);
			prompt('Put radar on which planet? [0=Abort] ');
			Input (BigString,3,true);
			nl;
			val(BigString,Place_Where,eq);
			if eq<>0 then Exit;
			if (Place_Where <=0) or (Place_Where > Number_of_Planets) or (BigString = '') then
			begin
				Ansic(YellowF);
				print('Radar installation ABORTED!');
				Exit;
			end;
			if (Place_Where <= Number_of_Planets) and (Planet[Place_Where].Owner = Player_Number) then
			begin
				flag:=0;
				for H:=Which_radar to 3 do
					if (Planet[Place_Where].radars[H]=1) then
					begin
						print('You already have that type or better.');
						flag:=1;
					end;
				Ansic(GreenF);
				for H:=1 to (Which_radar - 1) do
					if (Planet[Place_Where].radars[H] =1) then
					begin
						print('Your existing '+radar_name[H]+' radar is replaced.');
						Planet[Place_Where].radars[H]:=0;
						Empire[Player_Number].radars[H]:=Empire[Player_Number].radars[H]-1;
					end;
				if flag=0 then
				begin
					Planet[Place_Where].radars[Which_radar]:=1;
					Empire[Player_Number].radars[Which_radar]:=Empire[Player_Number].radars[Which_radar]+1;
					Empire[Player_Number].Industry_Units:=
					Empire[Player_Number].Industry_Units -radar_cost[Which_radar];
					nl;
					print('A '+radar_name[Which_radar]+' radar has been installed on planet '+St(Place_Where)+'.');
				end;
			end;
			if Planet[Place_Where].Owner<>Player_Number then
			begin
				Ansic(redf);
				print('You do not own that planet!');
			end;
			nl;
		end;
	end;
end;

procedure Examine_radar;
var
	planloop,	LoopSKA,
	Attacked,	class,
	flag, px,
	py, maxx,
	minx, maxy,count,
	miny				:integer;
	hyp					:real;
	whose				:string[40];
Begin
	flag:=0;
	count:=0;
	print('Checking Radars. . .');
	for LoopSKA:=1 to Number_of_Squads do
		with Squadron[LoopSKA] do
			if Speed>0 then
			Begin
			  for planloop:=1 to Number_of_Planets do
					if Planet[planloop].Owner=Player_Number then
					begin
						Attacked:=planloop;
						class:=0;
						px:=squadpos[LoopSKA].xpos;
						py:=squadpos[LoopSKA].ypos;
						if (Planet[Attacked].radars[1] <>0) then class:=1;
						if (Planet[Attacked].radars[2] <>0) then class:=2;
						if (Planet[Attacked].radars[3] <>0) then class:=3;
						if class>0 then
						begin
							if attacked=destination then whose:=WhiteF+Blink+'Attacking'+ AllOff ;
							if destination<>attacked then whose:=CyanF+'Passing';
							if squadpos[LoopSKA].stealth then whose:=whose+' *Stealth Detected*';
							hyp:=sqrt(sqr(px-Planet[planloop].X)+sqr(py-Planet[planloop].Y));
							if (hyp<=radar_range[class]) and (detects>squadpos[LoopSKA].stealtheff) and not (owner=player_number) then
							begin
								Ansic(YellowF);
								print('Radar on planet '+addfront(St(Attacked),3)+' reports ships: '+whose);
								Ansic(MagentaF);
								print('From Empire:' +addfront(St(Owner),2)+', Dist.: '+StReal(hyp,2)
									+', Speed: '+addfront(St(Speed),1)
									+', Ships: '+addfront(St(Ships[1]),3)
									+', '+addfront(St(Ships[2]),3)
									+', '+addfront(St(Ships[3]),3)
									+', '+addfront(St(Ships[4]),3)
									+', '+addfront(St(Ships[5]),3)
									+', '+addfront(St(Ships[6]),3));
								nl;
								flag:=1;
								count:=count+1;
								if count>5 then
								begin
									pausescr;
									count:=0;
								end;
							end;
						end;
					end;
			end;
	if flag=0 then
	print(' Nothing to report.');
end;

{------============******** Radar Procedure Ends ********============------}

{ -------=======>*>*>!> Planet Menu Procedures <!<*<*<=======------- }
   { All of the following procedures were called from the Planet Management
     Menu.}

Procedure Spatial_Scan;
var
	distance:real;
	from_planet,loop,loop2,radartype,shipnum:integer;
	shipst:string[9];
begin
	nl;
	prompt ('Scan sector around which planet? [0=Abort] ');
	Input (BigString, 3,true);
	nl;
	nl;
	if BigString = '' then Exit;
	Val (BigString, from_planet, eq);
	if eq <> 0 then Exit;
	if (from_planet <1) or (from_planet>number_of_planets) then Exit;
	with planet[from_planet] do
	begin
		if owner<>player_number then
		begin
			Ansic(redf);
			print('You do not own that planet!');
			exit;
		end;
		radartype:=0;
		for loop:=1 to 3 do
			if radars[loop]>0 then radartype:=loop;
		if radartype=0 then
		begin
			Ansic(redf);
			print('There is no radar installation on that planet!');
			exit;
		end;
		radartype:=0;
		for loop:=1 to 3 do
			if radars[loop]>0 then radartype:=loop;
		Ansic(YellowF);
		print('Number   Owner    TechLev  IndLev   Total Ships   Distance');
		Ansic(MagentaF);
		print('----------------------------------------------------------');
		for loop:=1 to number_of_planets do
		begin
			distance:=sqrt(sqr(x-Planet[loop].X)+sqr(y-Planet[loop].Y));
			shipnum:=0;
			if distance/radar_range[radartype] <0.51 then
			begin
				for loop2:=1 to Number_of_Ships do
					shipnum:=shipnum+planet[loop].ships[loop2];
				shipst:=st(shipnum);
			end else
			begin
				shipst:='N/A';
			end;
			if (planet[loop].owner<>player_number) and (distance<=radar_range[radartype]) then
			begin
				Ansic(YellowF);
				prompt('  '+addrear(st(loop),8));
				if (planet[loop].owner<1) or (planet[loop].owner>20) then
				begin
					Ansic(CyanF);
					prompt(addrear('  Unowned    ',17));
					Ansic(YellowF);
				end else
				begin
					prompt(addrear(st(planet[loop].owner),8));
					prompt(addrear(streal(empire[planet[loop].owner].technology_level,2),9));
				end;
				prompt(addrear(streal(planet[loop].industrial_level,2),12));
				print(addrear(shipst,11)+streal(distance,2));
			end;
		end;
		nl;
	end;
end;

Procedure Build_Warpgate;
var
	cost:integer;
	bwloop:integer;
	high:integer;
	build_where:integer;
	kind:integer;
begin
	with empire[player_number] do
	begin
		if technology_level<Warpgate_tech[1] then
		begin
			Ansic(MagentaF);
			print('Your technology level is too low to build a Warpgate.');
			exit;
		end;
		nl;
		Ansic(WhiteF);
		print('Build Warpgate');
		Ansic(MagentaF);
		print('~~~~~~~~~~~~~~');
		nl;
		print(YellowF+'('+CyanF+'0'+YellowF+') Abort');
		for bwloop:=1 to 3 do
		begin
			if technology_level>=warpgate_tech[bwloop] then
			begin
				high:=bwloop;
				Ansic(YellowF);
				print('('+CyanF+st(bwloop)+YellowF+') '+warpgate_name[bwloop]);
			end;
		end;
		nl;
		prompt('Build which type (0-'+st(high)+')? ');
		case high of
			1	: onek(onechar,'01');
			2	: onek(onechar,'012');
			3	: onek(onechar,'0123');
		end;{case}
		If onechar='0' then
		begin
			nl;
			exit;
		end;
		kind:=value(onechar);
		Repeat
			prompt ('Build a '+warpgate_name[kind]+' on what planet? ');
			Input (BigString, 3,true);
			nl;
			if BigString = '' then Exit;
			Val (BigString, Build_Where, eq);
			if eq <> 0 then Exit;
			if Build_Where = 0 then Exit;
		Until (Build_Where > 0) and (Build_Where <= Number_of_Planets);

		if planet[build_where].owner<>player_number then
		begin
			Ansic(WhiteF);
			print('Planet '+st(Build_Where)+' is not part of your Empire.');
			nl;
			exit;
		end;
		if planet[build_where].warpgate<>0 then
		begin
			Ansic(YellowF);
			Prompt('This planet already has a '+warpgate_name[planet[build_where].warpgate]+
				' installed.  Continue (Y/N) ? ');
			if not YN then exit;
		end;
		if (technology_units-warpgate_bcost[kind])<0 then
		begin
			Ansic(WhiteF);
			print('You need '+st(warpgate_bcost[kind])+' Technology Units to build a '+
				warpgate_name[kind]+'.');
			nl;
			exit;
		end;
		Technology_Units:=Technology_Units-warpgate_bcost[kind];
		planet[Build_Where].warpgate:=kind;
		nl;
		Ansic(CyanF);
		print('A '+warpgate_name[kind]+' has been built on planet '+st(Build_where)+'.');
		Ansic(WhiteF);
		print('The population allocation for this planet must be at least');
		Ansic(YellowF);
		prompt(st(warpgate_ucost[kind])+WhiteF+' percent TECHNOLOGY.  ');
		if planet[build_where].technology_percent<warpgate_ucost[kind] then
		begin
			print('Making changes...');
			planet[build_where].industry_percent:=100-warpgate_ucost[kind];
			planet[build_where].technology_percent:=warpgate_ucost[kind];
		end else
		begin
			Print('No changes necessary.');
		end;
		exit;
	end;
end;

procedure All_Manpower;
Var
	SetNew, J1 : Integer;
Begin
	nl;
	if not Check_Planets then Exit;
	Repeat
		prompt ('What percent of the population should work in industry? ');
		Input (BigString, 3,true);
		nl;
		Val (BigString, SetNew, eq);
		if eq <> 0 then Exit;
	Until (SetNew >= 0) and (SetNew <= 100);
	for J1 := 1 to Number_of_Planets do
	Begin
		if Planet[J1].Owner = Player_Number then
		Begin
			if (planet[J1].warpgate>0) and ((100-setnew)<warpgate_ucost[planet[j1].warpgate]) then
			begin
				planet[J1].industry_percent:=100-warpgate_ucost[planet[j1].warpgate];
				planet[J1].technology_percent:=warpgate_ucost[planet[j1].warpgate];
				Ansic(WhiteF);
				print('Planet '+RedF+st(j1)+WhiteF+' has a '
					+warpgate_name[planet[j1].warpgate]+'.');
				Ansic(WhiteF);
				print('Industry level will be maximized as much as possible.');
			end else
			begin
				Planet[J1].Industry_Percent := SetNew;
				Planet[J1].Technology_Percent := 100 - SetNew;
			end;
		End;
	End;
	nl;
	Ansic(GreenF);
	print (St(SetNew) + ' % of all workers on every planet are now working in Industry.');
	Ansic(GreenF);
	print (St(100-SetNew) + ' % of all workers on every planet are now working in Technology');
	nl;
End;

procedure Change_Planet_Name;
Var
	Which_Planet : Integer;
	PlanetValid : Boolean;
Begin
	PlanetValid := false;
	nl;
	if not Check_Planets then Exit;
	Repeat
		prompt ('Change the name of which planet? ');
		Input (BigString, 3,true);
		nl;
		Val (BigString, Which_Planet, eq);
		if eq <> 0 then Exit;
		if BigString = '' then Exit;
		if Which_Planet = 0 then Exit;
		if (Which_Planet > 0) and (Which_Planet <= Number_of_Planets) and
			(Planet[Which_Planet].Owner = Player_Number) then PlanetValid := true;
	Until PlanetValid;
	prompt ('What shall be the planet''s new name? ');
	Input (BigString, 20,false);
	nl;
	if BigString = '' then
	Begin
		print ('Aborted.');
		Exit;
	End;
	Planet[Which_Planet].Planet_Name := BigString;
	print ('Planet ' + St(Which_Planet) + '''s name is ' +
		Planet[Which_Planet].Planet_Name + '.');
End;

procedure Increase_Industry;
Var
	Which_Planet       : Integer;
	How_Much, intmuch  : Real;
	PlanetValid        : Boolean;
Begin
	Repeat
		PlanetValid := false;
		writeln;
		prompt ('Increase Industry Level of which planet? ');
		Input (BigString, 3,true);
		nl;
		Val (BigString, Which_Planet, eq);
		if eq <> 0 then Exit;
		if BigString = '' then Exit;
		if Which_Planet = 0 then Exit;
		if (Which_Planet > 0) and (Which_Planet <= Number_of_Planets)
			and (Planet[Which_Planet].Owner = Player_Number) then PlanetValid := true;
	Until PlanetValid;
	writeln;
	print ('You have ' + St(Empire[Player_Number].Industry_Units) + ' Industry Units.');
	print ('Each increase of .01 costs 1 Unit.');
	prompt ('Increase Industry by how much? ');
	Input (BigString, 3,true);
	nl;
	Val (BigString, How_Much, eq);
	if eq <> 0 then Exit;
	if How_Much <= 0.009 then Exit;
	if (How_Much * 100) > Empire[Player_Number].Industry_Units then
		print ('You don''t have enough Industry Units available.');
	if (How_Much * 100) <= Empire[Player_Number].Industry_Units then
	Begin
		Empire[Player_Number].Industry_Units:=Empire[Player_Number].Industry_Units - round(How_Much * 100);
		Planet[Which_Planet].Industrial_Level := Planet[Which_Planet].Industrial_Level + How_Much;
		print ('Industry Level of Planet ' + St(Which_Planet) + ' increased by ' +
			StReal(How_Much,2) + ' to ' + StReal(Planet[Which_Planet].Industrial_Level,2) + '.');
	End;
End;

procedure Decrease_Industry;
Var
	Which_Planet       : Integer;
	How_Much, intmuch  : Real;
	PlanetValid        : Boolean;
Begin
	Repeat
		PlanetValid := false;
		writeln;
		prompt ('Decrease Industry Level of which planet? ');
		Input (BigString, 3,true);
		nl;
		Val (BigString, Which_Planet, eq);
		if eq <> 0 then Exit;
		if BigString = '' then Exit;
		if Which_Planet = 0 then Exit;
		if (Which_Planet > 0) and (Which_Planet <= Number_of_Planets)
			and (Planet[Which_Planet].Owner = Player_Number) then PlanetValid := true;
	Until PlanetValid;
	writeln;
	print ('This planet has a ' + Streal(planet[which_planet].Industrial_level,2) + ' Industry Level.  Each decrease of .10');
	print ('gains 9 Industy Units.  A planet can only be lowered to a minimum of 1.00.');
	prompt ('Decrease Industrial Level by how much? ');
	Input (BigString, 3,true);
	nl;
	Val (BigString, How_Much, eq);
	if eq <> 0 then Exit;
	if How_Much <= 0.009 then Exit;
	if How_Much > planet[Which_planet].Industrial_level-0.99 then
	begin
		print ('The planet does not have that high of an Industrial Level.');
	end else
	Begin
		Empire[Player_Number].Industry_Units:=Empire[Player_Number].Industry_Units + round(How_Much * 90);
		Planet[Which_Planet].Industrial_Level := Planet[Which_Planet].Industrial_Level - How_Much;
		print ('Industry Level of Planet ' + St(Which_Planet) + ' decreased by ' +
			StReal(How_Much,2) + ' to ' + StReal(Planet[Which_Planet].Industrial_Level,2) + '.');
	End;
End;

procedure Change_Manpower;
Var
	Which_Planet, SetNew : Integer;
	WhichValid : Boolean;
Begin
	nl;
	if not Check_Planets then Exit;
	WhichValid := false;
	Repeat
		prompt ('Change Manpower Allocation on what planet? ');
		Input (BigString, 3,true);
		nl;
		Val (BigString, Which_Planet, eq);
		if eq <> 0 then Exit;
		if BigString = '' then Exit;
		if Which_Planet = 0 then Exit;
		if (Which_Planet > 0) and (Which_Planet <= Number_of_Planets) and
			(Planet[Which_Planet].Owner = Player_Number) then WhichValid := true;
	Until WhichValid;
	Repeat
		nl;
		prompt ('What percent of the workers should produce industry? ');
		Input (BigString, 3,true);
		nl;
		Val (BigString, SetNew, eq);
		if eq <> 0 then Exit;
	Until (SetNew >= 0) and (SetNew <= 100);
	if (planet[Which_Planet].warpgate>0) and ((100-setnew)<warpgate_ucost[planet[Which_Planet].warpgate]) then
	begin
		planet[Which_Planet].industry_percent:=100-warpgate_ucost[planet[Which_Planet].warpgate];
		planet[Which_Planet].technology_percent:=warpgate_ucost[planet[Which_Planet].warpgate];
		Ansic(WhiteF);
		print('Planet '+RedF+st(Which_Planet)+WhiteF+' has a '
			+warpgate_name[planet[Which_Planet].warpgate]+'.');
		Ansic(WhiteF);
		print('Industry level will be maximized as much as possible.');
	end else
	begin
		Planet[Which_Planet].Industry_Percent := SetNew;
		Planet[Which_Planet].Technology_Percent := 100 - SetNew;
		print (addfront(St(SetNew),3) + ' % of the workers on planet ' + St(Which_Planet) + ' are producing industry.');
		print (addfront(St(100-SetNew),3) + ' % of the workers on planet ' + St(Which_Planet) + ' are producing technology.');
	end;
	nl;
End;

procedure Planet_Status;
Var
	Which_Planet : Integer;
	PlanetValid : Boolean;
Begin
	nl;
	if not Check_Planets then Exit;
	PlanetValid := false;
	Repeat
		prompt ('Which Planet do you wish to see? ');
		Input (BigString, 3,true);
		nl;
		Val (BigString, Which_Planet, eq);
		if eq <> 0 then Exit;
		if BigString = '' then Exit;
		if Which_Planet = 0 then Exit;
		if (Which_Planet > 0) and (Which_Planet <= Number_of_Planets)
			and (Planet[Which_Planet].Owner = Player_Number) then PlanetValid := true;
	Until PlanetValid;
	Print_Planet (Which_Planet);
End;

procedure Zoom_View;
Var
	LoopZV : integer;
  abort,next : boolean;
	wg:boolean;
	radt:boolean;
	rad:string[1];
Begin
	if check_planets then
	begin
		wg:=false;
		radt:=false;
		nl;
		abort := false;
		Ansic(BlueF);
		print ('     Planetary              Industry                Worker %      Percent   ');
		Ansic(BlueF);
		print ('Number       Name             Level   Population   Ind / Tech   Habitability');
		Ansic(BlueF);
		print ('----------------------------------------------------------------------------');
		loopzv := 1;
		while (not abort) and (loopzv <= number_of_planets) do
		begin
			if Planet[LoopZV].Owner = Player_Number then
				with Planet[LoopZV] do
				begin
					Ansic(CyanF);
					prompt(addfront(St(LoopZV),4));
					if planet[loopZV].warpgate>0 then
					begin
						prompt(YellowF+'*');
						wg:=true;
					end else
					begin
						prompt(' ');
					end;
					if radars[1]+radars[2]+radars[3]>0 then
					begin
						prompt(MagentaF+'R');
						radt:=true;
					end else
					begin
						prompt(' ');
					end;
					if planet_name ='' then
					begin
						prompt(RedF+' > Planet NOT Named < ')
					end else
					begin
						prompt (' '+GreenF+addrear(planet_name,21));
					end;
					Ansic(CyanF);
					printacr(addfront(StReal(Industrial_Level,2),7)
						+ addfront(St(Population),13)
						+ addfront(St(Industry_Percent),6)
						+ addfront(St(Technology_Percent),6)
						+ addfront(st(habitability),11),abort,next);
				end;
			loopzv := loopzv + 1;
		end;
		nl;
		if wg then
		begin
			Ansic(YellowF);
			print('    * Indicates a planet with a Warpgate.');
		end;
		if radt then
		begin
			Ansic(MagentaF);
			print('     R Indicates a Radar equipped planet.');
		end;
		nl;
		PauseScr;
	end;
End;
