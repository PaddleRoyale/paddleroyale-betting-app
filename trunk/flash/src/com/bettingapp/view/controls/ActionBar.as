package com.bettingapp.view.controls
{
	import com.bettingapp.controller.events.BettingAppEvent;
	import com.bettingapp.model.managers.EventManager;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class ActionBar extends MovieClip
	{
		public static var BACK_BUTTON:int 		= 0x01;
		public static var PAGE_NEXT_BUTTON:int 	= 0x02;
		public static var PAGE_PREV_BUTTON:int 	= 0x04;
		
		private var _backButton:ActionBarButton;
		private var _pageNextButton:ActionBarButton;
		private var _pagePrevButton:ActionBarButton;
		
		public function ActionBar()
		{
			super();
			
			_backButton = btn_back;
			_pageNextButton = btn_pageNext;
			_pagePrevButton = btn_pagePrev;
			
			_backButton.init(BACK_BUTTON);
			_pageNextButton.init(PAGE_NEXT_BUTTON);
			_pagePrevButton.init(PAGE_PREV_BUTTON);
			
			_backButton.addEventListener(BettingAppEvent.ACTION, onAction);
			_pageNextButton.addEventListener(BettingAppEvent.ACTION, onAction);
			_pagePrevButton.addEventListener(BettingAppEvent.ACTION, onAction);
			
			activate(0);
		}
		
		public function activate($filter:int):void
		{
			_backButton.enabled = (($filter & BACK_BUTTON) > 0);		
			_pageNextButton.enabled = (($filter & PAGE_NEXT_BUTTON) > 0);
			_pagePrevButton.enabled = (($filter & PAGE_PREV_BUTTON) > 0);
		}
		
		
		private function onAction($e:BettingAppEvent):void
		{
			EventManager.instance.dispatchEvent($e.clone());
		}
		
	}
}