/**
 * Автор: Александр Варламов
 * Дата: 06.09.2015
 */
package view
{
	import facebook.FacebookAPI;
	import facebook.facebook_data.FacebookInterest;

	import feathers.controls.Button;
	import feathers.controls.List;
	import feathers.controls.TextInput;
	import feathers.data.ListCollection;

	import starling.core.Starling;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.utils.Color;

	public class SelectInterestPopUp extends Sprite
	{
		private var _input:TextInput;
		private var _itemList:List;
		private var _currentTags:ListCollection = new ListCollection([]);

		private var _buttonOk:Button;
		private var _buttonCancel:Button;

		private var _cont:Sprite = new Sprite();

		private var _callBack:Function;
		public function SelectInterestPopUp(on_finish:Function)
		{
			super();

			_callBack = on_finish;
			var black:Quad = new Quad(Starling.current.nativeStage.fullScreenWidth, Starling.current.nativeStage.fullScreenHeight, Color.WHITE);
			black.alpha = .6;
			addChild(black);

			_input = new TextInput();
			_input.width = 300;
			_input.height = 40;
			_input.prompt = "Enter interest";
			_input.addEventListener(Event.CHANGE, onTextInput);
			_cont.addChild(_input);

			_buttonCancel = new Button();
			_buttonCancel.label = "Cancel";
			_buttonCancel.width = 100;
			_buttonCancel.height = 40;
			_buttonCancel.y = 42;
			_buttonCancel.x = 0;
			_buttonCancel.addEventListener(Event.TRIGGERED, onCancel);
			_cont.addChild(_buttonCancel);

			_buttonOk = new Button();
			_buttonOk.label = "Add";
			_buttonOk.width = 100;
			_buttonOk.height = 40;
			_buttonOk.y = 42;
			_buttonOk.x = 200;
			_buttonOk.isEnabled = false;
			_buttonOk.addEventListener(Event.TRIGGERED, onOk);
			_cont.addChild(_buttonOk);

			_itemList = new List();
			_itemList.x = 300;
			_itemList.width = 300;
			_itemList.height = 300;
			_itemList.itemRendererProperties.labelField = "name";
			_itemList.itemRendererProperties.width = 300;
			_itemList.dataProvider = _currentTags;
			_itemList.addEventListener(Event.CHANGE, onItemSelect);
			_cont.addChild(_itemList);

			_cont.x = (width - _cont.width) >> 1;
			_cont.y = (height - _cont.height) >> 1;
			addChild(_cont);

			Starling.current.stage.addChild(this);
		}

		private function onTextInput(e:Event):void
		{
			FacebookAPI.request("search", {
				type: "adinterest",
				q: _input.text,
				limit: 15,
				follow_pagination: false
			}, tagsLoaded);
		}

		private function tagsLoaded(data:Object = null):void
		{
			_currentTags.removeAll();

			var results:Object = (data);
			var fi:FacebookInterest;
			for (var i:int = 0; i < results.data.length; i++)
			{
				fi = new FacebookInterest(results.data[i]);
				_currentTags.addItem(fi);
			}

		}

		private function onItemSelect(e:Event):void
		{
			_buttonOk.isEnabled = _itemList.selectedIndex != -1;
		}

		private function onOk(e:Event):void
		{
			if(_itemList.selectedIndex != -1)
			{
				_callBack && _callBack(_itemList.selectedItem);
				close();
			}
		}

		private function onCancel(e:Event):void
		{
			close();
		}

		private function close():void
		{
			this.removeFromParent();
		}
	}
}
