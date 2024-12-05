//============================
//Black screen for loading etc.
spawnInReady = false;
player setPos [0,0,0];
player enableSimulation false;
player hideObject true;
1120 cutText ["", "BLACK FADED", 9999999];
0 fadeSound 0;
0 fadeMusic 0;
enableSaving [false, false];
enableSentences false;
enableEnvironment false;
sleep 1;
endLoadingScreen;
if(end)then{}else{
	spawnInReady = true;
};
[] spawn {
	private _scoreLimit = paramsArray select 3;
	waitUntil{spawnInReady};
	switch (_scoreLimit) do {
		case 9999: {
			[format ["<t size = '0'>Score Limit: %1</t>",_scoreLimit],0.295 * safezoneW + safezoneX,0.02850001 * safezoneH + safezoneY,99999999,0,0,9995] spawn BIS_fnc_dynamicText;
		
		};
		default {
			[format ["<t size = '0.35'>Score Limit: %1</t>",_scoreLimit],0.295 * safezoneW + safezoneX,0.02850001 * safezoneH + safezoneY,99999999,0,0,9995] spawn BIS_fnc_dynamicText;
		};
	};
};
//============================


//============================
// Setting View distance from parameters
[] spawn {
	setViewDistance (paramsArray select 1);
};
//============================


//============================
//Current flag marker postion
[] spawn {
	while{true}do{
		uiSleep 15;
		"flagMarker" setMarkerPos getPos (flagOwner mainFlag);
	};
};
//============================


//============================
//Add Grab flag action
[] spawn {
[
    mainFlag,                                                                        
    "Grab Flag",                                                                    
    "\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_connect_ca.paa",                
    "\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_connect_ca.paa",       
    "_this distance _target < 5 && flagOnPole",                                                        // Condition for the action to be shown
    "_this distance _target < 5 && flagOnPole",                                                      // Condition for the action to progress
    {},                                                                                  // Code executed when action starts
    {},                                                                                  // Code executed on every progress tick
    {
		[] spawn {
			mainFlag setFlagOwner player;
			waitUntil{flagOwner mainFlag == player};
			flagOnPole = false;
			publicVariable "flagOnPole";
			switch (side player) do {
			case west: {
			["<t size = '1.5'>BLUFOR HAVE THE FLAG</t>",0.295 * safezoneW + safezoneX,0.1240001 * safezoneH + safezoneY,1,1,0,1105] remoteExec ["BIS_fnc_dynamicText", 0];
			["<t size = '0.7'><img image='\a3\Modules_f\data\iconSector_ca.paa' /></t>",0.295 * safezoneW + safezoneX,0.09500001 * safezoneH + safezoneY,99999999,0,0,9925] remoteExec ["BIS_fnc_dynamicText", 0];
			};
			case east: {
			["<t size = '1.5'>OPFOR HAVE THE FLAG</t>",0.295 * safezoneW + safezoneX,0.1240001 * safezoneH + safezoneY,1,1,0,1105] remoteExec ["BIS_fnc_dynamicText", 0];
			["<t size = '0.7'><img image='\a3\Modules_f\data\iconSector_ca.paa' /></t>",0.266 * safezoneW + safezoneX,0.09500001 * safezoneH + safezoneY,99999999,0,0,9925] remoteExec ["BIS_fnc_dynamicText", 0];
			};
			};
		};
		[] spawn {
			waitUntil{!alive player && !flagOnPole && flagOwner mainFlag isEqualTo player};
			flagOnPole = true;
			publicVariable "flagOnPole";
			mainFlag setFlagOwner objNull;
			["<t size = '0'><img image='\a3\Modules_f\data\iconSector_ca.paa' /></t>",0.322 * safezoneW + safezoneX,0.09500001 * safezoneH + safezoneY,99999999,0,0,9925] remoteExec ["BIS_fnc_dynamicText", 0];
			["<t size = '1.5'>THE FLAG HAS BEEN RETURNED</t>",0.295 * safezoneW + safezoneX,0.1240001 * safezoneH + safezoneY,1,1,0,1105] remoteExec ["BIS_fnc_dynamicText", 0];
			
		};
		[] spawn {
			switch (side player) do {
			case west: {
				waitUntil{player distance westDrop < 5 && !flagOnPole};
				private _before = asaayu getVariable ["score",[0,0,0]];
				asaayu setVariable ["score",[(_before select 0) + 1,_before select 1,_before select 2],true];
				scored = true;
				publicVariable "scored";
				playSound "AddItemOK";
				["<t size = '1.5'>BLUFOR HAVE CAPTURED A FLAG</t>",0.295 * safezoneW + safezoneX,0.1240001 * safezoneH + safezoneY,1,1,0,1105] remoteExec ["BIS_fnc_dynamicText", 0];
				["<t size = '0'><img image='\a3\Modules_f\data\iconSector_ca.paa' /></t>",0.322 * safezoneW + safezoneX,0.09500001 * safezoneH + safezoneY,99999999,0,0,9925] remoteExec ["BIS_fnc_dynamicText", 0];
				uisleep 5;
				["<t size = '1.5'>90 SECONDS TO FLAG RESPAWN</t>",0.295 * safezoneW + safezoneX,0.1240001 * safezoneH + safezoneY,1,1,0,1106] remoteExec ["BIS_fnc_dynamicText", 0];
 
			};
			case east: {
				waitUntil{player distance eastDrop < 5 && !flagOnPole};
				private _before = asaayu getVariable ["score",[0,0,0]];
				asaayu setVariable ["score",[_before select 0,(_before select 1) + 1,_before select 2],true];
				scored = true;
				publicVariable "scored";
				playSound "AddItemOK";
				["<t size = '1.5'>OPFOUR HAVE CAPTURED A FLAG</t>",0.295 * safezoneW + safezoneX,0.1240001 * safezoneH + safezoneY,1,1,0,1105] remoteExec ["BIS_fnc_dynamicText", 0]; 
				["<t size = '0'><img image='\a3\Modules_f\data\iconSector_ca.paa' /></t>",0.322 * safezoneW + safezoneX,0.09500001 * safezoneH + safezoneY,99999999,0,0,9925] remoteExec ["BIS_fnc_dynamicText", 0];
				uisleep 5;
				["<t size = '1.5'>90 SECONDS TO FLAG RESPAWN</t>",0.295 * safezoneW + safezoneX,0.1240001 * safezoneH + safezoneY,1,1,0,1106] remoteExec ["BIS_fnc_dynamicText", 0]; 
 
			};
			};
		};
	},                                             
    {},                                                                                  // Code executed on interrupted
    [],                                                                                  // Arguments passed to the scripts as _this select 3
    4,                                                                                  // Action duration [s]
    12,                                                                             
    false,                                                                        
    false                                                                       
] call BIS_fnc_holdActionAdd;
};
//============================


