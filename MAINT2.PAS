{ for Dominions! version 1.50 - December 1989 }

{+!+!+!+!+!+!+!+!+!+!+ Maintenance Procedures  +!+!+!+!+!+!+!+!+!+!+!+!+}

procedure Production;
Var
	LoopPro, Owner_Temp : Integer;
	powned:integer;
	skip:boolean;
	sloop:integer;
	subtech:integer;
	leave:boolean;
Begin
	print ('Producing goods');
	for LoopPro := 1 to Number_of_Planets do
		if (Planet[LoopPro].Owner > 0) and (Planet[LoopPro].Owner < Number_of_Players) then
		Begin
			Owner_Temp := Planet[LoopPro].Owner;
			skip:=false;
			leave:=false;
			powned:=empire[owner_temp].planets;
			if planet[looppro].industrial_level<0 then
				planet[looppro].industrial_level:=-(planet[looppro].industrial_level);


						{Check to see if the workers go on strike}


			if random(round((450-powned)*(empire[owner_temp].technology_level/(planet[looppro].
				industrial_level+0.01))))<9 then
				begin
					send_message(0,owner_temp,'The workers on Planet '+st(LoopPro)+' have gone on strike!');
					skip:=true;
					with planet[looppro] do
					begin
						if (alignment>empire[owner_temp].alignment) and (Alignment<20) then alignment:=alignment+1;
						if (alignment<empire[owner_temp].alignment) and (Alignment>1) then alignment:=alignment-1;
						if (alignment=empire[owner_temp].alignment) and (looppro<>owner_temp) then
						begin
							if empire[owner_temp].alignment=1 then alignment:=alignment+1;
							if empire[owner_temp].alignment=20 then alignment:=alignment-1;
							case random(2)+1 of
								1	:	if empire[owner_temp].alignment<>1 then alignment:=alignment-1;
								2	:	if empire[owner_temp].alignment<>20 then alignment:=alignment+1;
							end;{case}
						end;
						empire[owner_temp].points:=empire[owner_temp].points-1000.0;
					end;
				end;


						{Check to see if the planet secedes from the owning empire.}
						{EXCEPT for original homeworlds!                           }


			if (not skip) and (LoopPro<>owner_temp) then
			begin
				with planet[LoopPro] do
				begin
					if random(40)<round(abs(Empire[owner_temp].alignment-alignment)) then
					begin
						send_message(0,owner_temp,'Rioting has broken out on planet '+st(LoopPro)+'.');
						if alignment>empire[owner_temp].alignment then alignment:=alignment+1;
						if alignment<empire[owner_temp].alignment then alignment:=alignment-1;
						empire[owner_temp].points:=empire[owner_temp].points-1000.0;

					end;
				end;
			end;

			if not skip then
			begin
				with planet[LoopPro] do
				begin
					if empire[owner_temp].alignment<alignment then
					begin
						if random(100)<80 then
						begin
							alignment:=alignment-1;
							empire[owner_temp].points:=empire[owner_temp].points+1000.0;
						end;
						if alignment=empire[owner_temp].alignment then
							send_message(0,owner_temp,'Planet '+st(LoopPro)+' has accepted your Empire''s rule.');
					end;
					if empire[owner_temp].alignment>alignment then
					begin
						if random(100)<80 then
						begin
							alignment:=alignment+1;
							empire[owner_temp].points:=empire[owner_temp].points+1000.0;
						end;
						if alignment=empire[owner_temp].alignment then
							send_message(0,owner_temp,'Planet '+st(LoopPro)+' has accepted your Empire''s rule.');
					end;
				end;
			end;

						{Produce INDUSTRY Units and TECHNOLOGY Units}

			if not skip then
			begin
				Empire[Owner_Temp].Industry_Units :=
					Empire[Owner_Temp].Industry_Units + RoundOff (Planet[LoopPro].Population / 1000 *
					(Planet[LoopPro].Industry_Percent / 100) * sqrt(Planet[LoopPro].Industrial_Level));
				subtech:=0;
				if planet[looppro].warpgate>0 then
					subtech:=warpgate_ucost[planet[looppro].warpgate];
				Empire[Owner_Temp].Technology_Units :=
					Empire[Owner_Temp].Technology_Units + RoundOff (Planet[LoopPro].Population / 2500 *
					((Planet[LoopPro].Technology_Percent-subtech) / 100) * sqrt(Planet[LoopPro].Industrial_Level));
			end;
		End;
