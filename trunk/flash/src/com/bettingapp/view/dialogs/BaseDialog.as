package com.bettingapp.view.dialogs
{
	import com.bettingapp.controller.events.BettingAppEvent;
	import com.bettingapp.model.managers.EventManager;
	import com.bettingapp.vo.DialogParameters;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;

	public class BaseDialog extends MovieClip
	{
		protected var _parent:MovieClip;
		
		public function BaseDialog()
		{
			super();
		}
		
		protected function init():void
		{
		}
		
		public function open($parent:MovieClip, $parameters:DialogParameters = null):void
		{
			_parent = $parent;
			_parent.addChild(this);
		}
		
		protected function close():void
		{
			_parent.removeChild(this);
			delete this;
		}
	}
}