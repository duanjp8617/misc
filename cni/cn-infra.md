* use ```logrus.DefaultLogger().Warnf()``` to add custom print messages. 

* ```ExamplePlugin``` calls the ```Watch``` method on the ```kvdbsync``` plugin, passing in several channels for event notifications and key prefixes to watch. The ```Watch``` method does not do too many things, in fact, it will register the channels and prefixes internally and returns a handle ```WatchRegistration``` back to the ```ExamplePlugin```.

* In the ```AfterInit``` phase of ```kvdbsync``` plugin, after etcd has been connected, a callback function is called. Inside this callback function, the etcd connection is used as the base to create a ```Broker``` and ```Watcher```, which are used later to interact with the etcd database. 

* Still in this callback function, for each of the previously registed subscription through ```kvdbsync```'s ```Watch```, the ```kvdbsync``` plugin registers with ```resync```, and acquires a registration handle, which containing the status channel.

