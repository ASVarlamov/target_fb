/**
 * Автор: Александр Варламов
 * Дата: 06.09.2015
 */
package view.AdTarget
{
	import facebook.facebook_data.FacebookAd;

	import starling.display.Sprite;
	import starling.events.Event;

	public class AdTargetBase extends Sprite
	{
		protected var _data:FacebookAd;

		public function AdTargetBase()
		{
			super();
		}

		public function get data():FacebookAd
		{
			return _data;
		}

		public function set data(value:FacebookAd):void
		{
			_data = value;
			dispathChange();
		}

		public function dispathChange():void
		{
			if(parent) parent.dispatchEvent(new Event(Event.CHANGE));
		}
	}
}
