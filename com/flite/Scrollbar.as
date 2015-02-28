package com.flite
{
	import flash.events.*;
	import flash.display.*;
	import flash.geom.Rectangle;
	
	import fl.transitions.Tween;
	import fl.transitions.easing.*;
	import fl.transitions.TweenEvent;
	
	/**
	 * 
	 * @package com.flite
	 * @class   Scrollbar
	 * @author  pandao pandao@vip.qq.com
	 */

	public class Scrollbar
	{
		private var $:Utils;
		private var stage:Stage;
		private var tween:Tween;		
		private var delta:uint = 1;
		
		public var rectWidth:Number;
		public var rectHeight:Number;
		public var contentObj:DisplayObject;    // content object
		public var rectMask:Sprite;          	// container rect mask
		public var container:Sprite;            // container object	
		public var scrollbar:Sprite;            // scrollbar object
		public var scrollbarContainer:Sprite;   // scrollbar container object
		
		public var params:Object = {
										x           : 0,
										y           : 0,
										width       : 300,
										height      : 300,
										direction   : "y",
										conColor    : 0xDDDDDD,
										conAlpha    : 0,
										barWidth    : 4,
										barHeight   : 4, 
										barMargin   : 0,
										barColor    : 0x000000, 
										barAlpha    : 1,
										barConAlpha : 1,
										barConColor : 0xDDDDDD,
										ratio       : 0.05,
										tweenTime   : 0.5,
										easingType  : Regular.easeOut
									};
		
		public function Scrollbar(_stage:Stage, contentObj:DisplayObject, newParams:Object = null, containerObj = null) : void
		{
			$ = new Utils;
			
			stage = _stage;
			
			this.params = $.extend(this.params, newParams);
			this.contentObj = contentObj;
			
			create(containerObj);
		}
		
		public function create(containerObj) : void
		{
			// if direction == "x" (horizontal)
			rectWidth  = (params.direction == "x") ? params.width : (params.width + params.barWidth + params.barMargin);
			rectHeight = (params.direction == "x") ? (params.height + params.barHeight + params.barMargin) : params.height;
			
			if (containerObj) 
			{
				container         = containerObj;
				
				params.conWidth   = container.width;
				params.maskWidth  = container.width;
				params.maskHeight = container.height;
			}
			else
			{
				// if containerObj is undefined, creating container object.
				
				container = new Sprite();
				container.graphics.beginFill(params.conColor, params.conAlpha);
				container.graphics.drawRect(0, 0, rectWidth, rectHeight);
				container.graphics.endFill();
			}
							
			container.x = params.x;
			container.y = params.y;
			container.scrollRect = new Rectangle(0, 0, rectWidth, rectHeight); 
			
			// if contentObj's width/height > container's width/height
			if (contentObj.width > container.width || contentObj.height > container.height)
			{			
				rectMask        = new Sprite();
				scrollbar          = new Sprite();
				scrollbarContainer = new Sprite();
				
				rectMask.graphics.beginFill(0xDDDDDD);
				rectMask.graphics.drawRect(0, 0, rectWidth, rectHeight);
				rectMask.graphics.endFill();
				rectMask.x = 0;
				rectMask.y = 0;
				
				if (params.direction == "x")  // horizontal
				{
					scrollbarContainer.graphics.beginFill(params.barConColor, params.barConAlpha);
					scrollbarContainer.graphics.drawRect(0, 0, params.width, params.barHeight);
					scrollbarContainer.graphics.endFill();
					scrollbarContainer.x = 0;
					scrollbarContainer.y = rectHeight - params.barHeight;

					scrollbar.graphics.beginFill(params.barColor, params.barAlpha);
					scrollbar.graphics.drawRect(0, 0, 50, params.barHeight);
					scrollbar.graphics.endFill();

					scrollbar.width = scrollbarContainer.width * (container.width / contentObj.width);			
				}
				
				if (params.direction == "y")  // Vertical
				{
					scrollbarContainer.graphics.beginFill(params.barConColor, params.barConAlpha);
					scrollbarContainer.graphics.drawRect(0, 0, params.barWidth, params.height);
					scrollbarContainer.graphics.endFill();
					scrollbarContainer.x = rectWidth - params.barWidth;
					scrollbarContainer.y = 0;

					scrollbar.graphics.beginFill(params.barColor, params.barAlpha);
					scrollbar.graphics.drawRect(0, 0, params.barWidth, 50);
					scrollbar.graphics.endFill();

					scrollbar.height = scrollbarContainer.height * (container.height / contentObj.height);
				}
				
				scrollbar.buttonMode = true;

				scrollbarContainer.addChild(scrollbar);

				contentObj.mask = rectMask;
				
				container.addChild(rectMask);
				container.addChild(contentObj);
				container.addChild(scrollbarContainer);

				scrollbar.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler); 
				
				container.addEventListener(MouseEvent.MOUSE_WHEEL, mouseWheelHandler); 
			}
			else
			{
				container.addChild(contentObj);				
			}
		}

		public function mouseDownHandler(e:MouseEvent) : void
		{
			var rec:Rectangle;
			
			if (params.direction == "x")
			{
				rec = new Rectangle(0, 0, params.width - scrollbar.width, 0);
			}
			
			if (params.direction == "y")
			{
				rec = new Rectangle(0, 0, 0, params.height - scrollbar.height);
			}
			
			scrollbar.startDrag(false, rec);
			
			stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
			stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			
			e.updateAfterEvent();
		}

		public function mouseMoveHandler(e:MouseEvent) : void
		{
			if (params.direction == "x") 
			{
				var newX:Number = - contentObj.width * (scrollbar.x / scrollbarContainer.width);
				
				tween = new Tween(contentObj, "x", params.easingType, contentObj.x, newX, params.tweenTime, true);
			}
			
			if (params.direction == "y") 
			{
				var newY:Number = - contentObj.height * (scrollbar.y / scrollbarContainer.height);
				
				tween = new Tween(contentObj, "y", params.easingType, contentObj.y, newY, params.tweenTime, true);
			}
			
			e.updateAfterEvent();
		}

		public function mouseUpHandler(e:MouseEvent):void
		{
			scrollbar.stopDrag();
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
			stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			e.updateAfterEvent();
		}
		
		public function mouseWheelHandler(event:MouseEvent):void 
		{			
			var speed:Number;
			
			delta = (event.delta < 0) ? delta -- : delta ++; // down --, up ++;
			
			if (params.direction == "x") 
			{
				var scrollLeft;
				var scrollbarNewX = scrollbar.x;
				
				speed = scrollbarContainer.width * params.ratio;
				
				scrollbarNewX = (event.delta < 0) ? scrollbarNewX + speed : scrollbarNewX - speed;

				if (scrollbarNewX + scrollbar.width >= scrollbarContainer.width) 
				{
					scrollLeft = scrollbarContainer.width - scrollbar.width;
				} 
				else if (scrollbarNewX <= 0) 
				{
					scrollLeft = 0;			
				}
				else 
				{
					scrollLeft = scrollbarNewX;
				}
				
				scrollbar.x = scrollLeft;
				
				var sx:Number = scrollLeft / scrollbarContainer.width; // rolling ratio 
				
				tween = new Tween(contentObj, "x", params.easingType, contentObj.x, -(contentObj.width * sx), params.tweenTime, true);
			}
			
			if (params.direction == "y") 
			{
				var scrollTop;
				var scrollbarNewY = scrollbar.y;
				
				speed = scrollbarContainer.height * params.ratio;
				
				scrollbarNewY = (event.delta < 0) ? scrollbarNewY + speed : scrollbarNewY - speed;

				if (scrollbarNewY + scrollbar.height >= scrollbarContainer.height) 
				{
					scrollTop = scrollbarContainer.height -scrollbar.height;
				} 
				else if (scrollbarNewY <= 0) 
				{
					scrollTop = 0;			
				}
				else 
				{
					scrollTop = scrollbarNewY;
				}
				
				scrollbar.y = scrollTop;
				
				var sy:Number = scrollTop / scrollbarContainer.height;  // rolling ratio   
				
				tween = new Tween(contentObj, "y", params.easingType, contentObj.y, -(contentObj.height * sy), params.tweenTime, true);
			}
		}
	}
}