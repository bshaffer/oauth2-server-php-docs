---
title: Storage | OAuth2 Server PHP
---

# Storage

## Overview

This library supports adapters for several different storage engines.
Among them is [PDO](../../storage/pdo) (for MySQL, SQLite, PostgreSQL, etc),
[MongoDB](../../storage/mongo), [Redis](../../storage/redis), and
[Cassandra](../../storage/cassandra).

This is done through multiple PHP Interfaces which dictate how different
objects are stored. Interfaces allow the library to be extended and
customized for multiple platforms, making it easy to
[Write your own Storage class](../../storage/custom/).

Storage interfaces also make it easy to store your objects across
[multiple data storage systems](../../storage/multiple).