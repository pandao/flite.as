package com.flite 
{
	import flash.net.*;
	import flash.events.*;
	import flash.display.*;
	
	/**
	 * 
	 * @package com.flite
	 * @class   Debuger
	 * @author  pandao pandao@vip.qq.com
	 * 
	 */
	
	public class ImageLoader
	{
		public var url:String;
		public var image:Sprite;
		public var percent:Number = 0;
		public var onload:Function;
		public var onerror:Function;
		public var onpreload:Function;
		public var onprogress:Function;
		
		private var loader:Loader;
		
		public function ImageLoader(url:String) : void
		{			
			this.url = url;
			
			image  = new Sprite();
			
            loader = new Loader();
            loader.load(new URLRequest(url));
			loader.contentLoaderInfo.addEventListener(Event.OPEN, preloadHandler);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
			loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, progressHandler);
            loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadedHandler);
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
			var bitmap:Bitmap = Bitmap(loader.content);
			bitmap.smoothing = true;
			
			image.addChild(bitmap);
			
			onload = onload || new Function;
			onload(event);
		}
	}

}