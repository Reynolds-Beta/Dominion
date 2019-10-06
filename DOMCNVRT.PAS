Program Mod_Dominions;


			{This program will convert old .DOM data formats, starting at
			 Dominions 1.50MZ, and convert them to modified .DOM formats.
			 It is important to note that in order to accomplish this, one
			 must manually change the data types to match those of both
			 the OLD and the NEW structures.}

Const
	Number_Of_Players	:integer=20;
	Number_Of_Planets	:integer=200;
	Number_Of_Squads	:Integer=600;
	Number_Of_Messages:integer=200;

Type
	String25 = String [25];

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
		radars						: Array [1..3] of Integer;
		Points            : Real;
		Expert            : Boolean;
		Alignment					:	byte;
	End;
	Empirerecs = Array [1..20] of Empirerecord;

	NewEmpirerecord = Record
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
		radars						: Array [1..3] of Integer;
		Points            : Real;
		Expert            : Boolean;
		Alignment					:	byte;
	End;
	NewEmpirerecs = Array [1..20] of NewEmpirerecord;

	Planetrecord = record
		Planet_Name 			: String[20];
		X 								: Byte;
		Y 								: Byte;
		Owner 						: Byte;
		Population 				: Real;
		Habitability 			: Byte;
		Industry_Percent 	: Byte;
		Technology_Percent: Byte;
		Industrial_Level 	: Real;
    warpgate					: integer;
		Ships 						: Array [1..6] of Integer;
		radars						: Array [1..3] of byte;
    Alignment					: byte;
	End;
	Planetrecs = Array [1..200] of Planetrecord;

	NewPlanetrecord = record
		Planet_Name 			: String[20];
		X 								: Byte;
		Y 								: Byte;
		Owner 						: Byte;
		Population 				: Real;
		Habitability 			: Byte;
		Industry_Percent 	: Byte;
		Technology_Percent: Byte;
		Industrial_Level 	: Real;
		warpgate					: integer;
		Ships 						: Array [1..6] of Integer;
		radars						: Array [1..3] of byte;
		Alignment					: byte;
	End;
	NewPlanetrecs = Array [1..200] of NewPlanetrecord;

	Squadronrecord = record
		Owner : Byte;
		Distance_Left : Real;
		Destination : Byte;
		Speed : Byte;
		Ships : Array [1..6] of Integer;
	End;
	Squadronrecs = Array [1..600] of Squadronrecord;

	NewSquadronrecord = record
		Owner : Byte;
		Distance_Left : Real;
		Destination : Byte;
		Speed : Byte;
		Ships : Array [1..6] of Integer;
	End;
	NewSquadronrecs = Array [1..600] of NewSquadronrecord;

Var
	OldEmpire : Empirerecs;
	NewEmpire : NewEmpirerecs;
	OldEm_File:	file of Empirerecord;
	NewEm_File:	file of NewEmpirerecord;

	OldPlanet : Planetrecs;
	NewPlanet	:	NewPlanetrecs;
	OldPl_File: file of Planetrecord;
	NewPl_File: file of NewPlanetRecord;

	OldSquad 	: Squadronrecs;
	NewSquad 	: NewSquadronrecs;
	OldSq_File: file of SquadronRecord;
	NewSq_File: file of NewSquadronRecord;

	Loop : Integer;
	PosValid : Boolean;

