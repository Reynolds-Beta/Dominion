# Dominions!
Source code to old Turbo Pascal BBS door game which was run from a WWIV BBS. 

## Sharing Dominions
[See the LICENSE.md file for sharing restrictions](LICENSE.md)

## Genre
This game is of the "4 X" genre: eXplore, eXpand, eXploit, and eXterminate. In this case, you control planetary populations which produce resources for you. Using those resources, you build fleets of ships to explore other planets, colonize, build more resources, and attack your neighbors.

Game play is turn-based. Each player logs on and makes their daily moves. At the end of a day, all moves are resolved according to the game logic and priorities then reported back to the users the next time they log in.

## Version 1.60 history
This version is the one I modified back in 1991 to add greater strategy and realism to the game - at the time I went by the user name "The Doctor" (after Dr. Who, of course). Remember, this is an old program meant to run under a WWIV BBS and DOS. Total memory used was about 110k RAM.

### Enhancements I added to make version 1.60
1. Planetary populations
2. Ship crew
3. Ability to move populations from planet to planet
4. Re-added scanners in the form of radars to see advancing fleets - this feature had been removed in an earlier version, though I'm not sure why.
5. More realistic positioning of fleets in real-space as they travelled. Interception of fleets before they entered range of a planet became possible
5. Warp gates!
6. Long-range warp missiles which could remotely bombard a planet!
7. Population could rebel if you work them too much, thus reducing resource output.
8. Re-worked fleet battle logic, initiative, and other.

## Future Plans
The intention is to recreate this as a modern web-based, massively multiplayer strategy game making use of Azure functionality for the backend API and logic (perhaps Azure Functions as REST calls or similar). Actual client design is to be determined, as I am not a great web designer/coder and my graphic/art skills are rudimentary at best.

Has this been done before? Sure. So what? I've wanted to recreate what I contributed to for a long time. While the concept won't be new, I'm hoping the actual game play will feel fresh enough.

### Potential future features
1. Users gain the ability to design their own ships based on the technology levels they have attained
2. Allow refit of existing ships to gain some of the benefits of higher technology levels
3. Massive number of planetary systems (1,000,000 or more) leading to a massive number of players
4. Non-player adversaries.
5. One-way and two-way warp paths between different planetary systems. Read about this concept in a a sci-fi book - might make an interesting strategic change.
6. Variety of technologies to research and use for resource production, ship design, and intelligence gathering.
7. Planetary environments. Some planets may be habitable, others may be generally worthless rocks but which are in strong strategic locations and thus desireable to hold onto.
