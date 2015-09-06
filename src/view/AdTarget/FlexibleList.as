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

	public class FlexibleList extends AdTargetBase
	{
		private var _groupList:List;
		private var _concreteList:List;

		private var _btnAddGroup:Button;
		private var _btnRemoveGroup:Button;
		private var _btnRemoveItem:Button;
		private var _btnAddItem:Button;

		public function FlexibleList()
		{
			super();
			_groupList = new List();
			_groupList.width = 300;
			_groupList.height = 300;
			_groupList.itemRendererProperties.labelField = "name";
			_groupList.itemRendererProperties.width = 300;
			_groupList.addEventListener(Event.CHANGE, onGroupSelect);
			addChild(_groupList);

			_concreteList = new List();
			_concreteList.x = 320;
			_concreteList.width = 300;
			_concreteList.height = 300;
			_concreteList.itemRendererProperties.labelField = "name";
			_concreteList.itemRendererProperties.width = 300;
			_concreteList.addEventListener(Event.CHANGE, onItemSelect);
			addChild(_concreteList);

			_btnAddGroup = new Button();
			_btnAddGroup.label = "Add";
			_btnAddGroup.width = 148;
			_btnAddGroup.height = 40;
			_btnAddGroup.y = 302;
			_btnAddGroup.addEventListener(Event.TRIGGERED, onNeedAdd);

			_btnRemoveGroup = new Button();
			_btnRemoveGroup.label = "Remove";
			_btnRemoveGroup.width = 148;
			_btnRemoveGroup.height = 40;
			_btnRemoveGroup.y = 302;
			_btnRemoveGroup.x = 152;
			_btnRemoveGroup.addEventListener(Event.TRIGGERED, onNeedRemove);

			_btnRemoveItem = new Button();
			_btnRemoveItem.label = "Remove";
			_btnRemoveItem.width = 150;
			_btnRemoveItem.height = 40;
			_btnRemoveItem.y = 302;
			_btnRemoveItem.x = 320;
			_btnRemoveItem.addEventListener(Event.TRIGGERED, onNeedRemoveIem);

			_btnAddItem = new Button();
			_btnAddItem.label = "Add";
			_btnAddItem.width = 150;
			_btnAddItem.height = 40;
			_btnAddItem.y = 302;
			_btnAddItem.x = 470;
			_btnAddItem.addEventListener(Event.TRIGGERED, onNeedAddItem);

			addChild(_btnAddGroup);
			addChild(_btnRemoveGroup);
			addChild(_btnRemoveItem);
			addChild(_btnAddItem);
		}

		override public function set data(value:FacebookAd):void
		{
			super.data = value;
			_groupList.dataProvider = new ListCollection(value.targeting.flexible_spec);
			_concreteList.visible = false;
			_btnRemoveItem.visible = false;
		}

		private function onGroupSelect(e:Event = null):void
		{
			if (_groupList.selectedIndex > -1)
			{
				_concreteList.visible = true;
				_btnRemoveItem.visible = _concreteList.selectedIndex != -1;
				_concreteList.dataProvider = new ListCollection(_data.targeting.flexible_spec[_groupList.selectedIndex].interests)
			}
		}

		private function onItemSelect(e:Event = null):void
		{
			_btnRemoveItem.visible = _concreteList.selectedIndex != -1;
		}

		private function onNeedAdd(e:Event = null):void
		{
			_data.addFlexibleGroup();
			data = (_data);
		}

		private function onNeedRemove(e:Event = null):void
		{
			if (_groupList.selectedIndex != -1)
			{
				_data.removeFlexibleGroup(_groupList.selectedIndex);
				data = (_data);
			}
		}

		private function onNeedRemoveIem(e:Event = null):void
		{
			if (_groupList.selectedIndex != -1 && _concreteList.selectedIndex != -1)
			{
				_data.removeFlexibleInterest(_groupList.selectedIndex, _concreteList.selectedIndex);
				onGroupSelect();
				dispathChange();
			}
		}

		private function onNeedAddItem(e:Event = null):void
		{
			new SelectInterestPopUp(onFound);
		}

		private function onFound(item:Object):void
		{
			if (item && _groupList.selectedIndex != -1)
			{
				_data.addFlexibleInterest(item, _groupList.selectedIndex);
			}

			this.data = _data;
		}
	}
}
