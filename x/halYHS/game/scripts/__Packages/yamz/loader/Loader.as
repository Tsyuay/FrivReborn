class yamz.loader.Loader extends MovieClip
{
   var startLoading = true;
   var gotoAnd = "";
   var label = "";
   var endValue = 100;
   var endType = "%";
   var version = false;
   var order = 0;
   var debug = "info";
   function Loader()
   {
      super();
      if(_global.isLivePreview || this._url.indexOf("..swf") != -1)
      {
         return undefined;
      }
      mx.events.EventDispatcher.initialize(this);
      this.addEventListener("onLoadError",this);
      this.addEventListener("onLoadProgress",this);
      this.addEventListener("onLoadComplete",this);
      if(this.group == "")
      {
         this.group = null;
      }
      if(this.group != undefined && this.order == undefined)
      {
         yamz.loader.Loader.loading = false;
         this.dispatchEvent({type:"onLoadError",target:this,level:"error",description:this._name + ": manque l\'ordre dans le groupe",code:2});
         return undefined;
      }
      if(this.group != null)
      {
         if(!(this.group instanceof yamz.loader.GroupLoader))
         {
            var lTempGroup = this.group.split(".");
            var lEndGroup = lTempGroup.pop();
            var lBeginGroup = !lTempGroup.length ? this._parent : eval("this._parent." + lTempGroup.join("."));
            if(lBeginGroup[lEndGroup] instanceof yamz.loader.GroupLoader)
            {
               this.group = lBeginGroup[lEndGroup];
            }
            else
            {
               this.group = lBeginGroup[lEndGroup] = new yamz.loader.GroupLoader(true);
            }
         }
         this.group.initOrder(this);
      }
      if(this.group != undefined)
      {
         this.startLoading = this.order !== 0 ? false : this.group.startLoading;
      }
      if(this.version == undefined)
      {
         this.version = this.group == undefined ? false : this.group.version;
      }
      if(this.group == undefined || this.group.idGraphic === undefined)
      {
         this.setGraphic(this.idGraphic);
      }
      else
      {
         this.setGraphic(this.group.idGraphic);
      }
      if(this.group == undefined || this.group.endValue === undefined || this.group.endType === undefined)
      {
         this.setLoadingEnd(this.endValue,this.endType);
      }
      else
      {
         this.setLoadingEnd(this.group.endValue,this.group.endType);
      }
      if(this.startLoading)
      {
         if(this.group != undefined)
         {
            this.group.list[this.order] = undefined;
         }
         this.load();
      }
   }
   function get _targetInstanceName()
   {
      return this.target;
   }
   function set _targetInstanceName(pTarget)
   {
      if(typeof pTarget == "number")
      {
         this.target = new Number(pTarget);
      }
      else
      {
         this.target = this._parent[pTarget];
      }
   }
   static function create(pParent, pName, pDepth, pInitObject)
   {
      if(pInitObject == undefined)
      {
         pInitObject = {};
      }
      if(pInitObject.startLoading == undefined)
      {
         pInitObject.startLoading = false;
      }
      if(pDepth == undefined)
      {
         pDepth = pParent.getNextHighestDepth();
      }
      return yamz.loader.Loader(pParent.attachMovie("yamz.loader.Loader",pName,pDepth,pInitObject));
   }
   function setGraphic(pId)
   {
      if(arguments.length > 0 && pId !== undefined)
      {
         this.idGraphic = pId;
         if(pId == null || pId != "")
         {
            if(this.mcGraphic != undefined)
            {
               this.mcGraphic.swapDepths(this.getNextHighestDepth());
               this.mcGraphic.removeMovieClip();
            }
            if(pId != "")
            {
               this.attachMovie(pId,"mcGraphic",0);
            }
         }
      }
      this.mcGraphic._visible = false;
   }
   function setLoadingEnd(pValue, pType)
   {
      if(pType != "image" && pType != "%" && pType != "kb")
      {
         pValue = 100;
         pType = "%";
      }
      this.endValue = pValue;
      this.endType = pType;
   }
   function load(pUrl, pTarget, pVersion)
   {
      if(this.mcGraphic != undefined)
      {
         this.addEventListener("onLoadProgress",this.mcGraphic);
      }
      if(pTarget != undefined)
      {
         if(typeof pTarget == "movieclip" || pTarget instanceof Sound || pTarget instanceof LoadVars || pTarget instanceof XML)
         {
            this.target = pTarget;
         }
         else
         {
            this.__set___targetInstanceName(pTarget);
         }
      }
      if(pVersion != undefined)
      {
         this.version = pVersion;
      }
      this.url = yamz.loader.Loader.parseURL(pUrl == undefined ? this.url : pUrl,this.version);
      if(this.url == "" && this.__get___targetInstanceName() == undefined)
      {
         this.target = this._parent;
         this.onEnterFrame = this.__loadProgress();
         return undefined;
      }
      if(this.url == "")
      {
         yamz.loader.Loader.loading = false;
         this.dispatchEvent({type:"onLoadError",target:this,level:"error",description:"fichier à charger non défini",code:0});
         return undefined;
      }
      if(!(this.target instanceof Number || typeof this.target == "movieclip" || this.target instanceof Sound || this.target instanceof LoadVars || this.target instanceof XML))
      {
         yamz.loader.Loader.loading = false;
         this.dispatchEvent({type:"onLoadError",target:this,level:"error",description:"cible non définie ou non supportée",code:1});
         return undefined;
      }
      if(this.endType == "image" && (this.target instanceof Sound || this.target instanceof LoadVars || this.target instanceof XML))
      {
         yamz.loader.Loader.loading = false;
         this.dispatchEvent({type:"onLoadError",target:this,level:"error",description:"le endType \'image\' n\'est pas supporté par la cible",code:3});
         return undefined;
      }
      if(this.target instanceof Sound)
      {
         yamz.loader.Loader.loading = true;
         this.target.loadSound(this.url,false);
         this.onEnterFrame = this.__loadProgress();
      }
      else if(this.target instanceof LoadVars || this.target instanceof XML)
      {
         yamz.loader.Loader.loading = true;
         this.target.load(this.url);
         this.onEnterFrame = this.__loadProgress();
      }
      else if(typeof this.target == "movieclip")
      {
         this.target.unloadMovie();
         this.onEnterFrame = this.__initClip;
      }
      else
      {
         _global.loadMovieNum(this.url,this.target);
         this.onEnterFrame = this.__initLevel;
      }
   }
   function __initClip()
   {
      yamz.loader.Loader.loading = true;
      if(this.target.getBytesTotal() === 0)
      {
         this.target.loadMovie(this.url);
         this.onEnterFrame = this.__loadProgress();
      }
   }
   function __initLevel()
   {
      yamz.loader.Loader.loading = true;
      if(this["_level" + this.target])
      {
         this.target = this["_level" + this.target];
         this.onEnterFrame = this.__loadProgress();
      }
   }
   function __loadProgress()
   {
      var lStartTime = getTimer();
      if(this.group != undefined && this.visible == undefined)
      {
         this.mcGraphic._visible = this.group.visible;
      }
      else if(this.visible != undefined)
      {
         this.mcGraphic._visible = this.visible;
      }
      else
      {
         this.mcGraphic._visible = true;
      }
      return function()
      {
         yamz.loader.Loader.loading = true;
         var _loc8_ = this.target.getBytesLoaded();
         var _loc6_ = this.target.getBytesTotal();
         var _loc3_ = undefined;
         var _loc2_ = undefined;
         if(this.endType == "image")
         {
            _loc3_ = this.target._framesloaded;
            _loc2_ = this.endValue;
         }
         else
         {
            _loc3_ = _loc8_;
            if(this.endType == "%")
            {
               _loc2_ = Math.floor(_loc6_ * Math.min(100,this.endValue) / 100);
            }
            else
            {
               _loc2_ = this.endValue * 1000;
            }
         }
         if(_loc6_ > 0)
         {
            var _loc9_ = getTimer() - lStartTime;
            var _loc5_ = _loc3_ / _loc9_;
            var _loc7_ = Math.ceil((_loc2_ - _loc3_) / (_loc5_ * 1000));
            var _loc4_ = Math.max(0,Math.min(_loc3_,_loc2_));
            if(this.group != undefined)
            {
               this.group.loadProgress(this.url,_loc4_,_loc2_,_loc7_);
            }
            this.dispatchEvent({type:"onLoadProgress",target:this,loaded:_loc4_,total:_loc2_,speed:Math.round(_loc5_),timeLeft:_loc7_});
            if(_loc4_ >= _loc2_)
            {
               this.dispatchEvent({type:"onLoadComplete",target:this});
               var _loc11_ = !isNaN(parseInt(this.label)) ? Number(this.label) : this.label;
               if(this.gotoAnd != "")
               {
                  this.target["gotoAnd" + this.gotoAnd](this.label);
               }
               if(this.group != undefined)
               {
                  this.group.loadNext(_loc2_);
               }
               else
               {
                  yamz.loader.Loader.loading = false;
               }
               delete this.onEnterFrame;
               if(this.getDepth() < 0)
               {
                  this.swapDepths(this._parent.getNextHighestDepth());
               }
               this.removeMovieClip();
            }
         }
      };
   }
   static function parseURL(pUrl, pVersion)
   {
      var _loc2_ = yamz.System.mainPath;
      var _loc3_ = undefined;
      var _loc4_ = undefined;
      if(pUrl.indexOf("://") != -1 || _loc2_ == undefined || _loc2_ == "")
      {
         _loc3_ = pUrl;
      }
      else
      {
         _loc4_ = _loc2_.length - 1;
         if(_loc2_.charAt(_loc4_) == "/")
         {
            _loc2_ = _loc2_.substring(0,_loc4_);
         }
         if(!_loc2_.indexOf(".."))
         {
            _loc3_ = _loc2_ + "/" + pUrl;
         }
         else
         {
            _loc4_ = _loc2_.length - 1;
            if(_loc2_.charAt(_loc4_) == "/")
            {
               _loc2_ = _loc2_.substring(0,_loc4_);
            }
            var _loc5_ = pUrl.split("../");
            _loc4_ = _loc5_.length - 1;
            _loc3_ = _loc2_.split("/");
            _loc3_ = _loc3_.slice(0,_loc3_.length - _loc4_).join("/");
            if(_loc3_ != "")
            {
               _loc3_ += "/";
            }
            _loc3_ += _loc5_[_loc4_];
         }
      }
      return !(_global.System.capabilities.playerType != "External" && pVersion) ? _loc3_ : _loc3_ + "?" + yamz.System.version;
   }
   function onLoadError(pError)
   {
      if(this.debug != "none")
      {
         if(yamz.System.netDebug)
         {
            _global.debug("yamz.loader.Loader ERREUR",pError);
         }
         else
         {
            trace("** yamz.loader.Loader ERREUR **");
            for(var _loc4_ in pError)
            {
               trace("\t" + _loc4_ + ": " + pError[_loc4_]);
            }
         }
      }
   }
   function onLoadProgress(pEvt)
   {
      if(this.debug == "verbose")
      {
         if(yamz.System.netDebug)
         {
            _global.debug(pEvt);
         }
         else
         {
            trace(pEvt.target + ": " + pEvt.loaded + "/" + pEvt.total + " [" + pEvt.speed + "kb/s] [" + pEvt.timeLeft + "s]");
         }
      }
   }
   function onLoadComplete()
   {
      if(this.debug == "verbose" || this.debug == "info")
      {
         if(yamz.System.netDebug)
         {
            _global.debug((!(this.target instanceof XML) ? this.target : "XML") + ": chargement terminé");
         }
         else
         {
            trace((!(this.target instanceof XML) ? this.target : "XML") + ": chargement terminé");
         }
      }
   }
}
