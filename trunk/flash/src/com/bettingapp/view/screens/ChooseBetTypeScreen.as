package com.bettingapp.view.screens
{
	import com.bettingapp.controller.events.BettingAppEvent;
	import com.bettingapp.model.managers.EventManager;
	import com.bettingapp.model.managers.WebServicesManager;
	import com.bettingapp.view.controls.ActionBar;
	import com.bettingapp.view.controls.StandardButton;
	import com.bettingapp.vo.BetTypes;
	import com.bettingapp.vo.ScreenIds;
	import com.bettingapp.vo.ScreenTransitionTypes;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public class ChooseBetTypeScreen extends BaseScreen
	{
		private var _playerBetButton:StandardButton;
		private var _agencyBetButton:StandardButton;
		private var _matchBetButton:StandardButton;
		
		public function ChooseBetTypeScreen()
		{
			super();
		}
	
		public override function init():void
		{
			_playerBetButton = btn_playerBet;
			_agencyBetButton = btn_agencyBet;
			_matchBetButton = btn_matchBet;
			
			_playerBetButton.label = "Bet On Player";
			_agencyBetButton.label = "Bet On Agency";
			_matchBetButton.label = "Bet On Match";
			
			_playerBetButton.enabled = _agencyBetButton.enabled = _matchBetButton.enabled = false;
			super.init();
		}
		
		protected override function onAddedToStage($e:Event):void
		{
			super.onAddedToStage($e);
		}
		
		public override function show():void
		{
			super.show();
			
			_playerBetButton.enabled = _agencyBetButton.enabled = _matchBetButton.enabled = true;
			_eventManager.addEventListener(BettingAppEvent.BUTTON_PRESSED, onButtonPressed);
			_eventManager.addEventListener(BettingAppEvent.ACTION, onAction);
		}
		
		protected override function showActionBar($filter:int = 0):void
		{
			super.showActionBar(ActionBar.BACK_BUTTON);
		}
		
		public override function hide():void 
		{
			_eventManager.removeEventListener(BettingAppEvent.BUTTON_PRESSED, onButtonPressed);
			_eventManager.removeEventListener(BettingAppEvent.ACTION, onAction);
			_playerBetButton.enabled = _agencyBetButton.enabled = false;
			super.hide();
		}
		
		private function onButtonPressed($e:BettingAppEvent):void
		{
			trace("button pressed");
			
			// make sure this is not the nav bar.
			if ($e.parameters.button == _agencyBetButton)
			{
				trace("agency bet selected");
				WebServicesManager.instance.activeBet.type = BetTypes.BET_TYPE_AGENCY;
				changeView(ScreenIds.SCREEN_ID_SELECT_AGENCY, ScreenTransitionTypes.SCREEN_TRANSITION_TYPE_FORWARD);
			}
			else if ($e.parameters.button == _playerBetButton)
			{
				trace("player bet selected");
				WebServicesManager.instance.activeBet.type = BetTypes.BET_TYPE_PLAYER;
				changeView(ScreenIds.SCREEN_ID_SELECT_PLAYER, ScreenTransitionTypes.SCREEN_TRANSITION_TYPE_FORWARD);		
			}
			else if ($e.parameters.button == _matchBetButton)
			{
				trace("match bet selected");
				WebServicesManager.instance.activeBet.type = BetTypes.BET_TYPE_MATCH;
				changeView(ScreenIds.SCREEN_ID_SELECT_PLAYER, ScreenTransitionTypes.SCREEN_TRANSITION_TYPE_FORWARD);		
			}
		}
		
		protected function onAction($e:BettingAppEvent):void
		{
			if ($e.parameters.action == ActionBar.BACK_BUTTON)
			{
				changeView(ScreenIds.SCREEN_ID_VERIFY_VOUCHER, ScreenTransitionTypes.SCREEN_TRANSITION_TYPE_BACK);
			}
			// straight override, no base class.
		}
	}
}