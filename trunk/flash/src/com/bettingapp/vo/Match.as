package com.bettingapp.vo
{
	public class Match
	{
		private var _id:int;
		private var _player1:String;
		private var _player2:String;

		public function get id():int
		{
			return _id;
		}

		public function set id(value:int):void
		{
			_id = value;
		}

		public function get player1():String
		{
			return _player1;
		}

		public function set player1(value:String):void
		{
			_player1 = value;
		}
		
		public function get player2():String
		{
			return _player2;
		}
		
		public function set player2(value:String):void
		{
			_player2 = value;
		}

	}
}