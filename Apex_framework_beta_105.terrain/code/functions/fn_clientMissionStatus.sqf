/*/
File: fn_clientMissionStatus.sqf
Author:
	
	Quiksilver
	
Last Modified:

	9/12/2017 A3 1.80 by Quiksilver

Description:

	Mission Status Display
__________________________________________________________/*/
scriptName 'QS Mission Status';
disableSerialization;
waitUntil {
	uiSleep 0.1;
	(!isNull (findDisplay 46))
};
_side = playerSide;
_display = findDisplay 46;
private _key = actionKeysNames 'NavigateMenu';
private _keyText = _key select [1,((count _key) - 2)];
private _array = [];
private _array2 = [];
private _rate = 0;
private _rateAdjusted = 0;
private _scoreWin = missionNamespace getVariable ['QS_virtualSectors_scoreWin',300];
private _isBeingInterrupted = FALSE;
private _QS_ctrlCreateArray = [];
{
	missionNamespace setVariable _x;
} forEach [
	['QS_client_vs_isInControlArea',FALSE,FALSE],
	['QS_client_vs_isInCaptureArea',FALSE,FALSE],
	['QS_client_vs_msgEnteredControlArea',FALSE,FALSE],
	['QS_client_vs_msgEnteredCaptureArea',FALSE,FALSE]
];
_fn_sectorHint = {
	_playerPos = getPosATL player;
	if ((_playerPos select 2) > 10) exitWith {};
	params ['_radiusCapture','_radiusControl'];
	_position = [0,_playerPos] call (missionNamespace getVariable 'QS_fnc_scGetNearestSector');
	if (_position isEqualTo []) exitWith {};
	if ((_playerPos distance2D _position) < _radiusControl) then {
		if ((_playerPos distance2D _position) <= _radiusCapture) then {
			if (missionNamespace getVariable 'QS_client_vs_isInControlArea') then {
				missionNamespace setVariable ['QS_client_vs_isInControlArea',FALSE,FALSE];
			};
			if (!(missionNamespace getVariable 'QS_client_vs_isInCaptureArea')) then {
				missionNamespace setVariable ['QS_client_vs_isInCaptureArea',TRUE,FALSE];
			};
			if (!(missionNamespace getVariable 'QS_client_vs_msgEnteredCaptureArea')) then {
				missionNamespace setVariable ['QS_client_vs_msgEnteredCaptureArea',TRUE,FALSE];
				(missionNamespace getVariable 'QS_managed_hints') pushBack [1,FALSE,3,-1,'Entering CAPTURE area',[],(serverTime + 15)];
			};
			if (missionNamespace getVariable 'QS_client_vs_msgEnteredControlArea') then {
				missionNamespace setVariable ['QS_client_vs_msgEnteredControlArea',FALSE,FALSE];
			};
		} else {
			comment 'Was in Cap area, entering Ctrl area';
			if (missionNamespace getVariable 'QS_client_vs_isInCaptureArea') then {
				missionNamespace setVariable ['QS_client_vs_isInCaptureArea',FALSE,FALSE];
			};
			if (!(missionNamespace getVariable 'QS_client_vs_isInControlArea')) then {
				missionNamespace setVariable ['QS_client_vs_isInControlArea',TRUE,FALSE];
			};
			if (!(missionNamespace getVariable 'QS_client_vs_msgEnteredControlArea')) then {
				missionNamespace setVariable ['QS_client_vs_msgEnteredControlArea',TRUE,FALSE];
				(missionNamespace getVariable 'QS_managed_hints') pushBack [1,FALSE,3,-1,'Entering CONTROL area',[],(serverTime + 15)];
			};
			if (missionNamespace getVariable 'QS_client_vs_msgEnteredCaptureArea') then {
				missionNamespace setVariable ['QS_client_vs_msgEnteredCaptureArea',FALSE,FALSE];
				(missionNamespace getVariable 'QS_managed_hints') pushBack [1,FALSE,3,-1,'Leaving CAPTURE area, entering CONTROL area',[],(serverTime + 15)];
			};
		};
	} else {
		if (missionNamespace getVariable 'QS_client_vs_isInControlArea') then {
			missionNamespace setVariable ['QS_client_vs_isInControlArea',FALSE,FALSE];
		};
		if (missionNamespace getVariable 'QS_client_vs_isInCaptureArea') then {
			missionNamespace setVariable ['QS_client_vs_isInCaptureArea',FALSE,FALSE];
		};
		if (missionNamespace getVariable 'QS_client_vs_msgEnteredCaptureArea') then {
			missionNamespace setVariable ['QS_client_vs_msgEnteredCaptureArea',FALSE,FALSE];
			if ((_playerPos distance2D _position) < (_radiusControl * 1.5)) then {
				(missionNamespace getVariable 'QS_managed_hints') pushBack [1,FALSE,3,-1,'Leaving CAPTURE area',[],(serverTime + 15)];
			};
		};
		if (missionNamespace getVariable 'QS_client_vs_msgEnteredControlArea') then {
			missionNamespace setVariable ['QS_client_vs_msgEnteredControlArea',FALSE,FALSE];
			if ((_playerPos distance2D _position) < (_radiusControl * 1.5)) then {
				(missionNamespace getVariable 'QS_managed_hints') pushBack [1,FALSE,3,-1,'Leaving CONTROL area',[],(serverTime + 15)];
			};
		};
	};
};

comment '****************************** 1 ******************************';

_QS_color_profile = [(profilenamespace getvariable ['GUI_BCG_RGB_R',0.3843]),(profilenamespace getvariable ['GUI_BCG_RGB_G',0.7019]),(profilenamespace getvariable ['GUI_BCG_RGB_B',0.8862]),(profilenamespace getvariable ['GUI_BCG_RGB_A',0.7])];
_QS_ctrlCreateArray = ['RscFrame',12340];
_QS_ctrl0 = _display ctrlCreate _QS_ctrlCreateArray;
_QS_ctrl0 ctrlShow FALSE;
_QS_ctrl0 ctrlSetPosition [
	((0.395 * safezoneW) + safezoneX),
	((0 * safezoneH) + safezoneY),
	0.52,
	0.13
];
_QS_ctrl0_backgroundColor = [0,0,0,0]; /*/[0,0,0,0.95]/*/
_QS_ctrl0 ctrlSetTextColor [0,0,0,0];
_QS_ctrl0 ctrlSetBackgroundColor _QS_ctrl0_backgroundColor;
_QS_ctrl0 ctrlCommit 0;
/*/_QS_ctrlCreateArray = ['RscBackground',12341];/*/
_QS_ctrlCreateArray = ['RscPicture',12341];
_QS_ctrl01 = _display ctrlCreate _QS_ctrlCreateArray;
_QS_ctrl01 ctrlShow FALSE;
_QS_ctrl01 ctrlSetPosition [
	((0.395 * safezoneW) + safezoneX),
	((0 * safezoneH) + safezoneY),
	0.52,
	0.13
];
_QS_ctrl01 ctrlSetText 'media\images\icons\gradient_ca.paa';
_QS_ctrl01_backgroundColor = [0,0,0,0.5];/*/[0,0,0,0.7]/*/
_QS_ctrl01 ctrlSetTextColor _QS_ctrl01_backgroundColor;
_QS_ctrl01 ctrlSetBackgroundColor _QS_ctrl01_backgroundColor;
_QS_ctrl01 ctrlCommit 0;
_QS_ctrlCreateArray = ['RscPictureKeepAspect',12345];
_QS_ctrl1 = _display ctrlCreate _QS_ctrlCreateArray;
_QS_ctrl1 ctrlShow FALSE;
_QS_ctrl1 ctrlSetPosition [
	((0.4 * safezoneW) + safezoneX),
	((0.01 * safezoneH) + safezoneY),
	0.1,
	0.1
];
private _QS_ctrl_text1 = 'a3\ui_f\data\igui\cfg\HoldActions\progress2\progress_14_ca.paa';
private _QS_ctrl_color1 = [0.5,0,0,0.65];
_QS_ctrl1 ctrlSetText _QS_ctrl_text1;
_QS_ctrl1 ctrlSetTextColor _QS_ctrl_color1;
_QS_ctrl1_scale = 1;
_QS_ctrl1 ctrlSetScale _QS_ctrl1_scale;
_QS_ctrl1 ctrlCommit 0;

_QS_ctrl1_position_0 = (ctrlPosition _QS_ctrl1) select 0;
_QS_ctrl1_position_1 = (ctrlPosition _QS_ctrl1) select 1;
_QS_ctrl1_position_2 = (ctrlPosition _QS_ctrl1) select 2;
_QS_ctrl1_position_3 = (ctrlPosition _QS_ctrl1) select 3;

comment '****************************** 2 ******************************';
_QS_ctrlCreateArray = ['RscPictureKeepAspect',12346];
_QS_ctrl2 = _display ctrlCreate _QS_ctrlCreateArray;
_QS_ctrl2 ctrlShow FALSE;
_QS_ctrl2 ctrlSetPosition [
	(((ctrlPosition _QS_ctrl1) select 0) + (((ctrlPosition _QS_ctrl1) select 2) + 0.1)),
	((0.01 * safezoneH) + safezoneY),
	0.1,
	0.1
];
private _QS_ctrl_text2 = 'a3\ui_f\data\igui\cfg\HoldActions\progress2\progress_21_ca.paa';
private _QS_ctrl_color2 = [0,0.3,0.6,0.65];
_QS_ctrl2 ctrlSetText _QS_ctrl_text2;
_QS_ctrl2 ctrlSetTextColor _QS_ctrl_color2;
_QS_ctrl2_scale = 1;
_QS_ctrl2 ctrlSetScale _QS_ctrl2_scale;
_QS_ctrl2 ctrlCommit 0;

