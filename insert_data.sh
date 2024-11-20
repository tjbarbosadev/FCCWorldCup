#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE games, teams")
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $YEAR != year ]]
  then
    # get teams id
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")

    if [[ -z $WINNER_ID ]]
    then
      # insert team
      INSERT_WINNER_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
      if [[ $INSERT_WINNER_RESULT == "INSERT 0 1" ]]
      then
        echo "Inserted into teams, $WINNER"
      fi
      # get new team_id
      WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    fi

    if [[ -z $OPPONENT_ID ]]
    then
      # insert team
      INSERT_WINNER_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
      if [[ $INSERT_WINNER_RESULT == "INSERT 0 1" ]]
      then
        echo "Inserted into teams, $OPPONENT"
      fi
      # get new team_id
      OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    fi

    # insert games
    INSERT_GAME_STATS=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES('$YEAR', '$ROUND', '$WINNER_ID', '$OPPONENT_ID', '$WINNER_GOALS', '$OPPONENT_GOALS')")
    echo $INSERT_GAME_STATS
    
  fi
done
