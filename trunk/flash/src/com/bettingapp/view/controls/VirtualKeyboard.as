package com.bettingapp.view.controls
{
	import com.bettingapp.controller.events.BettingAppEvent;
	import com.bettingapp.model.managers.EventManager;
	import com.bettingapp.model.managers.ScreenManager;
	import com.bettingapp.view.dialogs.BaseDialog;
	import com.bettingapp.vo.DialogParameters;
	import com.greensock.TweenMax;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;

	public class VirtualKeyboard extends BaseDialog
	{
		private var _keys:Array = new Array();
		private  var _keyboardContainer:MovieClip;		// we keep keyboard in container so we can animate it independently of other objects in this dialog.
		private var _targetY:Number;				// when animating keyboard in, this is our target position.
		private const SLIDE_TIME:Number = 0.30;
		
		public function VirtualKeyboard()
		{
			super();
			
			_keyboardContainer = mc_keyboardContainer;
			_targetY = _keyboardContainer.y;
			
			with (_keyboardContainer)
			{
				_keys.push({ key:mc_keyA, value:"A" });
				_keys.push({ key:mc_keyB, value:"B" });
				_keys.push({ key:mc_keyC, value:"C" });
				_keys.push({ key:mc_keyD, value:"D" });
				_keys.push({ key:mc_keyE, value:"E" });
				_keys.push({ key:mc_keyF, value:"F" });
				_keys.push({ key:mc_keyG, value:"G" });
				_keys.push({ key:mc_keyH, value:"H" });
				_keys.push({ key:mc_keyI, value:"I" });
				_keys.push({ key:mc_keyJ, value:"J" });
				_keys.push({ key:mc_keyK, value:"K" });
				_keys.push({ key:mc_keyL, value:"L" });
				_keys.push({ key:mc_keyM, value:"M" });
				_keys.push({ key:mc_keyN, value:"N" });
				_keys.push({ key:mc_keyO, value:"O" });
				_keys.push({ key:mc_keyP, value:"P" });
				_keys.push({ key:mc_keyQ, value:"Q" });
				_keys.push({ key:mc_keyR, value:"R" });
				_keys.push({ key:mc_keyS, value:"S" });
				_keys.push({ key:mc_keyT, value:"T" });
				_keys.push({ key:mc_keyU, value:"U" });
				_keys.push({ key:mc_keyV, value:"V" });
				_keys.push({ key:mc_keyW, value:"W" });
				_keys.push({ key:mc_keyX, value:"X" });
				_keys.push({ key:mc_keyY, value:"Y" });
				_keys.push({ key:mc_keyZ, value:"Z" });
				_keys.push({ key:mc_key0, value:"0" });
				_keys.push({ key:mc_key1, value:"1" });
				_keys.push({ key:mc_key2, value:"2" });
				_keys.push({ key:mc_key3, value:"3" });
				_keys.push({ key:mc_key4, value:"4" });
				_keys.push({ key:mc_key5, value:"5" });
				_keys.push({ key:mc_key6, value:"6" });
				_keys.push({ key:mc_key7, value:"7" });
				_keys.push({ key:mc_key8, value:"8" });
				_keys.push({ key:mc_key9, value:"9" });
				_keys.push({ key:mc_keyDelete, value:"Delete" });
				_keys.push({ key:mc_keyClear, value:"Clear" });
				_keys.push({ key:mc_keySpace, value:"Space" });
				_keys.push({ key:mc_keyAccept, value:"Accept" });
				_keys.push({ key:mc_keyCancel, value:"Cancel" });
			}
			
			for each (var obj:Object in _keys)
			{
				var key:Key = obj.key;
				key.init(obj.value);
			}
		}
		
		public override function open($parent:MovieClip, $dialogParameters:DialogParameters = null):void
		{
			// we need to take into account any scale being applied to reference clip.
			var referenceSprite:Sprite = ScreenManager.instance.referenceSprite;
			var actualHeight:Number = referenceSprite.height / referenceSprite.scaleY;
			
			_keyboardContainer.y = actualHeight;
			TweenMax.to(_keyboardContainer, SLIDE_TIME, { y:_targetY, onComplete: onTransitionInComplete });
			
			super.open($parent);
		}
		
		/**
		 * Called to "activate" screen when keyboard is done transitioning in 
		 * 
		 */		
		private function onTransitionInComplete():void
		{
			trace("onTransitionInComplete");
			EventManager.instance.addEventListener(BettingAppEvent.KEYBOARD_STATE_CHANGE, onKeyStateChange);
			for each (var obj:Object in _keys)
			{
				var key:Key = obj.key;
				key.enabled = true;
			}	
		}
		
		protected override function close():void
		{
			trace("close");
			// we need to take into account any scale being applied to reference clip.
			var referenceSprite:Sprite = ScreenManager.instance.referenceSprite;
			var actualHeight:Number = referenceSprite.height / referenceSprite.scaleY;
			
			TweenMax.to(_keyboardContainer, SLIDE_TIME, { y:actualHeight, onComplete: onTransitionOutComplete });
			
			// don't call base class close as we don't want to get pushed off display stack yet.  Will get called when anim is over.
		}
		
		public function forceClose():void
		{
			// we need to take into account any scale being applied to reference clip.
			var referenceSprite:Sprite = ScreenManager.instance.referenceSprite;
			var actualHeight:Number = referenceSprite.height / referenceSprite.scaleY;
			
			y = actualHeight;
			onTransitionOutComplete();
		}
		
		/**
		 * Called to "deactivate" screen when keyboard is done transitioning in 
		 * 
		 */		
		private function onTransitionOutComplete():void
		{
			trace("onTransitionOutComplete");
			// tell base screen that the keyboard was closed.
			EventManager.instance.dispatchEvent(new BettingAppEvent(BettingAppEvent.KEYBOARD_CLOSE));
			
			// cleanup on our end.
			EventManager.instance.removeEventListener(BettingAppEvent.KEYBOARD_STATE_CHANGE, onKeyStateChange);
			for each (var obj:Object in _keys)
			{
				var key:Key = obj.key;
				key.enabled = false;
			}
			super.close();
		}
		
		private function onKeyStateChange($e:BettingAppEvent):void
		{
			var key:Key = $e.parameters.key as Key;
			var keyVal:String;
		
			trace("got key press: " + key.label);
			switch (key.label)
			{
				case "Delete":
				case "Clear":
					// handled below
					break;
			
				case "Space":
					keyVal = " ";
					break;
				
				case "Accept":
					close();
					return;
					break;
				
				case "Cancel":
					close();
					break;
				
				default:
					keyVal = key.label;
					break;
			}
			
			
			var event:BettingAppEvent = new BettingAppEvent(BettingAppEvent.KEY_PRESSED);
			event.parameters.DELETE = (key.label == "Delete");
			event.parameters.CLEAR = (key.label == "Clear");
			event.parameters.CANCEL = (key.label == "Cancel");
			event.parameters.key = keyVal;
			EventManager.instance.dispatchEvent(event);
		}
	}
}