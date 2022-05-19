#! /bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table --no-align --tuples-only -c"

ELEMENT_ATOMIC_NUMBER=''
ARGUMENT=$1

INFOS(){
  echo "$($PSQL "SELECT * FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id)\
  where atomic_number=$ELEMENT_ATOMIC_NUMBER;")"\
  | while IFS='|' read TYPE_ID ATOMIC_NUMBER SYMBOL NAME ATOMIC_MASS MELTING_POINT BOILING_POINT TYPE
    do
      echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
    done
}

GET_ATOMIC_NUMBER(){
  if [[ $ARGUMENT =~ ^[A-Z][a-z]?$ ]]
    then
      ELEMENT_ATOMIC_NUMBER="$($PSQL "SELECT atomic_number FROM elements WHERE symbol='$ARGUMENT'")"
    elif [[ $ARGUMENT =~ ^[A-Z][a-z]+$ ]]
      then
        ELEMENT_ATOMIC_NUMBER="$($PSQL "SELECT atomic_number FROM elements WHERE name='$ARGUMENT'")"
    elif [[ $ARGUMENT =~ ^[0-9][0-9]*$ ]]
      then
        ELEMENT_ATOMIC_NUMBER="$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number=$ARGUMENT")"
  fi
}

if [[ -z $1 ]] 
  then
    echo "Please provide an element as an argument."
  else
    GET_ATOMIC_NUMBER 
    if [[ -z $ELEMENT_ATOMIC_NUMBER ]]
      then 
        echo "I could not find that element in the database."
      else
        INFOS
    fi
fi
