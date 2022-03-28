local Translations = {
    error = {
        ["canceled"] = "Canceled",
        ["911_chatmessage"] = "911 MESSAGE",
        ["take_off"] = "/divingsuit to take off your diving suit",
        ["not_wearing"] = "You are not wearing a diving gear ..",
        ["no_coral"] = "You don't have any coral to sell..",
    },
    success = {
        ["took_out"] = "You took your wetsuit off",
    },
    info = {
        ["collecting_coral"] = "Collecting coral",
        ["diving_area"] = "Diving Area",
        ["collect_coral"] = "Collect coral",
        ["collect_coral_dt"] = "[E] - Collect Coral",
        ["checking_pockets"] = "Checking Pockets To Sell Coral",
        ["sell_coral"] = "Sell Coral",
        ["sell_coral_dt"] = "[E] - Sell Coral",
        ["blip_text"] = "911 - Dive Site",
        ["put_suit"] = "Put on a diving suit",
        ["pullout_suit"] = "Pull out a diving suit ..",
        ["cop_msg"] = "This coral may be stolen",
        ["cop_title"] = "Illegal diving",
        ["command_diving"] = "Take off your diving suit",
    },
    warning = {},
}
Lang = Locale:new({
    phrases = Translations,
    warnOnMissing = true
})