//============================
// SIDE ICONS
[] spawn {
	waitUntil{spawnInReady};
	["<img image='A3\ui_f\data\map\diary\icons\playerWest_ca.paa' />",0.295 * safezoneW + safezoneX,0.03500001 * safezoneH + safezoneY,99999999,0,0,2185] spawn BIS_fnc_dynamicText; 
	["<t size = '0.95'><img image='A3\ui_f\data\map\diary\icons\playerEast_ca.paa' /></t>",0.266 * safezoneW + safezoneX,0.035000001 * safezoneH + safezoneY,99999999,0,0,2184] spawn BIS_fnc_dynamicText; 
	["<img image='A3\ui_f\data\map\diary\icons\playerGuer_ca.paa' />",0.322 * safezoneW + safezoneX,0.03500001 * safezoneH + safezoneY,99999999,0,0,2183] spawn BIS_fnc_dynamicText;  
};
//============================


//============================
//============================


//============================
//============================


//============================
//Set up side score ui
[] spawn {
	waitUntil{spawnInReady};
	while{true}do{
		if(end)then{}else{
		//NATO
			[format["<t size = '0.8'>%1</t>",(asaayu getVariable ["score",[0,0,0]]) select 0],0.295 * safezoneW + safezoneX,0.03900001 * safezoneH + safezoneY,99999999,0,0,2195] spawn BIS_fnc_dynamicText; 
			[format["<t size = '0.5'>%1</t>", (west countSide (allPlayers - entities "HeadlessClient_F")) ],0.295 * safezoneW + safezoneX,0.0740001 * safezoneH + safezoneY,99999999,0,0,2205] spawn BIS_fnc_dynamicText;
		//CSAT
			[format["<t size = '0.8'>%1</t>",(asaayu getVariable ["score",[0,0,0]]) select 1],0.267 * safezoneW + safezoneX,0.03900001 * safezoneH + safezoneY,99999999,0,0,2194] spawn BIS_fnc_dynamicText; 
			[format["<t size = '0.5'>%1</t>", (east countSide (allPlayers - entities "HeadlessClient_F")) ],0.267 * safezoneW + safezoneX,0.0740001 * safezoneH + safezoneY,99999999,0,0,2204] spawn BIS_fnc_dynamicText;
		//AAF
			[format["<t size = '0.8'>%1</t>",(asaayu getVariable ["score",[0,0,0]]) select 2],0.3225 * safezoneW + safezoneX,0.03900001 * safezoneH + safezoneY,99999999,0,0,2193] spawn BIS_fnc_dynamicText; 		
			[format["<t size = '0.5'>%1</t>", (independent countSide (allPlayers - entities "HeadlessClient_F")) ],0.3225 * safezoneW + safezoneX,0.0740001 * safezoneH + safezoneY,99999999,0,0,2203] spawn BIS_fnc_dynamicText;
			uisleep 1;
		};
	};
};
//============================


