Program Domedit;
{$V-}

Uses Dos, Wind20, Crt;
Const

	mdays			  			: byte = 2;
	Players_Needed	  : Byte = 5;
	Number_of_Planets : Byte = 200;
	Number_of_Ships   : Byte = 6;
	number_of_radars  : Byte = 3;
	Number_of_Players : Byte = 20;
	Number_of_Squads  : Integer = 600;
	Number_of_Messages: Byte = 200;
	Align_Name				:	Array [1..20] of string[20] =('Demonic','Brutal','Loathsome','Conniving','Dastardly','Mean','Harsh',
												'Crass','Rude','Leftist-Neutral','Right-wing Neutral','Polite','Nice','Unselfish','Forgiving',
												'Giving','Gallant','Knightly','Princely','Saintly');
	Ship_Cost         : Array [1..6] of Byte = (5, 12, 28, 60, 150, 250);
	Ship_Crew		  		: Array [1..6] of integer = (50, 150, 450, 1350, 4050, 12150);
	eff				  			: Array [1..6] of byte = (85,80,70,60,50,35);
	radar_cost        : Array [1..3] of Integer = (100, 300, 700);
	radar_range       : Array [1..3] of integer = (4, 8, 12);
	Ship_Tech         : Array [1..6] of Real = (0.9, 1.9, 3.4, 5.4, 8.9, 14.9);
	radar_tech        : Array [1..3] of real = (5.4, 11.9, 19.9);
	tech_modifier     : Real = 0.33;

	Warpgate_bcost		: array [1..3] of integer = (200,600,1200);
	Warpgate_ucost		: array [1..3] of integer = (20,35,45);
	Warpgate_tech			:	array [1..3] of real = (7.5, 15.0, 30.0);
	Warpgate_eff			: array [1..3] of integer =(70,85,95);
	Warpgate_range		:	array [1..3] of integer =(10,25,40);
	Warpgate_name			:	array [1..3] of string[22] =('Low-Power Warpgate','High-Power Warpfield','Trans-Warpgate');

	Ship_Name         : Array [1..6] of String[20] = ('Frigate', 'Destroyer', 'Cruiser',
											 'Battleship', 'Dreadnought', 'SuperDreadnought');
	radar_name        : Array [1..3] of string[20] = ('Short Range','Mid Range','Long Range');
	Ship_Attack  			: Array [1..6] of Byte = (1,2,4,8,16,32);
	Ship_Defense      : Array [1..6] of Byte = (2,3,6,12,24,48);
	Ship_Damage       : Array [1..6] of Byte = (5,11,24,53,116,255);
	Month             : Array [1..12] of String[9] = ('January','February','March','April',
											 'May','June','July','August','September','October','November','December');
	IsFalse           : Boolean = false;

Type
	String160 = String[160];
	String80 = String [80];
	String40 = String [40];
	String25 = String [25];
	String20 = String [20];
	String2 = String [2];

	extratech=record
		warpmissle	:boolean;
		photontorp	:boolean;
		plasmatorp	:boolean;
		lasertrack	:boolean;
		laserarmor	:boolean;
		cloaking		:boolean;
		transporter	:boolean;
	end;

	tech2 = array[1..20] of extratech;

	squadmappos=record
		maxspeed:byte;
		xpos	:byte;
		ypos	:byte;
		xdest	:byte;
		ydest	:byte;
		stealth	:boolean;
		stealtheff	:byte;
	end;

	squadxy=array[1..600] of squadmappos;

	Empirerecord = Record
		User_Number       : Integer;
		User_Name,
		Empire_Name       : String25;
		Technology_Level,
		Total_Population  : Real;
		Planets           : Byte;
		Intel_Reports     : Byte;
		Industry_Units,
		Technology_Units  : Real;
		Ships             : Array [1..6] of Integer;
		radars            : Array [1..3] of Integer;
		Points            : Real;
		Expert            : Boolean;
		Alignment					:	Byte;
	End;

	Empirerecs = Array [1..20] of Empirerecord;

	Planetrecord = Record
		Planet_Name       : String[20];
		X,
		Y,
		Owner         		: Byte;
		Population        : Real;
		Habitability,
		Industry_Percent,
		Technology_Percent: Byte;
		Industrial_Level  : Real;
		warpgate          :	Integer;
		Ships             : Array [1..6] of Integer;
		radars            : array [1..3] of byte;
		Alignment					:	Byte;
	End;

	Planetrecs = Array [1..200] of Planetrecord;

	Squadronrecord = Record
		Owner         : Byte;
		Distance_Left : Real;
		Destination   : Byte;
		Speed         : Byte;
		Ships         : Array [1..6] of Integer;
	End;

	Squadronrecs = Array [1..600] of Squadronrecord;

	Messagerecord = Record
		Sent_By : Byte;
		Sent_To : Byte;
		Message : String80;
	End;

	Messagerecs = Array [1..200] of Messagerecord;

