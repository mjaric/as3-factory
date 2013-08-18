h1. AS3 Factory

as3-factory is ActionScript 3 general infrastructure framework. It will grow over time, and for now it has

- Dependency injection container

This library depends on as3-common-reflect and as3-common-lang. Later it can include other libs from this great project. Both can be found at as3-commons

By using this library, you will be able to separate actual implementation of the rest of application. This will allow you to create more testable and modular ActionScript application. And one good point of this DI container is that you can finally forget for factory methods. Leave initialization to DI. How? Look at sample below.

Note: You will need to add compiler directive -keep-as3-metadata=Inject so it will export [Inject] metadata with your classes.

Simple usage:
```
public interface ISamle
{
    function apiMethod():void;
}
```
```
public class SampleImpl implements ISample
{
    public function apiMethod():void
    {
        trace("execution of implementation of ISample");
    } 
}
```
```
public interface IRoot 
{
    public function callAll():void;
}
```
```
public interface RootImpl implements IRoot 
{
    private _sample:ISample;

    [Inject]
    public function RootImpl(sample:ISample)
    {
        _sample = sample;
    }

    public function callAll():void
    {
        trace("call from implementation");
        _sample.apiMethod();
    }
}
```

```

// initialize DI container ...
var container:DIContainer = new DIContainer();
container.register(ISample,SampleImpl);
container.register(IRoot,RootImpl);

//..... anywhere in code ...
var root:IRoot = container.getInstance(IRoot);

root.callAll();

// debugger output:
// call from implementation
// execution of implementation of ISample
```

Best practice is to create interface for every type you want to be exposed to rest of the world.

To make things easier, when container is fully developed, module initializers will be added tothis project, in order to have quicker start, and better modularity whit your AS libraries.

Happy coding!