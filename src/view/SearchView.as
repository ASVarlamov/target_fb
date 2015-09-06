/**
 * Автор: Александр Варламов
 * Дата: 05.09.2015
 */
package view
{
	import facebook.FacebookAPI;
	import facebook.facebook_data.FacebookInterest;

	import feathers.controls.List;
	import feathers.controls.Radio;
	import feathers.controls.TextInput;
	import feathers.core.ToggleGroup;
	import feathers.data.ListCollection;

	import starling.display.Sprite;
	import starling.events.Event;

	public class SearchView extends Sprite
	{
		private var _currentTags:ListCollection = new ListCollection([]);
		private var _currentSelectedTags:ListCollection = new ListCollection([]);
		private var _input:TextInput;
		private var _textInfo:TextInput;

		private var _tagSearchList:List;
		private var _tagSelectedList:List;

		private var _toggleGroup:ToggleGroup = new ToggleGroup();
		private var _radioAny:Radio = new Radio();
		private var _radioAll:Radio = new Radio();
		private var _radioNone:Radio = new Radio();

		public function SearchView()
		{
			super();
			_input = new TextInput();
			_input.width = 300;
			_input.height = 50;
			_input.prompt = "Enter query";
			_input.addEventListener(Event.CHANGE, onTextInput);
			addChild(_input);

			_tagSelectedList = new List();
			_tagSelectedList.y = 80;
			_tagSelectedList.width = 300;
			_tagSelectedList.height = 300;
			_tagSelectedList.itemRendererProperties.labelField = "name";
			_tagSelectedList.itemRendererProperties.width = 300;
			_tagSelectedList.dataProvider = _currentSelectedTags;
			_tagSelectedList.addEventListener(Event.CHANGE, onDeselect);
			addChild(_tagSelectedList);

			_tagSearchList = new List();
			_tagSearchList.width = 300;
			_tagSearchList.height = 300;
			_tagSearchList.itemRendererProperties.labelField = "name";
			_tagSearchList.itemRendererProperties.width = 300;
			_tagSearchList.dataProvider = _currentTags;
			_tagSearchList.addEventListener(Event.CHANGE, onSelect);
			_tagSearchList.x = 302;
			addChild(_tagSearchList);

			_radioAny.toggleGroup = _toggleGroup;
			_radioNone.toggleGroup = _toggleGroup;
			_radioAll.toggleGroup = _toggleGroup;
			_radioAny.width = _radioNone.width = _radioAll.width = 80;
			_radioAny.height = _radioNone.height = _radioAll.height = 30;
			_radioAny.label = "any";
			_radioAll.label = "all";
			_radioNone.label = "none";

			_radioAll.x = 0;
			_radioAny.x = _radioAll.width + 2;
			_radioNone.x = _radioAny.x + _radioAny.width + 2;
			_radioAny.y = _radioNone.y = _radioAll.y = 52;
			addChild(_radioAny);
			addChild(_radioAll);
			addChild(_radioNone);

			_textInfo = new TextInput();
			_textInfo.width = 300;
			_textInfo.height = 50;
			_textInfo.y = 382;
			_textInfo.text = "Estimate auditory : ";
			addChild(_textInfo);

			_toggleGroup.addEventListener(Event.CHANGE, onRadioChanged);
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
			var res:Array = [];
			for (var i:int = 0; i < results.data.length; i++)
			{
				fi = new FacebookInterest(results.data[i]);
				_currentTags.addItem(fi);
			}

		}

		private function onSelect(e:Event):void
		{
			var list:List = List(e.currentTarget);
			if (list.selectedIndex == -1)
			{
				return;
			}

			for (var i:int = 0; i < _currentSelectedTags.length; i++)
			{
				var interest:FacebookInterest = _currentSelectedTags.getItemAt(i) as FacebookInterest;
				if (interest.id == list.selectedItem.id)
				{
					return;
				}

			}
			_currentSelectedTags.addItem(list.selectedItem);
			estimateRequest();

		}

		private function onDeselect(e:Event):void
		{
			var list:List = List(e.currentTarget);

			if (list.selectedIndex == -1)
			{
				return;
			}

			_currentSelectedTags.removeItemAt(list.selectedIndex);
			estimateRequest();
		}

		private function estimateRequest():void
		{
			FacebookAPI.estimateAuditory(_currentSelectedTags.data as Array, estimateComplete, Radio(_toggleGroup.selectedItem).label);
//			var specs:Object = {};
//			specs['accountId'] = adUserId;
//
//			var targ_spec:Object = {};
//			targ_spec['age_max'] = 65;
//			targ_spec['age_min'] = 18;
//			targ_spec['geo_locations'] = {};
//			targ_spec['geo_locations']['countries'] = ['RU'];
//			targ_spec['geo_locations']['location_types'] = ['home', 'recent'];
//
//			targ_spec['interests'] = [];
//			for (var i:int = 0; i < interests.length; i++)
//			{
//				var interest:FacebookInterest = interests[i];
//				targ_spec['interests'].push({id: interest.id, name: interest.name});
//			}
//
//			specs['targeting_spec'] = targ_spec;
//
//			FacebookAPI.request(estimateMethod, specs, on_complete);
		}

		private function estimateComplete(data:Object = null):void
		{
			_textInfo.text = "Estimate auditory : " + data.users;
			trace(JSON.stringify(data));
		}

		private function onRadioChanged(e:Event):void
		{
			if (_currentSelectedTags.length == 0)
				return;

			FacebookAPI.estimateAuditory(_currentSelectedTags.data as Array, estimateComplete, Radio(_toggleGroup.selectedItem).label);
		}
	}
}