Var
	eplayer		:boolean;
	pcount		:integer;
	detects		:integer;
	moretech	:tech2;
	squadpos	:squadxy;
	BigString : String160;
	OneChar 	: Char;
	Player_Number, EC, CurMonth, Year, Len : Integer;
	Empire 		: Empirerecs;
	Planet 		: Planetrecs;
	Squadron 	: Squadronrecs;
	Messages 	: Messagerecs;
	Filled_Up : Boolean;
	date_now 	: string160;


procedure Load_Information;
Var
	EmpireFile  : file of Empirerecord;
	PlanetFile  : file of Planetrecord;
	SquadFile   : file of Squadronrecord;
	MessageFile : file of Messagerecord;
	squadxyfile : file of squadmappos;
	tech2file		: file of extratech;
	LastOnFile  : file of String160;
	LastPlayed  : String160;
	DateFile    : File of Integer;
	LoopLI      : Integer;
Begin
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
	if pcount>=Players_Needed then eplayer:=true;
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
	for loopsa:=1 to number_of_planets do
	begin
		planet[loopsa].industrial_level:=abs(planet[loopsa].industrial_level);
		for loopsh:=1 to number_of_ships do
			if planet[loopsa].ships[loopsh]<0 then
				planet[loopsa].ships[loopsh]:=-(planet[loopsa].ships[loopsh]);
	end;
	assign (squadxyfile, 'squadpos.dom');
	rewrite(squadxyfile);
	for LoopSA :=1 to Number_of_Squads do begin
		write (squadxyfile,squadpos[LoopSA]);
	end;
	close(squadxyfile);
	assign (tech2file,'tech2.dom');
	rewrite(tech2file);
	for LoopSA:=1 to Number_of_Players do begin
		write(tech2file,moretech[LoopSA]);
	end;
	close(tech2file);
	Assign (EmpireFile, 'Empires.Dom');
	Rewrite (EmpireFile);
	for LoopSA := 1 to Number_of_Players do
		write (EmpireFile, Empire[LoopSA]);
	Close (EmpireFile);
	Assign (PlanetFile, 'Planets.Dom');
	Rewrite (PlanetFile);
	for LoopSA := 1 to Number_of_Planets do
		write (PlanetFIle, Planet[LoopSA]);
	Close (PlanetFile);
	Assign (SquadFile, 'Squads.Dom');
	Rewrite (SquadFile);
	for LoopSA := 1 to Number_of_Squads do
		write (SquadFile, Squadron[LoopSA]);
	Close (SquadFile);
	Assign (MessageFile, 'Messages.Dom');
	Rewrite (MessageFile);
	for LoopSA:= 1 to Number_of_Messages do
		write (MessageFile, Messages[LoopSA]);
	Close (MessageFile);
End;

{ +!+!+!+ The Main Body of the Program! +!+!+!+ }

Begin
	textcolor(14);
	textbackground(0);
	clrscr;
	DefineWindow(1,15,2,65,23,attr(15,3),SingleBorder,attr(14,0),'Dominion Editor Main',attr(9,0),center,
		'Your choice?',attr(9,0),center,7);
	OpenWindow(1);
	readln;
	CloseWindow(1);
	clrscr;
End.
