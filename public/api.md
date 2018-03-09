# Resource: Addresses

## Action: Create an Address

### Description:

#### Signature:

**POST** `/api/v1/addresses`

#### Parameters:

Name | Type | Description
-----|------|---------|------------
 label | *string* `Example: label` | 
 city | *string* `Example: city` | 
 street | *string* `Example: street 123` | 
 zip_code | *string* `Example: 01-222` | 
 country | *string* `Example: Poland` | 
 primary | *integer* `Example: 1` | 

### Examples:

#### Example: /api/v1/addresses /api/v1/addresses/#create error

##### Request headers:

    Content-Type: application/x-www-form-urlencoded
    Access-Token: B-BtKR26DHjh6QSOIofGaw
    Client:       7a8XlCfpwBP-iOJ62bj88g
    Expiry:       1468491978
    Uid:          cary@huel.info

##### Request params:

    {
      "label": "",
      "city": "Warsaw",
      "street": "",
      "zip_code": "01-222",
      "country": ""
    }

##### Response headers:

    Status:       400
    Content-Type: application/json
    Access-token: B-BtKR26DHjh6QSOIofGaw
    Client:       7a8XlCfpwBP-iOJ62bj88g
    Expiry:       1468491978
    Uid:          cary@huel.info

##### Response body:

    [
      "Street can't be blank",
      "Country can't be blank",
      "Primary can't be blank"
    ]

#### Example: /api/v1/addresses /api/v1/addresses/#create

##### Request headers:

    Content-Type: application/x-www-form-urlencoded
    Access-Token: DwoaOsC7VZbUYG3mK0nNlA
    Client:       fKWR4t-rTTI5w0K4vhIjjA
    Expiry:       1468491978
    Uid:          coty@hegmann.com

##### Request params:

    {
      "label": "label",
      "city": "city",
      "street": "street 123",
      "zip_code": "01-222",
      "country": "Poland",
      "primary": "1"
    }

##### Response headers:

    Status:       200
    Content-Type: application/json
    Access-token: DwoaOsC7VZbUYG3mK0nNlA
    Client:       fKWR4t-rTTI5w0K4vhIjjA
    Expiry:       1468491978
    Uid:          coty@hegmann.com

##### Response body:

    {
      "id": 4,
      "user_id": 2,
      "label": "label",
      "city": "city",
      "street": "street 123",
      "zip_code": "01-222",
      "country": "Poland",
      "primary": "true"
    }

## Action: Update an existing Address

### Description:

#### Signature:

**PUT** `/api/v1/addresses/{id}`

#### Parameters:

Name | Type | Description
-----|------|---------|------------
 label | *string* `Example: home` | 
 city | *string* `Example: Warsaw` | 
 zip_code | *string* `Example: 01-222` | 
 primary | *integer* `Example: 1` | 
 id | *integer* `Example: 5` | 

### Examples:

#### Example: /api/v1/addresses /api/v1/addresses/#update

##### Request headers:

    Content-Type: application/x-www-form-urlencoded
    Access-Token: gAkvd5yH-Suw7ZgkVyAx9Q
    Client:       lNdmHNhjH11WEG5VwGZvKw
    Expiry:       1468491978
    Uid:          breanna@bergecarroll.name

##### Request params:

    {
      "label": "home",
      "city": "Warsaw",
      "zip_code": "01-222",
      "primary": "1",
      "id": "5"
    }

##### Response headers:

    Status:       200
    Content-Type: application/json
    Access-token: gAkvd5yH-Suw7ZgkVyAx9Q
    Client:       lNdmHNhjH11WEG5VwGZvKw
    Expiry:       1468491978
    Uid:          breanna@bergecarroll.name

##### Response body:

    {
      "id": 5,
      "user_id": 4,
      "label": "home",
      "city": "Warsaw",
      "street": "Street 12",
      "zip_code": "01-222",
      "country": "Poland",
      "primary": "true"
    }

## Action: Remove an existing Address

### Description:

#### Signature:

**DELETE** `/api/v1/addresses/{id}`

#### Parameters:

Name | Type | Description
-----|------|---------|------------
 id | *integer* `Example: 6` | 

### Examples:

#### Example: /api/v1/addresses /api/v1/addresses/#destroy

##### Request headers:

    Content-Type: application/x-www-form-urlencoded
    Access-Token: S-r7XKCrw-mLDVHf_jGjhQ
    Client:       h-5FVYpxjGid_e5jGQ7MJA
    Expiry:       1468491978
    Uid:          ariel_mitchell@okonrohan.io

##### Request params:

    {
      "id": "6"
    }

##### Response headers:

    Status:       200
    Content-Type: text/plain
    Access-token: S-r7XKCrw-mLDVHf_jGjhQ
    Client:       h-5FVYpxjGid_e5jGQ7MJA
    Expiry:       1468491978
    Uid:          ariel_mitchell@okonrohan.io

##### Response body:



## Action: List all Addresses

### Description:

#### Signature:

**GET** `/api/v1/addresses`

#### Parameters:

Name | Type | Description
-----|------|---------|------------

### Examples:

#### Example: /api/v1/addresses /api/v1/addresses

##### Request headers:

    Content-Type: application/x-www-form-urlencoded
    Access-Token: xYEjvpaPEeCI8C1egghUfw
    Client:       2zsfQrR6PhI2mSVINFg5Yg
    Expiry:       1468491977
    Uid:          zachariah.bednar@roobemmerich.biz

##### Response headers:

    Status:       200
    Content-Type: application/json
    Access-token: xYEjvpaPEeCI8C1egghUfw
    Client:       2zsfQrR6PhI2mSVINFg5Yg
    Expiry:       1468491977
    Uid:          zachariah.bednar@roobemmerich.biz

##### Response body:

    [
      {
        "id": 1,
        "user_id": 1,
        "label": "Label",
        "city": "New York",
        "street": "Street 12",
        "zip_code": "15-241",
        "country": "Poland",
        "primary": ""
      },
      {
        "id": 2,
        "user_id": 1,
        "label": "Label",
        "city": "London",
        "street": "Street 12",
        "zip_code": "15-241",
        "country": "Poland",
        "primary": ""
      }
    ]

# Resource: Carousels

## Action: Home a Carousel

### Description:

#### Signature:

**GET** `/api/v1/carousel/home`

#### Parameters:

Name | Type | Description
-----|------|---------|------------

### Examples:

#### Example: /api/v1/carousel/home

##### Request headers:

    Content-Type: application/x-www-form-urlencoded

##### Response headers:

    Status:       200
    Content-Type: application/json

##### Response body:

    [
      {
        "name": "Trending",
        "icon_url": "",
        "type": "trending"
      },
      {
        "id": 2,
        "name": "Man",
        "icon_url": "/fallback/carousel_default_picture.png",
        "subcategories": [
    
        ],
        "type": "category"
      },
      {
        "id": 1,
        "name": "Woman",
        "icon_url": "/fallback/carousel_default_picture.png",
        "subcategories": [
    
        ],
        "type": "category"
      },
      {
        "name": "Tv",
        "icon_url": "",
        "type": "tv"
      },
      {
        "name": "Magazine",
        "icon_url": "",
        "type": "magazine"
      }
    ]

# Resource: Categories

## Action: List all Categories

### Description:

#### Signature:

**GET** `/api/v1/categories`

#### Parameters:

Name | Type | Description
-----|------|---------|------------
 parent_id | *integer* `Example: 9` | 

### Examples:

#### Example: /api/v1/categories?parent_id=1

##### Request headers:

    Content-Type: application/x-www-form-urlencoded

##### Request params:

    {
      "parent_id": "5"
    }

##### Response headers:

    Status:       200
    Content-Type: application/json

##### Response body:

    [
      {
        "id": 7,
        "parent_id": "5",
        "name": "Woman Shoes",
        "image": "/assets/fallback/default_picture-5b9ea71fca84bac245fb046d833b7fc0ffe73432a71c950813658a699696f0a3.png",
        "icon": "/assets/fallback/default_picture-5b9ea71fca84bac245fb046d833b7fc0ffe73432a71c950813658a699696f0a3.png"
      }
    ]

#### Example: /api/v1/categories?parent_name=Woman

##### Request headers:

    Content-Type: application/x-www-form-urlencoded

##### Request params:

    {
      "parent_id": "9"
    }

##### Response headers:

    Status:       200
    Content-Type: application/json

##### Response body:

    [
      {
        "id": 11,
        "parent_id": "9",
        "name": "Woman Shoes",
        "image": "/assets/fallback/default_picture-5b9ea71fca84bac245fb046d833b7fc0ffe73432a71c950813658a699696f0a3.png",
        "icon": "/assets/fallback/default_picture-5b9ea71fca84bac245fb046d833b7fc0ffe73432a71c950813658a699696f0a3.png"
      }
    ]

#### Example: /api/v1/categories

##### Request headers:

    Content-Type: application/x-www-form-urlencoded

##### Response headers:

    Status:       200
    Content-Type: application/json

##### Response body:

    [
      {
        "id": 4,
        "parent_id": "",
        "name": "Man",
        "image": "/assets/fallback/default_picture-5b9ea71fca84bac245fb046d833b7fc0ffe73432a71c950813658a699696f0a3.png",
        "icon": "/assets/fallback/default_picture-5b9ea71fca84bac245fb046d833b7fc0ffe73432a71c950813658a699696f0a3.png"
      },
      {
        "id": 3,
        "parent_id": "",
        "name": "Woman",
        "image": "/assets/fallback/default_picture-5b9ea71fca84bac245fb046d833b7fc0ffe73432a71c950813658a699696f0a3.png",
        "icon": "/assets/fallback/default_picture-5b9ea71fca84bac245fb046d833b7fc0ffe73432a71c950813658a699696f0a3.png"
      }
    ]

## Action: Tree a Category

### Description:

#### Signature:

**GET** `/api/v1/categories/tree`

#### Parameters:

Name | Type | Description
-----|------|---------|------------

### Examples:

#### Example: /api/v1/categories/tree

##### Request headers:

    Content-Type: application/x-www-form-urlencoded

##### Response headers:

    Status:       200
    Content-Type: application/json

##### Response body:

    [
      {
        "id": 14,
        "name": "Man",
        "icon_url": "/fallback/carousel_default_picture.png",
        "subcategories": [
          {
            "id": 16,
            "name": "Man Shoes",
            "icon_url": "/fallback/carousel_default_picture.png",
            "subcategories": [
    
            ]
          }
        ]
      },
      {
        "id": 13,
        "name": "Woman",
        "icon_url": "/fallback/carousel_default_picture.png",
        "subcategories": [
          {
            "id": 15,
            "name": "Woman Shoes",
            "icon_url": "/fallback/carousel_default_picture.png",
            "subcategories": [
    
            ]
          }
        ]
      }
    ]

# Resource: Channels

## Action: List all Channels

### Description:

#### Signature:

**GET** `/api/v1/channels`

#### Parameters:

Name | Type | Description
-----|------|---------|------------
 category_id | *integer* `Example: 17` | 

### Examples:

#### Example: /api/v1/channels?category_id=1

##### Request headers:

    Content-Type: application/x-www-form-urlencoded

##### Request params:

    {
      "category_id": "17"
    }

##### Response headers:

    Status:       200
    Content-Type: application/json

##### Response body:

    [
      {
        "id": 9,
        "name": "MTV",
        "thumbnail_url": "/uploads/channel_picture/9/4/9/custom_my_picture.png",
        "image_url": "/uploads/channel_picture/9/4/9/custom_my_picture.png",
        "feed": true,
        "magazines": false,
        "tv_shows": false
      },
      {
        "id": 8,
        "name": "MTV",
        "thumbnail_url": "/uploads/channel_picture/8/4/8/custom_my_picture.png",
        "image_url": "/uploads/channel_picture/8/4/8/custom_my_picture.png",
        "feed": true,
        "magazines": false,
        "tv_shows": false
      }
    ]

#### Example: /api/v1/channels

##### Request headers:

    Content-Type: application/x-www-form-urlencoded

##### Response headers:

    Status:       200
    Content-Type: application/json

##### Response body:

    [
      {
        "id": 2,
        "name": "Viva",
        "thumbnail_url": "/uploads/channel_picture/2/1/2/custom_my_picture.png",
        "image_url": "/uploads/channel_picture/2/1/2/custom_my_picture.png",
        "feed": true,
        "magazines": false,
        "tv_shows": false
      },
      {
        "id": 1,
        "name": "MTV",
        "thumbnail_url": "/uploads/channel_picture/1/0/1/custom_my_picture.png",
        "image_url": "/uploads/channel_picture/1/0/1/custom_my_picture.png",
        "feed": true,
        "magazines": false,
        "tv_shows": false
      }
    ]

#### Example: /api/v1/channels with following flag wrong token

##### Request headers:

    Content-Type: application/x-www-form-urlencoded
    Access-Token: zfyZOdltUvnvZK1Gw
    Client:       EDy68nOY54fJeemrNunitQ
    Expiry:       1463745453
    Uid:          sylvester@schmidt.org

##### Response headers:

    Status:       401
    Content-Type: application/json

##### Response body:

    {
      "errors": [
        "Authorized users only."
      ]
    }

#### Example: /api/v1/channels with following flag

##### Request headers:

    Content-Type: application/x-www-form-urlencoded
    Access-Token: SrKw4lg4iMqMTr-_mGbReQ
    Client:       CtMgGQIa8O9GzVjG_TeSWg
    Expiry:       1468491979
    Uid:          maureen@crist.name

##### Response headers:

    Status:       200
    Content-Type: application/json
    Access-token: SrKw4lg4iMqMTr-_mGbReQ
    Client:       CtMgGQIa8O9GzVjG_TeSWg
    Expiry:       1468491979
    Uid:          maureen@crist.name

##### Response body:

    [
      {
        "id": 4,
        "name": "Viva",
        "thumbnail_url": "/uploads/channel_picture/4/2/4/custom_my_picture.png",
        "image_url": "/uploads/channel_picture/4/2/4/custom_my_picture.png",
        "feed": true,
        "magazines": false,
        "tv_shows": false,
        "is_followed": false
      },
      {
        "id": 3,
        "name": "MTV",
        "thumbnail_url": "/uploads/channel_picture/3/1/3/custom_my_picture.png",
        "image_url": "/uploads/channel_picture/3/1/3/custom_my_picture.png",
        "feed": true,
        "magazines": false,
        "tv_shows": false,
        "is_followed": true
      }
    ]

## Action: Discovery a Channel

### Description:

#### Signature:

**GET** `/api/v1/channels/discovery`

#### Parameters:

Name | Type | Description
-----|------|---------|------------
 number_of_posts | *integer* `Example: 25` | 
 timestamp | *integer* `Example: 1467282380` | 

### Examples:

#### Example: /api/v1/channels/discovery?number_of_posts=25&timestamp=1781096123

##### Request headers:

    Content-Type: application/x-www-form-urlencoded

##### Request params:

    {
      "number_of_posts": "25",
      "timestamp": "1467282380"
    }

##### Response headers:

    Status:       200
    Content-Type: application/json

##### Response body:

    {
      "social_media_containers": [
        {
          "type": "social_media_container",
          "id": 18,
          "date": 1467163265,
          "width": "half",
          "post_type": "video",
          "content_title": "A Glass of Blessings",
          "content_body": "Cumque veniam minus asperiores harum quis.",
          "post_url": "http://mullerbrown.info/millie.mueller",
          "website": "twitter",
          "icon": "http://localhost:3000/icons/twitter.png",
          "owner": {
            "id": 13,
            "type": "channel",
            "name": "MTV",
            "thumbnail_url": "/uploads/channel_picture/13/6/13/custom_my_picture.png"
          },
          "content": {
            "type": "video/mp4",
            "url": "/home/mariusz/working/hotspotting/spec/support/uploads/post/content_video/18/video.mp4",
            "thumbnail_url": "/home/mariusz/working/hotspotting/spec/support/uploads/post/content_video/18/video_thumb_video.jpg"
          },
          "has_products": false
        },
        {
          "type": "social_media_container",
          "id": 16,
          "date": 1467071071,
          "width": "half",
          "post_type": "video",
          "content_title": "The Mirror Crack'd from Side to Side",
          "content_body": "Aut numquam unde omnis.",
          "post_url": "http://mcglynn.net/edison",
          "website": "instagram",
          "icon": "http://localhost:3000/icons/instagram.png",
          "owner": {
            "id": 12,
            "type": "channel",
            "name": "MTV",
            "thumbnail_url": "/uploads/channel_picture/12/6/12/custom_my_picture.png"
          },
          "content": {
            "type": "video/mp4",
            "url": "/home/mariusz/working/hotspotting/spec/support/uploads/post/content_video/16/video.mp4",
            "thumbnail_url": "/home/mariusz/working/hotspotting/spec/support/uploads/post/content_video/16/video_thumb_video.jpg"
          },
          "has_products": false
        },
        {
          "type": "social_media_container",
          "id": 15,
          "date": 1467067217,
          "width": "half",
          "post_type": "image",
          "content_title": "The Last Enemy",
          "content_body": "Qui est in officiis facilis dolore id.",
          "post_url": "http://mcclure.info/maybell",
          "website": "instagram",
          "icon": "http://localhost:3000/icons/instagram.png",
          "owner": {
            "id": 12,
            "type": "channel",
            "name": "MTV",
            "thumbnail_url": "/uploads/channel_picture/12/6/12/custom_my_picture.png"
          },
          "content": {
            "type": "image",
            "url": "/home/mariusz/working/hotspotting/spec/support/uploads/post/content_picture/15/my_picture_tgf0hymxb7.png",
            "thumbnail_url": "/home/mariusz/working/hotspotting/spec/support/uploads/post/content_picture/15/my_picture_tgf0hymxb7.png"
          },
          "has_products": false
        },
        {
          "type": "social_media_container",
          "id": 13,
          "date": 1466954649,
          "width": "half",
          "post_type": "image",
          "content_title": "In Dubious Battle",
          "content_body": "Consequatur similique dolor dolores.",
          "post_url": "http://murazik.net/jack_dibbert",
          "website": "facebook",
          "icon": "http://localhost:3000/icons/facebook.png",
          "owner": {
            "id": 3,
            "type": "media_owner",
            "name": "Ole Yundt DVM",
            "thumbnail_url": "/uploads/media_owner_picture/3/1/3/custom_my_picture.png"
          },
          "content": {
            "type": "image",
            "url": "/home/mariusz/working/hotspotting/spec/support/uploads/post/content_picture/13/my_picture_1d49hmwpty.png",
            "thumbnail_url": "/home/mariusz/working/hotspotting/spec/support/uploads/post/content_picture/13/my_picture_1d49hmwpty.png"
          },
          "has_products": false
        },
        {
          "type": "social_media_container",
          "id": 14,
          "date": 1466823239,
          "width": "half",
          "post_type": "video",
          "content_title": "Recalled to Life",
          "content_body": "Et perspiciatis sed numquam omnis.",
          "post_url": "http://kris.io/karli",
          "website": "facebook",
          "icon": "http://localhost:3000/icons/facebook.png",
          "owner": {
            "id": 3,
            "type": "media_owner",
            "name": "Ole Yundt DVM",
            "thumbnail_url": "/uploads/media_owner_picture/3/1/3/custom_my_picture.png"
          },
          "content": {
            "type": "video/mp4",
            "url": "/home/mariusz/working/hotspotting/spec/support/uploads/post/content_video/14/video.mp4",
            "thumbnail_url": "/home/mariusz/working/hotspotting/spec/support/uploads/post/content_video/14/video_thumb_video.jpg"
          },
          "has_products": false
        },
        {
          "type": "social_media_container",
          "id": 17,
          "date": 1466692115,
          "width": "half",
          "post_type": "image",
          "content_title": "Great Work of Time",
          "content_body": "Repudiandae eos adipisci ullam eum.",
          "post_url": "http://parkerlueilwitz.io/timothy",
          "website": "twitter",
          "icon": "http://localhost:3000/icons/twitter.png",
          "owner": {
            "id": 13,
            "type": "channel",
            "name": "MTV",
            "thumbnail_url": "/uploads/channel_picture/13/6/13/custom_my_picture.png"
          },
          "content": {
            "type": "image",
            "url": "/home/mariusz/working/hotspotting/spec/support/uploads/post/content_picture/17/my_picture_xazfkey4uw.png",
            "thumbnail_url": "/home/mariusz/working/hotspotting/spec/support/uploads/post/content_picture/17/my_picture_xazfkey4uw.png"
          },
          "has_products": false
        }
      ]
    }

## Action: Retrieve single Channel

### Description:

#### Signature:

**GET** `/api/v1/channels/{id}`

#### Parameters:

Name | Type | Description
-----|------|---------|------------
 id | *integer* `Example: 7` | 

### Examples:

#### Example: /api/v1/channels/:id

##### Request headers:

    Content-Type: application/x-www-form-urlencoded

##### Request params:

    {
      "id": "7"
    }

##### Response headers:

    Status:       200
    Content-Type: application/json

##### Response body:

    {
      "id": 7,
      "name": "MTV",
      "thumbnail_url": "/uploads/channel_picture/7/3/7/custom_my_picture.png",
      "image_url": "/uploads/channel_picture/7/3/7/custom_my_picture.png",
      "feed": true,
      "magazines": false,
      "tv_shows": false
    }

## Action: Trending a Channel

### Description:

#### Signature:

**GET** `/api/v1/channels/14/trending`

#### Parameters:

Name | Type | Description
-----|------|---------|------------
 id | *integer* `Example: 14` | 

### Examples:

#### Example: /api/v1/channels/1/trending

##### Request headers:

    Content-Type: application/x-www-form-urlencoded

##### Request params:

    {
      "id": "14"
    }

##### Response headers:

    Status:       200
    Content-Type: application/json

