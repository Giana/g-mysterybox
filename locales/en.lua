local Translations = {
    error = {
        already_opened = 'This mystery box has already been opened...',
        no_room = 'You don\'t have enough room for all the rewards!',
        money_type = 'Error awarding money type: %{type}',
        unauthorized = 'Unauthorized'
    },
    primary = {
        resetting = 'Resetting mystery box location...'
    },
    success_log = {
        previous_loaded = 'Previous mystery box successfully loaded from database',
        saved_box_database = 'New mystery box successfully saved to database',
        reset_command = '~~~~~~~~~~\nMystery box location reset via command\n\nName: %{name}\nLicense: %{license}\n~~~~~~~~~~',
        box_opened = '~~~~~~~~~~\nMystery box opened\n\nPlayer Name: %{name}\nLicense: %{license}\nCharacter: %{firstName} %{lastName} (%{citizenid})\nLoot Box: %{lootBoxName}\n~~~~~~~~~~',
        saved_opened_database = 'Opened mystery box successfully recorded in database'
    },
    error_log = {
        saving_no_match = 'Error saving mystery box spawn in config: No location match found in config for current mystery box in database\nGenerating new spawn...',
        saving_no_index_coords = 'Error saving mystery box spawn in config: No index or coords given',
        saving_spawn_not_set = 'Error saving mystery box to database: Spawn not set in config',
        insert_database = 'Error saving mystery box to database: Database insert unsuccessful',
        picking_not_enough = 'Error picking new random spawn: More than one location must exist in config\nPlease add more locations to avoid players farming rewards',
        insert_opened_database = 'Error recording opened mystery box in database: Database insert unsuccessful',
    },
    other = {
        opening_progress = 'Opening mystery box...',
        walkup_text = '~g~E~w~ - Open Mystery Box',
        target_label = 'Open Mystery Box',
        bot_name = 'Mystery Box Bot',
    }
}

Lang = Locale:new({
    phrases = Translations,
    warnOnMissing = true
})