# Snake-game
Classic Nokia mobile Snake game recreated using HTML, CSS and Javascript. Used div based grid system to render game board. 

## Features
- Game can be started using start button
- Game ends if snake hits the boundary of board or run over itself.
- Play or pause the game in between
- Dynamic score & level calc after snake eats food. Speed up after each level up.
- Directions of snake can be changed with arrow keys on keyboard
- Colors of snake and food can easily be changed

## Implementation
- Used Singleton design pattern as there will be single instance of game, board and snake
- gameBoard initialized only once 
- game can be started using start button, after which only game state can be change from pause to play and vice versa
- For each step check if snake going out of the boundary or running over itself
- if above conditions are not true then only snake moves forward
- if next step of snake contains food then increase snake's length and re-calculate scores & level.
- After above step create new food point randomly. Make sure it falls into game boundary and not in snake's current path.

## To-dos
- Refactor code for finding new foodpoint.
- Check if all the points on board are taken by snake and then end game. 