##### Response body:

    {
      "collections_containers": [
        {
          "type": "collections_container",
          "name": "collections",
          "collections": [
    
          ],
          "position": 2,
          "width": "full"
        }
      ],
      "products_containers": [
        {
          "type": "products_container",
          "id": 2,
          "name": "products container",
          "date": "2016-06-30 10:26:20 UTC",
          "products": [
            {
              "id": 2,
              "name": "Ewok",
              "brand": "Hoth",
              "description": "You'll find I'm full of surprises!",
              "vendor_url": "",
              "vendor": "",
              "image": "",
              "small_image": "",
              "medium_image": "",
              "price_min": 0.0,
              "price_max": 0.0,
              "currency": "USD",
              "asin": "",
              "available": 0
            }
          ],
          "position": 1,
          "width": "full"
        }
      ],
      "media_containers": [
        {
          "type": "media_container",
          "id": 4,
          "date": 1467121061,
          "name": "media container",
          "description": "Eveniet voluptatem aliquam reprehenderit. Et voluptates qui qui nisi. Fuga cum qui eveniet beatae. Minima debitis totam quae ut ea nobis natus.",
          "additional_description": "I'll hack the primary JBOD matrix, that should program the CSS pixel!",
          "width": "half",
          "owner": {
            "id": 4,
            "type": "media_owner",
            "name": "Emerald Wolf",
            "thumbnail_url": "/uploads/media_owner_picture/4/2/4/custom_my_picture.png"
          },
          "content": {
            "type": "image/png",
            "url": "/home/mariusz/working/hotspotting/spec/support/uploads/media_content/file/2/my_picture_ejjzd22jjn.png",
            "thumbnail_url": "/home/mariusz/working/hotspotting/spec/support/uploads/media_content/file/2/thumb_my_picture_ejjzd22jjn.png"
          },
          "position": 3
        },
        {
          "type": "media_container",
          "id": 5,
          "date": 1466904323,
          "name": "media container",
          "description": "Deserunt quia hic. At error tempore qui earum voluptatem. Ut tempora voluptatibus minima ipsam rem aspernatur distinctio. Est perspiciatis deleniti nam nesciunt sunt quia exercitationem.",
          "additional_description": "If we bypass the sensor, we can get to the FTP firewall through the online SSL firewall!",
          "width": "full",
          "owner": {
            "id": 15,
            "type": "channel",
            "name": "MTV",
            "thumbnail_url": "/uploads/channel_picture/15/7/15/custom_my_picture.png"
          },
          "content": {
            "type": "image/png",
            "url": "/home/mariusz/working/hotspotting/spec/support/uploads/media_content/file/3/my_picture_f0dgdk5qp6.png",
            "thumbnail_url": "/home/mariusz/working/hotspotting/spec/support/uploads/media_content/file/3/thumb_my_picture_f0dgdk5qp6.png"
          },
          "position": 11
        }
      ],
      "combo_containers": [
        {
          "type": "combo_container",
          "id": 3,
          "name": "combo container",
          "date": "2016-06-30 10:26:20 UTC",
          "products": [
            {
              "id": 3,
              "name": "Ewok",
              "brand": "Takodana",
              "description": "You'll find I'm full of surprises!",
              "vendor_url": "",
              "vendor": "",
              "image": "",
              "small_image": "",
              "medium_image": "",
              "price_min": 0.0,
              "price_max": 0.0,
              "currency": "USD",
              "asin": "",
              "available": 0
            }
          ],
          "description": null,
          "media_owner": {
            "id": 5,
            "name": "Dr. Thad Kshlerin",
            "thumbnail_url": "/uploads/media_owner_picture/5/2/5/custom_my_picture.png"
          },
          "content": {
            "image_url": "",
            "type": "",
            "url": "",
            "thumbnail_url": "",
            "media_container_url": "",
            "combo_container_url": "",
            "specification": {
            }
          },
          "position": 4,
          "width": "half"
        }
      ],
      "single_product_containers": [
        {
          "id": 4,
          "name": "Name of the Product",
          "brand": "Lothal",
          "description": "That is why you fail.",
          "vendor_url": "",
          "vendor": "",
          "image": "",
          "small_image": "",
          "medium_image": "",
          "price_min": 0.0,
          "price_max": 0.0,
          "currency": "USD",
          "asin": "",
          "available": 0,
          "position": 5,
          "width": "full"
        },
        {
          "id": 5,
          "name": "Another Product Name",
          "brand": "Dagobah",
          "description": "Fear is the path to the dark side... fear leads to anger... anger leads to hate... hate leads to suffering.",
          "vendor_url": "",
          "vendor": "",
          "image": "",
          "small_image": "",
          "medium_image": "",
          "price_min": 0.0,
          "price_max": 0.0,
          "currency": "USD",
          "asin": "",
          "available": 0,
          "position": 10,
          "width": "full"
        }
      ],
      "links_containers": [
        {
          "id": 1,
          "target_id": 6,
          "name": "Celebrity Name",
          "type": "link_container",
          "link_type": "media_owner",
          "number_of_videos": 0,
          "description": "",
          "image_url": "/uploads/media_owner_picture/6/3/6/custom_my_picture.png",
          "position": 6,
          "width": "full"
        },
        {
          "id": 2,
          "target_id": 1,
          "name": "Magazine title",
          "type": "link_container",
          "link_type": "magazine",
          "number_of_videos": 0,
          "description": "Vhs pitchfork fixie kogi aesthetic you probably haven't heard of them taxidermy venmo. Pinterest plaid kogi disrupt crucifix next level lomo quinoa. Offal slow-carb poutine thundercats sartorial raw denim put a bird on it tattooed. Chartreuse knausgaard next level.",
          "image_url": "/uploads/magazine_cover_image/1/0/1/custom_my_picture.png",
          "number_of_issues": 0,
          "position": 8,
          "width": "half"
        },
        {
          "id": 3,
          "target_id": 1,
          "name": "Tv Show title",
          "type": "link_container",
          "link_type": "tv_show",
          "number_of_videos": 2,
          "description": "Truffaut five dollar toast lo-fi. Swag schlitz actually messenger bag hammock craft beer meditation. Venmo loko authentic.",
          "image_url": "/uploads/tv_show_cover_image/1/0/1/custom_my_picture.png",
          "position": 9,
          "width": "full"
        },
        {
          "id": 4,
          "target_id": 1,
          "name": "Event Super Name",
          "type": "link_container",
          "link_type": "event",
          "number_of_videos": 0,
          "description": "",
          "image_url": "",
          "position": 12,
          "width": "full"
        }
      ]
    }

## Action: Feed a Channel

### Description:

#### Signature:

**GET** `/api/v1/channels/10/feed`

#### Parameters:

Name | Type | Description
-----|------|---------|------------
 number_of_posts | *integer* `Example: 25` | 
 timestamp | *integer* `Example: 1467282379` | 
 id | *integer* `Example: 10` | 

### Examples:

#### Example: /api/v1/channels/:id/feed?number_of_posts=25&timestamp=1781096123

##### Request headers:

    Content-Type: application/x-www-form-urlencoded

##### Request params:

    {
      "number_of_posts": "25",
      "timestamp": "1467282379",
      "id": "10"
    }

##### Response headers:

    Status:       200
    Content-Type: application/json

##### Response body:

    {
      "social_media_containers": [
        {
          "type": "social_media_container",
          "id": 3,
          "date": 1467246289,
          "width": "half",
          "post_type": "image",
          "content_title": "Butter In a Lordly Dish",
          "content_body": "Officia debitis quis doloribus enim.",
          "post_url": "http://renner.name/ronaldo",
          "website": "instagram",
          "icon": "http://localhost:3000/icons/instagram.png",
          "owner": {
            "id": 1,
            "type": "media_owner",
            "name": "Elenora Herman",
            "thumbnail_url": "/uploads/media_owner_picture/1/0/1/custom_my_picture.png"
          },
          "content": {
            "type": "image",
            "url": "/home/mariusz/working/hotspotting/spec/support/uploads/post/content_picture/3/my_picture_szhz8u6wd4.png",
            "thumbnail_url": "/home/mariusz/working/hotspotting/spec/support/uploads/post/content_picture/3/my_picture_szhz8u6wd4.png"
          },
          "has_products": false
        },
        {
          "type": "social_media_container",
          "id": 4,
          "date": 1467158095,
          "width": "half",
          "post_type": "video",
          "content_title": "The Little Foxes",
          "content_body": "Qui maxime est voluptatem.",
          "post_url": "http://wilderman.io/jorge_ryan",
          "website": "instagram",
          "icon": "http://localhost:3000/icons/instagram.png",
          "owner": {
            "id": 1,
            "type": "media_owner",
            "name": "Elenora Herman",
            "thumbnail_url": "/uploads/media_owner_picture/1/0/1/custom_my_picture.png"
          },
          "content": {
            "type": "video/mp4",
            "url": "/home/mariusz/working/hotspotting/spec/support/uploads/post/content_video/4/video.mp4",
            "thumbnail_url": "/home/mariusz/working/hotspotting/spec/support/uploads/post/content_video/4/video_thumb_video.jpg"
          },
          "has_products": false
        },
        {
          "type": "social_media_container",
          "id": 2,
          "date": 1467149616,
          "width": "half",
          "post_type": "video",
          "content_title": "The Road Less Traveled",
          "content_body": "Ea consectetur et id et.",
          "post_url": "http://mayerparisian.biz/reuben",
          "website": "facebook",
          "icon": "http://localhost:3000/icons/facebook.png",
          "owner": {
            "id": 10,
            "type": "channel",
            "name": "MTV",
            "thumbnail_url": "/uploads/channel_picture/10/5/10/custom_my_picture.png"
          },
          "content": {
            "type": "video/mp4",
            "url": "/home/mariusz/working/hotspotting/spec/support/uploads/post/content_video/2/video.mp4",
            "thumbnail_url": "/home/mariusz/working/hotspotting/spec/support/uploads/post/content_video/2/video_thumb_video.jpg"
          },
          "has_products": false
        },
        {
          "type": "social_media_container",
          "id": 1,
          "date": 1467016042,
          "width": "half",
          "post_type": "image",
          "content_title": "The Moving Finger",
          "content_body": "Quod dolor quis numquam ab incidunt.",
          "post_url": "http://murazik.co/kaycee",
          "website": "facebook",
          "icon": "http://localhost:3000/icons/facebook.png",
          "owner": {
            "id": 10,
            "type": "channel",
            "name": "MTV",
            "thumbnail_url": "/uploads/channel_picture/10/5/10/custom_my_picture.png"
          },
          "content": {
            "type": "image",
            "url": "/home/mariusz/working/hotspotting/spec/support/uploads/post/content_picture/1/my_picture_y80m8r88qj.png",
            "thumbnail_url": "/home/mariusz/working/hotspotting/spec/support/uploads/post/content_picture/1/my_picture_y80m8r88qj.png"
          },
          "has_products": false
        },
        {
          "type": "social_media_container",
          "id": 5,
          "date": 1466900274,
          "width": "half",
          "post_type": "image",
          "content_title": "To Sail Beyond the Sunset",
          "content_body": "Dicta quos architecto sit sint dolor.",
          "post_url": "http://gleasonmetz.org/tom.casper",
          "website": "twitter",
          "icon": "http://localhost:3000/icons/twitter.png",
          "owner": {
            "id": 1,
            "type": "media_owner",
            "name": "Elenora Herman",
            "thumbnail_url": "/uploads/media_owner_picture/1/0/1/custom_my_picture.png"
          },
          "content": {
            "type": "image",
            "url": "/home/mariusz/working/hotspotting/spec/support/uploads/post/content_picture/5/my_picture_r80uw9d5eh.png",
            "thumbnail_url": "/home/mariusz/working/hotspotting/spec/support/uploads/post/content_picture/5/my_picture_r80uw9d5eh.png"
          },
          "has_products": false
        },
        {
          "type": "social_media_container",
          "id": 6,
          "date": 1466740734,
          "width": "half",
          "post_type": "video",
          "content_title": "A Time to Kill",
          "content_body": "Explicabo sunt repudiandae dolor quis.",
          "post_url": "http://leuschkekoelpin.com/stephen",
          "website": "twitter",
          "icon": "http://localhost:3000/icons/twitter.png",
          "owner": {
            "id": 1,
            "type": "media_owner",
            "name": "Elenora Herman",
            "thumbnail_url": "/uploads/media_owner_picture/1/0/1/custom_my_picture.png"
          },
          "content": {
            "type": "video/mp4",
            "url": "/home/mariusz/working/hotspotting/spec/support/uploads/post/content_video/6/video.mp4",
            "thumbnail_url": "/home/mariusz/working/hotspotting/spec/support/uploads/post/content_video/6/video_thumb_video.jpg"
          },
          "has_products": false
        }
      ]
    }

## Action: Videos a Channel

### Description:

#### Signature:

**GET** `/api/v1/channels/11/videos`

#### Parameters:

Name | Type | Description
-----|------|---------|------------
 number_of_posts | *integer* `Example: 25` | 
 timestamp | *integer* `Example: 1467282379` | 
 id | *integer* `Example: 11` | 

### Examples:

#### Example: /api/v1/channels/:id/videos?number_of_posts=25&timestamp=1781096123

##### Request headers:

    Content-Type: application/x-www-form-urlencoded

##### Request params:

    {
      "number_of_posts": "25",
      "timestamp": "1467282379",
      "id": "11"
    }

##### Response headers:

    Status:       200
    Content-Type: application/json

##### Response body:

    {
      "social_media_containers": [
        {
          "type": "social_media_container",
          "id": 8,
          "date": 1467154161,
          "width": "half",
          "post_type": "video",
          "content_title": "Nine Coaches Waiting",
          "content_body": "Reiciendis exercitationem odit tempora odio mollitia et atque.",
          "post_url": "http://gutkowski.net/dion",
          "website": "facebook",
          "icon": "http://localhost:3000/icons/facebook.png",
          "owner": {
            "id": 11,
            "type": "channel",
            "name": "MTV",
            "thumbnail_url": "/uploads/channel_picture/11/5/11/custom_my_picture.png"
          },
          "content": {
            "type": "video/mp4",
            "url": "/home/mariusz/working/hotspotting/spec/support/uploads/post/content_video/8/video.mp4",
            "thumbnail_url": "/home/mariusz/working/hotspotting/spec/support/uploads/post/content_video/8/video_thumb_video.jpg"
          },
          "has_products": false
        },
        {
          "type": "social_media_container",
          "id": 12,
          "date": 1466911830,
          "width": "half",
          "post_type": "video",
          "content_title": "Death Be Not Proud",
          "content_body": "Dolorem cum debitis perferendis voluptatibus quidem et cupiditate aut.",
          "post_url": "http://feil.org/lewis.hagenes",
          "website": "twitter",
          "icon": "http://localhost:3000/icons/twitter.png",
          "owner": {
            "id": 2,
            "type": "media_owner",
            "name": "Bernard Harvey",
            "thumbnail_url": "/uploads/media_owner_picture/2/1/2/custom_my_picture.png"
          },
          "content": {
            "type": "video/mp4",
            "url": "/home/mariusz/working/hotspotting/spec/support/uploads/post/content_video/12/video.mp4",
            "thumbnail_url": "/home/mariusz/working/hotspotting/spec/support/uploads/post/content_video/12/video_thumb_video.jpg"
          },
          "has_products": false
        },
        {
          "type": "social_media_container",
          "id": 10,
          "date": 1466781783,
          "width": "half",
          "post_type": "video",
          "content_title": "After Many a Summer Dies the Swan",
          "content_body": "Soluta impedit voluptatibus et distinctio aut.",
          "post_url": "http://bayer.name/barney",
          "website": "instagram",
          "icon": "http://localhost:3000/icons/instagram.png",
          "owner": {
            "id": 2,
            "type": "media_owner",
            "name": "Bernard Harvey",
            "thumbnail_url": "/uploads/media_owner_picture/2/1/2/custom_my_picture.png"
          },
          "content": {
            "type": "video/mp4",
            "url": "/home/mariusz/working/hotspotting/spec/support/uploads/post/content_video/10/video.mp4",
            "thumbnail_url": "/home/mariusz/working/hotspotting/spec/support/uploads/post/content_video/10/video_thumb_video.jpg"
          },
          "has_products": false
        }
      ],
      "media_containers": [
        {
          "type": "media_container",
          "id": 3,
          "date": 1467032883,
          "name": "Shawn Paucek DDS",
          "description": "Nostrum minus voluptatem. Qui sit earum doloribus. Hic odio ducimus magnam sequi.",
          "additional_description": "I'll parse the cross-platform CSS transmitter, that should firewall the PNG circuit!",
          "width": "half",
          "owner": {
            "id": 11,
            "type": "channel",
            "name": "MTV",
            "thumbnail_url": "/uploads/channel_picture/11/5/11/custom_my_picture.png"
          },
          "content": {
            "type": "video/mp4",
            "url": "/home/mariusz/working/hotspotting/spec/support/uploads/media_content/file/1/video_l3qzfylpke.mp4",
            "thumbnail_url": "/home/mariusz/working/hotspotting/spec/support/uploads/media_content/file/1/video_thumb_video_l3qzfylpke.jpg"
          }
        }
      ]
    }

# Resource: Collections

## Action: Retrieve single Collection

### Description:

#### Signature:

**GET** `/api/v1/collections/{id}`

#### Parameters:

Name | Type | Description
-----|------|---------|------------
 id | *integer* `Example: 4` | 

### Examples:

#### Example: /api/v1/collections/:id

##### Request headers:

    Content-Type: application/x-www-form-urlencoded

##### Request params:

    {
      "id": "4"
    }

##### Response headers:

    Status:       200
    Content-Type: application/json

##### Response body:

    {
      "id": 4,
      "name": "sample",
      "image_url": "/assets/fallback/default_picture-5b9ea71fca84bac245fb046d833b7fc0ffe73432a71c950813658a699696f0a3.png",
      "products_containers": [
        {
          "type": "products_container",
          "id": 4,
          "name": "products container",
          "date": "2016-06-30 10:26:20 UTC",
          "products": [
            {
              "id": 6,
              "name": "Ewok",
              "brand": "Dagobah",
              "description": "I find your lack of faith disturbing.",
              "vendor_url": "",
              "vendor": "",
              "image": "",
              "small_image": "",
              "medium_image": "",
              "price_min": 0.0,
              "price_max": 0.0,
              "currency": "USD",
              "asin": "",
              "available": 0
            }
          ],
          "position": 1
        }
      ],
      "media_containers": [
        {
          "type": "media_container",
          "id": 6,
          "date": 1466683528,
          "name": "media",
          "description": "Ut quis aut assumenda alias. Aut laborum aspernatur odit et accusamus. Natus inventore eos ut voluptatem et odio. Itaque quo sequi. Quia voluptas incidunt.",
          "additional_description": "Try to transmit the CSS array, maybe it will navigate the optical bus!",
          "width": "half",
          "owner": "",
          "content": {
            "type": "image/png",
            "url": "/home/mariusz/working/hotspotting/spec/support/uploads/media_content/file/5/my_picture_3dmgdry90.png",
            "thumbnail_url": "/home/mariusz/working/hotspotting/spec/support/uploads/media_content/file/5/thumb_my_picture_3dmgdry90.png"
          },
          "position": 2
        }
      ],
      "combo_containers": [
        {
          "type": "combo_container",
          "id": 5,
          "name": "combo container",
          "date": "2016-06-30 10:26:20 UTC",
          "products": [
            {
              "id": 7,
              "name": "Jawa",
              "brand": "Kashyyyk",
              "description": "It's not impossible. I used to bullseye womp rats in my T-16 back home, they're not much bigger than two meters.",
              "vendor_url": "",
              "vendor": "",
              "image": "",
              "small_image": "",
              "medium_image": "",
              "price_min": 0.0,
              "price_max": 0.0,
              "currency": "USD",
              "asin": "",
              "available": 0
            }
          ],
          "description": null,
          "media_owner": {
            "id": 7,
            "name": "Mr. Aric Ernser",
            "thumbnail_url": "/uploads/media_owner_picture/7/3/7/custom_my_picture.png"
          },
          "content": {
            "image_url": "",
            "type": "",
            "url": "",
            "thumbnail_url": "",
            "media_container_url": "",
            "combo_container_url": "",
            "specification": {
            }
          },
          "position": 3
        }
      ]
    }

## Action: List all Collections

### Description:

#### Signature:

**GET** `/api/v1/collections`

#### Parameters:

Name | Type | Description
-----|------|---------|------------

### Examples:

#### Example: /api/v1/collections

##### Request headers:

    Content-Type: application/x-www-form-urlencoded

##### Response headers:

    Status:       200
    Content-Type: application/json

##### Response body:

    [
      {
        "id": 3,
        "name": "Collection2",
        "image_url": "/assets/fallback/default_picture-5b9ea71fca84bac245fb046d833b7fc0ffe73432a71c950813658a699696f0a3.png"
      },
      {
        "id": 2,
        "name": "Collection1",
        "image_url": "/assets/fallback/default_picture-5b9ea71fca84bac245fb046d833b7fc0ffe73432a71c950813658a699696f0a3.png"
      }
    ]

# Resource: Combo Containers

## Action: Retrieve single Combo Container

### Description:

#### Signature:

**GET** `/api/v1/combo_containers/{id}`

#### Parameters:

Name | Type | Description
-----|------|---------|------------
 id | *integer* `Example: 6` | 

### Examples:

#### Example: /api/v1/combo_containers/:id

##### Request headers:

    Content-Type: application/x-www-form-urlencoded

##### Request params:

    {
      "id": "6"
    }

##### Response headers:

    Status:       200
    Content-Type: application/json

##### Response body:

    {
      "type": "combo_container",
      "id": 6,
      "name": "combo container",
      "date": "2016-06-30 10:26:20 UTC",
      "products": [
        {
          "id": 8,
          "name": "Ewok",
          "brand": "Alderaan",
          "description": "Never tell me the odds!",
          "vendor_url": "",
          "vendor": "",
          "image": "",
          "small_image": "",
          "medium_image": "",
          "price_min": 0.0,
          "price_max": 0.0,
          "currency": "USD",
          "asin": "",
          "available": 0
        },
        {
          "id": 9,
          "name": "Gungan",
          "brand": "Geonosis",
          "description": "If they follow standard Imperial procedure, they'll dump their garbage before they go to light-speed.",
          "vendor_url": "",
          "vendor": "",
          "image": "",
          "small_image": "",
          "medium_image": "",
          "price_min": 0.0,
          "price_max": 0.0,
          "currency": "USD",
          "asin": "",
          "available": 0
        }
      ],
      "description": null,
      "media_owner": {
        "id": 8,
        "name": "Melany Heidenreich",
        "thumbnail_url": "/uploads/media_owner_picture/8/4/8/custom_my_picture.png"
      },
      "content": {
        "image_url": "",
        "type": "",
        "url": "",
        "thumbnail_url": "",
        "media_container_url": "",
        "combo_container_url": "",
        "specification": {
        }
      }
    }

# Resource: Events

## Action: Retrieve single Event

### Description:

