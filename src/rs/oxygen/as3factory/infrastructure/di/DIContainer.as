package rs.oxygen.as3factory.infrastructure.di
{
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	
	import mx.core.Application;
	import mx.core.FlexGlobals;
	
	import org.as3commons.lang.ClassUtils;
	import org.as3commons.reflect.Accessor;
	import org.as3commons.reflect.Constructor;
	import org.as3commons.reflect.Parameter;
	import org.as3commons.reflect.Type;

	public class DIContainer
	{
		private var _mappings:Dictionary;
		
		public function DIContainer()
		{
			_mappings = new Dictionary();			
		}
		/**
		 * Method which will alow you to register type mapping 
		 * into this container instance.
		 * 
		 * @param asType a type (<code>Class</code>) which we use to get 
		 * underlying type. In most cases it is interface.
		 * @param clazz a type of underlaying <class>Class</class>, 
		 * it is actual implementation of asType parameter.
		 * @param isSingleton this tells to DI container strategy which will 
		 * be used in cunstruction of underlaying type. If it is <code>true</code> 
		 * it will always return same instance. This is handy for services. By default
		 * it is set to false.
		 */		
		public function register(
			asType:Class, 
			clazz:Class, 
			isSingleton:Boolean = false):void{
			
			if(has(asType)){
				throw new DefinitionError("asType");
			}
			if(!ClassUtils.isAssignableFrom(asType, clazz)){
				throw new ArgumentError("Class " + clazz + " is not implementing or extending " + asType );
			}
			
			_mappings[asType] = clazz;
		} 
		
		/**
		 * Returns instance of actual type which is registered 
		 * in this or any child container as type passed in 
		 * method parameter.
		 * 
		 * @param asType the type for whitch we are reqesting instance. 
		 * It is in most cases interface
		 */
		public function getInstance(asType:Class):*{
			
			if (!has(asType)){
				//ToDo: Add exception here
				trace("none as type " + asType + " is registered within this container");
				return null;
			}
			var clazz:Class = _mappings[asType] as Class;
			trace("the type " + clazz + " is mapped as " + asType );
			applyBeforeFilter(clazz);
			var instance:* = construct(clazz);
			applyAfterFilter(instance);
			return instance;
		}
		/**
		 * This method will inject required dependecy in all 
		 * accessors which has [Inject] metadata set above it.
		 * [Inject] is nothing else than marker
		 */
		public function buildItemWithCurrentContext(instance:*):*{
			var instanceType:Type = Type.forInstance(instance);
			
			for each(var accesor:Accessor in instanceType.accessors){
				if(!accesor.hasMetaData("Inject")){
					continue;
				}
				if(has(accesor.type.clazz) && accesor.writeable){
					var obj:* = getInstance(accesor.type.clazz);
					buildItemWithCurrentContext(obj);
					instance[accesor.name] = obj;
				}
			}
			
			return instance;
		}
		
		public function has(asType:Class):Boolean{
			// Note: Closure usage!!!
			return _mappings[asType] != null;
		}
		
		private function construct(clazz:Class):*{
			
			var typed:Type = Type.forClass(clazz);
			var parameters:Array = typed.constructor.parameters;
			if (parameters.length < 1){
				// construct imidiatly
				return ClassUtils.newInstance(clazz);
			}
			// Todo: [HiPriority] Find a way to detect circular references!!!
			var arguments:Array = new Array();
			for each( var parameter:Parameter in parameters){
				arguments.push(	getInstance(parameter.type.clazz));
			}
			var instance:* = ClassUtils.newInstance(clazz,arguments);
			return instance;
		}
		
		private function applyBeforeFilter(clazz:Class):void{
			//Todo: Add filter execution logic
		}
		
		private function applyAfterFilter(instance:*):void {
			//Todo: Add filter execution logic
		}
		
	}
}