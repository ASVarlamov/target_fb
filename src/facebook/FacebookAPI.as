/**
 * �����: ��������� ��������
 * ����: 03.09.2015
 */
package facebook
{
	import facebook.facebook_data.FacebookAd;
	import facebook.facebook_data.FacebookInterest;

	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.geom.Rectangle;
	import flash.media.StageWebView;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;

	public class FacebookAPI
	{
		public static var graphUrl:String = "https://graph.facebook.com/v2.4/"; // link to graph

		public static var appId:String = "502566206579539"; //app id (built-in)
//		public static var appId:String = "1466141670357591"; //app id (built-in)
//		public static var appSecret:String = "0769dcca3c145439492a0d12da95690c"; //app secret key (built-in)
		public static var appSecret:String = "6700419d24d45abaa32aaaa830254cea"; //app secret key (built-in)

		private static var _adUserId:String = "341506620"; // user id from ad manager (built-in)
		private static var _adUserStr:String;

		public static var appCode:String; //login key (via request)
		public static var appToken:String; //access_token (via request)

		private static var _stage:Stage;
		private static var _webView:StageWebView;

		public function FacebookAPI()
		{
		}

		public static function init(stage:Stage):void
		{
			_stage = stage;
		}

		public static function login(on_complete:Function):void
		{
			_webView = new StageWebView();
			_webView.stage = _stage;
			_webView.viewPort = new Rectangle(0, 0, 600, 300);
			_webView.addEventListener("complete", locationChange);
			_webView.loadURL(getFacebookLoginUrl(appId));

			function locationChange(e:Object = null):void
			{
				var new_location:String = _webView.location;
				if (new_location.indexOf("facebook.com/connect/login_success.html?code=") > 0)
				{
					var code_begin:int = new_location.indexOf("code=") + 5;
					var code_ends:int = new_location.indexOf("#_");
					appCode = new_location.substr(code_begin, code_ends - code_begin);
					_webView.dispose();
					on_complete && on_complete(appCode);
				}
			}
		}

		public static function getToken(on_complete:Function):void
		{
			trace("Begin request: " + getFacebookOauthUrl(appCode, appId, appSecret));
			var url_req:URLRequest = new URLRequest(getFacebookOauthUrl(appCode, appId, appSecret));
			url_req.method = URLRequestMethod.GET;

			var urlLoader:URLLoader;
			urlLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, onComplete);
			urlLoader.load(url_req);

			function onComplete(e:Event):void
			{
				var data:Object = JSON.parse(e.currentTarget.data as String);
				appToken = data.access_token;
				on_complete && on_complete(appToken);
			}
		}

		public static function loadMe(on_complete:Function):void
		{
			request("me", {}, on_complete);
		}


		public static function request(method:String, params:Object, on_complete:Function, req_method:String = URLRequestMethod.GET):void
		{
			params = generateParams(params);
			var url:String = graphUrl + method + "?";
			var i:int = 0;

			for (var key:String in params)
			{
				if (i != 0) url += "&";

				if (!(params[key] is String))
					url += key + "=" + JSON.stringify(params[key]);
				else
					url += key + "=" + params[key];

				i++;
			}

			var url_req:URLRequest = new URLRequest(url);
			url_req.method = req_method;

			var urlLoader:URLLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, onComplete);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, onError);
			urlLoader.load(url_req);
			trace("Begin request: " + url);

			function onComplete(e:Event):void
			{
				trace("Request complete " + method + " : " + URLLoader(e.target).data);
				on_complete && on_complete(JSON.parse(URLLoader(e.target).data));
			}

			function onError(e:IOErrorEvent):void
			{
				trace("Request failed " + method + " : " + URLLoader(e.target).data);
			}
		}

		public static function get estimateMethod():String
		{
			return "act_" + adUserId + "/reachestimate";
		}

		public static function estimateForAd(ad_info:FacebookAd, on_complete:Function):void
		{
			var specs:Object = {};
			specs['accountId'] = adUserId;
			specs['targeting_spec'] = ad_info.targeting;

			FacebookAPI.request(estimateMethod, specs, on_complete);
		}

		public static function estimateAuditory(interests:Array, on_complete:Function, condition:String):void
		{
			var cond:Object = {any: generateAny, none: generateNone, all: generateAll};
			var curren_type:Function = cond[condition];

			var specs:Object = {};
			specs['accountId'] = adUserId;
			specs['targeting_spec'] = curren_type(interests);

			FacebookAPI.request(estimateMethod, specs, on_complete);
		}

		private static function generateAny(interests:Array):Object
		{
			var res:Object = {};
			res['page_types'] = ['rightcolumn'];
			res['exclusions'] = {};
			res['flexible_spec'] = [];
			res['interests'] = [];
			for (var i:int = 0; i < interests.length; i++)
			{
				var interest:FacebookInterest = interests[i];
				res['interests'].push({id: interest.id, name: interest.name});
			}
			res['age_min'] = 18;
			res['age_max'] = 65;
			res['geo_locations'] = {countries: ['RU']};

			return res;
		}

		private static function generateNone(interests:Array):Object
		{
			var res:Object = {};
			res['page_types'] = ['rightcolumn'];
			res['exclusions'] = {};
			res['flexible_spec'] = [];
			res['interests'] = [];
			res['exclusions'] = {interests: []};

			for (var i:int = 0; i < interests.length; i++)
			{
				var interest:FacebookInterest = interests[i];
				res['exclusions']['interests'].push({id: interest.id, name: interest.name});
			}

			res['age_min'] = 18;
			res['age_max'] = 65;
			res['geo_locations'] = {countries: ['RU']};

			return res;
		}

		private static function generateAll(interests:Array):Object
		{
			var res:Object = {};
			res['page_types'] = ['rightcolumn'];
			res['exclusions'] = {};
			res['flexible_spec'] = [];
			res['interests'] = [];

			for (var i:int = 0; i < interests.length; i++)
			{
				var interest:FacebookInterest = interests[i];
				res['flexible_spec'].push({interests: [{id: interest.id, name: interest.name}]});
			}

			res['age_min'] = '18';
			res['age_max'] = '65';
			res['geo_locations'] = {countries: ['RU']};

			return res;
		}

		public static function saveAd(f_ad:FacebookAd, on_complete:Function):void
		{
			request(f_ad.id, f_ad.toSaveObject(), on_complete, URLRequestMethod.POST);
		}

		public static function getAdCampaigns(on_complete:Function):void
		{
			request(_adUserStr + "/adcampaigns", {fields:"id,name,targeting"}, onReceived);
			function onReceived(data:Object = null):void
			{
				on_complete && on_complete(data);
			}
		}

		public static function readCampaign(id:String):void
		{
			request(id, {fields:"id,name,targeting"}, onReceived);
			function onReceived(data:Object = null):void
			{
				trace("ok");
			}
		}

		public static function changeAd(interests:Array, on_complete:Function, condition:String):void
		{
			var cond:Object = {any: generateAny, none: generateNone, all: generateAll};
			var curren_type:Function = cond[condition];

			var specs:Object = {};
			specs['accountId'] = adUserId;
			specs['targeting_spec'] = curren_type(interests);

			FacebookAPI.request(estimateMethod, specs, on_complete);
		}

		public static function generateParams(obj:Object):Object
		{
			obj["access_token"] = appToken;
			return obj;
		}

		public static function get adUserId():String
		{
			return _adUserId;
		}

		public static function set adUserId(value:String):void
		{
			_adUserId = value;
			_adUserStr = "act_" + value;
		}

		public static const FACEBOOK_REDIRECT:String = "https://www.facebook.com/connect/login_success.html";

		private static var _facebookLoginUrl:String = "https://graph.facebook.com/v2.4/oauth/authorize?client_id={AID}&redirect_uri={RU}&scope=ads_read,ads_management";
		private static var _facebookOauthUrl:String = "https://graph.facebook.com/v2.4/oauth/access_token?client_id={AID}&redirect_uri={RU}&client_secret={AS}&code={C}&scope=ads_read,ads_management";

		public static function getFacebookLoginUrl(app_id:String, redir:String = null):String
		{
			if (!redir) redir = FACEBOOK_REDIRECT;

			return _facebookLoginUrl.replace("{AID}", app_id).replace("{RU}", redir);
		}

		public static function getFacebookOauthUrl(app_code:String, app_id:String, app_secret:String, redir:String = null):String
		{
			if (!redir) redir = FACEBOOK_REDIRECT;

			return _facebookOauthUrl.replace("{AID}", app_id).replace("{RU}", redir).replace("{AS}", app_secret).replace("{C}", app_code);

		}
	}
}
