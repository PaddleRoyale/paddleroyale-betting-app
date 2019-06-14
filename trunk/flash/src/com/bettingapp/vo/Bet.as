package com.bettingapp.vo
{
	public class Bet
	{
		private var _id:int;
		private var _type:int;
		private var _value:int;
		
		public function reset():void
		{
			_id = 0;
			_type = BetTypes.BET_TYPE_AGENCY;
			_value = -1;
		}
		
		public function get id():int
		{
			return _id;
		}

		public function set id(value:int):void
		{
			_id = value;
		}

		public function get type():int
		{
			return _type;
		}

		public function set type(value:int):void
		{
			_type = value;
		}

		public function get value():int
		{
			return _value;
		}

		public function set value(value:int):void
		{
			_value = value;
		}


	}
}