#### Signature:

**GET** `/api/v1/events/{id}`

#### Parameters:

Name | Type | Description
-----|------|---------|------------
 id | *integer* `Example: 2` | 

### Examples:

#### Example: /api/v1/events/:id

##### Request headers:

    Content-Type: application/x-www-form-urlencoded

##### Request params:

    {
      "id": "2"
    }

##### Response headers:

    Status:       200
    Content-Type: application/json

##### Response body:

    {
      "id": 2,
      "name": "Event Name",
      "type": "event_container",
      "image_url": "",
      "cover_image_url": "",
      "media_containers": [
        {
          "type": "media_container",
          "id": 8,
          "date": 1466683973,
          "name": "media container",
          "description": "Voluptates dolorem repudiandae consequatur possimus ab tempore. Ducimus earum similique ut ipsam est numquam. Culpa modi dolore occaecati. Doloremque dolorum consectetur voluptatem dolorem. Aut quia nihil occaecati quo accusantium.",
          "additional_description": "You can't compress the bus without indexing the neural RAM protocol!",
          "width": "half",
          "owner": {
            "id": 10,
            "type": "media_owner",
            "name": "Ms. Tre Harber",
            "thumbnail_url": "/uploads/media_owner_picture/10/5/10/custom_my_picture.png"
          },
          "content": {
            "type": "image/png",
            "url": "/home/mariusz/working/hotspotting/spec/support/uploads/media_content/file/9/my_picture_9qagiitbdw.png",
            "thumbnail_url": "/home/mariusz/working/hotspotting/spec/support/uploads/media_content/file/9/thumb_my_picture_9qagiitbdw.png"
          },
          "position": 1
        },
        {
          "type": "media_container",
          "id": 9,
          "date": 1466917511,
          "name": "media container",
          "description": "Voluptatem doloribus enim voluptatem. Eum voluptas aut culpa libero ut dolores. Quis cumque fuga odit quasi voluptatum illo similique. Non nisi maxime aut enim nam. Recusandae quia quis aut sunt excepturi quis facilis.",
          "additional_description": "We need to compress the 1080p RAM monitor!",
          "width": "full",
          "owner": {
            "id": 17,
            "type": "channel",
            "name": "MTV",
            "thumbnail_url": "/uploads/channel_picture/17/8/17/custom_my_picture.png"
          },
          "content": {
            "type": "image/png",
            "url": "/home/mariusz/working/hotspotting/spec/support/uploads/media_content/file/10/my_picture_kanvsqubyf.png",
            "thumbnail_url": "/home/mariusz/working/hotspotting/spec/support/uploads/media_content/file/10/thumb_my_picture_kanvsqubyf.png"
          },
          "position": 3
        }
      ],
      "products_containers": [
        {
          "type": "products_container",
          "id": 7,
          "name": "Name of the Product Series",
          "date": "2016-06-30 10:26:20 UTC",
          "products": [
            {
              "id": 12,
              "name": "Mon Calamari",
              "brand": "Endor",
              "description": "If you're saying that coming here was a bad idea, I'm starting to agree with you.",
              "vendor_url": "",
              "vendor": "",
              "image": "",
              "small_image": "",
              "medium_image": "",
              "price_min": 0.0,
              "price_max": 0.0,
              "currency": "USD",
              "asin": "",
              "available": 0
            },
            {
              "id": 13,
              "name": "Ewok",
              "brand": "Mustafar",
              "description": "It's not impossible. I used to bullseye womp rats in my T-16 back home, they're not much bigger than two meters.",
              "vendor_url": "",
              "vendor": "",
              "image": "",
              "small_image": "",
              "medium_image": "",
              "price_min": 0.0,
              "price_max": 0.0,
              "currency": "USD",
              "asin": "",
              "available": 0
            }
          ],
          "position": 9,
          "width": "full"
        }
      ],
      "single_product_containers": [
        {
          "id": 10,
          "name": "Name of the Product",
          "brand": "Coruscant",
          "description": "Now, witness the power of this fully operational battle station.",
          "vendor_url": "",
          "vendor": "",
          "image": "",
          "small_image": "",
          "medium_image": "",
          "price_min": 0.0,
          "price_max": 0.0,
          "currency": "USD",
          "asin": "",
          "available": 0,
          "position": 2,
          "width": "half"
        },
        {
          "id": 11,
          "name": "Another Product Name",
          "brand": "Sullust",
          "description": "R2-D2, you know better than to trust a strange computer!",
          "vendor_url": "",
          "vendor": "",
          "image": "",
          "small_image": "",
          "medium_image": "",
          "price_min": 0.0,
          "price_max": 0.0,
          "currency": "USD",
          "asin": "",
          "available": 0,
          "position": 4,
          "width": "full"
        }
      ],
      "links_containers": [
        {
          "id": 5,
          "target_id": 9,
          "name": "Celebrity Name",
          "type": "link_container",
          "link_type": "media_owner",
          "number_of_videos": 0,
          "description": "",
          "image_url": "/uploads/media_owner_picture/9/4/9/custom_my_picture.png",
          "position": 5,
          "width": "full"
        },
        {
          "id": 6,
          "target_id": 16,
          "name": "Channel Name",
          "type": "link_container",
          "link_type": "channel",
          "number_of_videos": 1,
          "description": "",
          "image_url": "/uploads/channel_picture/16/8/16/custom_my_picture.png",
          "position": 7,
          "width": "half"
        },
        {
          "id": 7,
          "target_id": 2,
          "name": "Magazine title",
          "type": "link_container",
          "link_type": "magazine",
          "number_of_videos": 0,
          "description": "Banjo roof farm-to-table pug lo-fi. Keytar deep v offal knausgaard. Neutra cray brooklyn marfa bushwick. Goth slow-carb cred tofu everyday cardigan 8-bit. Gastropub goth craft beer next level bicycle rights try-hard aesthetic.",
          "image_url": "/uploads/magazine_cover_image/2/1/2/custom_my_picture.png",
          "number_of_issues": 0,
          "position": 8,
          "width": "half"
        },
        {
          "id": 8,
          "target_id": 2,
          "name": "Tv Show title",
          "type": "link_container",
          "link_type": "tv_show",
          "number_of_videos": 2,
          "description": "Narwhal flexitarian iphone. Ennui pug austin. Pbr&b church-key cold-pressed disrupt meggings artisan aesthetic trust fund. 90's forage carry wolf viral meditation.",
          "image_url": "/uploads/tv_show_cover_image/2/1/2/custom_my_picture.png",
          "position": 6,
          "width": "full"
        },
        {
          "id": 9,
          "target_id": 3,
          "name": "Event Super Name",
          "type": "link_container",
          "link_type": "event",
          "number_of_videos": 0,
          "description": "",
          "image_url": "",
          "position": 12,
          "width": "full"
        }
      ]
    }

# Resource: Feeds

## Action: List all Feeds

### Description:

#### Signature:

**GET** `/api/v1/feed`

#### Parameters:

Name | Type | Description
-----|------|---------|------------
 media_owner_id | *string* | 
 with_channel | *string* `Example: true` | 
 with_media_owner | *string* `Example: true` | 
 channel_id | *string* | 

### Examples:

#### Example: /api/v1/feed?media_owner_id[]=1

##### Request headers:

    Content-Type: application/x-www-form-urlencoded

##### Request params:

    {
      "media_owner_id": [
        "1001"
      ]
    }

##### Response headers:

    Status:       200
    Content-Type: application/json

##### Response body:

    {
      "combo_containers": [
        {
          "type": "products_container",
          "id": 9,
          "name": "products_container",
          "date": "2016-06-30 10:26:20 UTC",
          "products": [
    
          ],
          "position": 1
        }
      ],
      "media_containers": [
        {
          "type": "media_container",
          "id": 12,
          "date": 1467158400,
          "name": "Yesterday",
          "description": "Ipsa error optio quo tempore. Eos iure nostrum quibusdam sint sit quos. Est modi temporibus deserunt molestiae.",
          "additional_description": "Try to parse the PCI system, maybe it will transmit the solid state pixel!",
          "width": "half",
          "owner": "",
          "content": {
            "type": "image/png",
            "url": "/home/mariusz/working/hotspotting/spec/support/uploads/media_content/file/14/my_picture_qhxv0xbcch.png",
            "thumbnail_url": "/home/mariusz/working/hotspotting/spec/support/uploads/media_content/file/14/thumb_my_picture_qhxv0xbcch.png"
          },
          "position": 2
        }
      ]
    }

#### Example: /api/v1/feed?with_channel=true

##### Request headers:

    Content-Type: application/x-www-form-urlencoded

##### Request params:

    {
      "with_channel": "true"
    }

##### Response headers:

    Status:       200
    Content-Type: application/json

##### Response body:

    {
      "combo_containers": [
        {
          "type": "combo_container",
          "id": 11,
          "name": "with channel2",
          "date": "2016-06-30 10:26:21 UTC",
          "products": [
    
          ],
          "description": null,
          "media_owner": {
            "id": 17,
            "name": "Rudy Luettgen",
            "thumbnail_url": "/uploads/media_owner_picture/18/9/18/custom_my_picture.png"
          },
          "content": {
            "image_url": "",
            "type": "image/png",
            "url": "/home/mariusz/working/hotspotting/spec/support/uploads/media_content/file/22/my_picture_bcxoygdw6l.png",
            "thumbnail_url": "/home/mariusz/working/hotspotting/spec/support/uploads/media_content/file/22/thumb_my_picture_bcxoygdw6l.png",
            "media_container_url": "",
            "combo_container_url": "",
            "specification": {
              "height": 40,
              "width": 40
            }
          },
          "position": 1
        }
      ],
      "media_containers": [
        {
          "type": "media_container",
          "id": 16,
          "date": 1467158400,
          "name": "with channel",
          "description": "Et dolor voluptatibus tempore. Quos qui quibusdam. In nemo laborum. Quo ipsum sunt et quia id sed officiis. Iure magni doloribus est ratione quia corporis tempora.",
          "additional_description": "I'll navigate the multi-byte IB alarm, that should panel the JSON feed!",
          "width": "half",
          "owner": "",
          "content": {
            "type": "image/png",
            "url": "/home/mariusz/working/hotspotting/spec/support/uploads/media_content/file/20/my_picture_7tpqazhigo.png",
            "thumbnail_url": "/home/mariusz/working/hotspotting/spec/support/uploads/media_content/file/20/thumb_my_picture_7tpqazhigo.png"
          },
          "position": 2
        }
      ]
    }

#### Example: /api/v1/feed

##### Request headers:

    Content-Type: application/x-www-form-urlencoded

##### Response headers:

    Status:       200
    Content-Type: application/json

##### Response body:

    {
      "combo_containers": [
        {
          "type": "combo_container",
          "id": 8,
          "name": "products_container",
          "date": "2016-06-30 10:26:20 UTC",
          "products": [
    
          ],
          "description": null,
          "media_owner": {
            "id": 13,
            "name": "Julia Ortiz",
            "thumbnail_url": "/uploads/media_owner_picture/13/6/13/custom_my_picture.png"
          },
          "content": {
            "image_url": "",
            "type": "image/png",
            "url": "/home/mariusz/working/hotspotting/spec/support/uploads/media_content/file/13/my_picture_8abde83zkv.png",
            "thumbnail_url": "/home/mariusz/working/hotspotting/spec/support/uploads/media_content/file/13/thumb_my_picture_8abde83zkv.png",
            "media_container_url": "",
            "combo_container_url": "",
            "specification": {
              "height": 40,
              "width": 40
            }
          },
          "position": 1
        }
      ],
      "media_containers": [
        {
          "type": "media_container",
          "id": 11,
          "date": 1467244800,
          "name": "Today",
          "description": "Ut sed dolor. Provident eligendi quisquam sapiente dignissimos doloremque qui et. Ut velit veritatis non dicta necessitatibus illum perspiciatis.",
          "additional_description": "Try to navigate the IB application, maybe it will compress the virtual capacitor!",
          "width": "half",
          "owner": {
            "id": 12,
            "type": "media_owner",
            "name": "Clinton Lebsack",
            "thumbnail_url": "/uploads/media_owner_picture/12/6/12/custom_my_picture.png"
          },
          "content": {
            "type": "image/png",
            "url": "/home/mariusz/working/hotspotting/spec/support/uploads/media_content/file/12/my_picture_531g475ruk.png",
            "thumbnail_url": "/home/mariusz/working/hotspotting/spec/support/uploads/media_content/file/12/thumb_my_picture_531g475ruk.png"
          },
          "position": 2
        },
        {
          "type": "media_container",
          "id": 10,
          "date": 1467158400,
          "name": "Yesterday",
          "description": "Possimus rem id rerum nostrum sint. Rerum eius iusto pariatur. Enim fugit recusandae sed maxime. Distinctio fugit atque. At earum dolorem ipsam explicabo.",
          "additional_description": "Try to hack the RSS protocol, maybe it will synthesize the multi-byte array!",
          "width": "half",
          "owner": {
            "id": 11,
            "type": "media_owner",
            "name": "Mrs. Jennifer Wintheiser",
            "thumbnail_url": "/uploads/media_owner_picture/11/5/11/custom_my_picture.png"
          },
          "content": {
            "type": "image/png",
            "url": "/home/mariusz/working/hotspotting/spec/support/uploads/media_content/file/11/my_picture_kf51x4e6tq.png",
            "thumbnail_url": "/home/mariusz/working/hotspotting/spec/support/uploads/media_content/file/11/thumb_my_picture_kf51x4e6tq.png"
          },
          "position": 3
        }
      ]
    }

#### Example: /api/v1/feed?with_media_owner=true

##### Request headers:

    Content-Type: application/x-www-form-urlencoded

##### Request params:

    {
      "with_media_owner": "true"
    }

##### Response headers:

    Status:       200
    Content-Type: application/json

##### Response body:

    {
      "combo_containers": [
        {
          "type": "products_container",
          "id": 12,
          "name": "with media owner",
          "date": "2016-06-30 10:26:21 UTC",
          "products": [
    
          ],
          "position": 1
        }
      ],
      "media_containers": [
        {
          "type": "media_container",
          "id": 18,
          "date": 1467158400,
          "name": "With media owner",
          "description": "Fuga nostrum et pariatur. Porro est veniam asperiores. Autem sit vel quae quidem iure. Est saepe qui.",
          "additional_description": "We need to synthesize the bluetooth CSS sensor!",
          "width": "half",
          "owner": "",
          "content": {
            "type": "image/png",
            "url": "/home/mariusz/working/hotspotting/spec/support/uploads/media_content/file/23/my_picture_kguiadnjo8.png",
            "thumbnail_url": "/home/mariusz/working/hotspotting/spec/support/uploads/media_content/file/23/thumb_my_picture_kguiadnjo8.png"
          },
          "position": 2
        }
      ]
    }

#### Example: /api/v1/feed?channel_id[]=1

##### Request headers:

    Content-Type: application/x-www-form-urlencoded

##### Request params:

    {
      "channel_id": [
        "1002"
      ]
    }

##### Response headers:

    Status:       200
    Content-Type: application/json

##### Response body:

    {
      "combo_containers": [
        {
          "type": "combo_container",
          "id": 10,
          "name": "products_container",
          "date": "2016-06-30 10:26:20 UTC",
          "products": [
    
          ],
          "description": null,
          "media_owner": {
            "id": 15,
            "name": "Esther King",
            "thumbnail_url": "/uploads/media_owner_picture/16/8/16/custom_my_picture.png"
          },
          "content": {
            "image_url": "",
            "type": "image/png",
            "url": "/home/mariusz/working/hotspotting/spec/support/uploads/media_content/file/19/my_picture_8c2yuvcg31.png",
            "thumbnail_url": "/home/mariusz/working/hotspotting/spec/support/uploads/media_content/file/19/thumb_my_picture_8c2yuvcg31.png",
            "media_container_url": "",
            "combo_container_url": "",
            "specification": {
              "height": 40,
              "width": 40
            }
          },
          "position": 1
        }
      ],
      "media_containers": [
        {
          "type": "media_container",
          "id": 14,
          "date": 1467158400,
          "name": "Yesterday",
          "description": "Facere voluptatem magni aut et quia nihil. Exercitationem sunt accusantium. Aut sint quia. Et ex rerum.",
          "additional_description": "If we copy the circuit, we can get to the AI firewall through the virtual SDD interface!",
          "width": "half",
          "owner": "",
          "content": {
            "type": "image/png",
            "url": "/home/mariusz/working/hotspotting/spec/support/uploads/media_content/file/17/my_picture_5gw4z4s61e.png",
            "thumbnail_url": "/home/mariusz/working/hotspotting/spec/support/uploads/media_content/file/17/thumb_my_picture_5gw4z4s61e.png"
          },
          "position": 2
        }
      ]
    }

# Resource: Followings

## Action: Toggle a Following

### Description:

#### Signature:

**POST** `/api/v1/followings/toggle`

#### Parameters:

Name | Type | Description
-----|------|---------|------------
 followed_id | *integer* `Example: 19` | 
 followed_type | *string* `Example: Channel` | 

### Examples:

#### Example: /api/v1/followings/toggle unfollow

##### Request headers:

    Content-Type: application/x-www-form-urlencoded
    Access-Token: c2hIHty-qBw12MLS9vyeww
    Client:       yWH0LavXai7YOHl8J19X4w
    Expiry:       1468491981
    Uid:          rebeca.koch@gibson.org

##### Request params:

    {
      "followed_id": "19",
      "followed_type": "MediaOwner"
    }

##### Response headers:

    Status:       200
    Content-Type: application/json
    Access-token: c2hIHty-qBw12MLS9vyeww
    Client:       yWH0LavXai7YOHl8J19X4w
    Expiry:       1468491981
    Uid:          rebeca.koch@gibson.org

##### Response body:

    {
      "isfollowing": false,
      "followers": 1,
      "followed_name": "Fergie"
    }

#### Example: /api/v1/followings/toggle follow mediaOwner

##### Request headers:

    Content-Type: application/x-www-form-urlencoded
    Access-Token: XzlvkW7WrOJsEJwNQd-ybw
    Client:       5XTvrFtGwga-K91fW8dwHw
    Expiry:       1468491981
    Uid:          abbey.dooley@vonrueden.io

##### Request params:

    {
      "followed_id": "18",
      "followed_type": "MediaOwner"
    }

##### Response headers:

    Status:       200
    Content-Type: application/json
    Access-token: XzlvkW7WrOJsEJwNQd-ybw
    Client:       5XTvrFtGwga-K91fW8dwHw
    Expiry:       1468491981
    Uid:          abbey.dooley@vonrueden.io

##### Response body:

    {
      "isfollowing": true,
      "followers": 2,
      "followed_name": "Fergie"
    }

#### Example: /api/v1/followings/toggle invlid media_owner id

##### Request headers:

    Content-Type: application/x-www-form-urlencoded
    Access-Token: 2O0FGB9brXCXtMdGW_13hg
    Client:       Gsxcas2OJ-8Hcdm-chur1Q
    Expiry:       1468491981
    Uid:          reid.lebsack@abshire.info

##### Request params:

    {
      "followed_id": "5",
      "followed_type": "MediaOwner"
    }

##### Response headers:

    Status:       400
    Content-Type: application/json
    Access-token: 2O0FGB9brXCXtMdGW_13hg
    Client:       Gsxcas2OJ-8Hcdm-chur1Q
    Expiry:       1468491981
    Uid:          reid.lebsack@abshire.info

##### Response body:

    [
      "Media owner not found."
    ]

#### Example: /api/v1/followings/toggle follow Channel

##### Request headers:

    Content-Type: application/x-www-form-urlencoded
    Access-Token: L4sOgh-DfCkfmlRvMLzBug
    Client:       ua_sCHV1Giz7Hj-3voPItg
    Expiry:       1468491981
    Uid:          declan@goodwin.biz

##### Request params:

    {
      "followed_id": "19",
      "followed_type": "Channel"
    }

##### Response headers:

    Status:       200
    Content-Type: application/json
    Access-token: L4sOgh-DfCkfmlRvMLzBug
    Client:       ua_sCHV1Giz7Hj-3voPItg
    Expiry:       1468491981
    Uid:          declan@goodwin.biz

##### Response body:

    {
      "isfollowing": true,
      "followers": 2,
      "followed_name": "Fergie"
    }

# Resource: Homes

## Action: Current a Home

### Description:

#### Signature:

**GET** `/api/v1/homes/current`

#### Parameters:

Name | Type | Description
-----|------|---------|------------
 home_type | *string* `Example: man` | 

### Examples:

#### Example: /api/v1/homes/current /api/v1/homes/current

##### Request headers:

    Content-Type: application/x-www-form-urlencoded

##### Response headers:

    Status:       200
    Content-Type: application/json