_QS_ctrl2_position_0 = (ctrlPosition _QS_ctrl2) select 0;
_QS_ctrl2_position_1 = (ctrlPosition _QS_ctrl2) select 1;
_QS_ctrl2_position_2 = (ctrlPosition _QS_ctrl2) select 2;
_QS_ctrl2_position_3 = (ctrlPosition _QS_ctrl2) select 3;

comment '****************************** 3 ******************************';
_QS_ctrlCreateArray = ['RscPictureKeepAspect',12347];
_QS_ctrl3 = _display ctrlCreate _QS_ctrlCreateArray;
_QS_ctrl3 ctrlShow FALSE;
_QS_ctrl3 ctrlSetPosition [
	(((ctrlPosition _QS_ctrl2) select 0) + (((ctrlPosition _QS_ctrl2) select 2) + 0.1)),
	((0.01 * safezoneH) + safezoneY),
	0.1,
	0.1
];
private _QS_ctrl_text3 = 'a3\ui_f\data\igui\cfg\HoldActions\progress2\progress_4_ca.paa';
private _QS_ctrl_color3 = [0.7,0.6,0,0.5];
_QS_ctrl3 ctrlSetText _QS_ctrl_text3;
_QS_ctrl3 ctrlSetTextColor _QS_ctrl_color3;
_QS_ctrl3_scale = 1;
_QS_ctrl3 ctrlSetScale _QS_ctrl3_scale;
_QS_ctrl3 ctrlCommit 0;

_QS_ctrl3_position_0 = (ctrlPosition _QS_ctrl3) select 0;
_QS_ctrl3_position_1 = (ctrlPosition _QS_ctrl3) select 1;
_QS_ctrl3_position_2 = (ctrlPosition _QS_ctrl3) select 2;
_QS_ctrl3_position_3 = (ctrlPosition _QS_ctrl3) select 3;

comment '****************************** 4 ******************************';
_QS_ctrlCreateArray = ['RscPictureKeepAspect',12348];
_QS_ctrl4 = _display ctrlCreate _QS_ctrlCreateArray;
_QS_ctrl4 ctrlShow FALSE;
_QS_ctrl4 ctrlSetPosition [
	_QS_ctrl1_position_0,
	_QS_ctrl1_position_1,
	_QS_ctrl1_position_2,
	_QS_ctrl1_position_3
];
_QS_ctrl4_scale = 1;
_QS_ctrl4 ctrlSetScale _QS_ctrl4_scale;
_QS_ctrl_text4 = 'a3\ui_f\data\igui\cfg\simpleTasks\letters\a_ca.paa';
_QS_ctrl_color4 = [1,1,1,0.75];
_QS_ctrl4 ctrlSetText _QS_ctrl_text4;
_QS_ctrl4 ctrlSetTextColor _QS_ctrl_color4;
_QS_ctrl4_scale = 1;
_QS_ctrl4 ctrlSetScale _QS_ctrl4_scale;
_QS_ctrl4 ctrlCommit 0;

comment '****************************** 5 ******************************';
_QS_ctrlCreateArray = ['RscPictureKeepAspect',12349];
_QS_ctrl5 = _display ctrlCreate _QS_ctrlCreateArray;
_QS_ctrl5 ctrlShow FALSE;
_QS_ctrl5 ctrlSetPosition [
	_QS_ctrl2_position_0,
	_QS_ctrl2_position_1,
	_QS_ctrl2_position_2,
	_QS_ctrl2_position_3
];
_QS_ctrl5_scale = 1;
_QS_ctrl5 ctrlSetScale _QS_ctrl5_scale;
_QS_ctrl_text5 = 'a3\ui_f\data\igui\cfg\simpleTasks\letters\b_ca.paa';
_QS_ctrl_color5 = [1,1,1,0.75];
_QS_ctrl5 ctrlSetText _QS_ctrl_text5;
_QS_ctrl5 ctrlSetTextColor _QS_ctrl_color5;
_QS_ctrl5 ctrlCommit 0;

comment '****************************** 6 ******************************';
_QS_ctrlCreateArray = ['RscPictureKeepAspect',12350];
_QS_ctrl6 = _display ctrlCreate _QS_ctrlCreateArray;
_QS_ctrl6 ctrlShow FALSE;
_QS_ctrl6 ctrlSetPosition [
	_QS_ctrl3_position_0,
	_QS_ctrl3_position_1,
	_QS_ctrl3_position_2,
	_QS_ctrl3_position_3
];
_QS_ctrl6_scale = 1;
_QS_ctrl6 ctrlSetScale _QS_ctrl6_scale;
_QS_ctrl_text6 = 'a3\ui_f\data\igui\cfg\simpleTasks\letters\c_ca.paa';
_QS_ctrl_color6 = [1,1,1,0.75];
_QS_ctrl6 ctrlSetText _QS_ctrl_text6;
_QS_ctrl6 ctrlSetTextColor _QS_ctrl_color6;
_QS_ctrl6 ctrlCommit 0;

comment '****************************** Attack/Defend ******************************';

_QS_icon_attack = 'a3\ui_f\data\igui\cfg\simpleTasks\types\attack_ca.paa';
_QS_icon_defend = 'a3\ui_f\data\gui\cfg\GameTypes\defend_ca.paa';

comment '****************************** 7 ******************************';
_QS_ctrlCreateArray = ['RscPictureKeepAspect',12351];
_QS_ctrl7 = _display ctrlCreate _QS_ctrlCreateArray;
_QS_ctrl7 ctrlShow FALSE;
_QS_ctrl7 ctrlSetPosition [
	_QS_ctrl1_position_0,
	_QS_ctrl1_position_1,
	_QS_ctrl1_position_2,
	_QS_ctrl1_position_3
];
_QS_ctrl7_scale = 0.25;
_QS_ctrl7 ctrlSetScale _QS_ctrl7_scale;
private _QS_ctrl_text7 = _QS_icon_attack;
private _QS_ctrl_color7 = [1,1,1,0.75];
_QS_ctrl7 ctrlSetText _QS_ctrl_text7;
_QS_ctrl7 ctrlSetTextColor _QS_ctrl_color7;
private _QS_ctrl7_fadeDir = -1;
_QS_ctrl7 ctrlCommit 0;

comment '****************************** 8 ******************************';
_QS_ctrlCreateArray = ['RscPictureKeepAspect',12352];
_QS_ctrl8 = _display ctrlCreate _QS_ctrlCreateArray;
_QS_ctrl8 ctrlShow FALSE;
_QS_ctrl8 ctrlSetPosition [
	_QS_ctrl2_position_0,
	_QS_ctrl2_position_1,
	_QS_ctrl2_position_2,
	_QS_ctrl2_position_3
];
_QS_ctrl8_scale = 0.25;
_QS_ctrl8 ctrlSetScale _QS_ctrl8_scale;
private _QS_ctrl_text8 = _QS_icon_defend;
private _QS_ctrl_color8 = [1,1,1,0.75];
_QS_ctrl8 ctrlSetText _QS_ctrl_text8;
_QS_ctrl8 ctrlSetTextColor _QS_ctrl_color8;
private _QS_ctrl8_fadeDir = -1;
_QS_ctrl8 ctrlCommit 0;

comment '****************************** 9 ******************************';
_QS_ctrlCreateArray = ['RscPictureKeepAspect',12353];
_QS_ctrl9 = _display ctrlCreate _QS_ctrlCreateArray;
_QS_ctrl9 ctrlShow FALSE;
_QS_ctrl9 ctrlSetPosition [
	_QS_ctrl3_position_0,
	_QS_ctrl3_position_1,
	_QS_ctrl3_position_2,
	_QS_ctrl3_position_3
];
_QS_ctrl9_scale = 0.25;
_QS_ctrl9 ctrlSetScale _QS_ctrl9_scale;
private _QS_ctrl_text9 = _QS_icon_defend;
private _QS_ctrl_color9 = [1,1,1,0.75];
_QS_ctrl9 ctrlSetText _QS_ctrl_text9;
_QS_ctrl9 ctrlSetTextColor _QS_ctrl_color9;
private _QS_ctrl9_fadeDir = -1;
_QS_ctrl9 ctrlCommit 0;

