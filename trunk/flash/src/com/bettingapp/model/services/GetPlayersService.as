package com.bettingapp.model.services
{
	import com.adobe.serialization.json.JSON;
	import com.bettingapp.controller.events.BettingAppEvent;
	import com.bettingapp.model.managers.WebServicesManager;
	import com.bettingapp.vo.Agency;
	import com.bettingapp.vo.BetTypes;
	import com.bettingapp.vo.Player;
	import com.bettingapp.vo.WebServiceResults;
	
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	
	public class GetPlayersService extends WebServiceBase
	{
		public function GetPlayersService()
		{
			super();
			
			// setup parameters exclusive to this command.
			_urlRequest.method = URLRequestMethod.GET;
			
			// run a modified query if we are dealing with match bets
			if (WebServicesManager.instance.activeBet.type == BetTypes.BET_TYPE_MATCH)
			{
				_urlRequest.url = BASE_URL + "betting/GetPlayersWithMatches";
			}
			else
			{
				_urlRequest.url = BASE_URL + "betting/GetPlayers";
			}
		}
		
		protected override function onResult($e:Event):void
		{
			trace(_urlLoader.data);
			
			// Flash 11 commented out as other developers are not on cs6 yet.
			//var result:Object = JSON.parse(_urlLoader.data);
			var result:Object = com.adobe.serialization.json.JSON.decode(_urlLoader.data);
			
			var players:Array = new Array();
			
			for each (var player:Object in result.Players)
			{
				var newPlayer:Player = new Player();
				newPlayer.id = int(player.id);
				newPlayer.firstName = String(player.firstName);
				newPlayer.lastName = String(player.lastName);
				newPlayer.nickname = String(player.nickname);
				newPlayer.agency.id = int(player.agencyId);
				newPlayer.agency.name = String(player.agencyName);
				players.push(newPlayer);
			}
			
			var event:BettingAppEvent = new BettingAppEvent(BettingAppEvent.WEB_SERVICE_RESULT);
			event.parameters.result = WebServiceResults.RESULT_SUCCESS;
			event.parameters.players = players;
			_eventManager.dispatchEvent(event);	
			
			removeListeners();
	
			// straight override, no calling base class.
		}
	}
}