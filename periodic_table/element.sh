#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

# Si no se proporciona ningún argumento
if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
  exit
fi

# Determinar si el argumento es un número, símbolo o nombre
if [[ $1 =~ ^[0-9]+$ ]]
then
  CONDITION="e.atomic_number = $1"
else
  CONDITION="e.symbol = '$1' OR e.name = '$1'"
fi

# Consultar la información del elemento uniendo las tablas
ELEMENT_INFO=$($PSQL "SELECT e.atomic_number, e.name, e.symbol, t.type, p.atomic_mass::real, p.melting_point_celsius, p.boiling_point_celsius 
FROM elements e 
JOIN properties p ON e.atomic_number = p.atomic_number 
JOIN types t ON p.type_id = t.type_id 
WHERE $CONDITION;")

# Si no se encuentra el elemento
if [[ -z $ELEMENT_INFO ]]
then
  echo "I could not find that element in the database."
else
  # Leer el resultado separado por barras verticales (|)
  echo "$ELEMENT_INFO" | while IFS="|" read ATOMIC_NUMBER NAME SYMBOL TYPE MASS MELTING BOILING
  do
    echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
  done
fi
# update 1
# update 2
# update 3
# update 4
