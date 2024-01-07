package
{
   import flash.display.Bitmap;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.ProgressEvent;
   import flash.geom.Matrix;
   import flash.media.SoundMixer;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   import flash.system.ApplicationDomain;
   import flash.system.LoaderContext;
   import flash.text.TextField;
   import flash.text.TextFormat;
   
   public class PreLoader2Armor extends MovieClip
   {
      
      public static const PreloaderBg1:Class = PreLoader2Armor_PreloaderBg1;
      
      public static const PreloaderBg2:Class = PreLoader2Armor_PreloaderBg2;
      
      public static const PreloaderBack:Class = PreLoader2Armor_PreloaderBack;
      
      private static var ArmorGamesAnim:Class = PreLoader2Armor_ArmorGamesAnim;
       
      
      private var movie_ag:Loader;
      
      private var mTicksAG:int = 0;
      
      private var Bg1:Bitmap = null;
      
      private var Bg2:Bitmap = null;
      
      private var Background:Bitmap = null;
      
      private var swfPct:Number = 0;
      
      private var progressLabel:TextField;
      
      private var progressFormat:TextFormat;
      
      public var ConsoleObject:Sprite;
      
      private var m_bDoneLoading:Boolean = false;
      
      public function PreLoader2Armor()
      {
         super();
         if(stage)
         {
            stage.frameRate = 60;
            this.onInitLoaderScreen(null);
            loaderInfo.addEventListener(ProgressEvent.PROGRESS,this.onProgress);
            loaderInfo.addEventListener(Event.COMPLETE,this.onPreloaderComplete);
         }
         else
         {
            addEventListener(Event.ADDED_TO_STAGE,this.onInitLoaderScreen);
         }
      }
      
      private function onInitLoaderScreen(param1:Event) : void
      {
         removeEventListener(Event.ADDED_TO_STAGE,this.onInitLoaderScreen);
         if(this.Bg1 != null)
         {
            return;
         }
         this.Bg1 = new PreloaderBg1() as Bitmap;
         this.Bg2 = new PreloaderBg2() as Bitmap;
         this.Background = new PreloaderBack() as Bitmap;
         this.addTextField();
      }
      
      private function addTextField() : void
      {
         this.progressFormat = new TextFormat();
         this.progressFormat.color = 16777215;
         this.progressFormat.size = 32;
         this.progressFormat.bold = true;
         this.progressFormat.align = "left";
         this.progressLabel = new TextField();
         this.progressLabel.embedFonts = false;
         addChild(this.progressLabel);
         this.progressLabel.setTextFormat(this.progressFormat);
      }
      
      private function render() : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:int = 0;
         var _loc13_:int = 0;
         var _loc14_:int = 0;
         var _loc15_:int = 0;
         var _loc16_:Matrix = null;
         var _loc17_:Boolean = false;
         var _loc18_:Boolean = false;
         if(this.m_bDoneLoading == true)
         {
            return;
         }
         graphics.clear();
         if(this.Background == null)
         {
            graphics.beginFill(0);
            graphics.drawRect(0,0,stage.stageWidth,stage.stageHeight);
            graphics.endFill();
         }
         else
         {
            _loc9_ = stage.stageWidth / this.Background.width;
            _loc10_ = stage.stageHeight / this.Background.height;
            _loc11_ = _loc9_;
            if(_loc10_ > _loc9_)
            {
               _loc11_ = _loc10_;
            }
            _loc12_ = this.Background.width * _loc11_;
            _loc13_ = this.Background.height * _loc11_;
            _loc14_ = (stage.stageWidth - _loc12_) / 2;
            _loc15_ = (stage.stageHeight - _loc13_) / 2;
            (_loc16_ = new Matrix()).translate(_loc3_,_loc4_);
            _loc16_.scale(_loc11_,_loc11_);
            _loc17_ = false;
            _loc18_ = true;
            graphics.beginBitmapFill(this.Background.bitmapData,_loc16_,_loc17_,_loc18_);
            graphics.drawRect(_loc14_,_loc15_,_loc12_,_loc13_);
            graphics.endFill();
         }
         var _loc1_:int = this.Bg1.width;
         var _loc2_:int = this.Bg1.height;
         _loc3_ = (stage.stageWidth - _loc1_) / 2;
         _loc4_ = stage.stageHeight - _loc2_ - 20;
         var _loc5_:Matrix;
         (_loc5_ = new Matrix()).translate(_loc3_,_loc4_);
         var _loc6_:Boolean = false;
         var _loc7_:Boolean = true;
         graphics.beginBitmapFill(this.Bg1.bitmapData,_loc5_,_loc6_,_loc7_);
         graphics.drawRect(_loc3_,_loc4_,_loc1_,_loc2_);
         graphics.endFill();
         var _loc8_:int = this.Bg2.width * this.swfPct;
         graphics.beginBitmapFill(this.Bg2.bitmapData,_loc5_,_loc6_,_loc7_);
         graphics.drawRect(_loc3_,_loc4_,_loc8_,_loc2_);
         graphics.endFill();
      }
      
      private function onProgress(param1:ProgressEvent) : void
      {
         this.swfPct = param1.bytesLoaded / param1.bytesTotal;
         var _loc2_:int = this.swfPct * 100;
         this.progressLabel.htmlText = "Downloading: " + _loc2_ + "%";
         this.progressLabel.setTextFormat(this.progressFormat);
         this.progressLabel.x = 50 + (stage.stageWidth - this.progressLabel.width) / 2;
         this.progressLabel.y = stage.stageHeight - this.Bg1.height - 20 + 30;
         this.progressLabel.width = 350;
         this.render();
      }
      
      private function onPreloaderComplete(param1:Event) : void
      {
         if(this.ConsoleObject != null)
         {
            return;
         }
         if(this.movie_ag != null)
         {
            return;
         }
         if(loaderInfo != null)
         {
            loaderInfo.removeEventListener(ProgressEvent.PROGRESS,this.onProgress);
            loaderInfo.removeEventListener(Event.COMPLETE,this.onPreloaderComplete);
         }
         if(this.progressLabel != null)
         {
            removeChild(this.progressLabel);
         }
         gotoAndStop(2);
         graphics.clear();
         this.m_bDoneLoading = true;
         graphics.clear();
         graphics.beginFill(0);
         graphics.drawRect(0,0,stage.stageWidth,stage.stageHeight);
         graphics.endFill();
         this.movie_ag = new Loader();
         var _loc2_:LoaderContext = new LoaderContext(false,ApplicationDomain.currentDomain);
         this.movie_ag.loadBytes(new ArmorGamesAnim(),_loc2_);
         this.movie_ag.contentLoaderInfo.addEventListener(Event.COMPLETE,this.contentsRetrieve);
      }
      
      private function contentsRetrieve(param1:Event) : void
      {
         this.movie_ag.x = (stage.stageWidth - 700) / 2;
         this.movie_ag.y = (stage.stageHeight - 400) / 2;
         stage.addChild(this.movie_ag);
         this.mTicksAG = 200;
         this.movie_ag.addEventListener(Event.ENTER_FRAME,this.enterFrame);
         stage.addEventListener(MouseEvent.CLICK,this.click);
      }
      
      protected function RunProcessAG() : void
      {
         var _loc1_:Class = null;
         if(this.movie_ag == null)
         {
            return;
         }
         --this.mTicksAG;
         if(this.mTicksAG <= 0)
         {
            stage.removeChild(this.movie_ag);
            this.movie_ag.removeEventListener(Event.ENTER_FRAME,this.enterFrame);
            stage.removeEventListener(MouseEvent.CLICK,this.click);
            this.movie_ag.unload();
            this.movie_ag = null;
            SoundMixer.stopAll();
            graphics.clear();
            _loc1_ = loaderInfo.applicationDomain.getDefinition("com.adobe.flascc.Console") as Class;
            this.ConsoleObject = new _loc1_(this);
         }
      }
      
      protected function enterFrame(param1:Event) : void
      {
         this.RunProcessAG();
      }
      
      private function click(param1:*) : void
      {
         navigateToURL(new URLRequest("http://armor.ag/MoreGames"),"_blank");
      }
   }
}
