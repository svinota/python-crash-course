python debug technics, different perspectives
---------------------------------------------

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
-----------------

logging
=======

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
=========

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
==========

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

pdb
===

td

rpdb2
=====

td

pyrasite
========

td

Corner cases
------------

td
