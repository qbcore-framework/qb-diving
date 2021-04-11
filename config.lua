QBBoatshop = QBBoatshop or {}
QBDiving = QBDiving or {}

QBBoatshop.PoliceBoat = {
    x = -800.67,
    y = -1494.54,
    z = 1.59,
}

QBBoatshop.PoliceBoatSpawn = {
    x = -793.58,
    y = -1501.4,
    z = 0.12,
    h = 111.5,
}

QBBoatshop.PoliceBoat2 = {
    x = -279.41,
    y = 6635.09,
    z = 7.51,
}

QBBoatshop.PoliceBoatSpawn2 = {
    x = -293.10,
    y = 6642.69,
    z = 0.15,
    h = 65.5,
}

QBBoatshop.Docks = {
    ["lsymc"] = {
        label = "Pier 45",
        coords = {
            take = {
                x = 739.79,
                y = -17.23,
                z = 1.48,
            },
            put = {
                x = 750.50,
                y = -9.45,
                z = 0.10,
                h = 345.90,
            }
        }
    },
    ["paletto"] = {
        label = "Golden Pier",
        coords = {
            take = {
                x = -454.79,
                y = 441.73,
                z = 1.51,
            },
            put = {
                x = -466.23,
                y = 438.15,
                z = 0.01,
                h = 98.95,
            }
        }
    }
    -- ["millars"] = {
        -- label = "Millars Boathouse",
        -- coords = {
            -- take = {
                -- x = 1299.24,
                -- y = 4216.69,
                -- z = 33.9,
            -- },
            -- put = {
                -- x = 1297.82,
                -- y = 4209.61,
                -- z = 30.12,
                -- h = 253.5,
            -- }
        -- }
    -- },
}

QBBoatshop.Depots = {
    [1] = {
        label = "Golden Pier Depot",
        coords = {
            take = {
                x = -437.35,
                y = 447.33,
                z = 1.51,
            },
            put = {
                x = -439.92,
                y = 437.06,
                z = 0.01,
                h = 263.70,
            }
        }
    },
}

QBBoatshop.Locations = {
    ["berths"] = {
        [1] = {
            ["boatModel"] = "seashark",
            ["coords"] = {
                ["boat"] = {
                    ["x"] = -462.82,
                    ["y"] = 419.33,
                    ["z"] = 0.01,
                    ["h"] = 91.75
                },
                ["buy"] = {
                    ["x"] = -455.65,
                    ["y"] = 419.27,
                    ["z"] = 1.51,
                }
            },
            ["inUse"] = false
        },
        [2] = {
            ["boatModel"] = "dinghy",
            ["coords"] = {
                ["boat"] = {
                    ["x"] = -464.13,
                    ["y"] = 403.16,
                    ["z"] = 0.01,
                    ["h"] = 87.28
                },
                ["buy"] = {
                    ["x"] = -455.58,
                    ["y"] = 405.06,
                    ["z"] = 1.51,
                },
            },
            ["inUse"] = false
        },
        [3] = {
            ["boatModel"] = "speeder",
            ["coords"] = {
                ["boat"] = {
                    ["x"] = -446.75,
                    ["y"] = 417.85,
                    ["z"] = 0.01,
                    ["h"] = 268.35
                },
                ["buy"] = {
                    ["x"] = -453.37,
                    ["y"] = 418.89,
                    ["z"] = 1.51,
                },
            },
            ["inUse"] = false
        },
        [4] = {
            ["boatModel"] = "marquis",
            ["coords"] = {
                ["boat"] = {
                    ["x"] = -445.21,
                    ["y"] = 403.71,
                    ["z"] = 0.01,
                    ["h"] = 278.30
                },
                ["buy"] = {
                    ["x"] = -453.03,
                    ["y"] = 401.00,
                    ["z"] = 1.51,
                },
            },
            ["inUse"] = false
        },
        -- [5] = {
        --     ["boatModel"] = "speeder",
        --     ["coords"] = {
        --         ["boat"] = {
        --             ["x"] = -749.59,
        --             ["y"] = -1354.88,
        --             ["z"] = 0.79,
        --             ["h"] = 229.5
        --         },
        --         ["buy"] = {
        --             ["x"] = -746.6,
        --             ["y"] = -1351.36,
        --             ["z"] = 1.59,
        --         },
        --     },
        --     ["inUse"] = false
        -- },
        -- [6] = {
        --     ["boatModel"] = "marquis",
        --     ["coords"] = {
        --         ["boat"] = {
        --             ["x"] = -753.39,
        --             ["y"] = -1362.76,
        --             ["z"] = 0.79,
        --             ["h"] = 229.5
        --         },
        --         ["buy"] = {
        --             ["x"] = -752.49,
        --             ["y"] = -1358.28,
        --             ["z"] = 1.59,
        --         },
        --     },
        --     ["inUse"] = false
        -- },
        -- [7] = {
        --     ["boatModel"] = "dinghy",
        --     ["coords"] = {
        --         ["boat"] = {
        --             ["x"] = -769.06,
        --             ["y"] = -1377.97,
        --             ["z"] = 0.79,
        --             ["h"] = 229.5
        --         },
        --         ["buy"] = {
        --             ["x"] = -723.3,
        --             ["y"] = -1323.61,
        --             ["z"] = 1.59,
        --         }
        --     },
        --     ["inUse"] = false
        -- },
        -- [8] = {
        --     ["boatModel"] = "dinghy",
        --     ["coords"] = {
        --         ["boat"] = {
        --             ["x"] = -774.99,
        --             ["y"] = -1385.0,
        --             ["z"] = 0.79,
        --             ["h"] = 229.5
        --         },
        --         ["buy"] = {
        --             ["x"] = -723.3,
        --             ["y"] = -1323.61,
        --             ["z"] = 1.59,
        --         }
        --     },
        --     ["inUse"] = false
        -- },
        -- [9] = {
        --     ["boatModel"] = "dinghy",
        --     ["coords"] = {
        --         ["boat"] = {
        --             ["x"] = -780.66,
        --             ["y"] = -1391.73,
        --             ["z"] = 0.79,
        --             ["h"] = 229.5
        --         },
        --         ["buy"] = {
        --             ["x"] = -723.3,
        --             ["y"] = -1323.61,
        --             ["z"] = 1.59,
        --         }
        --     },
        --     ["inUse"] = false
        -- },
        -- [10] = {
        --     ["boatModel"] = "dinghy",
        --     ["coords"] = {
        --         ["boat"] = {
        --             ["x"] = -786.47,
        --             ["y"] = -1398.6,
        --             ["z"] = 0.79,
        --             ["h"] = 229.5
        --         },
        --         ["buy"] = {
        --             ["x"] = -723.3,
        --             ["y"] = -1323.61,
        --             ["z"] = 1.59,
        --         }
        --     },
        --     ["inUse"] = false
        -- },
        -- [11] = {
        --     ["boatModel"] = "dinghy",
        --     ["coords"] = {
        --         ["boat"] = {
        --             ["x"] = -792.27,
        --             ["y"] = -1405.48,
        --             ["z"] = 0.79,
        --             ["h"] = 229.5
        --         },
        --         ["buy"] = {
        --             ["x"] = -723.3,
        --             ["y"] = -1323.61,
        --             ["z"] = 1.59,
        --         }
        --     },
        --     ["inUse"] = false
        -- },
        -- [12] = {
        --     ["boatModel"] = "dinghy",
        --     ["coords"] = {
        --         ["boat"] = {
        --             ["x"] = -798.33,
        --             ["y"] = -1412.67,
        --             ["z"] = 0.79,
        --             ["h"] = 229.5
        --         },
        --         ["buy"] = {
        --             ["x"] = -723.3,
        --             ["y"] = -1323.61,
        --             ["z"] = 1.59,
        --         }
        --     },
        --     ["inUse"] = false
        -- },
    }
}

