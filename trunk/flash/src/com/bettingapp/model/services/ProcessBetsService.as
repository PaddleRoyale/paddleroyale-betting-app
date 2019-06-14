package com.bettingapp.model.services
{
	import com.adobe.serialization.json.JSON;
	import com.bettingapp.controller.events.BettingAppEvent;
	import com.bettingapp.vo.WebServiceResults;
	
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	
	public class ProcessBetsService extends WebServiceBase
	{
		public function ProcessBetsService()
		{
			super();
			
			// setup parameters exclusive to this command.
			_urlRequest.method = URLRequestMethod.GET;
			_urlRequest.url = BASE_URL + "betting/ProcessBets";
		}
		
		protected override function onResult($e:Event):void
		{
			trace("ProcessBets result:" + _urlLoader.data);
			
			// Flash 11 commented out as other developers are not on cs6 yet.
			//var result:Object = JSON.parse(_urlLoader.data);
			var result:Object = com.adobe.serialization.json.JSON.decode(_urlLoader.data);
	
			var event:BettingAppEvent = new BettingAppEvent(BettingAppEvent.WEB_SERVICE_RESULT);
			event.parameters.result = Boolean(result.Result) ? WebServiceResults.RESULT_SUCCESS : WebServiceResults.RESULT_FAIL;
			_eventManager.dispatchEvent(event);	
			
			removeListeners();
	
			// straight override, no calling base class.
		}
	}
}