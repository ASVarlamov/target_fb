package
{
	//341506620
	import facebook.FacebookAPI;

	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.geom.Rectangle;

	import starling.core.Starling;
	import starling.utils.Color;

	public class App extends Sprite
	{
		private var _starling:Starling;

		public function App()
		{
			Starling.handleLostContext = true;

			stage.color = Color.GRAY;
			stage.align = StageAlign.LEFT;
			stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;

			FacebookAPI.init(stage);
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}

		private function onAdded(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAdded);

			_starling = new Starling(Main, stage, new flash.geom.Rectangle(0, 0, stage.fullScreenWidth, stage.fullScreenHeight));
			_starling.start();

		}
	}
}
