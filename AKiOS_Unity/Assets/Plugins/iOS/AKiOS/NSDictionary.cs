using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System;

namespace AKiOS
{
	public class NSDictionary : NSObject
	{
		public static NSDictionary dictionary()
		{
			return (NSDictionary)Class.FindByName("NSDictionary").Call("dictionary").Cast(typeof(NSDictionary));
		}

		public void setFromDict(Dictionary<string, string> value)
		{
			foreach (var kv in value) {
				setValueForKey(kv.Key, new NSString(kv.Value));
			}
		}

		public void setFromDict(Dictionary<string, object> value)
		{
			foreach (var kv in value) {
				setValueForKey (kv.Key, CsToOc(kv.Value));
			}
		}

		public static NSObject CsToOc(object csobj)
		{
			if (csobj == null)
            {
                return null;
            } else if (csobj is NSObject)
            {
                return (NSObject)csobj;
            } else if (csobj is string)
            {
                return new NSString((string)csobj);
            } else if (csobj.GetType() == typeof(int))
            {
                return new NSNumber((int)csobj);
            } else if (csobj.GetType() == typeof(float))
            {
                return new NSNumber((float)csobj);
            } else if (csobj.GetType() == typeof(double))
            {
                return new NSNumber((double)csobj);
            } else if (csobj.GetType() == typeof(bool))
            {
                return new NSNumber((bool)csobj);
            } else if (csobj.GetType() == typeof(Int64))
            {
                return new NSNumber((Int64)csobj);
            }

            return null;
		}
	}
}
