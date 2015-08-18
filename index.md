python debug technics, different perspectives
=============================================

1. Runtime perspective
    1. Post-mortem analysis [p]
    2. Runtime analysis
        1. step-by-step debug [d]
        2. one-shot analysis [s]
2. Code change perspective
    1. Invasive — requires code change [i]
    2. Non-invasive — doesn't require any code change [n]

Python modules:

[p,i] logging
[p,s,i] traceback
[p,s,i] gc
[p,s,i] meliae
[d,i] pdb
[d,i] rpdb2
[s,n] pyrasite

Modules and tools
=================

logging
-------

Why not `print()`? Often it is simpler to use the `print()` call
to dump variables and runtime marks. But the `print()` call should
be used only for ad-hoc debug, when the debug code will not become
a part of the project one is working with.

Some of the `logging` module features:

* supports different output destinations: file, stderr, syslog
* available as a part of the stdlib

By default, one will not get the debug or info messages in the log.
To turn them on, one should use `logging.basicConfig()`:
```
    import logging
    logging.basicConfig(level=logging.DEBUG)
```

traceback
---------

The typical usage of the `traceback` module is the `try … except`
statement:
```
    import logging
    import traceback

    try:
        do_whatever()
    except:
        logging.error(traceback.format_exc())
        do_cleanup()
```

But that's not all. One can use it in the ordinary code to get
tracebacks while in the process:
```
    import logging
    import traceback

    def some_func():
        do_whatever()
        logging.debug(''.join(traceback.format_stack()))
```

gc, meliae
----------

Though Python is a memory-safe language, in some complex project
one can forget to unlink objects, thus having a memory leaks. All
the objects are tracked by Python's garbage collector, and there
is an API to access it, the `gc` module:
```
    import gc

    do_whatever()
    target = my_filter(gc.get_objects())
    print('target refers:', gc.get_referents(target))
    print('target is referred by:', gc.get_referrers(target))
```

It is possible to work with individual objects via `gc`, but when
there are thousands of them, one must have a reasonable overview.
In that case one can use the `meliae` module to dump all the
gc map into a json file and/or load and analyze it:
```
    import gc
    from meliae import scanner
    from meliae import loader

    do_whatever()
    # first, cleanup everything unrelated
    gc.collect()
    # then, dump the map
    scanner.dump_all_objects('map.json')
    # load & analyze the map
    om = loader.load('map.json')
    print(om.summarize())
```

pdb, rpdb2
----------

There are several Python debuggers, but mostly known are `pdb` and
`rpdb2`. They both have similar approach and similar technics, but
`rpdb2` has several advantages over `pdb`:

* threads support
* graphical interface
* remote debugging

To start an embedded debugger session:
```
    import pdb
    do_whatever()
    pdb.set_trace()
    do_other_stuff()
```

This will start an interactive `pdb` console. In order to do so, one
should start the process also in the foreground on a console.

To do the same with `rpdb2`:
```
    import rpdb2
    do_whatever()
    rpdb2.start_embedded_debugger('secret', fAllowRemote=True)
    do_other_stuff()
```

Unlike `pdb`, the `rpdb2` debugger will not start an interactive
console, but will allow you to attach to the process from GUI or CLI:
```
$ rpdb2
RPDB2 - The Remote Python Debugger, version RPDB_2_4_8,
Copyright (C) 2005-2009 Nir Aides.
Type "help", "copyright", "license", "credits" for more information.

> password secret
Password is set to: "secret"

> host 10.0.0.1

> attach
Connecting to '10.0.0.1'...
Scripts to debug on '10.0.0.1':

   pid    name
--------------------------
   21515  /home/user/test.py

> attach 21515
...
```

Pls keep in mind, that one should keep the firewall down for the port
51000 in order to be able to connect to the target script.

One can also start a script under debugger:
```
$ rpdb2 /home/user/test.py
```

To start the GUI for `rpdb2`, one can use command `winpdb`.

pyrasite
--------

One of the most important debugging technics, since it can be used to
get traces from running processes without need to modify the code or
even restart the process:
```
$ pyrasite <pid> <payload>
```

The `payload` Python code will be injected and executed in the target
process. Please keep in mind, that if you plan to use prints in the
payload, the target's `stdout` and `stderr` files will be used.

To print something in the local console, you should run `pyrasite-shell`
and just paste the corresponding payload:
```
$ pyrasite-shell 2487
Pyrasite Shell 2.0
Connected to '/usr/bin/python2 /home/user/test.py'
Python 2.7.5 (default, Apr 10 2015, 08:09:05)
[GCC 4.8.3 20140911 (Red Hat 4.8.3-7)] on linux2
Type "help", "copyright", "credits" or "license" for more information.
(DistantInteractiveConsole)

>>> import sys, traceback
>>>
>>> for thread, frame in sys._current_frames().items():
...     print('Thread 0x%x' % thread)
...     traceback.print_stack(frame)
...     print()
...

```

Corner cases
============

* eventlet debug
* ...
