# DinoGameASM
`chrome://dino`, remade in Assembly

Original source code, iamges, and sounds can be found [here](https://source.chromium.org/chromium/chromium/src/+/main:components/neterror/).

Graphics are stored in three series of arrays:

- Terrain - These arrays can be rotated, so that the terrain goes an infinite loop but still has the appearance of moving.
- Obstacles - These arrays can be populated with data and then shifted on each game tick, to give the appearance of movement. Whenever the obstacles are shifted left toward the dino, so are the coordinates of the collision regions.
- Dino - These arrays would be less wide, only covering the max width of any one dino sprite. This would be completely overwritten in a cycle (or perhaps we just maintain a set of arrays for each dino sprite, and then choose which set of arrays we draw on the screen for each frame/game tick).

For each frame/game tick (haven't decided yet), we (1) clear screen, (2) write terrian arrays on to screen, (2) write obstacles on to screen, and (3) write dino on to screen.

We can increase game speed by increasing the # of ticks/second.

Score is milliseconds elapsed / 10

## Contest 2 Features

- Gets faster as time goes on
- Live on-screen score counter
- Pterodactyls
- Ability to duck
- Ability to restart game in same console window
- Multiple sizes of objects
