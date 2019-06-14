package com.bettingapp.view.dialogs
{
	import com.bettingapp.controller.events.BettingAppEvent;
	import com.bettingapp.model.managers.EventManager;
	import com.bettingapp.model.managers.WebServicesManager;
	import com.bettingapp.view.controls.BallotButton;
	import com.bettingapp.view.controls.StandardButton;
	import com.bettingapp.vo.Bet;
	import com.bettingapp.vo.DialogParameters;
	import com.bettingapp.vo.DialogResult;
	import com.bettingapp.vo.Match;
	import com.bettingapp.vo.WebServiceResults;
	
	import flash.display.MovieClip;
	import flash.text.TextField;

	public class ConfirmPlayerMatchBetDialog extends BaseDialog
	{
		private var _dialogContainer:MovieClip;
		private var _acceptButton:StandardButton;
		private var _cancelButton:StandardButton;
		private var _body:TextField;
		private var _displayName:String;
		private var _id:int;
		private var _matchId:int;
		private var _player1:TextField;
		private var _player2:TextField;
		
		public function ConfirmPlayerMatchBetDialog($displayName:String, $id:int)
		{
			super();
			
			_displayName = $displayName;
			_id = $id;
			init();
		}
		
		protected override function init():void
		{
			_dialogContainer = mc_dialogContainer;
			_acceptButton = _dialogContainer.btn_accept;
			_acceptButton.label = "Yes";
			
			_cancelButton = _dialogContainer.btn_cancel;
			_cancelButton.label = "No";
	
			_body = _dialogContainer.txt_body;
			_body.text = "Would you like to place a bet for " + _displayName + " to win the match summarized below?";
			
			_player1 = _dialogContainer.mc_match.txt_player1;
			_player2 = _dialogContainer.mc_match.txt_player2;
			
			_matchId = -1;
			
			super.init();	
		}
		
		
		public override function open($parent:MovieClip, $dialogParameters:DialogParameters = null):void
		{
			// run the service to get the next match for this player...
			WebServicesManager.instance.GetPlayerNextMatch(_id);
			EventManager.instance.addEventListener(BettingAppEvent.WEB_SERVICE_RESULT, onWebServiceResult);
			
			// hide dialog while we're fetching data.
			_dialogContainer.visible = false;
			
			super.open($parent);
		}
		
		private function onWebServiceResult($e:BettingAppEvent):void
		{
			EventManager.instance.removeEventListener(BettingAppEvent.WEB_SERVICE_RESULT, onWebServiceResult);
			EventManager.instance.addEventListener(BettingAppEvent.BUTTON_PRESSED, onButtonPressed);
			
			// using result, start showing dialog.
			if ($e.parameters.result == WebServiceResults.RESULT_SUCCESS)
			{
				// fill in data from match we got back, making sure we got back a valid match.
				var match:Match = $e.parameters.match as Match;
				
				_matchId = match.id;
				// make sure we got a valid match back.
				if (match && match.id >= 0)
				{
					_player1.text = match.player1;
					_player2.text = match.player2;
				}
			}
			
			// start showing content of dialog.
			_dialogContainer.visible = true;
		}
		
		private function onButtonPressed($e:BettingAppEvent):void
		{
			var event:BettingAppEvent = new BettingAppEvent(BettingAppEvent.DIALOG_RESULT);
			if ($e.parameters.button == _acceptButton)
			{
				// yes	
				event.parameters.result = DialogResult.DIALOG_RESULT_YES;
				
				// we need to include both the match id and the player id in order to place a match bet.
				event.parameters.id = (_matchId << 16) + _id;
				
				trace("confirming match bet: matchid=" + _matchId + ",playerid=" + _id + ", bet value=" + event.parameters.id);
			}
			else
			{
				trace("no");
				// no
				event.parameters.result = DialogResult.DIALOG_RESULT_NO;
			}
			EventManager.instance.dispatchEvent(event);
			close();
		}
		
		protected override function close():void
		{
			EventManager.instance.removeEventListener(BettingAppEvent.BUTTON_PRESSED, onButtonPressed);
			super.close();
		}
	}
}