##### Response body:

    {
      "home_type": "trending",
      "collections_containers": [
        {
          "type": "collections_container",
          "name": "collections",
          "collections": [
    
          ],
          "position": 2,
          "width": "full"
        }
      ],
      "products_containers": [
        {
          "type": "products_container",
          "id": 13,
          "name": "products container",
          "date": "2016-06-30 10:26:21 UTC",
          "products": [
            {
              "id": 14,
              "name": "Neimoidian",
              "brand": "Yavin",
              "description": "That is why you fail.",
              "vendor_url": "",
              "vendor": "",
              "image": "",
              "small_image": "",
              "medium_image": "",
              "price_min": 0.0,
              "price_max": 0.0,
              "currency": "USD",
              "asin": "",
              "available": 0
            }
          ],
          "position": 1,
          "width": "full"
        }
      ],
      "media_containers": [
        {
          "type": "media_container",
          "id": 21,
          "date": 1466747191,
          "name": "media container",
          "description": "Eveniet sit dicta qui delectus voluptas. Et ipsam et vitae. Mollitia maiores vitae. Quia molestiae iusto. Nulla aliquam non vel.",
          "additional_description": "Use the solid state SQL alarm, then you can input the cross-platform capacitor!",
          "width": "half",
          "owner": {
            "id": 21,
            "type": "media_owner",
            "name": "Ulises Hayes",
            "thumbnail_url": "/uploads/media_owner_picture/25/12/25/custom_my_picture.png"
          },
          "content": {
            "type": "image/png",
            "url": "/home/mariusz/working/hotspotting/spec/support/uploads/media_content/file/27/my_picture_wdsq32la4r.png",
            "thumbnail_url": "/home/mariusz/working/hotspotting/spec/support/uploads/media_content/file/27/thumb_my_picture_wdsq32la4r.png"
          },
          "position": 3
        },
        {
          "type": "media_container",
          "id": 22,
          "date": 1466880598,
          "name": "media container",
          "description": "Aut hic labore eligendi et voluptas. Eaque est quas qui excepturi. Animi adipisci aut in harum aut. Quod blanditiis rerum. Qui est harum omnis ut.",
          "additional_description": "If we input the bus, we can get to the RSS driver through the online ADP array!",
          "width": "full",
          "owner": {
            "id": 21,
            "type": "channel",
            "name": "MTV",
            "thumbnail_url": "/uploads/channel_picture/24/12/24/custom_my_picture.png"
          },
          "content": {
            "type": "image/png",
            "url": "/home/mariusz/working/hotspotting/spec/support/uploads/media_content/file/28/my_picture_m7ij5exf4d.png",
            "thumbnail_url": "/home/mariusz/working/hotspotting/spec/support/uploads/media_content/file/28/thumb_my_picture_m7ij5exf4d.png"
          },
          "position": 11
        }
      ],
      "combo_containers": [
        {
          "type": "combo_container",
          "id": 14,
          "name": "combo container",
          "date": "2016-06-30 10:26:21 UTC",
          "products": [
            {
              "id": 15,
              "name": "Wookiee",
              "brand": "Mustafar",
              "description": "Who's the more foolish; the fool, or the fool who follows him?",
              "vendor_url": "",
              "vendor": "",
              "image": "",
              "small_image": "",
              "medium_image": "",
              "price_min": 0.0,
              "price_max": 0.0,
              "currency": "USD",
              "asin": "",
              "available": 0
            }
          ],
          "description": null,
          "media_owner": {
            "id": 22,
            "name": "Mr. Katheryn Reichert",
            "thumbnail_url": "/uploads/media_owner_picture/23/11/23/custom_my_picture.png"
          },
          "content": {
            "image_url": "",
            "type": "",
            "url": "",
            "thumbnail_url": "",
            "media_container_url": "",
            "combo_container_url": "",
            "specification": {
            }
          },
          "position": 4,
          "width": "half"
        }
      ],
      "single_product_containers": [
        {
          "id": 16,
          "name": "Name of the Product",
          "brand": "Hosnian Prime",
          "description": "Who's the more foolish; the fool, or the fool who follows him?",
          "vendor_url": "",
          "vendor": "",
          "image": "",
          "small_image": "",
          "medium_image": "",
          "price_min": 0.0,
          "price_max": 0.0,
          "currency": "USD",
          "asin": "",
          "available": 0,
          "position": 5,
          "width": "full"
        },
        {
          "id": 17,
          "name": "Another Product Name",
          "brand": "Lothal",
          "description": "Strike me down, and I will become more powerful than you could possibly imagine.",
          "vendor_url": "",
          "vendor": "",
          "image": "",
          "small_image": "",
          "medium_image": "",
          "price_min": 0.0,
          "price_max": 0.0,
          "currency": "USD",
          "asin": "",
          "available": 0,
          "position": 10,
          "width": "full"
        }
      ],
      "links_containers": [
        {
          "id": 10,
          "target_id": 20,
          "name": "Celebrity Name",
          "type": "link_container",
          "link_type": "media_owner",
          "number_of_videos": 0,
          "description": "",
          "image_url": "/uploads/media_owner_picture/24/12/24/custom_my_picture.png",
          "position": 6,
          "width": "full"
        },
        {
          "id": 11,
          "target_id": 20,
          "name": "Channel Name",
          "type": "link_container",
          "link_type": "channel",
          "number_of_videos": 1,
          "description": "",
          "image_url": "/uploads/channel_picture/23/11/23/custom_my_picture.png",
          "position": 7,
          "width": "half"
        },
        {
          "id": 12,
          "target_id": 3,
          "name": "Magazine title",
          "type": "link_container",
          "link_type": "magazine",
          "number_of_videos": 0,
          "description": "Photo booth biodiesel keffiyeh. Shoreditch banjo whatever kinfolk distillery cornhole vegan. Hashtag microdosing schlitz health austin photo booth pabst waistcoat.",
          "image_url": "/uploads/magazine_cover_image/3/1/3/custom_my_picture.png",
          "number_of_issues": 0,
          "position": 8,
          "width": "half"
        },
        {
          "id": 13,
          "target_id": 3,
          "name": "Tv Show title",
          "type": "link_container",
          "link_type": "tv_show",
          "number_of_videos": 2,
          "description": "Jean shorts tote bag gluten-free. Migas truffaut pitchfork salvia irony. Forage street plaid iphone paleo.",
          "image_url": "/uploads/tv_show_cover_image/3/1/3/custom_my_picture.png",
          "position": 9,
          "width": "full"
        }
      ],
      "events_containers": [
        {
          "type": "events_container",
          "id": 1,
          "channel_id": 0,
          "name": "Event Container Name",
          "events": [
            {
              "id": 4,
              "name": "Adventure. Excitement. A Jedi craves not these things.",
              "type": "event_container",
              "image_url": "",
              "cover_image_url": "",
              "media_containers": [
    
              ],
              "products_containers": [
    
              ],
              "single_product_containers": [
    
              ],
              "links_containers": [
    
              ],
              "event_position": null
            }
          ],
          "position": 12,
          "width": "full"
        }
      ]
    }

#### Example: /api/v1/homes/current /api/v1/homes/current?home_type=man

##### Request headers:

    Content-Type: application/x-www-form-urlencoded

##### Request params:

    {
      "home_type": "man"
    }

##### Response headers:

    Status:       200
    Content-Type: application/json

##### Response body:

    {
      "home_type": "man",
      "collections_containers": [
        {
          "type": "collections_container",
          "name": "collections",
          "collections": [
    
          ],
          "position": 2,
          "width": "full"
        }
      ],
      "products_containers": [
        {
          "type": "products_container",
          "id": 15,
          "name": "products container",
          "date": "2016-06-30 10:26:22 UTC",
          "products": [
            {
              "id": 18,
              "name": "Mon Calamari",
              "brand": "Hosnian Prime",
              "description": "It's not impossible. I used to bullseye womp rats in my T-16 back home, they're not much bigger than two meters.",
              "vendor_url": "",
              "vendor": "",
              "image": "",
              "small_image": "",
              "medium_image": "",
              "price_min": 0.0,
              "price_max": 0.0,
              "currency": "USD",
              "asin": "",
              "available": 0
            }
          ],
          "position": 1,
          "width": "full"
        }
      ],
      "media_containers": [
        {
          "type": "media_container",
          "id": 23,
          "date": 1466874630,
          "name": "media container",
          "description": "Iste ab voluptate explicabo assumenda occaecati ex qui. Commodi id ab ex totam. Iure at non et fuga quidem adipisci impedit. Iusto et temporibus ex ipsa itaque excepturi.",
          "additional_description": "We need to reboot the bluetooth IB circuit!",
          "width": "full",
          "owner": "",
          "content": {
            "type": "image/png",
            "url": "/home/mariusz/working/hotspotting/spec/support/uploads/media_content/file/30/my_picture_v00j3khruw.png",
            "thumbnail_url": "/home/mariusz/working/hotspotting/spec/support/uploads/media_content/file/30/thumb_my_picture_v00j3khruw.png"
          },
          "position": 3
        }
      ],
      "combo_containers": [
        {
          "type": "combo_container",
          "id": 16,
          "name": "combo container",
          "date": "2016-06-30 10:26:22 UTC",
          "products": [
            {
              "id": 19,
              "name": "Mon Calamari",
              "brand": "Utapau",
              "description": "Shut him up or shut him down.",
              "vendor_url": "",
              "vendor": "",
              "image": "",
              "small_image": "",
              "medium_image": "",
              "price_min": 0.0,
              "price_max": 0.0,
              "currency": "USD",
              "asin": "",
              "available": 0
            }
          ],
          "description": null,
          "media_owner": {
            "id": 23,
            "name": "Alison Lind I",
            "thumbnail_url": "/uploads/media_owner_picture/26/13/26/custom_my_picture.png"
          },
          "content": {
            "image_url": "",
            "type": "",
            "url": "",
            "thumbnail_url": "",
            "media_container_url": "",
            "combo_container_url": "",
            "specification": {
            }
          },
          "position": 4,
          "width": "full"
        }
      ],
      "single_product_containers": [
    
      ],
      "links_containers": [
    
      ],
      "events_containers": [
    
      ]
    }

# Resource: Magazines

## Action: List all Magazines

### Description:

#### Signature:

**GET** `/api/v1/magazines`

#### Parameters:

Name | Type | Description
-----|------|---------|------------
 channel_id | *integer* `Example: 555` | 
 page | *integer* `Example: 2` | 
 per | *integer* `Example: 2` | 

### Examples:

#### Example: /api/v1/magazines?channel_id=555&page=2&per=2

##### Request headers:

    Content-Type: application/x-www-form-urlencoded

##### Request params:

    {
      "channel_id": "555",
      "page": "2",
      "per": "2"
    }

##### Response headers:

    Status:       200
    Content-Type: application/json

##### Response body:

    [
      {
        "id": 10,
        "name": "Second Page Magazine",
        "description": "Kogi yuccie austin kinfolk. Cray chia stumptown. Master thundercats occupy 3 wolf moon deep v tattooed etsy gluten-free.",
        "issues_count": 0,
        "volume_count": 0,
        "cover_image_url": "",
        "channel": {
          "id": 555,
          "name": "MTV",
          "thumbnail_url": "/uploads/channel_picture/26/13/26/custom_my_picture.png"
        }
      }
    ]

#### Example: /api/v1/magazines?channel_id=555

##### Request headers:

    Content-Type: application/x-www-form-urlencoded

##### Request params:

    {
      "channel_id": "555"
    }

##### Response headers:

    Status:       200
    Content-Type: application/json

##### Response body:

    [
      {
        "id": 6,
        "name": "Selected Channel Magazine",
        "description": "Beard portland salvia 8-bit distillery. Ethical occupy cray truffaut. Cliche schlitz hammock keffiyeh aesthetic gluten-free yr celiac. Wes anderson fashion axe lumbersexual poutine meditation chicharrones.",
        "issues_count": 0,
        "volume_count": 0,
        "cover_image_url": "",
        "channel": {
          "id": 555,
          "name": "MTV",
          "thumbnail_url": "/uploads/channel_picture/25/12/25/custom_my_picture.png"
        }
      }
    ]

#### Example: /api/v1/magazines

##### Request headers:

    Content-Type: application/x-www-form-urlencoded

##### Response headers:

    Status:       200
    Content-Type: application/json

##### Response body:

    [
      {
        "id": 4,
        "name": "Title",
        "description": "Gentrify tacos seitan pitchfork drinking yr kogi. Authentic vice austin cornhole diy. Wes anderson tattooed locavore keytar shabby chic fashion axe cray literally. Yolo austin xoxo.",
        "issues_count": 0,
        "volume_count": 0,
        "cover_image_url": "",
        "channel": {
        }
      },
      {
        "id": 5,
        "name": "Title2",
        "description": "Cronut meh +1 farm-to-table fashion axe vegan dreamcatcher. Keytar mustache selvage hoodie park tousled stumptown normcore. Aesthetic photo booth master echo. Photo booth tumblr vinyl poutine iphone heirloom. Mumblecore post-ironic xoxo meh cronut sriracha.",
        "issues_count": 0,
        "volume_count": 0,
        "cover_image_url": "",
        "channel": {
        }
      }
    ]

## Action: Retrieve single Magazine

### Description:

#### Signature:

**GET** `/api/v1/magazines/{id}`

#### Parameters:

Name | Type | Description
-----|------|---------|------------
 id | *integer* `Example: 11` | 

### Examples:

#### Example: /api/v1/magazines/:id

##### Request headers:

    Content-Type: application/x-www-form-urlencoded

##### Request params:

    {
      "id": "11"
    }

##### Response headers:

    Status:       200
    Content-Type: application/json

##### Response body:

    {
      "id": 11,
      "name": "Selected Magazine",
      "description": "Loko quinoa typewriter lo-fi cleanse dreamcatcher. Portland selvage hashtag typewriter cray leggings tousled. Cray tote bag bushwick tilde green juice park.",
      "issues_count": 2,
      "volume_count": 1,
      "cover_image_url": "",
      "channel": {
      },
      "volumes": [
        {
          "volume_id": 1,
          "volume_year": 1964,
          "volume_issues_count": 2,
          "issues": [
            {
              "issue_id": 1,
              "issue_publication_month": "August",
              "issue_publication_year": 1964,
              "issue_description": "Gluten-free banh mi wes anderson chicharrones chillwave pbr&b diy cronut. Mumblecore intelligentsia crucifix iphone. Vinyl chartreuse direct trade literally pitchfork lo-fi. Celiac cred selvage shabby chic polaroid blog artisan. Wayfarers keytar salvia.",
              "issue_title": "",
              "issue_cover_image_url": "",
              "issue_url": "http://mcdermott.info/dewitt.auer",
              "issue_pages": 124
            },
            {
              "issue_id": 2,
              "issue_publication_month": "January",
              "issue_publication_year": 1964,
              "issue_description": "Synth offal narwhal post-ironic hoodie cred normcore selvage. Pbr&b banh mi poutine shoreditch. Truffaut hashtag etsy crucifix master mixtape occupy chambray. Plaid pork belly wayfarers brooklyn raw denim taxidermy. Flexitarian hashtag thundercats.",
              "issue_title": "",
              "issue_cover_image_url": "",
              "issue_url": "http://kelerritchie.biz/mason",
              "issue_pages": 72
            }
          ]
        }
      ]
    }

# Resource: Media Containers

## Action: List all Media Containers

### Description:

#### Signature:

**GET** `/api/v1/media_containers`

#### Parameters:

Name | Type | Description
-----|------|---------|------------
 last_date | *string* `Example: 2016-06-30` | 
 media_owner_id | *integer* `Example: 1007` | 

### Examples:

#### Example: /api/v1/media_containers?last_date=2016-02-16

##### Request headers:

    Content-Type: application/x-www-form-urlencoded

##### Request params:

    {
      "last_date": "2016-06-30"
    }

##### Response headers:

    Status:       200
    Content-Type: application/json

##### Response body:

    [
      {
        "type": "media_container",
        "id": 26,
        "date": 1467158400,
        "name": "Yesterday",
        "description": "Et neque et sit. Qui assumenda facere excepturi. Illum voluptas consequatur aut ipsa. Soluta et tenetur accusamus nam. Ut dignissimos odio.",
        "additional_description": "You can't copy the program without backing up the online XML capacitor!",
        "width": "half",
        "owner": {
          "id": 26,
          "type": "media_owner",
          "name": "Sonya Bins MD",
          "thumbnail_url": "/uploads/media_owner_picture/29/14/29/custom_my_picture.png"
        },
        "content": {
          "type": "image/png",
          "url": "/home/mariusz/working/hotspotting/spec/support/uploads/media_content/file/34/my_picture_1jhs9qurxw.png",
          "thumbnail_url": "/home/mariusz/working/hotspotting/spec/support/uploads/media_content/file/34/thumb_my_picture_1jhs9qurxw.png"
        }
      }
    ]

#### Example: /api/v1/media_containers

##### Request headers:

    Content-Type: application/x-www-form-urlencoded

##### Response headers:

    Status:       200
    Content-Type: application/json

##### Response body:

    [
      {
        "type": "media_container",
        "id": 25,
        "date": 1467244800,
        "name": "Today",
        "description": "Eius consectetur amet id beatae quos aut nihil. Eos repellat non ea qui. In eligendi et consectetur neque vel voluptatum. Eligendi nihil recusandae maxime omnis alias consequatur minus.",
        "additional_description": "You can't copy the matrix without copying the open-source COM circuit!",
        "width": "half",
        "owner": {
          "id": 25,
          "type": "media_owner",
          "name": "Damon Nolan",
          "thumbnail_url": "/uploads/media_owner_picture/28/14/28/custom_my_picture.png"
        },
        "content": {
          "type": "image/png",
          "url": "/home/mariusz/working/hotspotting/spec/support/uploads/media_content/file/33/my_picture_jm04ngd5mk.png",
          "thumbnail_url": "/home/mariusz/working/hotspotting/spec/support/uploads/media_content/file/33/thumb_my_picture_jm04ngd5mk.png"
        }
      },
      {
        "type": "media_container",
        "id": 24,
        "date": 1467158400,
        "name": "Yesterday",
        "description": "Omnis autem blanditiis. Omnis laudantium possimus et pariatur tempora nisi sit. Quae cum amet.",
        "additional_description": "bypassing the pixel won't do anything, we need to calculate the open-source HDD microchip!",
        "width": "half",
        "owner": {
          "id": 24,
          "type": "media_owner",
          "name": "Alvena Shields",
          "thumbnail_url": "/uploads/media_owner_picture/27/13/27/custom_my_picture.png"
        },
        "content": {
          "type": "image/png",
          "url": "/home/mariusz/working/hotspotting/spec/support/uploads/media_content/file/32/my_picture_hmow7m722c.png",
          "thumbnail_url": "/home/mariusz/working/hotspotting/spec/support/uploads/media_content/file/32/thumb_my_picture_hmow7m722c.png"
        }
      }
    ]

#### Example: /api/v1/media_containers?media_owner_id=1

##### Request headers:

    Content-Type: application/x-www-form-urlencoded

##### Request params:

    {
      "media_owner_id": "1007"
    }

##### Response headers:

    Status:       200
    Content-Type: application/json

##### Response body:

    [
      {
        "type": "media_container",
        "id": 28,
        "date": 1466780344,
        "name": "Media Owner content",
        "description": "Maiores exercitationem amet quo ut ut. Nihil labore numquam omnis omnis. Facere corrupti fuga non voluptatem. Minus est qui nihil eius omnis dolorem. Repudiandae autem est voluptas provident.",
        "additional_description": "copying the driver won't do anything, we need to generate the auxiliary IB port!",
        "width": "half",
        "owner": "",
        "content": {
          "type": "image/png",
          "url": "/home/mariusz/working/hotspotting/spec/support/uploads/media_content/file/35/my_picture_lwyn5nt1y5.png",
          "thumbnail_url": "/home/mariusz/working/hotspotting/spec/support/uploads/media_content/file/35/thumb_my_picture_lwyn5nt1y5.png"
        }
      }
    ]

## Action: Retrieve single Media Container

### Description:

#### Signature:

**GET** `/api/v1/media_containers/{id}`

#### Parameters:

Name | Type | Description
-----|------|---------|------------
 id | *integer* `Example: 30` | 

### Examples:

#### Example: /api/v1/media_containers/:id

##### Request headers:

    Content-Type: application/x-www-form-urlencoded

##### Request params:

    {
      "id": "30"
    }

##### Response headers:

    Status:       200
    Content-Type: application/json

##### Response body:

    {
      "type": "media_container",
      "id": 30,
      "date": 1466973480,
      "name": "Jennifer Lopez outfit",
      "description": "Quaerat alias aut et. Officia possimus ipsum delectus. Ut reiciendis natus ut mollitia facere hic. Qui sit similique et beatae aut. Facilis ipsam ea sunt.",
      "additional_description": "I'll back up the cross-platform GB monitor, that should card the USB feed!",
      "width": "half",
      "owner": {
        "id": 27,
        "type": "media_owner",
        "name": "Ambrose Lebsack",
        "thumbnail_url": "/uploads/media_owner_picture/31/15/31/custom_my_picture.png"
      },
      "content": {
        "type": "image/png",
        "url": "/home/mariusz/working/hotspotting/spec/support/uploads/media_content/file/36/my_picture_3a92ms8jvs.png",
        "thumbnail_url": "/home/mariusz/working/hotspotting/spec/support/uploads/media_content/file/36/thumb_my_picture_3a92ms8jvs.png"
      },
      "tags": [
        {
          "id": 3,
          "icon": "",
          "coordinate_x": "0.900",
          "coordinate_y": "0.590",
          "start_time_ms": 1,
          "end_time_ms": 1,
          "product": {
            "id": 20,
            "name": "Gungan",
            "brand": "Mustafar",
            "description": "Who's the more foolish; the fool, or the fool who follows him?",
            "vendor_url": "",
            "vendor": "",
            "image": "",
            "small_image": "",
            "medium_image": "",
            "price_min": 0.0,
            "price_max": 0.0,
            "currency": "USD",
            "asin": "",
            "available": 0
          }
        }
      ]
    }

# Resource: Media Owners

## Action: Videos a Media Owner

### Description:

#### Signature:

**GET** `/api/v1/media_owners/46/videos`

#### Parameters:

Name | Type | Description
-----|------|---------|------------
 number_of_posts | *integer* `Example: 25` | 
 timestamp | *integer* `Example: 1467282383` | 
 id | *integer* `Example: 46` | 

### Examples:

#### Example: /api/v1/media_owners/:id/videos?number_of_posts=25&timestamp=1781096123

##### Request headers:

    Content-Type: application/x-www-form-urlencoded

##### Request params:

    {
      "number_of_posts": "25",
      "timestamp": "1467282383",
      "id": "46"
    }

##### Response headers:

    Status:       200
    Content-Type: application/json

