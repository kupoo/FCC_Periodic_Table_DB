#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"


if [[ ! $1 ]]
then
  echo Please provide an element as an argument.
else
  #query database for argument matching element information
  ATOMIC_NUMBER=$($PSQL "select atomic_number from elements 
                          full join properties using(atomic_number)
                          where (atomic_number::text = '$1' or name ILIKE '$1' or symbol ILIKE '$1');")  
  #if atomic number not found
  if [[ -z $ATOMIC_NUMBER ]]
  then
    echo I could not find that element in the database.
    exit
  fi
  #query database to obtain all element information
  ELEMENT_PROPERTIES=$($PSQL "select name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius
                              from elements full join properties using(atomic_number)
                              full join types using(type_id)
                              where atomic_number=$ATOMIC_NUMBER;")
  
  
  echo $ELEMENT_PROPERTIES | while IFS='|' read NAME SYMBOL TYPE ATOMIC_MASS MELTING_POINT BOILING_POINT
  do
    #display properly formatted information
    echo -e "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
  done  
fi