End;

procedure Reproduce;
Var
	LoopRep : Integer;
Begin
	print ('Increasing populations');
	for LoopRep := 1 to Number_of_Planets do
	Begin
		with planet[LoopRep] do
		begin
			if (Owner > 0) and (Owner <= Number_of_Players) then
				Population := RoundOff (Population*(Habitability / 1000 + 1.05));
			if (Owner = 0) or (Owner = 21) then
				Population := RoundOff (Population*(Habitability / 2000 + 1.05));
		End;
	end;
End;

procedure Change_Date;

Var
	NewDate_File : File of Integer;
Begin
	print ('Changing Date');
	CurMonth := CurMonth + 1;
	if CurMonth = 13 then
	Begin
		Year := Year + 1;
		CurMonth := 1;
	End;
End;

procedure Change_Happenings;
Var
	Happenings_File : Text;
Begin
	print ('Updating Happenings');
	assign (Happenings_File, 'Yesterda.Dom');
	Erase (Happenings_File);
	Add_On (' ');
	assign (Happenings_File, 'Today.Dom');
	Rename (Happenings_File, 'Yesterda.Dom');
	assign (Happenings_File, 'Today.Dom');
	rewrite (Happenings_File);
	write (Happenings_File, Month[CurMonth],' ',Year, ^M, ^J);
	write (Happenings_File, '~~~~~~~~~~~~~', ^M, ^J);
	close (Happenings_File);
End;

procedure Determine_Losses (Attack_Damage,Defense_Damage:Longint;LoopMS,Destination : Integer);
Var
	LoopDL, Which_Lost:integer;
	Total_Ships : Longint;
Begin
	if squadpos[loopms].stealth then
	begin
		if random(100)+1>squadpos[loopms].stealtheff then
		begin
			squadpos[loopms].stealth:=false;
			if rounds=1 then
				send_message(0,squadron[loopms].owner,'Your Stealth squadron was detected approching planet '+st(destination)+'!')
			else
				send_message(0,squadron[loopms].owner,'Your Stealth squadron was detected after '+st(rounds*5)+' minutes of combat.');
		end;
	end;
	if not squadpos[loopms].stealth then
	begin
		Repeat
			Total_Ships:=0;
			with Squadron[LoopMS] do
				for LoopDL:=1 to Number_of_Ships do	Total_Ships :=Total_Ships+Ships[LoopDL];
			Which_Lost := Random(Total_Ships) + 1;
			with Squadron[LoopMS] do
			Begin
				if Which_Lost <= Ships[1] then Which_Lost := 1;
				total_ships:=ships[1];
				for LoopDL := 2 to Number_of_Ships do
				Begin
					if (Which_Lost>Total_Ships) and (Which_Lost<=Total_Ships+Ships[LoopDL]) then
						Which_Lost := LoopDL;
					Total_Ships := Total_Ships + Ships[LoopDL];
				End;
				Defense_Damage := Defense_Damage - Ship_Damage[Which_Lost];
				Ships[Which_Lost] := Ships[Which_Lost]-1;
				ec:=0;
				for ed:=1 to number_of_ships do ec:=ec+Ships[ed];
				if ec=0	then Defense_Damage := 0;
			end;
		Until Defense_Damage < 1;
	end;
	if (squadpos[loopms].stealth) and (squadpos[loopms].stealtheff>0) then
		squadpos[loopms].stealtheff:=round(squadpos[loopms].stealtheff/1.25);
	Repeat
		with Planet[Destination] do
		begin
			ec:=0;
			for ed:=1 to number_of_ships do ec:=ec+ships[ed];
		end;
		Total_Ships := ec;
		Which_Lost := Random(Total_Ships) + 1;
		with Planet[Destination] do
		Begin
			if Which_Lost <= Ships[1] then Which_Lost := 1;
			Total_Ships := Ships[1];
			for LoopDL := 2 to 6 do
			Begin
				if (Which_Lost>Total_Ships) and (Which_Lost<=Total_Ships+Ships[LoopDL]) then
				Which_Lost := LoopDL;
				Total_Ships := Total_Ships + Ships[LoopDL];
			End;
			Ships[Which_Lost] := Ships[Which_Lost] - 1;
			Attack_Damage := Attack_Damage - Ship_Damage[Which_Lost];
			if (Ships[1] = 0) and (Ships[2] = 0) and (Ships[3] = 0) and
				(Ships[4] = 0) and (Ships[5] = 0) and (Ships[6] = 0)
				then Attack_Damage := 0;
		end;
	Until Attack_Damage < 1;
