/**
 * Автор: Александр Варламов
 * Дата: 06.09.2015
 */
package facebook.facebook_data
{
	public class FacebookInterestBase
	{

		public var id:String;
		public var name:String;

		public function FacebookInterestBase(data:Object)
		{
			id = data.id;
			name = data.name;
		}
	}
}