QBBoatshop.ShopBoats = {
    ["dinghy"] = {
        ["model"] = "dinghy",
        ["label"] = "Dinghy",
        ["price"] = 15000
    },
    ["speeder"] = {
        ["model"] = "speeder",
        ["label"] = "Speeder",
        ["price"] = 20000
    },
    ["marquis"] = {
        ["model"] = "marquis",
        ["label"] = "Marquis",
        ["price"] = 30000
    },
    ["seashark"] = {
        ["model"] = "seashark",
        ["label"] = "Seashark",
        ["price"] = 10000
    }
}

QBBoatshop.SpawnVehicle = {
    x = -462.80,
    y = 438.49,
    z = 0.01,
    h = 98.65,
}

QBDiving.Locations = {
    [1] = {
        label = "This is Location 1",
        coords = {
            Area = {
                x = 53.45,
                y = 1538.67,
                z = 3.30
            },
            Coral = {
                [1] = {
                    coords = {
                        x = -2849.25,
                        y = -377.58,
                        z = -40.23
                    },
                    PickedUp = false
                },
                [2] = {
                    coords = {
                        x = -2838.43,
                        y = -363.63,
                        z = -39.45
                    },
                    PickedUp = false
                },
                [3] = {
                    coords = {
                        x = -2887.04,
                        y = -394.87,
                        z = -40.91
                    },
                    PickedUp = false
                },
                [4] = {
                    coords = {
                        x = -2808.99,
                        y = -385.56,
                        z = -39.32
                    },
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
            Area = {
                x = 15.44,
                y = 1309.54,
                z = 4.00,
            },
            Coral = {
                [1] = {
                    coords = {
                        x = -3275.03,
                        y = -38.58,
                        z = -19.21,
                    },
                    PickedUp = false
                },
                [2] = {
                    coords = {
                        x = -3273.73,
                        y = -76.0,
                        z = -26.81,
                    },
                    PickedUp = false
                },
                [3] = {
                    coords = {
                        x = -3346.53,
                        y = -50.4,
                        z = -35.84
                    },
                    PickedUp = false
                },
            }
        },
        DefaultCoral = 3,
        TotalCoral = 3,
    },
}

--ALSO CHANGE VALUES IN SERVER/MAIN.LUA
QBDiving.CoralTypes = {
    [1] = {
        item = "dendrogyra_coral",
        maxAmount = math.random(1, 5),
        price = math.random(70, 100),
    },
    [2] = {
        item = "antipatharia_coral",
        maxAmount = math.random(2, 7),
        price = math.random(50, 70),
    }
}

QBDiving.SellLocations = {
    [1] = {
    ["coords"] = {
        -- ["x"] = -1684.13,
        -- ["y"] = -1068.91,
        -- ["z"] = 13.15
        x = 691.49,
        y = 1.98,
        z = 5.81,

    }
}
}

-- [1] = {
--     ["coords"] = {
--         ["x"] = -1686.9,
--         ["y"] = -1072.23,
--         ["z"] = 13.15
--     }
-- }

--232.5, y = 368.7, z = 105.94