comment '****************************** 10 ******************************';
_QS_ctrlCreateArray = ['RscIGUIText',12354];
_QS_ctrl10 = _display ctrlCreate _QS_ctrlCreateArray;
_QS_ctrl10 ctrlShow FALSE;
_QS_ctrl10_position_0 = (ctrlPosition _QS_ctrl01) select 0;
_QS_ctrl10_position_1 = ((-0.015 * safezoneH) + safezoneY);
_QS_ctrl10_position_2 = (ctrlPosition _QS_ctrl01) select 2;
_QS_ctrl10_position_3 = (ctrlPosition _QS_ctrl01) select 3;
_QS_ctrl10 ctrlSetPosition [
	_QS_ctrl10_position_0,
	_QS_ctrl10_position_1,
	_QS_ctrl10_position_2,
	_QS_ctrl10_position_3
];
_QS_ctrl10_scale = 0.75;
_QS_ctrl10 ctrlSetScale _QS_ctrl10_scale;
_QS_ctrl_text10 = '';
_QS_ctrl10_alpha = 0.75;
_QS_ctrl10_font = 'RobotoCondensed';
_QS_ctrl10 ctrlSetFont _QS_ctrl10_font;
_QS_ctrl10 ctrlSetText _QS_ctrl_text10;
private _QS_sectorHintShown = TRUE;
if (isNil {profileNamespace getVariable 'QS_ui_missionstatus_token'}) then {
	profileNamespace getVariable ['QS_ui_missionstatus_token',0];
};
if (!((profileNamespace getVariable 'QS_ui_missionstatus_token') isEqualType 0)) then {
	profileNamespace getVariable ['QS_ui_missionstatus_token',0];
};
profileNamespace setVariable [
	'QS_ui_missionstatus_token',
	((profileNamespace getVariable ['QS_ui_missionstatus_token',0]) + 1)
];
saveProfileNamespace;
if ((profileNamespace getVariable 'QS_ui_missionstatus_token') > 40) then {
	_QS_ctrl10_alpha = 0;
	_QS_sectorHintShown = FALSE;
};
_QS_ctrl_color10 = [0.5,0.5,0.5,_QS_ctrl10_alpha];
_QS_ctrl10 ctrlSetTextColor _QS_ctrl_color10;
_QS_ctrl10 ctrlCommit 0;

comment '****************************** 11 ******************************';

_QS_flag_west = missionNamespace getVariable ['QS_missionConfig_textures_defaultFlag','a3\data_f\flags\flag_nato_co.paa'];
_QS_flag_east = '\a3\Data_f_exp\Flags\flag_viper_co.paa';
_QS_ctrlCreateArray = ['RscPictureKeepAspect',12355];
_QS_ctrl11 = _display ctrlCreate _QS_ctrlCreateArray;
_QS_ctrl11 ctrlShow FALSE;
comment 'QS_ctrl11_pos_x = ((0.44 * safezoneW) + safezoneX);';
_QS_ctrl11_pos_x = ((ctrlPosition _QS_ctrl1) select 0) + (((ctrlPosition _QS_ctrl1) select 2) / 0.98);
_QS_ctrl11_pos_y = ((0.005 * safezoneH) + safezoneY);
_QS_ctrl11_pos_w = 0.1;
_QS_ctrl11_pos_h = 0.03;
_QS_ctrl11_scale = 1;
_QS_ctrl_text11 = _QS_flag_west;
_QS_ctrl_color11 = [1,1,1,0.75];
_QS_ctrl11 ctrlSetPosition [
	_QS_ctrl11_pos_x,
	_QS_ctrl11_pos_y,
	_QS_ctrl11_pos_w,
	_QS_ctrl11_pos_h
];
_QS_ctrl11 ctrlSetText _QS_ctrl_text11;
_QS_ctrl11 ctrlSetTextColor _QS_ctrl_color11;
_QS_ctrl11 ctrlSetScale _QS_ctrl11_scale;
_QS_ctrl11 ctrlCommit 0;

comment '****************************** 12 ******************************';
comment 'Progress bar';

_QS_ctrl12_pos_x = ((ctrlPosition _QS_ctrl1) select 0) + (((ctrlPosition _QS_ctrl1) select 2) / 0.98);
_QS_ctrl12_pos_y = ((0.025 * safezoneH) + safezoneY) + (((ctrlPosition _QS_ctrl1) select 3) / 4); comment '0.035';
_QS_ctrl12_pos_w = 0.1;
_QS_ctrl12_pos_h = 0.015;	
_QS_ctrlCreateArray = ['RscBackground',12359];
_QS_ctrl120 = _display ctrlCreate _QS_ctrlCreateArray;
_QS_ctrl120 ctrlShow FALSE;
_QS_ctrl120 ctrlSetPosition [
	_QS_ctrl12_pos_x,
	_QS_ctrl12_pos_y,
	_QS_ctrl12_pos_w,
	_QS_ctrl12_pos_h
];
_QS_ctrl120_backgroundColor = [0.5,0.5,0.5,0.5];
_QS_ctrl120 ctrlSetBackgroundColor _QS_ctrl120_backgroundColor;
_QS_ctrl120 ctrlCommit 0;
_QS_ctrlCreateArray = ['RscProgress',12356];
_QS_ctrl12 = _display ctrlCreate _QS_ctrlCreateArray;
_QS_ctrl12 ctrlShow FALSE;
_QS_ctrl12_scale = 1;
_QS_ctrl_text12 = '';
_QS_ctrl_color12 = _QS_color_profile;
_QS_ctrl12_progress = 1;
_QS_ctrl12 ctrlSetPosition [
	_QS_ctrl12_pos_x,
	_QS_ctrl12_pos_y,
	_QS_ctrl12_pos_w,
	_QS_ctrl12_pos_h
];
_QS_ctrl12 ctrlSetText _QS_ctrl_text12;
_QS_ctrl12 ctrlSetTextColor _QS_ctrl_color12;
_QS_ctrl12 ctrlSetScale _QS_ctrl12_scale;
_QS_ctrl12 ctrlCommit 0;
_QS_ctrl12 progressSetPosition _QS_ctrl12_progress;

comment '****************************** 13 ******************************';
_QS_ctrlCreateArray = ['RscPictureKeepAspect',12357];
_QS_ctrl13 = _display ctrlCreate _QS_ctrlCreateArray;
_QS_ctrl13 ctrlShow FALSE;
comment 'QS_ctrl13_pos_x = ((0.525 * safezoneW) + safezoneX);';
_QS_ctrl13_pos_x = ((ctrlPosition _QS_ctrl1) select 0) + (((ctrlPosition _QS_ctrl1) select 2) / 0.33);
_QS_ctrl13_pos_y = ((0.005 * safezoneH) + safezoneY);
_QS_ctrl13_pos_w = 0.1;
_QS_ctrl13_pos_h = 0.03;
_QS_ctrl13_scale = 1;
_QS_ctrl_text13 = _QS_flag_east;
_QS_ctrl_color13 = [1,1,1,0.75];
_QS_ctrl13 ctrlSetPosition [
	_QS_ctrl13_pos_x,
	_QS_ctrl13_pos_y,
	_QS_ctrl13_pos_w,
	_QS_ctrl13_pos_h
];
_QS_ctrl13 ctrlSetText _QS_ctrl_text13;
_QS_ctrl13 ctrlSetTextColor _QS_ctrl_color13;
_QS_ctrl13 ctrlSetScale _QS_ctrl13_scale;
_QS_ctrl13 ctrlCommit 0;

comment '****************************** 14 ******************************';
comment 'Progress bar';
_QS_ctrl14_pos_x = ((ctrlPosition _QS_ctrl1) select 0) + (((ctrlPosition _QS_ctrl1) select 2) / 0.33);
_QS_ctrl14_pos_y = ((0.025 * safezoneH) + safezoneY) + (((ctrlPosition _QS_ctrl1) select 3) / 4);
_QS_ctrl14_pos_w = 0.1;
_QS_ctrl14_pos_h = 0.015;
_QS_ctrlCreateArray = ['RscBackground',12360];
_QS_ctrl140 = _display ctrlCreate _QS_ctrlCreateArray;
_QS_ctrl140 ctrlShow FALSE;
_QS_ctrl140 ctrlSetPosition [
	_QS_ctrl14_pos_x,
	_QS_ctrl14_pos_y,
	_QS_ctrl14_pos_w,
	_QS_ctrl14_pos_h
];
_QS_ctrl140_backgroundColor = [0.5,0.5,0.5,0.5];
_QS_ctrl140 ctrlSetBackgroundColor _QS_ctrl140_backgroundColor;
_QS_ctrl140 ctrlCommit 0;
_QS_ctrlCreateArray = ['RscProgress',12358];
_QS_ctrl14 = _display ctrlCreate _QS_ctrlCreateArray;
_QS_ctrl14 ctrlShow FALSE;
comment 'QS_ctrl14_pos_x = ((0.525 * safezoneW) + safezoneX);';
_QS_ctrl14_scale = 1;
_QS_ctrl_text14 = '';
_QS_ctrl_color14 = _QS_color_profile;
_QS_ctrl14_progress = 1;
_QS_ctrl14 ctrlSetPosition [
	_QS_ctrl14_pos_x,
	_QS_ctrl14_pos_y,
	_QS_ctrl14_pos_w,
	_QS_ctrl14_pos_h
];
_QS_ctrl14 ctrlSetText _QS_ctrl_text14;
_QS_ctrl14 ctrlSetTextColor _QS_ctrl_color14;
_QS_ctrl14 ctrlSetScale _QS_ctrl14_scale;
_QS_ctrl14 ctrlCommit 0;
_QS_ctrl14 progressSetPosition _QS_ctrl14_progress;

comment '****************************************************************';

