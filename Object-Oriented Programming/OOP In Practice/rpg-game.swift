/*
 =========================================
 Challenge: RPG Game
 =========================================

 We need a simple RPG game where players can create
 characters, equip weapons, and fight enemies.

 There are two types of characters: warriors and mages.
 Both share common stats like health and attack power,
 but each fights differently.

 A warrior uses a weapon to deal damage. the weapon has
 a name and a damage value, and it's passed into the
 character from outside, not created inside the character.

 A mage casts spells instead of using a weapon. a mage
 has a list of spells, each spell has a name and a
 mana cost. the mage has a mana pool that decreases
 when a spell is cast and should reject casting if
 there isn't enough mana.

 Both character types have an abstract method attack()
 that returns a String describing what they did.
 the base class should enforce this using fatalError().

 Health must be protected. it can only be changed through
 takeDamage() which should reject negative values and
 never let health drop below zero.

 The game keeps a list of all characters and can make
 each one attack. when listing, it should be clear
 whether each character is a warrior or a mage.

 =========================================
 */
