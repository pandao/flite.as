package com.flite 
{
	import flash.net.*;
	import flash.events.*;
	import flash.display.*;
	
	/**
	 * 
	 * @package com.flite
	 * @class   XMLLoader
	 * @author  pandao pandao@vip.qq.com
	 * 
	 */
	
	public class XMLLoder 
	{		
		public var xml:XML;
		public var url:String;
		public var list:XMLList;
		public var percent:Number = 0;
		public var onload:Function;
		public var onerror:Function;
		public var onpreload:Function;
		public var onprogress:Function;
		
		private var loader:URLLoader;
		
		public function XMLLoder(url:String) : void
		{			
			this.url = url;
			
			xml = new XML();			
			xml.ignoreWhite = true;  //在分析过程中将放弃仅包含空白的文本节点
			
            loader = new URLLoader();
            loader.load(new URLRequest(url));
			loader.addEventListener(Event.OPEN, preloadHandler);
			loader.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
			loader.addEventListener(ProgressEvent.PROGRESS, progressHandler);
            loader.addEventListener(Event.COMPLETE, loadedHandler);
		}
		
		private function preloadHandler(event:Event) : void
		{
			onpreload = onpreload || new Function;
			onpreload(event);
		}
		
		private function errorHandler(event:IOErrorEvent) : void
		{			
			onerror = onerror || new Function;
			onerror(event);
		}
		
		private function progressHandler(event:ProgressEvent) : void
		{			
			percent = Math.round((event.bytesLoaded / event.bytesTotal) * 100);
			
			onprogress = onprogress || new Function;
			onprogress(event, percent);
		}
		
		private function loadedHandler(event:Event) : void
		{
			xml = XML(loader.data);
			
			onload = onload || new Function;
			onload(xml);
		}
	}

}