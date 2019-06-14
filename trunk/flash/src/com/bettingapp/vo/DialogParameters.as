package com.bettingapp.vo
{
	public class DialogParameters
	{
		private var _body:String;
		private var _dialogStyle:int;
		private var _labelYes:String;
		private var _labelNo:String;
		private var _labelCancel:String;
		
		public function DialogParameters()
		{
			
			_body = "";
			_dialogStyle = DialogStyle.DIALOG_STYLE_OK; 
		}

		public function get body():String
		{
			return _body;
		}

		public function set body(value:String):void
		{
			_body = value;
		}

		public function get labelCancel():String
		{
			return _labelCancel;
		}

		public function set labelCancel(value:String):void
		{
			_labelCancel = value;
		}

		public function get labelYes():String
		{
			return _labelYes;
		}

		public function set labelYes(value:String):void
		{
			_labelYes = value;
		}

		public function get labelNo():String
		{
			return _labelNo;
		}

		public function set labelNo(value:String):void
		{
			_labelNo = value;
		}

		public function get dialogStyle():int
		{
			return _dialogStyle;
		}

		public function set dialogStyle(value:int):void
		{
			_dialogStyle = value;
		}


	}
}