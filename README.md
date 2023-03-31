# Tic Tac Toe

This application is using flutter:

## Features:

- playing tic tac toe with solo ( does not have bot to play with yet )
- board size default is 10 x 10, can be customize to 100 x 100

## Logic Board:

### Initalize

- create board with 2 deminsonal array or list of list according board size ( default 10 x 10 ) filled with integer = 0
- when item = 0, empty box
- when item = 1, it belongs to "X"
- when item = 2, it belongs to "O"

### Validation
- the validation is being check at every new item input
- double loop through the board n = (board size) 
- check in 4 pattern: (ex: n = 6)
  - horizontal ( x line )
    - ex: [0,0] > [0,1] > [0,2] > [0,3] > [0,4] > [0,5]
    - ex: [1,0] > [1,1] > [1,2] > [1,3] > [1,4] > [1,5]
    - ...
  - vertical ( y line )
    - ex: [0,0] > [1,0] > [2,0] > [3,0] > [4,0] > [5,0]
    - ex: [0,1] > [1,1] > [2,1] > [3,1] > [4,1] > [5,1]
  - cross from top left to bottom right
    - is being divide to to 2 process
      - start from x = 0 -> x = n - 1
        - ex: [0,0] > [1,1] > [2,2] > [3,3] > [4,4] > [5,5]
        - ex: [1,0] > [2,1] > [3,2] > [4,3] > [5,4]
        - ex: [2,0] > [3,1] > [4,2] > [5,3]
        - ...
      - start from y = 0 -> y = n - 1
        - ex: [0,0] > [1,1] > [2,2] > [3,3] > [4,4] > [5,5] (skip this since it check above)
        - ex: [0,1] > [1,2] > [2,3] > [3,4] > [4,5]
        - ex: [0,2] > [1,3] > [2,4] > [3,5]
        - ...
  - cross from top right to bottom left
    - is being divide to to 2 process
      - start from x = n - 1 -> x = 0
        - ex: [5,0] > [4,1] > [3,2] > [2,3] > [1,4] > [0,5]
        - ex: [4,0] > [3,1] > [2,2] > [1,3] > [0,4]
        - ex: [3,0] > [2,1] > [1,2] > [0,3]
        - ...
      - start from y = 0 -> y = n
        - ex: [5,0] > [4,1] > [3,2] > [2,3] > [1,4] > [0,5] (skip this since it check above)
        - ex: [5,1] > [4,2] > [3,3] > [2,4] > [1,5]
        - ex: [5,2] > [4,3] > [3,4] > [2,5]
        - ...
- during pattern checking, if any item number is being duplicated straight after each other 5 time, then those items is winning tiles
- only item number 1 or 2 is counted. 0 mean empty so we don't consider it as winning

## How to run:

- install flutter: https://docs.flutter.dev/get-started/install
- set up editor to write, run or debug: https://docs.flutter.dev/get-started/editor?tab=vscode


## Deployment:

- https://docs.flutter.dev/deployment/android ( can check ios in same website )