##### Response body:

    {
      "social_media_containers": [
        {
          "type": "social_media_container",
          "id": 30,
          "date": 1466890964,
          "width": "half",
          "post_type": "video",
          "content_title": "The Waste Land",
          "content_body": "Adipisci nihil et est facilis et blanditiis.",
          "post_url": "http://waelchi.net/eldon_ziemann",
          "website": "twitter",
          "icon": "http://localhost:3000/icons/twitter.png",
          "owner": {
            "id": 46,
            "type": "media_owner",
            "name": "Augustus Steuber",
            "thumbnail_url": "/uploads/media_owner_picture/50/25/50/custom_my_picture.png"
          },
          "content": {
            "type": "video/mp4",
            "url": "/home/mariusz/working/hotspotting/spec/support/uploads/post/content_video/30/video.mp4",
            "thumbnail_url": "/home/mariusz/working/hotspotting/spec/support/uploads/post/content_video/30/video_thumb_video.jpg"
          },
          "has_products": false
        },
        {
          "type": "social_media_container",
          "id": 26,
          "date": 1466888503,
          "width": "half",
          "post_type": "video",
          "content_title": "The Golden Bowl",
          "content_body": "Autem omnis non et.",
          "post_url": "http://kuphal.org/crystel",
          "website": "facebook",
          "icon": "http://localhost:3000/icons/facebook.png",
          "owner": {
            "id": 46,
            "type": "media_owner",
            "name": "Augustus Steuber",
            "thumbnail_url": "/uploads/media_owner_picture/50/25/50/custom_my_picture.png"
          },
          "content": {
            "type": "video/mp4",
            "url": "/home/mariusz/working/hotspotting/spec/support/uploads/post/content_video/26/video.mp4",
            "thumbnail_url": "/home/mariusz/working/hotspotting/spec/support/uploads/post/content_video/26/video_thumb_video.jpg"
          },
          "has_products": false
        },
        {
          "type": "social_media_container",
          "id": 28,
          "date": 1466756048,
          "width": "half",
          "post_type": "video",
          "content_title": "Things Fall Apart",
          "content_body": "Doloremque velit id suscipit ipsa est ducimus eum.",
          "post_url": "http://stiedemann.io/sammy_schumm",
          "website": "instagram",
          "icon": "http://localhost:3000/icons/instagram.png",
          "owner": {
            "id": 46,
            "type": "media_owner",
            "name": "Augustus Steuber",
            "thumbnail_url": "/uploads/media_owner_picture/50/25/50/custom_my_picture.png"
          },
          "content": {
            "type": "video/mp4",
            "url": "/home/mariusz/working/hotspotting/spec/support/uploads/post/content_video/28/video.mp4",
            "thumbnail_url": "/home/mariusz/working/hotspotting/spec/support/uploads/post/content_video/28/video_thumb_video.jpg"
          },
          "has_products": false
        }
      ],
      "media_containers": [
        {
          "type": "media_container",
          "id": 33,
          "date": 1467203337,
          "name": "Mark Trantow MD",
          "description": "Quis ut cupiditate placeat quia. Ut alias velit modi est et. Laborum ullam ea rem aperiam culpa odit nihil. Minus unde voluptatem aliquid. Voluptatem amet in.",
          "additional_description": "I'll reboot the open-source USB sensor, that should firewall the GB port!",
          "width": "half",
          "owner": {
            "id": 46,
            "type": "media_owner",
            "name": "Augustus Steuber",
            "thumbnail_url": "/uploads/media_owner_picture/50/25/50/custom_my_picture.png"
          },
          "content": {
            "type": "video/mp4",
            "url": "/home/mariusz/working/hotspotting/spec/support/uploads/media_content/file/37/video_5ujwxp54m4.mp4",
            "thumbnail_url": "/home/mariusz/working/hotspotting/spec/support/uploads/media_content/file/37/video_thumb_video_5ujwxp54m4.jpg"
          }
        }
      ]
    }

## Action: List all Media Owners

### Description:

#### Signature:

**GET** `/api/v1/media_owners`

#### Parameters:

Name | Type | Description
-----|------|---------|------------
 search | *string* `Example: Jennifer` | 
 sort | *string* `Example: followings` | 
 category_id | *integer* `Example: 18` | 
 channel_id | *string* | 

### Examples:

#### Example: /api/v1/media_owners with following flag

##### Request headers:

    Content-Type: application/x-www-form-urlencoded
    Access-Token: Yd76teiDh83R4pH9z_-qyg
    Client:       mHf-4JZ-Aq022Iu8Wf3DLA
    Expiry:       1468491982
    Uid:          benton@haley.net

##### Response headers:

    Status:       200
    Content-Type: application/json
    Access-token: Yd76teiDh83R4pH9z_-qyg
    Client:       mHf-4JZ-Aq022Iu8Wf3DLA
    Expiry:       1468491982
    Uid:          benton@haley.net

##### Response body:

    [
      {
        "id": 31,
        "name": "Chrissy Teigen",
        "thumbnail_url": "/uploads/media_owner_picture/35/17/35/custom_my_picture.png",
        "is_followed": false
      },
      {
        "id": 30,
        "name": "Jennifer Lopez",
        "thumbnail_url": "/uploads/media_owner_picture/34/17/34/custom_my_picture.png",
        "is_followed": true
      }
    ]

#### Example: /api/v1/channels with following flag wrong token

##### Request headers:

    Content-Type: application/x-www-form-urlencoded
    Access-Token: zfyZOdltUvnvZK1Gw
    Client:       EDy68nOY54fJeemrNunitQ
    Expiry:       1463745453
    Uid:          sylvester@schmidt.org

##### Response headers:

    Status:       401
    Content-Type: application/json

##### Response body:

    {
      "errors": [
        "Authorized users only."
      ]
    }

#### Example: /api/v1/media_owners?search='name'

##### Request headers:

    Content-Type: application/x-www-form-urlencoded

##### Request params:

    {
      "search": "Jennifer"
    }

##### Response headers:

    Status:       200
    Content-Type: application/json

##### Response body:

    [
      {
        "id": 39,
        "name": "Jennifer Lopez",
        "thumbnail_url": "/uploads/media_owner_picture/43/21/43/custom_my_picture.png"
      }
    ]

#### Example: /api/v1/media_owners?sort=followings

##### Request headers:

    Content-Type: application/x-www-form-urlencoded

##### Request params:

    {
      "sort": "followings"
    }

##### Response headers:

    Status:       200
    Content-Type: application/json

##### Response body:

    [
      {
        "id": 34,
        "name": "Jennifer Lopez",
        "thumbnail_url": "/uploads/media_owner_picture/38/19/38/custom_my_picture.png"
      },
      {
        "id": 35,
        "name": "Chrissy Teigen",
        "thumbnail_url": "/uploads/media_owner_picture/39/19/39/custom_my_picture.png"
      }
    ]

#### Example: /api/v1/media_owners?category_id=1

##### Request headers:

    Content-Type: application/x-www-form-urlencoded

##### Request params:

    {
      "category_id": "18"
    }

##### Response headers:

    Status:       200
    Content-Type: application/json

##### Response body:

    [
      {
        "id": 38,
        "name": "Hilda Konopelski",
        "thumbnail_url": "/uploads/media_owner_picture/42/21/42/custom_my_picture.png"
      },
      {
        "id": 37,
        "name": "Ernestine Cartwright",
        "thumbnail_url": "/uploads/media_owner_picture/41/20/41/custom_my_picture.png"
      }
    ]

#### Example: /api/v1/media_owners?channel_id[]=1

##### Request headers:

    Content-Type: application/x-www-form-urlencoded

##### Request params:

    {
      "channel_id": [
        "23"
      ]
    }

##### Response headers:

    Status:       200
    Content-Type: application/json

##### Response body:

    [
      {
        "id": 42,
        "name": "with channel2",
        "thumbnail_url": "/uploads/media_owner_picture/46/23/46/custom_my_picture.png"
      },
      {
        "id": 41,
        "name": "with channel",
        "thumbnail_url": "/uploads/media_owner_picture/45/22/45/custom_my_picture.png"
      }
    ]

#### Example: /api/v1/media_owners

##### Request headers:

    Content-Type: application/x-www-form-urlencoded

##### Response headers:

    Status:       200
    Content-Type: application/json

##### Response body:

    [
      {
        "id": 29,
        "name": "Chrissy Teigen",
        "thumbnail_url": "/uploads/media_owner_picture/33/16/33/custom_my_picture.png"
      },
      {
        "id": 28,
        "name": "Jennifer Lopez",
        "thumbnail_url": "/uploads/media_owner_picture/32/16/32/custom_my_picture.png"
      }
    ]

## Action: Feed a Media Owner

### Description:

#### Signature:

**GET** `/api/v1/media_owners/45/feed`

#### Parameters:

Name | Type | Description
-----|------|---------|------------
 number_of_posts | *integer* `Example: 25` | 
 timestamp | *integer* `Example: 1467282383` | 
 id | *integer* `Example: 45` | 

### Examples:

#### Example: /api/v1/media_owners/:id/feed?number_of_posts=25&timestamp=1781096123

##### Request headers:

    Content-Type: application/x-www-form-urlencoded

##### Request params:

    {
      "number_of_posts": "25",
      "timestamp": "1467282383",
      "id": "45"
    }

##### Response headers:

    Status:       200
    Content-Type: application/json

##### Response body:

    {
      "social_media_containers": [
        {
          "type": "social_media_container",
          "id": 22,
          "date": 1467221672,
          "width": "half",
          "post_type": "video",
          "content_title": "To a God Unknown",
          "content_body": "Vel qui accusantium minus sed est quidem.",
          "post_url": "http://botsford.co/creola.price",
          "website": "instagram",
          "icon": "http://localhost:3000/icons/instagram.png",
          "owner": {
            "id": 45,
            "type": "media_owner",
            "name": "Moshe Johns DDS",
            "thumbnail_url": "/uploads/media_owner_picture/49/24/49/custom_my_picture.png"
          },
          "content": {
            "type": "video/mp4",
            "url": "/home/mariusz/working/hotspotting/spec/support/uploads/post/content_video/22/video.mp4",
            "thumbnail_url": "/home/mariusz/working/hotspotting/spec/support/uploads/post/content_video/22/video_thumb_video.jpg"
          },
          "has_products": false
        },
        {
          "type": "social_media_container",
          "id": 19,
          "date": 1467178310,
          "width": "half",
          "post_type": "image",
          "content_title": "A Confederacy of Dunces",
          "content_body": "Reprehenderit illum fugit culpa consectetur sint fugiat.",
          "post_url": "http://marquardt.info/leann",
          "website": "facebook",
          "icon": "http://localhost:3000/icons/facebook.png",
          "owner": {
            "id": 45,
            "type": "media_owner",
            "name": "Moshe Johns DDS",
            "thumbnail_url": "/uploads/media_owner_picture/49/24/49/custom_my_picture.png"
          },
          "content": {
            "type": "image",
            "url": "/home/mariusz/working/hotspotting/spec/support/uploads/post/content_picture/19/my_picture_j2tu2d59kw.png",
            "thumbnail_url": "/home/mariusz/working/hotspotting/spec/support/uploads/post/content_picture/19/my_picture_j2tu2d59kw.png"
          },
          "has_products": false
        },
        {
          "type": "social_media_container",
          "id": 23,
          "date": 1467065672,
          "width": "half",
          "post_type": "image",
          "content_title": "No Country for Old Men",
          "content_body": "Laudantium dicta voluptas iste.",
          "post_url": "http://toy.com/ramon",
          "website": "twitter",
          "icon": "http://localhost:3000/icons/twitter.png",
          "owner": {
            "id": 45,
            "type": "media_owner",
            "name": "Moshe Johns DDS",
            "thumbnail_url": "/uploads/media_owner_picture/49/24/49/custom_my_picture.png"
          },
          "content": {
            "type": "image",
            "url": "/home/mariusz/working/hotspotting/spec/support/uploads/post/content_picture/23/my_picture_58co6h0rm0.png",
            "thumbnail_url": "/home/mariusz/working/hotspotting/spec/support/uploads/post/content_picture/23/my_picture_58co6h0rm0.png"
          },
          "has_products": false
        },
        {
          "type": "social_media_container",
          "id": 24,
          "date": 1466945817,
          "width": "half",
          "post_type": "video",
          "content_title": "A Darkling Plain",
          "content_body": "Pariatur in rem veniam qui beatae adipisci.",
          "post_url": "http://fay.name/zoey",
          "website": "twitter",
          "icon": "http://localhost:3000/icons/twitter.png",
          "owner": {
            "id": 45,
            "type": "media_owner",
            "name": "Moshe Johns DDS",
            "thumbnail_url": "/uploads/media_owner_picture/49/24/49/custom_my_picture.png"
          },
          "content": {
            "type": "video/mp4",
            "url": "/home/mariusz/working/hotspotting/spec/support/uploads/post/content_video/24/video.mp4",
            "thumbnail_url": "/home/mariusz/working/hotspotting/spec/support/uploads/post/content_video/24/video_thumb_video.jpg"
          },
          "has_products": false
        },
        {
          "type": "social_media_container",
          "id": 20,
          "date": 1466823151,
          "width": "half",
          "post_type": "video",
          "content_title": "The Daffodil Sky",
          "content_body": "Consequatur saepe sit voluptatem vel officia repellat alias ut.",
          "post_url": "http://upton.com/ruby",
          "website": "facebook",
          "icon": "http://localhost:3000/icons/facebook.png",
          "owner": {
            "id": 45,
            "type": "media_owner",
            "name": "Moshe Johns DDS",
            "thumbnail_url": "/uploads/media_owner_picture/49/24/49/custom_my_picture.png"
          },
          "content": {
            "type": "video/mp4",
            "url": "/home/mariusz/working/hotspotting/spec/support/uploads/post/content_video/20/video.mp4",
            "thumbnail_url": "/home/mariusz/working/hotspotting/spec/support/uploads/post/content_video/20/video_thumb_video.jpg"
          },
          "has_products": false
        },
        {
          "type": "social_media_container",
          "id": 21,
          "date": 1466679167,
          "width": "half",
          "post_type": "image",
          "content_title": "Vile Bodies",
          "content_body": "Officiis recusandae rerum exercitationem iure.",
          "post_url": "http://aufderhargoodwin.biz/lonnie_rutherford",
          "website": "instagram",
          "icon": "http://localhost:3000/icons/instagram.png",
          "owner": {
            "id": 45,
            "type": "media_owner",
            "name": "Moshe Johns DDS",
            "thumbnail_url": "/uploads/media_owner_picture/49/24/49/custom_my_picture.png"
          },
          "content": {
            "type": "image",
            "url": "/home/mariusz/working/hotspotting/spec/support/uploads/post/content_picture/21/my_picture_iu9f3vl1my.png",
            "thumbnail_url": "/home/mariusz/working/hotspotting/spec/support/uploads/post/content_picture/21/my_picture_iu9f3vl1my.png"
          },
          "has_products": false
        }
      ]
    }

## Action: Discovery a Media Owner

### Description:

#### Signature:

**GET** `/api/v1/media_owners/discovery`

#### Parameters:

Name | Type | Description
-----|------|---------|------------
 number_of_posts | *integer* `Example: 25` | 
 timestamp | *integer* `Example: 1467282383` | 

### Examples:

#### Example: /api/v1/media_owners/discovery?number_of_posts=25&timestamp=1781096123

##### Request headers:

    Content-Type: application/x-www-form-urlencoded

##### Request params:

    {
      "number_of_posts": "25",
      "timestamp": "1467282383"
    }

##### Response headers:

    Status:       200
    Content-Type: application/json

##### Response body:

    {
      "social_media_containers": [
        {
          "type": "social_media_container",
          "id": 31,
          "date": 1467182365,
          "width": "half",
          "post_type": "image",
          "content_title": "An Evil Cradling",
          "content_body": "Harum incidunt adipisci est nobis enim tempore aut.",
          "post_url": "http://langworth.co/nyasia.hyatt",
          "website": "facebook",
          "icon": "http://localhost:3000/icons/facebook.png",
          "owner": {
            "id": 47,
            "type": "media_owner",
            "name": "Maggie Lind",
            "thumbnail_url": "/uploads/media_owner_picture/51/25/51/custom_my_picture.png"
          },
          "content": {
            "type": "image",
            "url": "/home/mariusz/working/hotspotting/spec/support/uploads/post/content_picture/31/my_picture_p268kvqum.png",
            "thumbnail_url": "/home/mariusz/working/hotspotting/spec/support/uploads/post/content_picture/31/my_picture_p268kvqum.png"
          },
          "has_products": false
        },
        {
          "type": "social_media_container",
          "id": 33,
          "date": 1467050943,
          "width": "half",
          "post_type": "image",
          "content_title": "Blue Remembered Earth",
          "content_body": "Vel dolor dolores expedita voluptatibus accusantium voluptatem laborum omnis.",
          "post_url": "http://durgan.co/betty.green",
          "website": "instagram",
          "icon": "http://localhost:3000/icons/instagram.png",
          "owner": {
            "id": 48,
            "type": "media_owner",
            "name": "Vivienne Beatty",
            "thumbnail_url": "/uploads/media_owner_picture/52/26/52/custom_my_picture.png"
          },
          "content": {
            "type": "image",
            "url": "/home/mariusz/working/hotspotting/spec/support/uploads/post/content_picture/33/my_picture_glh4qpuhwb.png",
            "thumbnail_url": "/home/mariusz/working/hotspotting/spec/support/uploads/post/content_picture/33/my_picture_glh4qpuhwb.png"
          },
          "has_products": false
        },
        {
          "type": "social_media_container",
          "id": 32,
          "date": 1466890734,
          "width": "half",
          "post_type": "video",
          "content_title": "Postern of Fate",
          "content_body": "Voluptatem sequi cupiditate aperiam placeat aut veritatis nisi.",
          "post_url": "http://nitzsche.co/flavio_hahn",
          "website": "facebook",
          "icon": "http://localhost:3000/icons/facebook.png",
          "owner": {
            "id": 47,
            "type": "media_owner",
            "name": "Maggie Lind",
            "thumbnail_url": "/uploads/media_owner_picture/51/25/51/custom_my_picture.png"
          },
          "content": {
            "type": "video/mp4",
            "url": "/home/mariusz/working/hotspotting/spec/support/uploads/post/content_video/32/video.mp4",
            "thumbnail_url": "/home/mariusz/working/hotspotting/spec/support/uploads/post/content_video/32/video_thumb_video.jpg"
          },
          "has_products": false
        },
        {
          "type": "social_media_container",
          "id": 34,
          "date": 1466713370,
          "width": "half",
          "post_type": "video",
          "content_title": "Recalled to Life",
          "content_body": "Illo dolorem deleniti rerum.",
          "post_url": "http://jacobson.com/adrian",
          "website": "instagram",
          "icon": "http://localhost:3000/icons/instagram.png",
          "owner": {
            "id": 48,
            "type": "media_owner",
            "name": "Vivienne Beatty",
            "thumbnail_url": "/uploads/media_owner_picture/52/26/52/custom_my_picture.png"
          },
          "content": {
            "type": "video/mp4",
            "url": "/home/mariusz/working/hotspotting/spec/support/uploads/post/content_video/34/video.mp4",
            "thumbnail_url": "/home/mariusz/working/hotspotting/spec/support/uploads/post/content_video/34/video_thumb_video.jpg"
          },
          "has_products": false
        }
      ]
    }

## Action: Retrieve single Media Owner

### Description:

#### Signature:

**GET** `/api/v1/media_owners/{id}`

#### Parameters:

Name | Type | Description
-----|------|---------|------------
 id | *integer* `Example: 36` | 

### Examples:

#### Example: /api/v1/media_owners/:id

##### Request headers:

    Content-Type: application/x-www-form-urlencoded

##### Request params:

    {
      "id": "36"
    }

##### Response headers:

    Status:       200
    Content-Type: application/json

##### Response body:

    {
      "id": 36,
      "name": "Jennifer Lopez",
      "thumbnail_url": "/uploads/media_owner_picture/40/20/40/custom_my_picture.png",
      "image_url": "/uploads/media_owner_picture/40/20/40/custom_my_picture.png",
      "url": "http://heidenreich.co/esteban",
      "background_image_url": "/uploads/media_owner_background_image/40/20/40/custom_my_picture.png",
      "channels": [
        {
          "id": 22,
          "name": "MTV",
          "thumbnail_url": "/uploads/channel_picture/27/13/27/custom_my_picture.png",
          "image_url": "/uploads/channel_picture/27/13/27/custom_my_picture.png",
          "feed": true,
          "magazines": false,
          "tv_shows": false
        }
      ],
      "feed": true
    }

# Resource: Omniauth Callbacks

## Action: Fb login an Omniauth Callback

### Description:

#### Signature:

**GET** `/api/v1/fb_login/xxx`

#### Parameters:

Name | Type | Description
-----|------|---------|------------
 fb_token | *string* `Example: EAAWEsLW7mI8BAF4zvZB3VGHMedhNkCnZCxnT5B7akE316ZBPDotHTNWdRn6dlbVdJ33tfIlDBOZA6RNWQGJlGfqXkk1B4Edvka3Qes742cR7sVi68JxYPw0KQN7EYoG0hAeNHtTKJp4ZCJP3u26IHZBaD4FjFmBwwLExoBbmmlnq1MegOdTUCZA` | 

### Examples:

#### Example: /api/v1/fb_login/:token error

##### Request headers:

    Content-Type: application/x-www-form-urlencoded

##### Request params:

    {
      "fb_token": "xxx"
    }

##### Response headers:

    Status:       401
    Content-Type: application/json

##### Response body:

    {
      "errors": [
        "Invalid login credentials. Please try again."
      ]
    }

#### Example: /api/v1/fb_login/:token success

##### Request headers:

    Content-Type: application/x-www-form-urlencoded

##### Request params:

    {
      "fb_token": "EAAWEsLW7mI8BAF4zvZB3VGHMedhNkCnZCxnT5B7akE316ZBPDotHTNWdRn6dlbVdJ33tfIlDBOZA6RNWQGJlGfqXkk1B4Edvka3Qes742cR7sVi68JxYPw0KQN7EYoG0hAeNHtTKJp4ZCJP3u26IHZBaD4FjFmBwwLExoBbmmlnq1MegOdTUCZA"
    }

##### Response headers:

    Status:       200
    Content-Type: application/json
    Access-token: AfjlCuTQ9WhXLdPm1ktaBg
    Client:       AU2yW6Q4Srph5qC_N4_Tcw
    Expiry:       1468491997
    Uid:          121207904952738

##### Response body:

    {
      "data": {
        "id": 33,
        "provider": "facebook",
        "uid": "121207904952738",
        "email": null,
        "created_at": "2016-06-30T10:26:37.242Z",
        "updated_at": "2016-06-30T10:26:37.326Z",
        "ulab_user_id": null,
        "ulab_access_token": null
      }
    }

## Action: Failure an Omniauth Callback

### Description:

#### Signature:

**GET** `/omniauth/facebook/callback`

#### Parameters:

Name | Type | Description
-----|------|---------|------------

### Examples:

#### Example: /api/v1/auth/facebook?auth_origin_url=return_url error

##### Request headers:

    Content-Type: application/x-www-form-urlencoded

##### Response headers:

    Status:       302
    Content-Type: 

##### Response body:

    <html><body>You are being <a href="http://localhost/api/v1/auth/sign_in">redirected</a>.</body></html>

## Action: Omniauth success an Omniauth Callback

### Description:

#### Signature:

**GET** `/api/v1/auth/facebook/callback`

#### Parameters:

Name | Type | Description
-----|------|---------|------------
 provider | *string* `Example: facebook` | 