End;

procedure New_Owner (Which_Planet, Owner, ExOwner : Integer);
Var
	LoopNO : Integer;
Begin
	with planet[which_planet] do
	begin
		if radars[1] <> 0 then
		begin
			Empire[ExOwner].radars[1]:=Empire[ExOwner].radars[1]-1;
			radars[1]:=0;
		end;
		if radars[2] <> 0 then
		begin
			Empire[ExOwner].radars[2]:=Empire[ExOwner].radars[2]-1;
			radars[2]:=0;
		end;
		if radars[3] <> 0 then
		begin
			Empire[ExOwner].radars[3]:=Empire[ExOwner].radars[3]-1;
			radars[3]:=0;
		end;
	end;
	LoopNO := 0;
	Repeat
		LoopNO := LoopNO + 1;
	Until (Messages[LoopNO].Sent_To = 0) or (LoopNO > Number_of_Messages);
	if LoopNO <= Number_of_Messages then
		with Messages[LoopNO] do
		Begin
			Sent_By := 0;
			Sent_To := ExOwner;
			Message := 'Planet ' + St(Which_Planet) + ' was taken by ' +
			Empire[Owner].Empire_Name + ' [' + St(Owner) + '].';
		End;
End;

procedure Fight (Owner1, LoopMS, Destination : Integer);
Var
	Attack_Damage, Defense_Damage : Longint;
	LoopF, LoopRF, ExOwner, Winner : Integer;
	temp_owner       : byte;
