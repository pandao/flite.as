package com.flite
{
	import flash.net.*;
	import flash.events.*;
	import flash.display.*;	
	import flash.system.fscommand;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	
	/**
	 * 
	 * a simple ContextMenu class
	 * 
	 * @package com.flite
	 * @class   xContextMenu
	 * @extend  Shape
	 * @author  pandao pandao@vip.qq.com
	 * 
	 */
	
	public class xContextMenu extends Shape
	{
		public var _contextMenu:ContextMenu;
		public var fullScreenText:String     = "Exit fullScreen";
		public var exitFullScreenText:String = "FullScreen";
		public var _target:DisplayObject;
		
		public function xContextMenu(target, menuSelectHandler:Function = null)
		{
			menuSelectHandler = menuSelectHandler || new Function;
			
			_target = target;
			_contextMenu = new ContextMenu();
			
			_contextMenu.addEventListener(ContextMenuEvent.MENU_SELECT, function(event:ContextMenuEvent) {
				menuSelectHandler(event);
			});
			
			_contextMenu.hideBuiltInItems(); // Hidden all context menu, Except "Settings".
			
            target.contextMenu = _contextMenu;
		}
		
		public function add(text:String, isGroup:Boolean = false, handler:Function = null):void 
		{
			handler = handler || function(){};
			
	        var obj:ContextMenuItem = new ContextMenuItem(text, isGroup);
			
			obj.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, function(event:ContextMenuEvent) {
				handler(event);
			});
			
	        _contextMenu.customItems.push(obj);
		}
		
		public function close(event:ContextMenuEvent = null)
		{
	        fscommand("quit");
		}
		
		public function remove(index:String) : void 
		{
			if (index == 'last')      _contextMenu.customItems.pop();   //删除最后一个菜单
			else if (index == 'shift') _contextMenu.customItems.shift(); //删除第一个菜单
			else {}
		}	
		
		public function openURL(url:String, target:String = '_top')
		{
			var request:URLRequest = new URLRequest(url);
            navigateToURL(request, target);	
		}
	}
	
}