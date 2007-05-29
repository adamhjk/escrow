CREATE TABLE escrow (
    thing_id        text NOT NULL,
    key_id          text NOT NULL,
    value_id        text NOT NULL,
    UNIQUE (thing_id, key_id)
);