Begin
	rounds:=1;
	Repeat
		temp_owner := Owner1 + 200;
		Attack_Damage := 0;
		Defense_Damage := 0;
		Winner := 0;
		for LoopRF := 1 to Number_of_Ships do
		begin
			if Squadron[LoopMS].Ships[LoopRF] > 0 then
				for LoopF := 1 to Squadron[LoopMS].Ships[LoopRF] do
				begin
					Attack_Damage := Attack_Damage + Random(Ship_Attack[LoopRF]+1)+Ship_Attack[LoopRF];
				end;
			if Planet[Destination].Ships[LoopRF] > 0 then
				for LoopF := 1 to Planet[Destination].Ships[LoopRF] do
					Defense_Damage := Defense_Damage + Random(Ship_Defense[LoopRF]+1)+Ship_Defense[LoopRF];
		end;
		with Planet[Destination] do
		begin
			ec:=0;
			for ed:=1 to number_of_ships do ec:=ec+Ships[ed];
			if ec=0 then Winner := temp_Owner;
			if Winner=0 then Determine_Losses(Attack_Damage,Defense_Damage,LoopMS,Destination);
			ec:=0;
			for ed:=1 to number_of_ships do ec:=ec+Ships[ed];
			if ec=0 then Winner := temp_Owner;
			ec:=0;
			for ed:=1 to number_of_ships do ec:=ec+Squadron[LoopMS].Ships[ed];
			if ec=0	then Winner := Destination;
		end;
		rounds:=rounds+1;
	Until Winner > 0;
	with Planet[Destination] do
	begin
		if Winner = Destination then
		Begin
			if (Owner > 0) and (Owner < 21) then
				Send_Message (0,Owner,Empire[Owner1].Empire_Name+' attacked planet '+St(Destination));
			Send_Message (0,Owner1,'You were defeated at planet '+St(Destination));
			Add_On (Empire[Owner1].Empire_Name + ' was defeated at planet ' + St(Destination));
			winner := 0;
		End;
		if Winner = temp_Owner then
		Begin
			if (Owner > 0) and (Owner < 21) then
				Send_Message (0,Owner,Empire[Owner1].Empire_Name+' captured planet '+St(Destination));
			ExOwner := Owner;
			Owner := Owner1;
			New_Owner (Destination, Owner1, ExOwner);
			Send_Message (0,Owner1,'You captured planet ' +St(Destination) + '!');
			Add_On (Empire[Owner1].Empire_Name+' captured planet '+St(Destination) + '!');
		End;
	end;
End;

procedure Add_Ships(LoopMS, Destination : Integer);
Var
	LoopAS : Integer;
Begin
	with planet[destination] do
	begin
		for LoopAS := 1 to Number_of_Ships do
			Ships[LoopAS]:=Ships[LoopAS]+Squadron[LoopMS].Ships[LoopAS];
	end;
End;

procedure Update_Empire_Stats;
Var
	LoopTES, LoopTES2, LoopTJ : Integer;
Begin
	print ('Update Empires');
	for LoopTES := 1 to Number_of_Players do
	Begin
		if moretech[looptes].cloaking then
		begin
			moretech[looptes].cloaking:=false;
		end;
		if moretech[looptes].transporter then
		begin
			moretech[looptes].transporter:=false;
			moretech[looptes].cloaking:=TRUE;
		end;
		Empire[LoopTES].Total_Population := 0;
		Empire[LoopTES].Planets := 0;
		for LoopTJ := 1 to Number_of_Ships do
			Empire[LoopTES].Ships[LoopTJ] := 0;
		Empire[LoopTES].Intel_Reports := 10;
		for LoopTES2 := 1 to 600 do
			with Squadron[LoopTES2] do
			Begin
				if Owner = LoopTES then
					for LoopTJ := 1 to Number_of_Ships do
						Empire[LoopTES].Ships[LoopTJ]:=Empire[LoopTES].Ships[LoopTJ]+Ships[LoopTJ];
			End;
			for LoopTES2 := 1 to Number_of_Planets do
			Begin
				if Planet[LoopTES2].Owner = LoopTES then
				Begin
					Empire[LoopTES].Total_Population := Empire[LoopTES].Total_Population
						+Planet[LoopTES2].Population;
					Empire[LoopTES].Planets := Empire[LoopTES].Planets + 1;
					for LoopTJ := 1 to Number_of_Ships do
						Empire[LoopTES].Ships[LoopTJ] := Empire[LoopTES].Ships[LoopTJ]
							+Planet[LoopTES2].Ships[LoopTJ];
				End;
			End;
	End;
End;

procedure Total_Scores;
Var
	LoopTS : Integer;
	fl:text;
	file_exist:boolean;
Begin
	{$I-}
	assign(fl,'c:\wwiv\gfiles\doors\scores.dom');
	rewrite(fl);
	{$I+}
	file_exist:=false;
	if IOresult=0 then file_exist:=true;
	if file_exist then
	begin
		writeln(fl,YellowF+'Dominions Status'+ AllOff );
		writeln(fl);
		print ('Scoring');
		with Empire[LoopTS] do
		begin
			for LoopTS := 1 to Number_of_Players do
			begin
				Points := Score (LoopTS);
				if (empire_name<>'') and (file_exist) then
					writeln(fl,WhiteF,addrear(Empire_name,25),GreenF,addfront(st(points),15));
			end;
		end;
		close(fl);
	end;
