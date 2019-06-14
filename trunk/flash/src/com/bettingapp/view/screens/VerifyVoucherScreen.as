package com.bettingapp.view.screens
{
	import com.bettingapp.controller.events.BettingAppEvent;
	import com.bettingapp.model.managers.EventManager;
	import com.bettingapp.model.managers.WebServicesManager;
	import com.bettingapp.view.controls.ActionBar;
	import com.bettingapp.view.controls.NumericPad;
	import com.bettingapp.vo.AdminModes;
	import com.bettingapp.vo.ScreenIds;
	import com.bettingapp.vo.ScreenTransitionTypes;
	import com.bettingapp.vo.Voucher;
	import com.bettingapp.vo.WebServiceResults;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.text.TextField;
	
	public class VerifyVoucherScreen extends BaseScreen
	{
		private static const MAX_VOUCHER_ID_LENGTH:int = 4;
		private static const PIN_MIN_VALUE:int = 1000; // how much we need to add to each pin when submitting.
		private var _voucherId:TextField;
		private var _header:TextField;
		private var _errorMessage:TextField;
		private var _numPad:NumericPad;
		private var _currentStep:int;
		private var _lastEnteredVoucherId:int;
		
		public function VerifyVoucherScreen()
		{
			super();
		}
	
		public override function init():void
		{
			_voucherId = txt_voucherId;
			_numPad = mc_numPad;
			_errorMessage = txt_error;
			_header = txt_header;
			super.init();
		}
		
		protected override function onAddedToStage($e:Event):void
		{
			super.onAddedToStage($e);
		}
		
		protected override function showActionBar($filter:int = 0):void
		{
			if (AdminMenuScreen.adminMode != AdminModes.ADMIN_MODE_NONE)
			{
				super.showActionBar(ActionBar.BACK_BUTTON);
			}
			else
			{
				super.showActionBar();
			}
		}
		
		public override function show():void
		{
			super.show();
			
			// clear voucher id everytime we come here...
			// see what we're showing...
			
			_currentStep = 1;
			switch (AdminMenuScreen.adminMode)
			{
				case AdminModes.ADMIN_MODE_ADD_CREDITS:
					_header.text = "Step 1/2: Enter PIN you wish to add credits for";
					break;
				case AdminModes.ADMIN_MODE_CHECK_CREDITS:
					_header.text = "Enter PIN you wish to check credits for";
					break;
				default:
					_header.text = "Enter PIN to continue";
					break;
					
			}
	
			_voucherId.text = "";
			_errorMessage.visible = false;
			_numPad.activate();
			_eventManager.addEventListener(BettingAppEvent.NUMERIC_PAD_PRESSED, onNumPadInput);
			
			if (AdminMenuScreen.adminMode != AdminModes.ADMIN_MODE_NONE)
			{
				_eventManager.addEventListener(BettingAppEvent.ACTION, onAction);
			}
		}
		
		public override function hide():void 
		{
			_numPad.deactivate();
			_eventManager.removeEventListener(BettingAppEvent.NUMERIC_PAD_PRESSED, onNumPadInput);
			if (AdminMenuScreen.adminMode != AdminModes.ADMIN_MODE_NONE)
			{
				_eventManager.removeEventListener(BettingAppEvent.ACTION, onAction);
			}
			super.hide();
		}
		
		private function onAction($e:BettingAppEvent):void
		{
			changeView(ScreenIds.SCREEN_ID_ADMIN_MENU, ScreenTransitionTypes.SCREEN_TRANSITION_TYPE_BACK);
		}
		
		private function onNumPadInput($e:BettingAppEvent):void
		{
			trace("key pressed=" + $e.parameters.key);
			_errorMessage.visible = false;
			
			switch($e.parameters.key)
			{
				case "Enter":
					
					if (_currentStep == 2)
					{
						WebServicesManager.instance.AddCredits(_lastEnteredVoucherId, int(_voucherId.text));
						_eventManager.addEventListener(BettingAppEvent.WEB_SERVICE_RESULT, onAddCreditsResult);
						
						// deactivate num pad while it's running.
						_numPad.deactivate();
					}
					else
					{
						// call web service to verify code.
						if (_voucherId.text.length == MAX_VOUCHER_ID_LENGTH)
						{
							// on the front end, we need to convert the "entered" id to a real voucher ID.
							// we add on some numbers to allow it to feel like a "PIN", where the format of the id's are small indeces from like 1 to 100
							var voucherId:int = int(_voucherId.text) - PIN_MIN_VALUE;
							trace("voucherId=" + voucherId);
							WebServicesManager.instance.GetVoucher(voucherId);
							_eventManager.addEventListener(BettingAppEvent.WEB_SERVICE_RESULT, onGetVoucherResult);
							
							// deactivate num pad while it's running.
							_numPad.deactivate();
						}
					}
					break;
				case "Clear":
					
					_voucherId.text = "";
					break;
				default:
					// only accept input if we're under the max allowed length.
					if (_voucherId.text.length < MAX_VOUCHER_ID_LENGTH)
					{
						_voucherId.appendText($e.parameters.key);
					}
					break;
			}
		}
		
		private function onAddCreditsResult($e:BettingAppEvent):void
		{
			_eventManager.removeEventListener(BettingAppEvent.WEB_SERVICE_RESULT, onAddCreditsResult);
			_errorMessage.visible = true;
			if ($e.parameters.result == WebServiceResults.RESULT_SUCCESS)
			{
				_errorMessage.text = "Successfully added " + _voucherId.text + " credits to PIN " + (_lastEnteredVoucherId + 1000);	
			}
			else
			{
				_errorMessage.text = "An unknown error occurred.";	
			}
			
			// reset to step 1 to allow them to add credits to another pin.
			_currentStep = 1;
			_header.text = "Step 1/2: Enter PIN you wish to add credits for";
			
			_voucherId.text = "";
			_numPad.activate();
		}
		
		private function onGetVoucherResult($e:BettingAppEvent):void
		{
			_eventManager.removeEventListener(BettingAppEvent.WEB_SERVICE_RESULT, onGetVoucherResult);
			
			if ($e.parameters.result == WebServiceResults.RESULT_SUCCESS)
			{
				var voucher:Voucher = $e.parameters.voucher;
				
				switch (AdminMenuScreen.adminMode)
				{
					case AdminModes.ADMIN_MODE_ADD_CREDITS:
						_voucherId.text = "";
						_numPad.activate();
						
						if (voucher.id > 0)
						{
							_currentStep = 2;
							_lastEnteredVoucherId = voucher.id;
							_header.text = "Step 2/2: Enter number of credits to add";
						}
						else
						{
							_errorMessage.visible = true;
							_errorMessage.text = "The PIN entered is not valid.";	
						}
						break;
					case AdminModes.ADMIN_MODE_CHECK_CREDITS:
						_voucherId.text = "";
						_numPad.activate();
						_errorMessage.visible = true;
						
						if (voucher.id > 0)
						{
							_errorMessage.text = "PIN " + (PIN_MIN_VALUE + voucher.id) + " has " + voucher.credits + " credits remaining.";
						}
						else
						{
							_errorMessage.text = "The PIN entered is not valid.";	
						}
						break;
					default:
						// if the voucher exists and we have credits remaining, allow the bet.
						if (voucher.id > 0 && voucher.credits > 0)
						{
							// voucher valid, move on.
							WebServicesManager.instance.activeBet.id = int(voucher.id);
							changeView(ScreenIds.SCREEN_ID_CHOOSE_BET_TYPE, ScreenTransitionTypes.SCREEN_TRANSITION_TYPE_FORWARD);
						}
						else
						{
							// show message on what went wrong.
							_errorMessage.visible = true;
							
							if (voucher.id == 0)
							{
								_errorMessage.text = "The PIN entered is not valid.";
							}
							else if (voucher.credits <= 0)
							{
								_errorMessage.text = "The PIN entered does not have any credits remaining.";
							}
							else
							{
								_errorMessage.text = "An unknown error occurred.";
							}
							
							// reset and reactivate num pad if voucher was entered incorrectly.
							_voucherId.text = "";
							_numPad.activate();
						}
						break;
					
				}
			}
			else
			{
				_errorMessage.visible = true;
				_errorMessage.text = "There was an unexpected error. Please try again.";
				_numPad.activate();
			}
		}
	}
}