//============================
//Setting up mission params
private _timeLimit = paramsArray select 2;
toFixed 2; 
asaayu setVariable ["timeLimit",_timeLimit,true];
toFixed -1;
asaayu setVariable ["score",[0,0,0],true];
flagOnPole = true;
publicVariable "flagOnPole";
scored = false;
publicVariable "scored";
end = false;
publicVariable "end";
winner = "";
publicVariable "winner";
overTime = false;
overTimeScore = 0;
hhu = true;
//============================

// Define possible flag locations in Malden
flagLocations = [
    [8118.91,10066.5,0], // Example coordinates
    [7239.13,7930.18,0],
    [5663.35,7001.98,0],
    [3544.74,3287.13,0]
];
publicVariable "flagLocations";

// Select a random position from the array
randomIndex = floor (random (count flagLocations));
publicVariable "randomIndex";

selectedFlagPosition = flagLocations select randomIndex;
publicVariable "selectedFlagPosition";

// Set the main flag and marker positions
mainFlag setPos selectedFlagPosition;
"marker_7" setMarkerPos selectedFlagPosition;


//============================
// Mission event handler for if player is carrying flag on disconnect
handle1 = addMissionEventHandler [
	"HandleDisconnect",
	{
		if(flagOwner mainFlag isEqualto (_this select 0)) then {
		mainFlag setFlagOwner objNull;
		["<t size = '1.5'>THE FLAG HAS RESPAWNED</t>",0.295 * safezoneW + safezoneX,0.1240001 * safezoneH + safezoneY,1,1,0,1105] remoteExec ["BIS_fnc_dynamicText", 0];
		["<t size = '0'><img image='\a3\Modules_f\data\iconSector_ca.paa' /></t>",0.322 * safezoneW + safezoneX,0.09500001 * safezoneH + safezoneY,99999999,0,0,9925] remoteExec ["BIS_fnc_dynamicText", 0];
		flagOnPole = true;
		publicVariable "flagOnPole";
		}
	}
];
//============================


//============================
//time setup for server, sent to clients
[] spawn {
	_originalTime = serverTime;
	private _time = asaayu getVariable ["timeLimit",45];
	_result = 60 *_time;
	_result =_result - (serverTime - _originalTime);
	_textResult = [_result] call BIS_fnc_secondsToString;
	[format["<t font = 'PuristaBold' size = '.8'>%1</t>",_textResult],0.295 * safezoneW + safezoneX,0.00000001 * safezoneH + safezoneY,99,0,0,2188] remoteExec ["BIS_fnc_dynamicText", 0];
	while{_result > 0 && !overTime && !end}do{
			uisleep 1;
			_result = _result - 1;
			_textResult = [_result] call BIS_fnc_secondsToString;
			if(_result <= 60 && hhu)then {
			[true,false] remoteExec ["BIS_fnc_playEndMusic", 0];
			hhu = false;
			};
			[format["<t font = 'PuristaBold' size = '.8'>%1</t>",_textResult],0.295 * safezoneW + safezoneX,0.00000001 * safezoneH + safezoneY,99,0,0,2188] remoteExec ["BIS_fnc_dynamicText", 0];
	};
	while{overTime && !end}do{
	["<t font = 'PuristaBold' size = '.8'>00:00:00</t>",0.295 * safezoneW + safezoneX,0.00000001 * safezoneH + safezoneY,99999,0,0,2188] remoteExec ["BIS_fnc_dynamicText", 0];		
	uisleep 1;
	["<t font = 'PuristaBold' color = '#FF0000' size = '.8'>OVERTIME</t>",0.295 * safezoneW + safezoneX,0.00000001 * safezoneH + safezoneY,99999,0,0,2188] remoteExec ["BIS_fnc_dynamicText", 0];
	uiSleep 1;
	};
};
//============================


//============================
// loop for if AI dies holding flag 
[] spawn {
	while{true}do{
		sleep 1;
		if(!alive (flagOwner mainFlag) && !((flagOwner mainFlag) isEqualto objNull))then {
			mainFlag setFlagOwner objNull;
			flagOnPole = true;
			publicVariable "flagOnPole";
			["<t size = '0'><img image='\a3\Modules_f\data\iconSector_ca.paa' /></t>",0.322 * safezoneW + safezoneX,0.09500001 * safezoneH + safezoneY,99999999,0,0,9925] remoteExec ["BIS_fnc_dynamicText", 0];
			["<t size = '1.5'>THE FLAG HAS BEEN RETURNED</t>",0.295 * safezoneW + safezoneX,0.1240001 * safezoneH + safezoneY,1,1,0,1105] remoteExec ["BIS_fnc_dynamicText", 0];
		};
	};
};
//============================


//============================
//Setting up side relations
[] spawn {
	blufor setFriend [civilian, 0];
	opfor setFriend [civilian, 0];
};
//============================


