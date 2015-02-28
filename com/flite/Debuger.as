package com.flite
{
	import flash.display.*;
	import flash.events.*;
	import flash.text.*;
	
	import com.flite.Utils;
	import com.flite.Scrollbar;
	
	/**
	 * Simple debuger tool panel
	 * 
	 * @package com.flite
	 * @class   Debuger
	 * @author  pandao pandao@vip.qq.com
	 *
	 * Example:
	 *  			
		Debuger.create(this, stage, {
			//width : 600, 
			//height: 480,
			//x : "center",
			//y : 100,
			text : "init text"
		});
	 * 
	 */
	
	public class Debuger
	{
		private static var $:Utils = new Utils;
		
		public var output:String         = "";
		
		public static var panel:*;
		public static var parent:DisplayObjectContainer;
		public static var outputTextbox:Sprite;
		public static var outputText:TextField;
		public static var outputTextStyle:TextFormat;
		public static var scrollbar:Scrollbar;
		public static var debuger:Object = { };
		public static var params:Object  = { 
												x         : "right",
												y         : "bottom", 
												width     : 600, 
												height    : 480,
												bgColor   : 0xFFFFFF, 
												fontSize  : 13, 
												fontColor : 0x000000,
												font      : "Microsoft Yahei",
												text      : "",
												barWidth  : 4,
												barMargin : 0
											};
		
		public function Debuger():void
		{
		}
		
		public static function create(container:DisplayObjectContainer, stage:Stage, newParams : Object = null):void
		{
			Debuger.parent = container;
			
			Debuger.params = $.extend(Debuger.params, newParams);
			
			var $params:Object = Debuger.params; 
			
			var panel:Sprite = new Sprite();
			panel.graphics.beginFill($params.bgColor);
			panel.graphics.drawRect(0, 0, $params.width, $params.height);
			panel.graphics.endFill(); 
			
			outputText = new TextField();
			outputText.htmlText = $params.text + "\n";
			outputText.autoSize = 'left';
			outputText.width    = $params.width - 10;
			outputText.height   = $params.height - 10;
			outputText.x        = 0;
			outputText.y        = 0;
			
			Debuger.outputTextbox = new Sprite();
			
			outputTextStyle       = new TextFormat();
			outputTextStyle.font  = $params.font;
			outputTextStyle.size  = $params.fontSize;
			outputTextStyle.color = $params.fontColor;
			outputText.setTextFormat(outputTextStyle);
			
			Debuger.outputTextbox.addChild(outputText);
			
			var params:Object = {
				width       : $params.width,  // if direction is Vertical, Rectangle width  == width + scrollbar.width + scrollbar.margin
				height      : $params.height,  // if direction is Vertical, Rectangle height == height
				barAlpha    : 0.7,
				barWidth    : $params.barWidth,
				barMargin   : $params.barMargin,
				barColor    : 0x2D96E3,
				barConColor : 0x0A428C,
				tweenTime   : 0.5
			};
			
			Debuger.scrollbar = new Scrollbar(stage, Debuger.outputTextbox, params); 
			
			panel.addChild(Debuger.scrollbar.container); 
			
			var closeBtn:Sprite = new Sprite();
			closeBtn.graphics.beginFill(0xFFCC00);
			closeBtn.graphics.drawRect(0, 0, 24, 24);
			closeBtn.graphics.endFill();
			
			closeBtn.buttonMode = true;
			closeBtn.x          = $params.width - 24;
			closeBtn.y          = 0;
			
			closeBtn.addEventListener(MouseEvent.CLICK, clickHandler);
			
			panel.addChild(closeBtn);
			
			var closeText:TextField = new TextField();
			closeText.text         = "X";
			closeText.x            = 5;
			closeText.autoSize     = "left";
			closeText.mouseEnabled = false;
			outputTextStyle.color  = 0xFFFFFF;
			closeText.setTextFormat(outputTextStyle);
			
			closeBtn.addChild(closeText);
			
			outputTextStyle.color = $params.fontColor;
			
			Debuger.panel = panel;
			
			
			container.addChild(Debuger.panel);
			
			setPosition($params.x, $params.y);
			
			stage.addEventListener(Event.RESIZE, resizeHandler); 
		}
		
		public static function setPosition(x, y) : void
		{	
			var posX:Number = 0;
			var posY:Number = 0;
			var stage = Debuger.parent.stage;
			
			Debuger.params.x = x;
			Debuger.params.y = y;
			
			switch(x)
			{
				case "left":
					posX = 0;
					break;
				case "right" :
					posX = stage.stageWidth - Debuger.params.width - Debuger.params.barWidth - Debuger.params.barMargin;
					break;
				case "center" :
					posX = (stage.stageWidth - Debuger.params.width) / 2;
					break;
				default :
					posX = x;
					break;
			}
			
			switch(y) 
			{
				case "top":
					posY = 0;
					break;
				case "bottom":
					posY = stage.stageHeight - Debuger.params.height;
					break;
				case "center":
					posY = (stage.stageHeight - Debuger.params.height) / 2;
					break;
				default :
					posY = y;
					break;
			}
			
			Debuger.panel.x = posX;
			Debuger.panel.y = posY;
		}
		
		private static function resizeHandler(event:Event) : void
		{
			setPosition(Debuger.params.x, Debuger.params.y);
		}
		
		private static function clickHandler(event:MouseEvent) : void
		{
			hide();	
		}
		
		public static function setDepthIndex(container, index:uint):void
		{
			container.setChildIndex(Debuger.panel, index);
		}
		
		public static function setText(value) : void
		{
			Debuger.outputText.htmlText = value;
		}
		
		public static function appendText(value, newline:Boolean = true) : void
		{
			if (newline) Debuger.outputText.appendText("\n");
			Debuger.outputText.appendText(value);
			Debuger.outputText.appendText("\n\n");
			Debuger.outputText.setTextFormat(Debuger.outputTextStyle);
		}
		
		public static function getText() : String
		{
			return Debuger.outputText.text;
		}
		
		public static function getHTMLText() : String
		{
			return Debuger.outputText.htmlText;
		}
		
		public static function empty() : void
		{
			Debuger.outputText.htmlText = "";
		}
		
		public static function show():void
		{
			Debuger.panel.visible = true;
		}	
			
		public static function hide(animate:Boolean = true) : void
		{			
			Debuger.panel.visible = false;
		}

		public static function remove() : void
		{
			Debuger.parent.removeChild(panel);
		}
		
		public static function console(type:String, message:String = "") : void 
		{
			trace(type, message);
			$.console(type, message);
		}
		
		public static function printr(array:Object, indent:String = "") : String
		{
			return $.printArray(array, indent);
		}
	}	
}