#include "main.h"

#include <string.h>
#include <stdio.h>
#include <stdlib.h>

#include "gba.h"
#include "images/item.h"
#include "images/monster.h"
#include "images/start.h"


enum gba_state {
  BEGIN,
  NAME,
  START,
  PLAY,
  WIN,
  LOSE,
};

int main(void) {
  // Manipulate REG_DISPCNT here to set Mode 3. //
  REG_DISPCNT = MODE3 | BG2_ENABLE; 

  // Save current and previous state of button input.
  u32 previousButtons = BUTTONS;
  u32 currentButtons = BUTTONS;

  // Load initial application state
  enum gba_state state = BEGIN;

  // Initialize player position and score
  p1.playerRow = 5;
  p1.playerCol = 5;
  int score = 0;
  char name[10];
  char totalScore[20];

  while (1) {
    currentButtons = BUTTONS; // Load the current state of the buttons

    // Manipulate the state machine below as needed //
    // NOTE: Call waitForVBlank() before you draw
    waitForVBlank();

    switch (state) {
      case BEGIN:
        // background image
        drawFullScreenImageDMA(start);
        drawCenteredString(HEIGHT, WIDTH, -100, -50, "PRESS", WHITE);
        if (KEY_JUST_PRESSED(BUTTON_START, currentButtons, previousButtons)) {
          drawRectDMA(0, 0, 240, 160, BLACK);
          state = NAME;
        }
        break;

      case NAME: 
        // name choosing 
        drawCenteredString(HEIGHT/2, WIDTH/2, 0, 0, "Choose Your Name!", WHITE);
        drawCenteredString(HEIGHT/2, WIDTH/2, 0, 50, "JULIE(UP) | STAT(DOWN)", WHITE);
        drawCenteredString(HEIGHT/2, WIDTH/2, 0, 100, "DAVE(RIGHT) | CATHY(LEFT)", WHITE);

        if (KEY_JUST_PRESSED(BUTTON_UP, currentButtons, previousButtons)) {
          strcpy(name, "JULIE");
          state = START;
        } else if (KEY_JUST_PRESSED(BUTTON_DOWN, currentButtons, previousButtons)) {
          strcpy(name, "STAN");
          state = START;
        } else if(KEY_JUST_PRESSED(BUTTON_RIGHT, currentButtons, previousButtons)) {
          strcpy(name, "DAVE");
          state = START;
        } else if (KEY_JUST_PRESSED(BUTTON_LEFT, currentButtons, previousButtons)) {
          strcpy(name, "CATHY");
          state = START;
        }
        break;
      
      case START:
        //animation when the name is selected
        drawRectDMA(p1.playerRow, p1.playerCol, 5, 5, WHITE);
        p1.playerCol ++;
        
        drawCenteredString(HEIGHT/2, WIDTH/2, 0, -50, "PRESS ENTER TO START!", WHITE);

        if (KEY_JUST_PRESSED(BUTTON_START, currentButtons, previousButtons)) {
          state = PLAY;
          p1.playerCol = 5;
          p1.playerRow = 80;
        }
        break;

      case PLAY:
        // background
        drawRectDMA(0, 0, 240, 160, CYAN);
        
        int exitRow = 150;
        int exitCol = 230;
        drawRectDMA(exitRow, exitCol, 7, 7, RED);
        
        drawRectDMA(p1.playerRow, p1.playerCol, 5, 5, BLUE);
        drawString(150, 5, name, WHITE); // Draw the name on the screen
        
        // Update player position based on button input
        if (currentButtons & BUTTON_UP && p1.playerRow > 0) {
          p1.playerRow++;
        }
        if (currentButtons & BUTTON_DOWN && p1.playerRow < HEIGHT - 5) {
          p1.playerRow--;
        }
        if (currentButtons & BUTTON_LEFT && p1.playerCol > 0) {
          p1.playerCol++;
        }
        if (currentButtons & BUTTON_RIGHT && p1.playerCol < WIDTH - 5) {
          p1.playerCol--;
        }

        // Draw the monsters
        int monster2Row = 80;
        int monster2Col = 30;

        int monster3Row = 70;
        int monster3Col = 200;

        int monster4Row = 120;
        int monster4Col = 180;

        drawImageDMA(monster2Row, monster2Col, 10, 10, monster);
        drawImageDMA(monster3Row, monster3Col, 10, 10, monster);
        drawImageDMA(monster4Row, monster4Col, 10, 10, monster);

        // Check for collision with monsters
        if (p1.playerRow + 7 > monster2Row && p1.playerRow < monster2Row + MONSTER_HEIGHT
            && p1.playerCol + 7 > monster2Col && p1.playerCol < monster2Col + MONSTER_WIDTH) {
          score-=1;
          drawRectDMA(monster2Row, monster2Col, MONSTER_WIDTH, MONSTER_HEIGHT, RED);
        }
        if (p1.playerRow + 7 > monster3Row && p1.playerRow < monster3Row + MONSTER_HEIGHT
            && p1.playerCol + 7 > monster3Col && p1.playerCol < monster3Col + MONSTER_WIDTH) {
          score-=1;
          drawRectDMA(monster3Row, monster3Col, MONSTER_WIDTH, MONSTER_HEIGHT, RED);

        }
        if (p1.playerRow + 7 > monster4Row && p1.playerRow < monster4Row + MONSTER_HEIGHT
            && p1.playerCol + 7 > monster4Col && p1.playerCol < monster4Col + MONSTER_WIDTH) {
          score-=1;
          drawRectDMA(monster4Row, monster4Col, MONSTER_WIDTH, MONSTER_HEIGHT, RED);
        }

        // Draw the items
        int item1Row = 70;
        int item1Col = 140;

        int item2Row = 75;
        int item2Col = 80;

        int item3Row = 130;
        int item3Col = 100;

        drawImageDMA(item1Row, item1Col, 10, 10, item);
        drawImageDMA(item2Row, item2Col, 10, 10, item);
        drawImageDMA(item3Row, item3Col, 10, 10, item);

        // Check for collision with items
        if (p1.playerRow + 7 > item1Row && p1.playerRow < item1Row + ITEM_HEIGHT
            && p1.playerCol + 7 > item1Col && p1.playerCol < item1Col + ITEM_WIDTH) {
          score+=1;
          drawRectDMA(item1Row, item1Col, ITEM_WIDTH, ITEM_HEIGHT, GREEN);
        }
        if (p1.playerRow + 7 > item2Row && p1.playerRow < item2Row + ITEM_HEIGHT
            && p1.playerCol + 7 > item2Col && p1.playerCol < item2Col + ITEM_WIDTH) {
            score+=1;
            drawRectDMA(item2Row, item2Col, ITEM_WIDTH, ITEM_HEIGHT, GREEN);
        }
        if (p1.playerRow + 7 > item3Row && p1.playerRow < item3Row + ITEM_HEIGHT
            && p1.playerCol + 7 > item3Col && p1.playerCol < item3Col + ITEM_WIDTH) {
          score+=1;
          drawRectDMA(item3Row, item3Col, ITEM_WIDTH, ITEM_HEIGHT, GREEN);
        }

        // show score
        drawString(5, 5, "Score: ", WHITE);   
        sprintf(totalScore, "Score: %d", score);
        drawString(5,5, totalScore, WHITE);

        // // Check if the player has won or lost
        if (p1.playerRow + 7 > exitRow && p1.playerRow < exitRow + 7
            && p1.playerCol + 7 > exitCol && p1.playerCol < exitCol + 7) {
          if (score > 0) {
            state = WIN;
          } else {
            state = LOSE;
          }
        }
        break;
  
      case WIN:
        // Display win screen
        drawCenteredString(HEIGHT/2, WIDTH/2, 0, -100, "You Won!", BLACK);
        sprintf(totalScore, "Final Score: %d", score);
        drawCenteredString(HEIGHT/2, WIDTH/2, 0, -50, totalScore, BLACK);
        drawCenteredString(HEIGHT/2, WIDTH/2, 0, 25, "Press SELECT to play again", BLACK);
        if (KEY_JUST_PRESSED(BUTTON_SELECT, currentButtons, previousButtons)) {            
          drawRectDMA(0, 0, 240, 160, BLACK);
          state = BEGIN;
          score = 0;
          p1.playerCol = 0;
          p1.playerRow = 0;
        }
        break;

      case LOSE:
        // Display lose screen
        drawCenteredString(HEIGHT/2, WIDTH/2, 0, -100, "You Lost!", BLACK);
        sprintf(totalScore, "Final Score: %d", score);
        drawCenteredString(HEIGHT/2, WIDTH/2, 0,-50, totalScore, BLACK);
        drawCenteredString(HEIGHT/2 + 20, WIDTH/2, 0, 25, "Press SELECT to play again", BLACK);
        if (KEY_JUST_PRESSED(BUTTON_SELECT, currentButtons, previousButtons)) {
          drawRectDMA(0, 0, 240, 160, BLACK);
          state = BEGIN;
          score = 0;
          p1.playerCol = 0;
          p1.playerRow = 0;
        }
        break;
    }
    previousButtons = currentButtons; // Store the current state of the buttons
  }
  UNUSED(previousButtons);
  return 0;
  
}

