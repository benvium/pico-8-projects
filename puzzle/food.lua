food_types={
    [1]={
        n=1,
        name="cheeseburger",
        t=26,
        ingredients={"bread","cheese","meat"},
        condition=function() return customer_count>3 end,
        coins=2,
    },
    [2]={
        n=2,
        name="saladburger",
        t=27,
        ingredients={"bread","cheese","leaf"},
        condition=function() return customer_count>2 end,
        coins=2,
    },
    [3]={
        n=3,
        name="salad",
        t=28,
        ingredients={"meat","leaf","cheese"},
        condition=function() return customer_count>3 end,
        coins=3,
    },
    [4]={
        n=4,
        name="water",
        t=17,
        ingredients={"water"},
        coins=1
    },
    [5]={
        n=5,
        name="fries",
        t=19,
        ingredients={"fries"},
        coins=1
    },
    [6]={
        n=6,
        name="burgerfries",
        t={26,19},
        ingredients={"fries","bread","cheese","meat"},
        coins=3,
        condition=function() return customer_count>5 end
    },
    [7]={
        n=7,
        name="burgerdrink",
        t={17,25},
        ingredients={"water","bread","ketchup","meat"},
        coins=3,
        condition=function() return customer_count>5 end
    },
    [8]={
        n=8,
        name="fries ketchup",
        condition=function() return customer_count>2 end,
        t=24,
        ingredients={"fries","ketchup"},
        coins=3
    },
}