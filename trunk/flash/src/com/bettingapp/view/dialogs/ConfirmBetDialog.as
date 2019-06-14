package com.bettingapp.view.dialogs
{
	import com.bettingapp.controller.events.BettingAppEvent;
	import com.bettingapp.model.managers.EventManager;
	import com.bettingapp.view.controls.BallotButton;
	import com.bettingapp.view.controls.StandardButton;
	import com.bettingapp.vo.DialogParameters;
	import com.bettingapp.vo.DialogResult;
	
	import flash.display.MovieClip;
	import flash.text.TextField;

	public class ConfirmBetDialog extends BaseDialog
	{
		private var _acceptButton:StandardButton;
		private var _cancelButton:StandardButton;
		private var _body:TextField;
		private var _displayName:String;
		private var _id:int;
		
		public function ConfirmBetDialog($displayName:String, $id:int)
		{
			_displayName = $displayName;
			_id = $id;
			super();
			init();
		}
		
		protected override function init():void
		{
			_acceptButton = btn_accept;
			_acceptButton.label = "Yes";
			
			_cancelButton = btn_cancel;
			_cancelButton.label = "No";
	
			_body = txt_body;
			_body.text = "Are you sure you want to place an agency bet on " + _displayName + "?";
			
			super.init();	
		}
		
		
		public override function open($parent:MovieClip, $dialogParameters:DialogParameters = null):void
		{
			EventManager.instance.addEventListener(BettingAppEvent.BUTTON_PRESSED, onButtonPressed);
			super.open($parent);
		}
		
		private function onButtonPressed($e:BettingAppEvent):void
		{
			var event:BettingAppEvent = new BettingAppEvent(BettingAppEvent.DIALOG_RESULT);
			if ($e.parameters.button == _acceptButton)
			{
				trace("yes");
				// yes	
				event.parameters.result = DialogResult.DIALOG_RESULT_YES;
				event.parameters.id = _id;
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