_QS_ctrl4_scale = 0.5;
_QS_ctrl1_position_0 = ((ctrlPosition _QS_ctrl1) select 0) + (((ctrlPosition _QS_ctrl1) select 2) / 4);
_QS_ctrl1_position_1 = ((0.01 * safezoneH) + safezoneY) + (((ctrlPosition _QS_ctrl1) select 3) / 4);
_QS_ctrl5_scale = 0.5; 
_QS_ctrl2_position_0 = ((ctrlPosition _QS_ctrl2) select 0) + (((ctrlPosition _QS_ctrl2) select 2) / 4); 
_QS_ctrl2_position_1 = ((0.01 * safezoneH) + safezoneY) + (((ctrlPosition _QS_ctrl2) select 3) / 4);
_QS_ctrl6_scale = 0.5; 
_QS_ctrl3_position_0 = ((ctrlPosition _QS_ctrl3) select 0) + (((ctrlPosition _QS_ctrl3) select 2) / 4); 
_QS_ctrl3_position_1 = ((0.01 * safezoneH) + safezoneY) + (((ctrlPosition _QS_ctrl3) select 3) / 4);
_QS_ctrl7_position_0 = ((ctrlPosition _QS_ctrl1) select 0) + (((ctrlPosition _QS_ctrl1) select 2) / 1.35);
_QS_ctrl7_position_1 = ((0.01 * safezoneH) + safezoneY) + (((ctrlPosition _QS_ctrl1) select 3) / 1.175);
_QS_ctrl8_position_0 = ((ctrlPosition _QS_ctrl2) select 0) + (((ctrlPosition _QS_ctrl2) select 2) / 1.35);
_QS_ctrl8_position_1 = ((0.01 * safezoneH) + safezoneY) + (((ctrlPosition _QS_ctrl2) select 3) / 1.175);
_QS_ctrl9_position_0 = ((ctrlPosition _QS_ctrl3) select 0) + (((ctrlPosition _QS_ctrl3) select 2) / 1.35);
_QS_ctrl9_position_1 = ((0.01 * safezoneH) + safezoneY) + (((ctrlPosition _QS_ctrl3) select 3) / 1.175);
missionNamespace setVariable ['QS_missionStatus_shown',TRUE,FALSE];
_sides = [EAST,WEST,RESISTANCE,CIVILIAN,sideUnknown];
_sideColors = [
	[0.5,0,0,0.65],
	[0,0.3,0.6,0.65],
	[0,0.5,0,0.65],
	[0.4,0,0.5,0.65],
	[0.7,0.6,0,0.5]
];
_QS_ctrl0 ctrlSetBackgroundColor _QS_ctrl0_backgroundColor;
_QS_ctrl0 ctrlCommit 0;
_QS_ctrl01 ctrlSetBackgroundColor _QS_ctrl01_backgroundColor;
_QS_ctrl01 ctrlCommit 0;
_QS_ctrl1 ctrlSetText _QS_ctrl_text1;
_QS_ctrl1 ctrlSetTextColor _QS_ctrl_color1;
_QS_ctrl1 ctrlSetScale _QS_ctrl1_scale;
_QS_ctrl1 ctrlCommit 0;
_QS_ctrl2 ctrlSetText _QS_ctrl_text2;
_QS_ctrl2 ctrlSetTextColor _QS_ctrl_color2;
_QS_ctrl2 ctrlSetScale _QS_ctrl2_scale;
_QS_ctrl2 ctrlCommit 0;
_QS_ctrl3 ctrlSetText _QS_ctrl_text3;
_QS_ctrl3 ctrlSetTextColor _QS_ctrl_color3;
_QS_ctrl3 ctrlSetScale _QS_ctrl3_scale;
_QS_ctrl3 ctrlCommit 0;
_QS_ctrl4 ctrlSetText _QS_ctrl_text4;
_QS_ctrl4 ctrlSetTextColor _QS_ctrl_color4;
_QS_ctrl4 ctrlSetScale _QS_ctrl4_scale;
_QS_ctrl4 ctrlSetPosition [
	_QS_ctrl1_position_0,
	_QS_ctrl1_position_1,
	_QS_ctrl1_position_2,
	_QS_ctrl1_position_3
];
_QS_ctrl4 ctrlCommit 0;
_QS_ctrl5 ctrlSetText _QS_ctrl_text5;
_QS_ctrl5 ctrlSetTextColor _QS_ctrl_color5;
_QS_ctrl5 ctrlSetScale _QS_ctrl5_scale;
_QS_ctrl5 ctrlSetPosition [
	_QS_ctrl2_position_0,
	_QS_ctrl2_position_1,
	_QS_ctrl2_position_2,
	_QS_ctrl2_position_3
];
_QS_ctrl5 ctrlCommit 0;
_QS_ctrl6 ctrlSetText _QS_ctrl_text6;
_QS_ctrl6 ctrlSetTextColor _QS_ctrl_color6;
_QS_ctrl6 ctrlSetScale _QS_ctrl6_scale;
_QS_ctrl6 ctrlSetPosition [
	_QS_ctrl3_position_0,
	_QS_ctrl3_position_1,
	_QS_ctrl3_position_2,
	_QS_ctrl3_position_3
];
_QS_ctrl6 ctrlCommit 0;
_QS_ctrl7 ctrlSetText _QS_ctrl_text7;
_QS_ctrl7 ctrlSetTextColor _QS_ctrl_color7;
_QS_ctrl7 ctrlSetPosition [
	_QS_ctrl7_position_0,
	_QS_ctrl7_position_1,
	_QS_ctrl1_position_2,
	_QS_ctrl1_position_3
];
_QS_ctrl7 ctrlSetScale _QS_ctrl7_scale;
_QS_ctrl7 ctrlCommit 0;

_QS_ctrl8 ctrlSetText _QS_ctrl_text8;
_QS_ctrl8 ctrlSetTextColor _QS_ctrl_color8;
_QS_ctrl8 ctrlSetPosition [
	_QS_ctrl8_position_0,
	_QS_ctrl8_position_1,
	_QS_ctrl2_position_2,
	_QS_ctrl2_position_3
];
_QS_ctrl8 ctrlSetScale _QS_ctrl8_scale;
_QS_ctrl8 ctrlCommit 0;

_QS_ctrl9 ctrlSetText _QS_ctrl_text9;
_QS_ctrl9 ctrlSetTextColor _QS_ctrl_color9;
_QS_ctrl9 ctrlSetPosition [
	_QS_ctrl9_position_0,
	_QS_ctrl9_position_1,
	_QS_ctrl3_position_2,
	_QS_ctrl3_position_3
];
_QS_ctrl9 ctrlSetScale _QS_ctrl9_scale;
_QS_ctrl9 ctrlCommit 0;
_QS_ctrl10 ctrlSetPosition [
	(((ctrlPosition _QS_ctrl01) select 0) + ((ctrlPosition _QS_ctrl01) select 2)),
	_QS_ctrl10_position_1,
	_QS_ctrl10_position_2,
	_QS_ctrl10_position_3
];
_QS_ctrl10 ctrlSetScale _QS_ctrl10_scale;
if (ctrlShown _QS_ctrl0) then {
	_QS_ctrl_text10 = format ['Press [%1] to hide',_keyText];
} else {
	_QS_ctrl_text10 = format ['Press [%1] to show mission status',_keyText];
};
_QS_ctrl10 ctrlSetFont _QS_ctrl10_font;
_QS_ctrl10 ctrlSetText _QS_ctrl_text10;
_QS_ctrl10 ctrlSetTextColor [0.5,0.5,0.5,_QS_ctrl10_alpha];
_QS_ctrl10 ctrlCommit 0;

_QS_ctrl11 ctrlSetPosition [
	_QS_ctrl11_pos_x,
	_QS_ctrl11_pos_y,
	_QS_ctrl11_pos_w,
	_QS_ctrl11_pos_h
];

_QS_ctrl12 ctrlSetPosition [
	_QS_ctrl12_pos_x,
	_QS_ctrl12_pos_y,
	_QS_ctrl12_pos_w,
	_QS_ctrl12_pos_h
];
_QS_ctrl12 ctrlSetText _QS_ctrl_text12;
_QS_ctrl12 ctrlSetTextColor _QS_ctrl_color12;
_QS_ctrl12 ctrlSetScale _QS_ctrl12_scale;
_QS_ctrl12 ctrlCommit 0;
_QS_ctrl12 progressSetPosition ((round((missionNamespace getVariable ['QS_virtualSectors_scoreSides',[0,0,0,0,0]]) select 1)) / _scoreWin);

_QS_ctrl11 ctrlSetText _QS_ctrl_text11;
_QS_ctrl11 ctrlSetTextColor _QS_ctrl_color11;
_QS_ctrl11 ctrlSetScale _QS_ctrl11_scale;
_QS_ctrl11 ctrlCommit 0;
_QS_ctrl13 ctrlSetPosition [
	_QS_ctrl13_pos_x,
	_QS_ctrl13_pos_y,
	_QS_ctrl13_pos_w,
	_QS_ctrl13_pos_h
];
_QS_ctrl13 ctrlSetText _QS_ctrl_text13;
_QS_ctrl13 ctrlSetTextColor _QS_ctrl_color13;
_QS_ctrl13 ctrlSetScale _QS_ctrl13_scale;
_QS_ctrl13 ctrlCommit 0;

