package com.bettingapp.vo
{
	public class Player
	{
		private var _id:int;
		private var _firstName:String;
		private var _lastName:String;
		private var _nickname:String;
		private var _agency:Agency = new Agency();
		
		public function get id():int
		{
			return _id;
		}

		public function set id(value:int):void
		{
			_id = value;
		}

		public function get firstName():String
		{
			return _firstName;
		}

		public function set firstName(value:String):void
		{
			_firstName = value;
		}

		public function get lastName():String
		{
			return _lastName;
		}

		public function set lastName(value:String):void
		{
			_lastName = value;
		}

		public function get nickname():String
		{
			return _nickname;
		}

		public function set nickname(value:String):void
		{
			_nickname = value;
		}

		public function get agency():Agency
		{
			return _agency;
		}


	}
}