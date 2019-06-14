package com.bettingapp.view.dialogs
{
	import com.bettingapp.controller.events.BettingAppEvent;
	import com.bettingapp.model.managers.EventManager;
	import com.bettingapp.view.controls.BallotButton;
	import com.bettingapp.view.controls.StandardButton;
	import com.bettingapp.vo.DialogParameters;
	import com.bettingapp.vo.DialogResult;
	import com.bettingapp.vo.DialogStyle;
	
	import flash.display.MovieClip;
	import flash.text.TextField;

	public class GenericDialog extends BaseDialog
	{
		private var _yesButton:StandardButton;
		private var _noButton:StandardButton;
		private var _cancelButton:StandardButton;	
		private var _body:TextField;
		private var _dialogContainer:MovieClip;
		private var _dialogStyle:int;
		
		private static const BUTTON_SPACING:int = 10;		// how much spacing between dialog buttons.
		
		public function GenericDialog()
		{
			super();
			init();
		}
		
		protected override function init():void
		{
			_yesButton = btn_yes;
			_noButton = btn_no;
			_cancelButton = btn_cancel;
			_body = txt_body;
			_dialogContainer = mc_dialogBG;
			
			super.init();	
		}
		
		
		public override function open($parent:MovieClip, $dialogParameters:DialogParameters = null):void
		{
			_dialogStyle = $dialogParameters.dialogStyle;
			_body.text = $dialogParameters.body;
			_yesButton.visible = _noButton.visible = _cancelButton.visible = false;
			
			switch (_dialogStyle)
			{
				case DialogStyle.DIALOG_STYLE_OK:
					_yesButton.label = ($dialogParameters.labelYes) ? $dialogParameters.labelYes : "OK";
					_yesButton.visible = true;
					
					_yesButton.x = (_dialogContainer.x + (_dialogContainer.width * 0.5)) - (_yesButton.width * 0.5);
					break;
				
				case DialogStyle.DIALOG_STYLE_YESNO:
					_yesButton.label = ($dialogParameters.labelYes) ? $dialogParameters.labelYes : "Yes";
					_noButton.label = ($dialogParameters.labelNo) ? $dialogParameters.labelNo : "No";
					
					_yesButton.visible = _noButton.visible = true;
					
					_yesButton.x = (_dialogContainer.x + (_dialogContainer.width * 0.5)) - _yesButton.width - (BUTTON_SPACING * 0.5);
					_noButton.x = (_dialogContainer.x + (_dialogContainer.width * 0.5)) + (BUTTON_SPACING * 0.5);
					break;
				
				case DialogStyle.DIALOG_STYLE_YESNOCANCEL:
					_yesButton.label = ($dialogParameters.labelYes) ? $dialogParameters.labelYes : "Yes";
					_noButton.label = ($dialogParameters.labelNo) ? $dialogParameters.labelNo : "No";
					_cancelButton.label = ($dialogParameters.labelCancel) ? $dialogParameters.labelCancel : "Cancel";
					_yesButton.visible = _noButton.visible = _cancelButton.visible = true;
					
					_noButton.x = (_dialogContainer.x + (_dialogContainer.width * 0.5)) - (_noButton.width * 0.5);
					_yesButton.x = _noButton.x - _yesButton.width - BUTTON_SPACING;
					_cancelButton.x = (_noButton.x + _noButton.width) + BUTTON_SPACING;
					break;
			}
			
			EventManager.instance.addEventListener(BettingAppEvent.BUTTON_PRESSED, onButtonPressed);
			super.open($parent);
		}
		
		private function onButtonPressed($e:BettingAppEvent):void
		{
			var event:BettingAppEvent = new BettingAppEvent(BettingAppEvent.DIALOG_RESULT);
			if ($e.parameters.button == _yesButton)
			{
				event.parameters.result = (_dialogStyle == DialogStyle.DIALOG_STYLE_OK) ? DialogResult.DIALOG_RESULT_OK : DialogResult.DIALOG_RESULT_YES;
			}
			else if ($e.parameters.button == _noButton)
			{
				// no
				event.parameters.result = DialogResult.DIALOG_RESULT_NO;
			}
			else
			{
				event.parameters.result = DialogResult.DIALOG_RESULT_CANCEL;
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