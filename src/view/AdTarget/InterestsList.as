/**
 * Автор: Александр Варламов
 * Дата: 06.09.2015
 */
package view.AdTarget
{
	import facebook.facebook_data.FacebookAd;

	import feathers.controls.Button;
	import feathers.controls.List;
	import feathers.data.ListCollection;

	import starling.events.Event;

	import view.SelectInterestPopUp;

	public class InterestsList extends AdTargetBase
	{
		private var _itemList:List;
		private var _btnRemoveItem:Button;
		private var _btnAddItem:Button;

		public function InterestsList()
		{
			super();

			_itemList = new List();
			_itemList.width = 300;
			_itemList.height = 300;
			_itemList.itemRendererProperties.labelField = "name";
			_itemList.itemRendererProperties.width = 300;
			_itemList.addEventListener(Event.CHANGE, onItemSelect);
			addChild(_itemList);


			_btnRemoveItem = new Button();
			_btnRemoveItem.label = "Remove";
			_btnRemoveItem.width = 150;
			_btnRemoveItem.height = 40;
			_btnRemoveItem.y = 302;
			_btnRemoveItem.x = 0;
			_btnRemoveItem.addEventListener(Event.TRIGGERED, onNeedRemoveIem);
			addChild(_btnRemoveItem);

			_btnAddItem = new Button();
			_btnAddItem.label = "Add";
			_btnAddItem.width = 150;
			_btnAddItem.height = 40;
			_btnAddItem.y = 302;
			_btnAddItem.x = 150;
			_btnAddItem.addEventListener(Event.TRIGGERED, onNeedAdd);
			addChild(_btnAddItem);
		}

		private function onItemSelect(e:Event):void
		{
			_btnRemoveItem.visible = _itemList.selectedIndex != -1;
		}

		private function onNeedRemoveIem(e:Event = null):void
		{
			if (_itemList.selectedIndex != -1)
			{
				_data.removeInterest(_itemList.selectedItem.id);
			}
			this.data = _data;
		}

		private function onNeedAdd(e:Event = null):void
		{
			new SelectInterestPopUp(onFound);
		}

		private function onFound(item:Object):void
		{
			if (item)
			{
				_data.addInterest(item);
			}

			this.data = _data;
		}

		override public function set data(value:FacebookAd):void
		{
			super.data = value;
			_itemList.dataProvider = new ListCollection(_data.interests);
			_btnRemoveItem.visible = false;
		}
	}
}
