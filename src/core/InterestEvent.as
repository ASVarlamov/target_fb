/**
 * Автор: Александр Варламов
 * Дата: 04.09.2015
 */
package core
{
	import facebook.facebook_data.FacebookInterest;

	import flash.events.Event;

	public class InterestEvent extends Event
	{
		public static const ADD:String = "add_interes";
		public static const REMOVE:String = "remove_interest";

		private var _data:FacebookInterest;

		public function InterestEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
		}

		public function get data():FacebookInterest
		{
			return _data;
		}

		public function set data(value:FacebookInterest):void
		{
			_data = value;
		}
	}
}
