package com.flite
{
	import flash.net.*;
	import flash.text.*;
	import flash.geom.*;
	import flash.utils.*;
	import flash.events.*;
	import flash.display.*;
	import flash.external.*;
	
	/*
	 * Util tools class
	 * 
	 * @package com.flite
	 * @class   Utils
	 * @extend  Shape
	 * @author  pandao pandao@vip.qq.com
	 * 
	 */
	
	public class Utils extends Shape	
	{
		public var output:String        = "";
		public var cookie:SharedObject;
		
		public function Utils():void 
		{
		}
		
		public function attr(obj, attr:Object, _trace:Boolean = false):void 
		{
			for (var i in attr) 
			{
				obj[i] = attr[i];
				
				if (_trace) {
					trace("set attr =>", i, attr[i]);
				}
			}
		}
		
		/*
		 * each
		 * 
		 * DisplayObject or Object foreach
		 * 
		 * @param {*}        	list 		DisplayObject or Object
		 * @param {Function} 	callback	callback function
		 * @example
		 
		    var arr = [12,23,25,56,36,43];
			each(arr, function(i){
				trace(arr[i]);
			});
		 *
		 */
		
		public function each(list:*, callback:Function = null) 
		{
			callback = callback || new Function;
			
			if(list is DisplayObject)
			{
				for (var i = 0; i < list.numChildren; i++) 
				{		
					callback(i);
				}
			}
			else if(list is Object)
			{
				for (var n in list) 
				{		
					callback(n, list[n]);
				}
			}
			else
			{
			}
		}
		
		public function clickOpenURL(obj, url:String, target:String = '_self'):void 
		{
			var _this = this;
			
			this.hover(obj, function() {
			    obj.buttonMode = true;
			},  function() {
			    obj.buttonMode = false;			
			});
			
			obj.addEventListener(MouseEvent.CLICK, openAction);
			
			function openAction(event:MouseEvent) : void 
			{
                _this.navToURL(url, target);
			}
		}
		
		public function navToURL(url:String, target:String = '_self'):void
		{
			var request:URLRequest = new URLRequest(url);
            navigateToURL(request, target);		
		}
			
		public function hover(obj:DisplayObject, overCallback:Function, outCallback:Function, buttonMode:Boolean = true, _trace:Boolean = false) : void 
		{
			obj.addEventListener(MouseEvent.MOUSE_OVER, overHandler);
			
			function overHandler(event:MouseEvent) : void 
			{			
			    if (_trace)     trace('Over', obj, obj.name);
				if (buttonMode) event.currentTarget.buttonMode = true;
				
				overCallback(event);
				obj.removeEventListener(MouseEvent.MOUSE_OVER, overHandler);	
				obj.addEventListener(MouseEvent.MOUSE_OUT, outHandler);	
			}	
			
			function outHandler(event:MouseEvent) : void
			{		
			    if (_trace)     trace('Out', obj, obj.name);
				if (buttonMode) event.currentTarget.buttonMode = false;
				
				outCallback(event);
				obj.removeEventListener(MouseEvent.MOUSE_OUT, outHandler);	
				obj.addEventListener(MouseEvent.MOUSE_OVER, overHandler);
			}
		}
		
		public function click(obj:DisplayObject, callback:Function, once:Boolean = false, _trace:Boolean = false) : void
		{			
			obj.addEventListener(MouseEvent.CLICK, clickHandler);	
			
			function clickHandler(event:MouseEvent) : void
			{
			    if (_trace) trace('onClick', obj, obj.name);
				
				callback(event);
				
				if(once) obj.removeEventListener(MouseEvent.CLICK, clickHandler);
			}
		}
		
		public function setPosition(obj:DisplayObject, x = "center", y = "center", relativeObject = null) : void
		{		
			switch(x)
			{
				case "left":
					obj.x = 0;
					break;
				case "right" :
					obj.x = (!relativeObject) ? (stage.stageWidth - obj.width) : (relativeObject.width - obj.width);
					break;
				case "center" :
					obj.x = (!relativeObject) ? (stage.stageWidth - obj.width) / 2 : (relativeObject.width - obj.width) / 2;
					break;
				default :
					obj.x = x;
					break;
			}
			
			switch(y) 
			{
				case "top":
					obj.y = 0;
					break;
				case "bottom":
					obj.y = (!relativeObject) ? (stage.stageHeight - obj.height) : (relativeObject.height - obj.height);
					break;
				case "center":
					obj.y = (!relativeObject) ? (stage.stageHeight - obj.height) / 2 : (relativeObject.height - obj.height) / 2;
					break;
				default :
					obj.y = y;
					break;
			}
		}
		
		public function resize(callback:Function) : void
		{
			stage.addEventListener(Event.RESIZE, function(event) {
				callback(event);
			});
		}
		
		public function toggle(obj:DisplayObject) : void
		{
			obj.visible = (obj.visible) ? false : true;
		}
		
		public function show(obj:DisplayObject):void 
		{
			obj.visible = true;
		}
		
		public function hide(obj:DisplayObject):void 
		{
			obj.visible = false;
		}
		
		public function traceDisplayObjectList(container:DisplayObjectContainer, indent:String = ""):void
		{
			var child:DisplayObject;
			
			for (var i:uint = 0; i < container.numChildren; i++)
			{
				child = container.getChildAt(i);
				
				trace(indent, child, child.name);
				
				if (container.getChildAt(i) is DisplayObjectContainer)
				{
					traceDisplayObjectList(DisplayObjectContainer(child), indent + "    ");
				}
		    }
	    }
		
		public function getChildrenIndexs(obj:DisplayObjectContainer, _trace:Boolean = false) : String
		{
			var output:String = "";
			
			for (var i:uint = 0, len:uint = obj.numChildren; i < len; i++)
			{
				var subObject  = obj.getChildAt(i);
				
				output += 'SubObject[' + i + ']：' + subObject.name + ', Index：' + obj.getChildIndex(subObject) + "\n";
			}
			
			if (_trace) 
			{
				trace(output);
				
				return "";
			} 
			else 
			{
				return output;
			}
		}

		// set siblings attributes
		public function siblings(obj, parentObj, setAttr:Object, callback:Function = null, debug:Boolean = false) : void
		{
			callback = callback || new Function;

			for (var i:uint = 0, len:uint = parentObj.numChildren; i < len; i++)
			{
				var getObj = parentObj.getChildAt(i);
				
				if (getObj !== obj)
				{
					if (debug)
					{
						trace(getObj.name);
					}
					
					for (var a in setAttr)
					{
						getObj[a] = setAttr[a];
					}
				}
			}
			
			callback();
		}
		
		// set children attributes
		
		public function children(parentObj, setAttr:Object, childObj:Array = null, callback:Function = null) : void
		{
			callback = callback || new Function;
			
			if (childObj == null)
			{
				for (var i:uint = 0, len:uint = parentObj.numChildren; i < len; i++)
				{
					var getObj = parentObj.getChildAt(i);
					
					for (var a in setAttr)
					{
						getObj[a] = setAttr[a];
					}
				}
			}
			else
			{
				for each (var o in childObj)
				{
					var getObj2 = parentObj.getChildByName(o);
					
					for (var s in setAttr)
					{
						getObj2[s] = setAttr[s];
					}
				}
			}

			callback();
		}
		
		public function inArray(searchValue, searchArray:Array) : Boolean
		{			
			for each (var i in searchArray)
			{		
				if (i is Array)
				{
					inArray(searchValue, i);
				}
				else
				{
					if (searchValue == i)
					{
						return true; 
					}
				}
			}
			
			return false;
		}
		
		public function printr(array:Object, indent:String = "") : String
		{
			return this.printArray(array, indent);
		}

		public function printArray(array:Object, indent:String = '') : String
		{
			var output:String = this.output;
			
			for (var i in array)
			{
				//trace("typeof =>", typeof array[i]);
				if (array[i] is Array) // Array
				{
					output += indent + " " + i + " => Array (\n";
					output += printArray(array[i], indent + "    "); // Recursive loop
					output += indent + " )\n";
				}
				else if (array[i] is Number)
				{
					if (array[i] is int)
					{
						if (array[i] is uint)
						{
							output += indent + " " + i +" => (Unit) " + array[i] + "\n";  // Unsigned integer
						}
						else
						{
							output += indent + " " + i + " => (Int) " + array[i] + "\n";   // Signed integer
						}
					}
					else
					{
						output += indent + " " + i + " => (Number) " + array[i] + "\n";    // Float
					}
				}
				else if (array[i] is String)
				{
					output += indent + " " + i + " => (String) " + array[i] + "\n";        // String
				}
				else if (array[i] is Boolean)
				{
					output += indent + " " + i + " => (Boolean) " + array[i] + "\n";       // Boolean
				}
				else if (array[i] == null)
				{
					output += indent + " " + i + " => (Null) " + array[i] + "\n";          // Null
				}
				else
				{ 	
					if (typeof array[i] == "object") // Object
					{
						output += indent + " " + i + " => Object (\n";
						output += printArray(array[i], indent + "    "); // Recursive loop
						output += indent + " )\n";
					} 
					else 
					{ 
						output += indent + " " + i + " => (?) " + array[i] + "\n";             // Unknown type | DisplayObject
					}
				}
			}

			return output;
		}
		
		public function setCookie(name:String, data:Object) : void
		{
			var date:Date = new Date();
			cookie = SharedObject.getLocal(name);
			cookie.data.cookieName    = name;
			cookie.data.cookieCreated = date.getHours() + ":" + date.getMinutes() + ":" + date.getSeconds() + " - " + date.getDate() + "/" + (date.getMonth() + 1) + "/" + date.getFullYear();
			cookie.data.cookieData    = data;
			cookie.flush();
		}

		public function getCookie(name:String) : Object
		{
			cookie = SharedObject.getLocal(name);
			
			if (cookie.data.cookieName == name)
			{
				return cookie.data.cookieData;
			}

			return false;
		}

		public function deleteCookie(name:String) : Boolean
		{
			cookie = SharedObject.getLocal(name);

			if (cookie.data.cookieName == name) 
			{
				cookie.clear();
			
				return true;
			}
			
			return false;
		}
		
		public function extend(defaultObj:Object, newObj:Object) : Object
		{
			newObj = newObj || { };
			
			for (var i in defaultObj)
			{
				if (newObj[i]) defaultObj[i] = newObj[i];
				newObj[i] = defaultObj[i];
			}

			return newObj;
		}
		
		// execute javascript
		public function js(func:String, params:String = null) : *
		{
			return ExternalInterface.call(func, params);
		}
		
		public function console(type:String, message:String = "") : void 
		{
			this.js("console." + type + "(\"" + message + "\")");	
		}
		
		public function getPathURL():String
	    {
			var selfURL:String = this.loaderInfo.url;
			
			return (selfURL.slice(0, selfURL.lastIndexOf("/") + 1));
	    }
		
		public function setPoint(obj:MovieClip, point:Point):void
		{
			var len:int        = obj.numChildren;
			var tmpPoint:Point = obj.parent.globalToLocal(obj.localToGlobal(point));
			
			while (len--)
			{
				var tmpObj:DisplayObject = obj.getChildAt(len);
				tmpObj.x -= point.x;
				tmpObj.y -= point.y;
			}
			
			obj.x = tmpPoint.x;
			obj.y = tmpPoint.y;
		}
		
		// remove DisplayObjectContainer (all) children DiaplayObject.
		
		public function removeChildren(container:DisplayObjectContainer, callback:Function = null) : void
		{
			while (container.numChildren > 0)
			{
				container.removeChildAt(0);
			}
			
			callback = callback || new Function;
			callback();
		}
	}	
}