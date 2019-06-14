package com.bettingapp.view.screens
{
	import com.bettingapp.controller.events.BettingAppEvent;
	import com.bettingapp.model.managers.EventManager;
	import com.bettingapp.model.managers.WebServicesManager;
	import com.bettingapp.view.controls.StandardButton;
	import com.bettingapp.vo.ScreenIds;
	import com.bettingapp.vo.ScreenTransitionTypes;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public class BetConfirmationScreen extends BaseScreen
	{
		private var _placeAnotherBetButton:StandardButton;
		
		public function BetConfirmationScreen()
		{
			super();
		}
	
		public override function init():void
		{
			_placeAnotherBetButton = btn_placeAnotherBet;
			
			super.init();
		}
		
		protected override function onAddedToStage($e:Event):void
		{
			super.onAddedToStage($e);
		}
		
		public override function show():void
		{
			super.show();
			_eventManager.addEventListener(BettingAppEvent.BUTTON_PRESSED, onButtonPressed);
		}
		
		public override function hide():void 
		{
			_eventManager.removeEventListener(BettingAppEvent.BUTTON_PRESSED, onButtonPressed);
			super.hide();
			
		}
		
		private function onButtonPressed($e:BettingAppEvent):void
		{
			trace("placing another bet");
			WebServicesManager.instance.activeBet.reset();
			changeView(ScreenIds.SCREEN_ID_VERIFY_VOUCHER, ScreenTransitionTypes.SCREEN_TRANSITION_TYPE_FORWARD);
		}
	}
}