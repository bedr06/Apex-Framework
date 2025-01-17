/*/
File: fn_dynamicTasks.sqf
Author: 

	Quiksilver

Last Modified:

	01/05/2023 A3 1.80 by Quiksilver

Description:

	Dynamic Tasks	
____________________________________________________________________________/*/

params ['_case','_type','_params','_isRx'];
private _array = [];
if (_case isEqualTo 1) then {
	if (_type isEqualTo 'DESTROY') then {
		_entity = _params # 0;
		_taskAuthor = _params # 1;
		_taskAuthorClass = _params # 2;
		_taskID = (format ['QS_DYNTASK_%1_%2',_type,(round (random 10000))]);
		private _description = (format [localize 'STR_QS_Task_118',(getText (configFile >> 'CfgVehicles' >> (typeOf _entity) >> 'displayName'))]);
		if (_isRx) then {
			_description = (format [localize 'STR_QS_Task_120',_description,_taskAuthor,_taskAuthorClass]);
		};
		_array = [
			_taskID,
			'ADD',
			_type,
			[
				[	/*/CREATED/*/
					[_entity],
					{
						params ['_entity'];
						(alive _entity)
					},
					[
						_taskID,
						TRUE,
						[
							_description,
							localize 'STR_QS_Task_119',
							localize 'STR_QS_Task_119'
						],
						[_entity,TRUE],
						'CREATED',
						0,
						TRUE,
						TRUE,
						'destroy',
						FALSE
					]
				],
				[	/*/SUCCESS/*/
					[_entity],
					{
						params ['_entity'];
						(!alive _entity)
					}
				],
				[	/*/FAILED/*/
					[_entity],
					{
						FALSE
					}
				],
				[	/*/CANCEL/*/
					_params,
					{
						FALSE
					}
				]
			],
			_params
		];
		(missionNamespace getVariable 'QS_module_dynamicTasks_add') pushBack _array;
	};
	if (_type isEqualTo 'MEDEVAC') then {
		_entity = _params # 0;
		_entityName = _params # 1;
		_taskID = (format ['QS_DYNTASK_%1_%2',_type,(round (random 10000))]);
		(missionNamespace getVariable ['QS_dynTask_medevac_array',[]]) pushBack _entity;
		[_entityName,{50 cutText [(format [localize 'STR_QS_Text_207',_this]),'PLAIN DOWN',0.5];}] remoteExec ['call',(allPlayers select {(_x getUnitTrait 'QS_trait_pilot')}),FALSE];
		private _description = (format [localize 'STR_QS_Text_465',_entityName]);
		_array = [
			_taskID,
			'ADD',
			_type,
			[
				[	/*/CREATED/*/
					[_entity],
					{
						params ['_entity'];
						((alive _entity) && ((lifeState _entity) isEqualTo 'INCAPACITATED'))
					},
					[
						_taskID,
						TRUE,
						[
							_description,
							'Medevac',
							'Medevac'
						],
						[_entity,TRUE],
						'CREATED',
						0,
						TRUE,
						TRUE,
						'heal',
						FALSE
					]
				],
				[	/*/SUCCESS/*/
					[_entity,(markerPos 'QS_marker_medevac_hq')],
					{
						params ['_entity','_medevacBase'];
						private _c = FALSE;
						if (alive _entity) then {
							if ((lifeState _entity) isNotEqualTo 'INCAPACITATED') then {
								if ((_entity distance2D _medevacBase) < 50) then {
									if (isNull (objectParent _entity)) then {
										if (isNull (attachedTo _entity)) then {
											_c = TRUE;
										};
									};
								};
							};
						};
						_c;
					}
				],
				[	/*/FAILED/*/
					[_entity],
					{
						params ['_entity'];
						(!alive _entity)
					}
				],
				[	/*/CANCEL/*/
					[_entity],
					{
						FALSE
					}
				]
			],
			_params
		];
		(missionNamespace getVariable 'QS_module_dynamicTasks_add') pushBack _array;
	};
	if (_type isEqualTo 'PRISONER') then {
		_entity = _params # 0;
		_entity setTaskMarkerOffset [0,-10,1];
		_taskID = (format ['QS_DYNTASK_%1_%2',_type,(round (random 10000))]);
		private _description = localize 'STR_QS_Task_125';
		_array = [
			_taskID,
			'ADD',
			_type,
			[
				[	/*/CREATED/*/
					[_entity],
					{
						params ['_entity'];
						(alive _entity)
					},
					[
						_taskID,
						TRUE,
						[
							_description,
							localize 'STR_QS_Task_126',
							localize 'STR_QS_Task_126'
						],
						[_entity,TRUE],
						'CREATED',
						0,
						TRUE,
						TRUE,
						'exit',
						FALSE
					]
				],
				[	/*/SUCCESS/*/
					[_entity,(markerPos 'QS_marker_gitmo')],
					{
						params ['_entity','_prisonBase'];
						private _c = FALSE;
						if (alive _entity) then {
							if ((_entity distance2D _prisonBase) < 30) then {
								if (isNull (objectParent _entity)) then {
									if (isNull (attachedTo _entity)) then {
										_c = TRUE;
									};
								};
							};
						};
						_c;
					}
				],
				[	/*/FAILED/*/
					[_entity],
					{
						params ['_entity'];
						(!alive _entity)
					}
				],
				[	/*/CANCEL/*/
					[_entity],
					{
						FALSE
					}
				]
			],
			_params
		];
		(missionNamespace getVariable 'QS_module_dynamicTasks_add') pushBack _array;
	};
	if (_type isEqualTo 'EVAC_PILOT') then {
		_entity = _params # 0;
		_entityName = _params # 1;
		_taskID = (format ['QS_DYNTASK_%1_%2',_type,(round (random 10000))]);
		private _description = (format [localize 'STR_QS_Task_127',_entityName]);
		_array = [
			_taskID,
			'ADD',
			_type,
			[
				[	/*/CREATED/*/
					[_entity],
					{
						params ['_entity'];
						(alive _entity)
					},
					[
						_taskID,
						TRUE,
						[
							_description,
							localize 'STR_QS_Task_128',
							localize 'STR_QS_Task_128'
						],
						[_entity,TRUE],
						'CREATED',
						0,
						TRUE,
						TRUE,
						'navigate',
						FALSE
					]
				],
				[	/*/SUCCESS/*/
					[_entity,(markerPos 'QS_marker_base_marker')],
					{
						params ['_entity','_base'];
						private _c = FALSE;
						if (alive _entity) then {
							if ((_entity distance2D _base) < 500) then {
								_c = TRUE;
							};
						};
						_c;
					}
				],
				[	/*/FAILED/*/
					[_entity],
					{
						params ['_entity'];
						(!alive _entity)
					}
				],
				[	/*/CANCEL/*/
					[_entity],
					{
						params ['_entity'];
						(((vehicle _entity) isKindOf 'Air') && (_entity isEqualTo (driver (vehicle _entity))))
					}
				]
			],
			_params
		];
		(missionNamespace getVariable 'QS_module_dynamicTasks_add') pushBack _array;		
	};
	if (_type isEqualTo 'FIRE_SUPPORT') then {
		_entity = _params # 0;
		_taskAuthorName = _params # 1;
		_taskID = (format ['QS_DYNTASK_%1_%2',_type,(round (random 10000))]);
		_timeout = diag_tickTime + 900;
		private _description = (format [localize 'STR_QS_Task_121',_taskAuthorName,(getText ((configOf _entity) >> 'displayName'))]);
		_array = [
			_taskID,
			'ADD',
			_type,
			[
				[	/*/CREATED/*/
					[_entity],
					{
						params ['_entity'];
						(alive _entity)
					},
					[
						_taskID,
						TRUE,
						[
							_description,
							localize 'STR_QS_Task_122',
							localize 'STR_QS_Task_122'
						],
						[_entity,TRUE],
						'CREATED',
						0,
						TRUE,
						TRUE,
						'target',
						FALSE
					]
				],
				[	/*/SUCCESS/*/
					[_entity],
					{
						params ['_entity'];
						(!alive _entity)
					}
				],
				[	/*/FAILED/*/
					[_entity],
					{
						FALSE
					}
				],
				[	/*/CANCEL/*/
					[_entity,_timeout],
					{
						params ['_entity','_timeout'];
						((diag_tickTime > _timeout) && (alive _entity))
					}
				]
			],
			_params
		];
		(missionNamespace getVariable 'QS_module_dynamicTasks_add') pushBack _array;
	};
};