CREATE DATABASE IF NOT EXISTS db0
ENGINE = Ordinary

CREATE TABLE db0.a0_replicated (
    day Date,
    id UInt32,
)
ENGINE = MergeTree()
PARTITION BY day
ORDER BY id

CREATE TABLE a0 (
    day Date,
    id UInt32,
)
ENGINE = Distributed('ha0', 'db0', a0_replicated, id)

CREATE TABLE db0.b0_replicated (
    day Date,
    id UInt32,
)
ENGINE = MergeTree()
PARTITION BY day
ORDER BY id

CREATE TABLE b0 (
    day Date,
    id UInt32,
)
ENGINE = Distributed('ha0', 'db0', b0_replicated, id)

CREATE TABLE db0.a1_replicated (
    day Date,
    id UInt32
)
ENGINE = MergeTree()
PARTITION BY day
ORDER BY id

CREATE TABLE a1 (
    day Date,
    id UInt32
)
ENGINE = Distributed('ha1', 'db0', a1_replicated, id)

CREATE TABLE db0.b1_replicated (
    day Date,
    id UInt32
)
ENGINE = MergeTree()
PARTITION BY day
ORDER BY id

CREATE TABLE b1 (
    day Date,
    id UInt32
)
ENGINE = Distributed('ha1', 'db0', b1_replicated, id)