_QS_ctrl14 ctrlSetPosition [
	_QS_ctrl14_pos_x,
	_QS_ctrl14_pos_y,
	_QS_ctrl14_pos_w,
	_QS_ctrl14_pos_h
];
_QS_ctrl14 ctrlSetText _QS_ctrl_text14;
_QS_ctrl14 ctrlSetTextColor _QS_ctrl_color14;
_QS_ctrl14 ctrlSetScale _QS_ctrl14_scale;
_QS_ctrl14 ctrlCommit 0;
_QS_ctrl14 progressSetPosition ((round((missionNamespace getVariable ['QS_virtualSectors_scoreSides',[0,0,0,0,0]]) select 0)) / _scoreWin);

comment 'Mission timer';
comment 'Frame';
_QS_ctrlCreateArray = ['RscFrame',12370];
_QS_ctrl17 = _display ctrlCreate _QS_ctrlCreateArray;
_QS_ctrl17 ctrlShow FALSE;
_QS_ctrl17 ctrlSetPosition [
	((0.35 * safezoneW) + safezoneX),
	((0 * safezoneH) + safezoneY),
	0.10,
	0.13
];
_QS_ctrl17_backgroundColor = [0,0,0,0]; comment '[0,0,0,0.95];';
_QS_ctrl17 ctrlSetTextColor [0,0,0,0];
_QS_ctrl17 ctrlSetBackgroundColor _QS_ctrl17_backgroundColor;
_QS_ctrl17 ctrlCommit 0;
comment 'Background';
_QS_ctrlCreateArray = ['RscPicture',12371];
_QS_ctrl18 = _display ctrlCreate _QS_ctrlCreateArray;
_QS_ctrl18 ctrlShow FALSE;
_QS_ctrl18 ctrlSetPosition [
	((0.35 * safezoneW) + safezoneX),
	((0 * safezoneH) + safezoneY),
	0.10,
	0.13
];
_QS_ctrl18 ctrlSetText 'media\images\icons\gradient_ca.paa';
_QS_ctrl18_backgroundColor = [0,0,0,0.5];
_QS_ctrl18 ctrlSetTextColor _QS_ctrl18_backgroundColor;
_QS_ctrl18 ctrlSetBackgroundColor _QS_ctrl18_backgroundColor;
_QS_ctrl18 ctrlCommit 0;
comment 'Picture';
_QS_ctrlCreateArray = ['RscPictureKeepAspect',12372];
_QS_ctrl19 = _display ctrlCreate _QS_ctrlCreateArray;
_QS_ctrl19 ctrlShow FALSE;
_QS_ctrl19 ctrlSetPosition [
	((0.35 * safezoneW) + safezoneX),
	((0 * safezoneH) + safezoneY),
	0.10,
	0.13
];
private _QS_ctrl_text19 = 'media\images\icons\timer_ca.paa';
private _QS_ctrl_color19 = _QS_color_profile;
_QS_ctrl19 ctrlSetText _QS_ctrl_text19;
_QS_ctrl19 ctrlSetTextColor _QS_ctrl_color19;
_QS_ctrl19_scale = 1;
_QS_ctrl19 ctrlSetScale _QS_ctrl19_scale;
_QS_ctrl19 ctrlCommit 0;
comment 'Text';
_QS_ctrlCreateArray = ['RscStructuredText',12373];
private _QS_ctrl_color20 = [1,1,1,0.35];
private _QS_ctrl_text20 = parseText '';
_QS_ctrl20 = _display ctrlCreate _QS_ctrlCreateArray;
_QS_ctrl20 ctrlShow FALSE;
_QS_ctrl20 ctrlSetPosition [
	((0.3575 * safezoneW) + safezoneX),
	((0.0275 * safezoneH) + safezoneY),
	0.075,
	0.05
];
_QS_ctrl20 ctrlSetStructuredText _QS_ctrl_text20;
_QS_ctrl20 ctrlCommit 0;

_QS_ctrlCreateArray = ['RscFrame',12384];
_QS_ctrl21 = _display ctrlCreate _QS_ctrlCreateArray;
_QS_ctrl21 ctrlShow FALSE;
_QS_ctrl21 ctrlSetPosition [
	((0.309 * safezoneW) + safezoneX),
	((0 * safezoneH) + safezoneY),
	0.10,
	0.13
];
_QS_ctrl21_backgroundColor = [0,0,0,0]; comment '[0,0,0,0.95];';
_QS_ctrl21 ctrlSetTextColor [0,0,0,0];
_QS_ctrl21 ctrlSetBackgroundColor _QS_ctrl21_backgroundColor;
_QS_ctrl21 ctrlCommit 0;		

comment 'Background';
_QS_ctrlCreateArray = ['RscPicture',12385];
_QS_ctrl22 = _display ctrlCreate _QS_ctrlCreateArray;
_QS_ctrl22 ctrlShow FALSE;
_QS_ctrl22 ctrlSetPosition [
	((0.309 * safezoneW) + safezoneX),
	((0 * safezoneH) + safezoneY),
	0.10,
	0.13
];
_QS_ctrl22 ctrlSetText 'media\images\icons\gradient_ca.paa';
_QS_ctrl22_backgroundColor = [0,0,0,0.5];
_QS_ctrl22 ctrlSetTextColor _QS_ctrl22_backgroundColor;
_QS_ctrl22 ctrlSetBackgroundColor _QS_ctrl22_backgroundColor;
_QS_ctrl22 ctrlCommit 0;
comment 'Picture';
_QS_ctrlCreateArray = ['RscPictureKeepAspect',12386];
_QS_ctrl23 = _display ctrlCreate _QS_ctrlCreateArray;
_QS_ctrl23 ctrlShow FALSE;
_QS_ctrl23 ctrlSetPosition [
	((0.309 * safezoneW) + safezoneX),
	((0 * safezoneH) + safezoneY),
	0.10,
	0.13
];
private _QS_ctrl_text23 = 'a3\ui_f\data\igui\cfg\HoldActions\progress2\progress_24_ca.paa';
private _QS_ctrl_color23 = _QS_color_profile;
_QS_ctrl23 ctrlSetText _QS_ctrl_text23;
_QS_ctrl23 ctrlSetTextColor _QS_ctrl_color23;
_QS_ctrl23_scale = 1;
_QS_ctrl23 ctrlSetScale _QS_ctrl23_scale;
_QS_ctrl23 ctrlCommit 0;

comment 'Picture';
_QS_ctrlCreateArray = ['RscPictureKeepAspect',12387];
_QS_ctrl24 = _display ctrlCreate _QS_ctrlCreateArray;
_QS_ctrl24 ctrlShow FALSE;
_QS_ctrl24 ctrlSetPosition [ 
	((0.30845 * safezoneW) + safezoneX), 
	((0.0175 * safezoneH) + safezoneY), 
	0.075, 
	0.05 
];
private _QS_ctrl_text24 = '';
private _QS_ctrl_color24 = [0.8,0.6,0,1]; /*/_QS_color_profile;/*/
_QS_ctrl24 ctrlSetText _QS_ctrl_text24;
_QS_ctrl24 ctrlSetTextColor _QS_ctrl_color24;
_QS_ctrl24_scale = 1.333;
_QS_ctrl24 ctrlSetScale _QS_ctrl24_scale;
_QS_ctrl24 ctrlCommit 0;

/*/
_productVersionCtrl = _display ctrlCreate ['RscText',5678];
_productVersionCtrl ctrlShow FALSE;
_productVersionCtrl ctrlSetPosition [
	((0.02 * safezoneW) + safezoneX),
	((0.97 * safezoneH) + safezoneY),
	1,
	0.05
];  
_productVersionCtrl ctrlSetTextColor [1,1,1,0];
_productVersionCtrl ctrlSetFont 'TahomaB';
_productVersionCtrl ctrlSetText (missionNamespace getVariable ['QS_system_devBuild_text','Apex Framework (Beta)']);
_productVersionCtrl ctrlCommit 0;
/*/

private _virtualSectorsData = [];
private _progress1 = 0;
private _progress2 = 0;
private _isCAS = ((player getUnitTrait 'QS_trait_fighterPilot') || (player getUnitTrait 'uavhacker'));
if (_isCAS) then {
	if (!isNil {missionNamespace getVariable 'QS_virtualSectors_sectorObjects'}) then {
		if (!((missionNamespace getVariable 'QS_virtualSectors_sectorObjects') isEqualTo [])) then {
			{
				_array = _x;
				{
					_array2 = _x;
					{
						if (_x isEqualType objNull) then {
							_x hideObject TRUE;
						};
					} forEach _array2;
				} forEach _array;
			} forEach (missionNamespace getVariable 'QS_virtualSectors_sectorObjects');
		};
	};
};

private _exit = FALSE;
private _currentTaskStr = '';
private _currentTaskID = '';
private _currentTaskCustomData = ['','',''];
private _currentTaskTimerData = [FALSE,-1];
private _currentTaskProgressData = [FALSE,-1];

_taskTypesConfig = configFile >> 'CfgTaskTypes';
private _currentTaskType = '';
private _currentTaskTooltip = '';
private _currentTaskDescription = '';
private _currentTaskIconPathDefault = 'a3\ui_f\data\igui\cfg\simpleTasks\types\default_ca.paa';
private _currentTaskIconPath = _currentTaskIconPathDefault;

