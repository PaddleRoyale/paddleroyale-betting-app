package com.bettingapp.view.controls
{
	import com.bettingapp.controller.events.BettingAppEvent;
	import com.greensock.TweenMax;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	public class ActionBarButton extends MovieClip
	{
		private var _label:TextField;
		private var _id:int;
		
		public function ActionBarButton()
		{
			super();
			
			alpha = 0;
			visible = false;
			mouseChildren = false;
			
			_label = txt_label;
		}
		
		public function init($id:int):void
		{
			_id = $id;
			
			switch (_id)
			{
				case ActionBar.BACK_BUTTON:
					_label.text = "Back";
					break;
				case ActionBar.PAGE_NEXT_BUTTON:
					_label.text = ">";
					break;
				case ActionBar.PAGE_PREV_BUTTON:
					_label.text = "<";
					break;
			}
			 
		}
		
		public override function set enabled($val:Boolean):void
		{
			if ($val)
			{
				buttonMode = true;
				mouseEnabled = true;
				addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
				addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
				addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
				
				TweenMax.to(this, 0.5, {autoAlpha: 1});
			}
			else
			{
				buttonMode = false;
				mouseEnabled = false;
				
				if (hasEventListener(MouseEvent.MOUSE_DOWN))
				{
					removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
				}
				if (hasEventListener(MouseEvent.MOUSE_UP))
				{
					removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
				}
				
				if (hasEventListener(MouseEvent.MOUSE_OUT))
				{
					removeEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
				}
				
				TweenMax.to(this, 0.5, {autoAlpha: 0});
			}
			super.enabled = $val;
		}
		
		private function onMouseOut($e:MouseEvent)
		{
			if (currentLabel == "down")
			{
				gotoAndStop("up");
			}
		}
		
		private function onMouseDown($e:MouseEvent):void
		{
			gotoAndStop("down");
		}
		
		private function onMouseUp($e:MouseEvent):void
		{
			gotoAndStop("up");
			var event:BettingAppEvent = new BettingAppEvent(BettingAppEvent.ACTION);
			event.parameters.action = _id;
			dispatchEvent(event); 
		}
	}
}