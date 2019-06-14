package com.bettingapp.model.services
{
	import com.adobe.serialization.json.JSON;
	
	import com.bettingapp.controller.events.BettingAppEvent;
	import com.bettingapp.vo.Match;
	import com.bettingapp.vo.WebServiceResults;
	
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	
	public class GetPlayerNextMatchService extends WebServiceBase
	{
		public function GetPlayerNextMatchService()
		{
			super();
			
			// setup parameters exclusive to this command.
			_urlRequest.method = URLRequestMethod.GET;
			_urlRequest.url = BASE_URL + "betting/GetPlayerNextMatch";
		}
		
		protected override function onResult($e:Event):void
		{
			trace("GetPlayerNextMatch result:" + _urlLoader.data);
			
			// Flash 11 commented out as other developers are not on cs6 yet.
			//var result:Object = JSON.parse(_urlLoader.data);
			var result:Object = com.adobe.serialization.json.JSON.decode(_urlLoader.data);
	
			var event:BettingAppEvent = new BettingAppEvent(BettingAppEvent.WEB_SERVICE_RESULT);
			event.parameters.result = WebServiceResults.RESULT_SUCCESS;
			
			var match:Match = new Match();
			match.id = result.matchBet.matchId;
			match.player1 = result.matchBet.player1;
			match.player2 = result.matchBet.player2;
			event.parameters.match = match;
			_eventManager.dispatchEvent(event);	
			
			removeListeners();
	
			// straight override, no calling base class.
		}
	}
}