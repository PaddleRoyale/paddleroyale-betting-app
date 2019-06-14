package com.bettingapp.view.screens
{
	import com.bettingapp.controller.events.BettingAppEvent;
	import com.bettingapp.model.managers.EventManager;
	import com.bettingapp.model.managers.WebServicesManager;
	import com.bettingapp.view.controls.ActionBar;
	import com.bettingapp.view.controls.Ballot;
	import com.bettingapp.view.controls.BallotButton;
	import com.bettingapp.view.controls.SearchBox;
	import com.bettingapp.view.dialogs.BaseDialog;
	import com.bettingapp.view.dialogs.ConfirmBetDialog;
	import com.bettingapp.view.dialogs.ConfirmPlayerMatchBetDialog;
	import com.bettingapp.vo.BetTypes;
	import com.bettingapp.vo.DialogResult;
	import com.bettingapp.vo.Player;
	import com.bettingapp.vo.ScreenIds;
	import com.bettingapp.vo.ScreenTransitionTypes;
	import com.bettingapp.vo.WebServiceResults;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.text.TextField;
	
	public class SelectPlayerScreen extends BaseScreen
	{
		private var _container:Ballot;
		private var _candidates:Array;
		private var _header:TextField;
		private var _searchBox:SearchBox;
		private var _isMatchBet:Boolean;
		private var _pagingInfo:MovieClip;
		
		public function SelectPlayerScreen()
		{
			super();
		}
		
		public override function init():void
		{
			_container = mc_container;
			_searchBox = mc_searchBox;
			_header = txt_header;
			_pagingInfo = mc_pagingInfo;
			_candidates = new Array();
			super.init();
		}
		
		protected override function onAddedToStage($e:Event):void
		{
			super.onAddedToStage($e);
		}
		
		public override function show():void
		{
			super.show();
			
			_isMatchBet = (WebServicesManager.instance.activeBet.type == BetTypes.BET_TYPE_MATCH);
			
			if (_isMatchBet)
			{
				_header.text = "Select a player to bet on to win their next match";
			}
			else
			{
				_header.text = "Select a player to bet on to win the tournament";
			}
			
			_eventManager.addEventListener(BettingAppEvent.CANDIDATE_SELECTED, onCandidateSelected);
			_eventManager.addEventListener(BettingAppEvent.REFRESH_CONTENT, onRefreshContent);
			_eventManager.addEventListener(BettingAppEvent.ACTION, onAction);
			_eventManager.addEventListener(BettingAppEvent.UPDATE_PAGING_INFO, onUpdatePageInfo);
			_searchBox.enabled = _container.enabled = true;
			getPlayers();
		}
		
		protected override function showActionBar($filter:int = 0):void
		{
			super.showActionBar(ActionBar.BACK_BUTTON | ActionBar.PAGE_NEXT_BUTTON | ActionBar.PAGE_PREV_BUTTON);
		}
		
		public override function hide():void 
		{
			_eventManager.removeEventListener(BettingAppEvent.CANDIDATE_SELECTED, onCandidateSelected);
			_eventManager.removeEventListener(BettingAppEvent.REFRESH_CONTENT, onRefreshContent);
			_eventManager.removeEventListener(BettingAppEvent.ACTION, onAction);
			_eventManager.removeEventListener(BettingAppEvent.UPDATE_PAGING_INFO, onUpdatePageInfo);
			_searchBox.enabled = _container.enabled = false;
			super.hide();
		}
		
		private function onUpdatePageInfo($e:BettingAppEvent):void
		{
			trace("onUpdatePageInfo");
			if (int($e.parameters.numPages) == 0)
			{
				_pagingInfo.visible = false;
			}
			else
			{
				_pagingInfo.visible = true;
				var pagingInfo:TextField = _pagingInfo.txt_pagingInfo as TextField; 
				pagingInfo.text = "Page " + $e.parameters.currentPage + " of " + $e.parameters.numPages;
			}
		}
		
		private function onCandidateSelected($e:BettingAppEvent):void
		{
			var chosenCandidate:BallotButton = $e.parameters.candidate as BallotButton;
			var dialog:BaseDialog;
			
			if (_isMatchBet)
			{
				trace("chosenCandidate=" + chosenCandidate);
				trace("label=" + chosenCandidate.label);
				trace("id=" + chosenCandidate.id);
				dialog = new ConfirmPlayerMatchBetDialog(chosenCandidate.label, chosenCandidate.id);
			}
			else
			{
				dialog = new ConfirmBetDialog(chosenCandidate.label, chosenCandidate.id);
			}
			
			dialog.open(this);
			_eventManager.addEventListener(BettingAppEvent.DIALOG_RESULT, onDialogResult);
		}
		
		
		private function onRefreshContent($e:BettingAppEvent):void
		{
			// every time we are told to refresh the list, we reset the current page.
			_container.doLayout(Ballot.RESET_PAGE, String($e.parameters.filter));
		}
		
		private function onDialogResult($e:BettingAppEvent):void
		{
			_eventManager.removeEventListener(BettingAppEvent.DIALOG_RESULT, onDialogResult);
			
			if ($e.parameters.result == DialogResult.DIALOG_RESULT_YES)
			{
				WebServicesManager.instance.activeBet.value = $e.parameters.id;
				_eventManager.addEventListener(BettingAppEvent.WEB_SERVICE_RESULT, onPlaceBetResult);
				WebServicesManager.instance.PlaceBet();
			}
		}
		
		private function onPlaceBetResult($e:BettingAppEvent):void
		{
			_eventManager.removeEventListener(BettingAppEvent.WEB_SERVICE_RESULT, onPlaceBetResult);
			if ($e.parameters.result == WebServiceResults.RESULT_SUCCESS && $e.parameters.betPlaced)
			{
				// success.
			}
			else
			{
				// fail
			}
			changeView(ScreenIds.SCREEN_ID_BET_CONFIRMATION, ScreenTransitionTypes.SCREEN_TRANSITION_TYPE_FORWARD);
		}
		
		protected function getPlayers():void
		{
			_pagingInfo.visible = false;
			_container.reset();
			
			// go out and retrieve list of agencies.
			WebServicesManager.instance.GetPlayers();
			_eventManager.addEventListener(BettingAppEvent.WEB_SERVICE_RESULT, onGetPlayersResult);
		}
		
		private function onGetPlayersResult($e:BettingAppEvent):void
		{
			trace("onGetPlayersResult");
			_eventManager.removeEventListener(BettingAppEvent.WEB_SERVICE_RESULT, onGetPlayersResult);
			
			if ($e.parameters.result == WebServiceResults.RESULT_SUCCESS)
			{
				var ballotButton:BallotButton;
				
				for each (var player:Player in $e.parameters.players)
				{
					ballotButton = new BallotButton(player.firstName + " '" + player.nickname + "' " + player.lastName, player.id);
					_container.candidates.push(ballotButton);
				}
			}
			
			// refresh screen to show the agencies.
			_container.doLayout();
		}
		
		protected function onAction($e:BettingAppEvent):void
		{
			switch ($e.parameters.action)
			{
				case ActionBar.BACK_BUTTON:
					changeView(ScreenIds.SCREEN_ID_CHOOSE_BET_TYPE, ScreenTransitionTypes.SCREEN_TRANSITION_TYPE_BACK);
					break;
				case ActionBar.PAGE_NEXT_BUTTON:
					_container.doLayout(Ballot.NEXT_PAGE);
					break;
				case ActionBar.PAGE_PREV_BUTTON:
					_container.doLayout(Ballot.PREV_PAGE);
					break;
			}
			
			// straight override, no base class.
		}
	}
}