![Name Changer banner](https://image.noelshack.com/fichiers/2017/45/6/1510397731-banner.png)
# gName-Changer
An essential addon for your **[DarkRP](http://darkrp.com/)** server !

## Informations
> This addon don't come with any warrantly. It's a completly free addon.
>
> **If you find a bug, you can report it in the "Issues" section of this repositery**

This is a simple addon that allow to your players to go to the tawn hall to make a request for a name change. It comes with an Admin panel and few admins commands to make your administration easier.

[![](https://img.youtube.com/vi/MT9mKqKGYrE/0.jpg)](http://www.youtube.com/watch?v=MT9mKqKGYrE "Click to play on Youtube.com")

## Features
* **First spawn** name change request *[* **BETA** *]*
  * Configurable (*active* / *disable*)
  * **Nice** blurred overlay, with community name and description
* **Easy** setup
  * [**HOT**] **Save** the NPCs position! (command: `gname_save_all` [configurable])
  * A **complete** config file : change *colors*, *models* and *more* !
* A **nice UI**
  * **Clean**, **elegant** and **beautiful** dermas
  * **Smooth animations**
  * [**HOT**] *Responsive* panels ! (**fixed**!)
* **Facilitate your administration**
  * **Anti-spam** protection! (*configurable*)
  * **Protection against smarties** trying to use derma without going through the NPC.
  * [**HOT**] An incredible **blacklist system** to block unwanted names and **facilitate your administration**!
  * A **beautiful admin panel** to config the **blacklist system**
  * **Force** player to have a **proper** caligraphy (*configurable*)
  * **Force** player to change his RPName (command : `gname_force <steamid>`)
* **Fits** developers requirements, by allowing them to add things easily, and by having a *well-indented and commented* code
* **Works with the latest DarkRP version !**

## Planned features
* Add an option to force the player to change his identity when he dies
* When setting the ``globalNotify`` to ``false``, it would be great that the user himself can see a notification.
* Propose your ideas : https://github.com/Gabyfle/gName-Changer/issues (label : Feature Request)

## Screenshots
These screenshots have been taken with the default colors. All colors are changeable.

#### **First spawn name change request**

![overlay](https://steamuserimages-a.akamaihd.net/ugc/958593001512576323/DFA1A6FEB9883F59A98837A9251D3734CB68B7E5/)

#### **3D2D NPC's title** :

![3d2d](https://image.noelshack.com/fichiers/2018/34/2/1534853510-npc.jpg)


(animation : https://goo.gl/RVnMrq)

#### **Home frame** :

![frame](https://steamuserimages-a.akamaihd.net/ugc/956340815955395423/3749F5F2C95C0F778F3C0689B0ABB60E5EBAE568/)

#### **RPName changing frame** :

![Name](https://steamuserimages-a.akamaihd.net/ugc/956340815955396433/259ACFA39F410E64791B36287CA835B3131832B2/)

#### **Blacklist's Admin Panel** :

![Admin Panel](https://steamuserimages-a.akamaihd.net/ugc/956340815955397127/D53D3C3F14B02DE724F926E1522DC45355479C33/)

## Installation
The installation is pretty easy !

Just drap & drop the "*gname-changer*" folder to your "*addons*" folder in your own server.
It had to looks like :

![Looks like](https://image.noelshack.com/fichiers/2018/34/2/1534853151-addon.png)

## Developers
gNameChanger allows you to add some actions to his principal frame.
Here, a short example of how you can add new actions :

- First, you'll need to have a function that can be executed from an other addon :

```lua
function printHi()
  print("Hi")
end

hook.Add("gunlicencetesting", "testingthings", printHi)
```

- Then, you can easily add an action by doing something like this, in the `gNameChanger.actions` table (located in config file) :

```lua
    ["gunlicence"] = {
        buttonText = "I want to buy a gun license!",
        buttonColor = Color(51, 25, 86),
        action = function() 
            hook.Run("gunlicencetesting")
        end
    }
```
This will create a new button, and will rearrange the display of the frame : 

![New action button](https://steamuserimages-a.akamaihd.net/ugc/948475103688537646/8A07B55E04CC955B1856129DF8A5401751B2987B/)

## Configuration
You can easily config your addon, by modifiying the "*gname_changer_config.lua*".
To do this, just go to :
```bash
addons/gname-changer/lua/autorun/`
```

And open the file named : "*gname_changer_config.lua*" :kiss:
## Contact me
Do you need my services, help or anything else ? Contact me on :

* [Steam](https://steamcommunity.com/id/EpicGaby)
* [OpenClassrooms](https://openclassrooms.com/membres/gabrielsantamaria)
