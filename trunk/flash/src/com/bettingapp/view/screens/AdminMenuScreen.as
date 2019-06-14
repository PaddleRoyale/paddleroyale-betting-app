﻿package com.bettingapp.view.screens{	import com.bettingapp.controller.events.BettingAppEvent;	import com.bettingapp.model.managers.EventManager;	import com.bettingapp.model.managers.WebServicesManager;	import com.bettingapp.view.controls.ActionBar;	import com.bettingapp.view.controls.StandardButton;	import com.bettingapp.view.dialogs.GenericDialog;	import com.bettingapp.vo.AdminModes;	import com.bettingapp.vo.BetTypes;	import com.bettingapp.vo.DialogParameters;	import com.bettingapp.vo.DialogResult;	import com.bettingapp.vo.DialogStyle;	import com.bettingapp.vo.ScreenIds;	import com.bettingapp.vo.ScreenTransitionTypes;	import com.bettingapp.vo.WebServiceResults;		import flash.display.MovieClip;	import flash.events.Event;		public class AdminMenuScreen extends BaseScreen	{		private var _addCreditsButton:StandardButton;		private var _checkAvailableCreditsButton:StandardButton;		private var _processBetsButton:StandardButton;		private var _showWinningBetTotalsButton:StandardButton;		private var _dialog:GenericDialog;				private static var _adminMode:int = AdminModes.ADMIN_MODE_NONE;				public function AdminMenuScreen()		{			super();		}			public override function init():void		{			_addCreditsButton = btn_addCredits;			_checkAvailableCreditsButton = btn_checkAvailableCredits;			_processBetsButton = btn_processBets;			_showWinningBetTotalsButton = btn_showWinningBetTotals;						_addCreditsButton.label = "Add Credits";			_checkAvailableCreditsButton.label = "Check Available Credits";			_processBetsButton.label = "Process Bets";			_showWinningBetTotalsButton.label = "Show Winning Bet Totals";						_addCreditsButton.enabled = _checkAvailableCreditsButton.enabled = _processBetsButton.enabled = _showWinningBetTotalsButton.enabled = false;						super.init();		}				protected override function onAddedToStage($e:Event):void		{			super.onAddedToStage($e);		}				public override function show():void		{			super.show();						_addCreditsButton.enabled = _checkAvailableCreditsButton.enabled = _processBetsButton.enabled = _showWinningBetTotalsButton.enabled =  true;			_eventManager.addEventListener(BettingAppEvent.BUTTON_PRESSED, onButtonPressed);		}						public override function hide():void 		{			_eventManager.removeEventListener(BettingAppEvent.BUTTON_PRESSED, onButtonPressed);			_addCreditsButton.enabled = _checkAvailableCreditsButton.enabled = _processBetsButton.enabled = _showWinningBetTotalsButton.enabled = false;			super.hide();		}				private function onButtonPressed($e:BettingAppEvent):void		{			trace("button pressed");						// make sure this is not the nav bar.			if ($e.parameters.button == _addCreditsButton)			{				_adminMode = AdminModes.ADMIN_MODE_ADD_CREDITS;				changeView(ScreenIds.SCREEN_ID_VERIFY_VOUCHER, ScreenTransitionTypes.SCREEN_TRANSITION_TYPE_FORWARD);			}			else if ($e.parameters.button == _checkAvailableCreditsButton)			{				_adminMode = AdminModes.ADMIN_MODE_CHECK_CREDITS;				changeView(ScreenIds.SCREEN_ID_VERIFY_VOUCHER, ScreenTransitionTypes.SCREEN_TRANSITION_TYPE_FORWARD);					}			else if ($e.parameters.button == _processBetsButton)			{				_adminMode = AdminModes.ADMIN_MODE_PROCESS_BETS;								var parameters:DialogParameters = new DialogParameters();				parameters.body = "Are you sure you want to process all bets?  This will clear any previous bet totals recorded.";				parameters.dialogStyle = DialogStyle.DIALOG_STYLE_YESNO;								_dialog = new GenericDialog();				_dialog.open(this, parameters);				_eventManager.addEventListener(BettingAppEvent.DIALOG_RESULT, onDialogResult);			}			else if ($e.parameters.button == _showWinningBetTotalsButton)			{				_adminMode = AdminModes.ADMIN_MODE_SHOW_WINNING_BET_TOTALS;				changeView(ScreenIds.SCREEN_ID_ADMIN_SHOW_BET_TOTALS, ScreenTransitionTypes.SCREEN_TRANSITION_TYPE_FORWARD);			}		}				private function onDialogResult($e:BettingAppEvent):void		{			_eventManager.removeEventListener(BettingAppEvent.DIALOG_RESULT, onDialogResult);						if ($e.parameters.result == DialogResult.DIALOG_RESULT_YES)			{				WebServicesManager.instance.ProcessBets();				_eventManager.addEventListener(BettingAppEvent.WEB_SERVICE_RESULT, onBetsProcessed);			}		}				private function onBetsProcessed($e:BettingAppEvent):void		{			_eventManager.removeEventListener(BettingAppEvent.WEB_SERVICE_RESULT, onBetsProcessed);						var parameters:DialogParameters = new DialogParameters();			parameters.dialogStyle = DialogStyle.DIALOG_STYLE_OK;						if ($e.parameters.result == WebServiceResults.RESULT_SUCCESS)			{								parameters.body = "All bets were successfully processed.";			}			else			{				parameters.body = "No bets were processed.  Most likely cause of this is that a winner for the tournament has not yet been defined.";					}						_dialog = new GenericDialog();			_dialog.open(this, parameters);		}			public static function get adminMode():int		{			return _adminMode;		}	}}