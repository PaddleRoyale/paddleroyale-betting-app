package com.bettingapp.view.screens
{
	import com.bettingapp.controller.events.BettingAppEvent;
	import com.bettingapp.model.managers.EventManager;
	import com.bettingapp.vo.ScreenIds;
	import com.bettingapp.vo.ScreenTransitionTypes;
	import com.greensock.easing.Linear;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	
	public class AttractScreen extends BaseScreen
	{
		private var _logo:MovieClip;
		private var _label:TextField;
		private var _logoCanvas:Rectangle;
		
		// vars to control animation of logo.
		private static const SPEED:Number = 4;
		private var _vx:Number = SPEED;
		private var _vy:Number = SPEED;
		
		public function AttractScreen()
		{
			super();
		}
	
		public override function init():void
		{
			super.init();
			
			_logo = mc_logo;
			_label = txt_label;
		}
		
		protected override function onAddedToStage($e:Event):void
		{
			super.onAddedToStage($e);
			
			// create logo canvas that it animates on
			// ARC_DCP Don't know why yet, but stage.width is not accurate, hard code our desired stage width.
			_logoCanvas = new Rectangle(0,0, 640.0 - _logo.width, (stage.height - (stage.height - _label.y)) - _logo.height);
		}
		
		public override function show():void
		{
			super.show();
			
			addEventListener(Event.ENTER_FRAME, updateLogo);
			stage.addEventListener(MouseEvent.CLICK, onTouched);
		}
		
		public override function hide():void 
		{
			super.hide();
			
			removeEventListener(Event.ENTER_FRAME, updateLogo);
			stage.removeEventListener(MouseEvent.CLICK, onTouched);
			
		}
		
		private function onTouched($e:MouseEvent):void
		{
			changeView(ScreenIds.SCREEN_ID_VERIFY_VOUCHER, ScreenTransitionTypes.SCREEN_TRANSITION_TYPE_NONE);
		}
		
		/**
		 * Checks the boundaries for the logo as it animates to make sure the logo stays within the boundaries. 
		 * 
		 */		
		private function updateLogo($e:Event):void
		{
			// change direction if ball moves out of allowed rectangle
			if (_logo.x < _logoCanvas.x)
			{
				_vx = SPEED;
			}
			else if (_logo.x > _logoCanvas.width)
			{
				_vx = -SPEED;
			}
			
			if (_logo.y < _logoCanvas.y)
			{
				_vy = SPEED;
			}
			else if (_logo.y > _logoCanvas.height)
			{
				_vy = -SPEED;
			}
			
			_logo.x += _vx;
			_logo.y += _vy;
		}
	}
}