begin

		{Convert the EMPIRES.DOM data file}

	Assign(OldEm_File,'Empires.Dom');
	Assign(NewEm_File,'NewEm.Dat');
	reset(OldEm_File);
	rewrite(NewEm_File);
	for Loop:=1 to number_of_players do
	begin
		read(OldEm_File,OldEmpire[Loop]);
		with OldEmpire[Loop] do
		begin
			NewEmpire[loop].User_Number:=User_Number;
			NewEmpire[loop].User_Name:=user_name;
			NewEmpire[loop].Empire_Name:=Empire_Name;
			NewEmpire[loop].Technology_Level:=Technology_Level;
			NewEmpire[loop].Total_Population:=Total_Population;
			NewEmpire[loop].Planets:=Planets;
			NewEmpire[loop].Intel_Reports:=Intel_Reports;
			NewEmpire[loop].Industry_Units:=Industry_Units;
			NewEmpire[loop].Technology_Units:=Technology_Units;

			NewEmpire[loop].Ships[1]:=Ships[1];
			NewEmpire[loop].Ships[2]:=Ships[2];
			NewEmpire[loop].Ships[3]:=Ships[3];
			NewEmpire[loop].Ships[4]:=Ships[4];
			NewEmpire[loop].Ships[5]:=Ships[5];
			NewEmpire[loop].Ships[6]:=Ships[6];

			NewEmpire[loop].radars[1]:=Radars[1];
			NewEmpire[loop].radars[2]:=Radars[2];
			NewEmpire[loop].radars[3]:=Radars[3];

			NewEmpire[loop].Points:=Points;
			NewEmpire[loop].Expert:=Expert;
			NewEmpire[loop].Alignment:=alignment;
		end;
		write(NewEm_File,NewEmpire[Loop]);
	end;
	close(OldEm_File);
	Close(NewEm_File);


		{Convert the PLANETS.DOM data file}

	Assign(OldPl_File,'Planets.Dom');
	assign(NewPl_File,'NewPl.Dat');
	reset(OldPl_File);
	rewrite(NewPl_File);
	for loop:=1 to number_of_planets do
	Begin
		read(OldPl_File,OldPlanet[Loop]);
		with OldPlanet[Loop] do
		Begin
			NewPlanet[Loop].Planet_Name:=Planet_Name;
			NewPlanet[Loop].X:=X;
			NewPlanet[Loop].Y:=Y;
			NewPlanet[Loop].Owner:=Owner;
			NewPlanet[Loop].Population:=Population;
			NewPlanet[Loop].Habitability:=Habitability;
			NewPlanet[Loop].Industry_Percent:=Industry_Percent;
			NewPlanet[Loop].Technology_Percent:=Technology_Percent;
			NewPlanet[Loop].Industrial_Level:=Industrial_Level;
			NewPlanet[Loop].warpgate:=warpgate;

			NewPlanet[Loop].Ships[1]:=Ships[1];
			NewPlanet[Loop].Ships[2]:=Ships[2];
			NewPlanet[Loop].Ships[3]:=Ships[3];
			NewPlanet[Loop].Ships[4]:=Ships[4];
			NewPlanet[Loop].Ships[5]:=Ships[5];
			NewPlanet[Loop].Ships[6]:=Ships[6];

			NewPlanet[Loop].radars[1]:=radars[1];
			NewPlanet[Loop].radars[2]:=radars[2];
			NewPlanet[Loop].radars[3]:=radars[3];
			NewPlanet[loop].alignment:=alignment;
		end;
		write(NewPl_File,NewPlanet[Loop]);
	end;
	close(OldPl_File);
	close(NewPl_File);


		{Convert the SQUADS.DOM data file}

	Assign(OldSq_File,'Squads.Dom');
	assign(NewSq_File,'NewSq.Dat');
	reset(OldSq_File);
	Rewrite(NewSq_File);
	for loop:=1 to Number_Of_Squads do
	begin
		read(OldSq_File,OldSquad[Loop]);
		with OldSquad[Loop] do
		begin
			NewSquad[Loop].Owner:=Owner;
			NewSquad[Loop].Distance_Left:=Distance_Left;
			NewSquad[Loop].Destination:=Destination;
			NewSquad[Loop].Speed:=speed;

			NewSquad[Loop].Ships[1]:=Ships[1];
      NewSquad[Loop].Ships[1]:=Ships[1];
			NewSquad[Loop].Ships[1]:=Ships[1];
			NewSquad[Loop].Ships[1]:=Ships[1];
			NewSquad[Loop].Ships[1]:=Ships[1];
			NewSquad[Loop].Ships[1]:=Ships[1];
		end;
		write(NewSq_File,NewSquad[Loop]);
	end;
	close(OldSq_File);
	close(NewSq_File);
end.





