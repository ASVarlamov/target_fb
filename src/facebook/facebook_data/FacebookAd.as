/**
 * Автор: Александр Варламов
 * Дата: 06.09.2015
 */
package facebook.facebook_data
{
	public dynamic class FacebookAd
	{
		public var id:String;
		public var name:String;

		//https://developers.facebook.com/docs/marketing-api/targeting-specs/v2.4
		public var targeting:Object;

		/**
		 * ATTENTION: For ad set allowed either interests or (flexible_spec + exclusion)
		 *
		 * @param data
		 */
		public function FacebookAd(data:Object)
		{
			id = data.id;
			name = data.name;
			targeting = data.targeting;
		}

		public function get interests():Array
		{
			return targeting.interests;
		}

		public function get exclusions():Array
		{
			if (targeting && targeting.exclusions)
			{
				return targeting.exclusions.interests;
			}

			targeting.exclusions = {};
			targeting.exclusions.interests = [];

			return targeting.exclusions.interests;
		}

		public function updateInterests(inter_list:Array/*of FacebookInterest*/):void
		{
			if (targeting)
			{
				var interests:Array = [];
				for (var i:int = 0; i < inter_list.length; i++)
				{
					var inter:FacebookInterestBase = inter_list[i];
					interests.push({id: inter.id, name: inter.name});
				}
				targeting["interests"] = interests;
			}
		}

		public function addInterest(inter:Object):void
		{
			if (targeting)
			{
				if (targeting.interests && targeting.interests is Array)
				{
					for (var i:int = 0; i < targeting.interests.length; i++)
					{
						var interest:Object = targeting.interests[i];
						if (interest.id == inter.id)
						{
							return;
						}
					}
					targeting.interests.push({id: inter.id, name: inter.name});
				}
				else
				{
					targeting.interests = [{id: inter.id, name: inter.name}];
				}
			}
		}

		public function removeInterest(id:String):void
		{
			if (targeting)
			{
				if (targeting.interests && targeting.interests is Array)
				{
					for (var i:int = 0; i < targeting.interests.length; i++)
					{
						var interest:Object = targeting.interests[i];
						if (interest.id == id)
						{
							targeting.interests.splice(i, 1);
							return;
						}
					}
				}
			}
		}

		public function addFlexibleInterest(inter:Object, group_index:int = 0):void
		{
			if (!targeting.flexible_spec)
			{
				targeting.flexible_spec = [{interests: []}];
			}

			if (targeting.flexible_spec.length > group_index)
			{
				targeting.flexible_spec[group_index].interests.push({id: inter.id, name: inter.name});
			}
			else
			{
				targeting.flexible_spec[0].interests.push({id: inter.id, name: inter.name});
			}
		}


		public function removeFlexibleInterest(group_index:int, int_index:int):void
		{
			if (!targeting.flexible_spec)
				return;

			if (targeting.flexible_spec.length > group_index)
			{
				var interests:Array = targeting.flexible_spec[group_index].interests;
				if (interests.length > int_index)
				{
					interests.splice(int_index, 1);
				}
			}
		}

		public function addFlexibleGroup(gr:Object = null):void
		{
			if (!targeting.flexible_spec)
			{
				targeting.flexible_spec = [];
			}

			if (gr)
			{
				targeting.flexible_spec.push(gr);
			}
			else
			{
				targeting.flexible_spec.push({interests: []});
			}
		}

		public function removeFlexibleGroup(index:int):void
		{
			if (!targeting.flexible_spec)
				return;

			if (targeting.flexible_spec.length > index)
			{
				targeting.flexible_spec.splice(index, 1);
			}
		}

		public function updateExclusions(inter_list:Array/*of FacebookInterest*/):void
		{
			if (targeting)
			{
				targeting['exclusions'] = {interests: []};
				var interests:Array = [];
				for (var i:int = 0; i < inter_list.length; i++)
				{
					var inter:FacebookInterestBase = inter_list[i];
					interests.push({id: inter.id, name: inter.name});
				}
				targeting['exclusions']['interests'] = interests;
			}
		}

		public function addExclusion(ex_add:Object):void
		{
			if (targeting)
			{
				if (!targeting.exclusions) targeting.exclusions = {interests: []};
				if (!targeting.exclusions.interests) targeting.exclusions.interests = [];

				for (var i:int = 0; i < targeting.exclusions.interests.length; i++)
				{
					var ex:Object = targeting.exclusions.interests[i];
					if (ex.id == ex_add.id)
					{
						return;
					}
				}
				targeting.exclusions.interests.push({id: ex_add.id, name: ex_add.name});
			}
		}

		public function removeExclusion(ex_remove:String):void
		{
			if (targeting)
			{
				if (targeting.exclusions && targeting.exclusions.interests)
				{
					for (var i:int = 0; i < targeting.exclusions.interests.length; i++)
					{
						var ex:Object = targeting.exclusions.interests[i];
						if (ex.id == ex_remove)
						{
							targeting.exclusions.interests.splice(i, 1);
							return;
						}
					}
				}
			}
		}

		public function toSaveObject():Object
		{
			if (targeting.flexible_spec && targeting.flexible_spec.interests && targeting.flexible_spec.interests.length == 0)
			{
				delete targeting.flexible_spec["interests"];
			}

			if (targeting.exclusions && targeting.exclusions.interests && targeting.exclusions.interests.length == 0)
			{
				delete targeting.exclusions["interests"];
			}

			if (targeting.interests && targeting.interests.length == 0)
			{
				delete targeting["interests"];
			}

			return {targeting: targeting};
		}


	}


	/*
		6030224865424 : {
			"id": "6030224865424",
			"name": "to-dance.ru - \u041a\u043b\u0438\u043a\u0438 \u043d\u0430 \u0432\u0435\u0431-\u0441\u0430\u0439\u0442",
			"targeting":
				{
			        "age_max": 50,
					"age_min": 16,
					"genders": [2],
					"geo_locations":
					{
						"cities": [{"country": "RU","distance_unit": "kilometer","key": "1997692","name": "Krasnoyarsk","radius": 70,"region": "Krasnoyarsk Krai","region_id": "3138"}],
				        "location_types": ["home","recent"]
					},
		            "interests": [
		                {
							"id": "6003223575158",
							"name": "Dirty Dancing"
						},
				        {
							"id": "6003299352701",
							"name": "Flashdance"
						},
						{
							"id": "6003423342191",
							"name": "Dance"
						}
			  ],
			  "page_types": ["rightcolumn"]
		}
	}
	*/

}
