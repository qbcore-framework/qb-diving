Config = Config or {}

Config.UseTarget = GetConvar('UseTarget', 'false') == 'true' -- Use qb-target interactions (don't change this, go to your server.cfg and add `setr UseTarget true` to use this and just that from true to false or the other way around)
Config.CopsChance = 0.5 -- The chance of the cops getting called when a coral gets picked up, this ranges from 0.0 to 1.0

Config.Debug = false

Config.CoralLocations = {
    [1] = {
        label = "This is Location 1",
        coords = {
            Area = vector3(-2838.8, -376.1, 3.55),
            Coral = {
                [1] = {
                    coords = vector3(-2849.25, -377.58, -40.23),
                    length = 3,
                    width = 3,
                    heading = 100.0,
                    PickedUp = false
                },
                [2] = {
                    coords = vector3(-2838.43, -363.63, -39.45),
                    length = 3,
                    width = 3,
                    heading = 100.0,
                    PickedUp = false
                },
                [3] = {
                    coords = vector3(-2887.04, -394.87, -40.91),
                    length = 3,
                    width = 3,
                    heading = 100.0,
                    PickedUp = false
                },
                [4] = {
                    coords = vector3(-2808.99, -385.56, -39.32),
                    length = 3,
                    width = 3,
                    heading = 100.0,
                    PickedUp = false
                },
            }
        },
        DefaultCoral = 4,
        TotalCoral = 4,
    },
    [2] = {
        label = "Location 2",
        coords = {
            Area = vector3(-3288.2, -67.58, 2.79),
            Coral = {
                [1] = {
                    coords = vector3(-3275.03, -38.58, -21.45),
                    length = 3,
                    width = 3,
                    heading = 100.0,
                    PickedUp = false
                },
                [2] = {
                    coords = vector3(-3273.73, -76.0, -26.81),
                    length = 3,
                    width = 3,
                    heading = 100.0,
                    PickedUp = false
                },
                [3] = {
                    coords = vector3(-3346.53, -50.4, -35.84),
                    length = 3,
                    width = 3,
                    heading = 100.0,
                    PickedUp = false
                },
                [4] = {
                    coords = vector3(-3332.6, -97.69, -44.02),
                    length = 3,
                    width = 3,
                    heading = 100.0,
                    PickedUp = false
                },
                [5] = {
                    coords = vector3(-3226.69, -136.03, -33.26),
                    length = 3,
                    width = 3,
                    heading = 100.0,
                    PickedUp = false
                },
            }
        },
        DefaultCoral = 5,
        TotalCoral = 5,
    },
    [3] = {
        label = "Location 3",
        coords = {
            Area = vector3(-3367.24, 1617.89, 1.39),
            Coral = {
                [1] = {
                    coords = vector3(-3388.01, 1635.88, -43.81),
                    length = 3,
                    width = 3,
                    heading = 100.0,
                    PickedUp = false
                },
                [2] = {
                    coords = vector3(-3354.19, 1549.3, -40.75),
                    length = 3,
                    width = 3,
                    heading = 100.0,
                    PickedUp = false
                },
                [3] = {
                    coords = vector3(-3317.68, 1640.51, -38.75),
                    length = 3,
                    width = 3,
                    heading = 100.0,
                    PickedUp = false
                },
                [4] = {
                    coords = vector3(-3395.91, 1582.99, -42.06),
                    length = 3,
                    width = 3,
                    heading = 100.0,
                    PickedUp = false
                },
                [5] = {
                    coords = vector3(-3398.14, 1677.49, -62.34),
                    length = 3,
                    width = 3,
                    heading = 100.0,
                    PickedUp = false
                },
            }
        },
        DefaultCoral = 5,
        TotalCoral = 5,
    },
    [4] = {
        label = "Location 4",
        coords = {
            Area = vector3(3002.5, -1538.28, -27.36),
            Coral = {
                [1] = {
                    coords = vector3(2978.05, -1509.07, -24.96),
                    length = 3,
                    width = 3,
                    heading = 100.0,
                    PickedUp = false
                },
                [2] = {
                    coords = vector3(3004.42, -1576.95, -28.66),
                    length = 3,
                    width = 3,
                    heading = 100.0,
                    PickedUp = false
                },
                [3] = {
                    coords = vector3(2951.65, -1560.69, -28.66),
                    length = 3,
                    width = 3,
                    heading = 100.0,
                    PickedUp = false
                },
                [4] = {
                    coords = vector3(3031.07, -1558.18, -27.84),
                    length = 3,
                    width = 3,
                    heading = 100.0,
                    PickedUp = false
                },
                [5] = {
                    coords = vector3(3026.27, -1466.7, -30.92),
                    length = 3,
                    width = 3,
                    heading = 100.0,
                    PickedUp = false
                },
            }
        },
        DefaultCoral = 5,
        TotalCoral = 5,
    },
    [5] = {
        label = "Location 5",
        coords = {
            Area = vector3(3421.58, 1975.68, 0.86),
            Coral = {
                [1] = {
                    coords = vector3(3421.69, 1976.54, -50.64),
                    length = 3,
                    width = 3,
                    heading = 100.0,
                    PickedUp = false
                },
                [2] = {
                    coords = vector3(3424.07, 1957.46, -53.04),
                    length = 3,
                    width = 3,
                    heading = 100.0,
                    PickedUp = false
                },
                [3] = {
                    coords = vector3(3434.65, 1993.73, -49.84),
                    length = 3,
                    width = 3,
                    heading = 100.0,
                    PickedUp = false
                },
                [4] = {
                    coords = vector3(3415.42, 1965.25, -51.74),
                    length = 3,
                    width = 3,
                    heading = 100.0,
                    PickedUp = false
                },
                [5] = {
                    coords = vector3(3474.93, 1993.49, -49.01),
                    length = 3,
                    width = 3,
                    heading = 100.0,
                    PickedUp = false
                },
                [6] = {
                    coords = vector3(3378.52, 2036.69, -27.88),
                    length = 3,
                    width = 3,
                    heading = 100.0,
                    PickedUp = false
                },
            }
        },
        DefaultCoral = 6,
        TotalCoral = 6,
    },
    [6] = {
        label = "Location 6",
        coords = {
            Area = vector3(2720.14, -2136.28, 0.74),
            Coral = {
                [1] = {
                    coords = vector3(2724.0, -2134.95, -19.33),
                    length = 3,
                    width = 3,
                    heading = 100.0,
                    PickedUp = false
                },
                [2] = {
                    coords = vector3(2710.68, -2156.06, -18.63),
                    length = 3,
                    width = 3,
                    heading = 100.0,
                    PickedUp = false
                },
                [3] = {
                    coords = vector3(2702.84, -2139.29, -18.51),
                    length = 3,
                    width = 3,
                    heading = 100.0,
                    PickedUp = false
                },
                [4] = {
                    coords = vector3(2736.27, -2153.91, -20.08),
                    length = 3,
                    width = 3,
                    heading = 100.0,
                    PickedUp = false
                },
                [5] = {
                    coords = vector3(2796.33, -2099.66, -39.59),
                    length = 3,
                    width = 3,
                    heading = 100.0,
                    PickedUp = false
                },
                [6] = {
                    coords = vector3(2743.65, -2071.83, -26.8),
                    length = 3,
                    width = 3,
                    heading = 100.0,
                    PickedUp = false
                },
            }
        },
        DefaultCoral = 6,
        TotalCoral = 6,
    },
    [7] = {
        label = "Location 7",
        coords = {
            Area = vector3(536.69, 7253.75, 1.69),
            Coral = {
                [1] = {
                    coords = vector3(542.31, 7245.37, -30.01),
                    length = 3,
                    width = 3,
                    heading = 100.0,
                    PickedUp = false
                },
                [2] = {
                    coords = vector3(528.21, 7223.26, -29.51),
                    length = 3,
                    width = 3,
                    heading = 100.0,
                    PickedUp = false
                },
                [3] = {
                    coords = vector3(510.36, 7254.97, -32.11),
                    length = 3,
                    width = 3,
                    heading = 100.0,
                    PickedUp = false
                },
                [4] = {
                    coords = vector3(525.37, 7259.12, -30.51),
                    length = 3,
                    width = 3,
                    heading = 100.0,
                    PickedUp = false
                },
                [5] = {
                    coords = vector3(510.36, 7201.82, -30.26),
                    length = 3,
                    width = 3,
                    heading = 100.0,
                    PickedUp = false
                },
                [6] = {
                    coords = vector3(454.99, 7297.56, -34.88),
                    length = 3,
                    width = 3,
                    heading = 100.0,
                    PickedUp = false
                },
                [7] = {
                    coords = vector3(525.94, 7309.53, -34.2),
                    length = 3,
                    width = 3,
                    heading = 100.0,
                    PickedUp = false
                },
                [8] = {
                    coords = vector3(579.6, 7308.56, -20.58),
                    length = 3,
                    width = 3,
                    heading = 100.0,
                    PickedUp = false
                },
            }
        },
        DefaultCoral = 8,
        TotalCoral = 8,
    },
}

Config.CoralTypes = {
    [1] = {
        item = "dendrogyra_coral",
        maxAmount = math.random(1, 5),
        price = math.random(700, 1000),
    },
    [2] = {
        item = "antipatharia_coral",
        maxAmount = math.random(2, 7),
        price = math.random(500, 850),
    }
}

Config.PriceModifiers = {
    [1] = {
        minAmount = 5,
        maxAmount = 10,
        minPercentage = 50,
        maxPercentage = 55
    },
    [2] = {
        minAmount = 11,
        maxAmount = 15,
        minPercentage = 70,
        maxPercentage = 75
    },
    [3] = {
        minAmount = 16,
        minPercentage = 80,
        maxPercentage = 85
    }
}

Config.SellLocations = {
    [1] = {
        coords = vector4(-1214.66, -1498.14, 4.33, 125.68),
        model = 'a_f_y_beach_01',
        zoneOptions = { -- Only used when not using the target
            length = 3,
            width = 3
        }
    }
}
