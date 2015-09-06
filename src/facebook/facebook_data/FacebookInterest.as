/**
 * Автор: Александр Варламов
 * Дата: 03.09.2015
 */
package facebook.facebook_data
{
	public class FacebookInterest extends FacebookInterestBase
	{
		public var audienceSize:Number;
		public var path:Array;
		public var description:String;

		public function FacebookInterest(data:Object)
		{
			super(data);
			description = data.description;
			audienceSize = data.audience_size;
			path = data.path;
		}
	}
}
