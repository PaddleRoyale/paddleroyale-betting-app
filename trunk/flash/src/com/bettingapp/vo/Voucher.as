package com.bettingapp.vo
{
	public class Voucher
	{
		private var _id:int;
		private var _credits:int;
		private var _winnings:int;

		public function get winnings():int
		{
			return _winnings;
		}

		public function set winnings(value:int):void
		{
			_winnings = value;
		}

		public function get credits():int
		{
			return _credits;
		}

		public function set credits(value:int):void
		{
			_credits = value;
		}

		public function get id():int
		{
			return _id;
		}

		public function set id(value:int):void
		{
			_id = value;
		}

	}
}