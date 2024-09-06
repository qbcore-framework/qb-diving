local Translations = {
    error = {
        ["canceled"] = "Abgebrochen",
        ["911_chatmessage"] = "911 NACHRICHT",
        ["take_off"] = "/divingsuit um deinen Taucheranzug auszuziehen",
        ["not_wearing"] = "Du trägst keinen Taucheranzug ..",
        ["no_coral"] = "Du hast keine Korallen zum Verkauf ..",
        ["not_standing_up"] = "Du musst stehen, um den Taucheranzug anzulegen",
        ["need_otube"] = "Du benötigst einen Sauerstoffschlauch, um deinen leeren Taucheranzug aufzufüllen",
        ["oxygenlevel"] = 'Der Ausrüstungsstand liegt bei %{oxygenlevel}, sollte 0% betragen'
    },
    success = {
        ["took_out"] = "Du hast deinen Neoprenanzug ausgezogen",
        ["tube_filled"] = "Der Schlauch wurde erfolgreich gefüllt"
    },
    info = {
        ["collecting_coral"] = "Korallen sammeln",
        ["diving_area"] = "Tauchgebiet",
        ["collect_coral"] = "Korallen sammeln",
        ["collect_coral_dt"] = "[E] - Korallen sammeln",
        ["checking_pockets"] = "Taschen durchsuchen, um Korallen zu verkaufen",
        ["sell_coral"] = "Korallen verkaufen",
        ["sell_coral_dt"] = "[E] - Korallen verkaufen",
        ["blip_text"] = "911 - Tauchplatz",
        ["put_suit"] = "Ziehe einen Taucheranzug an",
        ["pullout_suit"] = "Ziehe einen Taucheranzug heraus ..",
        ["cop_msg"] = "Diese Korallen könnten gestohlen sein",
        ["cop_title"] = "Illegales Tauchen",
        ["command_diving"] = "Ziehe deinen Taucheranzug aus",
    },
    warning = {
        ["oxygen_one_minute"] = "Du hast weniger als 1 Minute Luft übrig",
        ["oxygen_running_out"] = "Dein Taucheranzug geht die Luft aus",
    },
}

if GetConvar('qb_locale', 'en') == 'de' then
    Lang = Locale:new({
        phrases = Translations,
        warnOnMissing = true,
        fallbackLang = Lang,
    })
end
