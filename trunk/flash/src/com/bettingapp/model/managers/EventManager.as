package com.bettingapp.model.managers
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	public class EventManager extends EventDispatcher
	{
		private static var _instance:EventManager;
		
		public function EventManager($singleton:SingletonEnforcer)
		{
			super();
		}
		
		public static function get instance():EventManager
		{
			if (EventManager._instance == null)
			{
				EventManager._instance = new EventManager(new SingletonEnforcer);
			}
			return EventManager._instance;
		}
	}
}

internal class SingletonEnforcer {}