//============================
// Spawning Player;
[] spawn {
    waitUntil {spawnInReady};
    switch (playerSide) do {
        case west: {
            private _spawnPos = getPos westSpawn;
            private _spawnDir = getDir westSpawn;
            player setPos _spawnPos;
            player setDir _spawnDir;
        };
        case east: {
            private _spawnPos = getPos eastSpawn;
            private _spawnDir = getDir eastSpawn;
            player setPos _spawnPos;
            player setDir _spawnDir;
        };
    };

    [] spawn {
        player allowDamage false;
        uiSleep 5;
        player allowDamage true;
    };
    
    player setVelocity [0,0,0];
    player enableSimulation true;
    player hideObject false;
    1120 cutText ["", "PLAIN", 9999999];
    0 fadeSound 1;
    0 fadeMusic 0.5;
    enableEnvironment true;
};
//============================


//============================
//Ending
[] spawn {
	uiSleep 1;
	waitUntil{end};
	[] spawn {
		onEachFrame{
			{
				["",-1,-1,99999,0,0,_x] spawn BIS_fnc_dynamicText;
			}forEach[9995,1105,9925,1106,2185,2184,2183,1562,1561,2222,2223,2122,2123,2128,2188,2195,2205,2194,2204,2193,2203];
		};
	};
	0 fadeMusic 1;
	playMusic "LeadTrack01_F_Heli";
	showCinemaBorder false;
	private "_cam";
	_cam = "camera" camCreate (getPosATL startObject);
	_cam camSetTarget mainFlag;
	_cam cameraEffect ["internal", "BACK"];
	_cam camCommit 0;
	[] spawn {
		switch (winner) do {
		case "blue": {
			["<t size = '2'>BLUFOR </t><br /><t size = '1'>VICTORY</t>",0.295 * safezoneW + safezoneX,0.2560001 * safezoneH + safezoneY,99999,3,0,9875] spawn BIS_fnc_dynamicText;
			["<t size='1.5'><img image='\a3\Data_f\cfgFactionClasses_BLU_ca.paa' />",0.295 * safezoneW + safezoneX,0.2000001 * safezoneH + safezoneY,99999999,3,0,9873] spawn BIS_fnc_dynamicText;
			uiSleep 10;
			["<t size = '1'>Thanks for playing</t>",0.295 * safezoneW + safezoneX,0.3940001 * safezoneH + safezoneY,999,2,0,9874] spawn BIS_fnc_dynamicText; 
				};
		case "red": {
			["<t size = '2'>OPFOR </t><br /><t size = '1'>VICTORY</t>",0.295 * safezoneW + safezoneX,0.2560001 * safezoneH + safezoneY,999999,3,0,9875] spawn BIS_fnc_dynamicText;
			["<t size='1.5'><img image='\a3\Data_f\cfgFactionClasses_OPF_ca.paa' />",0.295 * safezoneW + safezoneX,0.2000001 * safezoneH + safezoneY,99999999,3,0,9873] spawn BIS_fnc_dynamicText;
			uiSleep 10;
			["<t size = '1'>Thanks for playing</t>",0.295 * safezoneW + safezoneX,0.3940001 * safezoneH + safezoneY,999,2,0,9874] spawn BIS_fnc_dynamicText;
		};
		case "green": {
			["<t size = '2'>INDEPENDENT </t><br /><t size = '1'>VICTORY</t>",0.295 * safezoneW + safezoneX,0.2560001 * safezoneH + safezoneY,999999,3,0,9875] spawn BIS_fnc_dynamicText;
			["<t size='1.5'><img image='\a3\Data_f\cfgFactionClasses_IND_ca.paa' />",0.295 * safezoneW + safezoneX,0.2000001 * safezoneH + safezoneY,99999999,3,0,9873] spawn BIS_fnc_dynamicText;
			uiSleep 10;
			["<t size = '1'>Thanks for playing</t>",0.295 * safezoneW + safezoneX,0.3940001 * safezoneH + safezoneY,999,2,0,9874] spawn BIS_fnc_dynamicText;
		};
	};
	};
	_cam camSetPos (getPosATL endObject);
	_cam camCommit 35;
	waitUntil { camCommitted _cam};
	1120 cutText ["", "BLACK FADED", 9999999];
};
//============================ 
