Description
===========

Add apt repository and install mongodb-10gen.

### Tested on

* ubuntu 12.04(precise)

Requirements
============

- OpscodeCookbook[apt]


Attributes
==========

Usage
=====

### Available recipes

#### default

- Add 10gen official repository and install newer stable mongodb.
- **disable** autostart when install or serverboot.

#### single

- setup mongodb single node.
- node-id is written at `attribute[nodemane]`, you can override and create many mongodb instances.

#### replica-sets

will here soon..

Additions
=====

### mongorc.js

Print information to prompt.  

Usage: `cp {mongo_dir}misc/mongorc.js ~/.mongorc.js`

<pre><code># mongo
MongoDB shell version: 2.0.4
connecting to: test
s01:PRIMARY:[2.0.4] > </code></pre>