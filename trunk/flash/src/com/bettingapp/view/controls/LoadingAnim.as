package com.bettingapp.view.controls
{
	import com.bettingapp.controller.events.BettingAppEvent;
	import com.bettingapp.model.managers.EventManager;
	import com.bettingapp.model.managers.ScreenManager;
	
	import flash.display.MovieClip;
	
	public class LoadingAnim extends MovieClip
	{
		public function LoadingAnim()
		{
			super();
			init();
		}
		
		private function init():void
		{
			visible = false;
			EventManager.instance.addEventListener(BettingAppEvent.SHOW_LOADING_OVERLAY, onShow);
			EventManager.instance.addEventListener(BettingAppEvent.HIDE_LOADING_OVERLAY, onHide);
		}
		
		private function onShow($e:BettingAppEvent):void
		{
			// bump us to top of display list.
			
			ScreenManager.instance.referenceSprite.addChild(this);
			gotoAndPlay("loop");
			visible = true;	
		}
		
		private function onHide($e:BettingAppEvent):void
		{
			gotoAndStop("off");
			visible = false;
		}
	}
}