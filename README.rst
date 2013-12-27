dping (Distributed ping)
=========================

This is a test application based on riak_core.

What is this?
--------------------

dping a.k.a distributed ping is HTTP checker application based on the riak_core.

dping can check web server availability from some nodes on different
networks. For example, internal network, monitoring company and some
home ISP network.

This is useful to find out a problem.

How to use
----------------

`attach` to the vnode and type `dping(<URL>).`

Below is a sample on the ring which includes 4 nodes(dping1-4).

::

  % dev/dev1/bin/dping attach
  (dping1@127.0.0.1)2> dping("http://www.google.com").
   command from 'dping1@127.0.0.1'
   dping to "http://www.google.com" recieved. node: <0.237.0> on 'dping1@127.0.0.1'
   responsed node 'dping1@127.0.0.1'
   responsed node 'dping2@127.0.0.1'
   responsed node 'dping3@127.0.0.1'
   dping to "http://www.google.com" success.
   ok

This shows HTTP GET was sent from dping1, 2, and 3.


Naming
---------

At first, I think check only ping(ICMP echo) but I noticed HTTP is more efficient....



License
-------------

2-clause BSD


