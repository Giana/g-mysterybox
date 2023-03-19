# G-MysteryBox

G-MysteryBox is a script for FiveM QBCore for configuring a mystery box to be found and opened for rewards.

<h1>INSTALLATION GUIDE</h1>

1. Drop the g-mysterybox folder into your [standalone] folder (or whichever other ensured folder you want to use)
2. Execute the query from g-mysterybox.sql in your server's database
3. Use "add_ace" in your server.cfg to give desired access to the command
    - Ex: add_ace group.admin "mysterybox" allow
    - Ex. add_ace identifier.steam:xxxxxxxxxxxxxxx "mysterybox" allow
    - For more info: https://forum.cfx.re/t/basic-aces-principals-overview-guide/90917

<h1>FEATURES</h1>

- Configure multiple locations a mystery box can spawn at
    - Mystery box location determined at server start
        - Can choose to spawn at the previous spawn location or new "random" location
    - Use /resetmysterybox command to reset mystery box location whenever without restarting server
- Configure whether a mystery box respawns in a new location after being found, or waits for restart
- Change the mystery box model
- Configure target or walk up to get rewards
- Configure multiple possible rewards box contents
    - Specify money rewards and item rewards (and their amounts) for each reward box
    - One reward box is picked randomly when mystery box is opened
- Record history of found/opened mystery boxes in database
- Enable/disable server console logging and/or webhook logging

**IMAGES**
-----
![Mystery Box](https://i.ibb.co/Czntrt9/mysterybox.png)
![Mystery Box Target](https://i.ibb.co/JRst8Ls/mysteryboxtarget.png)
![Mystery Box Rewards](https://i.ibb.co/RhV4TWh/mysteryboxrewards.png)

**DEPENDENCIES**
-----
- [oxmysql](https://github.com/overextended/oxmysql)
- [QBCore](https://github.com/qbcore-framework)
    - [qb-core](https://github.com/qbcore-framework/qb-core)
    - [qb-inventory](https://github.com/qbcore-framework/qb-inventory)
    - [qb-target](https://github.com/qbcore-framework/qb-target)