### Examples:

#### Example: /api/v1/auth/facebook?auth_origin_url=return_url success

##### Request headers:

    Content-Type: application/x-www-form-urlencoded

##### Request params:

    {
      "provider": "facebook"
    }

##### Response headers:

    Status:       302
    Content-Type: 

##### Response body:

    <html><body>You are being <a href="http://localhost/api/v1/snapped_products?access-token=3gfjd1a_VTckmby56HSy6Q&amp;auth_token=3gfjd1a_VTckmby56HSy6Q&amp;blank=true&amp;client=H8h6jg83ndnUSAteWwtJog&amp;client_id=H8h6jg83ndnUSAteWwtJog&amp;config=&amp;expiry=1468491998&amp;oauth_registration=true&amp;uid=123456789zxcasdqwe">redirected</a>.</body></html>

## Action: Redirect callbacks an Omniauth Callback

### Description:

#### Signature:

**GET** `/omniauth/facebook/callback`

#### Parameters:

Name | Type | Description
-----|------|---------|------------
 provider | *string* `Example: facebook` | 

### Examples:

#### Example: /api/v1/auth/facebook?auth_origin_url=return_url success

##### Request headers:

    Content-Type: application/x-www-form-urlencoded

##### Request params:

    {
      "provider": "facebook"
    }

##### Response headers:

    Status:       302
    Content-Type: 

##### Response body:

    <html><body>You are being <a href="http://localhost//api/v1/auth/facebook/callback">redirected</a>.</body></html>

# Resource: Passwords

## Action: Update an existing Password

### Description:

#### Signature:

**PUT** `/api/v1/auth/password`

#### Parameters:

Name | Type | Description
-----|------|---------|------------
 password | *string* `Example: sample` | 
 password_confirmation | *string* `Example: sample` | 

### Examples:

#### Example: Put /api/v1/auth/password UPDATE PASSWORD success

##### Request headers:

    Content-Type: application/x-www-form-urlencoded
    Access-Token: PiRUzcP-26esKPm36LbIog
    Client:       bSPtXfenPvcpVylqQlZQnA
    Expiry:       1468491995
    Uid:          jaunita_oreilly@considine.name

##### Request params:

    {
      "password": "sample",
      "password_confirmation": "sample"
    }

##### Response headers:

    Status:       200
    Content-Type: application/json
    Access-token: PiRUzcP-26esKPm36LbIog
    Client:       bSPtXfenPvcpVylqQlZQnA
    Expiry:       1468491995
    Uid:          jaunita_oreilly@considine.name

##### Response body:

    {
      "success": true,
      "data": {
        "id": 26,
        "provider": "email",
        "uid": "jaunita_oreilly@considine.name",
        "email": "jaunita_oreilly@considine.name",
        "created_at": "2016-06-30T10:26:35.239Z",
        "updated_at": "2016-06-30T10:26:35.371Z",
        "ulab_user_id": null,
        "ulab_access_token": null
      },
      "message": "Your password has been successfully updated."
    }

#### Example: Put /api/v1/auth/password UPDATE PASSWORD error

##### Request headers:

    Content-Type: application/x-www-form-urlencoded
    Access-Token: salEH4N2ko5dACnu5XF7OA
    Client:       IaNBg-3uIj4Y57NzLmyO1A
    Expiry:       1468491995
    Uid:          kamryn.gottlieb@effertzcollier.com

##### Request params:

    {
      "password": "sample",
      "password_confirmation": "wrongconf"
    }

##### Response headers:

    Status:       422
    Content-Type: application/json

##### Response body:

    {
      "success": false,
      "errors": {
        "password_confirmation": [
          "doesn't match Password"
        ],
        "full_messages": [
          "Password confirmation doesn't match Password"
        ]
      }
    }

## Action: Create a Password

### Description:

#### Signature:

**POST** `/api/v1/auth/password`

#### Parameters:

Name | Type | Description
-----|------|---------|------------
 email | *string* `Example: beie.larson@rosenbaumhilll.org` | 
 redirect_url | *string* `Example: sample_url` | 

### Examples:

#### Example: Post /api/v1/auth/password RESEND CONFIRMATION EMAIL error

##### Request headers:

    Content-Type: application/x-www-form-urlencoded

##### Request params:

    {
      "email": "wrong_email@o2.pl",
      "redirect_url": "sample_url"
    }

##### Response headers:

    Status:       404
    Content-Type: application/json

##### Response body:

    {
      "success": false,
      "errors": [
        "Unable to find user with email 'wrong_email@o2.pl'."
      ]
    }

#### Example: Post /api/v1/auth/password RESEND CONFIRMATION EMAIL success

##### Request headers:

    Content-Type: application/x-www-form-urlencoded

##### Request params:

    {
      "email": "beie.larson@rosenbaumhilll.org",
      "redirect_url": "sample_url"
    }

##### Response headers:

    Status:       200
    Content-Type: application/json

##### Response body:

    {
      "success": true,
      "data": {
        "id": 25,
        "provider": "email",
        "uid": "beie.larson@rosenbaumhilll.org",
        "email": "beie.larson@rosenbaumhilll.org",
        "created_at": "2016-06-30T10:26:35.029Z",
        "updated_at": "2016-06-30T10:26:35.200Z",
        "ulab_user_id": null,
        "ulab_access_token": null
      },
      "message": "An email has been sent to 'beie.larson@rosenbaumhilll.org' containing instructions for resetting your password."
    }

# Resource: Posts

## Action: Retrieve single Post

### Description:

#### Signature:

**GET** `/api/v1/posts/{id}`

#### Parameters:

Name | Type | Description
-----|------|---------|------------
 id | *integer* `Example: 35` | 

### Examples:

#### Example: /api/v1/posts/:id

##### Request headers:

    Content-Type: application/x-www-form-urlencoded

##### Request params:

    {
      "id": "35"
    }

##### Response headers:

    Status:       200
    Content-Type: application/json

##### Response body:

    {
      "post": {
        "type": "social_media_container",
        "id": 35,
        "date": 1466877638,
        "width": "half",
        "post_type": "image",
        "content_title": "Let Us Now Praise Famous Men",
        "content_body": "Ut ut aut dolorem mollitia.",
        "post_url": "http://kelerluettgen.net/hilton_quitzon",
        "website": "facebook",
        "icon": "http://localhost:3000/icons/facebook.png",
        "owner": {
          "id": 49,
          "type": "media_owner",
          "name": "Rex Schultz Jr.",
          "thumbnail_url": "/uploads/media_owner_picture/53/26/53/custom_my_picture.png"
        },
        "content": {
          "type": "image",
          "url": "/home/mariusz/working/hotspotting/spec/support/uploads/post/content_picture/35/my_picture_f21366v89q.png",
          "thumbnail_url": "/home/mariusz/working/hotspotting/spec/support/uploads/post/content_picture/35/my_picture_f21366v89q.png"
        },
        "has_products": true
      },
      "products": [
        {
          "id": 22,
          "name": "Hutt",
          "brand": "Endor",
          "description": "You'll find I'm full of surprises!",
          "vendor_url": "",
          "vendor": "",
          "image": "",
          "small_image": "",
          "medium_image": "",
          "price_min": 0.0,
          "price_max": 0.0,
          "currency": "USD",
          "asin": "",
          "available": 0
        },
        {
          "id": 23,
          "name": "Mon Calamari",
          "brand": "Dagobah",
          "description": "You'll find I'm full of surprises!",
          "vendor_url": "",
          "vendor": "",
          "image": "",
          "small_image": "",
          "medium_image": "",
          "price_min": 0.0,
          "price_max": 0.0,
          "currency": "USD",
          "asin": "",
          "available": 0
        },
        {
          "id": 24,
          "name": "Neimoidian",
          "brand": "Coruscant",
          "description": "You know, that little droid is going to cause me a lot of trouble.",
          "vendor_url": "",
          "vendor": "",
          "image": "",
          "small_image": "",
          "medium_image": "",
          "price_min": 0.0,
          "price_max": 0.0,
          "currency": "USD",
          "asin": "",
          "available": 0
        }
      ]
    }

# Resource: Products

## Action: List all Products

### Description:

#### Signature:

**GET** `/api/v1/products`

#### Parameters:

Name | Type | Description
-----|------|---------|------------
 category_id | *string* | 
 channel_id | *string* | 
 search | *string* `Example: First` | 
 media_owner_id | *string* | 
 page | *integer* `Example: 1` | 
 per | *integer* `Example: 1000` | 
 product_ids | *string* | 
 vendor | *string* | 

### Examples:

#### Example: /api/v1/products?category_id[]=1

##### Request headers:

    Content-Type: application/x-www-form-urlencoded

##### Request params:

    {
      "category_id": [
        "19"
      ]
    }

##### Response headers:

    Status:       200
    Content-Type: application/json

##### Response body:

    [
      {
        "id": 29,
        "name": "Woman Shoes",
        "brand": "Coruscant",
        "description": "Only at the end do you realize the power of the Dark Side.",
        "vendor_url": "",
        "vendor": "Amazon",
        "image": "",
        "small_image": "",
        "medium_image": "",
        "price_min": 19.990000000000002,
        "price_max": 39.99,
        "currency": "USD",
        "asin": "B0012GLDCU",
        "available": 1
      }
    ]

#### Example: /api/v1/products?category_id[]=1&channel_id[]=1

##### Request headers:

    Content-Type: application/x-www-form-urlencoded

##### Request params:

    {
      "category_id": [
        "21"
      ],
      "channel_id": [
        "25"
      ]
    }

##### Response headers:

    Status:       200
    Content-Type: application/json

##### Response body:

    [
      {
        "id": 34,
        "name": "Woman Shoes",
        "brand": "Mustafar",
        "description": "I have a bad feeling about this.",
        "vendor_url": "",
        "vendor": "Amazon",
        "image": "",
        "small_image": "",
        "medium_image": "",
        "price_min": 19.990000000000002,
        "price_max": 39.99,
        "currency": "USD",
        "asin": "B0012GLDCU",
        "available": 1
      },
      {
        "id": 35,
        "name": "Woman Shoes 2",
        "brand": "Takodana",
        "description": "A Jedi uses the Force for knowledge and defense, never for attack.",
        "vendor_url": "",
        "vendor": "Amazon",
        "image": "",
        "small_image": "",
        "medium_image": "",
        "price_min": 19.990000000000002,
        "price_max": 39.99,
        "currency": "USD",
        "asin": "B0012GLDCU",
        "available": 1
      }
    ]

#### Example: /api/v1/products?search='name'

##### Request headers:

    Content-Type: application/x-www-form-urlencoded

##### Request params:

    {
      "search": "First"
    }

##### Response headers:

    Status:       200
    Content-Type: application/json

##### Response body:

    [
      {
        "id": 38,
        "name": "First last",
        "brand": "Endor",
        "description": "Strike me down, and I will become more powerful than you could possibly imagine.",
        "vendor_url": "",
        "vendor": "Amazon",
        "image": "",
        "small_image": "",
        "medium_image": "",
        "price_min": 19.990000000000002,
        "price_max": 39.99,
        "currency": "USD",
        "asin": "B0012GLDCU",
        "available": 1
      }
    ]

#### Example: /api/v1/products?category_id[]=1&media_owner_id[]=1

##### Request headers:

    Content-Type: application/x-www-form-urlencoded

##### Request params:

    {
      "category_id": [
        "20"
      ],
      "media_owner_id": [
        "50"
      ]
    }

##### Response headers:

    Status:       200
    Content-Type: application/json

##### Response body:

    [
      {
        "id": 32,
        "name": "Woman Shoes",
        "brand": "Hosnian Prime",
        "description": "Never tell me the odds!",
        "vendor_url": "",
        "vendor": "Amazon",
        "image": "",
        "small_image": "",
        "medium_image": "",
        "price_min": 19.990000000000002,
        "price_max": 39.99,
        "currency": "USD",
        "asin": "B0012GLDCU",
        "available": 1
      },
      {
        "id": 33,
        "name": "Woman Shoes 2",
        "brand": "Sullust",
        "description": "Fear is the path to the dark side... fear leads to anger... anger leads to hate... hate leads to suffering.",
        "vendor_url": "",
        "vendor": "Amazon",
        "image": "",
        "small_image": "",
        "medium_image": "",
        "price_min": 19.990000000000002,
        "price_max": 39.99,
        "currency": "USD",
        "asin": "B0012GLDCU",
        "available": 1
      }
    ]

#### Example: /api/v1/products?category_id[]=1&channel_id[]=1&media_owner_id[]=1

##### Request headers:

    Content-Type: application/x-www-form-urlencoded

##### Request params:

    {
      "category_id": [
        "22"
      ],
      "channel_id": [
        "26"
      ],
      "media_owner_id": [
        "51"
      ],
      "page": "1",
      "per": "1000"
    }

##### Response headers:

    Status:       200
    Content-Type: application/json

##### Response body:

    [
      {
        "id": 36,
        "name": "Celebrity Woman Shoes",
        "brand": "Kashyyyk",
        "description": "I have a bad feeling about this.",
        "vendor_url": "",
        "vendor": "Amazon",
        "image": "",
        "small_image": "",
        "medium_image": "",
        "price_min": 19.990000000000002,
        "price_max": 39.99,
        "currency": "USD",
        "asin": "B0012GLDCU",
        "available": 1
      },
      {
        "id": 37,
        "name": "MTV Woman Shoes",
        "brand": "Hoth",
        "description": "You will never find a more wretched hive of scum and villainy. We must be cautious.",
        "vendor_url": "",
        "vendor": "Amazon",
        "image": "",
        "small_image": "",
        "medium_image": "",
        "price_min": 19.990000000000002,
        "price_max": 39.99,
        "currency": "USD",
        "asin": "B0012GLDCU",
        "available": 1
      }
    ]

#### Example: Search for profound words in a language other than english /api/v1/products?search=name&language=pl

##### Request headers:

    Content-Type: application/x-www-form-urlencoded

##### Request params:

    {
      "search": "First"
    }

##### Response headers:

    Status:       200
    Content-Type: application/json

##### Response body:

    [
      {
        "id": 52,
        "name": "First last",
        "brand": "Dagobah",
        "description": "Do. Or do not. There is no try.",
        "vendor_url": "",
        "vendor": "Amazon",
        "image": "",
        "small_image": "",
        "medium_image": "",
        "price_min": 19.990000000000002,
        "price_max": 39.99,
        "currency": "USD",
        "asin": "B0012GLDCU",
        "available": 1
      }
    ]

#### Example: /api/v1/products?product_ids[]=1&product_ids[]=2

##### Request headers:

    Content-Type: application/x-www-form-urlencoded

##### Request params:

    {
      "product_ids": [
        "40",
        "41"
      ]
    }

##### Response headers:

    Status:       200
    Content-Type: application/json

##### Response body:

    [
      {
        "id": 40,
        "name": "Selected product 1",
        "brand": "Hosnian Prime",
        "description": "Now, witness the power of this fully operational battle station.",
        "vendor_url": "",
        "vendor": "Amazon",
        "image": "",
        "small_image": "",
        "medium_image": "",
        "price_min": 19.990000000000002,
        "price_max": 39.99,
        "currency": "USD",
        "asin": "B0012GLDCU",
        "available": 1
      },
      {
        "id": 41,
        "name": "Selected product 2",
        "brand": "Naboo",
        "description": "Now, witness the power of this fully operational battle station.",
        "vendor_url": "",
        "vendor": "Amazon",
        "image": "",
        "small_image": "",
        "medium_image": "",
        "price_min": 19.990000000000002,
        "price_max": 39.99,
        "currency": "USD",
        "asin": "B0012GLDCU",
        "available": 1
      }
    ]

#### Example: /api/v1/products?vendor=manual

##### Request headers:

    Content-Type: application/x-www-form-urlencoded

##### Request params:

    {
      "vendor": [
        "manual"
      ]
    }

##### Response headers:

    Status:       200
    Content-Type: application/json

##### Response body:

    [
      {
        "id": 30,
        "name": "Woman Shoes",
        "brand": "Endor",
        "description": "Only at the end do you realize the power of the Dark Side.",
        "vendor_url": "",
        "vendor": "manual",
        "image": "",
        "small_image": "",
        "medium_image": "",
        "price_min": 0.0,
        "price_max": 0.0,
        "currency": "USD",
        "asin": "B0012GLDCU",
        "available": 0
      },
      {
        "id": 31,
        "name": "Woman Shoes 2",
        "brand": "Kamino",
        "description": "You do have your moments. Not many, but you have them.",
        "vendor_url": "",
        "vendor": "manual",
        "image": "",
        "small_image": "",
        "medium_image": "",
        "price_min": 0.0,
        "price_max": 0.0,
        "currency": "USD",
        "asin": "B0012GLDCU",
        "available": 0
      }
    ]

#### Example: /api/v1/products

##### Request headers:

    Content-Type: application/x-www-form-urlencoded

##### Response headers:

    Status:       200
    Content-Type: application/json

##### Response body:

    [
      {
        "id": 27,
        "name": "First",
        "brand": "Kamino",
        "description": "Strike me down, and I will become more powerful than you could possibly imagine.",
        "vendor_url": "",
        "vendor": "Amazon",
        "image": "",
        "small_image": "",
        "medium_image": "",
        "price_min": 19.990000000000002,
        "price_max": 39.99,
        "currency": "USD",
        "asin": "B0012GLDCU",
        "available": 1
      },
      {
        "id": 28,
        "name": "Second",
        "brand": "Yavin",
        "description": "Would somebody get this big walking carpet out of my way?",
        "vendor_url": "",
        "vendor": "Amazon",
        "image": "",
        "small_image": "",
        "medium_image": "",
        "price_min": 19.990000000000002,
        "price_max": 39.99,
        "currency": "USD",
        "asin": "B0012GLDCU",
        "available": 1
      }
    ]

## Action: Learning a Product

### Description:

#### Signature:

**GET** `/api/v1/products/learning`

#### Parameters:

Name | Type | Description
-----|------|---------|------------
 page | *integer* `Example: 1` | 
 per | *integer* `Example: 1000` | 
 category_hierarchy | *string* | 

### Examples:

#### Example: /api/v1/products/learning?page=1&per=1000

##### Request headers:

    Content-Type: application/x-www-form-urlencoded

##### Request params:

    {
      "page": "1",
      "per": "1000"
    }

##### Response headers:

    Status:       200
    Content-Type: application/json

##### Response body:

    [
      {
        "id": 45,
        "name": "new product",
        "category_id": 25,
        "parent_category_id": 24,
        "category_hierarchy": [
    
        ],
        "default_images": [
          "http://default_image.jpg"
        ],
        "asin": "B0012GLDCU",
        "variants": [
          {
            "variant_images": [
              "http://variant_image.jpg",
              "http://variant_image2.jpg"
            ]
          },
          {
            "variant_images": [
              "http://variant2_image.jpg"
            ]
          }
        ]
      },
      {
        "id": 46,
        "name": "Second",
        "category_id": 25,
        "parent_category_id": 24,
        "category_hierarchy": [
    
        ],
        "default_images": [
    
        ],
        "asin": null,
        "variants": [
    
        ]
      }
    ]

#### Example: Api/v1/products/learning?page=1&category_hierarchy[]=Woman&category_hierarchy[]=Jewelry&category_hierarchy[]=Tie Clips

##### Request headers:

    Content-Type: application/x-www-form-urlencoded

##### Request params:

    {
      "category_hierarchy": [
        "Woman",
        "Jewelry",
        "Tie Clips"
      ],
      "page": "1",
      "per": "1000"
    }

##### Response headers:

    Status:       200
    Content-Type: application/json

##### Response body:

    [
      {
        "id": 47,
        "name": "new product",
        "category_id": 27,
        "parent_category_id": 26,
        "category_hierarchy": [
          "Woman",
          "Jewelry",
          "Tie Clips"
        ],
        "default_images": [
          "http://default_image.jpg"
        ],
        "asin": "B0012GLDCU",
        "variants": [
          {
            "variant_images": [
              "http://variant_image.jpg",
              "http://variant_image2.jpg"
            ]
          },
          {
            "variant_images": [
              "http://variant2_image.jpg"
            ]
          }
        ]
      },
      {
        "id": 48,
        "name": "Second",
        "category_id": 27,
        "parent_category_id": 26,
        "category_hierarchy": [
          "Woman",
          "Jewelry",
          "Tie Clips"
        ],
        "default_images": [
    
        ],
        "asin": null,
        "variants": [
    
        ]
      }
    ]

## Action: Retrieve single Product

### Description:

#### Signature:

**GET** `/api/v1/products/{id}`

#### Parameters:

Name | Type | Description
-----|------|---------|------------
 id | *integer* `Example: 43` | 

### Examples:

#### Example: /api/v1/products/:id

##### Request headers:

    Content-Type: application/x-www-form-urlencoded

##### Request params:

    {
      "id": "43"
    }

##### Response headers:

    Status:       200
    Content-Type: application/json

##### Response body:

    {
      "id": 43,
      "name": "Woman Shoes",
      "brand": "Hosnian Prime",
      "description": "Now, witness the power of this fully operational battle station.",
      "vendor_url": "",
      "vendor": "Amazon",
      "image": "http://large_image.jpg",
      "small_image": "http://small_image.jpg",
      "medium_image": "http://normal_image.jpg",
      "price_min": 19.990000000000002,
      "price_max": 39.99,
      "currency": "USD",
      "asin": "123123123",
      "available": 1,
      "similar_products": [
        {
          "id": 44,
          "name": "Woman Shoes",
          "brand": "Bespin",
          "description": "Bounty hunters! We don't need this scum.",
          "vendor_url": "",
          "vendor": "",
          "image": "",
          "small_image": "",
          "medium_image": "",
          "price_min": 0.0,
          "price_max": 0.0,
          "currency": "USD",
          "asin": "",
          "available": 0
        }
      ],
      "variants": [
        {
          "id": 15,
          "sku": "123123123",
          "description": "Fear is the path to the dark side... fear leads to anger... anger leads to hate... hate leads to suffering.",
          "variant_files": [
    
          ],
          "variant_stores": [
            {
              "value": "95.31",
              "currency": "PLN",
              "url": "http://torphy.biz/kailee.harvey",
              "quantity": "50",
              "store": "Amazon"
            }
          ],
          "option_values": [
            {
              "value": "S",
              "option_type": "size"
            },
            {
              "value": "red",
              "option_type": "colour"
            }
          ]
        },
        {
          "id": 16,
          "sku": "123456789",
          "description": "I have a bad feeling about this.",
          "variant_files": [
    
          ],
          "variant_stores": [
            {
              "value": "45.96",
              "currency": "PLN",
              "url": "http://champlin.name/zaria.wiza",
              "quantity": "50",
              "store": "Manual"
            }
          ],
          "option_values": [
            {
              "value": "XXL",
              "option_type": "size"
            },
            {
              "value": "blue",
              "option_type": "colour"
            }
          ]
        }
      ]
    }

