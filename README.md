# Get code
```
git clone git@github.com:triebawerker/ocalfo.git
```

# Get gems
```
bundler
```

# Run seeds
in root directory
```
ruby app/seeds.rb
```

This will install a set of recipes (pancake and omelette) with ingredients and goods.

```
cd lib
ruby seeds.rb
```

h1 Get goods

Endpoint
```
GET <host>/goods.json
```

Response

```
[
  {
    "name": "flour",
    "unit": "g",
    "unit_size": 1000,
    "price_per_unit": 199
  },
  {
    "name": "sugar",
    "unit": "g",
    "unit_size": 1000,
    "price_per_unit": 99
  }, ...

  ]
```

  h1 Calculate order

```
POST <host>/order
```
Payload
```
{"recipes": [
  "name": "pancake",
  "quantity": 25
  ]
}
```
Response
```
[
  {"name":"egg",
  "quantity":100,
  "unit":"peace",
  "unit_size":10},
  {"name":"salt",
  "quantity":1,
  "unit":"g",
  "unit_size":500},
  {"name":"butter",
  "quantity":10,
  "unit":"g",
  "unit_size":250}
]
```