//============================
// Score functions
[] spawn {
    while {true} do {
        waitUntil {scored};
        ["<t size = '0'><img image='\a3\Modules_f\data\iconSector_ca.paa' /></t>", 0.322 * safezoneW + safezoneX, 0.09500001 * safezoneH + safezoneY, 99999999, 0, 0, 9925] remoteExec ["BIS_fnc_dynamicText", 0];
        
        mainFlag setFlagOwner asaayu;
        
        if (overTime) then {
            _scoreEnd = asaayu getVariable ["score", [0, 0, 0]];
            if ((_scoreEnd select 0 <= overTimeScore) && (_scoreEnd select 1 <= overTimeScore) && (_scoreEnd select 2 <= overTimeScore)) then {
                overTime = true;
                publicVariable "overTime";
                ["<t size = '1.5'>OVERTIME<br />CONTINUES</t>", 0.295 * safezoneW + safezoneX, 0.1240001 * safezoneH + safezoneY, 4, 1, 0, 1105] remoteExec ["BIS_fnc_dynamicText", 0];
            } else {
                overTime = false; 
                publicVariable "overTime";
            };
        };

        // Relocate flag to a new random position
        randomIndex = floor (random (count flagLocations));
        newFlagPosition = flagLocations select randomIndex;
        mainFlag setPos newFlagPosition;
        "marker_7" setMarkerPos newFlagPosition;
        uiSleep 90;
        mainFlag setFlagOwner objNull;
        flagOnPole = true;
        publicVariable "flagOnPole";
        scored = false;
        publicVariable "scored";
        ["<t size = '1.5'>THE FLAG HAS RESPAWNED/MOVED!</t>", 0.295 * safezoneW + safezoneX, 0.1240001 * safezoneH + safezoneY, 1, 1, 0, 1105] remoteExec ["BIS_fnc_dynamicText", 0];
    };
};
//============================


//============================
//Waiting until the mission ends;
[] spawn {
	private _scoreLimit = paramsArray select 3;
	waitUntil{(asaayu getVariable ["score",[0,0,0]]) select 0 >= _scoreLimit || (asaayu getVariable ["score",[0,0,0]]) select 1 >= _scoreLimit ||(asaayu getVariable ["score",[0,0,0]]) select 2 >= _scoreLimit};
	end = true;
	publicVariable "end";
	if((asaayu getVariable ["score",[0,0,0]]) select 0 >= _scoreLimit)then {
		winner = "blue";
		publicVariable "winner";
	};
	if((asaayu getVariable ["score",[0,0,0]]) select 1 >= _scoreLimit)then {
		winner = "red";
		publicVariable "winner";
	};
	if((asaayu getVariable ["score",[0,0,0]]) select 2 >= _scoreLimit)then {
		winner = "green";
		publicVariable "winner";
	};
	uiSleep 25;
	"EveryoneWon" call BIS_fnc_endMissionServer
};
//============================


//============================
//sleep until time limit end
uiSleep (60*_timeLimit);
//============================


//============================
// Time victory checking
_topScore = selectMax (asaayu getVariable ["score",[0,0,0]]);
_scoreEnd = asaayu getVariable ["score",[0,0,0]];
if(_scoreEnd select 0 < _topScore && _scoreEnd select 1 < _topScore || _scoreEnd select 1 < _topScore && _scoreEnd select 2 < _topScore || _scoreEnd select 2 < _topScore && _scoreEnd select 0 < _topScore) then {
	overTime = false;
	publicVariable "overTime";
}else{
	overTimeScore = selectMax (asaayu getVariable ["score",[0,0,0]]);
	publicVariable "overTimeScore";
	overTime = true;
	publicVariable "overTime";	
	["<t size = '1.5'>OVERTIME<br />NEXT FLAG WINS</t>",0.295 * safezoneW + safezoneX,0.1240001 * safezoneH + safezoneY,4,1,0,1105] remoteExec ["BIS_fnc_dynamicText", 0];
};
//============================


//============================
//See if overtime was started if not end game with winner
waitUntil{!overTime};
end = true;
publicVariable "end";
_winningScore = selectMax (asaayu getVariable ["score",[0,0,0]]);
if((asaayu getVariable ["score",[0,0,0]]) select 0 isEqualto _winningScore)then {
	winner = "blue";
	publicVariable "winner";
};
if((asaayu getVariable ["score",[0,0,0]]) select 1 isEqualto _winningScore)then {
	winner = "red";
	publicVariable "winner";
};
if((asaayu getVariable ["score",[0,0,0]]) select 2 isEqualto _winningScore)then {
	winner = "green";
	publicVariable "winner";
};
//============================


//============================
//let finish cinematic play before ending 
uiSleep 25;
"EveryoneWon" call BIS_fnc_endMissionServer
//============================

/*fin*/