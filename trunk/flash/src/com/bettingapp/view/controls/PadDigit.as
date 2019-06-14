package com.bettingapp.view.controls
{
	import com.bettingapp.controller.events.BettingAppEvent;
	import com.bettingapp.model.managers.EventManager;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	public class PadDigit extends MovieClip
	{
		private var _label:TextField;
		
		public function PadDigit()
		{
			super();
			
			_label = txt_label;
			buttonMode = true;
			mouseChildren = false;
		}
		
		public override function set enabled($val:Boolean):void
		{
			if ($val)
			{
				addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
				addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
				addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			}
			else
			{
				removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
				removeEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
				removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			}
			super.enabled = $val;
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
			gotoAndStop("up");
			var event:BettingAppEvent = new BettingAppEvent(BettingAppEvent.NUMERIC_PAD_PRESSED);
			event.parameters.key = _label.text;
			EventManager.instance.dispatchEvent(event);
		}
		
		public function setLabel($label:String):void
		{
			_label.text = $label;
		}
	}
}