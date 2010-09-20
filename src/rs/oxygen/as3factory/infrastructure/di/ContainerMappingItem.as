package rs.oxygen.as3factory.infrastructure.di
{
	import org.as3commons.reflect.Type;

	public class ContainerMappingItem
	{
		private var _key:Class;
		private var _klass:Type;
		private var _isSingleton:Boolean;
		private var _instance:Object;
		
		public function ContainerMappingItem(
			key:Class,
			klass:Type,
			isSingleton:Boolean = false,
			instance:Object = null){
			
			_key = key;
			_klass = klass;
			_isSingleton = isSingleton;
			_instance = instance;
		}
		
		public function get key():Class
		{
			return _key;
		}

		public function get kalss():Type
		{
			return _klass;
		}

		public function get isSingleton():Boolean
		{
			return _isSingleton;
		}

		public function get instance():Object
		{
			return _instance;
		}

	}
}