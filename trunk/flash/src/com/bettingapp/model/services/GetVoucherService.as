package com.bettingapp.model.services
{
	import com.adobe.serialization.json.JSON;
	
	import com.bettingapp.controller.events.BettingAppEvent;
	import com.bettingapp.vo.Voucher;
	import com.bettingapp.vo.WebServiceResults;
	
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	
	public class GetVoucherService extends WebServiceBase
	{
		public function GetVoucherService()
		{
			super();
			
			// setup parameters exclusive to this command.
			_urlRequest.method = URLRequestMethod.GET;
			_urlRequest.url = BASE_URL + "betting/GetVoucher";
		}
		
		protected override function onResult($e:Event):void
		{
			trace(_urlLoader.data);
			
			// Flash 11 commented out as other developers are not on cs6 yet.
			//var result:Object = JSON.parse(_urlLoader.data);
			var result:Object = com.adobe.serialization.json.JSON.decode(_urlLoader.data);
			
			var voucher:Voucher = new Voucher();
			voucher.id = int(result.Voucher.id);
			voucher.credits = int(result.Voucher.credits);
			voucher.winnings = int(result.Voucher.winnings);
			
			trace("voucher id = " + voucher.id);
			
			var event:BettingAppEvent = new BettingAppEvent(BettingAppEvent.WEB_SERVICE_RESULT);
			event.parameters.result = WebServiceResults.RESULT_SUCCESS;
			event.parameters.voucher = voucher;
			_eventManager.dispatchEvent(event);	
			
			removeListeners();
	
			// straight override, no calling base class.
		}
	}
}