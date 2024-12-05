//============================
//Respawn player in air with parachute
switch (playerSide) do {
	case west: {
		chute = "Steerable_Parachute_F" createVehicle [getPos westSpawn select 0,getPos westSpawn select 1,250];
		private _spawnDir = getDir westSpawn;
		chute setDir _spawnDir;
		uiSleep 0.1;
		player moveIndriver chute;
		chute setPosATL (chute modelToWorld[0,0,150]);
		if(player distance westSpawn < 10)then {player moveIndriver chute};
	};
	case east: {
		chute = "Steerable_Parachute_F" createVehicle [getPos eastSpawn select 0,getPos eastSpawn select 1,250];
		private _spawnDir = getDir eastSpawn;
		chute setDir _spawnDir;
		uiSleep 0.1;
		player moveIndriver chute;
		chute setPosATL (chute modelToWorld[0,0,150]);
		if(player distance eastSpawn < 10)then {player moveIndriver chute};
	};
	case resistance: {
		chute = "Steerable_Parachute_F" createVehicle [getPos indySpawn select 0,getPos indySpawn select 1,250];
		private _spawnDir = getDir indySpawn;
		chute setDir _spawnDir;
		uiSleep 0.1;
		player moveIndriver chute;
		chute setPosATL (chute modelToWorld[0,0,150]);
		if(player distance indySpawn < 10)then {player moveIndriver chute};
	};
};
//============================


//============================
//allow player to have time to move before being shot
[] spawn {
	player allowDamage false;
	uiSleep 5;
	player allowDamage true;
};
//============================


//============================
//basic starting settings
player setVelocity [0,0,0];
player enableSimulation true;
player hideObject false;
1120 cutText ["", "PLAIN", 9999999];
0 fadeSound 1;
0 fadeMusic 0.5;
enableEnvironment true;
//============================