private _currentTask = currentTask player;
private _currentTaskTimer = FALSE;
private _currentTaskTimeout = -1;
private _currentTaskTime = -1;
private _currentTaskTimerTextFormat = parseText '';
private _currentTaskData = [];

private _currentTaskProgress = FALSE;
private _currentTaskRate = 0;
private _currentTaskProgression = round (_currentTaskRate * 24);

private _client_uiCtrl_earplugs = (findDisplay 46) ctrlCreate ['RscPictureKeepAspect',12390];
uiNamespace setVariable ['QS_client_uiCtrl_earplugs',_client_uiCtrl_earplugs];
_client_uiCtrl_earplugs ctrlShow FALSE;
_client_uiCtrl_earplugs ctrlSetText 'media\images\icons\earplugs_ca.paa';
_client_uiCtrl_earplugs ctrlSetPosition [
	((0.95 * safezoneW) + safezoneX),
	((0.39 * safezoneH) + safezoneY),
	0.075,
	0.075
];
_client_uiCtrl_earplugs ctrlSetTextColor [0.8,0.8,0.8,1];/*/_QS_color_profile;[1,1,1,0.5];/*/
_client_uiCtrl_earplugs ctrlCommit 0;
_client_uiCtrl_earplugs = nil;
{
	_x ctrlCommit 0;
} forEach [
	_QS_ctrl0,
	_QS_ctrl01,
	_QS_ctrl1,
	_QS_ctrl2,
	_QS_ctrl3,
	_QS_ctrl4,
	_QS_ctrl5,
	_QS_ctrl6,
	_QS_ctrl7,
	_QS_ctrl8,
	_QS_ctrl9,
	_QS_ctrl11,
	_QS_ctrl12,
	_QS_ctrl13,
	_QS_ctrl14,
	_QS_ctrl120,
	_QS_ctrl140,
	_QS_ctrl17,
	_QS_ctrl18,
	_QS_ctrl19,
	_QS_ctrl20,
	_QS_ctrl21,
	_QS_ctrl22,
	_QS_ctrl23,
	_QS_ctrl24
];

_fn_inString = missionNamespace getVariable 'QS_fnc_inString';
_fn_secondsToString = missionNamespace getVariable 'BIS_fnc_secondsToString';

private _isStreamFriendly = isStreamFriendlyUIEnabled;
//_productVersionCtrl ctrlShow TRUE;

