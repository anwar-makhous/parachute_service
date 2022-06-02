class Shops {
  static const List shops = [
    {
      "name": "Restaurants",
      "shops": [
        {
          "id": 0,
          "category_id": 1,
          "name": "McDonald's",
          "rank": 3,
          "rate": 4,
          "details":
              "McDonald's is an American fast food company, founded in 1940 as a restaurant operated by Richard and Maurice McDonald, in San Bernardino, California, United States.",
          "icon": "assets/images/Restaurants/Mc.png",
          "photo": "assets/images/Restaurants/mcdonalds-restaurant.jpg",
          "service_time": "30",
          "address": "Lattakia - 8th of March St.",
          "menu_categories": [],
          "delivery": 1,
          "reservation": 1,
          "open_days": "Sunday, Monday, Tuesday, Wednesday, Thursday, Friday",
          "open_hours": "9:00 AM - 10:00 PM",
        },
        {
          "id": 1,
          "category_id": 1,
          "name": "KFC",
          "rank": 2,
          "rate": 3,
          "details":
              "KFC is an American fast food restaurant chain headquartered in Louisville, Kentucky that specializes in fried chicken.",
          "icon": "assets/images/Restaurants/KFC.png",
          "photo":
              "assets/images/Restaurants/kfc-quick-pick-up-super-tease.jpg",
          "service_time": "15",
          "address": "Lattakia - Mar Taqla",
          "menu_categories": [
            {
              "name": "Snacks",
              "items": [
                {
                  "name": "Burger",
                  "details": "Delicious Burger",
                  "price": 12000,
                  "image": "assets/images/burger.png",
                  "subitems": [
                    {
                      "type": "SingleChoice",
                      "title": "Cheese",
                      "required": 1,
                      "subItems": ["Swiss Cheese", "Gouda", "Vegan cheese"],
                      "prices": [10.0, 15.0, 20.0]
                    },
                    {
                      "type": "MultiChoice",
                      "title": "Drink",
                      "required": 0,
                      "subItems": ["Cola", "Orange Juice", "Strawberry Juice"],
                      "prices": [300.0, 150.0, 200.0]
                    },
                  ]
                },
              ],
            },
          ],
          "delivery": 1,
          "reservation": 0,
          "open_days":
              "Saturday, Sunday, Monday, Tuesday, Wednesday, Thursday, Friday",
          "open_hours": "8:00 AM - 3:00 AM",
        },
      ],
    },
    {
      "name": "Grocery",
      "shops": [],
    },
    {
      "name": "Pharmacies",
      "shops": [],
    },
  ];
}
