package com.flite 
{
	import flash.utils.*;
	import flash.events.*;
	import flash.display.*;
	import fl.transitions.*;
	import fl.transitions.easing.*;
	
	/**
	 * Animation
	 * 
	 * @package com.flite
	 * @class   Animation
	 * @extend  Shape
	 * @author  pandao pandao@vip.qq.com
	 * 
	 */
	
	public class Animation extends Shape
	{		
		public var tween:Tween;
		public var $:Utils;
		
		public function Animation() 
		{
			$ = new Utils;
		}
		
		public function slideDown(obj:DisplayObject, speed:Number = 10) 
		{
			if (!obj) return this;
			
			var initHeight = obj.height;
			
			obj.height = 0;
						
			obj.addEventListener(Event.ENTER_FRAME, slideDownHandler);
			
			function slideDownHandler(event:Event)
			{
				if (obj.height >= initHeight)
				{
					obj.removeEventListener(Event.ENTER_FRAME, slideDownHandler);
				}
				else
				{
					obj.height += speed;
				}
			}
			
			return this;			
		}
		
		public function slideUp(obj:DisplayObject, speed:Number = 10) 
		{
			if (!obj) return this;
						
			obj.addEventListener(Event.ENTER_FRAME, slideUpHandler);
			
			function slideUpHandler(event:Event)
			{
				if (obj.height <= 0)
				{
					obj.removeEventListener(Event.ENTER_FRAME, slideUpHandler);
				}
				else
				{
					obj.height -= speed;
				}
			}		
			
			return this;			
		}
		
		public function fadeIn(obj:DisplayObject, speed:Number = 0.03)
		{
			if (!obj) return this;
			
			obj.addEventListener(Event.ENTER_FRAME, fadeInHandler);
			
			function fadeInHandler(event:Event)
			{
				if (obj.alpha >= 1)
				{
					obj.removeEventListener(Event.ENTER_FRAME, fadeInHandler);
				}
				else
				{
					obj.alpha += speed;
				}
			}
			
			return this;
		}
		
		public function fadeOut(obj:DisplayObject, speed:Number = 0.03)
		{
			if (!obj) return this;
			
			obj.addEventListener(Event.ENTER_FRAME, fadeOutHandler);
			
			function fadeOutHandler(event:Event)
			{
				if (obj.alpha <= 0)
				{
					obj.removeEventListener(Event.ENTER_FRAME, fadeOutHandler);
				}
				else
				{
					obj.alpha -= speed;
				}
			}
			
			return this;
		}
		
		public function fadeTo(obj:DisplayObject, to:Number = 1, speed:Number = 0.03)
		{
			if (!obj || obj.alpha == to) return this;
			
			obj.addEventListener(Event.ENTER_FRAME, fadeToHandler);
			
			function fadeToHandler(event:Event)
			{
				if (obj.alpha > to)
				{
					if (obj.alpha <= to)
					{
						obj.removeEventListener(Event.ENTER_FRAME, fadeToHandler);
					}
					else
					{
						obj.alpha -= speed;
					}					
				}
				
				if (obj.alpha < to) 
				{
					if (obj.alpha >= to)
					{
						obj.removeEventListener(Event.ENTER_FRAME, fadeToHandler);
					}
					else
					{
						obj.alpha += speed;
					}					
				}
			}
			
			return this;
		}
		
		public function mouseFollow(obj:DisplayObject, speed:Number = 0.12)
		{
			if (!obj) return this;
			
			this.addEventListener(Event.ENTER_FRAME, moveAction);
			
			function moveAction(event:Event) : void
			{
				obj.x += ((mouseX - obj.width / 2)  - obj.x) * speed;
				obj.y += ((mouseY - obj.height / 2) - obj.y) * speed;
			}
			
			return this;
		}
		
		//Parallax slide
		public function parallax(obj:DisplayObject, direction:String = "x", speed:Number = 0.12)
		{
			if (!obj) return this;
			
			this.addEventListener(Event.ENTER_FRAME, moveAction);
			
			function moveAction(event:Event) : void
			{
				if (direction == "x" || direction == "xy") obj.x += ((mouseX - obj.width / 2)  - obj.x) * speed;
				if (direction == "y" || direction == "xy") obj.y += ((mouseY - obj.height / 2) - obj.y) * speed;
			}
			
			return this;
		}	
	}

}