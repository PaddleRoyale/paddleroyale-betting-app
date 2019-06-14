package com.bettingapp.view.controls
{
	import com.bettingapp.controller.events.BettingAppEvent;
	import com.bettingapp.model.managers.EventManager;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	public class StandardButton extends MovieClip
	{
		private var _label:TextField;
		
		public function StandardButton()
		{
			super();
			
			_label = txt_label;
			
			buttonMode = true;
			mouseChildren = false;
			
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}
		
		private function onMouseDown($e:MouseEvent):void
		{
			gotoAndStop("down");
		}
		
		private function onMouseOut($e:MouseEvent):void
		{
			if (currentLabel == "down")
			{
				gotoAndStop("up");
			}
		}
		
		private function onMouseUp($e:MouseEvent):void
		{
			var event:BettingAppEvent = new BettingAppEvent(BettingAppEvent.BUTTON_PRESSED);
			event.parameters.button = this;
			EventManager.instance.dispatchEvent(event);
		}
		
		public function set label($val:String):void
		{
			_label.text = $val;
		}
	}
}