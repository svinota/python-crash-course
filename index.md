python debug technics, different perspectives
---------------------------------------------

1. Runtime perspective
    1. Post-mortem analysis [p]
    2. Runtime analysis
        1. step-by-step debug [d]
        2. one-shot analysis [s]
2. Code change perspective
    1. Invasive — require code change [i]
    2. Non-invasive — don't require any code change [n]

Python modules:

[p,i] logging
[p,s,i] traceback
[p,s,i] gc
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

gc
==

td

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