## Action: Index shortened a Product

### Description:

#### Signature:

**GET** `/api/v1/products/index_shortened`

#### Parameters:

Name | Type | Description
-----|------|---------|------------
 search | *string* `Example: dress` | 

### Examples:

#### Example: /api/v1/products/index_shortened?search='name'

##### Request headers:

    Content-Type: application/x-www-form-urlencoded

##### Request params:

    {
      "search": "dress"
    }

##### Response headers:

    Status:       200
    Content-Type: application/json

##### Response body:

    [
      {
        "id": 49,
        "name": "Green dress"
      },
      {
        "id": 50,
        "name": "Blue dress"
      }
    ]

# Resource: Products Containers

## Action: Retrieve single Products Container

### Description:

#### Signature:

**GET** `/api/v1/products_containers/{id}`

#### Parameters:

Name | Type | Description
-----|------|---------|------------
 id | *integer* `Example: 18` | 

### Examples:

#### Example: /api/v1/products_containers/:id

##### Request headers:

    Content-Type: application/x-www-form-urlencoded

##### Request params:

    {
      "id": "18"
    }

##### Response headers:

    Status:       200
    Content-Type: application/json

##### Response body:

    {
      "type": "products_container",
      "id": 18,
      "name": "products container",
      "date": "2016-06-30 10:26:23 UTC",
      "products": [
        {
          "id": 25,
          "name": "Sullustan",
          "brand": "Hoth",
          "description": "Adventure. Excitement. A Jedi craves not these things.",
          "vendor_url": "",
          "vendor": "",
          "image": "",
          "small_image": "",
          "medium_image": "",
          "price_min": 0.0,
          "price_max": 0.0,
          "currency": "USD",
          "asin": "",
          "available": 0
        },
        {
          "id": 26,
          "name": "Mon Calamari",
          "brand": "Takodana",
          "description": "Would somebody get this big walking carpet out of my way?",
          "vendor_url": "",
          "vendor": "",
          "image": "",
          "small_image": "",
          "medium_image": "",
          "price_min": 0.0,
          "price_max": 0.0,
          "currency": "USD",
          "asin": "",
          "available": 0
        }
      ]
    }

# Resource: Registrations

## Action: Update an existing Registration

### Description:

#### Signature:

**PUT** `/api/v1/auth`

#### Parameters:

Name | Type | Description
-----|------|---------|------------
 password | *string* `Example: sample` | 
 password_confirmation | *string* `Example: sample` | 
 current_password | *string* `Example: password` | 

### Examples:

#### Example: /api/v1/auth update password success

##### Request headers:

    Content-Type: application/x-www-form-urlencoded
    Access-Token: aVkZFGUwv1qM6dMwIp6viQ
    Client:       WrFdmXJ9lyGcrQgHsW7BVw
    Expiry:       1468491994
    Uid:          iac.padberg@wyman.net

##### Request params:

    {
      "password": "sample",
      "password_confirmation": "sample",
      "current_password": "password"
    }

##### Response headers:

    Status:       200
    Content-Type: application/json
    Access-token: aVkZFGUwv1qM6dMwIp6viQ
    Client:       WrFdmXJ9lyGcrQgHsW7BVw
    Expiry:       1468491994
    Uid:          iac.padberg@wyman.net

##### Response body:

    {
      "status": "success",
      "data": {
        "id": 23,
        "provider": "email",
        "uid": "iac.padberg@wyman.net",
        "email": "iac.padberg@wyman.net",
        "created_at": "2016-06-30T10:26:34.735Z",
        "updated_at": "2016-06-30T10:26:34.872Z",
        "ulab_user_id": null,
        "ulab_access_token": null
      }
    }

#### Example: /api/v1/auth update password error

##### Request headers:

    Content-Type: application/x-www-form-urlencoded
    Access-Token: sLfkVydrVqhh_XNpmV1u_g
    Client:       YIHRzWGV4Vulybua7KxqeA
    Expiry:       1468491994
    Uid:          theron@reinger.name

##### Request params:

    {
      "password": "sample",
      "password_confirmation": "wrongconf"
    }

##### Response headers:

    Status:       422
    Content-Type: application/json
    Access-token: sLfkVydrVqhh_XNpmV1u_g
    Client:       YIHRzWGV4Vulybua7KxqeA
    Expiry:       1468491994
    Uid:          theron@reinger.name

##### Response body:

    {
      "status": "error",
      "errors": {
        "password_confirmation": [
          "doesn't match Password"
        ],
        "current_password": [
          "can't be blank"
        ],
        "full_messages": [
          "Password confirmation doesn't match Password",
          "Current password can't be blank"
        ]
      }
    }

## Action: Create a Registration

### Description:

#### Signature:

**POST** `/api/v1/auth`

#### Parameters:

Name | Type | Description
-----|------|---------|------------
 email | *string* `Example: sample@gmail.com` | 
 password | *string* `Example: secret` | 
 password_confirmation | *string* `Example: secret` | 
 confirm_success_url | *string* `Example: sample_url` | 

### Examples:

#### Example: /api/v1/auth sign_up: success

##### Request headers:

    Content-Type: application/x-www-form-urlencoded

##### Request params:

    {
      "email": "sample@gmail.com",
      "password": "secret",
      "password_confirmation": "secret",
      "confirm_success_url": "sample_url"
    }

##### Response headers:

    Status:       200
    Content-Type: application/json
    Access-token: ZqP25XVz_yX51-MVA1ZIoA
    Client:       BUxKrlRA67IBWnPwbESTqg
    Expiry:       1468491992
    Uid:          sample@gmail.com

##### Response body:

    {
      "status": "success",
      "data": {
        "id": 22,
        "provider": "email",
        "uid": "sample@gmail.com",
        "email": "sample@gmail.com",
        "created_at": "2016-06-30T10:26:32.336Z",
        "updated_at": "2016-06-30T10:26:32.398Z",
        "ulab_user_id": "1234",
        "ulab_access_token": "4321"
      }
    }

#### Example: /api/v1/auth sign_up: ulab error

##### Request headers:

    Content-Type: application/x-www-form-urlencoded

##### Request params:

    {
      "email": "sample@gmail.com",
      "password": "secret",
      "password_confirmation": "secret",
      "confirm_success_url": "sample_url"
    }

##### Response headers:

    Status:       422
    Content-Type: application/json

##### Response body:

    {
      "status": "error",
      "data": "ULAB registration error"
    }

#### Example: /api/v1/auth sign_up: devise error

##### Request headers:

    Content-Type: application/x-www-form-urlencoded

##### Request params:

    {
      "email": "sample@gmail.com",
      "password": "secret123",
      "password_confirmation": "aaaa",
      "confirm_success_url": "sample_url"
    }

##### Response headers:

    Status:       422
    Content-Type: application/json

##### Response body:

    {
      "status": "error",
      "data": {
        "id": null,
        "provider": "email",
        "uid": "",
        "email": "sample@gmail.com",
        "created_at": null,
        "updated_at": null,
        "ulab_user_id": null,
        "ulab_access_token": null
      },
      "errors": {
        "password_confirmation": [
          "doesn't match Password"
        ],
        "full_messages": [
          "Password confirmation doesn't match Password"
        ]
      }
    }

# Resource: Searched Phrases

## Action: List all Searched Phrases

### Description:

#### Signature:

**GET** `/api/v1/searched_phrases`

#### Parameters:

Name | Type | Description
-----|------|---------|------------
 search | *string* `Example: phrase` | 

### Examples:

#### Example: /api/v1/searched_phrases?search=phrase

##### Request headers:

    Content-Type: application/x-www-form-urlencoded

##### Request params:

    {
      "search": "phrase"
    }

##### Response headers:

    Status:       200
    Content-Type: application/json

##### Response body:

    [
      {
        "phrase": "most popular phrase"
      },
      {
        "phrase": "less popular phrase"
      }
    ]

# Resource: Sessions

## Action: Remove an existing Session

### Description:

#### Signature:

**DELETE** `/api/v1/auth/sign_out`

#### Parameters:

Name | Type | Description
-----|------|---------|------------

### Examples:

#### Example: /api/v1/auth/sign_out error

##### Request headers:

    Content-Type: application/x-www-form-urlencoded

##### Response headers:

    Status:       404
    Content-Type: application/json

##### Response body:

    {
      "errors": [
        "User was not found or was not logged in."
      ]
    }

#### Example: /api/v1/auth/sign_out success

##### Request headers:

    Content-Type: application/x-www-form-urlencoded
    Access-Token: Opn9q-8OTmlv_oglr0kbyg
    Client:       lJ44zZTtRs1CZ7XmBTYKGw
    Expiry:       1468491995
    Uid:          abagail@buckridgeharber.io

##### Response headers:

    Status:       200
    Content-Type: application/json

##### Response body:

    {
      "success": true
    }

## Action: Create a Session

### Description:

#### Signature:

**POST** `/api/v1/auth/sign_in`

#### Parameters:

Name | Type | Description
-----|------|---------|------------
 email | *string* `Example: sample@gmail.com` | 
 password | *string* `Example: secret` | 

### Examples:

#### Example: /api/v1/auth/sign_in success

##### Request headers:

    Content-Type: application/x-www-form-urlencoded

##### Request params:

    {
      "email": "mohammad@herzog.info",
      "password": "password"
    }

##### Response headers:

    Status:       200
    Content-Type: application/json
    Access-token: HhVn807kAYSTMzf_ClKvgw
    Client:       PC7QS6erJ0Tyjvp4JWZiPA
    Expiry:       1468491995
    Uid:          mohammad@herzog.info

##### Response body:

    {
      "data": {
        "id": 28,
        "provider": "email",
        "uid": "mohammad@herzog.info",
        "email": "mohammad@herzog.info",
        "ulab_user_id": "1234",
        "ulab_access_token": "4321",
        "name": "name",
        "surname": "surname",
        "picture": "/assets/fallback/default_picture-5b9ea71fca84bac245fb046d833b7fc0ffe73432a71c950813658a699696f0a3.png",
        "addresses": [
          {
            "id": 8,
            "user_id": 28,
            "label": "home",
            "city": "City",
            "street": "Street 12",
            "zip_code": "15-241",
            "country": "Poland",
            "primary": ""
          }
        ]
      }
    }

#### Example: /api/v1/auth sign_up: success

##### Request headers:

    Content-Type: application/x-www-form-urlencoded

##### Request params:

    {
      "email": "sample@gmail.com",
      "password": "secret"
    }

##### Response headers:

    Status:       200
    Content-Type: application/json
    Access-token: RJHjkLXadI-TLwtq3M5kIA
    Client:       _SNWny4mybBLh_8-eJnxXw
    Expiry:       1468491993
    Uid:          sample@gmail.com

##### Response body:

    {
      "data": {
        "id": 22,
        "provider": "email",
        "uid": "sample@gmail.com",
        "email": "sample@gmail.com",
        "ulab_user_id": "1234",
        "ulab_access_token": "4321",
        "addresses": [
    
        ]
      }
    }

#### Example: /api/v1/auth/sign_in error

##### Request headers:

    Content-Type: application/x-www-form-urlencoded

##### Request params:

    {
      "email": "dante.nitzsche@wittinghomenick.biz",
      "password": "wrong_password"
    }

##### Response headers:

    Status:       401
    Content-Type: application/json

##### Response body:

    {
      "errors": [
        "Invalid login credentials. Please try again."
      ]
    }

## Action: New a Session

### Description:

#### Signature:

**GET** `/api/v1/auth/sign_in`

#### Parameters:

Name | Type | Description
-----|------|---------|------------

### Examples:

#### Example: /api/v1/auth/facebook?auth_origin_url=return_url error

##### Request headers:

    Content-Type: application/x-www-form-urlencoded

##### Response headers:

    Status:       405
    Content-Type: application/json

##### Response body:

    {
      "errors": [
        "Use POST /sign_in to sign in. GET is not supported."
      ]
    }

## Action: Exist a Session

### Description:

#### Signature:

**GET** `/api/v1/users/exist`

#### Parameters:

Name | Type | Description
-----|------|---------|------------
 email | *string* `Example: christa@olsonweber.co` | 

### Examples:

#### Example: /api/v1/users/exist error

##### Request headers:

    Content-Type: application/x-www-form-urlencoded

##### Request params:

    {
      "email": "aaa@o2.pl"
    }

##### Response headers:

    Status:       404
    Content-Type: application/json

##### Response body:

    {
      "errors": false
    }

#### Example: /api/v1/users/exist success

##### Request headers:

    Content-Type: application/x-www-form-urlencoded

##### Request params:

    {
      "email": "christa@olsonweber.co"
    }

##### Response headers:

    Status:       200
    Content-Type: application/json

##### Response body:

    {
      "success": true
    }

# Resource: Snapped Photos

## Action: Create a Snapped Photo

### Description:

#### Signature:

**POST** `/api/v1/snapped_photos`

#### Parameters:

Name | Type | Description
-----|------|---------|------------
 image | *string* `Example: iVBORw0KGgoAAAANSUhEUgAAACgAAAAoCAMAAAC7IEhfAAAAG1BMVEX////7+/vz8/P8/Pzp6en39/cGBgbv7+/w8PDhD7smAAAARUlEQVQ4je2OMQ4AIAgDi4L6/xdb/QDddOCSdroUgKL4GDMGaIIa69oZZ8ogiJgIY6Vwqw9HSGZTnqThHNVOswSzKN6xARRmAFV8o5BtAAAAAElFTkSuQmCC
` | 

### Examples:

#### Example: /api/v1/snapped_photos/

##### Request headers:

    Content-Type: application/x-www-form-urlencoded
    Access-Token: dtfFBnNK-qrUuqIQ17XccA
    Client:       d3T3tLfonzFK0yWJx9IdHQ
    Expiry:       1468491998
    Uid:          omer@reynolds.name

##### Request params:

    {
      "image": "iVBORw0KGgoAAAANSUhEUgAAACgAAAAoCAMAAAC7IEhfAAAAG1BMVEX////7+/vz8/P8/Pzp6en39/cGBgbv7+/w8PDhD7smAAAARUlEQVQ4je2OMQ4AIAgDi4L6/xdb/QDddOCSdroUgKL4GDMGaIIa69oZZ8ogiJgIY6Vwqw9HSGZTnqThHNVOswSzKN6xARRmAFV8o5BtAAAAAElFTkSuQmCC\n"
    }

##### Response headers:

    Status:       200
    Content-Type: text/plain
    Access-token: dtfFBnNK-qrUuqIQ17XccA
    Client:       d3T3tLfonzFK0yWJx9IdHQ
    Expiry:       1468491998
    Uid:          omer@reynolds.name

##### Response body:



## Action: List all Snapped Photos

### Description:

#### Signature:

**GET** `/api/v1/snapped_photos`

#### Parameters:

Name | Type | Description
-----|------|---------|------------

### Examples:

#### Example: Guest user /api/v1/snapped_photos/

##### Request headers:

    Content-Type: application/x-www-form-urlencoded

##### Response headers:

    Status:       401
    Content-Type: application/json

##### Response body:

    {
      "errors": [
        "Authorized users only."
      ]
    }

#### Example: /api/v1/snapped_photos/

##### Request headers:

    Content-Type: application/x-www-form-urlencoded
    Access-Token: BbzS0KFDrDume7FhKTh4lw
    Client:       fePSXGUVf_o2HXqe9SQRow
    Expiry:       1468491998
    Uid:          imani_schoen@bauch.name

##### Response headers:

    Status:       200
    Content-Type: application/json
    Access-token: BbzS0KFDrDume7FhKTh4lw
    Client:       fePSXGUVf_o2HXqe9SQRow
    Expiry:       1468491998
    Uid:          imani_schoen@bauch.name

##### Response body:

    [
      {
        "id": 1,
        "image": "/home/mariusz/working/hotspotting/spec/support/uploads/snapped_photo/image/1/my_picture_yu6af5zqny.png"
      },
      {
        "id": 2,
        "image": "/home/mariusz/working/hotspotting/spec/support/uploads/snapped_photo/image/2/my_picture_rz4en5pjue.png"
      }
    ]

# Resource: Snapped Products

## Action: List all Snapped Products

### Description:

#### Signature:

**GET** `/api/v1/snapped_products`

#### Parameters:

Name | Type | Description
-----|------|---------|------------
 access-token | *string* `Example: 3gfjd1a_VTckmby56HSy6Q` | 
 auth_token | *string* `Example: 3gfjd1a_VTckmby56HSy6Q` | 
 blank | *string* `Example: true` | 
 client | *string* `Example: H8h6jg83ndnUSAteWwtJog` | 
 client_id | *string* `Example: H8h6jg83ndnUSAteWwtJog` | 
 config | *string* | 
 expiry | *integer* `Example: 1468491998` | 
 oauth_registration | *string* `Example: true` | 
 uid | *string* `Example: 123456789zxcasdqwe` | 

### Examples:

#### Example: Guest user /api/v1/snapped_products/

##### Request headers:

    Content-Type: application/x-www-form-urlencoded

##### Response headers:

    Status:       401
    Content-Type: application/json

##### Response body:

    {
      "errors": [
        "Authorized users only."
      ]
    }

#### Example: /api/v1/snapped_products/

##### Request headers:

    Content-Type: application/x-www-form-urlencoded
    Access-Token: 17bsyy8i1TAjn-BdCT7FcA
    Client:       uZwo6t-aw9N6WCdLPYjOPQ
    Expiry:       1468491999
    Uid:          tremaine@pouros.org

##### Response headers:

    Status:       200
    Content-Type: application/json
    Access-token: 17bsyy8i1TAjn-BdCT7FcA
    Client:       uZwo6t-aw9N6WCdLPYjOPQ
    Expiry:       1468491999
    Uid:          tremaine@pouros.org

##### Response body:

    [
      {
        "id": 54,
        "name": "Product",
        "brand": "Takodana",
        "description": "You do have your moments. Not many, but you have them.",
        "vendor_url": "",
        "vendor": "",
        "image": "",
        "small_image": "",
        "medium_image": "",
        "price_min": 0.0,
        "price_max": 0.0,
        "currency": "USD",
        "asin": "",
        "available": 0
      },
      {
        "id": 55,
        "name": "Product2",
        "brand": "Kashyyyk",
        "description": "I find your lack of faith disturbing.",
        "vendor_url": "",
        "vendor": "",
        "image": "",
        "small_image": "",
        "medium_image": "",
        "price_min": 0.0,
        "price_max": 0.0,
        "currency": "USD",
        "asin": "",
        "available": 0
      }
    ]

#### Example: /api/v1/auth/facebook?auth_origin_url=return_url success

##### Request headers:

    Content-Type: application/x-www-form-urlencoded

##### Request params:

    {
      "access-token": "3gfjd1a_VTckmby56HSy6Q",
      "auth_token": "3gfjd1a_VTckmby56HSy6Q",
      "blank": "true",
      "client": "H8h6jg83ndnUSAteWwtJog",
      "client_id": "H8h6jg83ndnUSAteWwtJog",
      "config": "",
      "expiry": "1468491998",
      "oauth_registration": "true",
      "uid": "123456789zxcasdqwe"
    }

##### Response headers:

    Status:       200
    Content-Type: application/json
    Access-token: 3gfjd1a_VTckmby56HSy6Q
    Client:       H8h6jg83ndnUSAteWwtJog
    Expiry:       1468491998
    Uid:          123456789zxcasdqwe

##### Response body:

    [
    
    ]

## Action: Capture a Snapped Product

### Description:

#### Signature:

**POST** `/api/v1/snapped_products/capture`

#### Parameters:

Name | Type | Description
-----|------|---------|------------
 image | *string* `Example: iVBORw0KGgoAAAANSUhEUgAAACgAAAAoCAMAAAC7IEhfAAAAG1BMVEX////7+/vz8/P8/Pzp6en39/cGBgbv7+/w8PDhD7smAAAARUlEQVQ4je2OMQ4AIAgDi4L6/xdb/QDddOCSdroUgKL4GDMGaIIa69oZZ8ogiJgIY6Vwqw9HSGZTnqThHNVOswSzKN6xARRmAFV8o5BtAAAAAElFTkSuQmCC
` | 
 image_parameters | *nested* | 
[] height | *integer* `Example: 703` | 
[] width | *integer* `Example: 391` | 
[] x | *integer* `Example: 160` | 
[] y | *integer* `Example: 0` | 
 do_not_save | *string* `Example: true` | 

### Examples:

#### Example: Capture products from photo guest user /api/v1/snapped_products/capture

##### Request headers:

    Content-Type: application/x-www-form-urlencoded

##### Request params:

    {
      "image": "iVBORw0KGgoAAAANSUhEUgAAACgAAAAoCAMAAAC7IEhfAAAAG1BMVEX////7+/vz8/P8/Pzp6en39/cGBgbv7+/w8PDhD7smAAAARUlEQVQ4je2OMQ4AIAgDi4L6/xdb/QDddOCSdroUgKL4GDMGaIIa69oZZ8ogiJgIY6Vwqw9HSGZTnqThHNVOswSzKN6xARRmAFV8o5BtAAAAAElFTkSuQmCC\n",
      "image_parameters": {
        "height": "703",
        "width": "391",
        "x": "160",
        "y": "0"
      }
    }

##### Response headers:

    Status:       200
    Content-Type: application/json

##### Response body:

    {
      "message": "message",
      "man": [
        {
          "id": 1,
          "name": "Product 1",
          "brand": "Dagobah",
          "description": "Shut him up or shut him down.",
          "vendor_url": "",
          "vendor": "",
          "image": "",
          "small_image": "",
          "medium_image": "",
          "price_min": 0.0,
          "price_max": 0.0,
          "currency": "USD",
          "asin": "",
          "available": 0
        },
        {
          "id": 2,
          "name": "Product 2",
          "brand": "Yavin",
          "description": "Do. Or do not. There is no try.",
          "vendor_url": "",
          "vendor": "",
          "image": "",
          "small_image": "",
          "medium_image": "",
          "price_min": 0.0,
          "price_max": 0.0,
          "currency": "USD",
          "asin": "",
          "available": 0
        }
      ],
      "woman": [
        {
          "id": 3,
          "name": "Product 3",
          "brand": "Naboo",
          "description": "I have a bad feeling about this.",
          "vendor_url": "",
          "vendor": "",
          "image": "",
          "small_image": "",
          "medium_image": "",
          "price_min": 0.0,
          "price_max": 0.0,
          "currency": "USD",
          "asin": "",
          "available": 0
        }
      ]
    }

