include "globals.mzn";             % include all global constraint that you want to use      

%data
% Number of players playing poker
int: n_players;  

% Colors of the poker chips 
int: n_color_chips ::add_to_output; 

% Number of poker chips for each color from the lower value to the higher
% (e.g. white, blue, red, black, green)
array[1..n_color_chips] of int: n_chips;

% Minimum number of total poker chips that each player should have
int: min_tot_chips;

% Minimum number of poker chips for each color that each player should have
% from the lower value to the higher (e.g. white, blue, red, black, green)
array[1..n_color_chips] of int: min_n_chips;

% Maximum number of poker chips for each color that each player should have
% from the lower value to the higher (e.g. white, blue, red, black, green)
array[1..n_color_chips] of int: max_n_chips;

% Initial budget for each player to start the poker (euro)
int: budget;

% Decimal unit according to compute the division
int: unit ::add_to_output;



% variables
array[1..n_color_chips] of var 1..(max(n_chips) div n_players): n_chips_for_player ::add_to_output; % number of chips that each player should have for each color
array[1..n_color_chips] of var 1..unit*budget: value_chips_for_player ::add_to_output;              % value to assign to each color of chips

% domain constraints
constraint forall(i in 1..n_color_chips) 
                 (n_chips_for_player[i] >= min_n_chips[i]);       
constraint forall(i in 1..n_color_chips) 
                 (n_chips_for_player[i] <= (if max_n_chips[i] < (n_chips[i] div n_players) then max_n_chips[i] else (n_chips[i] div n_players) endif));

% consistency of values and n_chips constraint
constraint sum(i in 1..n_color_chips)
              (n_chips_for_player[i]*value_chips_for_player[i]) = unit*budget;
constraint sum(i in 1..n_color_chips)
              (n_chips_for_player[i]) >= min_tot_chips;
constraint alldifferent(value_chips_for_player);

% order constraints
constraint forall(i,j in 1..n_color_chips where i<j) (value_chips_for_player[i] < value_chips_for_player[j]);  
constraint forall(i,j in 1..n_color_chips where i<j) (n_chips_for_player[i] >= n_chips_for_player[j]);  


% try to get as much values as possible that are mupliple of 10/5 cents
var int: n_rounded_values = sum(i in 1..n_color_chips)
                               (if (value_chips_for_player[i] mod 10) == 0 then 2
                                                                           else (if (value_chips_for_player[i] mod 5) == 0 then 1 else 0 endif) endif );
solve maximize n_rounded_values;

output ["N chips: "++show(n_chips_for_player)]
       ++
       ["\nValue chips: " ++show(value_chips_for_player)];