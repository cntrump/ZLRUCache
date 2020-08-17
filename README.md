# ZLRUCache
a fast thread-safed LRU memory cache.

[Benchmark](https://github.com/ibireme/YYCache/tree/master/Benchmark)

iPhone 8 plus, iOS 13.4.1

```
===========================
Memory cache set 200000 key-value pairs
NSDictionary:      31.99
NSDict+Lock:       35.23
YYMemoryCache:     82.18
PINMemoryCache:   149.33
NSCache:          152.05
ZLRUCache:          145.27

===========================
Memory cache set 200000 key-value pairs without resize
NSDictionary:      15.04
NSDict+Lock:       23.91
YYMemoryCache:     84.02
PINMemoryCache:   132.77
NSCache:          151.66
ZLRUCache:           81.45

===========================
Memory cache get 200000 key-value pairs
NSDictionary:      15.05
NSDict+Lock:       24.32
YYMemoryCache:     50.43
PINMemoryCache:    87.11
NSCache:           16.27
ZLRUCache:           43.20

===========================
Memory cache get 100000 key-value pairs randomly
NSDictionary:      28.33
NSDict+Lock:       37.62
YYMemoryCache:     94.44
PINMemoryCache:    98.85
NSCache:           19.03
ZLRUCache:           84.85

===========================
Memory cache get 200000 key-value pairs none exist
NSDictionary:      27.16
NSDict+Lock:       38.84
YYMemoryCache:     83.28
PINMemoryCache:    91.52
NSCache:           18.96
ZLRUCache:           81.66
```
