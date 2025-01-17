/*/
File: fn_clientEarplugs.sqf
Author:
	
	Quiksilver
	
Last Modified:

	23/05/2023 A3 2.12 by Quiksilver

Description:

	Client Earplugs Toggle
__________________________________________________________/*/

if (diag_tickTime < (uiNamespace getVariable ['QS_earplugs_cooldown',-1])) exitWith {FALSE};
uiNamespace setVariable ['QS_earplugs_cooldown',diag_tickTime + 1];
playSoundUI ['ClickSoft',1,3,FALSE];
getAudioOptionVolumes params ['_effects','','','','','_earplugs'];
_earplugs = parseNumber ((_effects * _mapFactor) toFixed 2);
if ((parseNumber (soundVolume toFixed 2)) isEqualTo _earplugs) then {
} else {
	if (!(isStreamFriendlyUIEnabled)) then {
		(uiNamespace getVariable ['QS_client_uiCtrl_earplugs',controlNull]) ctrlShow TRUE;
	};
	1 fadeSound _earplugs;
};
TRUE;