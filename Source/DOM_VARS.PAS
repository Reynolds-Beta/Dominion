Const
	Planet_Names : Array [22..25] of String[20] = ('Amalthea', 'Trantor', 'Magrathea', 'Terminus');
	mdays			  	: byte = 1;
	Players_Needed	  	: Byte = 1;
	Number_of_Planets 	: Integer = 400;
	Number_of_Ships   	: Byte = 6;
	number_of_radars  	: Byte = 3;
	Number_of_Players 	: Byte = 20;
	Number_of_Squads  	: Integer = 600;
	Number_of_Messages	: Byte = 200;
	Align_Name			: Array [1..20] of string[20] =('Demonic','Brutal','Loathsome','Conniving','Dastardly','Mean','Harsh',
							'Crass','Rude','Leftist-Neutral','Right-wing Neutral','Polite','Nice','Unselfish','Forgiving',
							'Giving','Gallant','Knightly','Princely','Saintly');
	Ship_Cost         	: Array [1..6] of Byte = (5, 10, 25, 55, 120, 250);
	Ship_Crew		  	: Array [1..6] of integer = (50, 150, 450, 1350, 4050, 12150);
	Eff				  	: Array [1..6] of byte = (85,80,70,60,45,35);
	radar_cost        	: Array [1..3] of Integer = (100, 300, 700);
	radar_range       	: Array [1..3] of integer = (4, 7, 13);
	Ship_Tech         	: Array [1..6] of Real = (0.9, 1.9, 3.4, 5.4, 8.9, 14.9);
	radar_tech        	: Array [1..3] of real = (4.9, 11.9, 19.9);
	tech_modifier     	: Real = 0.33;

	Warpgate_bcost		: array [1..3] of integer = (100,200,400);
	Warpgate_ucost		: array [1..3] of integer = (30,45,55);
	Warpgate_tech		: array [1..3] of real = (5.9, 11.9, 23.9);
	Warpgate_eff		: array [1..3] of integer =(55,70,85);
	Warpgate_range		: array [1..3] of integer =(10,20,40);
	Warpgate_name		: array [1..3] of string[22] =('Warpgate','Improved Warpgate','Transwarp gate');

	Ship_Name         	: Array [1..6] of String[20] = ('Frigate', 'Destroyer', 'Heavy Cruiser',
							'Battleship', 'Dreadnought', 'SuperDreadnought');
	radar_name        	: Array [1..3] of string[20] = ('Short Range','Mid Range','Long Range');
	Ship_Attack  		: Array [1..6] of Byte = (1,2,4,8,16,32);
	Ship_Defense      	: Array [1..6] of Byte = (2,4,8,16,32,64);
	Ship_Damage       	: Array [1..6] of Byte = (3,10,24,53,116,255);
	Month             	: Array [1..12] of String[9] = ('January','February','March','April',
							'May','June','July','August','September','October','November','December');
	IsFalse           	: Boolean = false;

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
		cloaking	:boolean;
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
		User_Number       	: Integer;    {0-1}
		User_Name,                        {2-26}
		Empire_Name       	: String25;   {27-51}
		Technology_Level,                 {52-57}
		Total_Population  	: Real;       {58-63}
		Planets           	: Integer;
		Intel_Reports     	: Byte;
		Industry_Units,
		Technology_Units  	: Real;
		Ships             	: Array [1..6] of Integer;
		radars            	: Array [1..3] of Integer;
		Points            	: Real;
		Expert            	: Boolean;
		Alignment			: Byte;
	End;

	Empirerecs = Array [1..20] of Empirerecord;

	Planetrecord = Record
		Planet_Name			: String[20];
		X,
		Y,
		Owner       		: Byte;
		Population			: Real;
		Habitability,
		Industry_Percent,
		Technology_Percent: Byte;
		Industrial_Level  : Real;
		warpgate          :	Integer;
		Ships             : Array [1..6] of Integer;
		radars            : array [1..3] of byte;
		Alignment		  :	Byte;
	End;

	Planetrecs = Array [1..400] of Planetrecord;

	Squadronrecord = Record
		Owner         : Byte;
		Distance_Left : Real;
		Destination   : integer;
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

{**************************************************************}