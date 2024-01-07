package com.adobe.flascc.vfs
{
   import flash.utils.ByteArray;
   
   public class FileHandle
   {
       
      
      private var _backingStore:IBackingStore = null;
      
      private var _backingStoreRelativePath:String = null;
      
      private var _bytes:ByteArray = null;
      
      private var _callback:ISpecialFile = null;
      
      public var readable:Boolean;
      
      public var writeable:Boolean;
      
      public var appending:Boolean;
      
      private var _isDirectory:Boolean = false;
      
      private var _path:String = null;
      
      public var position:uint;
      
      public function FileHandle(param1:IBackingStore = null, param2:String = null, param3:ByteArray = null, param4:ISpecialFile = null, param5:Boolean = true, param6:Boolean = false, param7:Boolean = false, param8:Boolean = false, param9:String = null, param10:uint = 0)
      {
         super();
         _backingStore = param1;
         _backingStoreRelativePath = param2;
         _bytes = param3;
         _callback = param4;
         readable = param5;
         writeable = param6;
         appending = param7;
         _isDirectory = param8;
         _path = param9;
         position = param10;
      }
      
      public static function makeSpecialFile(param1:ISpecialFile) : FileHandle
      {
         var _loc2_:FileHandle = new FileHandle();
         _loc2_.writeable = true;
         _loc2_.readable = true;
         _loc2_._callback = param1;
         return _loc2_;
      }
      
      public static function makeRegularFile(param1:String, param2:String, param3:IBackingStore, param4:ByteArray, param5:Boolean) : FileHandle
      {
         /*
          * Erro de descompilação.
          * Código pode ser ofuscado
          * Dica: você pode tentar habilitar "Desofuscação automática" em Configurações
          * Tipo de erro: NullPointerException (null)
          */
         throw new flash.errors.IllegalOperationError("Não descompiliado devido a erro");
      }
      
      public function get backingStore() : IBackingStore
      {
         return _backingStore;
      }
      
      public function get backingStoreRelativePath() : String
      {
         return _backingStoreRelativePath;
      }
      
      public function get bytes() : ByteArray
      {
         return _bytes;
      }
      
      public function get callback() : ISpecialFile
      {
         return _callback;
      }
      
      public function get isDirectory() : Boolean
      {
         return _isDirectory;
      }
      
      public function get path() : String
      {
         return _path;
      }
   }
}

const §2§:*;