End;

procedure Arrived (Owner, LoopMS, Destination : Integer);
Var
	LoopARR : Integer;
Begin
	if Planet[Destination].Owner <> Owner then Fight(Owner, LoopMS, Destination);
	if Planet[Destination].Owner = Owner then Add_Ships(LoopMS, Destination);
	with squadron[loopms] do
	begin
		for LoopARR := 1 to Number_of_Ships do
		begin
			Planet[Destination].Population:=Planet[Destination].Population+
				(Ships[LoopARR]*round(Ship_Crew[LoopARR]*0.75));
			Empire[Owner].Total_Population:=Empire[Owner].Total_Population+
				(Ships[LoopARR]*round(Ship_Crew[LoopARR]*0.75));
			Ships[LoopARR] := 0;
		end;
		destination := 0;
		owner := 0;
		speed := 0;
		distance_left := 0;
		squadpos[loopms].maxspeed:=0;
		squadpos[loopms].xpos:=0;
		squadpos[loopms].ypos:=0;
		squadpos[loopms].xdest:=0;
		squadpos[loopms].ydest:=0;
		squadpos[loopms].stealth:=false;
		squadpos[loopms].stealtheff:=0;
	end;
End;

procedure Move_Squads;
Var
	LoopMS : Integer;
	lghyp,smhyp,angle:real;
	px,py,dx,dy,addx,addy,newx,newy:integer;
Begin
	print ('Moving Squadrons');
	for LoopMS := 1 to Number_of_Squads do
		with Squadron[LoopMS] do
			if Owner > 0 then
			Begin
				px:=squadpos[LoopMS].xpos;
				py:=squadpos[LoopMS].ypos;
				dx:=squadpos[LoopMS].xdest;
				dy:=squadpos[LoopMS].ydest;
				lghyp:=sqrt(sqr(dx-px)+sqr(dy-py));
				Distance_Left := Distance_Left - Speed;
				if Distance_Left > 0 then
				begin
					angle:=1;
					smhyp:=lghyp-Distance_Left;
					if ((px-dx)=0) then angle:=pi/2;
					if ((py-dy)=0) then angle:=0;
					if angle=1 then	angle:=arctan(abs(dy-py)/abs(dx-px));
					addx:=round(smhyp*cos(angle));
					addy:=round(smhyp*sin(angle));
					if dy>py then
					begin
						py:=py+addy;
					end else
					begin
						if dy<py then begin
						py:=py-addy;
					end;
				end;
				if dx>px then
				begin
					px:=px+addx;
				end else
				begin
					if dx<px then
					begin
						px:=px-addx;
					end;
				end;
				squadpos[LoopMS].xpos:=px;
				squadpos[LoopMS].ypos:=py;
			end;
			if Distance_Left <= 0 then Arrived(Owner, LoopMS, Destination);
		End;
End;

procedure Maintenence;
var
	mdf	:	text;
	mds	:	string;
Begin
	cls;
	assign(mdf,'mdays.dom');
	reset(mdf);
	readln(mdf,mds);
	close(mdf);
	if length(mds)<mdays then
	begin
		rewrite(mdf);
		mds:=mds+' ';
		writeln(mdf,mds);
		close(mdf);
		exit;
	end;
	rewrite(mdf);
	mds:=' ';
	writeln(mdf,mds);
	close(mdf);
	writeln;
	print ('Maintenance Program is now running...');
	writeln;
	Production;
	Reproduce;
	Change_Date;
	Change_Happenings;
	Move_Squads;
	Update_Empire_Stats;
	Total_Scores;
	writeln;
	print ('All done!');
End;
