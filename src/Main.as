/**
 * Автор: Александр Варламов
 * Дата: 05.09.2015
 */
package
{
	import facebook.FacebookAPI;
	import facebook.facebook_data.FacebookAd;

	import feathers.controls.Button;
	import feathers.controls.PickerList;
	import feathers.controls.TextInput;
	import feathers.controls.popups.DropDownPopUpContentManager;
	import feathers.data.ListCollection;
	import feathers.themes.MetalWorksMobileTheme;

	import starling.display.Sprite;
	import starling.events.Event;

	import view.AdInfoPanel;

	public class Main extends Sprite
	{
//		private var _searchView:SearchView;
		private var _btnLogin:Button;
		private var _btnSave:Button;
		private var _inputAdAccId:TextInput;

		private var _adsList:PickerList;
		private var _adInfo:AdInfoPanel;

		public function Main()
		{
			super();
			new MetalWorksMobileTheme();

			_adInfo = new AdInfoPanel();
			_adInfo.y = 50;

			_inputAdAccId = new TextInput();
			_inputAdAccId.width = 100;
			_inputAdAccId.height = 40;
			_inputAdAccId.text = "341506620";
			addChild(_inputAdAccId);

			_btnLogin = new Button();
			_btnLogin.width = 100;
			_btnLogin.height = 40;
			_btnLogin.y = 40;
			_btnLogin.label = "Login";
			addChild(_btnLogin);

			_btnLogin.addEventListener(Event.TRIGGERED, onLoginTriggered);
		}

		private function onLoginTriggered(e:Event):void
		{
			_btnLogin.visible = false;
			FacebookAPI.adUserId = _inputAdAccId.text;
			FacebookAPI.login(onLoginComplete);
		}

		private function onLoginComplete(data:Object = null):void
		{
			FacebookAPI.getToken(onTokenReceived);
		}

		private function onTokenReceived(data:Object = null):void
		{
			FacebookAPI.getAdCampaigns(adsReceived);
		}

		private function adsReceived(data:Object = null):void
		{
			var ads:Array = [];
			for (var i:int = 0; i < data.data.length; i++)
			{
				ads.push(new FacebookAd(data.data[i]));
			}

			_adsList = new PickerList();
			_adsList.popUpContentManager = new DropDownPopUpContentManager();
			_adsList.labelField = "name";
			_adsList.width = 300;
			_adsList.prompt = "Select ad group...";
			_adsList.listProperties.@itemRendererProperties.labelField = "name";
			_adsList.dataProvider = new ListCollection(ads);
			_adsList.selectedIndex = -1;
			_adsList.addEventListener(Event.CHANGE, onAdSelect);
			addChild(_adsList);

			_btnSave = new Button();
			_btnSave.width = 80;
			_btnSave.height = 40;
			_btnSave.label = "save";
			_btnSave.addEventListener(Event.TRIGGERED, onNeedSave);
			_btnSave.x = 304;
			addChild(_btnSave);

			_adInfo.visible = false;
			addChild(_adInfo);
		}

		private function onAdSelect(e:Event):void
		{
			var list:PickerList = PickerList(e.currentTarget);
			if (list && list.selectedIndex > -1)
			{
				_adInfo.visible = true;
				_adInfo.data = list.selectedItem as FacebookAd;
			}
			else
			{
				_adInfo.visible = false;
			}
		}

		private function onNeedSave(e:Event):void
		{
			if (_adInfo.data)
			{
				FacebookAPI.saveAd(_adInfo.data, adSaved);
			}
		}

		private function adSaved(data:Object = null):void
		{
			trace("Save complete: " + JSON.stringify(data));
		}
	}
}
