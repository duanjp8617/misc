* use ```logrus.DefaultLogger().Warnf()``` to add custom print messages. 

* ```ExamplePlugin``` calls the ```Watch``` method on the ```kvdbsync``` plugin, passing in several channels for event notifications and key prefixes to watch. The ```Watch``` method does not do too many things, in fact, it will register the channels and prefixes internally and returns a handle ```WatchRegistration``` back to the ```ExamplePlugin```.

* In the ```AfterInit``` phase of ```kvdbsync``` plugin, after etcd has been connected, a callback function is called. Inside this callback function, the etcd connection is used as the base to create a ```Broker``` and ```Watcher```, which are used later to interact with the etcd database. 

* Still in this callback function, for each of the previously registed subscription through ```kvdbsync```'s ```Watch```, the ```kvdbsync``` plugin registers with ```resync```, and acquires a registration handle, which contains the status channel.
    * We step into the resync plugin to see what happens with the registration.
    * Actually it's very simple, the resync plugin just create a new Status channel internally and returns the Status channel out.

* After registration, the kvdbsync plugin calls ```watchAndResyncBrokerKeys``` to perform an initial status synchronization. Let's step into this function and see what has happened there.
    * The resync registrtation, change and resync channels passed in from the user plugin, the adapter that stores the etcd connection, and the registered keys that the user plugin intends to watch, are put into a special type called ```watchBrokerKeys```.
    * Then, the ```resyncRev``` method is called to perform an intitial synchronization with the database.
        * This method just acquires the key-val pair through the etcd connection and store the key-val pair inside an internal map.
    * In case that there is a new resync registration, the method starts a new goroutine ```watchResync```.
        * If someone, like the example plugin, would like to perform a resync, this plugin would send a message through the status channel.
        * this goroutine keeps watching the status channel, in case that a new event is received and this event is a ```resyncStart``` event, this goroutine start to work on resync by calling ```resync```.
            * This method just list all the values under the keys, store the key-val pairs inside a resync event, and sends the event into the resyncChan (which is passed in by the example plugin)
            * The resync event contains another channel for response notification. After the example plugin has consumed the resync event, it should sends the response back through this channel. When ```resync``` method receives this response, the resync procedure is done. (two way handshake)
        * Finally, when ```resync``` is finished, the goroutine responds an acknowledgement using the resync event.
    * If the example plugin has sent the changeChan, the method also starts to watch the etcd database for th key prefix. In case that the value under the key changes, the ```watchChanges``` callback is invoked.
        * 

* The initial resync event is sent by calling the ```DoResync``` method of the resync plugin.