for '_x' from 0 to 1 step 0 do {
	_isStreamFriendly = isStreamFriendlyUIEnabled;
	_currentTask = currentTask player;
	_currentTaskStr = str _currentTask;
	if ((missionNamespace getVariable ['QS_mission_aoType','']) isEqualTo 'SC') then {
		uiSleep 0.05;
		_virtualSectorsData = missionNamespace getVariable ['QS_virtualSectors_data_public',[]];
		if (!(_virtualSectorsData isEqualTo [])) then {
			{
				_rate = _x select 26;
				_rateAdjusted = (round(_rate * 24));
				_isBeingInterrupted = _x select 27;
				if (_forEachIndex isEqualTo 0) then {
					if ([((_x select 22) select 0),_currentTaskStr,FALSE] call _fn_inString) then {
						_QS_ctrl4 ctrlSetTextColor [0.8,0.6,0,1];
					} else {
						_QS_ctrl4 ctrlSetTextColor _QS_ctrl_color4;
					};
					_QS_ctrl_text1 = format ['a3\ui_f\data\igui\cfg\HoldActions\progress2\progress_%1_ca.paa',_rateAdjusted];
					_QS_ctrl_color1 = (_sideColors select (_sides find ((_x select 10) select 0)));
					if (_side in (_x select 10)) then {
						if (!(_QS_ctrl_text7 isEqualTo _QS_icon_defend)) then {
							_QS_ctrl_text7 = _QS_icon_defend;
						};
						if (!((_x select 13) isEqualTo (_x select 14))) then {
							if ((_x select 13) > (_x select 14)) then {
								_QS_ctrl_color7 set [0,0];
								_QS_ctrl_color7 set [1,1];
								_QS_ctrl_color7 set [2,0];
							} else {
								_QS_ctrl_color7 set [0,1];
								_QS_ctrl_color7 set [1,0];
								_QS_ctrl_color7 set [2,0];
							};
							if (_QS_ctrl7_fadeDir isEqualTo -1) then {
								_QS_ctrl_color7 set [3,((_QS_ctrl_color7 select 3) - 0.05)];
								if ((_QS_ctrl_color7 select 3) <= 0.5) then {
									_QS_ctrl7_fadeDir = 1;
								};
							} else {
								_QS_ctrl_color7 set [3,((_QS_ctrl_color7 select 3) + 0.05)];
								if ((_QS_ctrl_color7 select 3) >= 0.8) then {
									_QS_ctrl7_fadeDir = -1;
								};
							};
						} else {
							if (_isBeingInterrupted) then {
								_QS_ctrl_color7 set [0,0.7];
								_QS_ctrl_color7 set [1,0.6];
								_QS_ctrl_color7 set [2,0];
								if (!((_QS_ctrl_color7 select 3) isEqualTo 0.75)) then {
									_QS_ctrl_color7 set [3,0.75];
								};
							} else {
								_QS_ctrl_color7 set [0,1];
								_QS_ctrl_color7 set [1,1];
								_QS_ctrl_color7 set [2,1];
								if (!((_QS_ctrl_color7 select 3) isEqualTo 0.75)) then {
									_QS_ctrl_color7 set [3,0.75];
								};
							};
						};
					} else {
						if (!(_QS_ctrl_text7 isEqualTo _QS_icon_attack)) then {
							_QS_ctrl_text7 = _QS_icon_attack;
						};
						if (!((_x select 13) isEqualTo (_x select 14))) then {
							if ((_x select 13) < (_x select 14)) then {
								_QS_ctrl_color7 set [0,0];
								_QS_ctrl_color7 set [1,1];
								_QS_ctrl_color7 set [2,0];
							} else {
								_QS_ctrl_color7 set [0,1];
								_QS_ctrl_color7 set [1,0];
								_QS_ctrl_color7 set [2,0];
							};
							if (_QS_ctrl7_fadeDir isEqualTo -1) then {
								_QS_ctrl_color7 set [3,((_QS_ctrl_color7 select 3) - 0.05)];
								if ((_QS_ctrl_color7 select 3) <= 0.5) then {
									_QS_ctrl7_fadeDir = 1;
								};
							} else {
								_QS_ctrl_color7 set [3,((_QS_ctrl_color7 select 3) + 0.05)];
								if ((_QS_ctrl_color7 select 3) >= 0.8) then {
									_QS_ctrl7_fadeDir = -1;
								};
							};
						} else {
							if (_isBeingInterrupted) then {
								_QS_ctrl_color7 set [0,0.7];
								_QS_ctrl_color7 set [1,0.6];
								_QS_ctrl_color7 set [2,0];
								if (!((_QS_ctrl_color7 select 3) isEqualTo 0.75)) then {
									_QS_ctrl_color7 set [3,0.75];
								};
							} else {
								_QS_ctrl_color7 set [0,1];
								_QS_ctrl_color7 set [1,1];
								_QS_ctrl_color7 set [2,1];
								if (!((_QS_ctrl_color7 select 3) isEqualTo 0.75)) then {
									_QS_ctrl_color7 set [3,0.75];
								};
							};
						};
					};
				};
				if (_forEachIndex isEqualTo 1) then {
					if ([((_x select 22) select 0),_currentTaskStr,FALSE] call _fn_inString) then {
						_QS_ctrl5 ctrlSetTextColor [0.8,0.6,0,1];
					} else {
						_QS_ctrl5 ctrlSetTextColor _QS_ctrl_color5;
					};
					_QS_ctrl_text2 = format ['a3\ui_f\data\igui\cfg\HoldActions\progress2\progress_%1_ca.paa',_rateAdjusted];
					_QS_ctrl_color2 = (_sideColors select (_sides find ((_x select 10) select 0)));
					if (_side in (_x select 10)) then {
						if (!(_QS_ctrl_text8 isEqualTo _QS_icon_defend)) then {
							_QS_ctrl_text8 = _QS_icon_defend;
						};
						if (!((_x select 13) isEqualTo (_x select 14))) then {
							if ((_x select 13) > (_x select 14)) then {
								_QS_ctrl_color8 set [0,0];
								_QS_ctrl_color8 set [1,1];
								_QS_ctrl_color8 set [2,0];
							} else {
								_QS_ctrl_color8 set [0,1];
								_QS_ctrl_color8 set [1,0];
								_QS_ctrl_color8 set [2,0];
							};
							if (_QS_ctrl8_fadeDir isEqualTo -1) then {
								_QS_ctrl_color8 set [3,((_QS_ctrl_color8 select 3) - 0.05)];
								if ((_QS_ctrl_color8 select 3) <= 0.5) then {
									_QS_ctrl8_fadeDir = 1;
								};
							} else {
								_QS_ctrl_color8 set [3,((_QS_ctrl_color8 select 3) + 0.05)];
								if ((_QS_ctrl_color8 select 3) >= 0.8) then {
									_QS_ctrl8_fadeDir = -1;
								};
							};
						} else {
							if (_isBeingInterrupted) then {
								_QS_ctrl_color8 set [0,0.7];
								_QS_ctrl_color8 set [1,0.6];
								_QS_ctrl_color8 set [2,0];
								if (!((_QS_ctrl_color8 select 3) isEqualTo 0.75)) then {
									_QS_ctrl_color8 set [3,0.75];
								};
							} else {
								_QS_ctrl_color8 set [0,1];
								_QS_ctrl_color8 set [1,1];
								_QS_ctrl_color8 set [2,1];
								if (!((_QS_ctrl_color8 select 3) isEqualTo 0.75)) then {
									_QS_ctrl_color8 set [3,0.75];
								};
							};
						};
					} else {
						if (!(_QS_ctrl_text8 isEqualTo _QS_icon_attack)) then {
							_QS_ctrl_text8 = _QS_icon_attack;
						};
						if (!((_x select 13) isEqualTo (_x select 14))) then {
							if ((_x select 13) < (_x select 14)) then {
								_QS_ctrl_color8 set [0,0];
								_QS_ctrl_color8 set [1,1];
								_QS_ctrl_color8 set [2,0];
							} else {
								_QS_ctrl_color8 set [0,1];
								_QS_ctrl_color8 set [1,0];
								_QS_ctrl_color8 set [2,0];
							};
							if (_QS_ctrl8_fadeDir isEqualTo -1) then {
								_QS_ctrl_color8 set [3,((_QS_ctrl_color8 select 3) - 0.05)];
								if ((_QS_ctrl_color8 select 3) <= 0.5) then {
									_QS_ctrl8_fadeDir = 1;
								};
							} else {
								_QS_ctrl_color8 set [3,((_QS_ctrl_color8 select 3) + 0.05)];
								if ((_QS_ctrl_color8 select 3) >= 0.8) then {
									_QS_ctrl8_fadeDir = -1;
								};
							};
						} else {
							if (_isBeingInterrupted) then {
								_QS_ctrl_color8 set [0,0.7];
								_QS_ctrl_color8 set [1,0.6];
								_QS_ctrl_color8 set [2,0];
								if (!((_QS_ctrl_color8 select 3) isEqualTo 0.75)) then {
									_QS_ctrl_color8 set [3,0.75];
								};
							} else {
								_QS_ctrl_color8 set [0,1];
								_QS_ctrl_color8 set [1,1];
								_QS_ctrl_color8 set [2,1];
								if (!((_QS_ctrl_color8 select 3) isEqualTo 0.75)) then {
									_QS_ctrl_color8 set [3,0.75];
								};
							};
						};
					};
				};
				if (_forEachIndex isEqualTo 2) then {
					if ([((_x select 22) select 0),_currentTaskStr,FALSE] call _fn_inString) then {
						_QS_ctrl6 ctrlSetTextColor [0.8,0.6,0,1];
					} else {
						_QS_ctrl6 ctrlSetTextColor _QS_ctrl_color6;
					};
					_QS_ctrl_text3 = format ['a3\ui_f\data\igui\cfg\HoldActions\progress2\progress_%1_ca.paa',_rateAdjusted];
					_QS_ctrl_color3 = (_sideColors select (_sides find ((_x select 10) select 0)));
					if (_side in (_x select 10)) then {
						if (!(_QS_ctrl_text9 isEqualTo _QS_icon_defend)) then {
							_QS_ctrl_text9 = _QS_icon_defend;
						};
						if (!((_x select 13) isEqualTo (_x select 14))) then {
							if ((_x select 13) > (_x select 14)) then {
								_QS_ctrl_color9 set [0,0];
								_QS_ctrl_color9 set [1,1];
								_QS_ctrl_color9 set [2,0];
							} else {
								_QS_ctrl_color9 set [0,1];
								_QS_ctrl_color9 set [1,0];
								_QS_ctrl_color9 set [2,0];
							};
							if (_QS_ctrl9_fadeDir isEqualTo -1) then {
								_QS_ctrl_color9 set [3,((_QS_ctrl_color9 select 3) - 0.05)];
								if ((_QS_ctrl_color9 select 3) <= 0.5) then {
									_QS_ctrl9_fadeDir = 1;
								};
							} else {
								_QS_ctrl_color9 set [3,((_QS_ctrl_color9 select 3) + 0.05)];
								if ((_QS_ctrl_color9 select 3) >= 0.8) then {
									_QS_ctrl9_fadeDir = -1;
								};
							};
						} else {
							if (_isBeingInterrupted) then {
								_QS_ctrl_color9 set [0,0.7];
								_QS_ctrl_color9 set [1,0.6];
								_QS_ctrl_color9 set [2,0];
								if (!((_QS_ctrl_color9 select 3) isEqualTo 0.75)) then {
									_QS_ctrl_color9 set [3,0.75];
								};
							} else {
								_QS_ctrl_color9 set [0,1];
								_QS_ctrl_color9 set [1,1];
								_QS_ctrl_color9 set [2,1];
								if (!((_QS_ctrl_color9 select 3) isEqualTo 0.75)) then {
									_QS_ctrl_color9 set [3,0.75];
								};
							};
						};
					} else {
						if (!(_QS_ctrl_text9 isEqualTo _QS_icon_attack)) then {
							_QS_ctrl_text9 = _QS_icon_attack;
						};
						if (!((_x select 13) isEqualTo (_x select 14))) then {
							if ((_x select 13) < (_x select 14)) then {
								_QS_ctrl_color9 set [0,0];
								_QS_ctrl_color9 set [1,1];
								_QS_ctrl_color9 set [2,0];
							} else {
								_QS_ctrl_color9 set [0,1];
								_QS_ctrl_color9 set [1,0];
								_QS_ctrl_color9 set [2,0];
							};
							if (_QS_ctrl9_fadeDir isEqualTo -1) then {
								_QS_ctrl_color9 set [3,((_QS_ctrl_color9 select 3) - 0.05)];
								if ((_QS_ctrl_color9 select 3) <= 0.5) then {
									_QS_ctrl9_fadeDir = 1;
								};
							} else {
								_QS_ctrl_color9 set [3,((_QS_ctrl_color9 select 3) + 0.05)];
								if ((_QS_ctrl_color9 select 3) >= 0.8) then {
									_QS_ctrl9_fadeDir = -1;
								};
							};
						} else {
							if (_isBeingInterrupted) then {
								_QS_ctrl_color9 set [0,0.7];
								_QS_ctrl_color9 set [1,0.6];
								_QS_ctrl_color9 set [2,0];
								if (!((_QS_ctrl_color9 select 3) isEqualTo 0.75)) then {
									_QS_ctrl_color9 set [3,0.75];
								};
							} else {
								_QS_ctrl_color9 set [0,1];
								_QS_ctrl_color9 set [1,1];
								_QS_ctrl_color9 set [2,1];
								if (!((_QS_ctrl_color9 select 3) isEqualTo 0.75)) then {
									_QS_ctrl_color9 set [3,0.75];
								};
							};
						};
					};
				};
			} forEach _virtualSectorsData;
			if (_QS_sectorHintShown) then {
				if (!(_isStreamFriendly)) then {
					[((_virtualSectorsData select 0) select 8),((_virtualSectorsData select 0) select 9)] call _fn_sectorHint;
				};
			};
		};
		if ((!(missionNamespace getVariable 'QS_missionStatus_shown')) || {(!(missionNamespace getVariable 'QS_missionStatus_SC_canShow'))}) then {
			{
				if (ctrlShown _x) then {
					_x ctrlShow FALSE;
				};
			} forEach [
				_QS_ctrl0,
				_QS_ctrl01,
				_QS_ctrl1,
				_QS_ctrl2,
				_QS_ctrl3,
				_QS_ctrl4,
				_QS_ctrl5,
				_QS_ctrl6,
				_QS_ctrl7,
				_QS_ctrl8,
				_QS_ctrl9,
				_QS_ctrl11,
				_QS_ctrl12,
				_QS_ctrl13,
				_QS_ctrl14,
				_QS_ctrl120,
				_QS_ctrl140
			];
			if (!(_isCAS)) then {
				if (!isNil {missionNamespace getVariable 'QS_virtualSectors_data_public'}) then {
					if (!((missionNamespace getVariable 'QS_virtualSectors_data_public') isEqualTo [])) then {
						{
							_array = _x select 18;
							{
								_array2 = _x;
								{
									if (!(isObjectHidden _x)) then {
										_x hideObject TRUE;
									};
								} count _array2;
							} forEach _array;
						} forEach (missionNamespace getVariable 'QS_virtualSectors_data_public');
					};
				};
			};
		} else {
			{
				if (!(ctrlShown _x)) then {
					_x ctrlShow TRUE;
				};
			} forEach [
				_QS_ctrl0,
				_QS_ctrl01,
				_QS_ctrl1,
				_QS_ctrl2,
				_QS_ctrl3,
				_QS_ctrl4,
				_QS_ctrl5,
				_QS_ctrl6,
				_QS_ctrl7,
				_QS_ctrl8,
				_QS_ctrl9,
				_QS_ctrl11,
				_QS_ctrl12,
				_QS_ctrl13,
				_QS_ctrl14,
				_QS_ctrl120,
				_QS_ctrl140
			];
			if (!(_isCAS)) then {
				if (!isNil {missionNamespace getVariable 'QS_virtualSectors_data_public'}) then {
					if (!((missionNamespace getVariable 'QS_virtualSectors_data_public') isEqualTo [])) then {
						{
							_array = _x select 18;
							{
								_array2 = _x;
								{
									if (isObjectHidden _x) then {
										_x hideObject FALSE;
									};
								} count _array2;
							} forEach _array;
						} forEach (missionNamespace getVariable 'QS_virtualSectors_data_public');
					};
				};
			};
		};
		_key = actionKeysNames 'NavigateMenu';
		if (_key isEqualTo '') then {
			if (!(_keyText isEqualTo 'NavigateMenu')) then {
				_keyText = 'NavigateMenu';
			};
		} else {
			_keyText = _key select [1,((count _key) - 2)];
		};
		if (ctrlShown _QS_ctrl0) then {
			_QS_ctrl_text10 = format ['Press [%1] to hide',_keyText];
		} else {
			_QS_ctrl_text10 = format ['Press [%1] to show mission status',_keyText];
		};
		_QS_ctrl01 ctrlSetTextColor _QS_ctrl01_backgroundColor;
		{
			(_x select 0) ctrlSetText (_x select 1);
			(_x select 0) ctrlSetTextColor (_x select 2);
		} forEach [
			[_QS_ctrl1,_QS_ctrl_text1,_QS_ctrl_color1],
			[_QS_ctrl2,_QS_ctrl_text2,_QS_ctrl_color2],
			[_QS_ctrl3,_QS_ctrl_text3,_QS_ctrl_color3],
			[_QS_ctrl7,_QS_ctrl_text7,_QS_ctrl_color7],
			[_QS_ctrl8,_QS_ctrl_text8,_QS_ctrl_color8],
			[_QS_ctrl9,_QS_ctrl_text9,_QS_ctrl_color9],
			[_QS_ctrl10,_QS_ctrl_text10,_QS_ctrl_color10]
		];
		{
			_x ctrlCommit 0;
		} forEach [
			_QS_ctrl1,
			_QS_ctrl2,
			_QS_ctrl3,
			_QS_ctrl7,
			_QS_ctrl8,
			_QS_ctrl9,
			_QS_ctrl10
		];
		if (ctrlShown _QS_ctrl12) then {
			_progress1 = ((round((missionNamespace getVariable ['QS_virtualSectors_scoreSides',[0,0,0,0,0]]) select 1)) / _scoreWin);
			if (!((progressPosition _QS_ctrl12) isEqualTo _progress1)) then {
				_QS_ctrl12 progressSetPosition _progress1;
			};
		};
		if (ctrlShown _QS_ctrl14) then {
			_progress2 = ((round((missionNamespace getVariable ['QS_virtualSectors_scoreSides',[0,0,0,0,0]]) select 0)) / _scoreWin);
			if (!((progressPosition _QS_ctrl14) isEqualTo _progress2)) then {
				_QS_ctrl14 progressSetPosition _progress2;
			};
		};
	} else {
		{
			if (ctrlShown _x) then {
				_x ctrlShow FALSE;
			};
		} forEach [
			_QS_ctrl0,
			_QS_ctrl01,
			_QS_ctrl1,
			_QS_ctrl2,
			_QS_ctrl3,
			_QS_ctrl4,
			_QS_ctrl5,
			_QS_ctrl6,
			_QS_ctrl7,
			_QS_ctrl8,
			_QS_ctrl9,
			_QS_ctrl11,
			_QS_ctrl12,
			_QS_ctrl13,
			_QS_ctrl14,
			_QS_ctrl120,
			_QS_ctrl140
		];
		uiSleep 0.15;
	};
	if (!isNull _currentTask) then {
		_currentTaskTimer = FALSE;
		_currentTaskProgress = FALSE;
		if (!((missionNamespace getVariable 'QS_mission_tasks') isEqualTo [])) then {
			_exit = FALSE;
			{
				_currentTaskData = _x;
				if (_currentTaskData isEqualType []) then {
					_currentTaskID = _currentTaskData select 0;
					_currentTaskCustomData = _currentTaskData select 1; 
					_currentTaskTimerData = _currentTaskData select 2;
					_currentTaskProgressData = _currentTaskData select 3;
					if ([_currentTaskID,_currentTaskStr,FALSE] call _fn_inString) then {
						_exit = TRUE;
						_currentTaskType = _currentTaskCustomData select 0; 
						_currentTaskTooltip = _currentTaskCustomData select 1;
						_currentTaskDescription = _currentTaskCustomData select 2;
						_currentTaskTimer = _currentTaskTimerData select 0; 
						_currentTaskTimeout = _currentTaskTimerData select 1; 
						_currentTaskProgress = _currentTaskProgressData select 0; 
						_currentTaskRate = _currentTaskProgressData select 1; 
						if (_currentTaskTimer) then {
							_currentTaskTimeout = _currentTaskTimeout max 0;
						};
						if (_currentTaskProgress) then {
							_currentTaskRate = _currentTaskRate max 0;
						};
						if (!((ctrlText _QS_ctrl24) isEqualTo _currentTaskIconPath)) then {
							if (!isNil '_currentTaskType') then {
								if (_currentTaskType isEqualTo '') then {
									_currentTaskIconPath = _currentTaskIconPathDefault;
								} else {
									_currentTaskIconPath = getText (_taskTypesConfig >> _currentTaskType >> 'icon');
								};
							} else {
								_currentTaskIconPath = _currentTaskIconPathDefault;
							};
						};
					};
				};
				if (_exit) exitWith {};
			} forEach (missionNamespace getVariable 'QS_mission_tasks');
		};
		if ((!(_isStreamFriendly)) && (missionNamespace getVariable ['QS_missionStatus_shown',FALSE])) then {
			if (_currentTaskTimer) then {
				comment 'Show timer';
				_currentTaskTime = _currentTaskTimeout - serverTime;
				if (_currentTaskTime >= 60) then {
					_currentTaskTimerTextFormat = parseText (format ['<t shadow="2">%1</t>',([_currentTaskTime,'MM:SS'] call _fn_secondsToString)]);
				} else {
					if (_currentTaskTime >= 20) then {
						_currentTaskTimerTextFormat = parseText (format ['<t shadow="2">%1</t>',([_currentTaskTime,'MM:SS'] call _fn_secondsToString)]);
					} else {
						if (_currentTaskTime > 0) then {
							_currentTaskTimerTextFormat = parseText (format ['<t color="#ff0000" shadow="2">%1</t>',([_currentTaskTime,'MM:SS'] call _fn_secondsToString)]);
						} else {
							_currentTaskTimerTextFormat = parseText (format ['<t color="#ff0000" shadow="2">%1</t>',([(0 - 0),'MM:SS'] call _fn_secondsToString)]);
						};
					};
				};
				_QS_ctrl20 ctrlSetStructuredText _currentTaskTimerTextFormat;
				{
					if (!(ctrlShown _x)) then {
						_x ctrlShow TRUE;
					};
				} forEach [
					_QS_ctrl17,
					_QS_ctrl18,
					_QS_ctrl19,
					_QS_ctrl20
				];
			} else {
				comment 'Hide timer';
				{
					if (ctrlShown _x) then {
						_x ctrlShow FALSE;
					};
				} forEach [
					_QS_ctrl17,
					_QS_ctrl18,
					_QS_ctrl19,
					_QS_ctrl20
				];
			};
			if (_currentTaskProgress) then {
				comment 'Show progress';
				_currentTaskProgression = round (_currentTaskRate * 24);
				_QS_ctrl_text23 = format ['a3\ui_f\data\igui\cfg\HoldActions\progress2\progress_%1_ca.paa',_currentTaskProgression];
				if (!((ctrlText _QS_ctrl23) isEqualTo _QS_ctrl_text23)) then {
					_QS_ctrl23 ctrlSetText _QS_ctrl_text23;
				};
				if (!((ctrlText _QS_ctrl24) isEqualTo _currentTaskIconPath)) then {
					_QS_ctrl24 ctrlSetText _currentTaskIconPath;
				};
				{
					if (!(ctrlShown _x)) then {
						_x ctrlShow TRUE;
					};
				} forEach [
					_QS_ctrl21,
					_QS_ctrl22,
					_QS_ctrl23,
					_QS_ctrl24
				];
			} else {
				comment 'Hide progress';
				{
					if (ctrlShown _x) then {
						_x ctrlShow FALSE;
					};
				} forEach [
					_QS_ctrl21,
					_QS_ctrl22,
					_QS_ctrl23,
					_QS_ctrl24
				];
			};
		} else {
			comment 'Hide all';
			{
				if (ctrlShown _x) then {
					_x ctrlShow FALSE;
				};
			} forEach [
				_QS_ctrl17,
				_QS_ctrl18,
				_QS_ctrl19,
				_QS_ctrl20,
				_QS_ctrl21,
				_QS_ctrl22,
				_QS_ctrl23,
				_QS_ctrl24
			];
		};
	} else {
		{
			if (ctrlShown _x) then {
				_x ctrlShow FALSE;
			};
		} forEach [
			_QS_ctrl17,
			_QS_ctrl18,
			_QS_ctrl19,
			_QS_ctrl20,
			_QS_ctrl21,
			_QS_ctrl22,
			_QS_ctrl23,
			_QS_ctrl24
		];
	};
};