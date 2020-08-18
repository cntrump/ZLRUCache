# ZLRUCache
a fast thread-safed LRU memory cache.

[Benchmark](https://github.com/ibireme/YYCache/tree/master/Benchmark)

iPhone 8 plus, iOS 13.4.1

```
===========================
Memory cache set 200000 key-value pairs
NSDictionary:      39.10
NSDict+Lock:       34.90
YYMemoryCache:     91.46
PINMemoryCache:   166.72
NSCache:          156.53
ZLRUCache:          162.90

===========================
Memory cache set 200000 key-value pairs without resize
NSDictionary:      20.03
NSDict+Lock:       32.00
YYMemoryCache:    104.25
PINMemoryCache:   145.23
NSCache:          293.49
ZLRUCache:          106.96

===========================
Memory cache get 200000 key-value pairs
NSDictionary:      18.78
NSDict+Lock:       28.35
YYMemoryCache:     72.61
PINMemoryCache:   110.25
NSCache:           55.27
ZLRUCache:           65.81

===========================
Memory cache get 100000 key-value pairs randomly
NSDictionary:      35.82
NSDict+Lock:       52.57
YYMemoryCache:    103.90
PINMemoryCache:   114.01
NSCache:           97.19
ZLRUCache:          104.72

===========================
Memory cache get 200000 key-value pairs none exist
NSDictionary:      30.26
NSDict+Lock:       49.62
YYMemoryCache:     91.14
PINMemoryCache:    98.60
NSCache:           70.31
ZLRUCache:          105.48
```
