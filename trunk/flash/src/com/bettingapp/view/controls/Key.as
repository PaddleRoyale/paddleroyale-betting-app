package com.bettingapp.view.controls
{
	import com.bettingapp.controller.events.BettingAppEvent;
	import com.bettingapp.model.managers.EventManager;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	public class Key extends MovieClip
	{
		private var _label:TextField;
		
		public function Key()
		{
			super();
		}
		
		public function init($label:String):void
		{
			_label = txt_label;
			_label.text = $label;
			mouseChildren = false;
		}
		
		public override function set enabled($value:Boolean):void
		{
			mouseEnabled = buttonMode = $value;
			
			if ($value)
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
				
			super.enabled = $value;
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
			var event:BettingAppEvent = new BettingAppEvent(BettingAppEvent.KEYBOARD_STATE_CHANGE);
			event.parameters.key = this;
			EventManager.instance.dispatchEvent(event);
		}
		
		public function get label():String
		{
			return _label.text;
		}
	}
}