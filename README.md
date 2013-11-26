Shover
======

Must be HTTPS protected.

### POST /publish

Params:

`p` - MessageVerifier signed payload of `[user_id, event_name, data_hash]`

### POST /broadcast

Params:

`p` - MessageVerifier signed payload of `[event_name, data_hash]`

-----
Copyright (c) 2013 Irrational Industries Inc. All Rights Reserved.