#### Example: Capture products from photo wrong parameters /api/v1/snapped_products/capture

##### Request headers:

    Content-Type: application/x-www-form-urlencoded
    Access-Token: tCwNEsSgphMmYDhP3xhhGw
    Client:       M-qk6XKtqCRmD8At-t9LFw
    Expiry:       1468492001
    Uid:          kaleigh.goldner@rolfson.name

##### Request params:

    {
      "image": "",
      "image_parameters": {
        "width": "-10",
        "x": "160",
        "y": "abc"
      }
    }

##### Response headers:

    Status:       200
    Content-Type: application/json
    Access-token: tCwNEsSgphMmYDhP3xhhGw
    Client:       M-qk6XKtqCRmD8At-t9LFw
    Expiry:       1468492001
    Uid:          kaleigh.goldner@rolfson.name

##### Response body:

    {
      "message": "Wrong request not enough params: a28e7de45852a678675b9b9777c52f714ad70b68,1461335440,6bafa34d5b7307ef294046438c34f7,object_recognition,0,0,0,0,0,0",
      "man": [
    
      ],
      "woman": [
    
      ]
    }

#### Example: Capture products from photo no response /api/v1/snapped_products/capture

##### Request headers:

    Content-Type: application/x-www-form-urlencoded

##### Request params:

    {
      "image": "iVBORw0KGgoAAAANSUhEUgAAACgAAAAoCAMAAAC7IEhfAAAAG1BMVEX////7+/vz8/P8/Pzp6en39/cGBgbv7+/w8PDhD7smAAAARUlEQVQ4je2OMQ4AIAgDi4L6/xdb/QDddOCSdroUgKL4GDMGaIIa69oZZ8ogiJgIY6Vwqw9HSGZTnqThHNVOswSzKN6xARRmAFV8o5BtAAAAAElFTkSuQmCC\n",
      "image_parameters": {
        "height": "703",
        "width": "391",
        "x": "160",
        "y": "0"
      }
    }

##### Response headers:

    Status:       200
    Content-Type: application/json

##### Response body:

    {
      "message": "",
      "man": [
    
      ],
      "woman": [
    
      ]
    }

#### Example: Capture products from photo photo not to be saved /api/v1/snapped_products/capture

##### Request headers:

    Content-Type: application/x-www-form-urlencoded
    Access-Token: qJHkHMg0GZZ45YlGPp8kDg
    Client:       qFMautmr0VMsATdtJMqegg
    Expiry:       1468492000
    Uid:          ashtyn_koelpin@schustergraham.co

##### Request params:

    {
      "image": "iVBORw0KGgoAAAANSUhEUgAAACgAAAAoCAMAAAC7IEhfAAAAG1BMVEX////7+/vz8/P8/Pzp6en39/cGBgbv7+/w8PDhD7smAAAARUlEQVQ4je2OMQ4AIAgDi4L6/xdb/QDddOCSdroUgKL4GDMGaIIa69oZZ8ogiJgIY6Vwqw9HSGZTnqThHNVOswSzKN6xARRmAFV8o5BtAAAAAElFTkSuQmCC\n",
      "do_not_save": "true",
      "image_parameters": {
        "height": "703",
        "width": "391",
        "x": "160",
        "y": "0"
      }
    }

##### Response headers:

    Status:       200
    Content-Type: application/json
    Access-token: qJHkHMg0GZZ45YlGPp8kDg
    Client:       qFMautmr0VMsATdtJMqegg
    Expiry:       1468492000
    Uid:          ashtyn_koelpin@schustergraham.co

##### Response body:

    {
      "message": "message",
      "man": [
        {
          "id": 1,
          "name": "Product 1",
          "brand": "Geonosis",
          "description": "Truly wonderful, the mind of a child is.",
          "vendor_url": "",
          "vendor": "",
          "image": "",
          "small_image": "",
          "medium_image": "",
          "price_min": 0.0,
          "price_max": 0.0,
          "currency": "USD",
          "asin": "",
          "available": 0
        },
        {
          "id": 2,
          "name": "Product 2",
          "brand": "Bespin",
          "description": "Shut him up or shut him down.",
          "vendor_url": "",
          "vendor": "",
          "image": "",
          "small_image": "",
          "medium_image": "",
          "price_min": 0.0,
          "price_max": 0.0,
          "currency": "USD",
          "asin": "",
          "available": 0
        }
      ],
      "woman": [
        {
          "id": 3,
          "name": "Product 3",
          "brand": "Hosnian Prime",
          "description": "Shut him up or shut him down.",
          "vendor_url": "",
          "vendor": "",
          "image": "",
          "small_image": "",
          "medium_image": "",
          "price_min": 0.0,
          "price_max": 0.0,
          "currency": "USD",
          "asin": "",
          "available": 0
        }
      ]
    }

#### Example: Capture products from photo /api/v1/snapped_products/capture

##### Request headers:

    Content-Type: application/x-www-form-urlencoded
    Access-Token: 55UT3z-_jlMvWvBJY2LkCg
    Client:       FPaA-jFlv1qN2qpniERCNA
    Expiry:       1468491999
    Uid:          demetrius@greenfelderabbott.io

##### Request params:

    {
      "image": "iVBORw0KGgoAAAANSUhEUgAAACgAAAAoCAMAAAC7IEhfAAAAG1BMVEX////7+/vz8/P8/Pzp6en39/cGBgbv7+/w8PDhD7smAAAARUlEQVQ4je2OMQ4AIAgDi4L6/xdb/QDddOCSdroUgKL4GDMGaIIa69oZZ8ogiJgIY6Vwqw9HSGZTnqThHNVOswSzKN6xARRmAFV8o5BtAAAAAElFTkSuQmCC\n",
      "image_parameters": {
        "height": "703",
        "width": "391",
        "x": "160",
        "y": "0"
      }
    }

##### Response headers:

    Status:       200
    Content-Type: application/json
    Access-token: 55UT3z-_jlMvWvBJY2LkCg
    Client:       FPaA-jFlv1qN2qpniERCNA
    Expiry:       1468491999
    Uid:          demetrius@greenfelderabbott.io

##### Response body:

    {
      "message": "message",
      "man": [
        {
          "id": 1,
          "name": "Product 1",
          "brand": "Utapau",
          "description": "Adventure. Excitement. A Jedi craves not these things.",
          "vendor_url": "",
          "vendor": "",
          "image": "",
          "small_image": "",
          "medium_image": "",
          "price_min": 0.0,
          "price_max": 0.0,
          "currency": "USD",
          "asin": "",
          "available": 0
        },
        {
          "id": 2,
          "name": "Product 2",
          "brand": "Tatooine",
          "description": "Would somebody get this big walking carpet out of my way?",
          "vendor_url": "",
          "vendor": "",
          "image": "",
          "small_image": "",
          "medium_image": "",
          "price_min": 0.0,
          "price_max": 0.0,
          "currency": "USD",
          "asin": "",
          "available": 0
        }
      ],
      "woman": [
        {
          "id": 3,
          "name": "Product 3",
          "brand": "Takodana",
          "description": "Would somebody get this big walking carpet out of my way?",
          "vendor_url": "",
          "vendor": "",
          "image": "",
          "small_image": "",
          "medium_image": "",
          "price_min": 0.0,
          "price_max": 0.0,
          "currency": "USD",
          "asin": "",
          "available": 0
        }
      ]
    }

# Resource: Tv Shows

## Action: List all Tv Shows

### Description:

#### Signature:

**GET** `/api/v1/tv_shows`

#### Parameters:

Name | Type | Description
-----|------|---------|------------
 page | *integer* `Example: 2` | 
 per | *integer* `Example: 2` | 
 channel_id | *integer* `Example: 555` | 

### Examples:

#### Example: /api/v1/tv_shows?page=2&per=2

##### Request headers:

    Content-Type: application/x-www-form-urlencoded

##### Request params:

    {
      "page": "2",
      "per": "2"
    }

##### Response headers:

    Status:       200
    Content-Type: application/json

##### Response body:

    [
      {
        "id": 10,
        "name": "Second Page Show",
        "description": "Schlitz meggings cardigan blue bottle raw denim church-key blog five dollar toast. Shoreditch retro ethical leggings. Ugh biodiesel pabst fingerstache. Microdosing 90's occupy locavore vice narwhal ennui williamsburg.",
        "episodes_count": 0,
        "seasons_count": 0,
        "thumbnail_url": "",
        "channel": {
        }
      }
    ]

#### Example: /api/v1/tv_shows

##### Request headers:

    Content-Type: application/x-www-form-urlencoded

##### Response headers:

    Status:       200
    Content-Type: application/json

##### Response body:

    [
      {
        "id": 4,
        "name": "Title",
        "description": "Portland cornhole dreamcatcher single-origin coffee drinking master. Hashtag banh mi kinfolk wes anderson. Post-ironic actually +1 put a bird on it. Franzen fashion axe mumblecore. Distillery scenester tattooed normcore art party squid health.",
        "episodes_count": 0,
        "seasons_count": 0,
        "thumbnail_url": "",
        "channel": {
        }
      },
      {
        "id": 5,
        "name": "Title2",
        "description": "Hoodie plaid fashion axe sustainable pork belly hammock wolf roof. Kombucha messenger bag waistcoat literally cray salvia actually. Microdosing chicharrones lo-fi banh mi vegan everyday. Before they sold out lumbersexual mixtape fingerstache.",
        "episodes_count": 0,
        "seasons_count": 0,
        "thumbnail_url": "",
        "channel": {
        }
      }
    ]

#### Example: /api/v1/tv_shows?channel_id=555

##### Request headers:

    Content-Type: application/x-www-form-urlencoded

##### Request params:

    {
      "channel_id": "555"
    }

##### Response headers:

    Status:       200
    Content-Type: application/json

##### Response body:

    [
      {
        "id": 6,
        "name": "Selected Channel Show",
        "description": "Leggings five dollar toast 90's cold-pressed chia hella. Biodiesel next level sartorial keytar food truck try-hard iphone. Art party taxidermy godard fanny pack iphone goth bespoke. Craft beer etsy bespoke wes anderson williamsburg gastropub.",
        "episodes_count": 0,
        "seasons_count": 0,
        "thumbnail_url": "",
        "channel": {
          "id": 555,
          "name": "MTV",
          "thumbnail_url": "/uploads/channel_picture/32/16/32/custom_my_picture.png"
        }
      }
    ]

## Action: Retrieve single Tv Show

### Description:

#### Signature:

**GET** `/api/v1/tv_shows/{id}`

#### Parameters:

Name | Type | Description
-----|------|---------|------------
 id | *integer* `Example: 11` | 

### Examples:

#### Example: /api/v1/tv_shows/:id

##### Request headers:

    Content-Type: application/x-www-form-urlencoded

##### Request params:

    {
      "id": "11"
    }

##### Response headers:

    Status:       200
    Content-Type: application/json

##### Response body:

    {
      "id": 11,
      "name": "Selected Show",
      "description": "Cliche forage church-key skateboard green juice bicycle rights. Post-ironic salvia viral. Ramps hella migas vhs authentic beard polaroid. Actually thundercats retro. Taxidermy cred semiotics.",
      "episodes_count": 2,
      "seasons_count": 1,
      "thumbnail_url": "",
      "channel": {
      },
      "seasons": [
        {
          "season_id": 4,
          "season_number": 4,
          "season_episodes_count": 2,
          "episodes": [
            {
              "episode_id": 7,
              "episode_number": 7,
              "episode_title": "A Swiftly Tilting Planet",
              "episode_cover_image": "",
              "episode_file_url": "",
              "episode_file_specification": {
              }
            },
            {
              "episode_id": 8,
              "episode_number": 8,
              "episode_title": "Many Waters",
              "episode_cover_image": "",
              "episode_file_url": "",
              "episode_file_specification": {
              }
            }
          ]
        }
      ]
    }

# Resource: User Profiles

## Action: Update an existing User Profile

### Description:

#### Signature:

**PUT** `/api/v1/user_profile/update`

#### Parameters:

Name | Type | Description
-----|------|---------|------------
 name | *string* `Example: sample` | 
 surname | *string* `Example: surname` | 
 picture | *file* `Example: my_picture.png` | 
 id | *string* `Example: update` | 

### Examples:

#### Example: /api/v1/user_profile/update update user profile: delete profile picture

##### Request headers:

    Content-Type: application/x-www-form-urlencoded
    Access-Token: teHMcUmWhJzdKOqWkHHKGw
    Client:       eXp1LErboUWXtxg0xalx3g
    Expiry:       1468491991
    Uid:          roberto@crona.co

##### Request params:

    {
      "name": "Noah Fadel",
      "surname": "Peggie Simonis",
      "picture": "",
      "id": "update"
    }

##### Response headers:

    Status:       200
    Content-Type: application/json
    Access-token: teHMcUmWhJzdKOqWkHHKGw
    Client:       eXp1LErboUWXtxg0xalx3g
    Expiry:       1468491991
    Uid:          roberto@crona.co

##### Response body:

    {
      "status": "success",
      "data": {
        "id": 20,
        "provider": "email",
        "uid": "roberto@crona.co",
        "email": "roberto@crona.co",
        "created_at": "2016-06-30T10:26:29.495Z",
        "updated_at": "2016-06-30T10:26:31.033Z",
        "ulab_user_id": null,
        "ulab_access_token": null,
        "name": "Noah Fadel",
        "surname": "Peggie Simonis",
        "picture": "/home/mariusz/working/hotspotting/spec/support/uploads/profile/picture/3/deseruntsuntest.png"
      }
    }

#### Example: /api/v1/user_profile/update update user name and surname: success

##### Request headers:

    Content-Type: application/x-www-form-urlencoded
    Access-Token: w3DPxQPj3ZydEn4fkJFwrA
    Client:       rTj6hZBlZKk2GKrRhwZA_w
    Expiry:       1468491989
    Uid:          adrien.kertzmann@moenconn.net

##### Request params:

    {
      "name": "sample",
      "surname": "surname",
      "id": "update"
    }

##### Response headers:

    Status:       200
    Content-Type: application/json
    Access-token: w3DPxQPj3ZydEn4fkJFwrA
    Client:       rTj6hZBlZKk2GKrRhwZA_w
    Expiry:       1468491989
    Uid:          adrien.kertzmann@moenconn.net

##### Response body:

    {
      "status": "success",
      "data": {
        "id": 19,
        "provider": "email",
        "uid": "adrien.kertzmann@moenconn.net",
        "email": "adrien.kertzmann@moenconn.net",
        "created_at": "2016-06-30T10:26:28.316Z",
        "updated_at": "2016-06-30T10:26:29.409Z",
        "ulab_user_id": null,
        "ulab_access_token": null,
        "name": "sample",
        "surname": "surname",
        "picture": "/home/mariusz/working/hotspotting/spec/support/uploads/profile/picture/2/adestculpa.png"
      }
    }

#### Example: /api/v1/user_profile/update update user profile: error

##### Request headers:

    Content-Type: application/x-www-form-urlencoded
    Access-Token: wc0oBwMZuKxBaWwXlw6YfQ
    Client:       45RDmnLtbLHn1sxlCZG6rQ
    Expiry:       1468491992
    Uid:          keshawn@cronin.org

##### Request params:

    {
      "name": "",
      "surname": "",
      "picture": "",
      "id": "update"
    }

##### Response headers:

    Status:       422
    Content-Type: application/json
    Access-token: wc0oBwMZuKxBaWwXlw6YfQ
    Client:       45RDmnLtbLHn1sxlCZG6rQ
    Expiry:       1468491992
    Uid:          keshawn@cronin.org

##### Response body:

    {
      "status": "error",
      "errors": {
        "name": [
          "can't be blank"
        ],
        "surname": [
          "can't be blank"
        ],
        "full_messages": [
          "Name can't be blank",
          "Surname can't be blank"
        ]
      }
    }

#### Example: /api/v1/user_profile/update update user profile: success

##### Request headers:

    Content-Type: multipart/form-data
    Access-Token: kKrd-dbKFIWMXkwhT-m-XQ
    Client:       J7F0-c54lL5srMh4h4iu1A
    Expiry:       1468491988
    Uid:          dean_fadel@bosco.org

##### Request params:

    {
      "name": "sample",
      "surname": "surname",
      "picture": "#<ActionDispatch::Http::UploadedFile:0x00000000ace1f8>",
      "id": "update"
    }

##### Response headers:

    Status:       200
    Content-Type: application/json
    Access-token: kKrd-dbKFIWMXkwhT-m-XQ
    Client:       J7F0-c54lL5srMh4h4iu1A
    Expiry:       1468491988
    Uid:          dean_fadel@bosco.org

##### Response body:

    {
      "status": "success",
      "data": {
        "id": 18,
        "provider": "email",
        "uid": "dean_fadel@bosco.org",
        "email": "dean_fadel@bosco.org",
        "created_at": "2016-06-30T10:26:28.141Z",
        "updated_at": "2016-06-30T10:26:28.204Z",
        "ulab_user_id": null,
        "ulab_access_token": null,
        "name": "sample",
        "surname": "surname",
        "picture": "/home/mariusz/working/hotspotting/spec/support/uploads/profile/picture/1/my_picture.png"
      }
    }

# Resource: Wishlists

## Action: Toggle a Wishlist

### Description:

#### Signature:

**POST** `/api/v1/wishlists/toggle`

#### Parameters:

Name | Type | Description
-----|------|---------|------------
 product_id | *integer* `Example: 69` | 
 products_id | *integer* `Example: 5` | 

### Examples:

#### Example: /wishlists/toggle wish product

##### Request headers:

    Content-Type: application/x-www-form-urlencoded
    Access-Token: 094_DE9jMO7u_6hPxMnmag
    Client:       uyQU239hnv1WBTa-V-6RXQ
    Expiry:       1468492003
    Uid:          furman_corkery@thompson.biz

##### Request params:

    {
      "product_id": "66"
    }

##### Response headers:

    Status:       200
    Content-Type: application/json
    Access-token: 094_DE9jMO7u_6hPxMnmag
    Client:       uyQU239hnv1WBTa-V-6RXQ
    Expiry:       1468492003
    Uid:          furman_corkery@thompson.biz

##### Response body:

    {
      "is_on_wishlist": true,
      "user_wishlist_count": 2
    }

#### Example: /wishlists/toggle unwish product

##### Request headers:

    Content-Type: application/x-www-form-urlencoded
    Access-Token: xtACLzABoBX1Gh1epAziYg
    Client:       SuRHOL0M14S33At4hQFxtA
    Expiry:       1468492003
    Uid:          dillan_grimes@bailey.biz

##### Request params:

    {
      "product_id": "69"
    }

##### Response headers:

    Status:       200
    Content-Type: application/json
    Access-token: xtACLzABoBX1Gh1epAziYg
    Client:       SuRHOL0M14S33At4hQFxtA
    Expiry:       1468492003
    Uid:          dillan_grimes@bailey.biz

##### Response body:

    {
      "is_on_wishlist": false,
      "user_wishlist_count": 1
    }

#### Example: /wishlists/toggle invlid product id

##### Request headers:

    Content-Type: application/x-www-form-urlencoded
    Access-Token: lgtvka5jWkeDw8l-7S61Kw
    Client:       gP5tjMFz5ZPhktQlMB-90Q
    Expiry:       1468492003
    Uid:          annette_labadie@gleichnerconn.biz

##### Request params:

    {
      "products_id": "5"
    }

##### Response headers:

    Status:       400
    Content-Type: application/json
    Access-token: lgtvka5jWkeDw8l-7S61Kw
    Client:       gP5tjMFz5ZPhktQlMB-90Q
    Expiry:       1468492003
    Uid:          annette_labadie@gleichnerconn.biz

##### Response body:

    [
      "Product not found."
    ]

#### Example: /wishlists/toggle wish product error

##### Request headers:

    Content-Type: application/x-www-form-urlencoded

##### Request params:

    {
      "product_id": "68"
    }

##### Response headers:

    Status:       401
    Content-Type: application/json

##### Response body:

    {
      "errors": [
        "Authorized users only."
      ]
    }

## Action: List all Wishlists

### Description:

#### Signature:

**GET** `/api/v1/wishlists`

#### Parameters:

Name | Type | Description
-----|------|---------|------------

### Examples:

#### Example: /wishlists wishlist index

##### Request headers:

    Content-Type: application/x-www-form-urlencoded
    Access-Token: BSeLjuVwpGXJFLf_kkx49g
    Client:       HtwxW0XkJdg9HiVtoVY8Wg
    Expiry:       1468492002
    Uid:          karley@schuster.biz

##### Response headers:

    Status:       200
    Content-Type: application/json
    Access-token: BSeLjuVwpGXJFLf_kkx49g
    Client:       HtwxW0XkJdg9HiVtoVY8Wg
    Expiry:       1468492002
    Uid:          karley@schuster.biz

##### Response body:

    [
      {
        "id": 60,
        "name": "Product",
        "brand": "Sullust",
        "description": "If they follow standard Imperial procedure, they'll dump their garbage before they go to light-speed.",
        "vendor_url": "",
        "vendor": "",
        "image": "",
        "small_image": "",
        "medium_image": "",
        "price_min": 0.0,
        "price_max": 0.0,
        "currency": "USD",
        "asin": "",
        "available": 0
      },
      {
        "id": 61,
        "name": "Product2",
        "brand": "Kashyyyk",
        "description": "A Jedi uses the Force for knowledge and defense, never for attack.",
        "vendor_url": "",
        "vendor": "",
        "image": "",
        "small_image": "",
        "medium_image": "",
        "price_min": 0.0,
        "price_max": 0.0,
        "currency": "USD",
        "asin": "",
        "available": 0
      }
    ]

#### Example: /wishlists wishlist index error

##### Request headers:

    Content-Type: application/x-www-form-urlencoded

##### Response headers:

    Status:       401
    Content-Type: application/json

##### Response body:

    {
      "errors": [
        "Authorized users only."
      ]
    }

