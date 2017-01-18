Vagrant-reload
==============

A reload plugin for Vagrant. Gives you the ability to reload your machine as a provisioning step.

The plugin takes an optional condition as argument, making it possible to tune whether or not
reloading should be done.

Examples
========

```
Vagrant.configure(2) do |config|
    ...

    # This will just reload
    config.vm.provision "reload"

    # This will not reload
    config.vm.provision "reload", condition: false

    # This will reload some times
    config.vm.provision "reload", condition: lambda {
      r = Random.new
      return r.rand(100) >= 50
    }

    # This will reload if some var is set
    # Note that this will evaluate on configure time, not at provision time
    config.vm.provision "reload", condition: File.exists?(SOME_FILE)

    # The same as above, but evaluated at provision time
    config.vm.provision "reload", condition: lambda { File.exists?(SOME_FILE) }

    ...
end
```

