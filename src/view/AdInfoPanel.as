/**
 * Автор: Александр Варламов
 * Дата: 06.09.2015
 */
package view
{
	import facebook.FacebookAPI;
	import facebook.facebook_data.FacebookAd;

	import feathers.controls.TabBar;
	import feathers.controls.TextInput;
	import feathers.data.ListCollection;

	import starling.display.Sprite;
	import starling.events.Event;

	import view.AdTarget.AdTargetBase;
	import view.AdTarget.ExclusionList;
	import view.AdTarget.FlexibleList;
	import view.AdTarget.InterestsList;

	public class AdInfoPanel extends Sprite
	{
		private var _textId:TextInput;

//		private var _listChange:ToggleSwitch;
//		private var _listInterests:List;

		private var _selectTabs:TabBar;
		private var _flexList:FlexibleList = new FlexibleList();
		private var _intList:InterestsList = new InterestsList();
		private var _exList:ExclusionList = new ExclusionList();
		private var _tabs:Array = [];


		private var _data:FacebookAd;

//		private var _list:ScrollContainer = new ScrollContainer();

		public function AdInfoPanel()
		{
			super();
			_tabs = [_intList, _exList, _flexList];

//			_list.layout = new HorizontalLayout();
//			_list.width = 600;
//			_list.height = 300;
//			addChild(_list);


			_selectTabs = new TabBar();
			_selectTabs.width = 450;
			_selectTabs.height = 40;
			_selectTabs.y = 42;
			_selectTabs.dataProvider = new ListCollection(
					[
						{label: "Interests"},
						{label: "Exclusions"},
						{label: "Flexible"}
					]
			);

			_selectTabs.addEventListener(Event.CHANGE, onToggle);

			addChild(_selectTabs);

			_textId = new TextInput();
			_textId.width = 600;
			_textId.height = 40;
			_textId.isEditable = false;
			addChild(_textId);

			_flexList.y = _selectTabs.y + 42;
			_flexList.visible = false;
			addChild(_flexList);
			_intList.y = _selectTabs.y + 42;
			_intList.visible = false;
			addChild(_intList);
			_exList.y = _selectTabs.y + 42;
			_exList.visible = false;
			addChild(_exList);

			addEventListener(Event.CHANGE, onChange);
		}

		public function set data(value:FacebookAd):void
		{
			_data = value;
			_textId.text = _data.id + " : " + _data.name + " : Auditory: ";
			onToggle(null);
		}

		private function onToggle(e:Event):void
		{
			for (var i:int = 0; i < _tabs.length; i++)
			{
				var object:AdTargetBase = _tabs[i];
				object.visible = false;
				if (i == _selectTabs.selectedIndex)
				{
					object.visible = true;
					object.data = _data;
				}
			}
//			_flexList.visible = _listChange.isSelected;
//			_listInterests.visible = !_listChange.isSelected;
//
//			if (!_listChange.isSelected)
//			{
//				_listInterests.dataProvider = new ListCollection(_data.interests);
//			}
//			else
//			{
//				_flexList.data = (_data);
//			}

			//_listInterests.dataProvider = _listChange.isSelected ? new ListCollection(_data.interests) : new ListCollection(_data.exclusions)
		}

		public function get data():FacebookAd
		{
			return _data;
		}


		private function onChange(e:Event):void
		{
			if (_data)
				FacebookAPI.estimateForAd(_data, estimateComplete);
		}

		private function estimateComplete(data:Object):void
		{
			_textId.text = _data.id + " : " + _data.name + " : Auditory: " + data.users;
			trace("Estimation complete.");
		}
	}
}
