package com.flite
{
	import flash.net.*;
	import flash.events.*;
	import flash.display.*;
	
	/*
	 * FullscreenBackground
	 * 
	 * @author Pandao
	 * @example
		
		var testFullBackground = new FullscreenBackground(stage, "http://xxxx.jpg");
		addChild(testFullBackground.image);
	 * 
	 */

	public class FullscreenBackground
	{
		private var stage:Stage;
		private var loader:Loader;
		
		public var url:String;
		public var percent:Number = 0;
		public var image:Sprite;
		public var onpreload:Function;
		public var onerror:Function;
		public var onprogress:Function;
		public var onload:Function;

		public function FullscreenBackground(_stage:Stage, url:String)
		{
			// Must setting
			stage           = _stage;
			stage.align     = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			this.url = url;
			
			image  = new Sprite();
			
			loader = new Loader();
			var urlReqest:URLRequest = new URLRequest(url);

			loader.load(urlReqest);
			loader.contentLoaderInfo.addEventListener(Event.OPEN, preloadHandler);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
			loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, progressHandler);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadedHandler);
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

		private function preloadHandler(event:Event) : void
		{			
			onpreload = onpreload || new Function;
			
			onpreload(event);
		}
		
		private function loadedHandler(event:Event) : void
		{
			//var loader:Loader = Loader(event.target.loader);
			var bitmap:Bitmap = Bitmap(loader.content);

			bitmap.y -= bitmap.height;
			bitmap.smoothing = true;
			
			image.addChild(bitmap);

			stageResizing();
			stage.addEventListener(Event.RESIZE, stageResizing);
			
			onload = onload || new Function;
			onload(event);
		}
		
		private function stageResizing(event:Event = null) : void
		{
			image.width  = stage.stageWidth;
			image.scaleY = image.scaleX;
			
			if (image.height < stage.stageHeight)
			{
				image.height = stage.stageHeight;
				image.scaleX = image.scaleY;
			}
			
			image.y = stage.stageHeight;
		}
	}
}